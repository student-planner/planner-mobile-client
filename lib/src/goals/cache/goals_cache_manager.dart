import '../contracts/goal_dto/goal_dto.dart';

abstract class IGoalsCacheManager {
  /// Получить все цели
  Future<List<GoalDto>> getGoals();

  /// Получить цель по id
  Future<GoalDto?> getGoal(String id);

  /// Установить цели
  Future<bool> setGoals(List<GoalDto> goals);

  /// Получить цели с наивысшим приоритетом
  Future<List<GoalDto>> getMostImportantGoals();

  /// Установить цели с наивысшим приоритетом
  Future<bool> setMostImportantGoals(List<GoalDto> goals);

  /// Удалить цель
  Future<bool> deleteGoal(String id);
}
