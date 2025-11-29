import 'package:cactus/cactus.dart';
import 'cactus_controller.dart';

class SummarizationService {
  static final CactusLM _cactusLM = CactusController.cactusLM;

  /// Summarizes a transcription text using Cactus LM
  static Future<String> summarizeTranscription(String transcriptionText) async {
    try {
      print('Starting summarization for transcription');

      // Initialize LM model if not already loaded
      await _cactusLM.initializeModel(
        params: CactusInitParams(model: CactusController.languageModel),
      );

      // Create messages for summarization
      final messages = [
        ChatMessage(
          role: 'system',
          content:
              'You are a helpful assistant that summarizes phone call transcriptions concisely.',
        ),
        ChatMessage(
          role: 'user',
          content:
              'Summarize the following phone call transcription in 2-3 concise sentences. Focus on the main topic discussed and key points or outcomes:\n\n$transcriptionText',
        ),
      ];

      // Generate summary
      final result = await _cactusLM.generateCompletion(
        messages: messages,
        params: CactusCompletionParams(
          maxTokens: 150,
          temperature: 0.3,
          topP: 0.9,
        ),
      );

      if (result.success) {
        final summary = result.response.trim();
        print('Summarization completed: ${summary.length} characters');
        return summary;
      } else {
        print('Summarization failed: ${result.response}');
        return '';
      }
    } catch (e) {
      print('Error summarizing transcription: $e');
      return '';
    }
  }

  /// Releases the LM model from memory
  static Future<void> dispose() async {
    _cactusLM.unload();
  }
}
