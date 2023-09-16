/// Интерфейс репозиторий работы с пользователем
abstract class IUserRepository {
  /// Сохранить роль пользователя
  Future<bool> saveRole(int role);

  /// Получить роль пользователя
  Future<int?> getRole();

  /// Установить флаг использования dev API
  Future<bool> setUserUsingDevApi(bool value);

  /// Получить флаг использования dev API
  Future<bool> getUserIsUsingDevApi();
}
