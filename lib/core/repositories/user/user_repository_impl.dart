import 'package:shared_preferences/shared_preferences.dart';

import 'user_repository.dart';

/// Репозиторий работы с пользователем
class UserRepositoryImpl implements IUserRepository {
  static const String _roleKey = '_roleKey';
  static const String _apiAddress = '_apiAddress';

  @override
  Future<bool> saveRole(int role) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(_roleKey, role);
  }

  @override
  Future<int?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_roleKey);
  }

  @override
  Future<bool> setUserUsingDevApi(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_apiAddress, value);
  }

  @override
  Future<bool> getUserIsUsingDevApi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_apiAddress) ?? false;
  }
}
