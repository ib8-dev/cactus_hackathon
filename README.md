# Call (R)

**On-device AI-powered call recording assistant for Android**

Call (R) automatically transcribes, summarizes, and indexes your phone conversations - completely offline. Built with Nothing's design language and powered by on-device LLMs.


https://github.com/user-attachments/assets/513c3430-da85-40e4-a6cf-7f4f24b74f3f


## Screenshots

<div align="center">
  <img src="1.png" width="250" alt="Call List" />
  <img src="2.png" width="250" alt="Call Details" />
  <img src="3.png" width="250" alt="Search" />
</div>

## Features

### 🎙️ **Automatic Transcription**
- On-device speech recognition using Whisper
- Timestamped transcription segments
- Works completely offline

### 📝 **AI Summarization**
- Concise summaries from your perspective ("I", "We")
- Scam detection and urgency tagging
- Key outcomes, decisions, and action items

### 🔍 **Smart Search**
- Semantic search powered by RAG (Retrieval Augmented Generation)
- AI-generated search summaries
- Find calls by topic, person, or content

### 📌 **Notes Extraction**
- Automatically extracts phone numbers, emails, dates, and money amounts
- Contextual information for each extracted item
- Quick actions (call, email, etc.)

### 🎨 **Nothing Design Language**
- Sharp, geometric UI
- Minimalist aesthetic
- Consistent spacing and typography

## Tech Stack

- **Framework**: Flutter
- **AI/ML**: Cactus (on-device LLMs)
  - LFM for language understanding
  - Whisper for speech recognition
  - Qwen for embeddings
- **Database**: ObjectBox
- **Vector Search**: CactusRAG

## Architecture

```
┌─────────────────────────────────────────┐
│          User Interface (Flutter)       │
├─────────────────────────────────────────┤
│  Processing Pipeline:                   │
│  1. Link (Call Log/Contact)            │
│  2. Transcribe (Whisper STT)           │
│  3. Summarize (LFM)                    │
│  4. Extract Notes (Regex)              │
│  5. Vectorize (RAG)                    │
├─────────────────────────────────────────┤
│  Storage:                               │
│  • ObjectBox (metadata, transcripts)   │
│  • CactusRAG (vector embeddings)       │
└─────────────────────────────────────────┘
```

## Key Features in Detail

### Processing Pipeline
Each recording goes through an automated pipeline:
1. **Linking**: Associates with call log or contact
2. **Transcription**: Converts audio to text with timestamps
3. **Summarization**: Generates executive summary with LLM
4. **Notes Extraction**: Pulls out structured data (phones, emails, dates, money)
5. **Vectorization**: Creates embeddings for semantic search

### Search & Discovery
- **Semantic Search**: Ask questions like "Who is David?" or "Tell me about the contractor"
- **AI Summaries**: Get contextual answers synthesized from multiple calls
- **Context-Aware**: Search results include relevant snippets with surrounding context

### Privacy First
- **100% On-Device**: All AI processing happens locally
- **No Cloud**: No data leaves your device
- **Offline**: Works without internet connection

## Getting Started

### Prerequisites
- Flutter SDK
- Android device/emulator
- ~2GB free space for AI models

### Installation

```bash
# Clone the repository
cd flutter_intent

# Install dependencies
flutter pub get

# Run ObjectBox code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### First Launch
On first launch, the app will:
1. Download required AI models (~1.5GB total)
2. Load demo data for exploration
3. Navigate to home screen

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── home_screen.dart                   # Main navigation
├── audio_files_screen.dart            # Call list view
├── recording_detail_bottom_sheet.dart # Call details
├── processing_bottom_sheet.dart       # Processing pipeline UI
├── search_screen.dart                 # Search & AI summaries
├── services/
│   ├── transcription_service.dart     # Whisper STT
│   ├── summarization_service.dart     # LLM summarization
│   ├── rag_service.dart               # Vector search
│   └── notes_extraction_service.dart  # Entity extraction
├── objectbox_service.dart             # Database layer
└── models/
    ├── call_recording.dart            # Recording entity
    ├── transcription.dart             # Transcription entity
    └── vector.dart                    # Vector embeddings
```

## Demo Mode

The app includes demo data to showcase features:
- 3 realistic call scenarios
- Pre-generated transcriptions and summaries
- Searchable via semantic search

Toggle demo mode in the audio files screen to explore.

## Contributing

Contributions welcome! Please ensure:
- Code follows Flutter/Dart style guide
- ObjectBox models are regenerated after entity changes
- Nothing design language is maintained

## License

[Add your license here]

## Acknowledgments

- Built with [Cactus](https://github.com/Anthropic/cactus) for on-device AI
- Inspired by Nothing's minimalist design philosophy
- Whisper model by OpenAI
