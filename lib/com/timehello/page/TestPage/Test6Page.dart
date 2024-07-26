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
  final TextEditingController _controller = TextEditingController();
  Color color = Colors.purple;
  double iconSize = 18;
  double fontSize = 14;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: color),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${_controller.text.length}/1000',
                          style: TextStyle(color: color),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _controller.text.isEmpty ? Colors.purple[100] : color, // 按钮颜色
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          onPressed: _controller.text.isEmpty ? null : () {
                            // Handle button press
                          },
                          child: Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, // 未hover时的边框颜色
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: color, // hover时的边框颜色
                      ),
                    ),
                    labelText: getI18NKey().select_scenario,
                    labelStyle: TextStyle(
                      color: _controller.text.isEmpty ? Colors.purple[100] : color,
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {}); // 重新渲染以更新按钮颜色
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.text_fields, color: color, size: iconSize,),
                title: Text(getI18NKey().improve_writing, style: TextStyle(fontSize: fontSize),),
                onTap: () {
                  // Handle menu item tap
                },
              ),
              ListTile(
                leading: Icon(Icons.spellcheck, color: color, size: iconSize,),
                title: Text(getI18NKey().fix_spelling_grammar, style: TextStyle(fontSize: fontSize)),
                onTap: () {
                  // Handle menu item tap
                },
              ),
              ListTile(
                leading: Icon(Icons.short_text, color: color, size: iconSize,),
                title: Text(getI18NKey().shorten, style: TextStyle(fontSize: fontSize)),
                onTap: () {
                  // Handle menu item tap
                },
              ),
              ListTile(
                leading: Icon(Icons.format_list_bulleted, color: color, size: iconSize,),
                title: Text(getI18NKey().enrich, style: TextStyle(fontSize: fontSize)),
                onTap: () {
                  // Handle menu item tap
                },
              ),
              ListTile(
                leading: Icon(Icons.format_paint, color: color, size: iconSize,),
                title: Text(getI18NKey().switch_style, style: TextStyle(fontSize: fontSize)),
                onTap: () {
                  // Handle menu item tap
                },
              ),
              ListTile(
                leading: Icon(Icons.language, color: color, size: iconSize,),
                title: Text(getI18NKey().simplify_language, style: TextStyle(fontSize: fontSize)),
                onTap: () {
                  // Handle menu item tap
                },
              ),
              ListTile(
                leading: Icon(Icons.edit, color: color, size: iconSize,),
                title: Text(getI18NKey().continue_writing, style: TextStyle(fontSize: fontSize)),
                onTap: () {
                  // Handle menu item tap
                },
              ),
              ListTile(
                leading: Icon(Icons.summarize, color: color, size: iconSize,),
                title: Text(getI18NKey().summarize, style: TextStyle(fontSize: fontSize)),
                onTap: () {
                  // Handle menu item tap
                },
              ),
              ListTile(
                leading: Icon(Icons.translate, color: color, size: iconSize,),
                title: Text(getI18NKey().translate, style: TextStyle(fontSize: fontSize)),
                onTap: () {
                  // Handle menu item tap
                },
              ),
              ListTile(
                leading: Icon(Icons.help_outline, color: color, size: iconSize,),
                title: Text(getI18NKey().explain, style: TextStyle(fontSize: fontSize)),
                onTap: () {
                  // Handle menu item tap
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              // Handle button press
            },
            child: Text(getI18NKey().manage),
          ),
        ),
      ],
    );
  }
}