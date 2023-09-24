import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/button/thesis_button.dart';
import '../../../../core/widgets/button/thesis_button_options.dart';
import '../../../../core/widgets/thesis_split_screen.dart';
import '../../../../theme/theme_colors.dart';
import '../../../../theme/theme_constants.dart';
import '../../../../theme/theme_extention.dart';
import '../../contracts/goal_detailed_dto/goal_detailed_dto.dart';
import '../../contracts/goal_priority.dart';
import '../../contracts/goal_status.dart';
import '../../widgets/goal_status_card.dart';
import 'goal_add_props_widget.dart';

/// Страница с подробной информацией о цели
class GoalDetailedPage extends StatelessWidget {
  const GoalDetailedPage({
    super.key,
    required this.goal,
  });

  final GoalDetailedDto goal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            AppIcons.close,
            colorFilter: ColorFilter.mode(
              context.textPrimaryColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      body: ThesisSplitScreen(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SingleChildScrollView(
                padding: kThemeDefaultPadding,
                physics: kDefaultPhysics,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GoalStatusCard(
                          stateName: goal.status.name,
                          stateColor: goal.status.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      goal.name,
                      style: context.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.timer_rounded,
                          color: kGray2Color,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          kDateTimeFormatter.format(goal.deadline.toLocal()),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.textPrimaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: 'Приоритет: ',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: kGray2Color,
                        ),
                        children: [
                          TextSpan(
                            text: goal.priority.name,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: goal.priority.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        text: 'Осталось выполнить: ',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: kGray2Color,
                        ),
                        children: [
                          TextSpan(
                            text: goal.duration,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      goal.description,
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 25),
                    Visibility(
                      visible: goal.subGoals.isNotEmpty ||
                          goal.dependGoals.isNotEmpty,
                      child: GoalAdditionalPropertiesWidget(
                        subGoals: goal.subGoals,
                        dependGoals: goal.dependGoals,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ColoredBox(
              color: context.currentTheme.scaffoldBackgroundColor,
              child: Padding(
                padding: kThemeDefaultPadding.copyWith(
                  bottom: Platform.isIOS ? 48 : 24,
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: ThesisButton.fromText(
                        text: 'Удалить',
                        onPressed: () async {},
                        options: const ThesisButtonOptions(
                          color: kRedColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: ThesisButton.fromText(
                        text: 'Изменить',
                        onPressed: () async {},
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
