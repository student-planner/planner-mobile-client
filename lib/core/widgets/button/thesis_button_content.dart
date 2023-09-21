import 'package:flutter/material.dart';

import '../../../theme/theme_colors.dart';
import '../../../theme/theme_extention.dart';
import '../thesis_progress_bar.dart';

class ThesisButtonContent extends StatelessWidget {
  const ThesisButtonContent({
    this.child,
    this.text,
    this.color,
    required this.isDisabled,
    required this.isLoading,
  });

  final Widget? child;
  final String? text;
  final Color? color;

  final bool isDisabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = context.textTheme.titleLarge!.copyWith(
      color: color ?? Colors.white,
    );
    return Container(
      child: isLoading
          ? const ThesisProgressBar(color: kDarkTextPrimaryColor)
          : text != null
              ? Text(
                  text!,
                  style: isDisabled
                      ? defaultTextStyle.copyWith(fontWeight: FontWeight.w600)
                      : defaultTextStyle,
                )
              : child,
    );
  }
}
