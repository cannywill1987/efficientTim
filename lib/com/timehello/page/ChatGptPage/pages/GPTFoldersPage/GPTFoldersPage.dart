import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/SelectDateDialog.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/libs/mongodb/response/MongoDbSaved.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/ChatGptMessageModel.dart';
import 'package:time_hello/com/timehello/page/createFolderPage/WQBCreateFolderPage.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../common/provider/Env.dart';
import '../../../../common/provider/GlobalStateEnv.dart';
import '../../../../components/CustomMarquee.dart';
import '../../../../models/ChatGptFolderModel.dart';
import '../../../../models/FolderModel.dart';
import '../../../../models/WQBFolderModel.dart';
import '../../../../models/WQBFolderModelWithExtraData.dart';
import 'components/GPTMenuSilverList.dart';

class GPTFoldersPage extends BaseWidget {
  // final OnMapCallback onTapListener;
  Function onTapItemListener;
  GPTFoldersPage({required this.onTapItemListener});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _GPTFoldersPageWidgetState();
  }
}

class _GPTFoldersPageWidgetState<T> extends BaseWidgetState<GPTFoldersPage> {
  List<ChatGptFolderModel> _folderModelList = [];
  CalendarModel? calendarModel;

  @override
  void onCreate() {
    super.onCreate();
    curPage = "GPTFoldersPage";
  }

  @override
  void initState() {
    super.initState();
    this.isAppBarVisible = false;
    this.isNavBackBtnVisible = false;

    this.requestDatas();
    // forceAppBarVisible = false;
    //监听广播
    // eventBus.on<EventFn>().listen((event) {
    //   if (event.type == Params.ACTION_UPDATE_FOLDER_PAGE) {
    //     this.requestDatas(shouldRefresh: true);
    //   } else if (event.type == Params.ACTION_UPDATE_LISTVIEW) {
    //     this.updateUI();
    //   }
    // });
  }

  void onClick(type, data) async {
    switch (type) {
      //创建文件夹
      case 'onClickCreateFolder':
        onClickCreateFolder();
        break;
      case 'onClickMissionPage': //跳转任务页
        Utility.pushGPTDesktopMainContainerNavigator(
            context,  data);
        // if (data.iconType == 5 && Utility.isHandsetBySize() == false) {
        //   //PC端跳转到日程
        //
        // } else if (data.iconType == 5 && Utility.isHandsetBySize() == true) {
        //   Utility.showCurTab(
        //       context, CONSTANTS.getCurPage(PageEnum.CalendarPage), {});
        //   // Utility.pushNavigator(context,
        //   //     new CalendarPage());
        // } else {
        //   //打开mission页
        //   onClickMissionPage(data, data.iconType);
        // }
        this.widget.onTapItemListener.call();
        break;
      case 'onClickDeleteItem': //删除item
        //创建任务
        await onClickDeleteItem(data);
        break;
      // case 'onClickEditItem': //编辑item
      //   onClickEditItem(data);
      //   break;
      case 'onTapCreateTagListener': //创建tag
        onTapCreateTagListener();
        break;
      case 'onTapMore': //PC端点击更多
        onClickPCMore(data);
        break;
    }
  }

  void onClickPCMore(data) {
    this.onClick('onClickDeleteItem', data);
    // SelectDateDialogUtil.show(context,
    //     title: data.folderModelWithExtraData.title,
    //     content: '',
    //     list: CONSTANTS.getPCFolderListEditDialogModels(),
    //     onTapListener: (dataSheetDataModel) {
    //   if (dataSheetDataModel.scene == 'edit') {
    //     this.onClick('onClickEditItem', data);
    //   } else if (dataSheetDataModel.scene == 'delete') {
    //
    //   }
    // });
  }

  void onTapCreateTagListener() {
    WQBFolderModel folderModel = WQBFolderModel();
    folderModel.tag = 2; //1-normal 2-tag 3-circle
    folderModel.color = CONSTANTS.getColors()[0].color;
    Utility.openPagePCAndMobile(context,
        child: WQBCreateFolderPage(
          pageEnum: PageModeEnum.create,
          folderModel: folderModel,
        ));
  }

  // void onClickEditItem(WQBFolderModelWithExtraData data) {
  //   Utility.openPagePCAndMobile(Utility.getGlobalContext(), child:  new WQBCreateFolderPage(
  //     pageEnum: PageModeEnum.edit,
  //     folderModel: data.folderModel,
  //   ));
  // }

  Future onClickDeleteItem(data) async {
    await MongoApisManager.getInstance()
        .delete_ChatGptFolderModel(data.objectId, false);
    List<ChatGptMessageModel> listChatGptMessageModels = MongoApisManager.getInstance()
        .getChatGptMessageModelListByObjectId(
        data.folderModelWithExtraData.objectId ?? "");
    await MongoApisManager.getInstance().batchDelete_ChatGptMessageModel(listParam: listChatGptMessageModels);
    this.onClickCreateFolder();
  }

