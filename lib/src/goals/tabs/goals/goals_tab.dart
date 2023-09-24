import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/routes_constants.dart';
import '../../../../core/helpers/my_logger.dart';
import '../../../../core/widgets/thesis_progress_bar.dart';
import '../../../../core/widgets/thesis_staggered_list.dart';
import '../../../../theme/theme_colors.dart';
import '../../../../theme/theme_extention.dart';
import '../../contracts/goal_base_dto/goal_base_dto.dart';
import '../../widgets/goal_card.dart';
import '../../components/goals_data_provider.dart';

class GoalsTab extends StatelessWidget {
  const GoalsTab({
    super.key,
    required this.provider,
  });

  final GoalsDataProvider provider;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: provider.goalsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Center(
              child: ThesisProgressBar(),
            ),
          );
        }

        if (snapshot.hasError) {
          MyLogger.e(snapshot.error.toString());
          return Padding(
            padding: const EdgeInsets.only(top: 48),
            child: Column(
              children: [
                SvgPicture.asset(
                  AppIcons.error,
                  width: 128,
                  colorFilter: const ColorFilter.mode(
                    kRedColor,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Произошла ошибка :(',
                  style: context.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Нажмите на кнопку, чтобы повторить попытку',
                  style: context.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      kPrimaryColor.withOpacity(0.1),
                    ),
                  ),
                  onPressed: () => provider.refresh(),
                  child: Text(
                    'Повторить',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: kPrimaryLightColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final goals = snapshot.data ?? [];
        return Visibility(
          visible: goals.isEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 48),
            child: Column(
              children: [
                SvgPicture.asset(
                  AppIcons.goals,
                  colorFilter: const ColorFilter.mode(
                    kGray3Color,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Задачи отсутствуют',
                  style: context.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Нажмите на кнопку +, чтобы добавить задачу',
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          replacement: RefreshIndicator(
            color: kPrimaryColor,
            onRefresh: () async {
              provider.refresh();
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.74,
              ),
              child: ThesisStaggeredList<GoalBaseDto>(
                items: goals,
                renderChild: (goal) => InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () async {
                    final detailed = await provider.getGoal(goal.id);
                    navService
                        .pushNamed(AppRoutes.goalsDetailed, args: detailed)
                        .whenComplete(() => provider.refresh());
                  },
                  child: GoalCard(goal: goal),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
