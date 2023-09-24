import '../contracts/goal_base_dto/goal_base_dto.dart';
import '../contracts/goal_detailed_dto/goal_detailed_dto.dart';
import '../contracts/goal_important_dto/goal_important_dto.dart';
import '../contracts/goal_put_dto/goal_put_dto.dart';

/// Интерфейс репозитория для целей
abstract class IGoalsRepository {
  /// Получить все цели
  Future<List<GoalBaseDto>> getGoals();

  /// Получить цель по id
  Future<GoalDetailedDto> getGoal(String id);

  /// Добавить/изменить цель
  Future<int> putGoal(GoalPutDto goal);

  /// Получить цели с наивысшим приоритетом
  Future<List<GoalImportantDto>> getMostImportantGoals();
}
