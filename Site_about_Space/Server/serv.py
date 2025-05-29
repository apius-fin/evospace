import socket
import logging
import os
import mimetypes
from views import *

# Setting up logging
logging.basicConfig(level=logging.INFO)

# Folder for static files
STATIC_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'Static')

# Dictionary that maps URLs to corresponding handler functions
URLS = {
    '/': index,  # Main page
}

# Function to parse the HTTP request
def parse_request(request):
    parsed = request.split(' ')  # Split the request string by spaces

    if len(parsed) < 2:
        raise ValueError("Invalid request format")

    method = parsed[0]  # HTTP method (e.g., GET)
    url = parsed[1]  # URL (e.g., /)
    return method, url

# Function to serve static files
def serve_static_file(url):
    # Remove the "/Static" prefix from the URL
    if url.startswith('/Static'):
        url = url[7:]  # Remove '/Static' from the beginning of the path

    # Build the absolute file path relative to the project's root
    file_path = os.path.join(STATIC_DIR, url.lstrip('/'))

    logging.info(f"Requesting static file from: {file_path}")

    # Check if the file exists
    if os.path.exists(file_path):
        mime_type, _ = mimetypes.guess_type(file_path)
        if not mime_type:
            mime_type = 'application/octet-stream'

        with open(file_path, 'rb') as f:
            content = f.read()

        logging.info(f"Serving static file: {file_path} with MIME type: {mime_type}")
        return content, mime_type
    else:
        logging.warning(f"File not found: {file_path}\n")
        # Return empty content if the file is not found
        return b'', 'application/octet-stream'

# Function to generate response headers
def generate_headers(method, url):
    if method != 'GET':
        return 'HTTP/1.1 405 Method Not Allowed\n\n', 405

    # Handle static file request
    if url.startswith('/Static'):
        content, mime_type = serve_static_file(url)
        return f'HTTP/1.1 200 OK\nContent-Type: {mime_type}\n\n', content

    # If URL is not found in the dictionary, treat it as a dynamic page
    if url in URLS:
        # For the main page, return HTML
        return 'HTTP/1.1 200 OK\nContent-Type: text/html\n\n', URLS[url]()

    # If the page is not found
    return 'HTTP/1.1 404 Not Found\n\n', 404

# Function to generate the body content of the response
def generate_content(code, url):
    if code == 404:
        return '<h1>404 Not Found</h1><p>Page not found</p>'
    if code == 405:
        return '<h1>405 Method Not Allowed</h1><p>Only GET method is allowed</p>'
    return URLS[url]()

# Function to generate the complete HTTP response
def generate_response(request):
    try:
        method, url = parse_request(request)
    except ValueError:
        logging.error("Invalid request format")
        return 'HTTP/1.1 400 Bad Request\n\n'.encode()

    header, content = generate_headers(method, url)

    # If it's not a static file and content is a string
    if isinstance(content, str):
        body = generate_content(content, url)
        return (header + body).encode()

    # If content is a byte object (static file)
    if isinstance(content, int):
        body = generate_content(content, url)
        return (header + body).encode()

    # Return the headers and content
    return header.encode() + content

# Function to run the HTTP server
def run():
    # Create a server socket using IPv4 and TCP
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # Allow address reuse
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    # Bind the server to localhost and port 5000
    server_socket.bind(('localhost', 5000))
    # Start listening for incoming connections
    server_socket.listen()

    try:
        while True:
            client_socket, addr = server_socket.accept()
            request = client_socket.recv(1024)

            # Log the request
            logging.info(f"Request from {addr}: {request.decode('utf-8')}")

            # Generate the response
            response = generate_response(request.decode('utf-8'))

            # Send the response
            client_socket.sendall(response)
            client_socket.close()

    except KeyboardInterrupt:
        logging.info("Server stopped by user.")

    finally:
        server_socket.close()
        logging.info("Server socket closed.")

# Main entry point of the program, which starts the server
if __name__ == '__main__':
    run()