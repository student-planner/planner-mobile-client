import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../contracts/login_complete_dto/login_complete_dto.dart';
import '../contracts/login_start_dto/login_start_dto.dart';
import 'login_bloc.dart';

/// Скоп для блока авторизации
abstract class LoginScope {
  /// Получить блок
  static ILoginBloc of(BuildContext context) {
    return BlocProvider.of<ILoginBloc>(context);
  }

  /// Запросить код авторизации
  static void requestCode(BuildContext context, LoginStartDto startDto) {
    of(context).add(LoginEvent.requestCode(startDto: startDto));
  }

  /// Верифицировать код авторизации
  static void verifyCode(BuildContext context, LoginCompleteDto completeDto) {
    of(context).add(LoginEvent.verifyCode(completeDto: completeDto));
  }
}
