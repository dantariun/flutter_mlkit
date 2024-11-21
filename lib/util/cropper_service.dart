import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CropperService {
  static const _side = 1800;

  static Future<File> cropImageFile(String path, List<dynamic> rect) async {
    final image = await img.decodeImageFile(path);
    if (image == null) throw Exception('Unable to decode image');
    // final croppedImage = img.copyResizeCropSquare(image, size: _side);
    final croppedImage = img.copyCrop(
      image,
      x: rect[0],
      y: rect[1],
      width: rect[2] - rect[0],
      height: rect[3] - rect[1],
    );
    final croppedFile = await _convertImageToFile(croppedImage, path);
    return croppedFile;
  }

  static Future<File> _convertImageToFile(img.Image image, String path) async {
    final newPath = await _croppedFilePath(path);
    final jpegBytes = img.encodeJpg(image);

    final convertedFile = await File(newPath).writeAsBytes(jpegBytes);
    await File(path).delete();
    return convertedFile;
  }

  static Future<String> _croppedFilePath(String path) async {
    final tempDir = await getTemporaryDirectory();
    return join(
      tempDir.path,
      '${basenameWithoutExtension(path)}_compressed.jpg',
    );
  }
}
