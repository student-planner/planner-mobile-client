import 'package:flutter/material.dart';

import '../../../../../theme/theme_colors.dart';
import 'thesis_button_content.dart';
import 'thesis_button_options.dart';

/// Компонент базовой кнопки
class ThesisButton extends StatelessWidget {
  ThesisButton({
    super.key,
    required this.child,
    this.text,
    this.options = const ThesisButtonOptions(),
    required this.onPressed,
    this.isDisabled = false,
  });

  /// Кнопка из текста
  factory ThesisButton.fromText({
    Key? key,
    required String text,
    required void Function() onPressed,
    ThesisButtonOptions options = const ThesisButtonOptions(),
    bool isDisabled = false,
    bool isLoading = false,
  }) {
    return ThesisButton(
      key: key,
      child: null,
      text: text,
      options: options,
      onPressed: onPressed,
      isDisabled: isDisabled,
    );
  }

  final Widget? child;
  final String? text;
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
        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              isDisabled || isLoading
                  ? kGray2Color
                  : options.color ?? kPrimaryColor,
            ),
            fixedSize: MaterialStateProperty.all<Size>(
              Size(options.width ?? buttonWidth, options.height),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(options.borderRadius),
              ),
            ),
            elevation: MaterialStateProperty.all<double>(0),
          ),
          onPressed: isDisabled
              ? null
              : () async {
                  isLoadingNotifier.value = true;
                  onPressed();
                  await Future.delayed(const Duration(seconds: 2)).whenComplete(
                    () => isLoadingNotifier.value = false,
                  );
                },
          child: ThesisButtonContent(
            child: child,
            text: text,
            isLoading: isLoading,
            isDisabled: isDisabled,
          ),
        );
      },
    );
  }
}
