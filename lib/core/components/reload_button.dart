import 'package:flutter/material.dart';
import 'package:singleeat/core/components/spacing.dart';

class ReloadButton extends StatefulWidget {
  final VoidCallback? onReload;

  const ReloadButton({Key? key, this.onReload}) : super(key: key);

  @override
  _ReloadButtonState createState() => _ReloadButtonState();
}

class _ReloadButtonState extends State<ReloadButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350), // Duration of the rotation
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_controller.isAnimating) return;

    _controller.forward(from: 0.0).then((_) {
      _controller.reset(); // Optional: reset the animation
      widget.onReload?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
        child: Image.asset(
          "assets/images/reload.png",
          width: SGSpacing.p8,
          height: SGSpacing.p8,
        ),
      ),
    );
  }
}
