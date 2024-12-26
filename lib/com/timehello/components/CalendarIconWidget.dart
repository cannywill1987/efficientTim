import 'package:flutter/material.dart';

class CalendarIconWidget extends StatelessWidget {
  double width = 80; // 图标宽度
  double height = 100; // 图标高度
  DateTime now = DateTime.now();
  int day = DateTime.now().day; // 今天是几号
  String month = '${DateTime.now().month}月'; // 当前月份

  CalendarIconWidget({
    this.width = 80,
    this.height = 100,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // 图标宽度
      height: height, // 图标高度
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          // BoxShadow(
          //   color: Colors.grey.withOpacity(0.5),
          //   blurRadius: 8,
          //   offset: Offset(0, 4), // 阴影偏移
          // ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 月份
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(2),
            ),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 0),
            child: Text(
              month,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 6,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 日期
          Expanded(
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
