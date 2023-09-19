import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/extension/formatted_message.dart';
import '../contracts/goal_dto/goal_dto.dart';
import '../repositories/goals_repository.dart';

part 'goals_bloc.freezed.dart';

/// Интерфейс блока целей
abstract class IGoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  IGoalsBloc(super.initialState);
}

/// Блок целей
class GoalsBloc extends IGoalsBloc {
  final IGoalsRepository _goalsRepository;

  GoalsBloc({
    required GoalsState initialState,
    required IGoalsRepository goalsRepository,
  })  : _goalsRepository = goalsRepository,
        super(initialState) {
    on<GoalsEvent>(
      (event, emit) => event.map(
        load: (event) => _load(event, emit),
        loadSingle: (event) => _loadSingle(event, emit),
      ),
    );
  }

  Future<void> _load(
    _GoalsLoadEvent event,
    Emitter<GoalsState> emit,
  ) async {
    try {
      final goals = await _goalsRepository.getGoals();
      emit(GoalsState.loaded(goals: goals));
    } on Exception catch (e) {
      emit(GoalsState.error(message: e.getMessage));
      rethrow;
    }
  }

  Future<void> _loadSingle(
    _GoalsLoadSingleEvent event,
    Emitter<GoalsState> emit,
  ) async {
    try {
      final goal = await _goalsRepository.getGoal(event.id);
      emit(GoalsState.loadedSingle(goal: goal));
    } on Exception catch (e) {
      emit(GoalsState.error(message: e.getMessage));
      rethrow;
    }
  }
}

/// События логина
@freezed
abstract class GoalsEvent with _$GoalsEvent {
  /// Событие запроса кода
  const factory GoalsEvent.load() = _GoalsLoadEvent;

  /// Событие верификации кода
  const factory GoalsEvent.loadSingle({
    required String id,
  }) = _GoalsLoadSingleEvent;
}

/// Состояния логина
@freezed
abstract class GoalsState with _$GoalsState {
  /// Состояние загрузки
  const factory GoalsState.loading() = _GoalsLoadingState;

  /// Состояние удачной загрузки целей
  const factory GoalsState.loaded({
    required List<GoalDto> goals,
  }) = _GoalsLoadedState;

  /// Состояние удачной загрузки цели
  const factory GoalsState.loadedSingle({
    required GoalDto goal,
  }) = _GoalsLoadedSingleState;

  /// Состояние ошибки
  const factory GoalsState.error({
    required String message,
  }) = _GoalsErrorState;
}
