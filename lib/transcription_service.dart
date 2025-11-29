import 'package:cactus/cactus.dart';
import 'cactus_controller.dart';

class TranscriptionService {
  static final CactusSTT _cactusSTT = CactusController.cactusSTT;

  /// Transcribes an audio file and returns the transcription text
  static Future<String> transcribeAudio(String audioFilePath) async {
    try {
      print('Starting transcription for: $audioFilePath');

      // Initialize STT model if not already loaded
      await _cactusSTT.init(model: CactusController.sttModel);

      // Transcribe the audio file
      final transcription = await _cactusSTT.transcribe(
        filePath: audioFilePath,

        params: SpeechRecognitionParams(),
      );

      return transcription?.text ?? '';
    } catch (e) {
      print('Error transcribing audio: $e');
      return '';
    }
  }

  /// Releases the STT model from memory
  static Future<void> dispose() async {
    _cactusSTT.dispose();
  }
}
