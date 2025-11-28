import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_intent/audio_files_screen.dart';
import 'package:flutter_intent/call_recording.dart';
import 'package:flutter_intent/link_audio_dialog.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CallRecording> _audioFiles = [];

  @override
  void initState() {
    init();
    super.initState();
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

      print('Opening link dialog for: $fileName');
      // Show linking bottom sheet
      if (mounted) {
        final result = await showModalBottomSheet<LinkResult>(
          context: context,
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
          backgroundColor: Colors.transparent,
          builder: (context) => LinkAudioDialog(fileName: fileName),
        );

        print('Dialog result: ${result?.type}');
        // Always add the file, even if no link selected (result will be null)
        if (mounted) {
          setState(() {
            _audioFiles.add(
              CallRecording(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                filePath: file.path,
                fileName: fileName,
                dateReceived: lastModified,
                size: stat.size,
                callLog: result?.callLog,
                contact: result?.contact,
              ),
            );
          });
          print('File added to list. Total files: ${_audioFiles.length}');
        }
      }
    }
  }

  void _removeAudioFile(CallRecording file) {
    setState(() {
      _audioFiles.remove(file);
    });
  }

  void _relinkAudioFile(CallRecording oldFile, CallRecording newFile) {
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
