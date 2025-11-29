import 'package:flutter/material.dart';
import 'package:flutter_intent/call_recording.dart';
import 'package:flutter_intent/transcription_service.dart';
import 'package:flutter_intent/objectbox_service.dart';

enum ProcessingStep {
  linking,
  transcribing,
  summarizing,
  vectorizing,
  completed,
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
  ProcessingStep _currentStep = ProcessingStep.linking;
  String _statusMessage = 'Linking audio...';
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
    _startProcessing();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startProcessing() async {
    // Step 1: Linking (already done, just show it)
    await Future.delayed(const Duration(milliseconds: 500));
    _updateStep(ProcessingStep.transcribing, 'Transcribing audio...');

    // Step 2: Transcribe
    await _transcribe();

    // Step 3: Summarize
    _updateStep(ProcessingStep.summarizing, 'Summarizing transcription...');
    await _summarize();

    // Step 4: Vectorize
    _updateStep(ProcessingStep.vectorizing, 'Creating vectors for search...');
    await _vectorize();

    // Completed
    _updateStep(ProcessingStep.completed, 'Processing complete!');
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      widget.onComplete();
      Navigator.of(context).pop(_updatedRecording);
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

  Future<void> _transcribe() async {
    try {
      final transcription = await TranscriptionService.transcribeAudio(
        _updatedRecording!.filePath,
      );

      if (transcription.isNotEmpty) {
        _updatedRecording = CallRecording(
          id: _updatedRecording!.id,
          filePath: _updatedRecording!.filePath,
          fileName: _updatedRecording!.fileName,
          dateReceived: _updatedRecording!.dateReceived,
          size: _updatedRecording!.size,
          transcription: transcription,
          isTranscribed: true,
          callLogName: _updatedRecording!.callLogName,
          callLogNumber: _updatedRecording!.callLogNumber,
          callLogTimestamp: _updatedRecording!.callLogTimestamp,
          callLogDuration: _updatedRecording!.callLogDuration,
          callLogType: _updatedRecording!.callLogType,
          contactDisplayName: _updatedRecording!.contactDisplayName,
          contactPhoneNumber: _updatedRecording!.contactPhoneNumber,
        );

        // Save to ObjectBox
        final objectBox = ObjectBoxService.instance;
        objectBox.updateCallRecording(_updatedRecording!);
      }
    } catch (e) {
      print('Error during transcription: $e');
    }
  }

  Future<void> _summarize() async {
    // TODO: Implement summarization using Cactus LM
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _vectorize() async {
    // TODO: Implement vectorization for RAG
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
      ),
      padding: const EdgeInsets.all(24),
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
                  color: textColor.withOpacity(0.6),
                  fontSize: 12,
                ),
          ),

          const SizedBox(height: 24),
        ],
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
    final isCompleted = step.index < _currentStep.index;
    final isCurrent = step == _currentStep;

    Color iconColor;
    Color labelColor;

    if (isCompleted) {
      iconColor = accentColor;
      labelColor = textColor;
    } else if (isCurrent) {
      iconColor = accentColor;
      labelColor = accentColor;
    } else {
      iconColor = textColor.withOpacity(0.3);
      labelColor = textColor.withOpacity(0.3);
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
                  : textColor.withOpacity(0.3),
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
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
      color: isCompleted ? accentColor : textColor.withOpacity(0.3),
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
            final dotValue = (_animationController.value - delay).clamp(0.0, 1.0);
            final opacity = (dotValue * 2).clamp(0.0, 1.0);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(opacity),
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
