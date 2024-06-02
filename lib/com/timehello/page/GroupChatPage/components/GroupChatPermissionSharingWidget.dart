import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../../../config/Params.dart';

class GroupChatPermissionSharingWidget extends StatefulWidget {
  FolderModel? folderModel;

  GroupChatPermissionSharingWidget({this.folderModel});

  @override
  _GroupChatPermissionSharingWidgetState createState() =>
      _GroupChatPermissionSharingWidgetState();
}

class _GroupChatPermissionSharingWidgetState
    extends State<GroupChatPermissionSharingWidget> {
  String curRadioIndex = 'only_share_with_friends';
  String curEditableRadioIndex = 'can_visible';
  bool _canEdit = false;
  bool checkedPasswordOrigin = false;
  bool isMyFolder = true;
  CorrectStatusEnum correctStatusEnum = CorrectStatusEnum.normal;

  final TextEditingController _originPasswordController =
      TextEditingController();

  //0 未分享中 仅仅我自己 1 之后分享中 - 1 私有 - 需要搜索 仅仅好友 2 所有人可查看 3 所有人可编辑
  onClickRadio(String val) {
    if (ChatGroupManager.isFolderModelEnabled(
            folderId: this.widget.folderModel?.objectId ?? "",
            uid: LoginManager.getInstance().userBean.uid ?? "") ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return null;
    }
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

  onPasswordChange(val) async {
    if (ChatGroupManager.isFolderModelEnabled(
            folderId: this.widget.folderModel?.objectId ?? "",
            uid: LoginManager.getInstance().userBean.uid ?? "") ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return null;
    }
    if (val.length == 6) {
      String pwdEncrypt =
          Utility.encryptCTRAES(val, Params.AES_LISTING_GROUP_PWD);
      // String s = Utility.decryptCTRAES(pwdEncrypt, Params.AES_LISTING_GROUP_PWD);
      this.widget.folderModel?.groupChatPassword = pwdEncrypt;
      await MongoApisManager.getInstance()?.update_FolderModelWithFM(
          shouldQueryMissionModel: false,
          folderModel: this.widget.folderModel ?? FolderModel());
      this.correctStatusEnum = CorrectStatusEnum.success;
    }
  }

  onClickRadioShareMyFriends(String val) {
    if (ChatGroupManager.isFolderModelEnabled(
            folderId: this.widget.folderModel?.objectId ?? "",
            uid: LoginManager.getInstance().userBean.uid ?? "") ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return null;
    }
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
    if (ChatGroupManager.isMyFolder(
        folderModel: this.widget.folderModel ?? FolderModel())) {
      isMyFolder = true;
    } else {
      isMyFolder = false;
    }

    if (!TextUtil.isEmpty(this.widget.folderModel?.groupChatPassword)) {
      String s = Utility.decryptCTRAES(
          this.widget.folderModel?.groupChatPassword ?? "",
          Params.AES_LISTING_GROUP_PWD);
      _originPasswordController.text = s;
    }
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
                        color:
                            ThemeManager.getInstance().getCardBackgroundColor(),
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      Icons.close,
                      size: 20,
                    )),
              )),
          SizedBox(height: 20),
          Text(getI18NKey().who_can_view_edit_files,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          RadioListTile<String>(
            title: Text(getI18NKey().only_me),
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
            title: Text(getI18NKey().everyone_can_view),
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
            title: Text(getI18NKey().everyone_can_edit),
            value: 'everyone_can_edit',
            groupValue: curRadioIndex,
            onChanged: (value) {
              this.onClickRadio(value!);
              setState(() {
                curRadioIndex = value!;
              });
            },
          ),
          if (isMyFolder) SizedBox(height: 20),
          if (isMyFolder)
            Text(getI18NKey().set_password_for_group, style: TextStyle(fontSize: 16)),
          if (isMyFolder) SizedBox(height: 20),
          if (isMyFolder)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getI18NKey().set_6_digit_password),
                      getPwdStatusText(),
                    ],
                  ),
                ),
                if (isMyFolder)
                  Container(
                    width: 160,
                    height: 60,
                    child: TextField(
                      controller: _originPasswordController,
                      obscureText: !this.checkedPasswordOrigin,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        filled: true,
                        suffixIcon: Align(
                          alignment: Alignment.centerRight,
                          widthFactor: 1.0,
                          child: CheckImage(
                            //显示隐藏密码的眼睛
                            onTapListener: (isChecked) {
                              checkedPasswordOrigin = !isChecked;
                              setState(() {});
                            },
                            checked: checkedPasswordOrigin,
                            autoCheck: true,
                            checkIcon: Utility.getSVGPicture(
                                R.assetsImgIcEyeSlash,
                                size: 20),
                            uncheckIcon: Utility.getSVGPicture(
                                R.assetsImgIcEyeClose,
                                size: 20),
                          ),
                        ),
                        fillColor: ThemeManager.getInstance()
                            .getInputDecorationColor(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: getI18NKey().please_origin_password,
                        hintStyle: TextStyle(
                            color: ThemeManager.getInstance()
                                .getInputPlaceholderColor(),
                            fontSize: 12),
                      ),
                      onChanged: (value) async {
                        if (value.length == 6) {
                          correctStatusEnum = CorrectStatusEnum.correct;
                          await onPasswordChange(value);
                        } else {
                          correctStatusEnum = CorrectStatusEnum.wrong;
                        }
                        setState(() {});
                      },
                    ),
                  ),
              ],
            ),
          SizedBox(height: 20),
          Text(getI18NKey().share_to,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(getI18NKey().copy_link_description(this.widget.folderModel?.folderTeamWorkId ?? ""),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.link),
                onPressed: () {
                  // QQ好友分享逻辑
                  Utility.copyToClipboard(
                      getI18NKey().share_the_link(getI18NKey().app_name,
                          this.widget.folderModel?.folderTeamWorkId ?? ""));
                },
              ),
              // IconButton(
              //   icon: Icon(Icons.wechat),
              //   onPressed: () {
              //     // 微信好友分享逻辑
              //   },
              // ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // 复制链接逻辑
                  Utility.copyToClipboard(
                      getI18NKey().share_the_link(getI18NKey().app_name,
                          this.widget.folderModel?.folderTeamWorkId ?? ""));
                },
                child: Text(getI18NKey().copy_link),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     // 生成图片逻辑
              //   },
              //   child: Text(getI18NKey().generate_image),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     // 生成二维码逻辑
              //   },
              //   child: Text(getI18NKey().generate_qr_code),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getPwdStatusText() {
    if (correctStatusEnum == CorrectStatusEnum.normal) {
      return SizedBox.shrink();
    } else if (correctStatusEnum == CorrectStatusEnum.correct) {
      return Text(
        getI18NKey().password_correct,
        style: TextStyle(color: Colors.green),
      );
    } else if (correctStatusEnum == CorrectStatusEnum.wrong) {
      return Text(getI18NKey().please_enter_6_digit_password,
          style: TextStyle(color: Colors.red, fontSize: 12));
    } else if (correctStatusEnum == CorrectStatusEnum.success) {
      return Text(
        getI18NKey().password_set_success,
        style: TextStyle(color: Colors.green),
      );
    }
    return Text(getI18NKey().password_required_for_sharing);
  }

  Widget getOnlyFriendsWidget() {
    if (this.widget.folderModel?.isSharing == 1) {
      return Wrap(
        children: [
          RadioListTile<String>(
            title: Text(getI18NKey().only_share_with_friends),
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
                  title: Text(getI18NKey().can_view),
                  value: 'can_visible',
                  groupValue: curEditableRadioIndex,
                  onChanged: (value) {
                    _canEdit = false;
                    this.onClickRadioShareMyFriends(value!);
                  },
                ),
                RadioListTile<String>(
                  title: Text(getI18NKey().can_edit),
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
        title: Text(getI18NKey().only_share_with_friends),
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
