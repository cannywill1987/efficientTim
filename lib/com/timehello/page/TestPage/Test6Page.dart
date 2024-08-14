// import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CustomBackgroundWidget.dart';
import 'package:time_hello/com/timehello/models/TimelineMissionModel.dart';
import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../components/CustomLgLeftChatWidget.dart';
import '../TimeLinePage/components/FileMessageWidget.dart';
import '../WrongQuestionBookPage/components/WQBNoteWidget.dart';
import '../missionPage/componnents/MissionGridView.dart';

class Test6Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Test6PageState();
  }
}

class Test6PageState extends State<Test6Page> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  Color color = Colors.purple;
  Color fontColor = Colors.black;
  double iconSize = 18;
  double fontSize = 14;
  void _handleButtonClick(String action) {
    print('Button clicked: $action');
    // 在这里添加处理点击事件的逻辑
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '印象AI',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              QuickInsertButton(
                icon: Icons.auto_fix_high,
                label: 'AI 帮我写',
                onPressed: () => _handleButtonClick('AI 帮我写'),
              ),
              QuickInsertButton(
                icon: Icons.lightbulb,
                label: '头脑风暴',
                onPressed: () => _handleButtonClick('头脑风暴'),
              ),
              QuickInsertButton(
                icon: Icons.edit,
                label: '写文章',
                onPressed: () => _handleButtonClick('写文章'),
              ),
              QuickInsertButton(
                icon: Icons.list,
                label: '提纲',
                onPressed: () => _handleButtonClick('提纲'),
              ),
              QuickInsertButton(
                icon: Icons.book,
                label: '小红书',
                onPressed: () => _handleButtonClick('小红书'),
              ),
              QuickInsertButton(
                icon: Icons.more_horiz,
                label: '更多',
                onPressed: () => _handleButtonClick('更多'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuickInsertButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  QuickInsertButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(20),
            // primary: Colors.white,
            // onPrimary: Colors.purple,
          ),
          child: Icon(icon, color: Colors.purple),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.purple),
        ),
      ],
    );
  }
}