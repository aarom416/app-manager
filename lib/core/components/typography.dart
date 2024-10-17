import 'package:flutter/material.dart';
import 'package:singleeat/core/components/sizing.dart';

class SGTypography {
  static SGText label(
    text, {
    Color color = Colors.black,
  }) =>
      body(text, color: color, size: FontSize.normal, weight: FontWeight.w700);

  static SGText headline1(text, {double? lineHeight, String? fontFamily}) => body(
        text,
        size: FontSize.large,
        weight: FontWeight.w900,
        lineHeight: lineHeight ?? 1.2,
        fontFamily: fontFamily,
      );

  static SGText headline2(text, {double? lineHeight, String? fontFamily}) =>
      body(text, size: FontSize.medium, weight: FontWeight.w900, lineHeight: lineHeight ?? 1.2, fontFamily: fontFamily);

  static SGText headline3(text, {double? lineHeight, String? fontFamily}) => body(text,
      size: FontSize.normal + FontSize.unit,
      weight: FontWeight.w900,
      lineHeight: lineHeight ?? 1.2,
      fontFamily: fontFamily);

  static SGText headline4(text, {double? lineHeight, String? fontFamily}) => body(
        text,
        size: FontSize.normal,
        weight: FontWeight.w900,
        lineHeight: lineHeight ?? 1.2,
        fontFamily: fontFamily,
      );

  static SGText body(text,
          {Color color = Colors.black,
          FontWeight weight = FontWeight.w500,
          String? fontFamily,
          double? size,
          double letterSpacing = -0.25,
          double lineHeight = 1.0,
          int maxLines = 100,
          TextAlign align = TextAlign.start,
          TextOverflow overflow = TextOverflow.clip,
          TextDecoration decoration = TextDecoration.none}) =>
      SGText(text,
          size: size ?? FontSize.tiny,
          weight: weight,
          color: color,
          maxLines: maxLines,
          lineHeight: lineHeight,
          letterSpacing: letterSpacing,
          overflow: overflow,
          align: align,
          textDecoration: decoration);
}

class SGText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight weight;
  final Color color;
  final double letterSpacing;
  final double lineHeight;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign align;
  final bool selectable;
  final TextDecoration? textDecoration;

  const SGText(
    this.text, {
    Key? key,
    this.size,
    this.weight = FontWeight.w500,
    this.color = Colors.black,
    this.letterSpacing = -0.25,
    this.maxLines = 100,
    this.overflow = TextOverflow.ellipsis,
    this.align = TextAlign.start,
    this.selectable = false,
    this.lineHeight = 1.0,
    this.textDecoration,
  }) : super(key: key);

  TextStyle get textStyle => TextStyle(
        fontWeight: weight,
        letterSpacing: letterSpacing,
        height: lineHeight,
        fontSize: size ?? 16.0,
        color: color,
        overflow: overflow,
        fontFamily: 'Pretendard',
        decoration: textDecoration,
      );

  TextSpan toTextSpan({List<InlineSpan>? children = const []}) {
    return TextSpan(text: text, style: textStyle, children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle,
      textAlign: align,
      maxLines: textStyle.overflow == TextOverflow.ellipsis ? 1 : maxLines,
    );
  }
}
