import os

import firebase_admin
from firebase_admin import firestore
from flask import Flask

app = Flask(__name__)

if not firebase_admin._apps:
    firebase_admin.initialize_app()

db = firestore.client(database_id="derma")


@app.route("/analyze", methods=["POST"])
def handle_request() -> tuple[str, int]:
    """Handle incoming analysis requests."""
    return "Hello, World!", 200


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
