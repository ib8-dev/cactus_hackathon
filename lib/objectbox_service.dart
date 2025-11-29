import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'call_recording.dart';
import 'objectbox.g.dart';

class ObjectBoxService {
  late final Store _store;
  late final Box<CallRecording> _callRecordingBox;

  static ObjectBoxService? _instance;
  static bool _isInitializing = false;
  static String? _storePath;

  ObjectBoxService._create(this._store) {
    _callRecordingBox = Box<CallRecording>(_store);
  }

  static Future<ObjectBoxService> create() async {
    // Return existing instance if already created
    if (_instance != null) {
      return _instance!;
    }

    // Wait if currently initializing
    while (_isInitializing) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Check again after waiting
    if (_instance != null) {
      return _instance!;
    }

    _isInitializing = true;
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      _storePath = p.join(docsDir.path, 'objectbox');

      Store store;

      // Try to attach to existing store first
      if (Store.isOpen(_storePath!)) {
        print('ObjectBox store already open, attaching to existing store');
        store = Store.attach(getObjectBoxModel(), _storePath!);
      } else {
        print('Opening new ObjectBox store at: $_storePath');
        store = await openStore(directory: _storePath!);
      }

      _instance = ObjectBoxService._create(store);
      return _instance!;
    } finally {
      _isInitializing = false;
    }
  }

  static ObjectBoxService get instance {
    if (_instance == null) {
      throw Exception('ObjectBoxService not initialized. Call create() first.');
    }
    return _instance!;
  }

  // CallRecording operations
  int saveCallRecording(CallRecording recording) {
    return _callRecordingBox.put(recording);
  }

  List<CallRecording> getAllCallRecordings() {
    return _callRecordingBox.getAll();
  }

  CallRecording? getCallRecording(int id) {
    return _callRecordingBox.get(id);
  }

  bool deleteCallRecording(int id) {
    return _callRecordingBox.remove(id);
  }

  void updateCallRecording(CallRecording recording) {
    _callRecordingBox.put(recording);
  }

  void close() {
    _store.close();
    _instance = null;
  }

  /// Reset the singleton instance (useful for testing or hot reload)
  static void reset() {
    _instance?._store.close();
    _instance = null;
  }
}
