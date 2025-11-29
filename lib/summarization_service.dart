import 'package:cactus/cactus.dart';
import 'package:flutter_intent/prompt.dart';
import 'package:flutter_intent/call_recording.dart';
import 'cactus_controller.dart';

class SummarizationService {
  static final CactusLM _cactusLM = CactusController.cactusLM;

  /// Summarizes a transcription text using Cactus LM
  static Future<String> summarizeTranscription(
    String transcriptionText,
    CallRecording callRecording,
  ) async {
    try {
      print('Starting summarization for transcription');

      // Initialize LM model if not already loaded
      await _cactusLM.initializeModel(
        params: CactusInitParams(model: CactusController.languageModel),
      );

      // Create messages for summarization using prompts from prompt.dart
      final messages = [
        ChatMessage(role: 'system', content: getSummarySystemPrompt()),
        ChatMessage(
          role: 'user',
          content: getSummaryUserPrompt(transcriptionText, callRecording),
        ),
      ];

      // Generate summary
      final result = await _cactusLM.generateCompletion(
        messages: messages,
        params: CactusCompletionParams(
          maxTokens: 150,
          temperature: 0.3,
          topP: 0.1,
        ),
      );

      if (result.success) {
        // Clean up any template tokens that might appear
        var summary = result.response.trim();
        summary = summary.replaceAll('|im_end|', '');
        summary = summary.replaceAll('<|im_end|>', '');
        summary = summary.replaceAll('</s>', '');
        summary = summary.trim();
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
