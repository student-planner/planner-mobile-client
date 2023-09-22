import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:provider/provider.dart';

import '../../core/constants/assets_constants.dart';
import '../../core/constants/routes_constants.dart';
import '../../core/widgets/tab_bar/thesis_tab_bar.dart';
import '../../theme/theme_constants.dart';
import '../../theme/theme_extention.dart';
import '../welcome/auth/bloc/auth_scope.dart';
import 'components/goals_data_provider.dart';
import 'tabs/goals/goals_tab.dart';
import 'tabs/important/important_tab.dart';

/// Страница с задачами пользователя
class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalsDataProvider>(
      builder: (context, provider, child) {
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
          floatingActionButton: FloatingActionButton(
            onPressed: () => navService
                .pushNamed(AppRoutes.goalsPut)
                .whenComplete(() => provider.refresh()),
            child: SvgPicture.asset(
              AppIcons.add,
              colorFilter: ColorFilter.mode(
                context.textPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          body: Padding(
            padding: kThemeDefaultPadding,
            child: ThesisTabBar(
              tabs: const ['Все задачи', 'Нужно сделать'],
              children: [
                GoalsTab(provider: provider),
                ImportantTab(provider: provider),
              ],
              onTap: (index) {
                if (index == 0) {
                  provider.refresh();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
