import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/constants/assets_constants.dart';
import '../../theme/theme_extention.dart';
import '../welcome/auth/auth_scope.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Planner',
          style: context.textTheme.headlineSmall?.copyWith(fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => AuthScope.loggedOut(context),
            icon: SvgPicture.asset(
              AppIcons.logout,
              colorFilter: ColorFilter.mode(
                context.textPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
