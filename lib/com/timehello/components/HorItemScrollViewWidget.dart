import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/components/TimeRatioComponent.dart';

class HorItemScrollViewWidget extends StatefulWidget {
  List<TimeSegment> datas;

  HorItemScrollViewWidget({required this.datas});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HorItemScrollViewWidgetState();
  }

}

class HorItemScrollViewWidgetState extends State<HorItemScrollViewWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: this.widget.datas.map((section) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  color: section.color,
                ),
                SizedBox(width: 4),
                Text(section.label),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}