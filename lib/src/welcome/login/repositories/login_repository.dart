import '../contracts/login_complete_dto/login_complete_dto.dart';
import '../contracts/login_start_dto/login_start_dto.dart';
import '../contracts/ticket_dto/ticket_dto.dart';
import '../contracts/tokens_dto/tokens_dto.dart';

/// Интерфейс репозитория авторизации
abstract class ILoginRepository {
  /// Запросить код для авторизации
  Future<TicketDto> requestCode(LoginStartDto startDto);

  /// Подтвердить код авторизации
  Future<TokensDto> verifyCode(LoginCompleteDto completeDto);
}
