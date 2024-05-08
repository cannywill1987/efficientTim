import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/ChatGptMessageModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';

class ChatCreateMissionItem extends StatelessWidget {
  bool isUser = false;
  String text = '';
  int isLoading = 0;
  ChatGptMessageModel chatGptMessageModel;
  ChatGptMessageModel? chatGptMessageModelChatGptRedisCache;
  Function(ChatGptMessageModel)? onTapCreateMissionListener;
  Function(ChatGptMessageModel)? onTapSendAgainListener;

  ChatCreateMissionItem({this.onTapCreateMissionListener, this.onTapSendAgainListener, required this.chatGptMessageModel, this.chatGptMessageModelChatGptRedisCache, required this.isLoading, required this.isUser, required this.text});

  String getDateString() {
    // int startTimeMillis = this.chatGptMessageModel.function_call_arguments?['startTime'] ?? -1;
    // int endTimeMillis = this.chatGptMessageModel.function_call_arguments?['endTime'] ?? -1;
    // String title = this.chatGptMessageModel.function_call_arguments?['title'] ?? "";
    // if(startTimeMillis == -1 || endTimeMillis == -1) {
    //   return '';
    // }
    // DateTime startTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
    // DateTime endTime = DateTime.fromMillisecondsSinceEpoch(endTimeMillis);
    return '${getI18NKey().create_mission}';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return this.isLoading == 0
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(onTap: () {
          if(this.onTapCreateMissionListener != null) {
            this.onTapCreateMissionListener?.call(chatGptMessageModel);
          }
        },child: Stack(
          children: [
            Utility.getSVGPictureWithSize(R.assetsImgIcCreateMissionBg, width: 150, height: 130),
            Container(
              width: 150,
              height: 130,
              color: Colors.black.withOpacity(0.3),
              alignment: Alignment.center,
              child: Text(
                getI18NKey().click_to_view,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            )],
        )),
        SizedBox(height: 8,),
        Text(
          getDateString() ?? "",
          style:
          TextStyle(fontSize: 14, color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040))),
        ),
        SizedBox(height: 15,),
        this.chatGptMessageModel.choicesFinishReason != 'error' ? SizedBox.shrink() : Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.info,
                color: Colors.white,
                size: 18,
              ),
            ),
            SizedBox(width: 5,),
            Text(getI18NKey().try_again, style: TextStyle(color: Colors.red, fontSize: 12),),
            SizedBox(width: 5,),
            InkWell(
              onTap: () {
                if(this.onTapSendAgainListener != null) {
                  this.onTapSendAgainListener!(chatGptMessageModel);
                }

              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(
                      Radius.circular(14)),
                    border: Border.all(width: 2, color: Colors.red),),
                  child: Text(getI18NKey().send_again, style: TextStyle(color: Colors.red, fontSize: 12),)
              ),
            )
          ],
        )
      ],
    ) : this.isLoading == 1 ?  CupertinoActivityIndicator() :  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.chatGptMessageModelChatGptRedisCache?.text?.trim() ?? "",
          style:
          TextStyle(fontSize: 14, color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040))),
        ),
        CupertinoActivityIndicator(),
      ],
    );
  }

}