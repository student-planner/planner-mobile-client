import '../contracts/goal_dto/goal_dto.dart';
import '../contracts/goal_put_dto/goal_put_dto.dart';

/// Интерфейс репозитория для целей
abstract class IGoalsRepository {
  Future<List<GoalDto>> getGoals();
  Future<GoalDto> getGoal(String id);
  Future<int> putGoal(GoalPutDto goal);
}
