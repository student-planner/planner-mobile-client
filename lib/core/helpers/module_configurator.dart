import 'package:flutter_simple_dependency_injection/injector.dart';

import '../repositories/tokens/tokens_repository.dart';
import '../repositories/tokens/tokens_repository_impl.dart';
import '../repositories/user/user_repository.dart';
import '../repositories/user/user_repository_impl.dart';

/// Инжектор зависимостей
final Injector injector = Injector();

/// Конфигурация модулей
class ModuleConfigurator {
  /// Инициализация модулей
  static void init() {
    injector.map<ITokensRepository>((i) => TokensRepositoryImpl());
    injector.map<IUserRepository>((i) => UserRepositoryImpl());
  }
}
