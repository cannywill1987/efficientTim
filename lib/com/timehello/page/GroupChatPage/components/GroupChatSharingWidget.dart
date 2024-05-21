import 'package:flutter/material.dart';


class GroupChatSharingWidget extends StatefulWidget {
  @override
  _GroupChatSharingWidgetState createState() => _GroupChatSharingWidgetState();
}

class _GroupChatSharingWidgetState extends State<GroupChatSharingWidget> {
  String _visibility = 'only_share_with_friends';
  bool _canEdit = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('谁可以查看/编辑文件', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          RadioListTile<String>(
            title: Text('仅我自己'),
            value: 'only_me',
            groupValue: _visibility,
            onChanged: (value) {
              setState(() {
                _visibility = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: Text('仅我分享的好友'),
            value: 'only_share_with_friends',
            groupValue: _visibility,
            onChanged: (value) {
              setState(() {
                _visibility = value!;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('可查看')),
                Switch(
                  value: _canEdit,
                  onChanged: (value) {
                    setState(() {
                      _canEdit = value;
                    });
                  },
                ),
                Text('可编辑'),
              ],
            ),
          ),
          RadioListTile<String>(
            title: Text('所有人可查看'),
            value: 'everyone_can_view',
            groupValue: _visibility,
            onChanged: (value) {
              setState(() {
                _visibility = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: Text('所有人可编辑'),
            value: 'everyone_can_edit',
            groupValue: _visibility,
            onChanged: (value) {
              setState(() {
                _visibility = value!;
              });
            },
          ),
          SizedBox(height: 20),
          Text('高级权限：可设置禁止复制、批注等', style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          Text('分享到', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
}