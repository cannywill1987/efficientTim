// 一个组件
// 左边一个色值959595左箭头的可点击小按钮
// 右边一个色值959595右箭头的可点击小按钮
// 中间是通过毫秒时间戳生成的yyyy.mm格式的色值333333时间
// onChange回调

import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../util/Utility.dart';

class FlomoSelectDateWidget extends StatefulWidget {
  final ValueChanged<DateTime> onChange;
  final DateTime currentDateTime; // 新增的属性
  late DateTime maxDatetime; // 新增的属性
  late DateTime minDatetime; // 新增的属性

  FlomoSelectDateWidget(
      {Key? key,
      required this.onChange,
      required this.currentDateTime,
      DateTime? maxDatetime,
      DateTime? minDatetime})
      : super(key: key) {
    if (maxDatetime == null) {
      this.maxDatetime = Utility.getDateTimeAddMonth(currentDateTime, 36);
    } else {
      this.maxDatetime = maxDatetime.subtract(Duration(days: 31));
    }
    if (minDatetime == null) {
      this.minDatetime = Utility.getDateTimeAddMonth(currentDateTime, -36);
    } else {
      this.minDatetime = minDatetime;
    }
    print(
        "~~~~~~~~~~~~~~~~FlomoSelectDateWidget~~~~~~~~~~~~~~~~~~~~~~~${this.currentDateTime} ${this.maxDatetime} ${this.minDatetime}");
  }

  @override
  FlomoSelectDateWidgetState createState() =>
      FlomoSelectDateWidgetState(selectedDate: currentDateTime);
}

class FlomoSelectDateWidgetState extends State<FlomoSelectDateWidget> {
  late DateTime selectedDate; // 修改为非final
  // late DateTime maxDatetime;
  // late DateTime minDatetime;
  FlomoSelectDateWidgetState({required DateTime selectedDate}) {
    this.selectedDate = selectedDate; // 使用传入的当前日期时间初始化selectedDate
  }

  void _previousDate() {
    DateTime newDate = Utility.getDateTimeAddMonth(selectedDate, -1);
    if (newDate.isAfter(this.widget.minDatetime) ||
        newDate.isAtSameMomentAs(this.widget.minDatetime)) {
      setState(() {
        selectedDate = newDate;
        widget.onChange(selectedDate);
      });
    }
  }

  @override
  void didUpdateWidget(covariant FlomoSelectDateWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget' +
        oldWidget.currentDateTime.toString() +
        " " +
        widget.currentDateTime.toString());
    if (oldWidget.currentDateTime.month != widget.currentDateTime.month) {
      setState(() {
        selectedDate = widget.currentDateTime;
      });
    }
  }

  void _nextDate() {
    DateTime newDate = Utility.getDateTimeAddMonth(selectedDate, 1);
    if (newDate.isBefore(this.widget.maxDatetime) ||
        newDate.isAtSameMomentAs(this.widget.maxDatetime)) {
      setState(() {
        selectedDate = newDate;
        widget.onChange(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: ThemeManager.getInstance().getIconColor(defaultColor: Color(0xFF959595)),
            size: 16,
          ),
          onPressed: _previousDate,
        ),
        Text(
          '${selectedDate.year}.${selectedDate.month.toString().padLeft(2, '0')}',
          style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xFF333333))),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
            color: ThemeManager.getInstance().getIconColor(defaultColor: Color(0xFF959595)),
            size: 16,
          ),
          onPressed: _nextDate,
        ),
      ],
    );
  }
}
