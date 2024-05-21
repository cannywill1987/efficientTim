import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class AddGroupDialogWidget extends StatefulWidget {
  Function? okCallback;
  Function? cancelCallback;
  FolderModel? folerModel;
  String? cancelText;
  String? okText;
  Widget? child;
  AddGroupDialogWidget({Key? key, this.child, this.okText, FolderModel? folerModel, this.okCallback, this.cancelCallback, this.cancelText}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddGroupDialogWidgetState();
  }

}

class AddGroupDialogWidgetState extends State<AddGroupDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              constraints: BoxConstraints(
                maxWidth: 500,
              ),
              decoration: StylesConfig.getDecoration(
                radius: 12,
              ),
              child: Column(
                children: [
                  Text(
                    this.widget.folerModel?.title ?? "",
                    style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  this.widget.child ?? SizedBox.shrink(),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: ThemeManager.getInstance().getLineColor(),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                if (this.widget.cancelCallback != null) {
                                  this.widget.cancelCallback?.call();
                                }
                              },
                              child: Text(
                                  this.widget.cancelText ?? getI18NKey().refuse,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Color(0xffbbbbbb),
                                      fontSize: 15)))),
                      Container(
                        width: 1,
                        height: 40,
                        color:
                        ThemeManager.getInstance().getLineColor(),
                      ),
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                if (this.widget.okCallback != null) {
                                  this.widget.okCallback?.call();
                                }
                              },
                              child: Text(
                                this.widget.okText ?? getI18NKey().agree,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: ThemeManager.getInstance()
                                        .getTextColor(
                                        defaultColor: ThemeManager
                                            .getInstance()
                                            .getDefautThemeColor()),
                                    fontSize: 15),
                              )))
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}