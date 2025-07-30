import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';

import '../models/SheetDataModel.dart';
import '../util/Utility.dart';

class SharePopupWidget extends StatefulWidget {
  @override
  _SharePopupWidgetState createState() => _SharePopupWidgetState();
}

class _SharePopupWidgetState extends State<SharePopupWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late List<SheetDataModel> list;
  @override
  void initState() {
    super.initState();
    list = CONSTANTS.getShareModels();
    // _controller = AnimationController(
    //   duration: const Duration(seconds: 1),
    //   vsync: this,
    // )..forward();
    // _offsetAnimation = Tween<Offset>(
    //   begin: const Offset(0.0, 1.0),
    //   end: Offset.zero,
    // ).animate(CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.easeInOut,
    // ));
    // Future.delayed(Duration(), () {
    //   this.show();
    // });
  }

  // void show() {
  //   _controller.forward();
  // }
  //
  // void hide() {
  //   _controller.reverse();
  // }

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      //自定义dialog布局
      child: Stack(children: [
        Align(
          alignment: Utility.isHandsetBySize()
              ? Alignment.center
              : Alignment.center,
          child: Container(
              padding: EdgeInsets.fromLTRB(5, 20, 0, 15),
              decoration: Utility.isHandsetBySize()
                  ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)))
                  : BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              constraints: BoxConstraints(maxHeight: 90, maxWidth: 300),
              // color: Colors.white,
              child: GridView.count(
                crossAxisCount: list.length,
                children: List.generate(list.length, (index) {
                  SheetDataModel data = list[index];
                  return InkWell(
                    onTap: () {
                      print('Item $index clicked');
                    },
                    child: Column(
                      children: <Widget>[
                        data.icon ?? SizedBox.shrink(),
                        Text(
                          data.title ?? "",
                          style: TextStyle(
                            color: Color(0xFF404040),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              )),
        )
      ]),
    );


  }
}
