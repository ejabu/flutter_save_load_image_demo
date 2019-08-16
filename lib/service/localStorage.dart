import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  String getFileExt(File imageData) {
    String fullFilename = imageData.uri.pathSegments.last;
    String extension = fullFilename.split(".").last;
    return extension;
  }

  Future<File> _getLocalFile({String filename}) async {
    var dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$filename');
  }

  // Loading Image File
  Future<File> loadImageLocal({String imageFilename}) async {
      final file = await _getLocalFile(filename: imageFilename);
      if (!file.existsSync()){
        throw FormatException("does not exist");
      }
      return file;
  }

  // Saving Image File
  Future<File> saveImageLocal({File imageData, String newFilename}) async {
    final file = await _getLocalFile(filename: newFilename);
    File result = await file.writeAsBytes(imageData.readAsBytesSync());
    return result;
  }
}
