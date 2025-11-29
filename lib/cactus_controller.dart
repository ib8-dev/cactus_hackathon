import 'package:cactus/cactus.dart';

class CactusController {
  static String languageModel = 'lfm2-700m';
  static String embeddingModel = 'qwen3-0.6-embed';
  static String sttModel = 'whisper-base';
  static CactusLM cactusLM = CactusLM();
  static CactusSTT cactusSTT = CactusSTT();
  static CactusRAG cactusRAG = CactusRAG();

  static get isSTTModelDownloaded async =>
      await DownloadService.modelExists(sttModel);

  static get isLanguageModelDownloaded async =>
      await DownloadService.modelExists(languageModel);

  static get isEmbeddingModelDownloaded async =>
      await DownloadService.modelExists(embeddingModel);

  static Future<bool> isDownloadCompleted() async {
    var lm = await isLanguageModelDownloaded;
    var em = await isEmbeddingModelDownloaded;
    var stt = await isSTTModelDownloaded;

    return lm && em && stt;
  }

  static Future<void> download() async {
    await cactusSTT.download(
      model: sttModel,
      downloadProcessCallback: (progress, statusMessage, isError) {},
    );

    await cactusLM.downloadModel(
      model: languageModel,
      downloadProcessCallback: (progress, statusMessage, isError) {},
    );

    await cactusLM.downloadModel(
      model: embeddingModel,
      downloadProcessCallback: (progress, statusMessage, isError) {},
    );
  }
}
