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
    required List<String> subGoalsIds,
    required List<String> dependGoalsIds,
  }) = _GoalDto;

  factory GoalDto.fromJson(Map<String, dynamic> json) =>
      _$GoalDtoFromJson(json);
}
