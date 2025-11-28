import 'package:call_log/call_log.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class CallRecording {
  final String id;
  final String filePath;
  final String fileName;
  final DateTime dateReceived;
  final int size;
  final CallLogEntry? callLog;
  final Contact? contact;

  CallRecording({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.dateReceived,
    required this.size,
    this.callLog,
    this.contact,
  });

  bool get isLinked => callLog != null || contact != null;

  String get displayName {
    if (callLog != null) {
      // First try to get the contact name from call log
      if (callLog!.name != null && callLog!.name!.isNotEmpty) {
        return callLog!.name!;
      }
      // Otherwise show the number
      if (callLog!.number != null && callLog!.number!.isNotEmpty) {
        return callLog!.number!;
      }
      return 'Unknown';
    }
    if (contact != null) {
      return contact!.displayName;
    }
    return 'Unknown';
  }

  String? get phoneNumber {
    if (callLog != null) {
      return callLog!.number;
    }
    if (contact != null && contact!.phones.isNotEmpty) {
      return contact!.phones.first.number;
    }
    return null;
  }
}
