import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/image_utils.dart';
import '../models/recipe_model.dart';

final geminiDatasourceProvider = Provider<GeminiDatasource>((ref) {
  return GeminiDatasource(ref.read(dioClientProvider));
});

class GeminiDatasource {
  final DioClient _dioClient;

  GeminiDatasource(this._dioClient);

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

  Map<String, String> get _authHeader => {
        'Authorization': 'Bearer ${ApiConstants.openRouterApiKey}',
      };

  Future<RecipeModel> generateFromIngredients(List<String> ingredients) async {
    try {
      final body = {
        'model': ApiConstants.model,
        'messages': [
          {
            'role': 'user',
            'content': '$_systemPrompt\n\nIngredientes disponibles: ${ingredients.join(', ')}',
          },
        ],
        'temperature': 0.7,
        'max_tokens': 2048,
      };

      final response = await _dioClient.post(
        ApiConstants.chatEndpoint,
        data: body,
        headers: _authHeader,
      );

      return _parseResponse(response.data);
    } on AppFailure {
      rethrow;
    } on DioException catch (e) {
      throw UnknownFailure(e.message ?? '');
    } catch (e) {
      throw const ParseFailure();
    }
  }

  Future<RecipeModel> generateFromImage(File image) async {
    try {
      final base64Image = await ImageUtils.fileToBase64(image);
      final mimeType = ImageUtils.getMimeType(image.path);

      final body = {
        'model': ApiConstants.visionModel,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'image_url',
                'image_url': {'url': 'data:$mimeType;base64,$base64Image'},
              },
              {
                'type': 'text',
                'text': '$_systemPrompt\n\nAnaliza los ingredientes visibles en esta imagen y genera una receta.',
              },
            ],
          },
        ],
        'temperature': 0.7,
        'max_tokens': 2048,
      };

      final response = await _dioClient.post(
        ApiConstants.chatEndpoint,
        data: body,
        headers: _authHeader,
      );

      return _parseResponse(response.data);
    } on AppFailure {
      rethrow;
    } on DioException catch (e) {
      throw UnknownFailure(e.message ?? '');
    } catch (e) {
      throw const ParseFailure();
    }
  }

  RecipeModel _parseResponse(dynamic responseData) {
    try {
      final text =
          responseData['choices'][0]['message']['content'] as String;

      final cleanJson = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final jsonMap = jsonDecode(cleanJson) as Map<String, dynamic>;
      return RecipeModel.fromJson(jsonMap);
    } catch (_) {
      throw const ParseFailure();
    }
  }
}
