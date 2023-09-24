import 'package:freezed_annotation/freezed_annotation.dart';

import '../goal_status.dart';

part 'goal_base_dto.freezed.dart';
part 'goal_base_dto.g.dart';

/// Модель данных для цели
@freezed
class GoalBaseDto with _$GoalBaseDto {
  const factory GoalBaseDto({
    required String id,
    required String name,
    required String description,
    required DateTime deadline,
    required GoalStatus status,
  }) = _GoalBaseDto;

  factory GoalBaseDto.fromJson(Map<String, dynamic> json) =>
      _$GoalBaseDtoFromJson(json);
}
