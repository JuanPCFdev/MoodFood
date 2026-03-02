import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

// Función top-level requerida por compute() — corre en un isolate separado.
// Redimensiona a máximo 800px en el lado más largo y comprime a JPEG q70.
// Todo en Dart puro: sin código nativo, sin riesgo de crash del proceso.
Future<String> _resizeAndEncodeImage(String absolutePath) async {
  final bytes = await File(absolutePath).readAsBytes();

  final original = img.decodeImage(bytes);
  if (original == null) {
    // No se pudo decodificar → enviar el raw sin procesar
    return base64Encode(bytes);
  }

  // Redimensionar manteniendo proporción, máximo 800px en el lado más largo
  final resized = img.copyResize(
    original,
    width: original.width >= original.height ? 800 : null,
    height: original.height > original.width ? 800 : null,
    interpolation: img.Interpolation.linear,
  );

  final encoded = img.encodeJpg(resized, quality: 70);
  return base64Encode(encoded);
}

class ImageUtils {
  /// Redimensiona y convierte a base64 en un isolate separado.
  /// No usa código nativo — evita los crashes del proceso.
  static Future<String> fileToBase64(File imageFile) {
    return compute(_resizeAndEncodeImage, imageFile.absolute.path);
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