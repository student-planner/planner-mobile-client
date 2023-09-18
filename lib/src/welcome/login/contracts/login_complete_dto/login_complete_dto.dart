import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_complete_dto.freezed.dart';
part 'login_complete_dto.g.dart';

/// Модель данных для завершения авторизации
@freezed
class LoginCompleteDto with _$LoginCompleteDto {
  const factory LoginCompleteDto({
    required String ticketId,
    required String code,
  }) = _LoginCompleteDto;

  factory LoginCompleteDto.fromJson(Map<String, dynamic> json) =>
      _$LoginCompleteDtoFromJson(json);
}
