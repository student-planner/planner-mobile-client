import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../theme/theme_colors.dart';
import '../../../theme/theme_extention.dart';
import '../contracts/goal_base_dto/goal_base_dto.dart';
import '../contracts/goal_status.dart';
import 'goal_status_card.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goal,
  });

  final GoalBaseDto goal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GoalStatusCard(
                  stateName: goal.status.name,
                  stateColor: goal.status.color,
                ),
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
                      style:
                          context.textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              goal.name,
              style: context.textTheme.headlineSmall,
            ),
            Visibility(
              visible: goal.description.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  goal.description,
                  style: context.textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
