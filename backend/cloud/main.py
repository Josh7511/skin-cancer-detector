import logging
import os
import tempfile

import cv2
import firebase_admin
import numpy as np
from cloudevents.http import from_http
from firebase_admin import firestore, storage
from flask import Flask, request

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

if not firebase_admin._apps:
    firebase_admin.initialize_app()

db = firestore.client(database_id="derma")

IMAGE_SIZE = (224, 224)


def _download_image(bucket_name: str, object_name: str) -> tuple[np.ndarray, str]:
    """Download an image from Firebase Storage, save it to a temp file, and decode it.

    Args:
        bucket_name: The Firebase Storage bucket name.
        object_name: The path to the object within the bucket.

    Returns:
        A tuple of (decoded BGR image as a NumPy array, path to the temp file).

    Raises:
        ValueError: If the image bytes cannot be decoded.
    """
    bucket = storage.bucket(bucket_name)
    blob = bucket.blob(object_name)

    suffix = os.path.splitext(object_name)[-1] or ".jpg"
    with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
        blob.download_to_file(tmp)
        tmp_path = tmp.name

    logger.info("Image saved to container path: %s", tmp_path)

    img = cv2.imread(tmp_path)
    if img is None:
        raise ValueError(f"Failed to decode image from gs://{bucket_name}/{object_name}")

    return img, tmp_path


def _preprocess_image(img: np.ndarray) -> np.ndarray:
    """Resize and normalize a BGR image for model input.

    Args:
        img: Raw BGR image as a NumPy array.

    Returns:
        A float32 NumPy array of shape (224, 224, 3) with pixel values in [0.0, 1.0].
    """
    resized = cv2.resize(img, IMAGE_SIZE, interpolation=cv2.INTER_AREA)
    normalized = resized.astype(np.float32) / 255.0
    return normalized


@app.route("/", methods=["POST"])
def handle_request() -> tuple[str, int]:
    """Handle an Eventarc Cloud Storage object-finalized event.

    Expects a CloudEvent with type google.cloud.storage.object.v1.finalized,
    delivered via HTTP by Google Eventarc.

    Returns:
        A tuple of (response body, HTTP status code).
    """
    try:
        event = from_http(request.headers, request.get_data())
    except Exception as exc:
        logger.error("Failed to parse CloudEvent: %s", exc)
        return "Invalid CloudEvent payload", 400

    event_data: dict = event.data or {}
    bucket_name: str = event_data.get("bucket", "")
    object_name: str = event_data.get("name", "")

    if not bucket_name or not object_name:
        logger.error("CloudEvent missing bucket or name: %s", event_data)
        return "Missing bucket or object name in event data", 400

    image_dir = os.path.dirname(object_name)
    logger.info("Processing gs://%s/%s (directory: %s)", bucket_name, object_name, image_dir)

    try:
        img, tmp_path = _download_image(bucket_name, object_name)
        logger.info("Downloaded image with shape %s from %s", img.shape, tmp_path)
    except Exception as exc:
        logger.error("Failed to download image: %s", exc)
        return "Failed to download image", 500

    try:
        preprocessed = _preprocess_image(img)
        logger.info("Preprocessed image shape: %s, dtype: %s", preprocessed.shape, preprocessed.dtype)
    except Exception as exc:
        logger.error("Failed to preprocess image: %s", exc)
        return "Failed to preprocess image", 500

    # TODO: run model inference on `preprocessed` and write results to Firestore

    return "OK", 200


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
