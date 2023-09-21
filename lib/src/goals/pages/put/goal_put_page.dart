import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/routes_constants.dart';
import '../../../../core/widgets/button/thesis_button.dart';
import '../../../../core/widgets/button/thesis_outlined_button.dart';
import '../../../../core/widgets/thesis_split_screen.dart';
import '../../../../theme/theme_colors.dart';
import '../../../../theme/theme_constants.dart';
import '../../../../theme/theme_extention.dart';
import '../../contracts/goal_dto/goal_dto.dart';
import '../../contracts/goal_put_dto/goal_put_dto.dart';

/// Страница добавления/изменения цели
class GoalPutPage extends StatelessWidget {
  const GoalPutPage({
    super.key,
    this.goalDto,
  });

  final GoalDto? goalDto;

  @override
  Widget build(BuildContext context) {
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
                  ],
                ),
              ),
            ),
            ColoredBox(
              color: context.currentTheme.scaffoldBackgroundColor,
              child: Padding(
                padding: kThemeDefaultPadding.copyWith(bottom: 48),
                child: Column(
                  children: [
                    ThesisButton.fromText(
                      text: 'Продолжить',
                      onPressed: () {
                        final nameState =
                            nameKey.currentState?.validate() ?? false;
                        final descriptionState =
                            descriptionKey.currentState?.validate() ?? false;
                        final deadlineState =
                            deadlineKey.currentState?.validate() ?? false;
                        if (!nameState || !descriptionState || !deadlineState) {
                          return;
                        }

                        navService.pushNamed(
                          AppRoutes.goalsPutContinue,
                          args: putDto,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    ThesisOutlinedButton(
                      text: '+ Доп. свойства',
                      onPressed: () {},
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
