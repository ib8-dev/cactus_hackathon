import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl/intl.dart';

enum LinkType { callLog, contact, unknown }

class LinkResult {
  final LinkType type;
  final CallLogEntry? callLog;
  final Contact? contact;

  LinkResult.callLog(this.callLog) : type = LinkType.callLog, contact = null;

  LinkResult.contact(this.contact) : type = LinkType.contact, callLog = null;

  LinkResult.unknown()
    : type = LinkType.unknown,
      callLog = null,
      contact = null;
}

class LinkAudioDialog extends StatefulWidget {
  final String fileName;

  const LinkAudioDialog({super.key, required this.fileName});

  @override
  State<LinkAudioDialog> createState() => _LinkAudioDialogState();
}

class _LinkAudioDialogState extends State<LinkAudioDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<CallLogEntry>? _callLogs;
  List<Contact>? _contacts;
  bool _loadingCalls = true;
  bool _loadingContacts = true;
  String _searchQuery = '';
  bool _isIOS = false;

  @override
  void initState() {
    super.initState();
    _checkPlatform();
    _loadContacts();
  }

  void _checkPlatform() async {
    // Try to load call logs - will fail on iOS
    try {
      final logs = await CallLog.get();
      if (mounted) {
        setState(() {
          _callLogs = logs.toList();
          _loadingCalls = false;
          _isIOS = false;
          // Initialize tab controller based on platform
          _tabController = TabController(length: 2, vsync: this);
        });
      }
    } catch (e) {
      // iOS doesn't support call logs
      if (mounted) {
        setState(() {
          _callLogs = null;
          _loadingCalls = false;
          _isIOS = true;
          // Only 1 tab for iOS (Contacts only)
          _tabController = TabController(length: 1, vsync: this);
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        final contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );
        if (mounted) {
          setState(() {
            _contacts = contacts;
            _loadingContacts = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _contacts = [];
            _loadingContacts = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _contacts = [];
          _loadingContacts = false;
        });
      }
    }
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

  IconData _getCallIcon(CallType? type) {
    switch (type) {
      case CallType.incoming:
        return Icons.call_received;
      case CallType.outgoing:
        return Icons.call_made;
      case CallType.missed:
        return Icons.call_missed;
      case CallType.rejected:
        return Icons.call_end;
      default:
        return Icons.call;
    }
  }

  List<CallLogEntry> _getFilteredCallLogs() {
    if (_callLogs == null) return [];
    if (_searchQuery.isEmpty) return _callLogs!.take(20).toList();

    return _callLogs!
        .where((call) {
          final name = call.name?.toLowerCase() ?? '';
          final number = call.number?.toLowerCase() ?? '';
          final query = _searchQuery.toLowerCase();
          return name.contains(query) ||
              number.contains(query) ||
              call.callType == CallType.incoming ||
              call.callType == CallType.outgoing ||
              call.callType == CallType.voiceMail;
        })
        .take(20)
        .toList();
  }

  List<Contact> _getFilteredContacts() {
    if (_contacts == null) return [];
    if (_searchQuery.isEmpty) return _contacts!.take(20).toList();

    return _contacts!
        .where((contact) {
          final name = contact.displayName.toLowerCase();
          final query = _searchQuery.toLowerCase();
          return name.contains(query) ||
              contact.phones.any((phone) => phone.number.contains(query));
        })
        .take(20)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: textColor.withValues(alpha: 0.2), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: textColor.withValues(alpha: 0.2)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'LINK AUDIO FILE',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: textColor),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.fileName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Search bar
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: TextField(
          //     onChanged: (value) => setState(() => _searchQuery = value),
          //     decoration: InputDecoration(
          //       hintText: 'Search...',
          //       hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //         color: textColor.withValues(alpha: 0.4),
          //       ),
          //       prefixIcon: Icon(
          //         Icons.search,
          //         color: textColor.withValues(alpha: 0.6),
          //         size: 20,
          //       ),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(4),
          //         borderSide: BorderSide(
          //           color: textColor.withValues(alpha: 0.2),
          //         ),
          //       ),
          //       enabledBorder: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(4),
          //         borderSide: BorderSide(
          //           color: textColor.withValues(alpha: 0.2),
          //         ),
          //       ),
          //       focusedBorder: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(4),
          //         borderSide: BorderSide(color: accentColor),
          //       ),
          //       contentPadding: const EdgeInsets.symmetric(
          //         horizontal: 16,
          //         vertical: 12,
          //       ),
          //     ),
          //     style: Theme.of(context).textTheme.bodyMedium,
          //   ),
          // ),

          // Tabs
          if (_loadingCalls)
            const Center(child: CircularProgressIndicator())
          else ...[
            TabBar(
              controller: _tabController,
              labelColor: accentColor,
              unselectedLabelColor: textColor.withValues(alpha: 0.6),
              indicatorColor: accentColor,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              tabs: _isIOS
                  ? const [
                      Tab(text: 'CONTACTS'),
                    ]
                  : const [
                      Tab(text: 'CALL LOGS'),
                      Tab(text: 'CONTACTS'),
                    ],
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _isIOS
                    ? [
                        // Contacts Tab
                        _loadingContacts
                            ? Center(
                                child:
                                    CircularProgressIndicator(color: accentColor),
                              )
                            : _buildContactsList(),
                      ]
                    : [
                        // Call Logs Tab
                        _buildCallLogsList(),

                        // Contacts Tab
                        _loadingContacts
                            ? Center(
                                child:
                                    CircularProgressIndicator(color: accentColor),
                              )
                            : _buildContactsList(),
                      ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCallLogsList() {
    final filteredLogs = _getFilteredCallLogs();
    final textColor = Theme.of(context).colorScheme.onSurface;

    if (filteredLogs.isEmpty) {
      return Center(
        child: Text(
          'No call logs found',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textColor.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredLogs.length,
      itemBuilder: (context, index) {
        final call = filteredLogs[index];
        return InkWell(
          onTap: () => Navigator.of(context).pop(LinkResult.callLog(call)),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: textColor.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(_getCallIcon(call.callType), color: textColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ((call.name != null && call.name!.isNotEmpty)
                                ? call.name
                                : call.number) ??
                            '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatCallTime(call.timestamp),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textColor.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactsList() {
    final filteredContacts = _getFilteredContacts();
    final textColor = Theme.of(context).colorScheme.onSurface;
    final accentColor = Theme.of(context).colorScheme.secondary;

    if (filteredContacts.isEmpty) {
      return Center(
        child: Text(
          'No contacts found',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textColor.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = filteredContacts[index];
        return InkWell(
          onTap: () => Navigator.of(context).pop(LinkResult.contact(contact)),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: textColor.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                contact.photo != null
                    ? CircleAvatar(
                        backgroundImage: MemoryImage(contact.photo!),
                        radius: 18,
                      )
                    : CircleAvatar(
                        backgroundColor: accentColor.withValues(alpha: 0.1),
                        radius: 18,
                        child: Text(
                          contact.displayName.isNotEmpty
                              ? contact.displayName[0].toUpperCase()
                              : '?',
                          style: TextStyle(color: accentColor, fontSize: 14),
                        ),
                      ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.displayName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (contact.phones.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          contact.phones.first.number,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: textColor.withValues(alpha: 0.6),
                                fontSize: 11,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
