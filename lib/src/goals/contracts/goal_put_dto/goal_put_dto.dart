import 'package:freezed_annotation/freezed_annotation.dart';

import '../goal_detailed_dto/goal_detailed_dto.dart';
import '../goal_priority.dart';
import '../goal_status.dart';

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
    required GoalStatus status,
    required List<String> subGoalsIds,
    required List<String> dependGoalsIds,
  }) = _GoalPutDto;

  factory GoalPutDto.fromGoalDetailedDto(GoalDetailedDto? goalDto) =>
      GoalPutDto(
        id: goalDto?.id,
        name: goalDto?.name ?? '',
        description: goalDto?.description ?? '',
        deadline: goalDto?.deadline ?? DateTime.now(),
        labor: goalDto?.labor ?? 0,
        priority: goalDto?.priority ?? GoalPriority.extraLow,
        status: goalDto?.status ?? GoalStatus.New,
        subGoalsIds: goalDto?.subGoals.map((e) => e.id).toList() ?? [],
        dependGoalsIds: goalDto?.dependGoals.map((e) => e.id).toList() ?? [],
      );

// factory GoalPutDto.fromGoalImportantDto(GoalImportantDto? goalDto) =>
//       GoalPutDto(
//         id: goalDto?.id,
//         name: goalDto?.name ?? '',
//         description: goalDto?.description ?? '',
//         deadline: goalDto?.deadline ?? DateTime.now(),
//         labor: goalDto?.labor ?? 0,
//         priority: goalDto?.priority ?? GoalPriority.extraLow,
//         status: goalDto?.status ?? GoalStatus.New,
//       );

  factory GoalPutDto.fromJson(Map<String, dynamic> json) =>
      _$GoalPutDtoFromJson(json);
}
