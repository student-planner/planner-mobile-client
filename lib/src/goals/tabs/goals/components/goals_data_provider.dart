import 'package:flutter/material.dart';

import '../../../contracts/goal_dto/goal_dto.dart';
import '../../../repositories/goals_repository.dart';

/// Провайдер данных для целей
class GoalsDataProvider with ChangeNotifier {
  final IGoalsRepository _goalsRepository;
  late Stream<List<GoalDto>> _goalsStream;

  GoalsDataProvider({
    required IGoalsRepository goalsRepository,
  }) : _goalsRepository = goalsRepository {
    _goalsStream = _goalsRepository.getGoals().asStream().asBroadcastStream();
  }

  Stream<List<GoalDto>> get goalsStream => _goalsStream;

  void refresh() {
    _goalsStream = _goalsRepository.getGoals().asStream().asBroadcastStream();
    notifyListeners();
  }

  Future<GoalDto> getGoal(String id) async {
    try {
      return await _goalsRepository.getGoal(id);
    } on Exception catch (_) {
      rethrow;
    }
  }
}
