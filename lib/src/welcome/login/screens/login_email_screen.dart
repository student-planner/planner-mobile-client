import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

import '../../../../core/helpers/device_info_helper.dart';
import '../../../../theme/theme_constants.dart';
import '../bloc/login_scope.dart';
import '../contracts/login_start_dto/login_start_dto.dart';
import '../widgets/button_widget.dart';
import '../widgets/title_widget.dart';

/// Страница ввода email
class LoginEmailScreen extends StatelessWidget {
  const LoginEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(
      text: kDebugMode ? 'seljmov@list.ru' : '',
    );
    final emailFieldKey = GlobalKey<FormFieldState<String>>();
    final buttonDisableNotifier = ValueNotifier<bool>(
      emailController.text.isEmpty,
    );
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: kThemeDefaultPadding.copyWith(top: 0),
        child: Column(
          children: [
            const TitleWidget(
              title: 'Добро пожаловать в Planner!',
              description:
                  'Введите ваш email, на который мы отправим код для входа. Нет аккаунта? Мы создадим его для вас.',
            ),
            const SizedBox(height: 25),
            TextFormField(
              key: emailFieldKey,
              controller: emailController,
              onChanged: (value) {
                final validationState = emailFieldKey.currentState?.validate();
                buttonDisableNotifier.value = !(validationState ?? true);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Поле не может быть пустым.';
                }
                if (!isEmail(value)) {
                  return 'Неверный формат данных. Введите почту в формате im@example.ru.';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'im@example.ru',
              ),
            ),
            const SizedBox(height: 50),
            ButtonWidget(
              buttonDisableNotifier: buttonDisableNotifier,
              onPressed: () async {
                if (emailFieldKey.currentState?.validate() ?? false) {
                  final deviceInfo = await DeviceInfoHelper.get();
                  final startDto = LoginStartDto(
                    email: emailController.text,
                    deviceDescription: jsonEncode(deviceInfo),
                  );
                  LoginScope.requestCode(context, startDto);
                }
              },
              title: 'Продолжить',
            ),
          ],
        ),
      ),
    );
  }
}