  void onClickCreateFolder() {
    context.read<Env>().curChatGptFolderModel = null;
    // WQBFolderModel folderModel = WQBFolderModel();
    // folderModel.tag = 1; //1-circle 2-tag
    // folderModel.color = CONSTANTS.getColors()[0].color;
    // Utility.openPagePCAndMobile(context,
    //     child: new WQBCreateFolderPage(
    //       pageEnum: PageModeEnum.create,
    //       folderModel: folderModel,
    //     ));
    // if (Utility.isHandsetBySize()) {
    //   Utility.pushNavigator(
    //       context,
    //       new CreateFolderPage(
    //         pageEnum: PageModeEnum.create,
    //         folderModel: folderModel,
    //       ),
    //       callback: (res) {});
    // } else {
    //   Utility.pushDesktopNavigator(context, 'CreateFolderPage',
    //       {'PageEnum': PageModeEnum.create, 'folderModel': folderModel});
    // }
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    // final value = context.read<Counter>().increment();

    // _folderModelList = context.read<GlobalStateEnv>().listChatGptFolderModel;
    // CONSTANTS.wqbFolderModelList = _folderModelList;
    return Selector<GlobalStateEnv, List<ChatGptFolderModel>>(
        selector: (_, globalStateEnv) => globalStateEnv.listChatGptFolderModel,
        builder: (_, folderModelList, __) {
          _folderModelList = folderModelList;
          requestDatas();
          return Scaffold(
              key: ValueKey('Scaffold112114'),
              body: Container(
                  key: ValueKey('Contain2er111114'),
                  color: ThemeManager.getInstance().getLeftMenuColor(defaultColor: ThemeManager.getInstance().getLightDefaultThemeColor()),
                  child: Column(
                    children: [
                      // CustomMarquee(
                      //   key: ValueKey('cu2stom_marquee_1'),
                      //   bean: MarqueInfo.marqueFolderpage,
                      //   paddingTop: 0,
                      // ),
                      Expanded(key: ValueKey('e2xpanded_1'), child: getMenuList()),
                      getItem(context)
                    ],
                  )));
        });

  }

  Widget getMenuList() {
    calendarModel = context.watch<GlobalStateEnv>().calendarModel;
    return Selector<GlobalStateEnv, List<ChatGptFolderModel>>(
      selector: (_, globalStateEnv) => globalStateEnv.listChatGptFolderModel,
      builder: (_, listChatGptFolderModel, __) {
        this._folderModelList = listChatGptFolderModel;
        return CustomScrollView(
          slivers: [
            GPTMenuSilverList(
              key: ValueKey('menu_2silver_list_1211112131221'),
              datas: this._folderModelList,
              calendarModel: calendarModel ?? CalendarModel(),
              onTapListener: (data) {
                // if (data.type == 3) {
                //   //创建页面
                //   this.onClick('onClickCreateFolder', data);
                // } else {
                  this.onClick('onClickMissionPage', data);
                // }
              },
              onTapShareListener: (data) async {},
              onTapDeleteListener: (data) async {
                // 如果pc右侧有MissionDetailPage则隐藏
                //按理说这个不需要 因为删除的时候会自动刷新
                if (!Utility.isHandsetBySize()) {
                  Utility.popupDesktopRightNavigator(context);
                }
                this.onClick('onClickDeleteItem', data);
              },
              onTapEditListener: (data) {
                // 如果pc右侧有MissionDetailPage则隐藏
                // if (!Utility.isHandsetBySize()) {
                //   Utility.popupDesktopRightNavigator(context);
                // }
                // this.onClick('onClickEditItem', data);
              },
              onTapCreateTagListener: (data) {
                // 如果pc右侧有MissionDetailPage则隐藏
                if (!Utility.isHandsetBySize()) {
                  Utility.popupDesktopRightNavigator(context);
                }
                this.onClick('onTapCreateTagListener', data);
              },
              onTapMoreListener: (data) {
                // 如果pc右侧有MissionDetailPage则隐藏
                if (!Utility.isHandsetBySize()) {
                  Utility.popupDesktopRightNavigator(context);
                }
                this.onClick('onTapMore', data);
              },
              onTapCreateFolderListener: (data) {
                // 如果pc右侧有MissionDetailPage则隐藏
                if (!Utility.isHandsetBySize()) {
                  Utility.popupDesktopRightNavigator(context);
                }
              },
              onTapFinishListener: (data) {
                // 如果pc右侧有MissionDetailPage则隐藏
                if (!Utility.isHandsetBySize()) {
                  Utility.popupDesktopRightNavigator(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  requestDatas({bool shouldRefresh = false}) async {
    // List<WQBFolderModel> datas = await MongoApisManager.getInstance()
    //     .queryWhereEqual_WQBFolderModel(shouldRefresh: shouldRefresh);
    if(shouldRefresh)
    setState(() {});
  }

  InkWell getItem(BuildContext context) {
    WQBFolderModelWithExtraData _folderModelWithExtraData =
        CONSTANTS.getCreateWQBFolderModel();
    List<Widget> children = <Widget>[
      Container(
          key: ValueKey('Conta2ineqer4'),
          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Icon(
              key: ValueKey('Ic2ons14'),
              Icons.add,
              size: 22,
              color: ThemeManager.getInstance().getIconColor(defaultColor: ColorsConfig.create_folder))),
      SizedBox(
        key: ValueKey('SizedB2owqx14'),
        width: 10,
      ),
      Expanded(
          key: ValueKey('Expa2ndwqed14'),
          child: Text(getI18NKey().create_chat,
              key: ValueKey('T2extwq14'),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: ThemeManager.getInstance().getTextColor(defaultColor: _folderModelWithExtraData.folderModel.iconType == 7
                      ? ColorsConfig.create_folder
                      : ColorsConfig.gray_40))),
          flex: 3),
    ];
    return InkWell(
        key: ValueKey('InkWel2l_1'),
        onTap: () {
          // listen 设为false，不建立依赖关系
          // context.read<Counter2>().increment();
          // Provider.of<Counter2>(context, listen: false).increment();
          this.onClick('onClickCreateFolder', {});
          // context.read<Counter>().increment();
        },
        child: Container(
          key: ValueKey('Cont2ainer2'),
          height: 50,
          alignment: Alignment.centerLeft,
          child: Row(
            key: ValueKey('R2ow2'),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ));
  }
}
