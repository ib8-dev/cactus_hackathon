import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'call_recording.dart';
import 'link_audio_dialog.dart';
import 'recording_detail_bottom_sheet.dart';
import 'processing_bottom_sheet.dart';

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
      // Refresh the list by triggering a rebuild
      setState(() {});
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
        );
      } else if (result.contact != null) {
        updatedFile = CallRecording.fromContact(
          id: file.id,
          filePath: file.filePath,
          fileName: file.fileName,
          dateReceived: file.dateReceived,
          size: file.size,
          contact: result.contact!,
        );
      } else {
        updatedFile = CallRecording(
          id: file.id,
          filePath: file.filePath,
          fileName: file.fileName,
          dateReceived: file.dateReceived,
          size: file.size,
        );
      }
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
      appBar: AppBar(title: const Text('Call recordings')),
      body: widget.audioFiles.isEmpty
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
              itemCount: widget.audioFiles.length,
              itemBuilder: (context, index) {
                final file = widget.audioFiles[index];
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
    );
  }

  Widget _buildCallLogCard(
    CallRecording file,
    Color textColor,
    Color accentColor,
  ) {
    final isProcessed = file.transcription.target != null;
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
    final isProcessed = file.transcription.target != null;
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
    final isProcessed = file.transcription.target != null;
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
