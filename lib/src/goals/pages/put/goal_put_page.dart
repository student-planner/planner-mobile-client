import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/routes_constants.dart';
import '../../../../core/helpers/message_helper.dart';
import '../../../../core/helpers/module_configurator.dart';
import '../../../../core/widgets/button/thesis_button.dart';
import '../../../../core/widgets/button/thesis_button_options.dart';
import '../../../../core/widgets/button/thesis_outlined_button.dart';
import '../../../../core/widgets/tab_bar/thesis_tab_bar.dart';
import '../../../../core/widgets/thesis_bottom_sheep.dart';
import '../../../../core/widgets/thesis_check_box.dart';
import '../../../../core/widgets/thesis_split_screen.dart';
import '../../../../theme/theme_colors.dart';
import '../../../../theme/theme_constants.dart';
import '../../../../theme/theme_extention.dart';
import '../../components/goals_data_provider.dart';
import '../../contracts/goal_dto/goal_dto.dart';
import '../../contracts/goal_put_dto/goal_put_dto.dart';
import '../../contracts/goal_status.dart';
import '../../repositories/goals_repository.dart';
import '../../widgets/goal_status_card.dart';
import 'add_properties/add_props_bottom_sheep.dart';

/// Страница добавления/изменения цели
class GoalPutPage extends StatelessWidget {
  const GoalPutPage({
    super.key,
    this.goalDto,
  });

  final GoalDto? goalDto;

