import 'package:flutter_intent/call_recording.dart';
import 'package:flutter_intent/transcription_service.dart';
import 'package:flutter_intent/summarization_service.dart';
import 'package:flutter_intent/objectbox_service.dart';
import 'package:flutter_intent/transcription.dart';

class BackgroundProcessingService {
  /// Starts processing a recording in the background (transcription and summarization)
  static Future<void> processRecording(CallRecording recording) async {
    print('Starting background processing for recording ${recording.id}');

    try {
      // Step 1: Transcribe
      final transcribed = await _transcribe(recording);
      if (!transcribed) {
        print('Transcription failed for recording ${recording.id}');
        return;
      }

      // Step 2: Summarize
      final summarized = await _summarize(recording.id);
      if (!summarized) {
        print('Summarization failed for recording ${recording.id}');
        return;
      }

      print('Background processing completed for recording ${recording.id}');
    } catch (e) {
      print('Error during background processing: $e');
    }
  }

  static Future<bool> _transcribe(CallRecording recording) async {
    try {
      print('Background transcription started for ${recording.id}');

      final result = await TranscriptionService.transcribeAudioWithSegments(
        recording.filePath,
      );

      if (result == null || result.text.isEmpty) {
        return false;
      }

      // Create Transcription entity with segments
      final transcription = Transcription(fullText: result.text);

      // Add segments if available
      if (result.segments != null) {
        for (var segment in result.segments!) {
          final transcriptionSegment = TranscriptionSegment(
            start: segment.startTime,
            end: segment.endTime,
            text: segment.text,
          );
          transcription.segments.add(transcriptionSegment);
        }
      }

      // Fetch fresh recording and update with transcription
      final objectBox = ObjectBoxService.instance;
      final freshRecording = objectBox.getCallRecording(recording.id);

      if (freshRecording == null) {
        print('Recording not found in database');
        return false;
      }

      freshRecording.transcription.target = transcription;
      objectBox.updateCallRecording(freshRecording);

      print('Background transcription completed for ${recording.id}');
      return true;
    } catch (e) {
      print('Error during background transcription: $e');
      return false;
    }
  }

  static Future<bool> _summarize(int recordingId) async {
    try {
      print('Background summarization started for $recordingId');

      final objectBox = ObjectBoxService.instance;
      final recording = objectBox.getCallRecording(recordingId);

      if (recording == null) {
        print('Recording not found in database');
        return false;
      }

      final transcriptionText = recording.transcription.target?.fullText;
      if (transcriptionText == null || transcriptionText.isEmpty) {
        print('No transcription available to summarize');
        return false;
      }

      // Generate summary using Cactus LM
      final summary = await SummarizationService.summarizeTranscription(
        transcriptionText,
      );

      if (summary.isEmpty) {
        return false;
      }

      // Create new recording with updated summary
      final updatedRecording = CallRecording(
        id: recording.id,
        filePath: recording.filePath,
        fileName: recording.fileName,
        dateReceived: recording.dateReceived,
        size: recording.size,
        summary: summary,
        isSummarized: true,
        isVectorized: recording.isVectorized,
        callLogName: recording.callLogName,
        callLogNumber: recording.callLogNumber,
        callLogTimestamp: recording.callLogTimestamp,
        callLogDuration: recording.callLogDuration,
        callLogType: recording.callLogType,
        contactDisplayName: recording.contactDisplayName,
        contactPhoneNumber: recording.contactPhoneNumber,
      );

      // Copy the transcription relationship
      updatedRecording.transcription.target = recording.transcription.target;

      // Save to ObjectBox
      objectBox.updateCallRecording(updatedRecording);

      print('Background summarization completed for $recordingId');
      return true;
    } catch (e) {
      print('Error during background summarization: $e');
      return false;
    }
  }
}
