import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupChatFriendsSliverList extends StatelessWidget {
  final List friends;
  final Function onFriendTap;
  final Function onFriendLongPress;
  final Function onFriendRemove;
  final members = [
    {'name': '南极企鹅', 'role': '群主'},
    {'name': 'Ausider'},
    {'name': '爱与诚'},
    {'name': '阿正'},
    {'name': '不戳'},
    {'name': 'Blues'},
    {'name': 'Bullshit With Facts'},
    {'name': 'CJXT'},
    {'name': '初六'},
    {'name': '陈震'},
    {'name': '咩'},
    {'name': '冬石'},
  ];
  GroupChatFriendsSliverList({
    required this.friends,
    required this.onFriendTap,
    required this.onFriendLongPress,
    required this.onFriendRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(

      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final friend = members[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // Replace with actual image URL
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(friend['name']!),
                      if (friend['role'] != null) Text(friend['role']!),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: members.length,
      ),
    );
  }
}
