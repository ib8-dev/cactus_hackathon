import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'call_recording.dart';
import 'transcription.dart';

class RecordingDetailBottomSheet extends StatefulWidget {
  final CallRecording recording;

  const RecordingDetailBottomSheet({super.key, required this.recording});

  @override
  State<RecordingDetailBottomSheet> createState() =>
      _RecordingDetailBottomSheetState();
}

class _RecordingDetailBottomSheetState extends State<RecordingDetailBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AudioPlayer _audioPlayer;
  late ScrollController _scrollController;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Changed to 3 tabs
    _tabController.addListener(_onTabChange);
    _audioPlayer = AudioPlayer();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _initAudioPlayer();
  }

  void _onTabChange() {
    // Reset collapsed state when switching tabs
    // if (_isCollapsed) {
    //   setState(() {
    //     _isCollapsed = false;
    //   });
    // }
  }

  void _onScroll() {
    // Collapse when scrolled down more than 50 pixels
    final shouldCollapse =
        _scrollController.hasClients && _scrollController.offset > 50;
    if (shouldCollapse != _isCollapsed) {
      setState(() {
        _isCollapsed = shouldCollapse;
      });
    }
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayer.setSourceDeviceFile(widget.recording.filePath);

      _audioPlayer.onDurationChanged.listen((duration) {
        if (mounted) {
          setState(() {
            _duration = duration;
          });
        }
      });

      _audioPlayer.onPositionChanged.listen((position) {
        if (mounted) {
          setState(() {
            _position = position;
          });
        }
      });

      _audioPlayer.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state == PlayerState.playing;
          });
        }
      });

      _audioPlayer.onPlayerComplete.listen((_) {
        if (mounted) {
          setState(() {
            _position = Duration.zero;
            _isPlaying = false;
          });
          _audioPlayer.seek(Duration.zero);
        }
      });
    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  Future<void> _seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  String _formatAudioDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return 'N/A';
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds.remainder(60);
    return '${minutes}m ${secs}s';
  }

  String _formatDate(int? timestamp) {
    if (timestamp == null) return 'N/A';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('MMM dd, yyyy • HH:mm').format(date);
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone call')),
        );
      }
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch email app')),
        );
      }
    }
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open URL')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final accentColor = Theme.of(context).colorScheme.secondary;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: textColor.withOpacity(0.2), width: 2),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: textColor.withOpacity(0.3)),
          ),

          // Header - collapsed or expanded
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: _isCollapsed
                ? _buildCollapsedHeader(textColor, accentColor)
                : _buildHeader(textColor, accentColor),
          ),

          // Audio Player - collapsed or expanded
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: _isCollapsed
                ? const SizedBox.shrink()
                : _buildAudioPlayer(textColor, accentColor),
          ),

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: textColor.withOpacity(0.2), width: 2),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: accentColor,
              unselectedLabelColor: textColor.withOpacity(0.5),
              indicatorColor: accentColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              tabs: const [
                Tab(text: 'SUMMARY'),
                Tab(text: 'NOTES'),
                Tab(text: 'TRANSCRIPTION'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTab(textColor, accentColor),
                _buildNotesTab(textColor, accentColor),
                _buildTranscriptionTabContent(textColor, accentColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedHeader(Color textColor, Color accentColor) {
    final recording = widget.recording;
    IconData iconData = Icons.audiotrack;

    if (recording.callLogType != null) {
      switch (recording.callLogType) {
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
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: textColor.withOpacity(0.2), width: 2),
        ),
      ),
      child: Row(
        children: [
          Icon(iconData, color: accentColor, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              recording.displayName.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                border: Border.all(color: accentColor, width: 2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: accentColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color textColor, Color accentColor) {
    final recording = widget.recording;
    IconData iconData = Icons.audiotrack;
    String callType = '';

    if (recording.callLogType != null) {
      switch (recording.callLogType) {
        case 'incoming':
          iconData = Icons.call_received;
          callType = 'INCOMING';
          break;
        case 'outgoing':
          iconData = Icons.call_made;
          callType = 'OUTGOING';
          break;
        case 'missed':
          iconData = Icons.call_missed;
          callType = 'MISSED';
          break;
        case 'rejected':
          iconData = Icons.call_end;
          callType = 'REJECTED';
          break;
        default:
          iconData = Icons.call;
          callType = 'CALL';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact/Name
          Row(
            children: [
              Icon(iconData, color: accentColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  recording.displayName.toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Metadata
          if (recording.callLogNumber != null ||
              recording.contactPhoneNumber != null) ...[
            Text(
              recording.callLogNumber ?? recording.contactPhoneNumber ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Call info
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              if (callType.isNotEmpty) _buildMetadataChip(callType, textColor),
              if (recording.callLogDuration != null)
                _buildMetadataChip(
                  _formatDuration(recording.callLogDuration),
                  textColor,
                ),
              if (recording.callLogTimestamp != null)
                _buildMetadataChip(
                  _formatDate(recording.callLogTimestamp),
                  textColor,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataChip(String label, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: textColor.withOpacity(0.7),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildNotesTab(Color textColor, Color accentColor) {
    // Parse notes from JSON
    Map<String, dynamic>? notes;
    if (widget.recording.notes != null && widget.recording.notes!.isNotEmpty) {
      try {
        notes = jsonDecode(widget.recording.notes!) as Map<String, dynamic>;
      } catch (e) {
        print('Error parsing notes JSON: $e');
      }
    }

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NOTES',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: textColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          _buildNotesContent(notes, textColor, accentColor),
        ],
      ),
    );
  }

  Widget _buildNotesContent(
    Map<String, dynamic>? notes,
    Color textColor,
    Color accentColor,
  ) {
    if (notes == null || notes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'No notes available',
            style: TextStyle(fontSize: 13, color: textColor.withOpacity(0.4)),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (notes['phones'] != null && (notes['phones'] as List).isNotEmpty)
          _buildNoteSection(
            'Phones',
            notes['phones'] as List,
            Icons.phone,
            accentColor,
            textColor,
            onTap: (value) => _makePhoneCall(value),
          ),
        if (notes['emails'] != null && (notes['emails'] as List).isNotEmpty)
          _buildNoteSection(
            'Emails',
            notes['emails'] as List,
            Icons.email,
            accentColor,
            textColor,
            onTap: (value) => _sendEmail(value),
          ),
        if (notes['websites'] != null && (notes['websites'] as List).isNotEmpty)
          _buildNoteSection(
            'Websites',
            notes['websites'] as List,
            Icons.web,
            accentColor,
            textColor,
            onTap: (value) => _openUrl(value),
          ),
        if (notes['money'] != null && (notes['money'] as List).isNotEmpty)
          _buildNoteSection(
            'Money',
            notes['money'] as List,
            Icons.attach_money,
            accentColor,
            textColor,
          ),
        if (notes['dates'] != null && (notes['dates'] as List).isNotEmpty)
          _buildNoteSection(
            'Dates',
            notes['dates'] as List,
            Icons.calendar_today,
            accentColor,
            textColor,
          ),
        if (notes['people'] != null && (notes['people'] as List).isNotEmpty)
          _buildNoteSection(
            'People',
            notes['people'] as List,
            Icons.person,
            accentColor,
            textColor,
          ),
        if (notes['places'] != null && (notes['places'] as List).isNotEmpty)
          _buildNoteSection(
            'Places',
            notes['places'] as List,
            Icons.location_on,
            accentColor,
            textColor,
          ),
        if (notes['other_notes'] != null &&
            (notes['other_notes'] as List).isNotEmpty)
          _buildNoteSection(
            'Other Notes',
            notes['other_notes'] as List,
            Icons.note,
            accentColor,
            textColor,
          ),
      ],
    );
  }

  Widget _buildNoteSection(
    String title,
    List<dynamic> items,
    IconData icon,
    Color accentColor,
    Color textColor, {
    Function(String)? onTap,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: accentColor),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) {
            final value = item['value'] as String;
            final context = item['context'] as String?;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: onTap != null ? () => onTap(value) : null,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: textColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              value,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: onTap != null ? accentColor : textColor,
                              ),
                            ),
                            if (context != null && context.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                context,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (onTap != null)
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: accentColor,
                        )
                      else
                        IconButton(
                          icon: Icon(Icons.copy, size: 16, color: accentColor),
                          onPressed: () => _copyToClipboard(value, title),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryTab(Color textColor, Color accentColor) {
    final summary = widget.recording.summary;

    print('>>>>>> ${summary}');

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SUMMARY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: textColor.withOpacity(0.5),
                ),
              ),
              if (summary != null && summary.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.copy, size: 18, color: accentColor),
                  onPressed: () => _copyToClipboard(summary, 'Summary'),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (summary != null && summary.isNotEmpty)
            Text(
              summary,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.6,
                color: textColor,
              ),
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No summary available',
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withOpacity(0.4),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTranscriptionTabContent(Color textColor, Color accentColor) {
    final transcription = widget.recording.transcription.target;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TRANSCRIPTION',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: textColor.withValues(alpha: 0.5),
                ),
              ),
              if (transcription != null)
                IconButton(
                  icon: Icon(Icons.copy, size: 18, color: accentColor),
                  onPressed: () =>
                      _copyToClipboard(transcription.fullText, 'Transcription'),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (transcription != null)
            _buildSegmentedTranscription(transcription, textColor, accentColor)
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No transcription available',
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSegmentedTranscription(
    Transcription transcription,
    Color textColor,
    Color accentColor,
  ) {
    if (transcription.segments.isEmpty) {
      // Fallback to plain text if no segments
      return Text(
        transcription.fullText,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 13,
          height: 1.7,
          color: textColor,
        ),
      );
    }

    // Build inline highlighted text with segments
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 13,
          height: 1.7,
          color: textColor,
        ),
        children: transcription.segments.map((segment) {
          final isActive = segment.containsPosition(_position);

          return TextSpan(
            text: segment.text + ' ',
            style: TextStyle(
              color: isActive ? accentColor : textColor.withValues(alpha: 0.9),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAudioPlayer(Color textColor, Color accentColor) {
    // final recording = widget.recording;

    // // Determine title based on link status
    // String playerTitle;
    // if (recording.callLogNumber != null) {
    //   playerTitle = 'CALL RECORDING';
    // } else if (recording.contactPhoneNumber != null) {
    //   playerTitle = 'CONTACT RECORDING';
    // } else {
    //   playerTitle = 'AUDIO RECORDING';
    // }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: textColor.withValues(alpha: 0.2), width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          // Text(
          //   playerTitle,
          //   style: TextStyle(
          //     fontSize: 11,
          //     fontWeight: FontWeight.bold,
          //     letterSpacing: 1.2,
          //     color: textColor.withValues(alpha: 0.5),
          //   ),
          // ),
          // const SizedBox(height: 16),

          // Progress bar
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: accentColor,
              inactiveTrackColor: textColor.withValues(alpha: 0.2),
              thumbColor: accentColor,
              overlayColor: accentColor.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: _duration.inMilliseconds > 0
                  ? _position.inMilliseconds.toDouble().clamp(
                      0.0,
                      _duration.inMilliseconds.toDouble(),
                    )
                  : 0.0,
              min: 0,
              max: _duration.inMilliseconds.toDouble() > 0
                  ? _duration.inMilliseconds.toDouble()
                  : 1,
              onChanged: (value) {
                _seekTo(Duration(milliseconds: value.toInt()));
              },
            ),
          ),

          // Time indicators
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatAudioDuration(_position),
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: textColor.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  _formatAudioDuration(_duration),
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: textColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Play/Pause button
          Center(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: accentColor, width: 2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: accentColor,
                  size: 28,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
