import 'package:flutter/material.dart';
import 'package:flutter_intent/call_recording.dart';
import 'package:flutter_intent/rag_service.dart';
import 'package:flutter_intent/recording_detail_bottom_sheet.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  bool _isSearching = false;
  bool _isGeneratingSummary = false;
  String _searchQuery = '';
  String _searchSummary = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _searchQuery = '';
        _searchSummary = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchQuery = query;
      _searchSummary = '';
    });

    try {
      final results = await RagService.searchCalls(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });

      // Generate summary after getting results
      if (results.isNotEmpty) {
        _generateSummary(query, results);
      }
    } catch (e) {
      print('Search error: $e');
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _generateSummary(String query, List<SearchResult> results) async {
    setState(() {
      _isGeneratingSummary = true;
    });

    try {
      final summary = await RagService.generateSearchSummary(query, results);
      setState(() {
        _searchSummary = summary;
        _isGeneratingSummary = false;
      });
    } catch (e) {
      print('Summary generation error: $e');
      setState(() {
        _isGeneratingSummary = false;
      });
    }
  }

  void _showRecordingDetail(CallRecording recording) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecordingDetailBottomSheet(recording: recording),
    );
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
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Calls'),
        backgroundColor: backgroundColor,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: textColor.withValues(alpha: 0.2), width: 2),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onSubmitted: _performSearch,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                  ),
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: TextStyle(
                  color: textColor.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
                prefixIcon: Icon(Icons.search, color: accentColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: textColor.withValues(alpha: 0.5)),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: textColor.withValues(alpha: 0.3), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: textColor.withValues(alpha: 0.3), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: accentColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // AI Summary Section
          if (_searchSummary.isNotEmpty || _isGeneratingSummary)
            Container(
              margin: const EdgeInsets.all(16),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3, // Max 30% of screen
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.05),
                border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 2),
              ),
              child: _isGeneratingSummary
                  ? Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: accentColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Generating summary...',
                          style: TextStyle(
                            fontSize: 13,
                            color: textColor.withValues(alpha: 0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.auto_awesome, color: accentColor, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'AI SUMMARY',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _searchSummary,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: textColor,
                                ),
                          ),
                        ],
                      ),
                    ),
            ),

          // Search Results
          Expanded(
            child: _isSearching
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: accentColor),
                        const SizedBox(height: 16),
                        Text(
                          'Searching...',
                          style: TextStyle(
                            fontSize: 13,
                            color: textColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  )
                : _searchResults.isEmpty && _searchQuery.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: textColor.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No results found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try a different search term',
                              style: TextStyle(
                                fontSize: 13,
                                color: textColor.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      )
                    : _searchQuery.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.manage_search,
                                  size: 64,
                                  color: textColor.withValues(alpha: 0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Search your calls',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor.withValues(alpha: 0.5),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Find conversations by topic or keywords',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textColor.withValues(alpha: 0.4),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final result = _searchResults[index];
                              return _buildSearchResultCard(
                                result,
                                textColor,
                                accentColor,
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(
    SearchResult result,
    Color textColor,
    Color accentColor,
  ) {
    final recording = result.recording;
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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: textColor.withValues(alpha: 0.2), width: 2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Icon(iconData, color: accentColor, size: 24),
        title: Text(
          recording.displayName.toUpperCase(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Matched snippet
            if (result.matchedSnippet != null)
              Text(
                result.matchedSnippet!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: textColor.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 8),
            // Metadata
            Row(
              children: [
                Icon(Icons.schedule, size: 11, color: textColor.withValues(alpha: 0.5)),
                const SizedBox(width: 4),
                Text(
                  _formatDate(recording.dateReceived),
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    border: Border.all(color: accentColor, width: 1),
                  ),
                  child: Text(
                    '${(result.similarity * 100).toStringAsFixed(0)}% match',
                    style: TextStyle(
                      fontSize: 10,
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _showRecordingDetail(recording),
      ),
    );
  }
}

class SearchResult {
  final CallRecording recording;
  final double similarity;
  final String? matchedSnippet;

  SearchResult({
    required this.recording,
    required this.similarity,
    this.matchedSnippet,
  });
}
