import '../contracts/goal_base_dto/goal_base_dto.dart';
import '../contracts/goal_important_dto/goal_important_dto.dart';

abstract class IGoalsCacheManager {
  /// Получить все цели
  Future<List<GoalBaseDto>> getGoals();

  /// Получить цель по id
  Future<GoalBaseDto?> getGoal(String id);

  /// Установить цели
  Future<bool> setGoals(List<GoalBaseDto> goals);

  /// Получить цели с наивысшим приоритетом
  Future<List<GoalImportantDto>> getMostImportantGoals();

  /// Установить цели с наивысшим приоритетом
  Future<bool> setMostImportantGoals(List<GoalImportantDto> goals);

  /// Удалить цель
  Future<bool> deleteGoal(String id);
}
