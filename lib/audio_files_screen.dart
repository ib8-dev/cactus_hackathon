import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'call_recording.dart';
import 'link_audio_dialog.dart';

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
      final updatedFile = CallRecording(
        id: file.id,
        filePath: file.filePath,
        fileName: file.fileName,
        dateReceived: file.dateReceived,
        size: file.size,
        callLog: result.callLog,
        contact: result.contact,
      );
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
        title: const Text('Audio Files'),
      ),
      body: widget.audioFiles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note_outlined,
                    size: 64,
                    color: textColor.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No audio files yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: textColor.withOpacity(0.5),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Share audio files to this app',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor.withOpacity(0.4),
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
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: textColor.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: file.callLog != null
                        ? _buildCallLogCard(file, textColor, accentColor)
                        : file.contact != null
                            ? _buildContactCard(file, textColor, accentColor)
                            : _buildAudioFileCard(
                                file, textColor, accentColor),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildCallLogCard(
      CallRecording file, Color textColor, Color accentColor) {
    final call = file.callLog!;
    IconData iconData;

    switch (call.callType) {
      case CallType.incoming:
        iconData = Icons.call_received;
        break;
      case CallType.outgoing:
        iconData = Icons.call_made;
        break;
      case CallType.missed:
        iconData = Icons.call_missed;
        break;
      case CallType.rejected:
        iconData = Icons.call_end;
        break;
      default:
        iconData = Icons.call;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(iconData, color: textColor, size: 24),
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
            if (call.number != null && call.number != file.displayName) ...[
              Text(
                call.number!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor.withOpacity(0.6),
                      fontSize: 11,
                    ),
              ),
              const SizedBox(height: 2),
            ],
            Row(
              children: [
                if (call.duration != null) ...[
                  Icon(Icons.timer_outlined,
                      size: 11, color: textColor.withOpacity(0.6)),
                  const SizedBox(width: 4),
                  Text(
                    _formatDuration(call.duration!),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textColor.withOpacity(0.6),
                          fontSize: 11,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text('•',
                        style:
                            TextStyle(color: textColor.withOpacity(0.6))),
                  ),
                ],
                Text(
                  _formatCallTime(call.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: textColor.withOpacity(0.6),
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.link, color: accentColor),
        onPressed: () => _showLinkDialog(file),
      ),
      onTap: () => _showLinkDialog(file),
    );
  }

  Widget _buildContactCard(
      CallRecording file, Color textColor, Color accentColor) {
    final contact = file.contact!;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: contact.photo != null
          ? CircleAvatar(
              backgroundImage: MemoryImage(contact.photo!),
              radius: 24,
            )
          : CircleAvatar(
              backgroundColor: accentColor.withOpacity(0.1),
              radius: 24,
              child: Text(
                contact.displayName.isNotEmpty
                    ? contact.displayName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                    color: accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
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
            if (contact.phones.isNotEmpty) ...[
              Text(
                contact.phones.first.number,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor.withOpacity(0.6),
                      fontSize: 11,
                    ),
              ),
              const SizedBox(height: 2),
            ],
            Row(
              children: [
                Icon(Icons.audiotrack,
                    size: 11, color: textColor.withOpacity(0.6)),
                const SizedBox(width: 4),
                Text(
                  _formatFileSize(file.size),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: textColor.withOpacity(0.6),
                        fontSize: 11,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text('•',
                      style: TextStyle(color: textColor.withOpacity(0.6))),
                ),
                Text(
                  _formatDate(file.dateReceived),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: textColor.withOpacity(0.6),
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.link, color: accentColor),
        onPressed: () => _showLinkDialog(file),
      ),
      onTap: () => _showLinkDialog(file),
    );
  }

  Widget _buildAudioFileCard(
      CallRecording file, Color textColor, Color accentColor) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(Icons.audiotrack, color: accentColor),
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
                    color: textColor.withOpacity(0.6),
                    fontSize: 11,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child:
                  Text('•', style: TextStyle(color: textColor.withOpacity(0.6))),
            ),
            Text(
              _formatDate(file.dateReceived),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor.withOpacity(0.6),
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.link_off, color: textColor.withOpacity(0.4)),
        onPressed: () => _showLinkDialog(file),
      ),
      onTap: () => _showLinkDialog(file),
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
