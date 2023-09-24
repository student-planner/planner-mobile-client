import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/helpers/my_logger.dart';
import '../contracts/goal_base_dto/goal_base_dto.dart';
import '../contracts/goal_important_dto/goal_important_dto.dart';
import 'goals_cache_manager.dart';

/// Реализация кэша целей через SharedPreferences
class GoalsCachePrefsManagerImpl implements IGoalsCacheManager {
  final String _importantGoalsKey = '_important_goals_key';
  final String _goalsKey = '_goals_keys';
  final String _goalsPrefixKey = '_goals_prefix__';

  @override
  Future<GoalBaseDto?> getGoal(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final goal = prefs.getString(_goalsPrefixKey + id);
      if (goal == null) {
        final goalIds = prefs.getStringList(_goalsKey);
        if (goalIds != null && goalIds.contains(id)) {
          goalIds.remove(id);
          await prefs.setStringList(_goalsKey, goalIds);
        }
        return Future.value(null);
      }
      return Future.value(GoalBaseDto.fromJson(jsonDecode(goal)));
    } catch (e) {
      MyLogger.e(e.toString());
      return Future.value(null);
    }
  }

  @override
  Future<List<GoalBaseDto>> getGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final goalIds = prefs.getStringList(_goalsKey);
      if (goalIds == null) {
        return Future.value([]);
      }
      final goals = <GoalBaseDto>[];
      for (final id in goalIds) {
        final goal = prefs.getString(_goalsPrefixKey + id);
        if (goal != null) {
          goals.add(GoalBaseDto.fromJson(jsonDecode(goal)));
        }
      }
      return Future.value(goals);
    } catch (e) {
      MyLogger.e(e.toString());
      return Future.value([]);
    }
  }

  @override
  Future<bool> setGoals(List<GoalBaseDto> goals) async {
    final newIds = goals.map((e) => e.id).toList();
    final goalById = Map<String, GoalBaseDto>.fromIterable(
      goals,
      key: (e) => e.id,
      value: (e) => e,
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      final oldIds = prefs.getStringList(_goalsKey);
      if (oldIds != null) {
        for (final id in oldIds) {
          if (!newIds.contains(id)) {
            await prefs.remove(_goalsPrefixKey + id);
          }
        }
      }
      for (final id in newIds) {
        await prefs.setString(_goalsPrefixKey + id, jsonEncode(goalById[id]));
      }
      return await prefs.setStringList(_goalsKey, newIds);
    } catch (e) {
      MyLogger.e(e.toString());
      return Future.value(false);
    }
  }

  @override
  Future<List<GoalImportantDto>> getMostImportantGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final goals = prefs.getStringList(_importantGoalsKey);
      if (goals == null) {
        return Future.value([]);
      }
      return Future.value(
        goals.map((e) => GoalImportantDto.fromJson(jsonDecode(e))).toList(),
      );
    } catch (e) {
      MyLogger.e(e.toString());
      return Future.value([]);
    }
  }

  @override
  Future<bool> setMostImportantGoals(List<GoalImportantDto> goals) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final goalsJson = goals.map((e) => jsonEncode(e.toJson())).toList();
      return await prefs.setStringList(_importantGoalsKey, goalsJson);
    } catch (e) {
      MyLogger.e(e.toString());
      return Future.value(false);
    }
  }

  @override
  Future<bool> deleteGoal(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final goalIds = prefs.getStringList(_goalsKey);
      if (goalIds != null && goalIds.contains(id)) {
        goalIds.remove(id);
        await prefs.setStringList(_goalsKey, goalIds);
      }
      return await prefs.remove(_goalsPrefixKey + id);
    } catch (e) {
      MyLogger.e(e.toString());
      return Future.value(false);
    }
  }
}
