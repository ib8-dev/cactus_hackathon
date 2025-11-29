import 'package:flutter/material.dart';
import 'package:flutter_intent/cactus_controller.dart';
import 'package:flutter_intent/home_screen.dart';
import 'package:flutter_intent/objectbox_service.dart';
import 'package:flutter_intent/demo_data_loader.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  int currentModelIndex = 0;
  double progress = 0.0;

  final List<ModelDownload> models = [
    ModelDownload(
      name: 'LFM',
      description: 'Language Model',
      color: Color(0xFFD71920),
      modelKey: CactusController.languageModel,
    ),
    ModelDownload(
      name: 'Whisper',
      description: 'Speech Recognition',
      color: Color(0xFF000000),
      modelKey: CactusController.sttModel,
    ),
    ModelDownload(
      name: 'Qwen',
      description: 'Embeddings',
      color: Color(0xFF6B6B6B),
      modelKey: CactusController.embeddingModel,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startMockDownload();
  }

  void _startMockDownload() async {
    // Download models one by one
    for (int i = 0; i < models.length; i++) {
      setState(() {
        currentModelIndex = i;
        progress = 0.0;
      });

      final model = models[i];

      // Download based on model type
      if (model.modelKey == CactusController.sttModel) {
        // Download STT model (Whisper)
        await CactusController.cactusSTT.download(
          model: model.modelKey,
          downloadProcessCallback: (downloadProgress, statusMessage, isError) {
            print(
              'STT Progress: $downloadProgress, Status: $statusMessage, Error: $isError',
            );
            if (mounted && downloadProgress != null) {
              setState(() {
                progress = downloadProgress > 1
                    ? downloadProgress / 100
                    : downloadProgress;
              });
            }
          },
        );
      } else {
        // Download LM models (LFM and Qwen)
        await CactusController.cactusLM.downloadModel(
          model: model.modelKey,
          downloadProcessCallback: (downloadProgress, statusMessage, isError) {
            print(
              'LM Progress: $downloadProgress, Status: $statusMessage, Error: $isError',
            );
            if (mounted && downloadProgress != null) {
              setState(() {
                progress = downloadProgress > 1
                    ? downloadProgress / 100
                    : downloadProgress;
              });
            }
          },
        );
      }
    }

    // Load demo data without embeddings after all downloads complete
    if (mounted) {
      try {
        final objectBox = ObjectBoxService.instance;

        // Clear any existing demo data
        await DemoDataLoader.clearDemoData(objectBox);

        // Load demo data WITHOUT generating embeddings (faster onboarding)
        await DemoDataLoader.loadDemoData(
          objectBox,
          generateEmbeddings: false,
        );

        print('✅ Demo data loaded for onboarding (embeddings will be generated on first search)');
      } catch (e) {
        print('⚠️  Error loading demo data during onboarding: $e');
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // Title
              Text(
                'Call (R)',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 3),

              // Status text above loaders
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Setting things up...',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
              ),

              // Three model loaders stacked
              ...List.generate(models.length, (index) {
                final model = models[index];
                final isCompleted = index < currentModelIndex;
                final isActive = index == currentModelIndex;
                final isPending = index > currentModelIndex;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: ModelLoader(
                    model: model,
                    progress: isActive ? progress : (isCompleted ? 1.0 : 0.0),
                    isCompleted: isCompleted,
                    isActive: isActive,
                    isPending: isPending,
                  ),
                );
              }),

              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class ModelLoader extends StatelessWidget {
  final ModelDownload model;
  final double progress;
  final bool isCompleted;
  final bool isActive;
  final bool isPending;

  const ModelLoader({
    super.key,
    required this.model,
    required this.progress,
    required this.isCompleted,
    required this.isActive,
    required this.isPending,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Model name and status
        Row(
          children: [
            // Status indicator
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isPending ? Colors.grey[300] : model.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            // Model name
            Text(
              model.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isPending ? Colors.grey[400] : Colors.grey[900],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Description and percentage
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                model.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isPending ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              if (isActive || isCompleted)
                Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Progress bar
        DottedProgressBar(
          progress: progress,
          color: model.color,
          isActive: isActive,
        ),
      ],
    );
  }
}

class DottedProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  final bool isActive;

  const DottedProgressBar({
    super.key,
    required this.progress,
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    const double dotSize = 4.0;
    const double dotSpacing = 2.0;

    return SizedBox(
      height: dotSize,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final totalDots = (availableWidth / (dotSize + dotSpacing)).floor();

          return Row(
            children: List.generate(totalDots, (index) {
              final isFilled = index < (totalDots * progress).round();

              return Container(
                width: dotSize,
                height: dotSize,
                margin: EdgeInsets.only(
                  right: index < totalDots - 1 ? dotSpacing : 0,
                ),
                decoration: BoxDecoration(
                  color: isFilled ? color : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class ModelDownload {
  final String name;
  final String description;
  final Color color;
  final String modelKey;

  ModelDownload({
    required this.name,
    required this.description,
    required this.color,
    required this.modelKey,
  });
}
