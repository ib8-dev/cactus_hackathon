import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_intent/audio_files_screen.dart';
import 'package:flutter_intent/call_recording.dart';
import 'package:flutter_intent/link_audio_dialog.dart';
import 'package:flutter_intent/processing_bottom_sheet.dart';
import 'package:flutter_intent/objectbox_service.dart';
import 'package:flutter_intent/file_service.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CallRecording> _audioFiles = [];
  ObjectBoxService? _objectBox;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeObjectBox();
    init();
  }

  Future<void> _initializeObjectBox() async {
    if (_isInitialized) return;

    _objectBox = await ObjectBoxService.create();
    _isInitialized = true;

    // Load existing recordings after ObjectBox is initialized
    final recordings = _objectBox!.getAllCallRecordings();
    if (mounted) {
      setState(() {
        _audioFiles.addAll(recordings);
      });
    }
  }

  init() async {
    // 1. Listen for audio shared while the app is running in memory
    ReceiveSharingIntent.instance.getMediaStream().listen(
      (List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          _handleSharedAudio(value);
        }
      },
      onError: (err) {
        print("Error receiving audio: $err");
      },
    );

    // 2. Handle audio shared when the app was closed (cold start)
    ReceiveSharingIntent.instance.getInitialMedia().then((
      List<SharedMediaFile> value,
    ) {
      if (value.isNotEmpty) {
        _handleSharedAudio(value);
        // Reset to prevent re-processing on reload
        ReceiveSharingIntent.instance.reset();
      }
    });
  }

  void _handleSharedAudio(List<SharedMediaFile> files) async {
    print('Received ${files.length} files');
    for (var file in files) {
      print('Processing file: ${file.path}');
      final fileInfo = File(file.path);
      final lastModified = await fileInfo.lastModified();
      final stat = await fileInfo.stat();
      final fileName = file.path.split('/').last;

      // Copy file to app directory first
      try {
        print('Copying file to app directory...');
        final newFilePath = await FileService.copyFileToAppDirectory(
          file.path,
        );
        print('File copied to: $newFilePath');

        // Create initial CallRecording object (unlinked)
        CallRecording recording = CallRecording(
          filePath: newFilePath,
          fileName: fileName,
          dateReceived: lastModified,
          size: stat.size,
        );

        // Save to ObjectBox
        await _initializeObjectBox();
        final recordingId = _objectBox!.saveCallRecording(recording);
        recording = CallRecording(
          id: recordingId,
          filePath: recording.filePath,
          fileName: recording.fileName,
          dateReceived: recording.dateReceived,
          size: recording.size,
        );
        print('Recording saved to ObjectBox with id: ${recording.id}');

        // Add to UI list
        if (mounted) {
          setState(() {
            _audioFiles.add(recording);
          });
        }

        // Show processing bottom sheet FIRST (non-blocking)
        if (mounted) {
          showModalBottomSheet<CallRecording>(
            context: context,
            isDismissible: false,
            enableDrag: false,
            backgroundColor: Colors.transparent,
            builder: (context) => ProcessingBottomSheet(
              recording: recording,
              onComplete: () {
                // Refresh UI when processing completes
                if (mounted) {
                  setState(() {
                    final recordings = _objectBox!.getAllCallRecordings();
                    _audioFiles.clear();
                    _audioFiles.addAll(recordings);
                  });
                }
              },
            ),
          );

          // Small delay to ensure processing sheet renders first
          await Future.delayed(const Duration(milliseconds: 300));

          // Then show linking dialog ON TOP of processing sheet
          print('Opening link dialog for: $fileName');
          final result = await showModalBottomSheet<LinkResult>(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            enableDrag: true,
            backgroundColor: Colors.transparent,
            builder: (context) => LinkAudioDialog(fileName: fileName),
          );

          print('Dialog result: ${result?.type}');

          // Update recording with link info if provided
          if (result != null) {
            CallRecording updatedRecording;
            if (result.callLog != null) {
              updatedRecording = CallRecording.fromCallLog(
                id: recording.id,
                filePath: recording.filePath,
                fileName: recording.fileName,
                dateReceived: recording.dateReceived,
                size: recording.size,
                callLog: result.callLog!,
              );
            } else if (result.contact != null) {
              updatedRecording = CallRecording.fromContact(
                id: recording.id,
                filePath: recording.filePath,
                fileName: recording.fileName,
                dateReceived: recording.dateReceived,
                size: recording.size,
                contact: result.contact!,
              );
            } else {
              updatedRecording = recording;
            }

            // Update in ObjectBox
            _objectBox!.updateCallRecording(updatedRecording);

            // Update UI
            if (mounted) {
              setState(() {
                final index = _audioFiles.indexWhere((r) => r.id == recording.id);
                if (index != -1) {
                  _audioFiles[index] = updatedRecording;
                }
              });
            }
          }
        }
      } catch (e) {
        print('Error processing file: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error saving file: $e')));
        }
      }
    }
  }

  void _removeAudioFile(CallRecording file) async {
    // Delete from ObjectBox
    await _initializeObjectBox();
    _objectBox!.deleteCallRecording(file.id);

    // Delete the actual file
    await FileService.deleteFile(file.filePath);

    setState(() {
      _audioFiles.remove(file);
    });
  }

  void _relinkAudioFile(CallRecording oldFile, CallRecording newFile) async {
    // Update in ObjectBox
    await _initializeObjectBox();
    _objectBox!.updateCallRecording(newFile);

    setState(() {
      final index = _audioFiles.indexOf(oldFile);
      if (index != -1) {
        _audioFiles[index] = newFile;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AudioFilesScreen(
        audioFiles: _audioFiles,
        onFileRemove: _removeAudioFile,
        onFileRelink: _relinkAudioFile,
      ),
    );
  }
}
