import 'package:flutter/material.dart';

enum SGBoxShadow {
  none,
  small,
  medium,
  large;

  BoxShadow get shadow {
    switch (this) {
      case small:
        return BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: Offset(0, 2),
          blurRadius: 4,
        );
      case medium:
        return BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: Offset(0, 4),
          blurRadius: 8,
        );
      case large:
        return BoxShadow(
          color: Colors.black.withOpacity(0.06),
          offset: Offset(0, 4),
          blurRadius: 20,
        );
      default:
        return BoxShadow(color: Colors.transparent);
    }
  }
}

class SGContainer extends StatelessWidget {
  SGContainer(
      {super.key,
      this.width,
      this.height,
      this.margin = EdgeInsets.zero,
      this.padding = EdgeInsets.zero,
      this.color = Colors.transparent,
      this.borderColor = Colors.transparent,
      this.borderWidth = 1.0,
      this.borderRadius = BorderRadius.zero,
      this.boxShadow = SGBoxShadow.none,
      this.child});

  final double? width;
  final double? height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final SGBoxShadow boxShadow;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          boxShadow: [boxShadow.shadow],
          color: color,
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: padding,
          child: child,
        ));
  }
}
