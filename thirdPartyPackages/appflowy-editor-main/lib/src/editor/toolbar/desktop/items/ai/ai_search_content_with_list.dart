// import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../model/AppFlowyCheckButtonStateModel.dart';

class AISearchContentWithListWidget extends StatefulWidget {
  Function? onSubmit;


  AISearchContentWithListWidget({this.onSubmit});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AISearchContentWithListWidgetState();
  }
}

class AISearchContentWithListWidgetState extends State<AISearchContentWithListWidget> {
  final TextEditingController _controller = TextEditingController();
  Color color = Colors.purple;
  Color fontColor = Colors.black;
  double iconSize = 18;
  double fontSize = 14;
  String? placeholder;
  String? title;
  String? prompt;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _controller.
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _handleButtonClick(AppFlowyCheckButtonStateModel action) {
    print('Button clicked: $action');
    // this.widget.onSubmit?.call(action);
    this.placeholder = action.content;
    this.title = action.title;
    this.prompt = action.value;
    _controller.text = "";
    setState(() {

    });

    // 在这里添加处理点击事件的逻辑
  }

  getListWidget() {
    List<AppFlowyCheckButtonStateModel> list = AppFlowyCheckButtonStateModel.getAIListPrompts();
    List<Widget> widgets = [];
    for (AppFlowyCheckButtonStateModel model in list) {
      widgets.add( ListTile(
        leading: model.checkIcon,
        title: Text(model.title ?? "", style: TextStyle(color: fontColor, fontSize: fontSize),),
        onTap: () {
          // Handle menu item tap
          // _controller.text = model.content ?? "";
          _handleButtonClick(model);
          setState(() {

          });
        },
      ));
    }
    return widgets;
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
                  onSubmitted: (text) {
                    this.widget.onSubmit?.call(this.prompt!, _controller.text);
                  },
                  style: TextStyle(color: Color(0xff404040)),
                  decoration: InputDecoration(
                    // labelText: "134",
                    label: Text(this.placeholder ?? ""),
                    floatingLabelStyle: TextStyle(
                      color: Colors.purple,
                    ),
                    labelStyle: TextStyle(
                      color: Color(0xffa0a0a0),
                      fontSize: 14
                    ),
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.search,
                          color: color,
                          size: 20,
                        ),
                        if (this.title != null && this.title!.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(left: 2),
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(Colors.purple.value - 0xc0000000),
                            ),
                            child: Text(
                              this.title!,
                              style:
                                  TextStyle(color: Colors.purple, fontSize: 12),
                            ),
                          ),
                        if (this.title != null && this.title!.isNotEmpty)
                          SizedBox(
                            width: 5,
                          ),
                      ],
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${_controller.text.length}/1000',
                          style: TextStyle(color: color),
                        ),
                        SizedBox(width: 8),
                        //圆形
                        ElevatedButton(
                          clipBehavior: Clip.antiAlias,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _controller.text.isEmpty
                                ? Colors.purple[100]
                                : color,
                            // 按钮颜色
                            disabledBackgroundColor: _controller.text.isEmpty
                                ? Colors.purple[100]
                                : color,
                            // 按钮颜色
                            // foregroundColor: _controller.text.isEmpty ? Colors.purple[100] : color, // 文字颜色
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          onPressed: _controller.text.isEmpty
                              ? null
                              : () {
                                  // Handle button press
                                  // this.widget.onSubmit?.call(_controller.text);
                            this.widget.onSubmit?.call(this.prompt!, _controller.text);
                                },
                          child: Icon(Icons.arrow_forward),
                        ),
                        SizedBox(width: 8)
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
                    // labelText: i18nInstanceLocal.select_scenario,
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
            children: getListWidget(),
          ),
        ),
        // Container(
        //   padding: const EdgeInsets.all(8.0),
        //   child: ElevatedButton(
        //     onPressed: () {
        //       // Handle button press
        //     },
        //     child: Text(i18nInstanceLocal.manage),
        //   ),
        // ),
      ],
    );
  }
}
