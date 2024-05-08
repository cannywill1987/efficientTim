import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class ContainerWidget extends StatelessWidget {
  Widget? child;
  double paddingTop;
  double paddingBottom;
  ContainerWidget({this.child, this.paddingBottom: 10, this.paddingTop: 20});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      key: ValueKey('12133a'),
      padding: EdgeInsets.only(top: this.paddingTop, bottom: this.paddingBottom),
      constraints: BoxConstraints(minHeight: 60),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 2, color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: ColorsConfig.borderLineColor))
      ),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: child,
    );
  }

}