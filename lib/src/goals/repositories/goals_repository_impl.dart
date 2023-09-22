import '../../../core/helpers/dio_helper.dart';
import '../contracts/goal_dto/goal_dto.dart';
import '../contracts/goal_put_dto/goal_put_dto.dart';
import 'goals_repository.dart';

/// Реализация репозитория для целей
class GoalsRepositoryImpl implements IGoalsRepository {
  @override
  Future<GoalDto> getGoal(String id) async {
    try {
      final response = await DioHelper.getData(url: '/goal/$id');

      switch (response.statusCode) {
        case 200:
          return GoalDto.fromJson(response.data);
        default:
          throw Exception('Что-то пошло не так');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<GoalDto>> getGoals() async {
    try {
      final response = await DioHelper.getData(url: '/goal');

      switch (response.statusCode) {
        case 200:
          return (response.data as List)
              .map((e) => GoalDto.fromJson(e))
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
        url: '/goal',
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
  Future<List<GoalDto>> getMostImportantGoals() async {
    try {
      final response = await DioHelper.getData(url: '/goal/important');

      switch (response.statusCode) {
        case 200:
          return (response.data as List)
              .map((e) => GoalDto.fromJson(e))
              .toList();
        default:
          throw Exception('Что-то пошло не так');
      }
    } catch (e) {
      rethrow;
    }
  }
}
