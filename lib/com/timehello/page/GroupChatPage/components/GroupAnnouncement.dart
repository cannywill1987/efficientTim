import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class GroupAnnouncement extends StatelessWidget {
  FolderModel? folderModel;
  GroupAnnouncement({this.folderModel});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5),
      decoration: BoxDecoration(
        color: ThemeManager.getInstance().getLeftMenuColor(
            defaultColor: ThemeManager.getInstance()
                .getLightDefaultThemeColor()),
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            getI18NKey().group_announcement,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if(ChatGroupManager.isGroupManager(folderModel: this.folderModel ?? FolderModel()))
              Text(
                getI18NKey().edit,
                style: TextStyle(
                  fontSize: 13.0,
                  color: ThemeManager.getInstance().isDark() ? Colors.white : Colors.grey,
                ),
              ),
              SizedBox(width: 2,),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}