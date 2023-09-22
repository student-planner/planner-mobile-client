import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../cache/goals_cache_manager.dart';
import '../contracts/goal_dto/goal_dto.dart';
import '../contracts/goal_put_dto/goal_put_dto.dart';
import '../repositories/goals_repository.dart';

/// Провайдер данных для целей
class GoalsDataProvider with ChangeNotifier {
  final IGoalsCacheManager _goalsCacheManager;
  final IGoalsRepository _goalsRepository;
  late Stream<List<GoalDto>> _goalsStream;

  GoalsDataProvider({
    required IGoalsRepository goalsRepository,
    required IGoalsCacheManager goalsCacheManager,
  })  : _goalsRepository = goalsRepository,
        _goalsCacheManager = goalsCacheManager {
    _setStream();
  }

  Stream<List<GoalDto>> get goalsStream => _goalsStream;
  Future<bool> get _isConnectionAvailable async {
    return await (Connectivity().checkConnectivity()) !=
        ConnectivityResult.none;
  }

  void refresh() {
    _setStream();
    notifyListeners();
  }

  void _setStream() {
    final future = _loadGoals();
    _goalsStream = future.asStream().asBroadcastStream();
    future.then((goals) => _goalsCacheManager.setGoals(goals));
  }

  Future<List<GoalDto>> _loadGoals() async {
    final hasConnection = await _isConnectionAvailable;
    return hasConnection
        ? _goalsRepository.getGoals()
        : _goalsCacheManager.getGoals();
  }

  Future<GoalDto> getGoal(String id) async {
    try {
      return await _goalsRepository.getGoal(id);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<int> putGoal(GoalPutDto goal) async {
    try {
      return await _goalsRepository.putGoal(goal);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<List<GoalDto>> loadMostImportantGoals() async {
    try {
      final important = await _goalsRepository.getMostImportantGoals();
      await _goalsCacheManager.setMostImportantGoals(important);
      return important;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<List<GoalDto>> getMostImportantGoalsFromCache() async {
    try {
      return await _goalsCacheManager.getMostImportantGoals();
    } on Exception catch (_) {
      rethrow;
    }
  }
}
