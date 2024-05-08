import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/AvatarWidget.dart';
import 'package:time_hello/com/timehello/models/CommentModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/CONSTANTS.dart';

class FeedbackListView extends StatelessWidget {
  List<CommentModel>? datas;

  FeedbackListView({this.datas});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List list = CONSTANTS.getCommentModelsList(datas!);

    return new ListView.builder(
      itemCount: list.length,
      padding: EdgeInsets.only(top: 10, bottom: 100),
      //整个listview的top bottom margin
      itemBuilder: (context, int index) {
        return FeedbackItem(
          commentModel: list[index],
        );
      },
    );
  }
}

class FeedbackItem extends StatelessWidget {
  CommentModel commentModel;

  FeedbackItem({required this.commentModel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AvatarWidget(
            avatar: this.commentModel.avatar,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.commentModel.username ?? "",
                  style: TextStyle(fontSize: 10, color: Color(0xffff8800)),
                ),
                Text(
                  this.commentModel.title ?? "",
                  softWrap: true,
                  style: TextStyle(fontSize: 12, color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040))),
                )
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            CONSTANTS.getComment(this.commentModel.status ?? 0),
            style: TextStyle(
                fontSize: 12,
                color: this.commentModel.status == 0
                    ? Colors.red
                    : this.commentModel.status == 1
                        ? Colors.purple
                        : this.commentModel.status == 2
                            ? Colors.blue
                            : Colors.green),
          ),
          SizedBox(
            width: 10,
          ),
          // getResponse(content: this.commentModel.content),
        ],
      ),
      getResponse(commentModel: this.commentModel),
    ]);
  }

  Widget getResponse({required CommentModel commentModel}) {
    if (TextUtil.isEmpty(commentModel.content) == true || commentModel.content == commentModel.title) {
      return SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Color(0xffd0d0d0)), borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(
        getI18NKey().reply + ":" + (commentModel.content ?? ""),
        style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Colors.black45), fontSize: 12),
      ),
    );
  }
}
