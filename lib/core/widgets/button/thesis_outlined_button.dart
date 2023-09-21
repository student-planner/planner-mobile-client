import 'package:flutter/material.dart';

import '../../../theme/theme_colors.dart';
import 'thesis_button_content.dart';
import 'thesis_button_options.dart';

/// Компонент базовой кнопки с обводкой
class ThesisOutlinedButton extends StatelessWidget {
  ThesisOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.options = const ThesisButtonOptions(),
    this.isDisabled = false,
  });

  final String text;
  final ThesisButtonOptions options;
  final void Function() onPressed;
  final bool isDisabled;
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
      valueListenable: isLoadingNotifier,
      builder: (context, isLoading, child) {
        return OutlinedButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(
              Size(options.width ?? buttonWidth, options.height),
            ),
            side: MaterialStateProperty.all(
              const BorderSide(
                color: kPrimaryColor,
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(options.borderRadius),
              ),
            ),
          ),
          onPressed: onPressed,
          child: ThesisButtonContent(
            text: text,
            color: kPrimaryLighterColor,
            isDisabled: isDisabled,
            isLoading: isLoading,
          ),
        );
      },
    );
  }
}
