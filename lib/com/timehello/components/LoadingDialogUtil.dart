import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import 'LoadingWidget.dart';

enum LoadingTypeEnum { typeDefault, typeTomatoes, typeCircleLoading }

class LoadingDialogUtil {
  static LoadingDialogUtil? _instance;

  static LoadingDialogUtil getInstance() {
    if (_instance == null) {
      _instance = LoadingDialogUtil();
    }
    return _instance!;
  }

  // static DialogContent dialogContent;
  BuildContext? context;

  hide() {
    if (context != null) {
      Navigator.pop(context!);
      context = null;
    }
  }

  show(BuildContext mContext,
      {String? title,
      LoadingTypeEnum loadingType = LoadingTypeEnum.typeTomatoes,
      canceledOnTouchOutside = false}) {
    title = title ?? getI18NKey().loading;
    if (context == null || context != mContext) {
      showDialog(
          context: context = mContext,
          builder: (BuildContext context) {
            return DialogContent(
                // key: LoadingDialogUtilStateGlobalKey,
                title: title,
                canceledOnTouchOutside: canceledOnTouchOutside);
          });
    }
  }
}

class DialogContent extends StatefulWidget {
   String? title; //标题
  bool? canceledOnTouchOutside = false;
  LoadingTypeEnum? loadingType;

  DialogContent({
    Key? key,
    this.title,
    this.canceledOnTouchOutside,
    this.loadingType = LoadingTypeEnum.typeTomatoes,
  }) : super(key: key);

  @override
  DialogContentState createState() => DialogContentState(
        title: this.title,
      );
}

class DialogContentState extends State<DialogContent>
    with TickerProviderStateMixin {
   String? title; //标题

  DialogContentState({
    this.title,
  });

  @override
  void didUpdateWidget(DialogContent oldWidget) {}

  @override
  void initState() {
    super.initState();
  }

  Widget _dialog() {
    // print("val:" + animationCloud1.value.toString());
    return new Center(
      ///弹框大小
      child: new SizedBox(
        width: 120.0,
        height: 120.0,
        child: new Container(
          ///弹框背景和圆角
          decoration: ShapeDecoration(
            color: this.widget.loadingType == LoadingTypeEnum.typeCircleLoading
                ? Color(0xffffffff)
                : Color(0xa0202020),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              this.widget.loadingType == LoadingTypeEnum.typeCircleLoading
                  ? new CircularProgressIndicator()
                  : LoadingWidget(),
              new Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                ),
                child: new Text(
                  this.title ?? getI18NKey().loading,
                  style: new TextStyle(
                    fontSize: 16.0,
                    color: this.widget.loadingType ==
                            LoadingTypeEnum.typeCircleLoading
                        ? Color(0xff404040)
                        : Color(0xffffffff),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Material(

          ///背景透明
          color: Colors.transparent,

          ///保证控件居中效果
          child: Stack(
            children: <Widget>[
              GestureDetector(
                ///点击事件
                onTap: () {
                  if (this.widget.canceledOnTouchOutside ?? false) {
                    // this.context = context;
                    Navigator.pop(context);
                  }
                },
              ),
              _dialog()
            ],
          )),
    );
  }
}
