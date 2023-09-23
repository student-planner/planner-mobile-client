import 'package:flutter/material.dart';

import '../contracts/goal_dto/goal_dto.dart';
import 'goal_card.dart';

class GoalImportanceCard extends StatelessWidget {
  const GoalImportanceCard({
    super.key,
    required this.goal,
  });

  final GoalDto goal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: GoalCard(goal: goal),
    );
  }
}
