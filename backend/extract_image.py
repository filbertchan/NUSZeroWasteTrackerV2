import mysql.connector
import os

# Connect to the database
connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='ZeroWaste',
    database='ocr'
)

cursor = connection.cursor()

# Fetch all image data
cursor.execute("SELECT collectionTime, imageData FROM images ORDER BY collectionTime ASC")

# Ensure the 'images' directory exists
os.makedirs("images", exist_ok=True)

# Write each image to a file
for i, (collectionTime, image_data) in enumerate(cursor.fetchall()):
    with open(f'images/{i}_{collectionTime}.png', 'wb') as file:
        file.write(image_data)

cursor.close()
connection.close()
