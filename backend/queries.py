###########################################
#### DO NOT REMOVE THE FUNCTIONS BELOW ####
###########################################

import json
import os
from flask import Flask, request, render_template, redirect, url_for, jsonify
import base64
import numpy as np
from number_recognition_model import paddle_ocr
from paddleocr import PaddleOCR
import cv2
from perspective_transform import ImageProcessor
import mysql.connector
from mysql.connector import Error
from datetime import datetime, timedelta

# Create Flask application
app = Flask(__name__)
app.config['CORS_HEADERS'] = 'Content-Type'

# Configure your MySQL connection
def get_db_connection():
    connection = mysql.connector.connect(
        host='localhost',
        user='root',
        password='ZeroWaste',
        database='ocr'
    )
    return connection


# Route to perform number extraction from image
@app.route('/number_extraction', methods=['POST'])
def detect_digit():
    if 'image' not in request.files:
        return jsonify({"error": "No image uploaded"}), 400

    image_file = request.files['image']
    image = np.array(bytearray(image_file.read()), dtype=np.uint8)
    image = cv2.imdecode(image, cv2.IMREAD_COLOR)

    result = paddle_ocr(image)
    if result:
        print(f"Detected result: {result}")  # Debug log
        return jsonify(result)
    else:
        print("No valid result found")  # Debug log
        return jsonify({"error": "No valid result found"}), 500

@app.route('/insertData', methods=['POST'])
def insertData():
    try:
        # Get the JSON data from the request
        current_datetime = datetime.utcnow() + timedelta(hours=8)
        formatted_datetime = current_datetime.strftime("%Y-%m-%d %H:%M:%S")
        data = request.get_json()

        bin_center_name = data.get('binCenterName')
        extracted_weight = data.get('extractedWeight')
        manual_weight = data.get('manualWeight')
        collection_time = formatted_datetime  # No need to convert it to string again
        image_data = data.get('imageData', None)  # Retrieve the image data

        # Validate the required fields
        if not bin_center_name or not extracted_weight:
            return jsonify({"error": "binCenterName, extractedWeight and manualWeight are required"}), 400

        # Establish a database connection
        connection = get_db_connection()
        cursor = connection.cursor()

        # Insert the data into the extraction table
        insert_query = """
            INSERT INTO ocr.extraction 
            (binCenterName, extractedWeight, manualWeight, collectionTime) 
            VALUES (%s, %s, %s, %s)
        """
        cursor.execute(insert_query, (
            bin_center_name, extracted_weight, manual_weight, collection_time
        ))

        # Commit the transaction for the extraction table
        connection.commit()

        # If image data is provided, insert it into the images table
        if image_data:
            try:
                # Validate and decode the base64 image data
                image_binary = base64.b64decode(image_data)
            except (ValueError, TypeError) as e:
                return jsonify({"error": "Invalid image data"}), 400

            # Insert the image into the images table
            insert_image_query = """
                INSERT INTO ocr.images (collectionTime, binCenterName, imageData)
                VALUES (%s, %s, %s)
            """
            cursor.execute(insert_image_query, (collection_time, bin_center_name, image_binary))
            connection.commit()  # Commit the transaction for the images table

        return jsonify({"message": "Data inserted successfully"}), 201

    except Error as e:
        print(f"Error inserting data into MySQL: {e}")
        return jsonify({"error": "Database error occurred"}), 500

    finally:
        if 'cursor' in locals() and cursor:
            cursor.close()
        if 'connection' in locals() and connection.is_connected():
            connection.close()

if __name__ == "__main__":
    app.run(host='0.0.0.0', port="8501", debug=True)
