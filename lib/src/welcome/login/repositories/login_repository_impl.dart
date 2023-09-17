import '../../../../core/helpers/dio_helper.dart';
import '../contracts/login_complete_dto/login_complete_dto.dart';
import '../contracts/login_start_dto/login_start_dto.dart';
import '../contracts/ticket_dto/ticket_dto.dart';
import '../contracts/tokens_dto/tokens_dto.dart';
import 'login_repository.dart';

/// Репозиторий авторизации
class LoginRepositoryImpl implements ILoginRepository {
  @override
  Future<TicketDto> requestCode(LoginStartDto startDto) async {
    try {
      final response = await DioHelper.postData(
        url: '/auth/start',
        data: startDto.toJson(),
        useAuthErrorInterceptor: false,
      );

      switch (response.statusCode) {
        case 200:
          return TicketDto.fromJson(response.data);
        case 400:
          throw Exception('Передан некорректный email');
        case 404:
          throw Exception(
            'Пользователь с таким email не найден. Пожалуйста, зарегистрируйтесь',
          );
        default:
          throw Exception('Что-то пошло не так');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TokensDto> verifyCode(LoginCompleteDto completeDto) async {
    try {
      final response = await DioHelper.postData(
        url: '/auth/complete',
        data: completeDto.toJson(),
        useAuthErrorInterceptor: false,
      );

      switch (response.statusCode) {
        case 200:
          return TokensDto.fromJson(response.data);
        case 400:
          throw Exception('Переданы некорректные данные!');
        case 404:
          throw Exception('Время действия кода истекло!');
        case 409:
          throw Exception('Передан неверный код!');
        default:
          throw Exception('Что-то пошло не так...');
      }
    } catch (e) {
      rethrow;
    }
  }
}
