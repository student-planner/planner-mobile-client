import 'package:flutter/material.dart';

import '../../../theme/theme_extention.dart';
import '../contracts/goal_dto/goal_dto.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goal,
  });

  final GoalDto goal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              goal.name,
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              goal.description,
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
