import 'dart:io';
import 'package:video_compress/video_compress.dart';

class VideoCompressApi{
  static Future<MediaInfo?>compressVideo(File file)async{
    MediaInfo? mediaInfo  = MediaInfo(path: file.path);
    try{
      await VideoCompress.setLogLevel(0);
      final mFile = await VideoCompress.compressVideo(
        file.path,
        quality:VideoQuality.LowQuality,
        includeAudio: true,
        deleteOrigin: true,
        startTime: 0,
        duration: 10,
        frameRate: 30,
      );
      print(mFile!.toJson());
      return mediaInfo;

    }catch(e){
      print('error');
      print(e);
      VideoCompress.cancelCompression();
    }
    return mediaInfo;

  }



}