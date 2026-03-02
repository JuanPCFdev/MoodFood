import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get openRouterApiKey => dotenv.env['OPENROUTER_API_KEY'] ?? '';

  static const String baseUrl = 'https://openrouter.ai/api/v1';

  // Modelo de texto (no soporta system role ni imágenes)
  static const String model = 'google/gemma-3-4b-it:free';

  // Modelo de visión para el flujo de foto
  static const String visionModel = 'mistralai/mistral-small-3.1-24b-instruct:free';

  static const String chatEndpoint = '$baseUrl/chat/completions';
}
