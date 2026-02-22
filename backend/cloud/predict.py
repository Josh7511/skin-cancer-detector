import logging
import tempfile

from firebase_admin import storage
from ultralytics import YOLO

logger = logging.getLogger(__name__)

BUCKET_NAME = "derma-3fec9-2"
WEIGHTS_PATH = "models/best.pt"


def load_model() -> YOLO:
    """Download model weights from Firebase Storage and load the YOLO model.

    Returns:
        A loaded YOLO model ready for inference.
    """
    bucket = storage.bucket(BUCKET_NAME)
    blob = bucket.blob(WEIGHTS_PATH)

    with tempfile.NamedTemporaryFile(delete=False, suffix=".pt") as tmp:
        blob.download_to_file(tmp)
        tmp_path = tmp.name

    logger.info("Model weights saved to container path: %s", tmp_path)
    return YOLO(tmp_path)


def predict(model: YOLO, image_path: str) -> dict:
    """Run classification inference on a single image.

    Args:
        model: A loaded YOLO model.
        image_path: Path to the image file.

    Returns:
        A dict with verdict, confidence, and recommendation.
    """
    results = model.predict(image_path)
    result = results[0]

    probs = result.probs
    top1 = probs.top1
    confidence = float(probs.top1conf) * 100
    class_name = result.names[top1]

    return {
        "verdict": class_name,
        "confidence": round(confidence, 2),
    }