import 'package:flutter/material.dart';

class RwandanFlag extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const RwandanFlag({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 120,
      height: height ?? 80,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: Column(
          children: [
            // Blue stripe
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                color: const Color(0xFF00A1DE), // Rwanda blue
              ),
            ),
            // Yellow stripe
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: const Color(0xFFFAD201), // Rwanda yellow
              ),
            ),
            // Green stripe
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: const Color(0xFF00A651), // Rwanda green
              ),
            ),
          ],
        ),
      ),
    );
  }
}