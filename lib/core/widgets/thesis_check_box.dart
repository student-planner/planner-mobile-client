import 'package:flutter/material.dart';

import '../../theme/theme_colors.dart';

class ThesisCheckBox extends StatelessWidget {
  const ThesisCheckBox({
    required this.isChecked,
    required this.color,
  });

  final bool isChecked;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isChecked ? color : Colors.transparent,
        border: Border.all(
          color:
              isChecked ? const Color.fromARGB(255, 36, 36, 36) : kPrimaryColor,
        ),
        borderRadius: BorderRadius.circular(120),
      ),
      child: Visibility(
        visible: isChecked,
        child: const Icon(
          Icons.check,
          color: Color.fromARGB(255, 36, 36, 36),
          size: 16,
        ),
      ),
    );
  }
}
