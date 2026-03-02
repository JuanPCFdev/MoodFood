import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Placeholder de shimmer reutilizable con dimensiones configurables.
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }
}
