/// Интерфейс репозиторий авторизации
abstract class IAuthRepository {
  /// Проверить авторизованность пользователя
  Future<bool> userHasBeenLoggedIn();

  /// Проверить первый ли это запуск приложения
  Future<bool> checkIsLoginAndFirstRun();
}
