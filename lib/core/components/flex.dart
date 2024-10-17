import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';

class SGFlexible extends StatelessWidget {
  final Widget child;
  final int flex;

  SGFlexible({required this.child, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: SGContainer(width: double.infinity, child: child),
    );
  }
}
