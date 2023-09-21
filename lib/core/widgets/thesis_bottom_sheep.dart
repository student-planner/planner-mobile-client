import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../theme/theme_extention.dart';

/// Компонент нижнего модального окна
class ThesisBottomSheep {
  static Future<void> showBarModalAsync(
    BuildContext context, {
    required Widget Function(BuildContext context) builder,
    bool expand = false,
    Color? backgroundColor,
  }) async {
    backgroundColor ??= context.currentTheme.cardTheme.color;
    await showBarModalBottomSheet(
      context: context,
      expand: expand,
      backgroundColor: backgroundColor,
      builder: builder,
    );
  }

  static void showBarModal(
    BuildContext context, {
    required Widget Function(BuildContext context) builder,
    bool expand = false,
    Color? backgroundColor,
  }) {
    backgroundColor ??= context.currentTheme.cardTheme.color;
    showBarModalBottomSheet(
      context: context,
      expand: expand,
      backgroundColor: backgroundColor,
      builder: builder,
    );
  }
}
