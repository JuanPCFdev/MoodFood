import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/shimmer_box.dart';

class GeneratedDishImage extends StatelessWidget {
  final String imagePrompt;

  const GeneratedDishImage({super.key, required this.imagePrompt});

  String get _imageUrl {
    return 'https://enmicasa.com/wp-content/uploads/2022/05/22-ingredientes-de-chef.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: CachedNetworkImage(
        imageUrl: _imageUrl,
        width: double.infinity,
        height: 140,
        fit: BoxFit.cover,
        placeholder: (context, url) => const ShimmerBox(height: 240),
        errorWidget: (context, url, error) => _ErrorFallback(name: imagePrompt),
        imageBuilder: (context, imageProvider) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image(image: imageProvider, fit: BoxFit.cover),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
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
            ],
          );
        },
      ),
    )
        .animate()
        .fadeIn(duration: 200.ms)
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
      height: 140,
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
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🍽️', style: TextStyle(fontSize: 70))
        ],
      ),
    );
  }
}
