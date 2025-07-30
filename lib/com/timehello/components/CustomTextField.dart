//一个组件,属性有TextStyle的style
//bool isEditable
//isEditable = false为false显示text true显示透明背景的textfield

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/page/DrawPage/drawing_canvas/models/sketch.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class CustomTextField extends StatefulWidget {
  final TextStyle style;
  final String text;
  bool shouldUpdateText = false; //是否需要更新text
  final Function(String) onEnterListener;
  Function()? onCancelListener;
  double maxWidth = 200;
  Widget? icon;
  double padding = 0;
  bool isEditable = true;
  bool isEditing = false;

  CustomTextField(
      {Key? key,
      this.icon,
      this.isEditable = true,
      this.isEditing = false,
      required this.style,
      required this.text,
      this.onCancelListener,
      required this.onEnterListener,
      this.shouldUpdateText = false,
      this.padding = 0,
      this.maxWidth = 200})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomTextFieldState(isEditting: this.isEditing);
  }
}

class CustomTextFieldState extends State<CustomTextField> {
  bool isEditting = false;
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode(); // 创建FocusNode实例
  bool isHover = false;

  CustomTextFieldState({this.isEditting = false});

// GlobalKey keyTextField = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.widget.shouldUpdateText == false) _controller.text = widget.text;
    if (this.isEditting == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (isEditting) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  didUpdateWidget(CustomTextField oldWidget) {
    if (this.widget.shouldUpdateText == false) _controller.text = widget.text;
  }

  setEditing({isEditting: false}) {
    setState(() {
      this.isEditting = isEditting;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isEditting) {
      return Focus(
        onKey: (FocusNode node, RawKeyEvent event) {
          //新版本textfield已经支持 Textfield onSubmitted的enter方法
          if (event.data.physicalKey == PhysicalKeyboardKey.escape) {
            if (this.widget.isEditable == false) {
              return KeyEventResult.ignored;
            }
            cancel();
          }
          return KeyEventResult.ignored;
        },
        child: Container(
          height:
              widget.style.fontSize != null ? widget.style.fontSize! * 1.7 : 30,
          width: this.widget.maxWidth,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  style: TextStyle(
                      color: ThemeManager.getInstance()
                          .getTextColor(defaultColor: Color(0xff404040)),
                      fontSize: (this.widget.style.fontSize == null || this.widget.style.fontSize! * 0.6 < 12) ? 12 : this.widget.style.fontSize! * 0.6,
                      fontWeight: this.widget.style.fontWeight),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ThemeManager.getInstance()
                        .getInputDecorationColor(
                            defaultColor: Color(0xffe0e0e0)), // 设置填充颜色为灰色
                    border: OutlineInputBorder(
                      // 设置边框
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(10.0), // 设置圆角
                    ),
                  ),
                  onSubmitted: (value) {
                    if (this.widget.isEditable == false) {
                      return;
                    }
                    setState(() {
                      isEditting = false;
                    });
                    _controller.text = value;
                    widget.onEnterListener(value);
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  if (this.widget.isEditable == false) {
                    return;
                  }
                  cancel();
                  // widget.onEnterListener(_controller.text);
                },
                child: Icon(Icons.close,
                    color: Colors.redAccent,
                    size: this.widget.style.fontSize != null
                        ? this.widget.style.fontSize! * 1.5
                        : 20),
              ),
              InkWell(
                onTap: () {
                  if (this.widget.isEditable == false) {
                    return;
                  }
                  setState(() {
                    isEditting = false;
                  });
                  widget.onEnterListener(_controller.text);
                },
                child: Icon(Icons.done,
                    color: Colors.lightGreenAccent,
                    size: this.widget.style.fontSize != null
                        ? this.widget.style.fontSize! * 1.5
                        : 20),
              )
            ],
          ),
        ),
      );
    } else {
      if(this.widget.isEditable == false){
        return this.getBody();
      }
      return MouseRegion(
        onEnter: (_) {
          setState(() {
            this.isHover = true;
          });
        },
        onHover: (_) {},
        onExit: (_) {
          setState(() {
            this.isHover = false;
          });
        },
        child: this.widget.isEditable == false?this.getBody() : InkWell(
          onTap: () {
            if (this.widget.isEditable == false) {
              return;
            }
            setState(() {
              isEditting = true;
            });
            _focusNode.requestFocus(); // 请求焦点
            _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: _controller.text.length)); // 将光标移动到文本末尾
          },
          child: getBody(),
        ),
      );
    }
  }

  Widget getBody() {
    return this.widget.icon != null
            ? Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: this.widget.padding,
                  ),
                  this.widget.icon!,
                  if (this.widget.icon != null)
                    SizedBox(
                      width: 5,
                    ),
                  Text(
                    this.widget.shouldUpdateText
                        ? this.widget.text
                        : _controller.text,
                    style: widget.style,
                  )
                ],
              )
            : Container(
                decoration: BoxDecoration(
                  color: isHover ? Color(0x48e0e0e0) : null,
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Text(
                  _controller.text,
                  style: widget.style,
                ),
              );
  }

  void cancel() {
    this.isHover = false;
    _controller.text = this.widget.text;
    setState(() {
      isEditting = false;
    });
    this.widget.onCancelListener?.call();
  }
}
