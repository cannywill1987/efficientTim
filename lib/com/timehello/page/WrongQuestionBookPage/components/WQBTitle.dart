import 'package:flutter/material.dart';

class WQBTitle extends StatelessWidget {
  final String title;

  WQBTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xffFF8800),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
