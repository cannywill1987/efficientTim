import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
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
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/page/createFolderPage/WQBCreateFolderPage.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

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
        if (data.iconType == 5 && Utility.isHandsetBySize() == false) {
          //PC端跳转到日程
          Utility.pushWQBDesktopMainContainerNavigator(
              context, "WQBMissionPage", {});
        } else if (data.iconType == 5 && Utility.isHandsetBySize() == true) {
          Utility.showCurTab(
              context, CONSTANTS.getCurPage(PageEnum.CalendarPage), {});
          // Utility.pushNavigator(context,
          //     new CalendarPage());
        } else {
          //打开mission页
          onClickMissionPage(data, data.iconType);
        }
        this.widget.onTapItemListener.call();
        break;
      case 'onClickDeleteItem': //删除item
        //创建任务
        await onClickDeleteItem(data);
        break;
      case 'onClickEditItem': //编辑item
        onClickEditItem(data);
        break;
      case 'onTapCreateTagListener': //创建tag
        onTapCreateTagListener();
        break;
      case 'onTapMore': //PC端点击更多
        onClickPCMore(data);
        break;
    }
  }

  void onClickPCMore(data) {
    SelectDateDialogUtil.show(context,
        title: data.folderModelWithExtraData.title,
        content: '',
        list: CONSTANTS.getPCFolderListEditDialogModels(),
        onTapListener: (dataSheetDataModel) {
      if (dataSheetDataModel.scene == 'edit') {
        this.onClick('onClickEditItem', data);
      } else if (dataSheetDataModel.scene == 'delete') {
        this.onClick('onClickDeleteItem', data);
      }
    });
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

  void onClickEditItem(WQBFolderModelWithExtraData data) {
    Utility.openPagePCAndMobile(Utility.getGlobalContext(), child:  new WQBCreateFolderPage(
      pageEnum: PageModeEnum.edit,
      folderModel: data.folderModel,
    ));
  }

  Future onClickDeleteItem(data) async {
    OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: getI18NKey(context).delete,
        message: getI18NKey(context).confirmToDelete,
        okLabel: getI18NKey(context).confirm,
        cancelLabel: getI18NKey(context).cancel,
        onWillPop: () async {
          //点击对话框外围黑色区域才会走这里
          return true;
        });
    if (result == OkCancelResult.ok) {
      await Future.wait([
        MongoApisManager.getInstance()
            .delete_ChatGptFolderModel(data.folderModelWithExtraData.objectId),
        // MongoApisManager.getInstance()
        //     .batchdelete_MissionModel(folder_id: data.folderModel.objectId),
        // MongoApisManager.getInstance()
        //     .delete_CourseModel(data.folderModel.courseModelId)
      ]);

    }
  }

  // 根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成
  void onClickMissionPage(data, folderStatus) {
    Utility.pushWQBDesktopMainContainerNavigator(
        context, 'WQBMissionPage', {'data': data, 'folderStatus': folderStatus});
    // if (Utility.isHandsetBySize()) {
    //   // if (this.widget.onTapListener != null) {
    //   //   this.widget.onTapListener!(
    //   //       {"folderModel": data, "folderStatus": folderStatus});
    //   //   // this.widget.onTapListener(
    //   //   //     {"folderModel": data, "folderStatus": folderStatus});
    //   // }
    //   // Utility.pushNavigator(context,
    //   //     new MissionPage(folderModel: data, folderStatus: folderStatus));
    // } else {
    //   // Utility.pushDesktopNavigator(
    //   //     context, 'MissionPage', {'data': data, 'folderStatus': folderStatus});
    // }
  }

  void onClickCreateFolder() {
    WQBFolderModel folderModel = WQBFolderModel();
    folderModel.tag = 1; //1-circle 2-tag
    folderModel.color = CONSTANTS.getColors()[0].color;
    Utility.openPagePCAndMobile(context,
        child: new WQBCreateFolderPage(
          pageEnum: PageModeEnum.create,
          folderModel: folderModel,
        ));
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

    _folderModelList = context.read<GlobalStateEnv>().listChatGptFolderModel;
    // CONSTANTS.wqbFolderModelList = _folderModelList;
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
                screenType == ScreenType.Handset
                    ? SizedBox.shrink()
                    : getItem(context)
              ],
            )));
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
                if (data.type == 3) {
                  //创建页面
                  this.onClick('onClickCreateFolder', data);
                } else {
                  this.onClick('onClickMissionPage', data);
                }
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
                if (!Utility.isHandsetBySize()) {
                  Utility.popupDesktopRightNavigator(context);
                }
                this.onClick('onClickEditItem', data);
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
    List<WQBFolderModel> datas = await MongoApisManager.getInstance()
        .queryWhereEqual_WQBFolderModel(shouldRefresh: shouldRefresh);
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
          child: Text(_folderModelWithExtraData.folderModel.title ?? "",
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
    children.addAll([
      Wrap(
        key: ValueKey('Wrap2114'),
        children: [
          IconButton(
              key: ValueKey('IconB2utton1114'),
              icon: Icon(
                key: ValueKey('Ico2n1114'),
                Icons.local_offer,
                color: ThemeManager.getInstance().getIconColor(defaultColor: ColorsConfig.create_folder),
                size: 22,
              ),
              onPressed: () {
                this.onClick('onTapCreateTagListener', {});
              }),
          IconButton(
              key: ValueKey('IconB2utton111412'),
              icon: Icon(
                key: ValueKey('Ico2n11114'),
                Icons.create_new_folder,
                color: ThemeManager.getInstance().getIconColor(defaultColor: ColorsConfig.create_folder),
                size: 22,
              ),
              onPressed: () {}),
          SizedBox(
            key: ValueKey('SizedB2ox1112114'),
            width: 10,
          ),
        ],
      )
    ]);
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
