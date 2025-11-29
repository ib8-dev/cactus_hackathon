import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class FileService {
  /// Copies a shared file to the app's documents directory and returns the new path
  static Future<String> copyFileToAppDirectory(String sourcePath) async {
    try {
      final sourceFile = File(sourcePath);

      if (!await sourceFile.exists()) {
        throw Exception('Source file does not exist: $sourcePath');
      }

      // Get the app's documents directory
      final appDir = await getApplicationDocumentsDirectory();

      // Create a subdirectory for call recordings
      final recordingsDir = Directory(p.join(appDir.path, 'recordings'));
      if (!await recordingsDir.exists()) {
        await recordingsDir.create(recursive: true);
      }

      // Generate a unique filename using timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = p.extension(sourcePath);
      final fileName = p.basenameWithoutExtension(sourcePath);
      final newFileName = '${fileName}_$timestamp$extension';

      // Create the destination path
      final destinationPath = p.join(recordingsDir.path, newFileName);

      // Copy the file
      final newFile = await sourceFile.copy(destinationPath);

      return newFile.path;
    } catch (e) {
      print('Error copying file: $e');
      rethrow;
    }
  }

  /// Deletes a file from the app's directory
  static Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  /// Gets the size of a file in bytes
  static Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final stat = await file.stat();
        return stat.size;
      }
      return 0;
    } catch (e) {
      print('Error getting file size: $e');
      return 0;
    }
  }
}
