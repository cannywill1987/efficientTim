// import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/StylesConfig.dart';
import '../util/ThemeManager.dart';


class AISearchBar extends StatefulWidget {
  Function? onSubmit;
  String? title;
  String? prompt;
  String? placeholder;

  AISearchBar({this.onSubmit, this.prompt, this.title, this.placeholder});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AISearchBarState();
  }
}

class AISearchBarState extends State<AISearchBar> {
  final TextEditingController _controller = TextEditingController();
  Color color = Colors.purple;
  Color fontColor = Colors.black;
  double iconSize = 18;
  double fontSize = 14;

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

  // getListWidget() {
  //   List<AppFlowyCheckButtonStateModel> list = AppFlowyCheckButtonStateModel.getModelList();
  //   List<Widget> widgets = [];
  //   for (AppFlowyCheckButtonStateModel model in list) {
  //     widgets.add( ListTile(
  //       leading: model.checkIcon,
  //       title: Text(model.title ?? "", style: TextStyle(color: fontColor, fontSize: fontSize),),
  //       onTap: () {
  //         // Handle menu item tap
  //         _controller.text = model.content ?? "";
  //         setState(() {
  //
  //         });
  //       },
  //     ));
  //   }
  //   return widgets;
  // }

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
                    this.widget.onSubmit?.call(this.widget.prompt!, _controller.text);
                  },
                  style: TextStyle(color: ThemeManager.getInstance().getTextColor()),
                  decoration: InputDecoration(
                    // labelText: "134",
                    label: Text(this.widget.placeholder ?? ""),
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
                        if (this.widget.title != null)
                          Container(
                            margin: EdgeInsets.only(left: 2),
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(Colors.purple.value - 0xc0000000),
                            ),
                            child: Text(
                              this.widget.title!,
                              style:
                                  TextStyle(color: Colors.purple, fontSize: 12),
                            ),
                          ),
                        if (this.widget.title != null)
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
                            this.widget.onSubmit?.call(this.widget.prompt!, _controller.text);
                                },
                          child: Icon(Icons.arrow_forward),
                        ),
                        SizedBox(width: 8)
                      ],
                    ),
                    focusedBorder: StylesConfig.buildOutlineInputBorder(),
                    enabledBorder: StylesConfig.buildOutlineInputBorder(),
                    border: StylesConfig.buildOutlineInputBorder(),
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
        // Expanded(
        //   child: ListView(
        //     children: getListWidget(),
        //   ),
        // ),
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
