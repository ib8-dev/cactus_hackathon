import 'package:flutter/material.dart';
import 'package:flutter_intent/call_recording.dart';
import 'package:flutter_intent/transcription_service.dart';
import 'package:flutter_intent/summarization_service.dart';
import 'package:flutter_intent/objectbox_service.dart';
import 'package:flutter_intent/transcription.dart';
import 'package:cactus/cactus.dart';
import 'package:flutter_intent/rag_service.dart';
import 'package:flutter_intent/notes_extraction_service.dart';

enum ProcessingStep {
  linking,
  transcribing,
  summarizing,
  vectorizing,
  completed,
  failed,
}

class ProcessingBottomSheet extends StatefulWidget {
  final CallRecording recording;
  final VoidCallback onComplete;

  const ProcessingBottomSheet({
    super.key,
    required this.recording,
    required this.onComplete,
  });

  @override
  State<ProcessingBottomSheet> createState() => _ProcessingBottomSheetState();
}

class _ProcessingBottomSheetState extends State<ProcessingBottomSheet>
    with SingleTickerProviderStateMixin {
  late ProcessingStep _currentStep;
  ProcessingStep? _failedStep;
  late String _statusMessage;
  CallRecording? _updatedRecording;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _updatedRecording = widget.recording;

    // Determine the starting step based on what's already completed
    _currentStep = _determineStartingStep();
    _statusMessage = _getStatusMessage(_currentStep);

    _startProcessing();
  }

  ProcessingStep _determineStartingStep() {
    final recording = widget.recording;

    // Check in reverse order: if vectorized, we're done
    if (recording.isVectorized) {
      return ProcessingStep.completed;
    }

    // If summarized but not vectorized, start from vectorize
    if (recording.isSummarized) {
      return ProcessingStep.vectorizing;
    }

    // If transcribed but not summarized, start from summarize
    if (recording.transcription.target != null) {
      return ProcessingStep.summarizing;
    }

    // Otherwise start from transcribe
    return ProcessingStep.transcribing;
  }

  String _getStatusMessage(ProcessingStep step) {
    switch (step) {
      case ProcessingStep.linking:
        return 'Linking audio...';
      case ProcessingStep.transcribing:
        return 'Transcribing audio...';
      case ProcessingStep.summarizing:
        return 'Summarizing transcription...';
      case ProcessingStep.vectorizing:
        return 'Creating vectors for search...';
      case ProcessingStep.completed:
        return 'Processing complete!';
      case ProcessingStep.failed:
        return 'Processing failed';
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startProcessing() async {
    setState(() {
      _failedStep = null;
    });

    try {
      // Step 1: Linking (already done, just show it)
      if (_currentStep.index <= ProcessingStep.linking.index) {
        await Future.delayed(const Duration(milliseconds: 500));
        _updateStep(ProcessingStep.transcribing, 'Transcribing audio...');
      }

      // Step 2: Transcribe
      if (_currentStep.index <= ProcessingStep.transcribing.index) {
        final success = await _transcribe();
        if (!success) {
          _handleError(ProcessingStep.transcribing, 'Transcription failed');
          return;
        }
        _updateStep(ProcessingStep.summarizing, 'Summarizing transcription...');
      }

      // Step 3: Summarize
      if (_currentStep.index <= ProcessingStep.summarizing.index) {
        final success = await _summarize();
        if (!success) {
          _handleError(ProcessingStep.summarizing, 'Summarization failed');
          return;
        }
        _updateStep(
          ProcessingStep.vectorizing,
          'Creating vectors for search...',
        );
      }

      // Step 4: Vectorize
      if (_currentStep.index <= ProcessingStep.vectorizing.index) {
        final success = await _vectorize();
        if (!success) {
          _handleError(ProcessingStep.vectorizing, 'Vectorization failed');
          return;
        }
      }

      // Completed
      _updateStep(ProcessingStep.completed, 'Processing complete!');
      await Future.delayed(const Duration(milliseconds: 1000));

      if (mounted) {
        widget.onComplete();
        Navigator.of(context).pop(_updatedRecording);
      }
    } catch (e) {
      _handleError(_currentStep, 'An unexpected error occurred');
    }
  }

  void _handleError(ProcessingStep failedAt, String message) {
    if (mounted) {
      setState(() {
        _currentStep = ProcessingStep.failed;
        _failedStep = failedAt;
        _statusMessage = message;
      });
    }
  }

  void _retry() {
    // Reset to the failed step and restart
    if (_failedStep != null) {
      setState(() {
        _currentStep = _failedStep!;
      });
      _startProcessing();
    }
  }

  void _updateStep(ProcessingStep step, String message) {
    if (mounted) {
      setState(() {
        _currentStep = step;
        _statusMessage = message;
      });
    }
  }

  Future<bool> _transcribe() async {
    try {
      // Skip if already transcribed
      if (_updatedRecording!.transcription.target != null) {
        return true;
      }

      final result = await TranscriptionService.transcribeAudioWithSegments(
        _updatedRecording!.filePath,
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

      // Update the recording with the transcription
      _updatedRecording!.transcription.target = transcription;

      // Save to ObjectBox
      final objectBox = ObjectBoxService.instance;
      objectBox.updateCallRecording(_updatedRecording!);
      return true;
    } catch (e) {
      print('Error during transcription: $e');
      return false;
    }
  }

  Future<bool> _summarize() async {
    try {
      // Skip if already summarized
      if (_updatedRecording!.isSummarized) {
        return true;
      }

      // Get the transcription text
      final transcriptionText =
          _updatedRecording!.transcription.target?.fullText;
      if (transcriptionText == null || transcriptionText.isEmpty) {
        print('No transcription available to summarize');
        return false;
      }

      // Generate summary using Cactus LM
      final summary = await SummarizationService.summarizeTranscription(
        transcriptionText,
        _updatedRecording!,
      );

      if (summary.isEmpty) {
        return false;
      }

      // Extract notes using regex-based extraction (reliable with small models)
      final extractedNotes = NotesExtractionService.extractNotes(transcriptionText);
      print('Extracted notes: ${extractedNotes.length} characters');

      // Fetch the latest recording from ObjectBox to preserve all relationships
      final objectBox = ObjectBoxService.instance;
      final freshRecording = objectBox.getCallRecording(_updatedRecording!.id);

      if (freshRecording == null) {
        print('Recording not found in database');
        return false;
      }

      // Create new recording with updated summary and notes, preserving other fields
      final updatedRecording = CallRecording(
        id: freshRecording.id,
        filePath: freshRecording.filePath,
        fileName: freshRecording.fileName,
        dateReceived: freshRecording.dateReceived,
        size: freshRecording.size,
        summary: summary,
        notes: extractedNotes,
        isSummarized: true,
        isVectorized: freshRecording.isVectorized,
        callLogName: freshRecording.callLogName,
        callLogNumber: freshRecording.callLogNumber,
        callLogTimestamp: freshRecording.callLogTimestamp,
        callLogDuration: freshRecording.callLogDuration,
        callLogType: freshRecording.callLogType,
        contactDisplayName: freshRecording.contactDisplayName,
        contactPhoneNumber: freshRecording.contactPhoneNumber,
      );

      // CRITICAL: Copy the transcription relationship
      updatedRecording.transcription.target =
          freshRecording.transcription.target;

      // Save to ObjectBox - this will update the existing record
      objectBox.updateCallRecording(updatedRecording);

      // Update our local reference
      _updatedRecording = updatedRecording;

      print('Summary saved successfully for recording ${updatedRecording.id}');
      return true;
    } catch (e) {
      print('Error during summarization: $e');
      return false;
    }
  }

  Future<bool> _vectorize() async {
    try {
      // Skip if already vectorized
      if (_updatedRecording!.isVectorized) {
        return true;
      }

      await RagService.generateAndStoreEmbedding(_updatedRecording!);

      // Fetch the latest recording to get the updated vector and isVectorized flag
      final objectBox = ObjectBoxService.instance;
      final freshRecording = objectBox.getCallRecording(_updatedRecording!.id);

      if (freshRecording == null) {
        print('Recording not found in database');
        return false;
      }
      _updatedRecording = freshRecording;
      return true;
    } catch (e) {
      print('Error during vectorization: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Processing Audio',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 32),

              // Progress Steps
              _buildStepIndicator(
                ProcessingStep.linking,
                'Link',
                Icons.link,
                textColor,
                accentColor,
              ),
              _buildStepConnector(textColor, accentColor),
              _buildStepIndicator(
                ProcessingStep.transcribing,
                'Transcribe',
                Icons.mic,
                textColor,
                accentColor,
              ),
              _buildStepConnector(textColor, accentColor),
              _buildStepIndicator(
                ProcessingStep.summarizing,
                'Summarize',
                Icons.article_outlined,
                textColor,
                accentColor,
              ),
              _buildStepConnector(textColor, accentColor),
              _buildStepIndicator(
                ProcessingStep.vectorizing,
                'Vectorize',
                Icons.storage_outlined,
                textColor,
                accentColor,
              ),

              const SizedBox(height: 32),

              // Status message
              Text(
                _statusMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _currentStep == ProcessingStep.failed
                      ? accentColor
                      : textColor.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 24),

              // Retry button if failed
              if (_currentStep == ProcessingStep.failed) ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _retry,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: accentColor, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Text(
                      'RETRY',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(
    ProcessingStep step,
    String label,
    IconData icon,
    Color textColor,
    Color accentColor,
  ) {
    final isCompleted =
        step.index < _currentStep.index ||
        (_failedStep != null &&
            step.index < _failedStep!.index &&
            _currentStep == ProcessingStep.failed);
    final isCurrent =
        step == _currentStep && _currentStep != ProcessingStep.failed;
    final isFailed =
        _failedStep == step && _currentStep == ProcessingStep.failed;

    Color iconColor;
    Color labelColor;

    if (isFailed) {
      iconColor = accentColor;
      labelColor = accentColor;
    } else if (isCompleted) {
      iconColor = accentColor;
      labelColor = textColor;
    } else if (isCurrent) {
      iconColor = accentColor;
      labelColor = accentColor;
    } else {
      iconColor = textColor.withValues(alpha: 0.3);
      labelColor = textColor.withValues(alpha: 0.3);
    }

    return Row(
      children: [
        // Icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: isCompleted || isCurrent
                  ? accentColor
                  : textColor.withValues(alpha: 0.3),
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isFailed
                ? Icon(Icons.close, color: accentColor, size: 20)
                : isCompleted
                ? Icon(Icons.check, color: accentColor, size: 20)
                : isCurrent
                ? _buildDottedLoader(accentColor)
                : Icon(icon, color: iconColor, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        // Label
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: labelColor,
            fontWeight: isCurrent ? FontWeight.w500 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(Color textColor, Color accentColor) {
    final isCompleted = _currentStep.index > 0;

    return Container(
      margin: const EdgeInsets.only(left: 19),
      width: 2,
      height: 24,
      color: isCompleted ? accentColor : textColor.withValues(alpha: 0.3),
    );
  }

  Widget _buildDottedLoader(Color accentColor) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final dotValue = (_animationController.value - delay).clamp(
              0.0,
              1.0,
            );
            final opacity = (dotValue * 2).clamp(0.0, 1.0);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: opacity),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
