
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MovingGradientBackground extends StatelessWidget {
  const MovingGradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base light grey
        Container(color: const Color(0xFFF9F9F9)),
        
        // Animated Gradient Layer 1
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color(0xFFE0E0E0),
                  Colors.white,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .shimmer(duration: 15.seconds, color: Colors.black.withOpacity(0.02))
           .blur(begin: const Offset(50, 50), end: const Offset(80, 80), duration: 15.seconds),
        ),

        // Moving Soft Blobs
        _MovingBlob(
          color: Colors.black.withOpacity(0.08),
          size: 700,
          beginOffset: const Offset(-200, -200),
          endOffset: const Offset(150, 150),
          duration: 18.seconds,
        ),
        _MovingBlob(
          color: Colors.black.withOpacity(0.06),
          size: 600,
          beginOffset: const Offset(400, 500),
          endOffset: const Offset(-150, 250),
          duration: 22.seconds,
        ),
        _MovingBlob(
          color: Colors.black.withOpacity(0.04),
          size: 500,
          beginOffset: const Offset(100, 800),
          endOffset: const Offset(600, 400),
          duration: 25.seconds,
        ),
      ],
    );
  }
}

class _MovingBlob extends StatelessWidget {
  final Color color;
  final double size;
  final Offset beginOffset;
  final Offset endOffset;
  final Duration duration;

  const _MovingBlob({
    required this.color,
    required this.size,
    required this.beginOffset,
    required this.endOffset,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: beginOffset.dx,
      top: beginOffset.dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
       .move(begin: Offset.zero, end: endOffset - beginOffset, duration: duration, curve: Curves.easeInOut)
       .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: duration, curve: Curves.easeInOut),
    );
  }
}
