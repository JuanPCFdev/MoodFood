import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../errors/failures.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

class DioClient {
  late final Dio _dio;
  final _logger = Logger();

  DioClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Content-Type': 'application/json'},
        // ← Acepta TODOS los status codes sin lanzar excepción
        // El chequeo lo hacemos nosotros en post()
        validateStatus: (_) => true,
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.d('➡️ REQUEST: ${options.method} ${options.path}');
          handler.next(options); // Solo loguear, nunca lanzar aquí
        },
        onResponse: (response, handler) {
          _logger.d('📨 RESPONSE: ${response.statusCode}');
          if ((response.statusCode ?? 0) >= 400) {
            _logger.e('📨 ERROR BODY: ${response.data}');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.e('❌ DIO ERROR TYPE: ${error.type} | MSG: ${error.message}');
          handler.next(error); // Dejar pasar, lo convertimos en post()
        },
      ),
    );
  }

  /// Único punto donde se convierte status code → AppFailure
  Future<Response> post(
    String url, {
    required Map<String, dynamic> data,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: headers != null ? Options(headers: headers) : null,
      );
      
      _logger.d('✅ STATUS: ${response.statusCode}');

      // Validación manual del status code
      final failure = _failureFromStatus(response.statusCode);
      if (failure != null) {
        _logger.w('⚠️ Failure mapeado: ${failure.message}');
        throw failure;
      }

      return response;
    } on AppFailure {
      rethrow; // Ya está mapeado, dejar pasar
    } on DioException catch (e) {
      _logger.e('❌ DioException: type=${e.type} msg=${e.message}');
      throw _failureFromDioException(e);
    } catch (e) {
      _logger.e('❌ Unexpected: $e');
      throw UnknownFailure(e.toString());
    }
  }

  AppFailure? _failureFromStatus(int? status) {
    if (status == null) return const UnknownFailure('Status code nulo');
    return switch (status) {
      >= 200 && < 300 => null,           // ✅ Éxito
      429             => const RateLimitFailure(),
      413             => const ImageTooLargeFailure(),
      401 || 403      => UnknownFailure('API key inválida o sin permisos ($status)'),
      >= 400 && < 500 => UnknownFailure('Error del cliente: $status'),
      >= 500          => UnknownFailure('Error del servidor: $status'),
      _               => UnknownFailure('Status inesperado: $status'),
    };
  }

  AppFailure _failureFromDioException(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout   ||
      DioExceptionType.sendTimeout      => const TimeoutFailure(),
      DioExceptionType.connectionError  => const NetworkFailure(),
      _                                 => UnknownFailure(e.message ?? 'Error de red desconocido'),
    };
  }
}