import 'package:flutter/material.dart';

/// Опции кнопки
class ThesisButtonOptions {
  final bool isOutline;
  final double borderRadius;
  final double? width;
  final double height;
  final TextStyle? titleStyle;
  final Color? color;

  const ThesisButtonOptions({
    this.isOutline = false,
    this.borderRadius = 12,
    this.width,
    this.height = 56,
    this.titleStyle,
    this.color,
  });
}
