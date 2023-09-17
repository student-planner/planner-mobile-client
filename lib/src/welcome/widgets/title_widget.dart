import 'package:flutter/material.dart';

import '../../../theme/theme_extention.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.displaySmall,
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: context.textTheme.titleSmall,
        ),
      ],
    );
  }
}
