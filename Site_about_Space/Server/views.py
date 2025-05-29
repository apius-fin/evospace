import os

# Function to return the content of the main page
# Reads the 'index.html' file and returns its content
def index():
    try:
        # Get the path to the 'index.html' file, starting from the current directory
        template_path = os.path.join(os.path.dirname(__file__), '..', 'index.html')

        # Open the file and return its content
        with open(template_path) as template:
            return template.read()
    except FileNotFoundError:
        return '<h1>500 Internal Server Error</h1><p>Template not found.</p>'