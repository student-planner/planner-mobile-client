import 'package:flutter/material.dart';

import 'thesis_tab_bar_item.dart';

/// Компонент таб-бар
class ThesisTabBar extends StatelessWidget {
  const ThesisTabBar({
    super.key,
    required this.tabs,
    required this.children,
    this.onTap,
  });

  final List<String> tabs;
  final List<Widget> children;
  final void Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    final pickedNotifier = ValueNotifier<int>(0);
    return ValueListenableBuilder(
      valueListenable: pickedNotifier,
      builder: (context, currentIndex, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tabs.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index != tabs.length - 1 ? 8 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        pickedNotifier.value = index;
                        onTap?.call(index);
                      },
                      child: ThesisTabBarItem(
                        title: tabs[index],
                        isPicked: currentIndex == index,
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            children[currentIndex],
          ],
        );
      },
    );
  }
}
