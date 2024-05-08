import 'package:flutter/cupertino.dart';

class CustomGameText extends StatelessWidget {
  String text;

  CustomGameText({required this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(text);
  }

}