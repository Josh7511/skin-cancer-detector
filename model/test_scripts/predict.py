from ultralytics import YOLO
import cv2

model = YOLO("model/weights/best.pt")
results = model.predict("model/test_images/", save=True, save_txt=True)

for result in results:
    probs = result.probs
    top1 = probs.top1
    top1conf = probs.top1conf
    class_name = result.names[top1]

    print(f"Class: {class_name}, Confidence: {top1conf}")

    print(model.names)