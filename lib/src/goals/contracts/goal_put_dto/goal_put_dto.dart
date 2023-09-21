import 'package:freezed_annotation/freezed_annotation.dart';

import '../goal_dto/goal_dto.dart';
import '../goal_priority.dart';

part 'goal_put_dto.freezed.dart';
part 'goal_put_dto.g.dart';

/// Модель данных для цели
@freezed
class GoalPutDto with _$GoalPutDto {
  const factory GoalPutDto({
    required String? id,
    required String name,
    required String description,
    required DateTime deadline,
    required double labor,
    required GoalPriority priority,
    required List<String> subGoalsIds,
    required List<String> dependGoalsIds,
  }) = _GoalPutDto;

  factory GoalPutDto.fromGoalDto(GoalDto? goalDto) => GoalPutDto(
        id: goalDto?.id,
        name: goalDto?.name ?? '',
        description: goalDto?.description ?? '',
        deadline: goalDto?.deadline ?? DateTime.now(),
        labor: goalDto?.labor ?? 0,
        priority: goalDto?.priority ?? GoalPriority.low,
        subGoalsIds: goalDto?.subGoalsIds ?? [],
        dependGoalsIds: goalDto?.dependGoalsIds ?? [],
      );

  factory GoalPutDto.fromJson(Map<String, dynamic> json) =>
      _$GoalPutDtoFromJson(json);
}
