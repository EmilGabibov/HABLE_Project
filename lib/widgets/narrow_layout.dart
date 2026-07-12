import 'package:flutter/material.dart';

/// A reusable layout wrapper that restricts its child to a maximum reading width
/// (e.g., 700px) and centers it horizontally. This is specifically used on Web/Desktop
/// to prevent dense lists or cards from stretching unnaturally across an ultra-wide screen.
class NarrowLayout extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const NarrowLayout({
    super.key,
    required this.child,
    this.maxWidth = 700,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
