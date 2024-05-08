import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/SheetDataModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../config/ENUMS.dart';
import '../page/createFolderPage/CreateFolderPage.dart';
import 'CheckImage.dart';

typedef OnTapCreateTagListener = void Function(dynamic obj);

GlobalKey<DialogContentState> DialogContentStateGlobalKey = GlobalKey();

class SelectTagDialogUtil {
  // static DialogContent dialogContent;

  static show(BuildContext mContext,
      {String? title,
      bool onlyRight = false,
      String? content,
      String? leftText,
      String? rightText,
      List<SheetDataModel>? list,
      OnTapListener? onTapListener,
      OnTapCreateTagListener? onTapCreateTagListener,
      Function? okCallBack,
      Function? cancelCallBack,
      String? okRouteUri = "",
      bool? input = false}) {
    title = title ?? getI18NKey().remind;
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    showDialog(
        context: mContext,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
            return DialogContent(
                key: DialogContentStateGlobalKey,
                title: title,
                content: content,
                leftText: leftText,
                rightText: rightText,
                onlyRight: onlyRight,
                okCallBack: okCallBack,
                list: list ?? [],
                onTapListener: onTapListener,
                cancelCallBack: cancelCallBack,
                onTapCreateTagListener: onTapCreateTagListener,
                okRouteUri: okRouteUri,
                input: input);
          // } else {
          //   return dialogContent;
          // }
        });
  }
}

class DialogContent extends StatefulWidget {
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? cancelCallBack; //左边回调
   String? okRouteUri; //右边按钮跳转路由
   bool? input; //是否展示输入框
   List<SheetDataModel>? list;
   OnTapListener? onTapListener;
   OnTapCreateTagListener? onTapCreateTagListener;

  DialogContent(
      {Key? key,
      this.onTapCreateTagListener,
      this.onTapListener,
      this.title,
      this.content,
      this.leftText,
      this.rightText,
      this.onlyRight,
      this.okCallBack,
      this.list,
      this.cancelCallBack,
      this.okRouteUri,
      this.input})
      : super(key: key);

  @override
  DialogContentState createState() => DialogContentState(
      onTapCreateTagListener: this.onTapCreateTagListener,
      onTapListener: this.onTapListener,
      title: this.title,
      content: this.content,
      leftText: this.leftText,
      rightText: this.rightText,
      onlyRight: this.onlyRight,
      okCallBack: this.okCallBack,
      list: this.list,
      cancelCallBack: this.cancelCallBack,
      okRouteUri: this.okRouteUri,
      input: this.input);
}

class DialogContentState extends State<DialogContent> {
  String? label = '';
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? cancelCallBack; //左边回调
   String? okRouteUri; //右边按钮跳转路由
   bool? input; //是否展示输入框
  List<SheetDataModel>? list;
   OnTapListener? onTapListener;
   OnTapCreateTagListener? onTapCreateTagListener;
  SheetDataModel? _sheetDataModelCur = null;
  List<FolderModel>? _listFolderModel;
  DialogContentState(
      {this.onTapCreateTagListener,
      this.onTapListener,
      this.title,
      this.content,
      this.leftText,
      this.rightText,
      this.onlyRight,
      this.okCallBack,
      this.list,
      this.cancelCallBack,
      this.okRouteUri,
      this.input});

  @override
  void didUpdateWidget(DialogContent oldWidget) {
    this.requestData();
  }

  void requestData() async {
    List<FolderModel> list = await MongoApisManager.getInstance()
        .queryWhereEqual_folderModelWithTag();
    List<SheetDataModel> listSheetDataModel =
        Utility.getSheetDataModelFromFolderModel(list, Icons.local_offer);
    this._listFolderModel = list;
    setState(() {
      this.list = listSheetDataModel;
    });
  }

  @override
  void initState() {
    super.initState();
    this.requestData();
  }

  setCheck(List<SheetDataModel> list, int index) {
    list.forEach((data) {
      if (data.index == index) {
        data.isChecked = true;
      } else {
        data.isChecked = false;
      }
    });
    setState(() {
      this.list = list;
    });
  }

