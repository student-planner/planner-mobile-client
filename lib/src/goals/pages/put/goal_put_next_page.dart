import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helpers/message_helper.dart';
import '../../../../core/helpers/module_configurator.dart';
import '../../../../core/widgets/bottom_sheep/thesis_info_bottom_sheep.dart';
import '../../../../core/widgets/button/thesis_button.dart';
import '../../../../core/widgets/thesis_bottom_sheep.dart';
import '../../../../core/widgets/thesis_split_screen.dart';
import '../../../../theme/theme_colors.dart';
import '../../../../theme/theme_constants.dart';
import '../../../../theme/theme_extention.dart';
import '../../contracts/goal_priority.dart';
import '../../contracts/goal_put_dto/goal_put_dto.dart';
import '../../components/goals_data_provider.dart';

/// Страница добавления/изменения цели
class GoalPutNextPage extends StatelessWidget {
  const GoalPutNextPage({
    super.key,
    required this.goalPutDto,
  });

  final GoalPutDto goalPutDto;

  @override
  Widget build(BuildContext context) {
    var putDto = goalPutDto;

    final laborController = TextEditingController(
      text: goalPutDto.labor.toString().replaceAll('.0', ''),
    );
    final laborKey = GlobalKey<FormFieldState>();
    final laborNotifier = ValueNotifier<Duration>(
      Duration(seconds: goalPutDto.labor.toInt()),
    );

    final priorityController = TextEditingController();
    final priorityKey = GlobalKey<FormFieldState>();
    final priorityNotifier = ValueNotifier<GoalPriority>(
      goalPutDto.priority,
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            AppIcons.back,
            colorFilter: ColorFilter.mode(
              context.textPrimaryColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        title: Text(
          goalPutDto.id == null ? 'Добавить задачу' : 'Изменить задачу',
          style: context.textTheme.headlineSmall,
        ),
        centerTitle: true,
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
                                      putDto = goalPutDto.copyWith(
                                        labor: value.inSeconds.toDouble(),
                                      );
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
                        labelText: 'Трудоёмкость',
                        hintText: 'Введите трудоёмкость задачи',
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
                    const SizedBox(height: 20),
                    TextFormField(
                      key: priorityKey,
                      controller: priorityController,
                      readOnly: true,
                      onTap: () async {
                        final priority = await _GoalPriorityBottomSheep.show(
                          context,
                          priorityNotifier.value,
                        );
                        priorityController.text = priority.name;
                        putDto = putDto.copyWith(priority: priority);
                        priorityNotifier.value = priority;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Поле не может быть пустым.';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Приоритет',
                        hintText: 'Введите приоритет задачи',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: IconButton(
                          onPressed: () => ThesisInfoBottomSheep.show(
                            context,
                            title: 'Что такое приоритет?',
                            description:
                                'Приоритет позволяет выделить наиболее важные для вас задачи и предлагать их в первую очередь.',
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
                child: Column(
                  children: [
                    ThesisButton.fromText(
                      text: 'Сохранить',
                      onPressed: () async {
                        final provider = injector.get<GoalsDataProvider>();
                        final response = await provider.putGoal(putDto);
                        if (response == 201) {
                          MessageHelper.showSuccess('Задача успешно добавлена');
                        } else if (response == 204) {
                          MessageHelper.showSuccess('Задача успешно изменена');
                        } else {
                          MessageHelper.showError(
                            'Произошла ошибка при добавлении задачи',
                          );
                        }
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalPriorityBottomSheep {
  static Future<GoalPriority> show(
    BuildContext context,
    GoalPriority current,
  ) async {
    final priorityNotifier = ValueNotifier<GoalPriority>(current);
    final priorities = GoalPriority.values.reversed.toList();
    await ThesisBottomSheep.showBarModalAsync(
      context,
      builder: (context) {
        return SingleChildScrollView(
          padding: kThemeDefaultPadding.copyWith(bottom: 36),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Приоритет задачи'.toUpperCase(),
                  style: context.textTheme.headlineSmall,
                ),
              ),
              Column(
                children: List.generate(
                  priorities.length,
                  (index) => Padding(
                    padding: kCardBottomPadding,
                    child: ValueListenableBuilder(
                      valueListenable: priorityNotifier,
                      builder: (context, current, child) {
                        return InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            priorityNotifier.value = priorities[index];
                          },
                          child: Card(
                            color: kCardBottomSheepColor,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 6,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: current == priorities[index]
                                        ? current.color
                                        : priorities[index]
                                            .color
                                            .withOpacity(0.25),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(6.0),
                                      topRight: Radius.zero,
                                      bottomLeft: Radius.circular(6.0),
                                      bottomRight: Radius.zero,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 36, 36, 36),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 22, 22, 22),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(120),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  current == priorities[index]
                                                      ? current.color
                                                      : const Color(0xFF767676),
                                              borderRadius:
                                                  BorderRadius.circular(120),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        priorities[index].name,
                                        style: context.textTheme.titleLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ThesisButton.fromText(
                  text: 'Указать приоритет',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );

    return priorityNotifier.value;
  }
}
