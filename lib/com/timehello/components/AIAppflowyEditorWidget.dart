import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';

import '../util/ThemeManager.dart';
import '../util/Utility.dart';

class AIAppflowyEditorWidget extends StatefulWidget {
  Function onTap;

  AIAppflowyEditorWidget({required this.onTap});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AIAppflowyEditorWidgetState();
  }
}

class AIAppflowyEditorWidgetState extends State<AIAppflowyEditorWidget> {
  Color color = Colors.purple;
  Color fontColor = Colors.black;
  double iconSize = 18;
  double fontSize = 14;
  void _handleButtonClick(CheckButtonStateModel action) {
    print('Button clicked: $action');
    this.widget.onTap.call(action);
    // 在这里添加处理点击事件的逻辑
  }

  getListWidget() {
    List<CheckButtonStateModel> list = CONSTANTS.getAIPrompts();
    List<Widget> widgets = [];
for (int i = 0; i < list.length; i++) {
  CheckButtonStateModel model = list[i];
  Icon? icon = model?.checkIcon as Icon?;
      widgets.add(
        InkWell(
          onTap: () {
            _handleButtonClick(model);
          },
          child: QuickInsertButton(
            icon: icon?.icon ?? Icons.auto_fix_high,
            label: model?.title ?? "",
            onPressed: () => _handleButtonClick(model),
          ),
        ),
      );
    }
return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Utility.isHuaWei() == false)
          Text(
            getI18NKey().ai_title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ThemeManager.getInstance().getTextColor(
                  defaultColor: ColorsConfig.missionEditorPrimary,
                  defaultDarkColor: Colors.white),
            ),
          ),
          if (Utility.isHuaWei() == false)
          SizedBox(height: 16),
          if (Utility.isHuaWei() == false)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: getListWidget(),
            // children: [
            //   QuickInsertButton(
            //     icon: Icons.auto_fix_high,
            //     label: 'AI 帮我写',
            //     onPressed: () => _handleButtonClick('AI 帮我写'),
            //   ),
            //   QuickInsertButton(
            //     icon: Icons.lightbulb,
            //     label: '头脑风暴',
            //     onPressed: () => _handleButtonClick('头脑风暴'),
            //   ),
            //   QuickInsertButton(
            //     icon: Icons.edit,
            //     label: '写文章',
            //     onPressed: () => _handleButtonClick('写文章'),
            //   ),
            //   QuickInsertButton(
            //     icon: Icons.list,
            //     label: '提纲',
            //     onPressed: () => _handleButtonClick('提纲'),
            //   ),
            //   QuickInsertButton(
            //     icon: Icons.book,
            //     label: '小红书',
            //     onPressed: () => _handleButtonClick('小红书'),
            //   ),
            //   QuickInsertButton(
            //     icon: Icons.more_horiz,
            //     label: '更多',
            //     onPressed: () => _handleButtonClick('更多'),
            //   ),
            // ],
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
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(18),
            side: BorderSide(
              color: ColorsConfig.missionEditorOutline,
            ),
            backgroundColor: ColorsConfig.missionEditorSurface,
            elevation: 0,
          ),
          child: Icon(
            icon,
            color: ThemeManager.getInstance().getIconColor(
                defaultColor: ColorsConfig.missionEditorIcon,
                defaultDarkColor: Colors.white70),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
              color: ThemeManager.getInstance().getTextColor(
                  defaultColor: ColorsConfig.missionEditorPrimary,
                  defaultDarkColor: Colors.white70)),
        ),
      ],
    );
  }
}
