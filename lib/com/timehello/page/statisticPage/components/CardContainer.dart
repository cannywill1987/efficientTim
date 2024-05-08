import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final String title;


  const CardContainer({Key? key, required this.child, required this.title}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        key: ValueKey('Card_1'),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white),
        child: Stack(
          key: ValueKey('Stack_1'),
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.40,
              child: Container(
                key: ValueKey('Container_12'),
                decoration:  BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 12.0, top: 35, bottom: 12),
                  child: this.child,
                ),
              ),
            ),
            Positioned(
              key: ValueKey('Positioned_12'),
              top: 2,
              left: 10,
              child: Padding(padding: EdgeInsets.only(left:30, bottom: 10), child: TextButton(
                key: ValueKey('TextButton_12'),
                onPressed: () {  },
                child: Text(
                  title ?? '',
                  style: TextStyle(fontSize: 12, color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)))
                ),
              ),
              ),
            ),
          ],
        ));
  }

}