import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:validators/validators.dart';

import '../../../../core/constants/routes_constants.dart';
import '../../../../core/helpers/device_info_helper.dart';
import '../../../../theme/theme_colors.dart';
import '../../../../theme/theme_constants.dart';
import '../../../../theme/theme_extention.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/title_widget.dart';
import '../bloc/login_scope.dart';
import '../contracts/login_start_dto/login_start_dto.dart';

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
            Column(
              children: [
                const TitleWidget(
                  title: 'Добро пожаловать в Planner!',
                  description:
                      'Введите ваш email, на который мы отправим код для входа',
                ),
                const SizedBox(height: 25),
                TextFormField(
                  key: emailFieldKey,
                  controller: emailController,
                  onChanged: (value) {
                    final validationState =
                        emailFieldKey.currentState?.validate();
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
            const SizedBox(height: 48),
            const Text(
              'Еще нет аккаунта? Создайте его и начните планировать свое время!',
              textAlign: TextAlign.center,
            ),
            //const SizedBox(height: 25),
            TextButton(
              onPressed: () => navService.pushNamed(AppRoutes.register),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                  kPrimaryLighterColor.withOpacity(0.05),
                ),
              ),
              child: Text(
                'Зарегистрироваться',
                style: context.textTheme.titleMedium?.copyWith(
                  color: kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
