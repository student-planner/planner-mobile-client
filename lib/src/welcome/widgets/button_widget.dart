import 'package:flutter/material.dart';

import '../../../core/widgets/button/thesis_button.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.buttonDisableNotifier,
    required this.onPressed,
    required this.title,
  });

  final ValueNotifier<bool> buttonDisableNotifier;
  final void Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: buttonDisableNotifier,
      builder: (context, isDisable, child) {
        return ThesisButton.fromText(
          isDisabled: isDisable,
          onPressed: onPressed,
          text: title,
        );
      },
    );
  }
}
