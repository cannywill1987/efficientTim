// import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AiContentConfirmWidget extends StatefulWidget {
  String text;

  AiContentConfirmWidget({required this.text});
  // Function? onSubmit;
  //
  // AIContentWidget({this.onSubmit});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AiContentConfirmWidgetState();
  }
}

class AiContentConfirmWidgetState extends State<AiContentConfirmWidget> {
  final _controller = TextEditingController();
  Color color = Colors.purple;
  Color fontColor = Colors.black;
  double iconSize = 18;
  double fontSize = 14;
  void _handleButtonPress(String action) {
    switch (action) {
      case '替换':
      // 替换逻辑
        print('替换');
        break;
      case '插入':
      // 插入逻辑
        print('插入');
        break;
      case '继续写作':
      // 继续写作逻辑
        print('继续写作');
        break;
      case '放弃':
      // 放弃逻辑
        _controller.clear();
        print('放弃');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      // key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text('原文：政府正在积极采取措施，以应对日益严重的环境问题，包括加强环保法规的执行力度，提高公众环保意识，并推动绿色能源的发展。'),
          SizedBox(height: 16),
          Text('改写：政府正在加强环保法规，提高公众意识，并推动绿色能源，以应对环境问题。'),
          SizedBox(height: 16),
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
                            style: TextStyle(color: fontColor),
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
                      labelText: i18nInstanceLocal.select_scenario,
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
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: () => _handleButtonPress('替换'),
                icon: Icon(Icons.swap_horiz),
                label: Text('替换'),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _handleButtonPress('插入'),
                icon: Icon(Icons.add),
                label: Text('插入'),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _handleButtonPress('继续写作'),
                icon: Icon(Icons.edit),
                label: Text('继续写作'),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _handleButtonPress('放弃'),
                icon: Icon(Icons.clear),
                label: Text('放弃'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}