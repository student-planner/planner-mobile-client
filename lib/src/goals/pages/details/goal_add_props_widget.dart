import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/helpers/my_logger.dart';
import '../../../../core/widgets/tab_bar/thesis_tab_bar.dart';
import '../../contracts/goal_base_dto/goal_base_dto.dart';
import '../../widgets/goal_card.dart';
import '../put/add_properties/add_props_bottom_sheep.dart';

/// Виджет для отображения дополнительных свойств задачи
class GoalAdditionalPropertiesWidget extends StatelessWidget {
  const GoalAdditionalPropertiesWidget({
    super.key,
    required this.subGoals,
    required this.dependGoals,
  });

  final List<GoalBaseDto> subGoals;
  final List<GoalBaseDto> dependGoals;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      subGoals.isEmpty ? null : AdditionalProperties.subGoals,
      dependGoals.isEmpty ? null : AdditionalProperties.dependGoals,
    ];
    tabs.removeWhere((element) => element == null);

    MyLogger.d('tabs: $tabs');

    final children = <Widget>[];
    if (tabs.contains(AdditionalProperties.subGoals)) {
      children.add(_GoalsList(goals: subGoals));
    }
    if (tabs.contains(AdditionalProperties.dependGoals)) {
      children.add(_GoalsList(goals: dependGoals));
    }

    return ThesisTabBar(
      tabs: tabs.map((e) => e!.shortName).toList(),
      children: children,
    );
  }
}

class _GoalsList extends StatelessWidget {
  const _GoalsList({
    required this.goals,
  });

  final List<GoalBaseDto> goals;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          goals.length,
          (index) => Padding(
            padding: kCardBottomPadding,
            child: GoalCard(
              goal: goals[index],
            ),
          ),
        ),
      ),
    );
  }
}
