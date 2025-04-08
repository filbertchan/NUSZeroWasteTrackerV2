import mysql.connector

# Connect to the database
connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='ZeroWaste',
    database='ocr'
)

cursor = connection.cursor()

# Fetch image data
cursor.execute("SELECT * FROM extraction ORDER BY collectionTime DESC")
image_data = cursor.fetchone()[0]
# Write to file
# idk how u wna post to ur frontend

cursor.close()
connection.close()