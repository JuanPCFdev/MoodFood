import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageUtils {
  /// Comprime y convierte a base64 — listo para Gemini
  static Future<String> fileToBase64(File imageFile) async {
    final compressed = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      quality: 60,
      minWidth: 512,
      minHeight: 512,
    );

    if (compressed == null) {
      // Fallback sin compresión si falla
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    }

    return base64Encode(compressed);
  }

  static String getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png'           => 'image/png',
      'webp'          => 'image/webp',
      _               => 'image/jpeg',
    };
  }
}