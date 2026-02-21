# Skin Cancer Detector

An AI-powered web application that analyzes images of skin lesions to detect potential skin cancer. Users upload a photo through a Flutter web frontend, the image is processed by a PyTorch deep learning model via a Flask backend, and the results -- including a confidence score and a final verdict -- are returned to the user. The system uses anonymous accounts to protect user privacy.

## Architecture & Data Flow

```
Flutter (Web Frontend)
    |
    | 1. User uploads skin image
    v
Firebase Storage
    |
    | 2. Image stored, triggers processing
    v
Flask (Backend API)
    |
    | 3. Image retrieved and preprocessed
    v
OpenCV + PyTorch (AI Model)
    |
    | 4. Classification: cancer vs. non-cancer
    | 5. Confidence score generated
    v
Cloud Firestore (Database)
    |
    | 6. Results written (verdict, confidence, metadata)
    v
Flutter (Web Frontend)
    |
    | 7. User sees results: verdict, confidence score, recommendation
    v
User
```

### Flow Summary

1. **Flutter** -- User opens the web app, authenticates anonymously via Firebase Auth, and uploads a photo of a skin lesion.
2. **Firebase Storage** -- The image is uploaded to a Cloud Storage bucket.
3. **Flask** -- The backend detects the new upload (via Cloud Function trigger or polling), retrieves the image from Storage.
4. **OpenCV / PyTorch** -- The image is preprocessed (resized, normalized) with OpenCV, then fed into a PyTorch CNN trained on a skin cancer dataset. The model outputs a classification and confidence score.
5. **Cloud Firestore** -- The results (verdict, confidence percentage, timestamp, recommendation) are written to a Firestore document linked to the user's anonymous session.
6. **Flutter** -- The frontend listens to the Firestore document in real-time and displays the results to the user.

## Features

- **AI-Powered Analysis** -- Deep learning model trained on dermatological image datasets to classify skin lesions.
- **Confidence Score** -- Users see the model's confidence level (e.g., 87.3%) so they understand the certainty of the result.
- **Smart Recommendations**:
  - If flagged as potential cancer: strongly recommend visiting a dermatologist.
  - If not flagged but user is concerned: suggest visiting a doctor for peace of mind.
- **Anonymous Accounts** -- Users are authenticated anonymously via Firebase Auth. No personal data is collected or stored.
- **Real-Time Results** -- Firestore real-time listeners push results to the frontend as soon as analysis completes.
- **Privacy First** -- Images are processed and results are tied only to anonymous session IDs.

## Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Frontend** | Flutter (Web) | Cross-platform UI, image upload, results display |
| **Auth** | Firebase Anonymous Auth | Privacy-preserving user sessions |
| **Storage** | Firebase Cloud Storage | Temporary image storage for processing |
| **Backend** | Flask (Python) | REST API, orchestrates image processing pipeline |
| **Image Processing** | OpenCV | Image preprocessing (resize, normalize, augment) |
| **AI Model** | PyTorch | CNN-based skin lesion classification |
| **Database** | Cloud Firestore | Store analysis results, real-time sync to frontend |
| **Cloud** | Google Cloud Platform | Hosting, Cloud Functions, infrastructure |

## Project Structure (Planned)

```
skin_cancer_detector/
├── frontend/                  # Flutter web application
│   ├── lib/
│   │   ├── main.dart
│   │   ├── screens/          # Upload screen, results screen
│   │   ├── services/         # Firebase auth, storage, firestore
│   │   ├── widgets/          # Reusable UI components
│   │   └── models/           # Data models (analysis result, etc.)
│   ├── web/
│   ├── pubspec.yaml
│   └── ...
│
├── backend/                   # Backend services
│   └── cloud/
│       └── main.py           # Cloud Function entry point
│
├── AGENTS.md                  # AI agent rules
├── .gitignore
└── README.md                  # This file
```

## Getting Started

### Prerequisites

- **Flutter SDK** (3.x+) -- [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Python** (3.10+) -- [Install Python](https://www.python.org/downloads/)
- **Firebase CLI** -- `npm install -g firebase-tools`
- **Google Cloud SDK** -- [Install gcloud](https://cloud.google.com/sdk/docs/install)
- A **Firebase project** with Anonymous Auth, Cloud Storage, and Firestore enabled

### Backend Setup

```bash
# Navigate to backend
cd backend/

# Create virtual environment
python -m venv .venv
source .venv/bin/activate  # Linux/macOS
# .venv\Scripts\activate   # Windows

# Install dependencies
pip install -r requirements.txt

# Set environment variables
cp .env.example .env
# Edit .env with your Firebase credentials and config

# Run the Flask server
flask run --port 5000
```

### Frontend Setup

```bash
# Navigate to frontend
cd frontend/

# Get Flutter dependencies
flutter pub get

# Configure Firebase
flutterfire configure

# Run in Chrome
flutter run -d chrome
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `FIREBASE_PROJECT_ID` | Your Firebase project ID |
| `FIREBASE_STORAGE_BUCKET` | Cloud Storage bucket name |
| `GOOGLE_APPLICATION_CREDENTIALS` | Path to service account key JSON |
| `MODEL_WEIGHTS_PATH` | Path to trained PyTorch model weights |
| `FLASK_ENV` | `development` or `production` |
| `FLASK_PORT` | Port for Flask server (default: 5000) |

## Disclaimer

This application is intended for **educational and informational purposes only**. It is **not** a medical device and should **not** be used as a substitute for professional medical advice, diagnosis, or treatment. Always consult a qualified healthcare provider for any concerns about skin lesions or cancer. The AI model's predictions are probabilistic and may be incorrect.

## License

TBD
