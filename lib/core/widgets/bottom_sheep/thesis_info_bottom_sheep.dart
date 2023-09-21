import 'package:flutter/cupertino.dart';

import '../../../theme/theme_colors.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/theme_extention.dart';
import '../../constants/constants.dart';
import '../button/thesis_button.dart';
import '../thesis_bottom_sheep.dart';

class ThesisInfoBottomSheep {
  static void show(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    ThesisBottomSheep.showBarModalAsync(
      context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: kThemeDefaultPadding.copyWith(
            bottom: 36,
          ),
          physics: kDefaultPhysics,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: context.textTheme.headlineSmall,
              ),
              const SizedBox(height: 15),
              Text(
                description,
                style: context.textTheme.titleMedium?.copyWith(
                  color: kGray2Color,
                ),
              ),
              const SizedBox(height: 48),
              ThesisButton.fromText(
                text: 'Ок, понятно'.toUpperCase(),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
