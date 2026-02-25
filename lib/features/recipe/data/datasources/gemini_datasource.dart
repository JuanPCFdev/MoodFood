import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/image_utils.dart';
import '../models/recipe_model.dart';

final geminiDatasourceProvider = Provider<GeminiDatasource>((ref) {
  return GeminiDatasource(ref.read(dioClientProvider));
});

class GeminiDatasource {
  final DioClient _dioClient;

  GeminiDatasource(this._dioClient);

  // Prompt maestro que le dice a Gemini exactamente qué formato queremos
  static const String _systemPrompt = '''
Eres un chef profesional. El usuario te dará una lista de ingredientes.
Genera una receta creativa y deliciosa en formato JSON estricto.

RESPONDE SOLO con este JSON, sin markdown, sin explicaciones extra:
{
  "name": "Nombre del plato",
  "description": "Descripción apetitosa en 2 oraciones",
  "ingredients": ["ingrediente 1 con cantidad", "ingrediente 2 con cantidad"],
  "steps": [
    {"stepNumber": 1, "instruction": "Instrucción detallada", "tip": "Tip opcional del chef"},
    {"stepNumber": 2, "instruction": "...", "tip": null}
  ],
  "estimatedTime": "30 minutos",
  "difficulty": "Fácil|Medio|Difícil",
  "imagePrompt": "Professional food photography of [dish name], plated beautifully, restaurant quality, warm lighting"
}
''';

  Future<RecipeModel> generateFromIngredients(List<String> ingredients) async {
    final ingredientsList = ingredients.join(', ');
    
    final body = {
      'contents': [
        {
          'parts': [
            {'text': '$_systemPrompt\n\nIngredientes disponibles: $ingredientsList'}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 2048,
      }
    };

    final response = await _dioClient.post(
      ApiConstants.generateContentUrl,
      data: body,
    );

    return _parseResponse(response.data);
  }

  Future<RecipeModel> generateFromImage(File image) async {
    final base64Image = await ImageUtils.fileToBase64(image);
    final mimeType = ImageUtils.getMimeType(image.path);

    final body = {
      'contents': [
        {
          'parts': [
            {
              'inline_data': {
                'mime_type': mimeType,
                'data': base64Image,
              }
            },
            {
              'text': '$_systemPrompt\n\nAnaliza los ingredientes en esta imagen de nevera/despensa y genera una receta.'
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 2048,
      }
    };

    final response = await _dioClient.post(
      ApiConstants.generateContentUrl,
      data: body,
    );

    return _parseResponse(response.data);
  }

  RecipeModel _parseResponse(Map<String, dynamic> responseData) {
    // Extraer el texto de la respuesta de Gemini
    final text = responseData['candidates'][0]['content']['parts'][0]['text'] as String;
    
    // Limpiar posibles backticks de markdown que Gemini a veces agrega
    final cleanJson = text
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    final jsonMap = jsonDecode(cleanJson) as Map<String, dynamic>;
    return RecipeModel.fromJson(jsonMap);
  }
}