import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_start_dto.freezed.dart';
part 'login_start_dto.g.dart';

/// Модель данных для начала авторизации
@freezed
class LoginStartDto with _$LoginStartDto {
  const factory LoginStartDto({
    required String email,
    required String deviceDescription,
  }) = _LoginStartDto;

  factory LoginStartDto.fromJson(Map<String, dynamic> json) =>
      _$LoginStartDtoFromJson(json);
}
