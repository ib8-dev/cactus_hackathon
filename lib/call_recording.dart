import 'package:call_log/call_log.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:objectbox/objectbox.dart';
import 'transcription.dart';
import 'vector.dart';

@Entity()
class CallRecording {
  @Id()
  int id;

  final String filePath;
  final String fileName;

  @Property(type: PropertyType.date)
  final DateTime dateReceived;

  final int size;

  // Transcription and processing
  final transcription = ToOne<Transcription>();

  // Vector embeddings (multiple chunks for better search)
  final vectors = ToMany<Vector>();

  // Summarization
  final String? summary;
  final bool isSummarized;

  // Vectorization
  final bool isVectorized;

  // Store call log data as separate fields since CallLogEntry can't be stored directly
  final String? callLogName;
  final String? callLogNumber;
  final int? callLogTimestamp;
  final int? callLogDuration;
  final String? callLogType; // 'incoming', 'outgoing', 'missed', 'rejected'

  // Store contact data as separate fields
  final String? contactDisplayName;
  final String? contactPhoneNumber;

  CallRecording({
    this.id = 0,
    required this.filePath,
    required this.fileName,
    required this.dateReceived,
    required this.size,
    this.summary,
    this.isSummarized = false,
    this.isVectorized = false,
    this.callLogName,
    this.callLogNumber,
    this.callLogTimestamp,
    this.callLogDuration,
    this.callLogType,
    this.contactDisplayName,
    this.contactPhoneNumber,
  });

  // Transient fields (not stored in ObjectBox)
  @Transient()
  CallLogEntry? callLog;

  @Transient()
  Contact? contact;

  bool get isLinked => callLogNumber != null || contactPhoneNumber != null;

  String get displayName {
    if (callLogName != null && callLogName!.isNotEmpty) {
      return callLogName!;
    }
    if (callLogNumber != null && callLogNumber!.isNotEmpty) {
      return callLogNumber!;
    }
    if (contactDisplayName != null && contactDisplayName!.isNotEmpty) {
      return contactDisplayName!;
    }
    return 'Unknown';
  }

  String? get phoneNumber {
    return callLogNumber ?? contactPhoneNumber;
  }

  // Factory constructor to create from CallLogEntry
  factory CallRecording.fromCallLog({
    int id = 0,
    required String filePath,
    required String fileName,
    required DateTime dateReceived,
    required int size,
    required CallLogEntry callLog,
    String? summary,
    bool isSummarized = false,
    bool isVectorized = false,
  }) {
    return CallRecording(
      id: id,
      filePath: filePath,
      fileName: fileName,
      dateReceived: dateReceived,
      size: size,
      summary: summary,
      isSummarized: isSummarized,
      isVectorized: isVectorized,
      callLogName: callLog.name,
      callLogNumber: callLog.number,
      callLogTimestamp: callLog.timestamp,
      callLogDuration: callLog.duration,
      callLogType: callLog.callType?.toString().split('.').last,
    )..callLog = callLog;
  }

  // Factory constructor to create from Contact
  factory CallRecording.fromContact({
    int id = 0,
    required String filePath,
    required String fileName,
    required DateTime dateReceived,
    required int size,
    required Contact contact,
    String? summary,
    bool isSummarized = false,
    bool isVectorized = false,
  }) {
    return CallRecording(
      id: id,
      filePath: filePath,
      fileName: fileName,
      dateReceived: dateReceived,
      size: size,
      summary: summary,
      isSummarized: isSummarized,
      isVectorized: isVectorized,
      contactDisplayName: contact.displayName,
      contactPhoneNumber: contact.phones.isNotEmpty ? contact.phones.first.number : null,
    )..contact = contact;
  }
}
