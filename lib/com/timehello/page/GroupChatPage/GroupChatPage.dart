import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';

class GroupChatPage extends BaseWidget {

  const GroupChatPage({Key? key}) : super(key: key);

  @override
  _GroupChatPageState createState() => _GroupChatPageState();

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _GroupChatPageState();
  }
}

class _GroupChatPageState extends BaseWidgetState<GroupChatPage> {
  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAnnouncement(),
          _buildSearch(),
          Expanded(child: _buildMembersList()),
        ],
      ),
    );
  }

  Widget _buildAnnouncement() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network('https://via.placeholder.com/150'), // Replace with your image URL
          SizedBox(height: 10),
          Text(
            '【图片】现在软件免费使用应用市场有好评可以有三个月免费使用AI功能 另外可以免费6个月使用全功能时间管理ToDo 测试加入 ...',
            style: TextStyle(fontSize: 14),
          ),
          Text(
            'http://www.timerbell.com/',
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: '搜索',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _buildMembersList() {
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

    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with actual image URL
          ),
          title: Text(member['name']!),
          subtitle: member['role'] != null ? Text(member['role']!) : null,
        );
      },
    );
  }
}