  @override
  Widget build(BuildContext context) {
    final repository = injector.get<IGoalsRepository>();
    var putDto = GoalPutDto.fromGoalDto(goalDto);

    final nameController = TextEditingController(
      text: putDto.name,
    );
    final nameKey = GlobalKey<FormFieldState>();
    final descriptionController = TextEditingController(
      text: putDto.description,
    );
    final descriptionKey = GlobalKey<FormFieldState>();
    final deadlineController = TextEditingController(
      text: kDateTimeFormatter.format(putDto.deadline),
    );
    final deadlineNotifier = ValueNotifier<DateTime>(putDto.deadline);
    final deadlineKey = GlobalKey<FormFieldState>();

    final propsNotifier = ValueNotifier<List<AdditionalProperties>>([]);
    final subGoalsNotifier = ValueNotifier<List<GoalDto>>([]);
    final dependGoalsNotifier = ValueNotifier<List<GoalDto>>([]);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context, null),
          icon: SvgPicture.asset(
            AppIcons.close,
            colorFilter: ColorFilter.mode(
              context.textPrimaryColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        title: Text(
          goalDto == null ? 'Добавить задачу' : 'Изменить задачу',
          style: context.textTheme.headlineSmall,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final props = await AdditionalPropertiesBottomSheet.show(
                context,
                current: propsNotifier.value,
              );
              props.sort((a, b) => a.index.compareTo(b.index));
              propsNotifier.value = props;
            },
            icon: Icon(
              Icons.more_vert_rounded,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ThesisSplitScreen(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SingleChildScrollView(
                physics: kDefaultPhysics,
                padding: kThemeDefaultPadding,
                child: Column(
                  children: [
                    TextFormField(
                      key: nameKey,
                      controller: nameController,
                      onChanged: (value) {
                        final state = nameKey.currentState?.validate() ?? false;
                        if (state) {
                          putDto = putDto.copyWith(name: value);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Поле не может быть пустым.';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Название',
                        hintText: 'Решить проблему с...',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: descriptionKey,
                      controller: descriptionController,
                      onChanged: (value) {
                        final state =
                            descriptionKey.currentState?.validate() ?? false;
                        if (state) {
                          putDto = putDto.copyWith(description: value);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Поле не может быть пустым.';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Описание',
                        hintText: 'Описание задачи...',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: deadlineKey,
                      controller: deadlineController,
                      readOnly: true,
                      onTap: () async {
                        final height = MediaQuery.of(context).size.height * 0.4;
                        await showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext builder) {
                            return Container(
                              height: height,
                              width: double.infinity,
                              color: context.currentTheme.cardTheme.color,
                              child: CupertinoTheme(
                                data: CupertinoThemeData(
                                  brightness: context.currentTheme.brightness,
                                ),
                                child: CupertinoDatePicker(
                                  minimumDate: DateTime.now(),
                                  mode: CupertinoDatePickerMode.dateAndTime,
                                  dateOrder: DatePickerDateOrder.dmy,
                                  use24hFormat: true,
                                  onDateTimeChanged: (DateTime value) {
                                    deadlineNotifier.value = value;
                                    deadlineController.text = kDateTimeFormatter
                                        .format(deadlineNotifier.value);
                                    final state =
                                        deadlineKey.currentState?.validate() ??
                                            false;
                                    if (state) {
                                      putDto = putDto.copyWith(
                                        deadline:
                                            deadlineNotifier.value.toUtc(),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Поле не может быть пустым.';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Крайний срок',
                        hintText: 'Выберите дату...',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: kGray2Color,
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: propsNotifier,
                      builder: (context, props, child) {
                        if (props.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final children = <Widget>[];
                        if (props.contains(AdditionalProperties.subGoals)) {
                          children.add(_ShowAddGoalsList(
                            goalsNotifier: subGoalsNotifier,
                            repository: repository,
                            onFilter: (item) {
                              return !dependGoalsNotifier.value.contains(item);
                            },
                          ));
                        }
                        if (props.contains(AdditionalProperties.dependGoals)) {
                          children.add(_ShowAddGoalsList(
                            goalsNotifier: dependGoalsNotifier,
                            repository: repository,
                            onFilter: (item) {
                              return !subGoalsNotifier.value.contains(item);
                            },
                          ));
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ThesisTabBar(
                            tabs: props.map((e) => e.shortName).toList(),
                            children: children,
                          ),
                        );
                      },
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
                child: ValueListenableBuilder(
                  valueListenable: propsNotifier,
                  builder: (context, props, child) {
                    return Visibility(
                      visible: props.isNotEmpty,
                      child: ThesisButton.fromText(
                        text: 'Сохранить',
                        onPressed: () async {
                          final nameState =
                              nameKey.currentState?.validate() ?? false;
                          final descriptionState =
                              descriptionKey.currentState?.validate() ?? false;
                          final deadlineState =
                              deadlineKey.currentState?.validate() ?? false;
                          if (!nameState ||
                              !descriptionState ||
                              !deadlineState) {
                            return;
                          }

                          putDto = putDto.copyWith(
                            subGoalsIds: subGoalsNotifier.value
                                .map((e) => e.id)
                                .toList(),
                            dependGoalsIds: dependGoalsNotifier.value
                                .map((e) => e.id)
                                .toList(),
                          );

                          final provider = injector.get<GoalsDataProvider>();
                          final response = await provider.putGoal(putDto);
                          if (response == 201) {
                            MessageHelper.showSuccess(
                              'Задача успешно добавлена',
                            );
                          } else if (response == 204) {
                            MessageHelper.showSuccess(
                              'Задача успешно изменена',
                            );
                          } else {
                            MessageHelper.showError(
                              'Произошла ошибка при добавлении задачи',
                            );
                          }
                          Navigator.pop(context);
                        },
                      ),
                      replacement: ThesisButton.fromText(
                        text: 'Продолжить',
                        onPressed: () {
                          final nameState =
                              nameKey.currentState?.validate() ?? false;
                          final descriptionState =
                              descriptionKey.currentState?.validate() ?? false;
                          final deadlineState =
                              deadlineKey.currentState?.validate() ?? false;
                          if (!nameState ||
                              !descriptionState ||
                              !deadlineState) {
                            return;
                          }

                          navService.pushNamed(
                            AppRoutes.goalsPutContinue,
                            args: putDto,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowAddGoalsList extends StatelessWidget {
  const _ShowAddGoalsList({
    required this.goalsNotifier,
    required this.repository,
    this.onFilter,
  });

  final ValueNotifier<List<GoalDto>> goalsNotifier;
  final IGoalsRepository repository;
  final bool Function(GoalDto)? onFilter;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: goalsNotifier,
      builder: (context, subGoals, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                visible: subGoals.isEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: Text(
                      'Добавьте задачи при помощи кнопки ниже',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: kGray2Color,
                      ),
                    ),
                  ),
                ),
                replacement: Column(
                  children: List.generate(
                    subGoals.length,
                    (index) => Padding(
                      padding: kCardBottomPadding,
                      child: _GoalsListItem(
                        goal: subGoals[index],
                        onRemove: (item) {
                          subGoals.remove(item);
                          goalsNotifier.value = List.from(subGoals);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ]..add(
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: ThesisOutlinedButton(
                    text: '+ Добавить',
                    onPressed: () async {
                      final goals = await _PickGoalsBottomSheep.show(
                        context,
                        repository: repository,
                        pickedGoals: subGoals,
                        onFilter: onFilter,
                      );
                      goalsNotifier.value = List.from(goals);
                    },
                    options: const ThesisButtonOptions(
                      height: 48,
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

class _GoalsListItem extends StatelessWidget {
  const _GoalsListItem({
    required this.goal,
    required this.onRemove,
  });

  final GoalDto goal;
  final void Function(GoalDto item) onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GoalStatusCard(
                  stateName: goal.status.name,
                  stateColor: goal.status.color,
                ),
                const SizedBox(height: 4),
                Text(
                  goal.name,
                  style: context.textTheme.headlineSmall,
                ),
              ],
            ),
            IconButton(
              onPressed: () => onRemove(goal),
              icon: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: kRedColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    AppIcons.delete,
                    colorFilter: ColorFilter.mode(
                      context.textPrimaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickGoalsBottomSheep {
  static Future<List<GoalDto>> show(
    BuildContext context, {
    required IGoalsRepository repository,
    required List<GoalDto> pickedGoals,
    bool Function(GoalDto item)? onFilter,
  }) async {
    final goalsNotifier = ValueNotifier<List<GoalDto>>(pickedGoals);
    final goals = (await repository.getGoals())
        .where((goal) =>
            goal.status != GoalStatus.Done && goal.status != GoalStatus.Overdue)
        .toList();
    if (onFilter != null) {
      goals.removeWhere((goal) => !onFilter(goal));
    }
    await ThesisBottomSheep.showBarModalAsync(
      context,
      builder: (context) {
        return SingleChildScrollView(
          padding: kThemeDefaultPadding.copyWith(bottom: 32),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Выберите задачи'.toUpperCase(),
                  style: context.textTheme.headlineSmall,
                ),
              ),
              Visibility(
                visible: goals.isEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      'Невозможно выбрать задачи :( \nТакое возможно, если вы пытаетесь добавить задачу, которая уже находится в списке подзадач или наоборот.',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: kRedColor,
                      ),
                    ),
                  ),
                ),
                replacement: ValueListenableBuilder<List<GoalDto>>(
                  valueListenable: goalsNotifier,
                  builder: (context, picked, child) {
                    return Column(
                      children: List.generate(
                        goals.length,
                        (index) {
                          final current = goals[index];
                          return Padding(
                            padding: index != goals.length - 1
                                ? kCardBottomPadding
                                : EdgeInsets.zero,
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                if (picked.contains(current)) {
                                  picked.remove(current);
                                } else {
                                  picked.add(current);
                                }
                                goalsNotifier.value = List.from(picked);
                              },
                              child: Card(
                                color: kCardBottomSheepColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          children: [
                                            ThesisCheckBox(
                                              isChecked:
                                                  picked.contains(current),
                                              color: kPrimaryColor,
                                            ),
                                            const SizedBox(width: 20),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      GoalStatusCard(
                                                        stateName:
                                                            current.status.name,
                                                        stateColor: current
                                                            .status.color,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons.timer_rounded,
                                                            color: kGray2Color,
                                                            size: 16,
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          Text(
                                                            kDateTimeFormatter
                                                                .format(current
                                                                    .deadline
                                                                    .toLocal()),
                                                            style: context
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    current.name,
                                                    style: context.textTheme
                                                        .headlineSmall,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: ThesisButton.fromText(
                  text: 'Добавить',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
    return goalsNotifier.value;
  }
}
