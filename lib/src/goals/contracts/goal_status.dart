import 'package:freezed_annotation/freezed_annotation.dart';

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
