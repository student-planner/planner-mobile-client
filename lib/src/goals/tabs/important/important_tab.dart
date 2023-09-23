import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helpers/my_logger.dart';
import '../../../../core/widgets/bottom_sheep/thesis_info_bottom_sheep.dart';
import '../../../../core/widgets/button/thesis_button.dart';
import '../../../../core/widgets/button/thesis_outlined_button.dart';
import '../../../../core/widgets/thesis_bottom_sheep.dart';
import '../../../../core/widgets/thesis_progress_bar.dart';
import '../../../../core/widgets/thesis_staggered_list.dart';
import '../../../../theme/theme_colors.dart';
import '../../../../theme/theme_constants.dart';
import '../../../../theme/theme_extention.dart';
import '../../components/goals_data_provider.dart';
import '../../contracts/goal_dto/goal_dto.dart';
import '../../contracts/goal_priority.dart';
import '../../contracts/goal_put_dto/goal_put_dto.dart';
import '../../contracts/goal_status.dart';
import '../../widgets/goal_card.dart';
import '../../widgets/goal_status_card.dart';

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
            onRefresh: () async => setState(() {
              _importantFuture = widget.provider.loadMostImportantGoals();
            }),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.74,
              ),
              child: ThesisStaggeredList<GoalDto>(
                items: goals,
                renderChild: (goal) => InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () async {
                    if (goal.status == GoalStatus.New) {
                      final result = await _TakeGoalBottomSheep.show(
                        context,
                        goal: goal,
                        dataProvider: widget.provider,
                      );
                      if (result) {
                        setState(() {
                          _importantFuture =
                              widget.provider.loadMostImportantGoals();
                        });
                      }
                    } else if (goal.status == GoalStatus.InProgress) {
                      final result = await _SetGoalLaborBottomSheep.show(
                        context,
                        goal: goal,
                        dataProvider: widget.provider,
                      );
                      if (result) {
                        setState(() {
                          _importantFuture =
                              widget.provider.loadMostImportantGoals();
                        });
                      }
                    }
                  },
                  child: GoalCard(
                    goal: goal,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TakeGoalBottomSheep {
  static Future<bool> show(
    BuildContext context, {
    required GoalDto goal,
    required GoalsDataProvider dataProvider,
  }) async {
    final resultNotifier = ValueNotifier<bool>(false);
    await ThesisBottomSheep.showBarModalAsync(
      context,
      builder: (context) {
        return SingleChildScrollView(
          physics: kDefaultPhysics,
          padding: kThemeDefaultPadding.copyWith(bottom: 32),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  'Взять задачу в работу?'.toUpperCase(),
                  style: context.textTheme.headlineSmall,
                ),
              ),
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
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    goal.name,
                    style: context.textTheme.headlineSmall,
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
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 40),
                  ThesisButton.fromText(
                    text: 'Взять в работу',
                    onPressed: () async {
                      var putDto = GoalPutDto.fromGoalDto(goal);
                      putDto = putDto.copyWith(
                        status: GoalStatus.InProgress,
                      );
                      await dataProvider.putGoal(putDto);
                      resultNotifier.value = true;
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  ThesisOutlinedButton(
                    text: 'Перейти к задаче',
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        );
      },
    );
    return resultNotifier.value;
  }
}

class _SetGoalLaborBottomSheep {
  static Future<bool> show(
    BuildContext context, {
    required GoalDto goal,
    required GoalsDataProvider dataProvider,
  }) async {
    final resultNotifier = ValueNotifier<bool>(false);
    final laborController = TextEditingController();
    final laborKey = GlobalKey<FormFieldState>();
    final laborNotifier = ValueNotifier<Duration>(Duration.zero);
    await ThesisBottomSheep.showBarModalAsync(
      context,
      builder: (context) {
        return SingleChildScrollView(
          physics: kDefaultPhysics,
          padding: kThemeDefaultPadding.copyWith(bottom: 32),
          child: Wrap(
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
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    goal.name,
                    style: context.textTheme.headlineSmall,
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
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: laborKey,
                    controller: laborController,
                    readOnly: true,
                    onTap: () async {
                      await ThesisBottomSheep.showBarModalAsync(
                        context,
                        builder: (context) {
                          return Padding(
                            padding: kThemeDefaultPadding.copyWith(
                              bottom: 36,
                            ),
                            child: Wrap(
                              children: [
                                CupertinoTimerPicker(
                                  initialTimerDuration: laborNotifier.value,
                                  mode: CupertinoTimerPickerMode.hm,
                                  onTimerDurationChanged: (Duration value) {
                                    laborNotifier.value = value;
                                    laborController.text =
                                        '${value.inHours} ч. ${value.inMinutes.remainder(60)} мин.';
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Поле не может быть пустым.';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Отработанная трудоемкость',
                      hintText: 'Например, 2 ч. 30 мин.',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: IconButton(
                        onPressed: () => ThesisInfoBottomSheep.show(
                          context,
                          title: 'Что такое трудоёмкость?',
                          description:
                              'Трудоемкость - это общее количество временных затрат, необходимых для выполнения поставленной задачи.',
                        ),
                        icon: DecoratedBox(
                          decoration: BoxDecoration(
                            color: kGray3Color,
                            borderRadius: BorderRadius.circular(120),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.question_mark_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                      'Укажите время, которое вы потратили на задачу. Оно будет вычтено из оставшейся трудоемкости.'),
                  const SizedBox(height: 40),
                  ValueListenableBuilder(
                    valueListenable: laborNotifier,
                    builder: (context, labor, child) {
                      return ThesisButton.fromText(
                        text: 'Зафиксировать результат',
                        isDisabled: goal.labor < labor.inSeconds,
                        onPressed: () async {
                          var putDto = GoalPutDto.fromGoalDto(goal);
                          final finalLabor = goal.labor - labor.inSeconds;
                          putDto = putDto.copyWith(
                            labor: finalLabor,
                            status: finalLabor == 0
                                ? GoalStatus.Done
                                : GoalStatus.InProgress,
                          );
                          await dataProvider.putGoal(putDto);
                          resultNotifier.value = true;
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  ThesisOutlinedButton(
                    text: 'Завершить досрочно',
                    onPressed: () async {
                      var putDto = GoalPutDto.fromGoalDto(goal);
                      putDto = putDto.copyWith(
                        labor: 0,
                        status: GoalStatus.Done,
                      );
                      await dataProvider.putGoal(putDto);
                      resultNotifier.value = true;
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        );
      },
    );
    return resultNotifier.value;
  }
}
