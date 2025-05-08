from flask import Flask
from pathlib import Path
import requests

app = Flask(__name__)

@app.route('/', methods=["GET"])
def get_hello():
    try:
        output = Path("/usr/share/output.txt")
        return output.read_text()
    except FileNotFoundError:
        return "upload failure", 500

@app.route('/health', methods=["GET"])
def health():
    return "live", 200


@app.route('/ready', methods=["GET"])
def ready():
    ready_status = requests.get("http://127.0.0.1:8000/").status_code
    if ready_status != 200:
        return "not ready", ready_status
    return "ready", 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port="8000")
