import 'dart:convert';
import 'mock_processed_calls.dart';
import 'objectbox_service.dart';
import 'call_recording.dart';
import 'transcription.dart';

class DemoDataLoader {
  /// Load demo data into ObjectBox
  /// Returns list of demo CallRecording objects
  static Future<List<CallRecording>> loadDemoData(
    ObjectBoxService objectBox,
  ) async {
    print('🎬 Loading demo data...');
    final demoRecordings = <CallRecording>[];

    for (var mockCall in mockProcessedCalls) {
      // Create transcription
      final transcriptionData = mockCall['transcription'] as Map<String, dynamic>;
      final transcription = Transcription(
        fullText: transcriptionData['fullText'] as String,
      );

      // Serialize notes to JSON string
      final notesJson = mockCall['notes'] != null
          ? jsonEncode(mockCall['notes'])
          : null;

      // Create call recording
      final recording = CallRecording(
        id: 0, // Auto-assign
        filePath: mockCall['filePath'] as String,
        fileName: mockCall['fileName'] as String,
        dateReceived: DateTime.parse(mockCall['dateReceived'] as String),
        size: mockCall['size'] as int,
        callLogName: mockCall['callLogName'] as String?,
        callLogNumber: mockCall['callLogNumber'] as String?,
        callLogTimestamp: mockCall['callLogTimestamp'] as int?,
        callLogDuration: mockCall['callLogDuration'] as int?,
        callLogType: mockCall['callLogType'] as String?,
        contactDisplayName: mockCall['contactDisplayName'] as String?,
        contactPhoneNumber: mockCall['contactPhoneNumber'] as String?,
        summary: mockCall['summary'] as String?,
        notes: notesJson,
        isSummarized: true,
        isVectorized: true, // Mark as vectorized for demo
        isDemoData: true, // 🎬 Mark as demo data
      );

      recording.transcription.target = transcription;
      final id = objectBox.saveCallRecording(recording);

      // Get the saved recording with proper ID
      final savedRecording = objectBox.getCallRecording(id);
      if (savedRecording != null) {
        demoRecordings.add(savedRecording);
      }
    }

    print('✅ Demo data loaded: ${demoRecordings.length} calls');
    return demoRecordings;
  }

  /// Clear only demo data from ObjectBox (useful for development)
  static Future<void> clearDemoData(ObjectBoxService objectBox) async {
    final allRecordings = objectBox.getAllCallRecordings();
    int deletedCount = 0;

    for (var recording in allRecordings) {
      if (recording.isDemoData) {
        objectBox.deleteCallRecording(recording.id);
        deletedCount++;
      }
    }

    print('🗑️  Cleared $deletedCount demo recordings');
  }

  /// Clear all recordings from ObjectBox
  static Future<void> clearAllData(ObjectBoxService objectBox) async {
    final allRecordings = objectBox.getAllCallRecordings();
    for (var recording in allRecordings) {
      objectBox.deleteCallRecording(recording.id);
    }
    print('🗑️  All data cleared');
  }

  /// Get demo data count
  static int getDemoDataCount(ObjectBoxService objectBox) {
    final allRecordings = objectBox.getAllCallRecordings();
    return allRecordings.where((r) => r.isDemoData).length;
  }

  /// Get real data count
  static int getRealDataCount(ObjectBoxService objectBox) {
    final allRecordings = objectBox.getAllCallRecordings();
    return allRecordings.where((r) => !r.isDemoData).length;
  }
}
