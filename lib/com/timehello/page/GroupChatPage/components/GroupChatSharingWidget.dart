import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';

class GroupChatSharingWidget extends StatefulWidget {
  FolderModel? folderModel;

  GroupChatSharingWidget({this.folderModel});

  @override
  _GroupChatSharingWidgetState createState() => _GroupChatSharingWidgetState();
}

class _GroupChatSharingWidgetState extends State<GroupChatSharingWidget> {
  String curRadioIndex = 'only_share_with_friends';
  String curEditableRadioIndex = 'can_visible';
  bool _canEdit = false;

  //0 未分享中 仅仅我自己 1 之后分享中 - 1 私有 - 需要搜索 仅仅好友 2 所有人可查看 3 所有人可编辑
  onClickRadio(String val) {
    switch (val) {
      case 'only_me': // 仅我自己
        this.widget.folderModel?.isSharing = 0;
        this.widget.folderModel?.isOtherUserEditable = false;
        break;
      case 'only_share_with_friends': // 仅我分享的好友
        this.widget.folderModel?.isSharing = 1;
        this.widget.folderModel?.isOtherUserEditable = _canEdit;
        break;
      case 'everyone_can_view': // 所有人可查看
        this.widget.folderModel?.isSharing = 2;
        this.widget.folderModel?.isOtherUserEditable = false;
        break;
      case 'everyone_can_edit': // 所有人可编辑
        this.widget.folderModel?.isSharing = 3;
        this.widget.folderModel?.isOtherUserEditable = true;
        break;
    }
    MongoApisManager.getInstance()?.update_FolderModelWithFM(
        shouldQueryMissionModel: false,
        folderModel: this.widget.folderModel ?? FolderModel());
    setState(() {});
  }

  onClickRadioShareMyFriends(String val) {
    switch (val) {
      case 'can_visible': // 可查看
        this.widget.folderModel?.isSharing = 1;
        this.widget.folderModel?.isOtherUserEditable = false;
        break;
      case 'can_editable': // 可编辑
        this.widget.folderModel?.isSharing = 1;
        this.widget.folderModel?.isOtherUserEditable = true;
        break;
    }
    MongoApisManager.getInstance()?.update_FolderModelWithFM(
        shouldQueryMissionModel: false,
        folderModel: this.widget.folderModel ?? FolderModel());
    setState(() {});
  }

  initState() {
    curRadioIndex = this.widget.folderModel?.isSharing == 0
        ? 'only_me'
        : this.widget.folderModel?.isSharing == 1
            ? 'only_share_with_friends'
            : this.widget.folderModel?.isSharing == 2
                ? 'everyone_can_view'
                : 'everyone_can_edit';
    _canEdit = this.widget.folderModel?.isOtherUserEditable ?? false;
    curEditableRadioIndex = _canEdit ? 'can_editable' : 'can_visible';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  DialogManagement.getInstance().hideDialog(context);
                },
                child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      Icons.close,
                      size: 20,
                    )),
              )),
          SizedBox(height: 20),
          Text('谁可以查看/编辑文件',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          RadioListTile<String>(
            title: Text('仅我自己'),
            value: 'only_me',
            groupValue: curRadioIndex,
            onChanged: (value) {
              this.onClickRadio(value!);
              setState(() {
                curRadioIndex = value!;
              });
            },
          ),
          getOnlyFriendsWidget(),
          RadioListTile<String>(
            title: Text('所有人可查看'),
            value: 'everyone_can_view',
            groupValue: curRadioIndex,
            onChanged: (value) {
              this.onClickRadio(value!);
              setState(() {
                curRadioIndex = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: Text('所有人可编辑'),
            value: 'everyone_can_edit',
            groupValue: curRadioIndex,
            onChanged: (value) {
              this.onClickRadio(value!);
              setState(() {
                curRadioIndex = value!;
              });
            },
          ),
          SizedBox(height: 20),
          Text('高级权限：可设置禁止复制、批注等', style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          Text('分享到',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {
                  // QQ好友分享逻辑
                },
              ),
              IconButton(
                icon: Icon(Icons.wechat),
                onPressed: () {
                  // 微信好友分享逻辑
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // 复制链接逻辑
                },
                child: Text('复制链接'),
              ),
              ElevatedButton(
                onPressed: () {
                  // 生成图片逻辑
                },
                child: Text('生成图片'),
              ),
              ElevatedButton(
                onPressed: () {
                  // 生成二维码逻辑
                },
                child: Text('生成二维码'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getOnlyFriendsWidget() {
    if (this.widget.folderModel?.isSharing == 1) {
      return Wrap(
        children: [
          RadioListTile<String>(
            title: Text('仅我分享的好友'),
            value: 'only_share_with_friends',
            groupValue: curRadioIndex,
            onChanged: (value) {
              this.onClickRadio(value!);
              setState(() {
                curRadioIndex = value!;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Wrap(
              alignment: WrapAlignment.start,
              children: <Widget>[
                RadioListTile<String>(
                  title: Text('可查看'),
                  value: 'can_visible',
                  groupValue: curEditableRadioIndex,
                  onChanged: (value) {
                    _canEdit = false;
                    this.onClickRadioShareMyFriends(value!);
                  },
                ),
                RadioListTile<String>(
                  title: Text('可编辑'),
                  value: 'can_editable',
                  groupValue: curEditableRadioIndex,
                  onChanged: (value) {
                    _canEdit = true!;
                    this.onClickRadioShareMyFriends(value!);
                  },
                )
                // Switch(
                //   value: _canEdit,
                //   onChanged: (value) {
                //     setState(() {
                //       _canEdit = value;
                //     });
                //   },
                // ),
              ],
            ),
          ),
        ],
      );
    } else {
      return RadioListTile<String>(
        title: Text('仅我分享的好友'),
        value: 'only_share_with_friends',
        groupValue: curRadioIndex,
        onChanged: (value) {
          this.onClickRadio(value!);
          setState(() {
            curRadioIndex = value!;
          });
        },
      );
    }
  }
}
