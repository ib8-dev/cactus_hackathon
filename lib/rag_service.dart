import 'dart:math';
import 'package:cactus/cactus.dart';
import 'call_recording.dart';
import 'cactus_controller.dart';
import 'vector.dart';
import 'objectbox_service.dart';
import 'search_screen.dart';

class RagService {
  static final CactusLM _cactusLM = CactusController.cactusLM;
  static final CactusRAG _cactusRAG = CactusController.cactusRAG;

  //   static Future<void> oldWayGenerateAndStoreEmbedding(
  //     CallRecording callRecording,
  //   ) async {
  //     final transcription = callRecording.transcription.target?.fullText;
  //     if (transcription == null || transcription.isEmpty) {
  //       return;
  //     }

  //     await _cactusRAG.initialize();

  //     _cactusRAG.setEmbeddingGenerator((text) async {
  //       var result = await _cactusLM.generateEmbedding(
  //         text: text,
  //         modelName: CactusController.embeddingModel,
  //       );
  //       return result.embeddings;
  //     });

  //     _cactusRAG.setChunking(chunkSize: 1024, chunkOverlap: 128);

  //     // Create rich content with metadata for better search
  //     String content =
  //         '''
  // Call with: ${callRecording.callLogName ?? 'Unknown Number'}
  // Phone: ${callRecording.phoneNumber}

  // Transcript:
  // ${callRecording.transcription.target!.fullText}
  // ''';

  //     await _cactusRAG.storeDocument(
  //       fileName: "${callRecording.id}.txt",
  //       filePath: "/calls/${callRecording.id}",
  //       content: content,
  //       fileSize: content.length,
  //     );
  //   }

  static Future<void> generateAndStoreEmbedding(
    CallRecording callRecording,
  ) async {
    final transcription = callRecording.transcription.target?.fullText;
    if (transcription == null || transcription.isEmpty) {
      return;
    }

    // Initialize embedding model
    await _cactusLM.initializeModel(
      params: CactusInitParams(model: CactusController.embeddingModel),
    );

    await _cactusRAG.initialize();

    _cactusRAG.setEmbeddingGenerator((text) async {
      var result = await _cactusLM.generateEmbedding(
        text: text,
        modelName: CactusController.embeddingModel,
      );
      return result.embeddings;
    });

    // 1. "Trojan Horse": Disable internal chunking so your manual chunks pass through
    _cactusRAG.setChunking(chunkSize: 10000, chunkOverlap: 0);

    // 2. Generate the smart chunks
    List<String> chunks = SmartChunker.slideBySentence(
      text: transcription,
      windowSize: 4,
      stepSize: 2,
      metadataHeader:
          "Context: Call with ${callRecording.callLogName ?? 'Unknown'} (${callRecording.callLogTimestamp ?? 'No timestamp'})",
    );

    print("Indexing ${chunks.length} chunks for Call ${callRecording.id}...");

    // 3. Fetch the latest recording to preserve relationships
    final objectBox = ObjectBoxService.instance;
    final freshRecording = objectBox.getCallRecording(callRecording.id);

    print('??????');

    if (freshRecording == null) {
      print('Recording not found in database');
      return;
    }

    // Clear existing vectors
    freshRecording.vectors.clear();

    // 4. Loop through chunks: store in CactusRAG AND generate vectors for ObjectBox
    for (var i = 0; i < chunks.length; i++) {
      // Store in CactusRAG for semantic search
      print('storing >>>>>>');
      await _cactusRAG.storeDocument(
        fileName: "${callRecording.id}_chunk_$i.txt",
        filePath: "${callRecording.id}",
        content: chunks[i],
        fileSize: chunks[i].length,
      );

      // Generate embedding for this chunk and store in ObjectBox
      final embeddingResult = await _cactusLM.generateEmbedding(
        text: chunks[i],
        modelName: CactusController.embeddingModel,
      );

      if (embeddingResult.success) {
        final vector = Vector(embedding: embeddingResult.embeddings);
        freshRecording.vectors.add(vector);
      }
    }

    // 5. Mark as vectorized and save
    final updatedRecording = CallRecording(
      id: freshRecording.id,
      filePath: freshRecording.filePath,
      fileName: freshRecording.fileName,
      dateReceived: freshRecording.dateReceived,
      size: freshRecording.size,
      summary: freshRecording.summary,
      isSummarized: freshRecording.isSummarized,
      isVectorized: true,
      notes: freshRecording.notes,
      callLogName: freshRecording.callLogName,
      callLogNumber: freshRecording.callLogNumber,
      callLogTimestamp: freshRecording.callLogTimestamp,
      callLogDuration: freshRecording.callLogDuration,
      callLogType: freshRecording.callLogType,
      contactDisplayName: freshRecording.contactDisplayName,
      contactPhoneNumber: freshRecording.contactPhoneNumber,
    );

    // Copy relationships
    updatedRecording.transcription.target = freshRecording.transcription.target;
    updatedRecording.vectors.addAll(freshRecording.vectors);

    objectBox.updateCallRecording(updatedRecording);

    print("Indexing Complete. Stored ${chunks.length} vectors in ObjectBox.");
  }

