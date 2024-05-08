import 'package:flutter/material.dart';

class MonthItem extends StatelessWidget {
  final double percent;
  final int color;
  final double borderRadius;
  final double width;
  final bool isDisabled;

  MonthItem({
    required this.percent,
    required this.color,
    required this.borderRadius,
    required this.width,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: percent > 0 && isDisabled == false? BoxDecoration(
        color: Color(color).withOpacity(percent),
        borderRadius: BorderRadius.circular(borderRadius),
      ) : BoxDecoration(
        border: Border.all(width: 1, color: Color(color)),
        // color: Color(color).withOpacity(percent),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: isDisabled
          ? Stack(
              children: [
                // Positioned(
                //   top: width / 4,
                //   left: 0,
                //   right: 0,
                //   child: Divider(color: Color(color), thickness: 1),
                // ),
                Align(alignment: Alignment(0,-1),child: Divider(color: Color(color), thickness: 1)),
                Align(alignment: Alignment(0,-0.5),child: Divider(color: Color(color), thickness: 1)),
                Align(alignment: Alignment(0,0),child: Divider(color: Color(color), thickness: 1)),
                Align(alignment: Alignment(0,0.5),child: Divider(color: Color(color), thickness: 1)),
                Align(alignment: Alignment(0,1),child: Divider(color: Color(color), thickness: 1)),
                // Align(alignment: Alignment(0,1.5),child: Divider(color: Color(color), thickness: 1)),
                // Positioned(
                //   top: width * 3 / 4,
                //   left: 0,
                //   child: Divider(color: Color(color), thickness: 1),
                // ),
              ],
            )
          : null,
    );
  }
}
