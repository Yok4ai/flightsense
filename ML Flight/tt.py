import os

# Print the current working directory
print("Current Working Directory:", os.getcwd())

# List all files in the current directory
print("Files in the Current Directory:", os.listdir())

# Try to open the file explicitly
try:
    with open('model.pkl', 'rb') as file:
        print("File opened successfully!")
except FileNotFoundError:
    print("File not found.")
