import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/AvatarWidget.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class GroupChatFriendsSliverList extends StatelessWidget {
  final List friends;
  final Function onFriendTap;

  GroupChatFriendsSliverList({
    required this.friends,
    required this.onFriendTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            // 管理员
            Map friend = {
              "username": LoginManager.getInstance().userBean.username,
              "avatar": LoginManager.getInstance().userBean.avatar,
              "uid": LoginManager.getInstance().userBean.uid,
            };
            return getItem(friend);
          } else {
            // 普通用户
            final Map friend = friends[index - 1];
            return getItem(friend);
          }
        },
        childCount: friends.length + 1,
      ),
    );
  }

  InkWell getItem(Map<dynamic, dynamic> friend) {
    return InkWell(
      onTap: () => onFriendTap(friend),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            AvatarWidget(avatar: friend['avatar']),
            // CircleAvatar(
            //   backgroundImage: NetworkImage(
            //       'https://via.placeholder.com/150'), // Replace with actual image URL
            // ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(!TextUtil.isEmpty(friend['username'])
                      ? friend['username']
                      : getI18NKey().unname_user),
                  if (ChatGroupManager.getInstance()
                      .isGroupManager(member: friend))
                    Text(getI18NKey().administrator, style: TextStyle(color: ThemeManager.getInstance().getTextColor()),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
