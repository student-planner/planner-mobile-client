import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/extension/formatted_message.dart';
import '../../../../core/repositories/tokens/tokens_repository.dart';
import '../contracts/login_complete_dto/login_complete_dto.dart';
import '../contracts/login_start_dto/login_start_dto.dart';
import '../repositories/login_repository.dart';

part 'login_bloc.freezed.dart';

abstract class ILoginBloc extends Bloc<LoginEvent, LoginState> {
  ILoginBloc(super.initialState);
}

/// Блок логина
class LoginBloc extends ILoginBloc {
  final ITokensRepository _tokensRepository;
  final ILoginRepository _loginRepository;

  LoginBloc({
    required LoginState initialState,
    required ITokensRepository tokensRepository,
    required ILoginRepository loginRepository,
  })  : _tokensRepository = tokensRepository,
        _loginRepository = loginRepository,
        super(initialState) {
    on<LoginEvent>(
      (event, emit) => event.map(
        requestCode: (event) => _requestCode(event, emit),
        verifyCode: (event) => _verifyCode(event, emit),
      ),
    );
  }

  Future<void> _requestCode(
    _LoginRequestCodeEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final ticketDto = await _loginRepository.requestCode(event.startDto);
      emit(LoginState.successRequestCode(ticketId: ticketDto.ticketId));
    } on Exception catch (e) {
      emit(LoginState.error(message: e.getMessage));
      rethrow;
    }
  }

  Future<void> _verifyCode(
    _LoginVerifyCodeEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final tokensDto = await _loginRepository.verifyCode(event.completeDto);
      await _tokensRepository.saveTokens(
        tokensDto.accessToken,
        tokensDto.refreshToken,
      );
      emit(const LoginState.successVerifyCode());
    } on Exception catch (e) {
      emit(LoginState.error(message: e.getMessage));
      rethrow;
    }
  }
}

/// События логина
@freezed
abstract class LoginEvent with _$LoginEvent {
  /// Событие запроса кода
  const factory LoginEvent.requestCode({
    required LoginStartDto startDto,
  }) = _LoginRequestCodeEvent;

  /// Событие верификации кода
  const factory LoginEvent.verifyCode({
    required LoginCompleteDto completeDto,
  }) = _LoginVerifyCodeEvent;
}

/// Состояния логина
@freezed
abstract class LoginState with _$LoginState {
  /// Состояние загрузки
  const factory LoginState.loading() = _LoginLoadingState;

  /// Состояние удачного запроса кода
  const factory LoginState.successRequestCode({
    required String ticketId,
  }) = _LoginSuccessRequestCodeState;

  /// Состояние удачной верификации кода
  const factory LoginState.successVerifyCode() = _LoginSuccessVerifyCodeState;

  /// Состояние ошибки
  const factory LoginState.error({
    required String message,
  }) = _LoginErrorState;

  /// Состояние удачного запроса кода
  const factory LoginState.failureRequestCode({
    required String message,
  }) = _LoginFailureRequestCodeState;

  /// Состояние неудачной верификации кода
  const factory LoginState.failureVerifyCode({
    required String message,
  }) = _LoginFailureVerifyCodeState;
}
