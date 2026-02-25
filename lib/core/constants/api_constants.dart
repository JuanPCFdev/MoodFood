import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  
  static const String geminiModel = 'gemini-2.0-flash';
  
  // Endpoint completo para generar contenido
  static String get generateContentUrl =>
      '$geminiBaseUrl/models/$geminiModel:generateContent?key=$geminiApiKey';
}