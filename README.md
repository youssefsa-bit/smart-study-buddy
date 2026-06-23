# 🎓 Smart Study Buddy — Frontend 📱

<div align="center">
  <img src="assets/images/logo.png" alt="Smart Study Buddy Logo" width="120" />
  <br>
  <strong>Your AI-Powered Academic Companion</strong>
  <br>
  <em>Transform your lecture PDFs into interactive flashcards, quizzes, and summaries instantly using advanced AI.</em>
</div>

<br>

## 🚀 Overview

Smart Study Buddy is a cross-platform mobile application built with **Flutter**. It empowers university students by automating the process of generating study materials from dense lecture slides. The app seamlessly communicates with a Node.js/Python AI backend to stream real-time flashcards, multiple-choice questions, and comprehensive summaries.

## ✨ Key Features

- **📄 Smart Document Upload:** Upload PDF lecture slides directly from your device.
- **⚡ Real-Time AI Generation (SSE):** Watch flashcards and quizzes generate in real-time with Server-Sent Events (SSE).
- **🗂️ Interactive Flashcards:** Flip through dynamically generated flashcards to test your knowledge.
- **📝 Automated Quizzes (MCQ):** Test yourself with AI-curated multiple choice questions based strictly on your PDF content.
- **📑 Instant Summaries:** Generate comprehensive lecture summaries and export them as perfectly formatted PDF files.
- **🌍 Built-in Translation:** Translate any highlighted text to Arabic seamlessly within the app.
- **🌙 Theming & Localization:** Full support for system-based Dark/Light modes and English/Arabic localizations.
- **📊 Activity History:** Keep track of your past generated flashcards and quizzes in a unified history feed.

---

## 🛠️ Technology Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **Language:** Dart
- **State Management:** `flutter_bloc`
- **Routing:** `go_router`
- **Networking:** `dio` (with robust interceptors & SSE stream handling)
- **Local Storage:** `shared_preferences` & `flutter_secure_storage`
- **UI/UX:** Custom animated widgets, `shimmer` loading effects, `flutter_svg`
- **Architecture:** Feature-based Clean Architecture principles

---

## 📂 Project Structure

The project follows a feature-driven architecture to keep the codebase modular, scalable, and easy to maintain.

```text
lib/
├── core/
│   ├── network/          # Dio client, API endpoints, error handling
│   ├── theme/            # App colors, text styles, light/dark themes
│   ├── utils/            # Shared utilities, constants, validators
│   └── widgets/          # Reusable UI components (buttons, text fields)
├── features/
│   ├── auth/             # Login, Registration, Token management
│   ├── document/         # PDF upload, duplicate detection handling
│   ├── flashcards/       # Flashcard UI, Swiper, SSE Stream listener
│   ├── mcq/              # Quiz UI, Real-time MCQ stream listener
│   ├── summary/          # Summary generation & PDF export
│   ├── history/          # Activity feed for all generated content
│   └── profile/          # User settings, password change, theming
├── l10n/                 # Localization files (en.arb, ar.arb)
└── main.dart             # App entry point
```

---

## 🚦 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.19.0 or higher recommended)
- Android Studio / VS Code
- An emulator or physical device for testing
- The backend services must be running (Node.js API & Colab AI service).

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/smart-study-buddy-frontend.git
   cd smart-study-buddy-frontend
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables:**
   - Create a `.env` file in the root directory (if not using constants).
   - Alternatively, update `lib/core/network/api_constants.dart` with your local backend URL:
   ```dart
   class ApiConstants {
     static const String baseUrl = 'http://YOUR_BACKEND_IP:3000/api';
   }
   ```

4. **Run the App:**
   ```bash
   flutter run
   ```

---

## 🔌 API Integration Details

This app relies heavily on **Server-Sent Events (SSE)** using `Dio` for a magical user experience. Instead of waiting 30+ seconds for a loading spinner, the app opens an active stream connection and yields flashcards/MCQs one by one as the AI generates them.

- **Cancellation Support:** If a user navigates away from the generation screen, the `Bloc` automatically cancels the `CancelToken`, signaling the backend to abort the AI generation and save resources.

---

## 🎨 UI/UX Guidelines

- **Typography:** Uses modern fonts with clearly defined hierarchies in `app_text_styles.dart`.
- **Colors:** A centralized `app_colors.dart` ensures consistency across Dark and Light modes.
- **Responsiveness:** Layouts adapt smoothly to different screen sizes, preventing overflow errors.

---

## 🎓 About

This frontend application was developed as part of a Graduation Project by students at the **Faculty of Computers and Information Sciences**. It aims to leverage the latest advancements in LLMs to make university studying highly efficient and interactive.

<div align="center">
  <sub>Built with ❤️ using Flutter & Dart</sub>
</div>
