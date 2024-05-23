import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BlackCheckButtonListWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/ScreenLockManager.dart';

import '../../../models/FolderModel.dart';


class GroupInfoPage extends StatefulWidget {
  FolderModel folderModel;
  Function onTapShare;

  GroupInfoPage({Key? key, required this.onTapShare, required this.folderModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GroupInfoPageState();
  }
}

class GroupInfoPageState extends State<GroupInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/group_avatar.png'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.widget.folderModel.title ?? "",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      this.widget.folderModel.folderTeamWorkId ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // if(this.widget.folderModel.uid == LoginManager.getInstance().userBean.uid)
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text('可搜索'),
            //     BlackCheckButtonListWidget(
            //       initIndex: this.widget.folderModel.isSharing == 3
            //           ? 1
            //           : 0,
            //       list: CONSTANTS.getOnAndOffButtonList(),
            //       onTapListener: (obj) async {
            //         if(obj == 1) {
            //           this.widget.folderModel.isSharing = 3;
            //         } else {
            //           this.widget.folderModel.isSharing = 0;
            //         }
            //         await MongoApisManager.getInstance().update_FolderModelWithFM(folderModel: this.widget.folderModel);
            //         setState(() {
            //
            //         });
            //         // if(!ScreenLockManager.getInstance().hasPassword() && obj == 1) {
            //         //   ScreenLockManager.getInstance().createPassword(shouldShow: true);
            //         // }
            //       },
            //     )
            //     // Text(
            //     //   '设置群聊备注',
            //     //   style: TextStyle(color: Colors.blue),
            //     // ),
            //   ],
            // ),
            // SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text('备注'),
            //     Text(
            //       '设置群聊备注',
            //       style: TextStyle(color: Colors.blue),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 10),
            // Divider(),
            // Row(
            //   children: [
            //     Text('群介绍'),
            //     SizedBox(width: 10),
            //     Expanded(
            //       child: Text(
            //         '有什么问题都可以留言，...',
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 10),
            // Divider(),
            // Row(
            //   children: [
            //     Text('群公告'),
            //     SizedBox(width: 10),
            //     Expanded(
            //       child: Text(
            //         '[图片] 现在软件免费使...',
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    this.widget.onTapShare.call();
                  },
                  child: Text('分享'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}