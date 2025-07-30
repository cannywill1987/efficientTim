import 'package:flutter/cupertino.dart';

/**
 * gpt 更多页面的标题
 */
class ChatGptMoreSectionTitleWidget extends StatelessWidget {
  String title;
  ChatGptMoreSectionTitleWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(left: 5, right: 15, top: 0, bottom: 3),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          color: Color(0xff888888),
        ),
      ),
    );
  }
}