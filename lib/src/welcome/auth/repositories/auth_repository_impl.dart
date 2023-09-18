import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/helpers/my_logger.dart';
import '../../../../core/repositories/tokens/tokens_repository.dart';
import 'auth_repository.dart';

/// Репозиторий авторизации
class AuthRepositoryImpl implements IAuthRepository {
  final ITokensRepository _tokensRepository;

  AuthRepositoryImpl({
    required ITokensRepository tokensRepository,
  }) : _tokensRepository = tokensRepository;

  @override
  Future<bool> userHasBeenLoggedIn() async {
    // Достаточно проверить наличие одного токена
    final token = await _tokensRepository.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<bool> checkIsLoginAndFirstRun() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('first_run') ?? true) {
        await prefs.setBool('first_run', false);
      }
      return await userHasBeenLoggedIn();
    } catch (e) {
      MyLogger.e("AuthRepository -> isFirstRun() -> e -> $e");
      rethrow;
    }
  }
}
