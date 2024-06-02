import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../models/FolderModel.dart';

class GroupInfoWidget extends StatefulWidget {
  FolderModel folderModel;
  Function onTapShare;
  Function onTapQuit;

  GroupInfoWidget(
      {Key? key,
      required this.onTapShare,
      required this.folderModel,
      required this.onTapQuit})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GroupInfoWidgetState();
  }
}

class GroupInfoWidgetState extends State<GroupInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        // decoration: BoxDecoration(
        //   color: ThemeManager.getInstance().getLeftMenuColor(
        //       defaultColor: ThemeManager.getInstance()
        //           .getLightDefaultThemeColor()),
        //   // boxShadow: [
        //   //   BoxShadow(
        //   //     color: Colors.black12,
        //   //     blurRadius: 10,
        //   //   ),
        //   // ],
        // ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.widget.folderModel.title ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  getI18NKey()
                      .group_id(this.widget.folderModel.folderTeamWorkId ?? ""),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    // textStyle: MaterialStateProperty.all(TextStyle(
                    //   color: Colors.white,
                    // )),
                    backgroundColor: MaterialStateProperty.all(
                        ThemeManager.getInstance().getDefautThemeColor()),
                    // overlayColor: MaterialStateProperty.all(Colors.red),
                    // surfaceTintColor: MaterialStateProperty.all(Colors.red),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    this.widget.onTapShare.call();
                  },
                  child: Text(getI18NKey().share),
                ),
                if(!ChatGroupManager.onlyMeInGroup(folderModel: this.widget.folderModel ?? FolderModel()))
                InkWell(
                  onTap: () {
                    this.widget.onTapQuit.call();
                  },
                  child: Text(
                    ChatGroupManager.isCreator(
                            folderModel:
                                this.widget.folderModel ?? FolderModel())
                        ? getI18NKey().dismiss_group
                        : getI18NKey().leave_group,
                    style: TextStyle(color: ThemeManager.getInstance().isDark() ? Colors.white : Colors.red),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
