from flask import Flask, request, jsonify
from paddleocr import PaddleOCR
import cv2
import numpy as np
import io
import logging
from perspective_transform import ImageProcessor
from PIL import Image
import scipy.misc
import matplotlib.image

# Configure logging
logging.basicConfig(level=logging.DEBUG,  # Set to logging.INFO for less verbosity
                    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

app = Flask(__name__)
app.logger.setLevel(logging.DEBUG)

ocr = PaddleOCR(use_angle_cls=True, recogn_type='number')

# Function for OCR processing
def paddle_ocr(image):
    unskew_image = False
    if unskew_image:
        image = ImageProcessor(image)
        image = ImageProcessor.unskew(image)
    else:
        height, width, _ = image.shape
        if height > width:
            image = image[35*height//90 : 55*height//90 , width//10:9*width//10]
        else:
            image = image[height//3 : 2*height//3 , 2*width//10 : 8*width//10]
    #cv2.imwrite('output_image.png', image)

    try:
        height, width, _ = image.shape
    except Exception as e:
        logger.error(f"Error in image shape extraction: {e}")
        return None

    cropped = image[height//2:, 3*(width//4):]
    #cv2.imwrite('cropped.png', cropped)
    #logger.debug(f"Cropped image shape: {cropped.shape}")

    cropped = cv2.bilateralFilter(cropped, 9, 75, 75)

    logger.debug("Performing OCR...")
    reader = ocr.ocr(cropped)

    if reader[0]:
        # Log the raw OCR result
        #logger.debug(f"Raw OCR result: {reader}")

        for line in reader:
            for word_info in line:
                reading, confidence = word_info[1]
                logger.debug(f"OCR reading: {reading}, Confidence: {confidence}")
                try:
                    reading = int(reading)
                    if confidence >= 0.5:
                        return [reading]
                except ValueError:
                    logger.error(f"Cannot convert '{reading}' to integer")
                    return None

    logger.info("No text detected by OCR")
    return None
