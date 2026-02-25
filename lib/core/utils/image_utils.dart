import 'dart:convert';
import 'dart:io';

class ImageUtils {
  /// Convierte un archivo de imagen a base64 para enviarlo a Gemini
  static Future<String> fileToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }

  /// Obtiene el mimeType según la extensión
  static String getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
  }
}