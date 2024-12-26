// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:time_hello/com/timehello/beans/UserInfoBean.dart';
import 'package:time_hello/com/timehello/components/AvatarWidget.dart';
import 'package:time_hello/com/timehello/components/CustomPopupWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/AnalyticsEventsManager.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';

class GroupChatFriendsSliverList extends StatelessWidget {
  UserInfoBean? userInfoBeanCreator;
  FolderModel? folderModel;
  final List userInfoBeans;
  final Function onFriendTap;
  final Function onTapSetAdministrator;
  final Function onTapCancelAdministrator;
  final Function onTapDeleteUser;


  GroupChatFriendsSliverList({
    required this.userInfoBeanCreator,
    required this.folderModel,
    required this.userInfoBeans,
    required this.onFriendTap,
    required this.onTapCancelAdministrator,
    required this.onTapSetAdministrator,
    required this.onTapDeleteUser,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            if (TextUtil.isEmpty(this.userInfoBeanCreator?.uid)) {
              return SizedBox.shrink();
            }
            // 管理员

            return GroupChatFriendsSliverListItem(
              userInfoBean: this.userInfoBeanCreator!,
              folderModel: this.folderModel!,
              onTapCancelAdministrator: this.onTapCancelAdministrator,
              onFriendTap: this.onFriendTap,
              onTapSetAdministrator: this.onTapSetAdministrator,
              onTapDeleteUser: this.onTapDeleteUser,
            );
          } else {
            // 普通用户
            final UserInfoBean userInfoBean = userInfoBeans[index - 1];

            return GroupChatFriendsSliverListItem(
              userInfoBean: userInfoBean,
              folderModel: this.folderModel!,
              onTapCancelAdministrator: this.onTapCancelAdministrator,
              onFriendTap: this.onFriendTap,
              onTapSetAdministrator: this.onTapSetAdministrator,
              onTapDeleteUser: this.onTapDeleteUser,
            );
          }
        },
        childCount: userInfoBeans.length + 1,
      ),
    );
  }
}

class GroupChatFriendsSliverListItem extends StatefulWidget {
  UserInfoBean userInfoBean;
  FolderModel folderModel;
  Function onFriendTap;
  final Function onTapSetAdministrator;
  final Function onTapDeleteUser;
  final Function onTapCancelAdministrator;

  GroupChatFriendsSliverListItem({
    required this.userInfoBean,
    required this.folderModel,
    required this.onTapCancelAdministrator,
    required this.onFriendTap,
    required this.onTapSetAdministrator,
    required this.onTapDeleteUser,
  });

  @override
  _GroupChatFriendsSliverListItemState createState() =>
      _GroupChatFriendsSliverListItemState();
}

