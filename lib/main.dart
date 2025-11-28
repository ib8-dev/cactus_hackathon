import 'dart:io';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'audio_files_screen.dart';
import 'call_recording.dart';
import 'link_audio_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final Color textColor = Colors.grey[900]!;

    final nothingTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: Colors.black,
        secondary: Color(0xFFD71920), // Nothing's Red
        surface: Colors.white,
        background: Colors.white,
        onPrimary:
            Colors.white, // Text on primary color (black) should be white
        onSecondary:
            Colors.white, // Text on secondary color (red) should be white
        onSurface:
            textColor, // Text on surface color (white) should be dark grey
        onBackground:
            textColor, // Text on background color (white) should be dark grey
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'DotGothic16',
          color: textColor,
          fontSize: 48,
        ),
        displayMedium: TextStyle(
          fontFamily: 'DotGothic16',
          color: textColor,
          fontSize: 36,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'DotGothic16',
          color: textColor,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          fontFamily: 'DotGothic16',
          color: textColor,
          fontSize: 20,
        ),

        // Default body and title text styles
        bodyLarge: TextStyle(fontFamily: 'IBMPlexMono', color: textColor),
        bodyMedium: TextStyle(fontFamily: 'IBMPlexMono', color: textColor),
        bodySmall: TextStyle(fontFamily: 'IBMPlexMono', color: textColor),
        titleMedium: TextStyle(fontFamily: 'IBMPlexMono', color: textColor),
        titleSmall: TextStyle(fontFamily: 'IBMPlexMono', color: textColor),
        labelLarge: TextStyle(fontFamily: 'IBMPlexMono', color: textColor),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'DotGothic16',
          color: textColor,
          fontSize: 22,
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFD71920),
        unselectedItemColor: textColor,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
      iconTheme: IconThemeData(color: textColor),
    );

    return MaterialApp(
      title: 'Flutter Intent',
      theme: nothingTheme,
      darkTheme:
          nothingTheme, // Still providing a darkTheme for completeness, but themeMode.light will override.
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}

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
