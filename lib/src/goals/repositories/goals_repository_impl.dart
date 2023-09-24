import '../../../core/helpers/dio_helper.dart';
import '../contracts/goal_base_dto/goal_base_dto.dart';
import '../contracts/goal_detailed_dto/goal_detailed_dto.dart';
import '../contracts/goal_important_dto/goal_important_dto.dart';
import '../contracts/goal_put_dto/goal_put_dto.dart';
import 'goals_repository.dart';

/// Реализация репозитория для целей
class GoalsRepositoryImpl implements IGoalsRepository {
  @override
  Future<GoalDetailedDto> getGoal(String id) async {
    try {
      final response = await DioHelper.getData(url: '/goals/$id');

      switch (response.statusCode) {
        case 200:
          return GoalDetailedDto.fromJson(response.data);
        default:
          throw Exception('Что-то пошло не так');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<GoalBaseDto>> getGoals() async {
    try {
      final response = await DioHelper.getData(url: '/goals');

      switch (response.statusCode) {
        case 200:
          return (response.data as List)
              .map((e) => GoalBaseDto.fromJson(e))
              .toList();
        default:
          throw Exception('Что-то пошло не так');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> putGoal(GoalPutDto goal) async {
    try {
      final response = await DioHelper.putData(
        url: '/goals',
        data: goal.toJson(),
      );

      switch (response.statusCode) {
        case 201:
          return 201;
        case 204:
          return 204;
        case 400:
          throw Exception('Переданы некорректные данные');
        case 404:
          throw Exception('Задача не найдена');
        default:
          throw Exception('Что-то пошло не так');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<GoalImportantDto>> getMostImportantGoals() async {
    try {
      final response = await DioHelper.getData(url: '/goals/important');

      switch (response.statusCode) {
        case 200:
          return (response.data as List)
              .map((e) => GoalImportantDto.fromJson(e))
              .toList();
        default:
          throw Exception('Что-то пошло не так');
      }
    } catch (e) {
      rethrow;
    }
  }
}
