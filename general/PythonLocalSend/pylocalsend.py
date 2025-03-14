import requests
import json
import sys
import os
import uuid
import ssl
import hashlib

# Ensure the correct number of arguments
if len(sys.argv) < 3:
    print("Usage: python script.py <server_address> <file_path>")
    sys.exit(1)

print("\n")

file_path = sys.argv[2]  # First argument: File path
server_address = sys.argv[1]  # Second argument: Server address (e.g., localhost)

file_name = os.path.basename(file_path)

# Generate a random UUID for the file
random_uuid = str(uuid.uuid4())

# Prepare the request payload for "prepare-upload"
data = {
    "info": {
        "alias": "Good Lemon",
        "version": "2.1",
        "deviceModel": "Samsung",
        "deviceType": "desktop",
        "fingerprint": "F0848F3137763E0F3FE782C87F1CC1205C61D683C7DC707237207AF6FEB36771",
        "port": 53317,
        "protocol": "https",
        "download": False
    },
    "files": {
        random_uuid: {
            "id": random_uuid,
            "fileName": file_name,
            "size": os.path.getsize(file_path),
            "fileType": "*"
        }
    }
}

# Use a session for a persistent connection
session = requests.Session()

# API endpoint for prepare-upload
prepare_url = f"https://{server_address}:53317/api/localsend/v2/prepare-upload"


# **Function to get certificate hash from a response**
def get_certificate_hash(response):
    """Extract the SSL certificate and compute its SHA-256 hash."""
    try:
        cert_bin = response.raw._connection.sock.getpeercert(binary_form=True)
        cert_hash = hashlib.sha256(cert_bin).hexdigest()
        return cert_hash
    except Exception as e:
        print(f"Error retrieving certificate hash: {e}")
        return None


try:
    # Send POST request (using session for persistent connection)
    response = session.post(prepare_url, json=data, verify=False, timeout=50, stream=True)

    # Get the certificate hash from the first request
    cert_hash_1 = get_certificate_hash(response)

    # Print response status and body
    print("\n=== Prepare Upload Response ===")
    print("Status Code:", response.status_code)
    print(f"First request hash:  {':'.join(f'{b:02X}' for b in bytes.fromhex(cert_hash_1))}")
    print("\n\n")

    # Parse JSON response
    response_data = response.json()
    session_id = response_data.get("sessionId", "")
    file_token = response_data.get("files", {}).get(random_uuid, "")

    if not session_id or not file_token:
        print("Error: Could not extract sessionId or fileToken from response.")
        sys.exit(1)

    # Construct the upload URL with query parameters
    upload_url = f"https://{server_address}:53317/api/localsend/v2/upload?sessionId={session_id}&fileId={random_uuid}&token={file_token}"

    # Read file bytes
    with open(file_path, "rb") as file:
        file_bytes = file.read()

        # Send the raw file bytes in the POST request using the same session
        upload_response = session.post(upload_url, data=file_bytes, verify=False, timeout=None, stream=True)

        # Get the certificate hash from the second request
        cert_hash_2 = get_certificate_hash(upload_response)

        # Print response details
        print("\n=== Upload Response ===")
        print("Status Code:", upload_response.status_code)
        print("Response Body:", upload_response.text)
        print(f"Second request hash: {':'.join(f'{b:02X}' for b in bytes.fromhex(cert_hash_2))}")
        print("\n")
        

    # **Compare the certificate hashes**
    if cert_hash_1 and cert_hash_2:
        print("\n=== Certificate Hash Comparison ===")

        if cert_hash_1 == cert_hash_2:
            print("Certificate is the SAME for both requests.")
        else:
            print("WARNING: Certificate has CHANGED between requests!")
        print()

except requests.exceptions.ConnectionError as e:
    print(f"Connection error: {e}")
except requests.exceptions.Timeout:
    print("Error: The request timed out.")
except requests.exceptions.RequestException as e:
    print(f"Request failed: {e}")
except FileNotFoundError:
    print(f"Error: File '{file_path}' not found.")
except PermissionError:
    print(f"Error: Permission denied for '{file_path}'.")
