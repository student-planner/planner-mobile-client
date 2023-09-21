import 'package:flutter/cupertino.dart';

import '../../../../theme/theme_extention.dart';

class ThesisDurationPicker {
  static Future<Duration> show(BuildContext context) async {
    final hoursNotifier = ValueNotifier<int>(0);
    final minutesNotifier = ValueNotifier<int>(0);
    final height = MediaQuery.of(context).size.height * 0.4;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: height,
          width: double.infinity,
          color: context.currentTheme.cardTheme.color,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
            ).copyWith(bottom: 32),
            child: Row(
              children: [
                Flexible(
                  child: ValueListenableBuilder(
                    valueListenable: hoursNotifier,
                    builder: (context, hours, child) {
                      return CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (value) {
                          hoursNotifier.value = value;
                        },
                        children: List.generate(24, (index) {
                          return Center(
                            child: Text(
                              hours == index ? '$index ч' : index.toString(),
                              style: context.textTheme.titleMedium,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
                Flexible(
                  child: ValueListenableBuilder(
                    valueListenable: minutesNotifier,
                    builder: (context, minutes, child) {
                      return CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (value) {
                          minutesNotifier.value = value;
                        },
                        children: List.generate(60, (index) {
                          return Center(
                            child: Text(
                              minutes == index
                                  ? '$index мин'
                                  : index.toString(),
                              style: minutes == index
                                  ? context.textTheme.titleLarge
                                  : context.textTheme.titleMedium,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    return Duration(
      hours: hoursNotifier.value,
      minutes: minutesNotifier.value,
    );
  }
}
