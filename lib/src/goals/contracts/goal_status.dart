import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../theme/theme_colors.dart';

/// Статус цели
enum GoalStatus {
  /// Новая
  @JsonValue(0)
  New,

  /// В процессе
  @JsonValue(1)
  InProgress,

  /// Выполнена
  @JsonValue(2)
  Done,

  /// Просрочена
  @JsonValue(3)
  Overdue,
}

extension GoalStatusExtension on GoalStatus {
  /// Возвращает название статуса
  String get name {
    switch (this) {
      case GoalStatus.New:
        return 'Новая';
      case GoalStatus.InProgress:
        return 'В работе';
      case GoalStatus.Done:
        return 'Выполнена';
      case GoalStatus.Overdue:
        return 'Просрочена';
      default:
        return '';
    }
  }

  /// Возвращает цвет статуса
  Color get color {
    switch (this) {
      case GoalStatus.New:
        return kGray2Color;
      case GoalStatus.InProgress:
        return kOrangeColor;
      case GoalStatus.Done:
        return kGreenColor;
      case GoalStatus.Overdue:
        return kRedColor;
      default:
        return kGray3Color;
    }
  }
}
