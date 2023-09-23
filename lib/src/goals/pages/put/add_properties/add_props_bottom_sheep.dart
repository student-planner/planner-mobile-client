import 'package:flutter/material.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/widgets/bottom_sheep/thesis_info_bottom_sheep.dart';
import '../../../../../core/widgets/button/thesis_button.dart';
import '../../../../../core/widgets/thesis_bottom_sheep.dart';
import '../../../../../core/widgets/thesis_check_box.dart';
import '../../../../../theme/theme_colors.dart';
import '../../../../../theme/theme_constants.dart';
import '../../../../../theme/theme_extention.dart';

/// Дополнительные свойства задачи
enum AdditionalProperties {
  subGoals,
  dependGoals,
}

/// Расширение для [AdditionalProperties]
extension AdditionalPropertiesExtension on AdditionalProperties {
  String get name {
    switch (this) {
      case AdditionalProperties.subGoals:
        return 'Список подзадач';
      case AdditionalProperties.dependGoals:
        return 'Зависимость от других задач';
      default:
        return '';
    }
  }

  String get shortName {
    switch (this) {
      case AdditionalProperties.subGoals:
        return 'Подзадачи';
      case AdditionalProperties.dependGoals:
        return 'Зависит от';
      default:
        return '';
    }
  }

  (String title, String description) get info {
    switch (this) {
      case AdditionalProperties.subGoals:
        return (
          'ЧТО ТАКОЕ ПОДЗАДАЧА?',
          'Вы можете разделить задачу на подзадачи, которые будут использоваться для рекомендации к выполнению. При планировании к выполнению предлагаются подзадачи, представляющие базовую задачу.'
        );
      case AdditionalProperties.dependGoals:
        return (
          'ЧТО ТАКОЕ ЗАВИСИМОСТЬ ОТ ДРУГИХ ЗАДАЧ?',
          'Вы можете указать зависимость добавляемой задачи от выполнения других задач. Это означает, что задача не будет предложена, пока не будут выполнены все задачи, от которых она зависит. Признак того, что от выполнения задачи зависят другие задачи повышает ее приоритет и важность.'
        );
      default:
        return ('', '');
    }
  }
}

/// BottomSheet для выбора дополнительных свойств задачи
class AdditionalPropertiesBottomSheet {
  /// Отображает BottomSheet для выбора дополнительных свойств задачи
  static Future<List<AdditionalProperties>> show(
    BuildContext context, {
    required List<AdditionalProperties> current,
  }) async {
    final propsNotifier = ValueNotifier<List<AdditionalProperties>>(current);
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
                  'Какие сведения добавить?'.toUpperCase(),
                  style: context.textTheme.headlineSmall,
                ),
              ),
              ValueListenableBuilder<List<AdditionalProperties>>(
                valueListenable: propsNotifier,
                builder: (context, props, child) {
                  return Column(
                    children: List.generate(
                      AdditionalProperties.values.length,
                      (index) {
                        final current = AdditionalProperties.values[index];
                        return Padding(
                          padding:
                              index != AdditionalProperties.values.length - 1
                                  ? kCardBottomPadding
                                  : EdgeInsets.zero,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              if (props.contains(current)) {
                                props.remove(current);
                              } else {
                                props.add(current);
                              }
                              propsNotifier.value = List.from(props);
                            },
                            child: Card(
                              color: kCardBottomSheepColor,
                              child: Padding(
                                padding: kCardBottomSheepDefaultPadding,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Row(
                                        children: [
                                          ThesisCheckBox(
                                            isChecked: props.contains(current),
                                            color: kPrimaryColor,
                                          ),
                                          const SizedBox(width: 20),
                                          Flexible(
                                            child: Text(
                                              current.name,
                                              style:
                                                  context.textTheme.titleLarge,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () => ThesisInfoBottomSheep.show(
                                        context,
                                        title: current.info.$1,
                                        description: current.info.$2,
                                      ),
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.question_mark_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
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
    return propsNotifier.value;
  }
}
