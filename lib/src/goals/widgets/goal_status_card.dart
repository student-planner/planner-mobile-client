import 'package:flutter/material.dart';

/// Карточка состояния заявок
class GoalStatusCard extends StatelessWidget {
  const GoalStatusCard({
    super.key,
    required this.stateName,
    required this.stateColor,
    this.showInfo = false,
  });

  final String stateName;
  final Color stateColor;
  final bool showInfo;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: stateColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              stateName,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            Visibility(
              visible: showInfo,
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.error,
                  size: 18,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
