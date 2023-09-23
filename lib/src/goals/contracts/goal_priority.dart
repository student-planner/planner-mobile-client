import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

import '../../../theme/theme_colors.dart';

/// Приоритет задачи
enum GoalPriority {
  /// <summary>
  /// Очень низкий
  /// </summary>
  @JsonValue(0)
  extraLow,

  /// <summary>
  /// Низкий
  /// </summary>
  @JsonValue(1)
  low,

  /// <summary>
  /// Средний
  /// </summary>
  @JsonValue(2)
  medium,

  /// <summary>
  /// Высокий
  /// </summary>
  @JsonValue(3)
  high,

  /// <summary>
  /// Очень высокий
  /// </summary>
  @JsonValue(4)
  extraHigh,
}

extension GoalPriorityExtension on GoalPriority {
  /// Получить строковое представление приоритета
  String get name {
    switch (this) {
      case GoalPriority.extraLow:
        return 'Очень низкий';
      case GoalPriority.low:
        return 'Низкий';
      case GoalPriority.medium:
        return 'Средний';
      case GoalPriority.high:
        return 'Высокий';
      case GoalPriority.extraHigh:
        return 'Очень высокий';
      default:
        return '';
    }
  }

  /// Получить цвет приоритета
  Color get color {
    switch (this) {
      case GoalPriority.extraLow:
        return kGreenColor;
      case GoalPriority.low:
        return kLimeColor;
      case GoalPriority.medium:
        return kOrangeColor;
      case GoalPriority.high:
        return kPinkColor;
      case GoalPriority.extraHigh:
        return kRedColor;
      default:
        return kBlueColor;
    }
  }
}
