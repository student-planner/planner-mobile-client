import 'package:freezed_annotation/freezed_annotation.dart';

import '../goal_priority.dart';
import '../goal_status.dart';

part 'goal_dto.freezed.dart';
part 'goal_dto.g.dart';

/// Модель данных для цели
@freezed
class GoalDto with _$GoalDto {
  const factory GoalDto({
    required String id,
    required String name,
    required String description,
    required DateTime deadline,
    required double labor,
    required GoalPriority priority,
    required GoalStatus status,
  }) = _GoalDto;

  factory GoalDto.fromJson(Map<String, dynamic> json) =>
      _$GoalDtoFromJson(json);
}

/// Расширение для модели данных цели
extension GoalDtoDuration on GoalDto {
  /// Возвращает длительность цели в формате "ч. мин."
  String get duration {
    final dur = Duration(seconds: this.labor.toInt());
    var result = '';
    final hours = dur.inHours;
    if (hours > 0) {
      result += '$hours ч. ';
    }
    final minutes = dur.inMinutes.remainder(60);
    if (minutes > 0) {
      result += '$minutes мин.';
    }
    return result.trim();
  }
}
