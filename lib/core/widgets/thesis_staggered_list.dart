import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../constants/constants.dart';

/// Компонент анимированного списка
class ThesisStaggeredList<T> extends StatelessWidget {
  const ThesisStaggeredList({
    super.key,
    required this.items,
    required this.renderChild,
  });

  final List<T> items;
  final Widget Function(T item) renderChild;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 375),
          child: SlideAnimation(
            child: FadeInAnimation(
              child: Padding(
                padding: kCardBottomPadding,
                child: renderChild(items[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
