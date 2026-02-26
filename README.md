# Derma – AI-Assisted Skin Cancer Screening

Derma is an AI-powered mobile application designed for dermatologists. Clinicians capture or upload dermatoscopic images directly from their phone, and the app delivers an instant AI-powered secondary opinion — classifying the lesion, displaying a confidence score, and storing structured analysis results for review. Derma is built to strengthen clinical confidence and improve efficiency, not replace medical expertise.

---

## Hack@URI 2026 — NVIDIA Track

> **2nd Place — $1,000 Prize**

Derma was submitted under the **NVIDIA track** at [Hack@URI 2026](https://hackuri.com) and placed **second overall**, winning **$1,000**.

**Team:** Joshua Pereira, Noah Vargas, Ericsen Semedo

---

## Inspiration

Skin cancer is highly treatable when detected early, yet dermatologists face increasing patient demand and limited time per evaluation. We were inspired by the idea of transforming a smartphone into a clinical decision-support tool that delivers an instant AI-powered secondary opinion during examinations.

More broadly, Derma reflects the growing role of artificial intelligence in the ever-changing healthcare environment. As clinical workloads increase and technology advances, AI has the potential to support faster decision making, improve consistency, and expand access to high-quality care.

---

## What It Does

Derma is a mobile AI application designed for dermatologists. It allows clinicians to:

- Capture or upload dermatoscopic images from their phone
- Receive a classification of **potential cancer** or **non-cancer**
- View a **confidence score** representing the model's certainty
- Store and review **structured analysis results** via a scan history screen

The app functions as a real-time AI assistant within a dermatologist's workflow.

---

## How We Built It

### AI Model

We used **YOLO26s-cls**, a lightweight image classification model optimized for fast and efficient inference.

- Trained on approximately **10,000 dermatoscopic images**
- Training performed on the **URI Unity Cluster**
- Tuned for deployment in a cloud-based production environment

Images are preprocessed using **OpenCV** before being passed into the trained model for classification.

### Backend & Cloud Infrastructure

We designed a scalable, production-ready cloud architecture:

- **Flutter** (iOS, Android, Web) — cross-platform mobile and web frontend
- **Flask** (Python) — backend API handling inference requests and logging
- **Docker** — containerizes the backend and model environment for consistent builds
- **Artifact Registry** — stores and manages container images
- **Google Cloud Run** — deploys and auto-scales containers based on traffic
- **Firebase Storage** — holds uploaded dermatoscopic images
- **Cloud Firestore** — stores structured analysis results (NoSQL)
- **Firebase Authentication** — anonymous auth for secure, privacy-preserving access

### System Flow

```
Flutter (Mobile/Web)
    |
    | 1. Clinician captures or uploads dermatoscopic image
    v
Firebase Storage
    |
    | 2. Image stored in cloud bucket
    v
Flask API (Cloud Run)
    |
    | 3. Image retrieved and preprocessed with OpenCV
    v
YOLO26s-cls Model
    |
    | 4. Classification: cancer vs. non-cancer
    | 5. Confidence score generated
    v
Cloud Firestore
    |
    | 6. Results written (verdict, confidence, timestamp, recommendation)
    v
Flutter (Mobile/Web)
    |
    | 7. Real-time listener displays results to clinician
    v
Clinician
```

Docker ensures consistent environments across development and production. Containers are pushed to Artifact Registry, and Cloud Run automatically scales them based on incoming traffic.

---

## Features

- **AI-Powered Analysis** — YOLO26s-cls model trained on dermatoscopic images classifies lesions as potential cancer or non-cancer.
- **Confidence Score** — Displays the model's certainty (e.g., 87.3%) so clinicians can weigh the result appropriately.
- **Smart Recommendations**
  - If flagged as potential cancer: strongly recommend consulting a specialist.
  - If not flagged but concern remains: suggest a follow-up evaluation.
- **Scan History** — Clinicians can review past analyses stored in Firestore, organized by session.
- **Anonymous Accounts** — Users authenticate anonymously via Firebase Auth. No personal data is collected or stored.
- **Real-Time Results** — Firestore real-time listeners push results to the app as soon as analysis completes.
- **Dark / Light Mode** — Theme toggle for comfortable use in any clinical environment.
- **Privacy First** — Images and results are tied only to anonymous session IDs.

---

## Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Frontend** | Flutter (iOS, Android, Web) | Cross-platform UI, image capture/upload, results display |
| **State Management** | Provider | App-wide state for auth, history, and theme |
| **Auth** | Firebase Anonymous Auth | Privacy-preserving clinician sessions |
| **Storage** | Firebase Cloud Storage | Temporary image storage for processing |
| **Backend** | Flask (Python) | REST API, orchestrates image processing pipeline |
| **Image Processing** | OpenCV | Preprocessing (resize, normalize) before inference |
| **AI Model** | YOLO26s-cls (Ultralytics) | Dermatoscopic image classification |
| **Database** | Cloud Firestore | Store analysis results, real-time sync to frontend |
| **Containerization** | Docker | Consistent build and deployment environment |
| **Registry** | Artifact Registry | Container image storage and versioning |
| **Cloud** | Google Cloud Run | Serverless, auto-scaling container deployment |

---

## Project Structure

```
skin-cancer-detector/
├── frontend/                        # Flutter application (iOS, Android, Web)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── firebase_options.dart
│   │   ├── screens/                 # home, upload, results, history, about, app_shell
│   │   ├── services/                # auth, storage, firestore, analysis, local_storage, image_cache
│   │   ├── widgets/                 # scan_card, step_indicator, confidence_gauge, info_step_card, theme_toggle
│   │   ├── models/                  # analysis_result
│   │   ├── providers/               # auth, history, theme
│   │   └── theme/                   # app_theme
│   ├── android/
│   ├── ios/
│   ├── web/
│   └── pubspec.yaml
│
├── backend/
│   └── cloud/
│       ├── main.py                  # Flask entry point
│       ├── predict.py               # YOLO26s-cls inference logic
│       ├── Dockerfile               # gunicorn on port 8080
│       └── requirements.txt
│
├── model/
│   ├── weights/                     # Trained model weights (gitignored)
│   └── test_images/                 # Local test images (gitignored)
│
├── AGENTS.md
├── .gitignore
└── README.md
```

---

## Disclaimer

This application is intended for **educational and research purposes only**. It is **not** a certified medical device and should **not** be used as a substitute for professional medical advice, diagnosis, or treatment. Always consult a qualified healthcare provider for any concerns about skin lesions or cancer. The AI model's predictions are probabilistic and may be incorrect.

---

## License

TBD
