import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/beans/UserInfoBean.dart';
import 'package:time_hello/com/timehello/components/AvatarWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';

class GroupChatFriendsSliverList extends StatelessWidget {
  final List userInfoBeans;
  final Function onFriendTap;

  GroupChatFriendsSliverList({
    required this.userInfoBeans,
    required this.onFriendTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            // 管理员
            UserInfoBean userInfoBean = UserInfoBean();
            userInfoBean.username = LoginManager.getInstance().userBean.username;
            userInfoBean.avatar = LoginManager.getInstance().userBean.avatar;
            userInfoBean.uid = LoginManager.getInstance().userBean.uid;
            return getItem(userInfoBean);
          } else {
            // 普通用户
            final UserInfoBean userInfoBean = userInfoBeans[index - 1];
            return getItem(userInfoBean);
          }
        },
        childCount: userInfoBeans.length + 1,
      ),
    );
  }

  InkWell getItem(UserInfoBean userInfoBean) {
    return InkWell(
      onTap: () => onFriendTap(userInfoBean),
      child: Padding(
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
                      if (ChatGroupManager.getInstance()
                          .isGroupManager(bean: userInfoBean))
                        Container(
                            margin: EdgeInsets.only(left: 4),
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 2),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.orangeAccent),
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
                      Utility.getSVGPicture(R.assetsImgIcTotalCheck, size: 13),
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
    );
  }

  Text getOnlineStatusText({required UserInfoBean userInfoBean}) {
    return Text(
      "专注中",
      style: TextStyle(color: Colors.green, fontSize: 12),
    );
  }
}
