import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/shimmer_box.dart';

class GeneratedDishImage extends StatelessWidget {
  final String imagePrompt;

  const GeneratedDishImage({super.key, required this.imagePrompt});

  /// Construye la URL de Pollinations.ai con el prompt encodado
  String get _imageUrl {
    final encoded = Uri.encodeComponent(imagePrompt);
    return 'https://image.pollinations.ai/prompt/$encoded?width=800&height=600&nologo=true';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CachedNetworkImage(
        imageUrl: _imageUrl,
        width: double.infinity,
        height: 260,
        fit: BoxFit.cover,
        // Shimmer mientras carga
        placeholder: (context, url) => const ShimmerBox(height: 260),
        // Si falla, fallback elegante
        errorWidget: (context, url, error) => _ErrorFallback(name: imagePrompt),
        imageBuilder: (context, imageProvider) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image(image: imageProvider, fit: BoxFit.cover),
              // Overlay degradado inferior para que el título se lea bien
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.55),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Badge "IA Generada"
              Positioned(
                top: 12,
                right: 12,
                child: _AIBadge(),
              ),
            ],
          );
        },
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.95, 0.95));
  }
}

// ── Fallback si la API falla
class _ErrorFallback extends StatelessWidget {
  final String name;
  const _ErrorFallback({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.secondary.withValues(alpha: 0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🍽️', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Badge "✨ IA Generada"
class _AIBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('✨', style: TextStyle(fontSize: 12)),
              SizedBox(width: 4),
              Text(
                'IA Generada',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}