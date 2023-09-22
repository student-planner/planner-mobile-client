import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/helpers/my_logger.dart';
import '../../../../core/widgets/thesis_progress_bar.dart';
import '../../../../core/widgets/thesis_staggered_list.dart';
import '../../../../theme/theme_colors.dart';
import '../../../../theme/theme_extention.dart';
import '../../components/goals_data_provider.dart';
import '../../contracts/goal_dto/goal_dto.dart';
import '../../widgets/goal_card.dart';

class ImportantTab extends StatefulWidget {
  const ImportantTab({
    super.key,
    required this.provider,
  });

  final GoalsDataProvider provider;

  @override
  State<ImportantTab> createState() => _ImportantTabState();
}

class _ImportantTabState extends State<ImportantTab> {
  late Future<List<GoalDto>> _importantFuture;

  @override
  void initState() {
    _importantFuture = widget.provider.getMostImportantGoalsFromCache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _importantFuture,
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
                  onPressed: () => setState(() {
                    _importantFuture = widget.provider.loadMostImportantGoals();
                  }),
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
                const Icon(
                  Icons.star_rate_rounded,
                  size: 128,
                  color: kGray3Color,
                ),
                const SizedBox(height: 16),
                Text(
                  'Готовы к работе?',
                  style: context.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Нажмите на кнопку ниже, чтобы получить задачи',
                  style: context.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() {
                    _importantFuture = widget.provider.loadMostImportantGoals();
                  }),
                  child: Text(
                    'Получить',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: kPrimaryLightColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          replacement: RefreshIndicator(
            color: kPrimaryColor,
            onRefresh: () async {
              widget.provider.refresh();
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
  }
}
