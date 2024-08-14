import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AiContentConfirmWidget extends StatefulWidget {
  String text;
  bool shouldShowReplace;
  Function? onSubmit;
  Function? onReplace;
  Function? onInsert;
  Function? onContinue;
  Function? onGiveUp;
  Function? onCopy;

  AiContentConfirmWidget({
    required this.text,
    this.shouldShowReplace = true,
    this.onCopy,
    this.onSubmit,
    this.onReplace,
    this.onInsert,
    this.onContinue,
    this.onGiveUp,
  });

  @override
  State<StatefulWidget> createState() {
    return AiContentConfirmWidgetState();
  }
}

class AiContentConfirmWidgetState extends State<AiContentConfirmWidget> {
  final _controller = TextEditingController();
  Color color = Colors.purple;
  Color fontColor = Colors.black;
  double iconSize = 18;
  double fontSize = 14;
  double itemHeight = 40;

  void _handleButtonPress(String action) {
    switch (action) {
      case 'copy':
        print('复制');
        _controller.text = this.widget.text;
        this.widget.onCopy?.call(_controller.text);
        break;
      case 'replace':
        print('替换');
        this.widget.onReplace?.call(this.widget.text);
        break;
      case 'insert':
        print('插入');
        this.widget.onInsert?.call(this.widget.text);
        break;
      case 'continue':
        print('继续写作');
        this.widget.onContinue?.call(this.widget.text);
        break;
      case 'giveup':
        _controller.clear();
        this.widget.onGiveUp?.call(_controller.text);
        print('放弃');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color),
          ),
          child: Column(
            children: [
              Container(
          constraints: BoxConstraints(maxHeight: 120),
                  child: Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                    child: SingleChildScrollView(
                      child: Text(this.widget.text,
                          style: TextStyle(color: fontColor)),
                    ),
                  )),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.black),
                      onSubmitted: (text) {
                        this.widget.onSubmit?.call(_controller.text);
                      },
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
                                backgroundColor: _controller.text.isEmpty
                                    ? Colors.purple[100]
                                    : color,
                                disabledBackgroundColor:
                                    _controller.text.isEmpty
                                        ? Colors.purple[100]
                                        : color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                              onPressed: _controller.text.isEmpty
                                  ? null
                                  : () {
                                      this
                                          .widget
                                          .onSubmit
                                          ?.call(_controller.text);
                                    },
                              child: Icon(Icons.arrow_forward),
                            ),
                            SizedBox(
                              width: 8,
                            )
                          ],
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: color,
                          ),
                        ),
                        labelText: i18nInstanceLocal.select_scenario,
                        labelStyle: TextStyle(
                          color: _controller.text.isEmpty
                              ? Colors.purple[100]
                              : color,
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        Container(
          width: 300,
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(this.widget.shouldShowReplace == true)
              InkWell(
                onTap: () => _handleButtonPress('replace'),
                child: Container(
                  height: itemHeight,
                  child: Row(
                    children: [
                      Icon(
                        Icons.swap_horiz,
                        color: color,
                        size: iconSize,
                      ),
                      SizedBox(width: 8),
                      Text(i18nInstanceLocal.replace,
                          style: TextStyle(color: fontColor)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () => _handleButtonPress('insert'),
                child: Container(
                  height: itemHeight,
                  child: Row(
                    children: [
                      Icon(Icons.add, color: color, size: iconSize),
                      SizedBox(width: 8),
                      Text(i18nInstanceLocal.insert,
                          style: TextStyle(color: fontColor)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () => _handleButtonPress('continue'),
                child: Container(
                  height: itemHeight,
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: color, size: iconSize),
                      SizedBox(width: 8),
                      Text(i18nInstanceLocal.continue_writing,
                          style: TextStyle(color: fontColor)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              //复制
              InkWell(
                onTap: () => _handleButtonPress('copy'),
                child: Container(
                  height: itemHeight,
                  child: Row(
                    children: [
                      Icon(Icons.copy, color: color, size: iconSize),
                      SizedBox(width: 8),
                      Text(i18nInstanceLocal.copy,
                          style: TextStyle(color: fontColor)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () => _handleButtonPress('giveup'),
                child: Container(
                  height: itemHeight,
                  child: Row(
                    children: [
                      Icon(Icons.clear, color: color, size: iconSize),
                      SizedBox(width: 8),
                      Text(i18nInstanceLocal.give_up,
                          style: TextStyle(color: fontColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