  // getCreateTagWidget() {
  //   List<Widget> list = [];
  //   List<SheetDataModel> listModels = this.list;
  //   list.add(InkWell(
  //     onTap: () {
  //       if (this.onTapCreateTagListener != null) {
  //         this.onTapCreateTagListener(null);
  //       }
  //     },
  //     child: Container(
  //         height: 60,
  //         padding: new EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Wrap(
  //               crossAxisAlignment: WrapCrossAlignment.center,
  //               children: [
  //                 SizedBox(
  //                   width: 5,
  //                 ),
  //                 Icon(
  //                   Icons.add,
  //                   size: 14,
  //                 ),
  //                 SizedBox(
  //                   width: 5,
  //                 ),
  //                 Text(
  //                   getI18NKey().createMission,
  //                   style: TextStyle(
  //                       fontSize: 15,
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.w500),
  //                 )
  //               ],
  //             ),
  //           ],
  //         )),
  //   ));
  //   return Column(
  //     children: list,
  //   );
  // }


  getContentView() {
    List<Widget> list = [];
    List<SheetDataModel> listModels = this.list ?? [];
    for (int i = 0; i < listModels.length; i++) {
      SheetDataModel data = listModels[i];
      list.add(InkWell(
        onTap: () {
          if (this.onTapListener != null) {
            setCheck(this.list ?? [], data.index ?? 0);
            this._sheetDataModelCur = data;
            this.onTapListener!(data);
            // Navigator.of(context).pop();
          }
        },
        child: Container(
            height: 60,
            padding: new EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    data.icon ?? SizedBox.shrink(),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      data.title ?? '',
                      style: TextStyle(
                          fontSize: 15,
                          color: ThemeManager.getInstance().getTextColor(),
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                CheckImage(
                  checked: data.isChecked ?? false,
                  checkIcon: Icon(Icons.radio_button_checked_outlined,
                      color: ColorsConfig.gray_a7),
                  uncheckIcon: Icon(Icons.radio_button_unchecked_outlined,
                      color: ColorsConfig.gray_a7),
                ),
              ],
            )),
      ));
    }
    return Column(
      children: list,
    );
  }


  getCreateTagWidget() {
    List<Widget> list = [];
    // List<SheetDataModel> listModels = this.list;
    list.add(InkWell(
      onTap: () {
        if (this.widget.onTapCreateTagListener != null) {
          this.widget.onTapCreateTagListener!(null);
          FolderModel folderModel = FolderModel();
          folderModel.tag = 2; //1-normal 2-tag 3-circle
          Utility.pushNavigator(
              context,
              new CreateFolderPage(
                pageEnum: PageModeEnum.create,
                pageNavShowEnum: PageNavShowEnum.show,
                folderModel: folderModel,
              ), callback: (res) {
            // this.requestDatas();
            requestData();
            // this.onTapTag();
          });
        }
      },
      child: Container(
          height: 60,
          padding: new EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.add,
                    size: 14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    getI18NKey().createTag,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ],
          )),
    ));
    return Column(
      children: list,
    );
  }

  @override
  void didChangeDependencies() {
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      //自定义dialog布局
      child: Stack(children: [
        Align(
          alignment: Alignment.center,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  color: ThemeManager.getInstance().getCardBackgroundColor(),
                  constraints:
                      BoxConstraints(maxHeight: 500, maxWidth: 500),
                  // color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      Text(title ?? "",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      SizedBox(height: 10),
                      Text(content ?? "",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400)),
                      Container(
                        height: 200,
                        child: new ListView(children: <Widget>[
                          Container(child: getContentView()),
                          getCreateTagWidget(),
                        ]),
                      ),
                      new ButtonBar(
                        children: <Widget>[
                          new ElevatedButton(
                            child: new Text(getI18NKey().cancel),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) {
                                    //默认状态使用灰色
                                    return Colors.black;
                                  },
                                ),
                                //背景颜色
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  //设置按下时的背景颜色
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.white;
                                  }
                                  //默认不使用背景颜色
                                  return Colors.white;
                                }),
                                textStyle: MaterialStateProperty.all(TextStyle(
                                    fontSize: 18, color: Colors.black))),
                            onPressed: () {
                              Navigator.of(context).pop();
                              if(this.cancelCallBack != null) {
                                this.cancelCallBack!();
                              }
                            },
                          ),
                          new ElevatedButton(
                            child: new Text(getI18NKey().confirm),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) {
                                    //默认状态使用灰色
                                    return Colors.white;
                                  },
                                ),
                                //背景颜色
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  //设置按下时的背景颜色
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.red;
                                  }
                                  //默认不使用背景颜色
                                  return Colors.red;
                                }),
                                textStyle: MaterialStateProperty.all(TextStyle(
                                    fontSize: 18, color: Colors.red))),
                            onPressed: () {
                              if(this.widget.okCallBack != null) {
                                if (this._sheetDataModelCur?.index != null) {
                                  this.widget.okCallBack!(this._listFolderModel![this._sheetDataModelCur?.index ?? 0]);
                                } else {
                                  this.widget.okCallBack!(null);
                                }
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      )
                    ],
                  ))),
        )
      ]),
    );
  }
}
