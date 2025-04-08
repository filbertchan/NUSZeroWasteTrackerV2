import mysql.connector
import csv

# Connect to the database
connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='ZeroWaste',
    database='ocr'
)

cursor = connection.cursor()

# Fetch image data
cursor.execute("SELECT * FROM extraction ORDER BY collectionTime ASC")

# Write to CSV file
with open("extraction_data.csv", "w", newline="") as file:
    writer = csv.writer(file)
    
    # Write header
    column_names = [desc[0] for desc in cursor.description]
    writer.writerow(column_names)
    
    # Write rows
    writer.writerows(cursor.fetchall())

cursor.close()
connection.close()
