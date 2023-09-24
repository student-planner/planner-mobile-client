import 'package:freezed_annotation/freezed_annotation.dart';

import '../goal_base_dto/goal_base_dto.dart';
import '../goal_priority.dart';
import '../goal_status.dart';

part 'goal_detailed_dto.freezed.dart';
part 'goal_detailed_dto.g.dart';

/// Модель данных для цели
@freezed
class GoalDetailedDto with _$GoalDetailedDto {
  const factory GoalDetailedDto({
    required String id,
    required String name,
    required String description,
    required DateTime deadline,
    required double labor,
    required GoalPriority priority,
    required GoalStatus status,
    required List<GoalBaseDto> subGoals,
    required List<GoalBaseDto> dependGoals,
  }) = _GoalDetailedDto;

  factory GoalDetailedDto.fromJson(Map<String, dynamic> json) =>
      _$GoalDetailedDtoFromJson(json);
}

/// Расширение для модели данных цели
extension GoalDetailedDtoDuration on GoalDetailedDto {
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