class _GroupChatFriendsSliverListItemState
    extends State<GroupChatFriendsSliverListItem> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    if ((DeviceInfoManagement.isMoible() == true ||
        DeviceInfoManagement.isWebMobileBySize())) {
      return Slidable(
        key: ValueKey(this.widget.folderModel),
        enabled: !(ChatGroupManager.isCreatorForUserBean(
            folderModel: this.widget.folderModel,
            userBean: this.widget.userInfoBean) ||
            ChatGroupManager.isMe(userInfoBean: this.widget.userInfoBean) ||
            ChatGroupManager.isGroupManager(folderModel: this.widget.folderModel)),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.15,
          children: this.getSlideActions(this.widget.folderModel),
        ),
        child: this.getItem(
          userInfoBean: this.widget.userInfoBean,
          folderModel: this.widget.folderModel,
        ),
      );
    } else {
      //PC
      return MouseRegion(
          onEnter: (_) {
            setState(() {
              this.isHover = true;
            });
          },
          onHover: (_) {},
          onExit: (_) {
            setState(() {
              this.isHover = false;
            });
          },
          child: this.getItem(
              userInfoBean: this.widget.userInfoBean,
              folderModel: this.widget.folderModel));
    }
  }

  List<Widget> getSlideActions(FolderModel folderModel) {
    List<CheckButtonStateModel> datas = this.getSlideDatas(folderModel, true);
    List<Widget> widgets = [];
    for (CheckButtonStateModel data in datas) {
      widgets.add(SlidableAction(
        onPressed: (context) async {
          if (data.code == 'cancel_setting_administrator') {
            AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
              "sceneType": "GroupChatPage",
              "eventType": "GroupChatPage_unset_admin",
              "description": "取消设置管理员",
            });
            await ChatGroupManager.setRoleForUserBean(
                folderModel: this.widget.folderModel,
                userBean: this.widget.userInfoBean,
                role: 2);
            this.widget.onTapCancelAdministrator(folderModel);
          } else if (data.code == 'setting_administrator') {
            AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
              "sceneType": "GroupChatPage",
              "eventType": "GroupChatPage_set_admin",
              "description": "设置管理员",
            });
            await ChatGroupManager.setRoleForUserBean(
                folderModel: this.widget.folderModel,
                userBean: this.widget.userInfoBean,
                role: 1);
            this.widget.onTapSetAdministrator(folderModel);
          } else if (data.code == 'delete') {
            AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
              "sceneType": "GroupChatPage",
              "eventType": "GroupChatPage_delete_user",
              "description": "删除用户",
            });
            await ChatGroupManager.removeUserFromGroup(
                folderModel: this.widget.folderModel,
                userBean: this.widget.userInfoBean);
            this.widget.onTapDeleteUser(folderModel);
          }
        },
        backgroundColor: Color(data.color ?? Colors.red.value),
        foregroundColor: Colors.white,
        icon: Icons.check, // 用于代替 iconWidget 的默认图标
        label: data.title,
      ));
    }
    return widgets;
  }


  Widget getItem(
      {required UserInfoBean userInfoBean, required FolderModel folderModel}) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              AvatarWidget(avatar: userInfoBean.avatar, width: 30),
              // CircleAvatar(
              //   backgroundImage: NetworkImage(
              //       'https://via.placeholder.com/150'), // Replace with actual image URL
              // ),
              SizedBox(width: 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(!TextUtil.isEmpty(userInfoBean.username)
                            ? userInfoBean.username!
                            : getI18NKey().unname_user),
                        if (ChatGroupManager.isGroupManager(
                            folderModel: folderModel, uid: userInfoBean.uid))
                          Container(
                              margin: EdgeInsets.only(left: 4),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 2),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.orangeAccent),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0x20fe9146)),
                              child: Text(
                                getI18NKey().administrator,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xfffe9146),
                                ),
                              )),
                        Spacer(),
                        getOnlineStatusText(userInfoBean: userInfoBean),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          R.assetsImgIcLogoRed,
                          width: 14,
                          height: 14,
                        ),
                        // Utility.getSVGPicture(R.assetsImgIcLogoRed, size: this.widget.size),
                        SizedBox(width: 1),
                        Text("0",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: ColorsConfig.red)),
                        SizedBox(width: 10),
                        Utility.getSVGPicture(R.assetsImgIcTotalCheck,
                            size: 13),
                        SizedBox(width: 1),
                        Text("0",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xff37c7b1))),

                        SizedBox(width: 10),
                        Utility.getSVGPicture(R.assetsImgIcFocusDuration,
                            size: 13),
                        SizedBox(width: 1),
                        Text("0",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xff3c64ff))),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        ChatGroupManager.isCreatorForUserBean(folderModel: this.widget.folderModel, userBean: this.widget.userInfoBean) || (ChatGroupManager.isMe(userInfoBean: this.widget.userInfoBean)) || (ChatGroupManager.isGroupManager(
            folderModel: this.widget.folderModel) && this.isHover == false)
            ? SizedBox.shrink()
            : Positioned(
                right: 10,
                top: 10,
                child: CustomPopupWidget(
                    onSelected: (val) async {
                      // cancel_setting_administrator setting_administrator delete
                      // if (userInfoBean.uid ==
                      //     FirebaseAuth.instance.currentUser!.uid) {
                      //   Utility.showToastMsg(
                      //       msg: getI18NKey().cannot_handle_myself);
                      //   return;
                      // }
                      switch (val.code) {
                        case 'cancel_setting_administrator':
                          AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "GroupChatPage","eventType": "GroupChatPage_unset_admin","description": "取消设置管理员",});
                          ChatGroupManager.setRoleForUserBean(
                              folderModel: this.widget.folderModel,
                              userBean: userInfoBean,
                              role: 2);
                          this.widget.onTapCancelAdministrator(folderModel);
                          // await ChatGroupManager.cancelSettingAdministrator(folderModel: this.widget.folderModel, userInfoBean: userInfoBean);
                          break;
                        case 'setting_administrator':
                          AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "GroupChatPage","eventType": "GroupChatPage_set_admin","description": "设置管理员",});
                          ChatGroupManager.setRoleForUserBean(
                              folderModel: this.widget.folderModel,
                              userBean: userInfoBean,
                              role: 1);
                          this.widget.onTapSetAdministrator(folderModel);
                          // await ChatGroupManager.settingAdministrator(folderModel: this.widget.folderModel, userInfoBean: userInfoBean);
                          break;
                        case 'delete':
                          AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "GroupChatPage","eventType": "GroupChatPage_delete_user","description": "删除用户",});
                          ChatGroupManager.removeUserFromGroup(folderModel: this.widget.folderModel, userBean: userInfoBean);
                          this.widget.onTapDeleteUser(this.widget.folderModel);
                          // await ChatGroupManager.deleteUserFromGroup(folderModel: this.widget.folderModel, userInfoBean: userInfoBean);
                          break;
                      }
                    },
                    // list: CONSTANTS.getCreatorCheckList(),
                    list: getSlideDatas(folderModel, false),
                    child: Icon(
                      Icons.more_vert,
                      size: 14,
                      color: ThemeManager.getInstance()
                          .getIconColor(defaultColor: Colors.black87),
                    )),
              )
      ],
    );
  }

  List<CheckButtonStateModel> getSlideDatas(FolderModel folderModel, bool isSlide) {
    return ChatGroupManager.isCreator(folderModel: this.widget.folderModel) ? CONSTANTS.getCreatorCheckList(isSlide: isSlide, isAdministrator: ChatGroupManager.isGroupManager(folderModel: folderModel, uid: this.widget.userInfoBean.uid)) : ChatGroupManager.isGroupManager(folderModel: folderModel, uid: LoginManager.getInstance().getUserBean().uid) ? CONSTANTS.getAdminsCheckList(isSlide: isSlide) : [];
  }

  // offline,
  // online,
  // focusing,
  // relaxing,
  Widget getOnlineStatusText({required UserInfoBean userInfoBean}) {
    if (this.isHover == true) {
      return SizedBox.shrink();
    }
    if (userInfoBean.onlineStatusEnum == OnlineStatusEnum.offline) {
      return Text(
        getI18NKey().offline,
        style: TextStyle(color: Colors.grey, fontSize: 12),
      );
    } else if (userInfoBean.onlineStatusEnum == OnlineStatusEnum.online) {
      return Text(
        getI18NKey().online,
        style: TextStyle(color: Colors.green, fontSize: 12),
      );
    } else if (userInfoBean.onlineStatusEnum == OnlineStatusEnum.focusing) {
      return Text(
        getI18NKey().focusing,
        style: TextStyle(color: Colors.red, fontSize: 12),
      );
    } else if (userInfoBean.onlineStatusEnum == OnlineStatusEnum.relaxing) {
      return Text(
        getI18NKey().relaxing,
        style: TextStyle(color: Colors.blue, fontSize: 12),
      );
    }
    return SizedBox.shrink();
  }
}
