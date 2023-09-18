import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_dto.freezed.dart';
part 'ticket_dto.g.dart';

/// Модель тикета
@freezed
class TicketDto with _$TicketDto {
  const factory TicketDto({
    required String ticketId,
    required bool isNewUser,
  }) = _TicketDto;

  factory TicketDto.fromJson(Map<String, dynamic> json) =>
      _$TicketDtoFromJson(json);
}
