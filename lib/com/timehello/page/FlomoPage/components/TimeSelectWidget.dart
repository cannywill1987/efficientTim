// a stateful widget has properties title, date(mm/dd Weekday)
// a statefulle widget's root is a column
// column has 3 children
// the first child is a text contain the title
// the second child is a row text contain the second property
// the third line is a row text "today"

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class FlomoTimeWidget extends StatefulWidget {
  final String title;
  final String date;
  final String today;

  const FlomoTimeWidget(
      {required this.title, required this.date, required this.today});

  @override
  State<StatefulWidget> createState() {
    return _FlomoTimeWidgetState();
  }
}

class _FlomoTimeWidgetState extends State<FlomoTimeWidget> {
  double margin = 10;
  @override
  void onCreate() {}

  @override
  void initState() {}

  @override
  void didUpdateWidget(FlomoTimeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: margin,),
        Text(this.widget.title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey
          ),
        ),
        SizedBox(height: margin,),
        Text(this.widget.date,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeManager.getInstance().getDefautThemeColor()
          ),
        ),
        SizedBox(height: margin,),
        Text(this.widget.today,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey
          ),
        ),
        SizedBox(height: margin,),
      ],
    );
  }
}