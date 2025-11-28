# Call Recording Analyser with AI

## Features

1. Users can share their call recordings and will be transcribed
2. Then the transcription will be summarised
3. Users can search with AI to find relevant calls and summary with those calls
4. We automatically group the calls based on context, for example: grouping all the calls related to an upcoming event

## Flow
1. Since we cannot listen to call audio, users record using their native recorder
2. They share their file with our app
3. Once we received the app, we give options to link that recording with the call logs and contacts, if not linked, we consider as unknown
4. We use Cactus SDK for AI. After receiving and linked, we transcribe using whisper
5. After Transcription, we send that to summarization
6. After that we have to store the call logs as vector for RAG
7. Then users can search calls
8. Call grouping happens automatically

We are not focussed on any edge cases at the moment. We are just focussing on happy path