import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/helpers/my_logger.dart';
import '../../../../core/widgets/thesis_progress_bar.dart';
import '../../../../core/widgets/thesis_staggered_list.dart';
import '../../../../theme/theme_colors.dart';
import '../../../../theme/theme_extention.dart';
import '../../contracts/goal_dto/goal_dto.dart';
import '../../widgets/goal_card.dart';
import 'components/goals_data_provider.dart';

class GoalsTab extends StatelessWidget {
  const GoalsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalsDataProvider>(
      builder: (context, provider, child) {
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

            final goals = (snapshot.data ?? []).reversed.toList();
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
                  child: ThesisStaggeredList<GoalDto>(
                    items: goals,
                    renderChild: (goal) => GoalCard(goal: goal),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
