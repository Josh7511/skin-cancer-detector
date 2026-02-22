import logging
import tempfile

from firebase_admin import storage
from ultralytics import YOLO

logger = logging.getLogger(__name__)

BUCKET_NAME = "derma-3fec9-2"
WEIGHTS_PATH = "best.pt"


def load_model() -> YOLO:
    """Download model weights from Firebase Storage and load the YOLO model.

    Returns:
        A loaded YOLO model ready for inference.
    """
    # #region agent log
    logger.info("[DEBUG][H1/H2] load_model: entry — bucket=%s path=%s", BUCKET_NAME, WEIGHTS_PATH)
    # #endregion
    try:
        bucket = storage.bucket(BUCKET_NAME)
        blob = bucket.blob(WEIGHTS_PATH)
        # #region agent log
        logger.info("[DEBUG][H1] load_model: bucket access OK, blob exists=%s", blob.exists())
        # #endregion
    except Exception as exc:
        # #region agent log
        logger.error("[DEBUG][H1] load_model: bucket/blob access FAILED — %s", exc)
        # #endregion
        raise

    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=".pt") as tmp:
            blob.download_to_file(tmp)
            tmp_path = tmp.name
        # #region agent log
        import os as _os
        logger.info("[DEBUG][H2/H3] load_model: weights downloaded — tmp=%s size=%s bytes", tmp_path, _os.path.getsize(tmp_path))
        # #endregion
    except Exception as exc:
        # #region agent log
        logger.error("[DEBUG][H2] load_model: weights download FAILED — %s", exc)
        # #endregion
        raise

    try:
        # #region agent log
        logger.info("[DEBUG][H4] load_model: loading YOLO model from %s", tmp_path)
        # #endregion
        model = YOLO(tmp_path)
        # #region agent log
        logger.info("[DEBUG][H4] load_model: YOLO model loaded OK")
        # #endregion
        return model
    except Exception as exc:
        # #region agent log
        logger.error("[DEBUG][H4] load_model: YOLO load FAILED — %s", exc)
        # #endregion
        raise


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