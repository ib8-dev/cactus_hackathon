import 'dart:convert';

/// Simple regex-based extraction for notes
/// Designed for reliability with small models
class NotesExtractionService {
  /// Extract structured notes from transcription text
  /// Returns JSON string compatible with CallRecording.notes format
  static String extractNotes(String transcriptionText) {
    final notes = {
      'phones': _extractPhoneNumbers(transcriptionText),
      'emails': _extractEmails(transcriptionText),
      'money': _extractMoney(transcriptionText),
      'dates': _extractDates(transcriptionText),
      'websites': <Map<String, String>>[],
      'places': <Map<String, String>>[],
      'people': <Map<String, String>>[],
      'other_notes': <Map<String, String>>[],
    };

    return jsonEncode(notes);
  }

  /// Extract phone numbers
  static List<Map<String, String>> _extractPhoneNumbers(String text) {
    final phoneNumbers = <Map<String, String>>[];

    // Patterns for phone numbers
    final patterns = [
      RegExp(r'\+?1?[-.\s]?\(?(\d{3})\)?[-.\s]?(\d{3})[-.\s]?(\d{4})'), // US format
      RegExp(r'\b(\d{3})[-.\s]?(\d{3})[-.\s]?(\d{4})\b'), // Simple format
      RegExp(r'\b(\d{10})\b'), // 10 digits
    ];

    for (var pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (var match in matches) {
        final phoneNumber = match.group(0)?.trim() ?? '';
        if (phoneNumber.isNotEmpty && !_isDuplicate(phoneNumbers, phoneNumber)) {
          // Get context (20 chars before and after)
          final start = (match.start - 20).clamp(0, text.length);
          final end = (match.end + 20).clamp(0, text.length);
          final context = text.substring(start, end).trim();

          phoneNumbers.add({
            'value': phoneNumber,
            'context': context,
          });
        }
      }
    }

    return phoneNumbers;
  }

  /// Extract email addresses
  static List<Map<String, String>> _extractEmails(String text) {
    final emails = <Map<String, String>>[];

    final emailPattern = RegExp(
      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
    );

    final matches = emailPattern.allMatches(text);
    for (var match in matches) {
      final email = match.group(0)?.trim() ?? '';
      if (email.isNotEmpty && !_isDuplicate(emails, email)) {
        // Get context
        final start = (match.start - 30).clamp(0, text.length);
        final end = (match.end + 30).clamp(0, text.length);
        final context = text.substring(start, end).trim();

        emails.add({
          'value': email,
          'context': context,
        });
      }
    }

    return emails;
  }

  /// Extract money amounts
  static List<Map<String, String>> _extractMoney(String text) {
    final moneyAmounts = <Map<String, String>>[];

    final patterns = [
      RegExp(r'\$[\d,]+(?:\.\d{2})?'), // $1,234.56
      RegExp(r'(?:USD|usd)\s*[\d,]+(?:\.\d{2})?'), // USD 1234.56
      RegExp(r'[\d,]+(?:\.\d{2})?\s*(?:dollars|bucks)'), // 1234.56 dollars
    ];

    for (var pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (var match in matches) {
        final amount = match.group(0)?.trim() ?? '';
        if (amount.isNotEmpty && !_isDuplicate(moneyAmounts, amount)) {
          // Get context
          final start = (match.start - 30).clamp(0, text.length);
          final end = (match.end + 30).clamp(0, text.length);
          final context = text.substring(start, end).trim();

          moneyAmounts.add({
            'value': amount,
            'context': context,
          });
        }
      }
    }

    return moneyAmounts;
  }

  /// Extract dates
  static List<Map<String, String>> _extractDates(String text) {
    final dates = <Map<String, String>>[];

    final patterns = [
      RegExp(r'\b(?:Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\b', caseSensitive: false),
      RegExp(r'\b(?:today|tomorrow|yesterday)\b', caseSensitive: false),
      RegExp(r'\b(?:next|last)\s+(?:week|month|year|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\b', caseSensitive: false),
      RegExp(r'\b(?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2}(?:st|nd|rd|th)?\b', caseSensitive: false),
      RegExp(r'\b\d{1,2}[/-]\d{1,2}[/-]\d{2,4}\b'), // 12/25/2024
    ];

    for (var pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (var match in matches) {
        final date = match.group(0)?.trim() ?? '';
        if (date.isNotEmpty && !_isDuplicate(dates, date)) {
          // Get context
          final start = (match.start - 30).clamp(0, text.length);
          final end = (match.end + 30).clamp(0, text.length);
          final context = text.substring(start, end).trim();

          dates.add({
            'value': date,
            'context': context,
          });
        }
      }
    }

    return dates;
  }

  /// Check if value already exists in list
  static bool _isDuplicate(List<Map<String, String>> list, String value) {
    return list.any((item) => item['value'] == value);
  }
}
