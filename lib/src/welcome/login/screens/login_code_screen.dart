import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:validators/validators.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../theme/theme_constants.dart';
import '../../../../theme/theme_extention.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/title_widget.dart';
import '../bloc/login_scope.dart';
import '../contracts/login_complete_dto/login_complete_dto.dart';

class LoginCodeScreen extends StatelessWidget {
  const LoginCodeScreen({
    super.key,
    required this.ticketId,
  });

  final String ticketId;

  @override
  Widget build(BuildContext context) {
    final codeController = TextEditingController();
    final codeFieldKey = GlobalKey<FormFieldState<String>>();
    final buttonDisableNotifier = ValueNotifier<bool>(true);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: SvgPicture.asset(
              AppIcons.close,
              colorFilter: const ColorFilter.mode(
                Colors.white,
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
            const TitleWidget(
              title: 'Подтвердите ваш Email',
              description:
                  'Вам был отправлен код. Введите его для подтверждения личности.',
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
                    ticketId: ticketId,
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
