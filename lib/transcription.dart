import 'package:objectbox/objectbox.dart';

@Entity()
class TranscriptionSegment {
  @Id()
  int id;

  final int start; // in centiseconds (hundredths of a second)
  final int end; // in centiseconds
  final String text;

  TranscriptionSegment({
    this.id = 0,
    required this.start,
    required this.end,
    required this.text,
  });

  // Helper to get Duration from centiseconds
  Duration get startDuration => Duration(milliseconds: start * 10);
  Duration get endDuration => Duration(milliseconds: end * 10);

  // Check if a given position falls within this segment
  bool containsPosition(Duration position) {
    final positionMs = position.inMilliseconds;
    return positionMs >= start * 10 && positionMs <= end * 10;
  }
}

@Entity()
class Transcription {
  @Id()
  int id;

  final String fullText;

  // Relationship to segments
  final segments = ToMany<TranscriptionSegment>();

  Transcription({
    this.id = 0,
    required this.fullText,
  });
}
