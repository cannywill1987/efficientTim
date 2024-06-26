import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/PresentModel.dart';
import 'package:time_hello/com/timehello/models/SheetDataModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../config/ENUMS.dart';
import '../page/createFolderPage/CreateFolderPage.dart';
import '../page/createFolderPage/CreatePresentPage.dart';
import 'CheckImage.dart';
import 'MoneyHandlerWidget.dart';

typedef OnTapCreatePresentListener = void Function(dynamic obj);

GlobalKey<DialogContentState> DialogContentStateGlobalKey = GlobalKey();

class SelectPresentDialogUtil {
  static  show(BuildContext mContext,
      {String? title,
      bool isCheckButtonShow = false,
        int maxSelected = -1,
      String? content,
      String? leftText,
      String? rightText,
      List<SheetDataModel>? list,
      OnTapListener? onTapListener,
      OnTapCreatePresentListener? onTapCreatePresentListener,
        bool isCloseAuto = true, //点击Ok是否自动关闭
      Function? okCallBack,
      Function? cancelCallBack,
      String okRouteUri = "",
      bool input = false}) {
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
              isCheckButtonShow: isCheckButtonShow,
              isCloseAuto: isCloseAuto,
              maxSelected: maxSelected,
              okCallBack: okCallBack,
              list: list ?? [],
              onTapListener: onTapListener,
              cancelCallBack: cancelCallBack,
              onTapCreatePresentListener: onTapCreatePresentListener,
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
   bool? isCheckButtonShow; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? cancelCallBack; //左边回调
   String? okRouteUri; //右边按钮跳转路由
   bool? input; //是否展示输入框
   bool? isCloseAuto;
   List<SheetDataModel>? list;
   OnTapListener? onTapListener;
   OnTapCreatePresentListener? onTapCreatePresentListener;
  int? maxSelected;
  DialogContent(
      {Key? key,
        this.maxSelected,
      this.onTapCreatePresentListener,
      this.onTapListener,
      this.title,
        this.isCloseAuto,
      this.content,
      this.leftText,
      this.rightText,
      this.isCheckButtonShow,
      this.okCallBack,
      this.list,
      this.cancelCallBack,
      this.okRouteUri,
      this.input})
      : super(key: key);

  @override
  DialogContentState createState() => DialogContentState(
      onTapCreatePresentListener: this.onTapCreatePresentListener,
      onTapListener: this.onTapListener,
      title: this.title,
      content: this.content,
      maxSelected: this.maxSelected,
      isCloseAuto: this.isCloseAuto,
      leftText: this.leftText,
      rightText: this.rightText,
      isCheckButtonShow: this.isCheckButtonShow,
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
   bool? isCheckButtonShow; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? cancelCallBack; //左边回调
   String? okRouteUri; //右边按钮跳转路由
   bool? input; //是否展示输入框
  List<SheetDataModel>? list;
   OnTapListener? onTapListener;
   OnTapCreatePresentListener? onTapCreatePresentListener;
  List<PresentModel>? _listFolderModel;
   bool? isCloseAuto;
  int? maxSelected;
  DialogContentState(
      {this.onTapCreatePresentListener,
      this.onTapListener,
      this.title,
      this.content,
        this.maxSelected,
      this.leftText,
        this.isCloseAuto,
      this.rightText,
      this.isCheckButtonShow,
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
    List<PresentModel> list =
        await MongoApisManager.getInstance().queryWhereEqual_presentModel();
    List<SheetDataModel> listSheetDataModel =
        Utility.getSheetDataModelFromPresentModel(list, Icons.local_offer, 15);
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
        data.isChecked = !(data.isChecked ?? false);
      }
    });
    setState(() {
      this.list = list;
    });
  }

  getContentView() {
    List<Widget> list = [];
    List<SheetDataModel> listModels = this.list ?? [];
    for (int i = 0; i < listModels.length; i++) {
      SheetDataModel data = listModels[i];
      list.add(InkWell(
        onTap: () {
          setCheck(this.list ?? [], data.index ?? 0);
          // this._sheetDataModelCur = data;
          if (this.onTapListener != null) {
            this.onTapListener!(data);
          }
        },
        child: Slidable(
          key: ValueKey(i),
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.15,
            children: [
              SlidableAction(
                onPressed: (context) {
                  PresentModel presentModel = _listFolderModel![i];
                  Utility.openPagePCAndMobile(context, child: CreatePresentPage(
                      pageEnum: PageModeEnum.edit,
                      presentModel: presentModel,
                      callback: () {
                        requestData();
                      }
                  ));
                },
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: getI18NKey().edit,
              ),
              SlidableAction(
                onPressed: (context) async {
                  PresentModel presentModel = _listFolderModel![i];
                  try {
                    await MongoApisManager.getInstance().delete_PresentModel(
                        currentObjectId: presentModel.objectId);
                    requestData();
                  } catch (e) {
                    // Handle error
                  }
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: getI18NKey().delete,
              ),
            ],
          ),
          child: Container(
            height: 60,
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  direction: Axis.vertical,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(width: 5),
                        data.icon ?? SizedBox.shrink(),
                        SizedBox(width: 5),
                        Text(
                          data.title ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            color: ThemeManager.getInstance()
                                .getTextColor(defaultColor: Colors.black),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(width: 25),
                        Text(getI18NKey().consump_money),
                        SizedBox(width: 5),
                        MoneyHandlerWidget(
                          money: (data.data as PresentModel).value.toString(),
                          pageFrom: PageFromEnum.PresentDialog,
                        )
                      ],
                    ),
                  ],
                ),
                (this.isCheckButtonShow ?? false)
                    ? CheckImage(
                  checked: data.isChecked ?? false,
                  checkIcon: Icon(
                    Icons.radio_button_checked_outlined,
                    color: ColorsConfig.gray_a7,
                  ),
                  uncheckIcon: Icon(
                    Icons.radio_button_unchecked_outlined,
                    color: ColorsConfig.gray_a7,
                  ),
                )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        )));
    }
    return Column(
      children: list,
    );
  }

  getCreateTagWidget() {
    List<Widget> list = [];
    list.add(InkWell(
      onTap: () {
        if (this.widget.onTapCreatePresentListener != null) {
          this.widget.onTapCreatePresentListener!(null);
        }
        PresentModel presentModel = PresentModel();
        // FolderModel folderModel = FolderModel();
        // folderModel.tag = 2; //1-normal 2-tag 3-circle
        Utility.openPagePCAndMobile(
            context,
            child: new CreatePresentPage(
              pageEnum: PageModeEnum.create,
              presentModel: presentModel,
        callback: () {
            // this.requestDatas();
            requestData();
        // this.onTapTag();
      }
            ));
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
                    getI18NKey().create_present,
                    style: TextStyle(
                        fontSize: 15,
                        color: ThemeManager.getInstance().getTextColor(defaultColor: Colors.black),
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
  void didChangeDependencies() {}

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
                  color: ThemeManager.getInstance().getDialogBackgroundColor(defaultColor: Colors.white),
                  constraints: BoxConstraints(maxHeight: 500, maxWidth: 500),
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
                        height: 300,
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
                              if (this.cancelCallBack != null) {
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
                              if (this.widget.okCallBack != null) {
                                // List<PresentModel> listPresentModel = [];
                                // if (this._sheetDataModelCur?.index != null) {
                                  this.widget.okCallBack!(Utility.getCheckedModelFromSheetModelList(this.list ?? []));
                                // } else {
                                //   this.widget.okCallBack(null);
                                // }
                              }
                              if (this.widget.isCloseAuto == true) {
                                Navigator.of(context).pop();
                              }
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
