import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'call_recording.dart';
import 'link_audio_dialog.dart';
import 'recording_detail_bottom_sheet.dart';
import 'processing_bottom_sheet.dart';
import 'search_screen.dart';
import 'demo_data_loader.dart';
import 'objectbox_service.dart';

class AudioFilesScreen extends StatefulWidget {
  final List<CallRecording> audioFiles;
  final Function(CallRecording) onFileRemove;
  final Function(CallRecording, CallRecording) onFileRelink;

  const AudioFilesScreen({
    super.key,
    required this.audioFiles,
    required this.onFileRemove,
    required this.onFileRelink,
  });

  @override
  State<AudioFilesScreen> createState() => _AudioFilesScreenState();
}

class _AudioFilesScreenState extends State<AudioFilesScreen> {
  bool _showDemoData = false;
  List<CallRecording> _demoRecordings = [];
  bool _isDemoLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPersistedDemoData();
  }

  Future<void> _loadPersistedDemoData() async {
    try {
      final objectBox = ObjectBoxService.instance;
      final allRecordings = objectBox.getAllCallRecordings();
      final demoRecordings = allRecordings.where((r) => r.isDemoData).toList();

      if (demoRecordings.isNotEmpty && mounted) {
        setState(() {
          _demoRecordings = demoRecordings;
        });
        print('📦 Loaded ${demoRecordings.length} persisted demo recordings');
      }
    } catch (e) {
      print('Error loading persisted demo data: $e');
    }
  }

  List<CallRecording> get _displayedFiles {
    if (_showDemoData) {
      return _demoRecordings;
    } else {
      // Ensure we only show real user data (filter out any demo data)
      return widget.audioFiles.where((r) => !r.isDemoData).toList();
    }
  }

  Future<void> _toggleDemoData() async {
    if (_isDemoLoading) return;

    setState(() {
      _isDemoLoading = true;
    });

    try {
      final objectBox = ObjectBoxService.instance;

      if (!_showDemoData) {
        // Load demo data from ObjectBox (if already exists)
        final allRecordings = objectBox.getAllCallRecordings();
        _demoRecordings = allRecordings.where((r) => r.isDemoData).toList();

        print(
          '🎬 Demo mode ON: ${_demoRecordings.length} demo calls | ${DemoDataLoader.getRealDataCount(objectBox)} real calls',
        );
      } else {
        print(
          '📱 Demo mode OFF: ${DemoDataLoader.getRealDataCount(objectBox)} real calls',
        );
      }

      setState(() {
        _showDemoData = !_showDemoData;
        _isDemoLoading = false;
      });
    } catch (e) {
      print('Error toggling demo data: $e');
      setState(() {
        _isDemoLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading demo data: $e')));
      }
    }
  }

  void _showDetailSheet(CallRecording file) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecordingDetailBottomSheet(recording: file),
    );
  }

  void _showProcessingSheet(CallRecording file) async {
    // The ProcessingBottomSheet automatically determines which step to start from
    // based on what's already completed (transcription, summary, vectorization)
    final updatedRecording = await showModalBottomSheet<CallRecording>(
      context: context,
      isScrollControlled: false,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          ProcessingBottomSheet(recording: file, onComplete: () {}),
    );

    if (updatedRecording != null && mounted) {
      // Trigger parent to refresh the list
      widget.onFileRelink(file, updatedRecording);
    }
  }

  void _showLinkDialog(CallRecording file) async {
    final result = await showModalBottomSheet<LinkResult>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LinkAudioDialog(fileName: file.fileName),
    );

    if (result != null && mounted) {
      CallRecording updatedFile;
      if (result.callLog != null) {
        updatedFile = CallRecording.fromCallLog(
          id: file.id,
          filePath: file.filePath,
          fileName: file.fileName,
          dateReceived: file.dateReceived,
          size: file.size,
          callLog: result.callLog!,
          summary: file.summary,
          isSummarized: file.isSummarized,
          isVectorized: file.isVectorized,
          notes: file.notes,
        );
      } else if (result.contact != null) {
        updatedFile = CallRecording.fromContact(
          id: file.id,
          filePath: file.filePath,
          fileName: file.fileName,
          dateReceived: file.dateReceived,
          size: file.size,
          contact: result.contact!,
          summary: file.summary,
          isSummarized: file.isSummarized,
          isVectorized: file.isVectorized,
          notes: file.notes,
        );
      } else {
        updatedFile = CallRecording(
          id: file.id,
          filePath: file.filePath,
          fileName: file.fileName,
          dateReceived: file.dateReceived,
          size: file.size,
          summary: file.summary,
          isSummarized: file.isSummarized,
          isVectorized: file.isVectorized,
          notes: file.notes,
        );
      }

      // CRITICAL: Preserve the transcription and vectors relationships
      updatedFile.transcription.target = file.transcription.target;
      updatedFile.vectors.addAll(file.vectors);

      widget.onFileRelink(file, updatedFile);
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final fileDate = DateTime(date.year, date.month, date.day);

    if (fileDate == today) {
      return 'Today ${DateFormat('HH:mm').format(date)}';
    } else if (fileDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${DateFormat('HH:mm').format(date)}';
    } else {
      return DateFormat('MMM dd, HH:mm').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Call Recordings'),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _isDemoLoading ? null : _toggleDemoData,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _showDemoData
                        ? accentColor
                        : textColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Demo',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _showDemoData
                            ? accentColor
                            : textColor.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _isDemoLoading
                        ? SizedBox(
                            width: 36,
                            height: 20,
                            child: Center(
                              child: SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: accentColor,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: 36,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _showDemoData
                                  ? accentColor
                                  : textColor.withValues(alpha: 0.2),
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 200),
                              alignment: _showDemoData
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: accentColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: _displayedFiles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note_outlined,
                    size: 64,
                    color: textColor.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No recordings yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: textColor.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Share audio files to this app',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textColor.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _displayedFiles.length,
              itemBuilder: (context, index) {
                final file = _displayedFiles[index];
                return Dismissible(
                  key: Key(file.filePath),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: accentColor,
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    widget.onFileRemove(file);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: textColor.withValues(alpha: 0.2),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: file.callLogNumber != null
                        ? _buildCallLogCard(file, textColor, accentColor)
                        : file.contactPhoneNumber != null
                        ? _buildContactCard(file, textColor, accentColor)
                        : _buildAudioFileCard(file, textColor, accentColor),
                  ),
                );
              },
            ),
      // floatingActionButton: kDebugMode
      //     ? _buildDebugFAB(textColor, accentColor)
      //     : null,
    );
  }

  Widget? _buildDebugFAB(Color textColor, Color accentColor) {
    try {
      final objectBox = ObjectBoxService.instance;
      final demoCount = DemoDataLoader.getDemoDataCount(objectBox);
      final hasDemoData = demoCount > 0;

      return FloatingActionButton.extended(
        onPressed: () async {
          if (hasDemoData) {
            // Clear demo data
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('🧹 Clear Demo Data'),
                content: Text(
                  'Remove $demoCount demo recordings from database?\n\n'
                  'Real user recordings will NOT be affected.\n\n'
                  '(Debug Mode Only)',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Clear'),
                  ),
                ],
              ),
            );

            if (confirmed == true && mounted) {
              await DemoDataLoader.clearDemoData(objectBox);
              setState(() {
                _demoRecordings.clear();
                _showDemoData = false;
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('🗑️ Cleared $demoCount demo recordings'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }
          } else {
            // Load demo data
            setState(() {
              _isDemoLoading = true;
            });

            try {
              await DemoDataLoader.clearDemoData(objectBox);

              // Show message that embeddings are being generated
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '🎬 Loading demo data and generating embeddings...',
                    ),
                    backgroundColor: Colors.blue,
                    duration: Duration(seconds: 2),
                  ),
                );
              }

              _demoRecordings = await DemoDataLoader.loadDemoData(
                objectBox,
                generateEmbeddings: false,
              );

              setState(() {
                _isDemoLoading = false;
              });

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '✅ Loaded ${_demoRecordings.length} demo calls with RAG search enabled',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              setState(() {
                _isDemoLoading = false;
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error loading demo data: $e')),
                );
              }
            }
          }
        },
        backgroundColor: hasDemoData
            ? Colors.red.shade400
            : Colors.blue.shade400,
        icon: Icon(hasDemoData ? Icons.delete_sweep : Icons.download),
        label: Text(
          hasDemoData ? 'Clear Demo ($demoCount)' : 'Load Demo',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    } catch (e) {
      // ObjectBox not initialized yet
      return null;
    }
  }

  Widget _buildCallLogCard(
    CallRecording file,
    Color textColor,
    Color accentColor,
  ) {
    // Check if fully processed: transcribed, summarized, AND vectorized
    final isProcessed =
        file.transcription.target != null &&
        file.isSummarized &&
        file.isVectorized;
    final iconColor = isProcessed
        ? accentColor
        : textColor.withValues(alpha: 0.3);

    IconData iconData;

    switch (file.callLogType) {
      case 'incoming':
        iconData = Icons.call_received;
        break;
      case 'outgoing':
        iconData = Icons.call_made;
        break;
      case 'missed':
        iconData = Icons.call_missed;
        break;
      case 'rejected':
        iconData = Icons.call_end;
        break;
      default:
        iconData = Icons.call;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      leading: Icon(iconData, color: iconColor, size: 20),
      title: Text(
        file.displayName.toUpperCase(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (file.callLogNumber != null &&
                file.callLogNumber != file.displayName) ...[
              Text(
                file.callLogNumber!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
            ],
            Row(
              children: [
                if (file.callLogDuration != null) ...[
                  Icon(
                    Icons.timer_outlined,
                    size: 11,
                    color: textColor.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDuration(file.callLogDuration!),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      '•',
                      style: TextStyle(color: textColor.withValues(alpha: 0.6)),
                    ),
                  ),
                ],
                Text(
                  _formatCallTime(file.callLogTimestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.link, color: iconColor),
        onPressed: () => _showLinkDialog(file),
      ),
      onTap: () =>
          isProcessed ? _showDetailSheet(file) : _showProcessingSheet(file),
    );
  }

  Widget _buildContactCard(
    CallRecording file,
    Color textColor,
    Color accentColor,
  ) {
    // Check if fully processed: transcribed, summarized, AND vectorized
    final isProcessed =
        file.transcription.target != null &&
        file.isSummarized &&
        file.isVectorized;
    final avatarColor = isProcessed
        ? accentColor
        : textColor.withValues(alpha: 0.3);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: avatarColor.withValues(alpha: 0.1),
        radius: 24,
        child: Text(
          file.contactDisplayName != null && file.contactDisplayName!.isNotEmpty
              ? file.contactDisplayName![0].toUpperCase()
              : '?',
          style: TextStyle(
            color: avatarColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      title: Text(
        file.displayName,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (file.contactPhoneNumber != null) ...[
              Text(
                file.contactPhoneNumber!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
            ],
            Row(
              children: [
                Icon(
                  Icons.audiotrack,
                  size: 11,
                  color: textColor.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  _formatFileSize(file.size),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '•',
                    style: TextStyle(color: textColor.withValues(alpha: 0.6)),
                  ),
                ),
                Text(
                  _formatDate(file.dateReceived),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.link, color: avatarColor),
        onPressed: () => _showLinkDialog(file),
      ),
      onTap: () =>
          isProcessed ? _showDetailSheet(file) : _showProcessingSheet(file),
    );
  }

  Widget _buildAudioFileCard(
    CallRecording file,
    Color textColor,
    Color accentColor,
  ) {
    // Check if fully processed: transcribed, summarized, AND vectorized
    final isProcessed =
        file.transcription.target != null &&
        file.isSummarized &&
        file.isVectorized;
    final iconColor = isProcessed
        ? accentColor
        : textColor.withValues(alpha: 0.3);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(Icons.audiotrack, color: iconColor),
      ),
      title: Text(
        file.fileName,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Text(
              _formatFileSize(file.size),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                '•',
                style: TextStyle(color: textColor.withValues(alpha: 0.6)),
              ),
            ),
            Text(
              _formatDate(file.dateReceived),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.link_off, color: textColor.withValues(alpha: 0.4)),
        onPressed: () => _showLinkDialog(file),
      ),
      onTap: () =>
          isProcessed ? _showDetailSheet(file) : _showProcessingSheet(file),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds.remainder(60);
    return '${minutes}m ${secs}s';
  }

  String _formatCallTime(int? timestamp) {
    if (timestamp == null) return 'N/A';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final callDate = DateTime(date.year, date.month, date.day);

    if (callDate == today) {
      return 'Today ${DateFormat('HH:mm').format(date)}';
    } else if (callDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${DateFormat('HH:mm').format(date)}';
    } else {
      return DateFormat('MMM dd, HH:mm').format(date);
    }
  }
}
