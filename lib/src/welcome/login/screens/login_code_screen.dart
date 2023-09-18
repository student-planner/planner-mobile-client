import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:validators/validators.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../theme/theme_constants.dart';
import '../../../../theme/theme_extention.dart';
import '../bloc/login_scope.dart';
import '../contracts/login_complete_dto/login_complete_dto.dart';
import '../contracts/ticket_dto/ticket_dto.dart';
import '../widgets/button_widget.dart';
import '../widgets/title_widget.dart';

class LoginCodeScreen extends StatelessWidget {
  const LoginCodeScreen({
    super.key,
    required this.ticketDto,
  });

  final TicketDto ticketDto;

  @override
  Widget build(BuildContext context) {
    final codeController = TextEditingController();
    final codeFieldKey = GlobalKey<FormFieldState<String>>();
    final buttonDisableNotifier = ValueNotifier<bool>(true);
    final greating = ticketDto.isNewUser
        ? 'Заметили, что вы новенький! Отправили код на почту. Введите его для создания аккаунта и входа в приложение.'
        : 'Вам был отправлен код. Введите его для подтверждения личности.';
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: SvgPicture.asset(
              AppIcons.close,
              colorFilter: ColorFilter.mode(
                context.textPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: kThemeDefaultPadding.copyWith(top: 0),
        child: Column(
          children: [
            TitleWidget(
              title: 'Подтвердите ваш Email',
              description: greating,
            ),
            const SizedBox(height: 25),
            TextFormField(
              key: codeFieldKey,
              maxLength: 6,
              controller: codeController,
              onChanged: (value) {
                final validationState = codeFieldKey.currentState?.validate();
                buttonDisableNotifier.value = !(validationState ?? true);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Поле не может быть пустым.';
                }
                if (!isNumeric(value)) {
                  return 'Неверный формат данных. Введите код в формате 123456.';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: '123456',
                counterStyle: context.textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 50),
            ButtonWidget(
              buttonDisableNotifier: buttonDisableNotifier,
              onPressed: () {
                if (codeFieldKey.currentState?.validate() ?? false) {
                  final completeDto = LoginCompleteDto(
                    ticketId: ticketDto.ticketId,
                    code: codeController.text,
                  );
                  LoginScope.verifyCode(context, completeDto);
                }
              },
              title: 'Войти',
            ),
          ],
        ),
      ),
    );
  }
}
