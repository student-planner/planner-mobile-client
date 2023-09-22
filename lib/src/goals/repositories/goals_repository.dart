import '../contracts/goal_dto/goal_dto.dart';
import '../contracts/goal_put_dto/goal_put_dto.dart';

/// Интерфейс репозитория для целей
abstract class IGoalsRepository {
  /// Получить все цели
  Future<List<GoalDto>> getGoals();

  /// Получить цель по id
  Future<GoalDto> getGoal(String id);

  /// Добавить/изменить цель
  Future<int> putGoal(GoalPutDto goal);

  /// Получить цели с наивысшим приоритетом
  Future<List<GoalDto>> getMostImportantGoals();
}
