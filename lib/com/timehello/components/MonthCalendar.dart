import 'package:flutter/material.dart';

import 'MonthItem.dart';

/**
 * 用于创建任务艾宾浩斯 月历  用于选择日期
 */
class MonthCalendar extends StatelessWidget {
  final List<DateTime?> monthDates;
  final double itemSpacing;

  MonthCalendar({required this.monthDates, this.itemSpacing = 10.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      child: GridView.builder(
        itemCount: monthDates.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: itemSpacing,
          crossAxisSpacing: itemSpacing,
        ),
        itemBuilder: (context, index) {
          return MonthItem(
            percent: 1,
            color: Colors.orange.value,
            borderRadius: 10.0,
            width: 10.0,
            isDisabled: this.monthDates[index] == null,
          );
        },
      ),
    );
  }
}