  /// Verify if a recording has been properly vectorized
  static Future<bool> isRecordingVectorized(CallRecording recording) async {
    try {
      // Check 1: isVectorized flag
      if (!recording.isVectorized) {
        return false;
      }

      // Check 2: Has vectors in ObjectBox
      if (recording.vectors.isEmpty) {
        print(
          'Recording ${recording.id} marked as vectorized but has no vectors',
        );
        return false;
      }

      // Check 3: Verify chunks exist in CactusRAG
      await _cactusRAG.initialize();

      // Try to find at least one chunk for this recording
      final allChunks = _cactusRAG.chunkBox.getAll();
      final hasChunks = allChunks.any((chunk) {
        final filePath = chunk.document.target?.filePath;
        return filePath == recording.id.toString();
      });

      if (!hasChunks) {
        print('Recording ${recording.id} has no chunks in CactusRAG');
        return false;
      }

      return true;
    } catch (e) {
      print('Error verifying vectorization for recording ${recording.id}: $e');
      return false;
    }
  }

  /// Search for calls using semantic search
  static Future<List<SearchResult>> searchCalls(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      // Initialize embedding model
      await _cactusLM.initializeModel(
        params: CactusInitParams(model: CactusController.embeddingModel),
      );

      await _cactusRAG.initialize();

      _cactusRAG.setEmbeddingGenerator((text) async {
        var result = await _cactusLM.generateEmbedding(
          text: text,
          modelName: CactusController.embeddingModel,
        );
        return result.embeddings;
      });

      // Search CactusRAG
      final ragResults = await _cactusRAG.search(
        text: query,
        limit: 20, // Get top 20 most relevant chunks
      );

      print('RAG search returned ${ragResults.length} results');

      // Group results by recording ID (filePath)
      final Map<int, List<ChunkSearchResult>> resultsByRecording = {};

      for (var result in ragResults) {
        // filePath contains the recording ID
        final recordingId = int.tryParse(
          result.chunk.document.target!.filePath,
        );
        if (recordingId != null) {
          resultsByRecording.putIfAbsent(recordingId, () => []);
          resultsByRecording[recordingId]!.add(result);
        }
      }

      // Fetch recordings and create search results
      final objectBox = ObjectBoxService.instance;
      final searchResults = <SearchResult>[];

      for (var entry in resultsByRecording.entries) {
        final recordingId = entry.key;
        final chunks = entry.value;

        // Get the recording
        final recording = objectBox.getCallRecording(recordingId);
        if (recording == null) continue;

        // Skip demo data in search results
        if (recording.isDemoData) continue;

        // Calculate average distance (lower is better)
        final avgDistance =
            chunks.map((c) => c.distance).reduce((a, b) => a + b) /
            chunks.length;

        // Convert distance to similarity score (0-1, higher is better)
        // Using exponential decay: similarity = exp(-distance)
        final similarity = exp(-avgDistance);

        // Get the best matching snippet (lowest distance)
        final bestChunk = chunks.reduce(
          (a, b) => a.distance < b.distance ? a : b,
        );

        searchResults.add(
          SearchResult(
            recording: recording,
            similarity: similarity,
            matchedSnippet: bestChunk.chunk.content,
          ),
        );
      }

      // Sort by similarity (highest first)
      searchResults.sort((a, b) => b.similarity.compareTo(a.similarity));

      return searchResults;
    } catch (e) {
      print('Error searching calls: $e');
      return [];
    }
  }
}

class SmartChunker {
  /// Splits text into overlapping windows of sentences
  static List<String> slideBySentence({
    required String text,
    required int windowSize, // e.g., 5 sentences per chunk
    required int stepSize, // e.g., move 2 sentences forward
    String? metadataHeader, // e.g., "Call with Mike | Nov 28"
  }) {
    // 1. Split text into sentences using Regex
    // Look for punctuation (.?!) followed by space or end of line
    RegExp sentenceSplit = RegExp(r"(.*?[.?!])\s+");

    // Clean up newlines to avoid weird splits
    String cleanText = text
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s+'), ' ');

    // Get all matches
    List<String> sentences = sentenceSplit
        .allMatches(cleanText + " ") // Add space to catch last sentence
        .map((m) => m.group(1)!.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    List<String> finalChunks = [];

    // 2. The Sliding Loop
    for (int i = 0; i < sentences.length; i += stepSize) {
      // Determine the end of this window
      int end = i + windowSize;
      if (end > sentences.length) end = sentences.length;

      // Grab the slice of sentences
      List<String> window = sentences.sublist(i, end);

      // Join them back into a paragraph
      String chunkBody = window.join(" ");

      // 3. Inject Metadata (Contextual Chunking)
      // This ensures every chunk knows WHO is talking
      if (metadataHeader != null) {
        finalChunks.add("$metadataHeader\n$chunkBody");
      } else {
        finalChunks.add(chunkBody);
      }

      // Stop if we've reached the end
      if (end == sentences.length) break;
    }

    return finalChunks;
  }
}
