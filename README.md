# Chessdy 👑

Chessdy is an interactive chess learning and coaching application. It features a Flutter-based frontend and a Python FastAPI backend integrated with the Stockfish chess engine. Chessdy provides users with a conversational AI coach, interactive lessons, statistics tracking, and full gameplay capabilities.

---

## 📂 Project Structure

```text
research/
├── chessdy/               # Flutter Frontend
│   ├── android/
│   ├── ios/
│   ├── lib/               # Flutter source code
│   │   ├── features/      # Game, Coach, Lessons, and Home features
│   │   └── main.dart      # Application entry point
│   ├── assets/            # App assets
│   └── backend/           # Python FastAPI Backend
│       ├── main.py        # API server logic (move analysis, commentary)
│       └── requirements.txt
└── README.md              # Project documentation
```

---

## 🛠️ Prerequisites

Before running the project, make sure you have the following installed on your machine:

1. **Flutter SDK** (v3.10.x or newer): [Install Flutter](https://docs.flutter.dev/get-started/install)
2. **Python** (v3.8 or newer): [Install Python](https://www.python.org/downloads/)
3. **Stockfish Chess Engine**:
   - **macOS** (via Homebrew):
     ```bash
     brew install stockfish
     ```
   - **Ubuntu/Debian**:
     ```bash
     sudo apt-get install stockfish
     ```
   - **Windows**: Download the binary from the [Stockfish website](https://stockfishchess.org/download/) and add it to your system's PATH, or configure the path manually in `chessdy/backend/main.py`.

---

## 🚀 Getting Started

### 1. Run the Python Backend

The backend runs on FastAPI and handles AI move calculations, position evaluations, and natural language commentary (supporting both English and Mongolian).

1. Navigate to the backend directory:
   ```bash
   cd chessdy/backend
   ```
2. Create and activate a virtual environment:
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```
3. Install the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Start the FastAPI development server:
   ```bash
   uvicorn main:app --reload --port 8000
   ```
   *The backend will now be running at `http://127.0.0.1:8000`.*

---

### 2. Run the Flutter Frontend

1. Open a new terminal window and navigate to the `chessdy` directory:
   ```bash
   cd chessdy
   ```
2. Fetch the Flutter package dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application on your desired device/simulator:
   - To list available devices:
     ```bash
     flutter devices
     ```
   - To run the application:
     ```bash
     flutter run
     ```

---

## ⚙️ Configuration & Customization

### Stockfish Engine Path
The backend searches for Stockfish automatically on standard system paths. If you have Stockfish installed in a custom location, you can update the path in `chessdy/backend/main.py`:
```python
STOCKFISH_PATH = "/your/custom/path/to/stockfish"
```

### API Endpoint Configuration
The frontend communicates with the backend via `http://127.0.0.1:8000`. If you host the backend on a different address or port, update the URLs in:
- `chessdy/lib/features/coach/coach_page.dart`