import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/CustomPopupWidget.dart';
import 'package:time_hello/com/timehello/components/SelectDateDialog.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/libs/mongodb/response/MongoDbSaved.dart';
import 'package:time_hello/com/timehello/libs/mongodb/response/MongoDbUpdated.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderModelWithExtraData.dart';
import 'package:time_hello/com/timehello/models/FolderTimeModel.dart';
import 'package:time_hello/com/timehello/page/createFolderPage/CreateFolderPage.dart';
import 'package:time_hello/com/timehello/page/createFolderPage/CreateObjectiveFolderPage.dart';
import 'package:time_hello/com/timehello/page/folderspage/components/FolderSilverList.dart';
import 'package:time_hello/com/timehello/page/statisticPage/pages/SummaryPage.dart';
import 'package:time_hello/com/timehello/util/AnalyticsEventsManager.dart';
import 'package:time_hello/com/timehello/util/CloudSharepreferenceManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../r.dart';
import '../../beans/ResourceDeliveryInfoBean.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/CustomMarquee.dart';
import '../../components/SectionTitleWidget.dart';
import '../../interface/OnCallbackListener.dart';
import '../../interface/OnTapListener.dart';
import '../../models/CourseModel.dart';
import '../../models/EventFn.dart';
import '../../util/ChatGroupManager.dart';
import '../../util/DialogManagement.dart';
import '../../util/JumpNavigator.dart';
import '../AddFilterPage/AddFilterPage.dart';
import '../CreateShareFolderPage/CreateShareFolderPage.dart';
import '../RichEditor/RichEditorPage.dart';
import '../missionPage/MissionPage.dart';
import '../statisticPage/pages/FolderSummaryPage.dart';
import 'components/CustomHeaderGridView.dart';
import 'components/FolderSectionTitleWidget.dart';
import 'components/MenuSilverList.dart';

class FoldersPage extends BaseWidget {
  final OnMapCallback onTapListener;
  final bool useUnifiedStyle;

  const FoldersPage(
      {required this.onTapListener, this.useUnifiedStyle = false});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _FoldersPageWidgetState();
  }
}

class _FoldersPageWidgetState<T> extends BaseWidgetState<FoldersPage> {
  List<FolderModel> _folderModelList = [];
  List<String> listOrderFolderModelObjectId = [];
  List<String> listOrderFolderModelObjectIdOtherFolder = []; // 其他文件夹的排序
  List<String> listOrderFolderModelObjectIdFilterer = []; // 过滤器
  List<String> listOrderFolderModelObjectIdArchived = []; // 归档
  List<String> listOrderFolderModelObjectIdOtherFolderArchived =
      []; // 其他文件夹的排序 归档
  CalendarModel? calendarModel;
  String? curSelectedTitle = null;
  FolderModel? curSelectedFolderModel;
  List<FolderModelWithExtraData> listDatasNormal = []; // 今天 明天 现在做列表
  List<FolderModelWithExtraData> listDatasListing = []; // 清单列表
  List<FolderModelWithExtraData> listDatasListingObjetives = []; // 清单列表-目标
  List<FolderModelWithExtraData> listDatasTags = []; // 标签列表
  List<FolderModelWithExtraData> listDatasFilteres = []; // 过滤器列表
  List<FolderModelWithExtraData> listDatasArchive = []; // 归档文件列表
  bool isAddingFolder = false;

  @override
  void onCreate() {
    super.onCreate();
    curPage = "FoldersPage2";
  }

  @override
  void initState() {
    super.initState();
    this.isAppBarVisible = false;
    this.isNavBackBtnVisible = false;
    this.requestDatas(); // 请求数据
    try {
      this.listOrderFolderModelObjectId = List<String>.from(
          CloudSharepreferenceManagement.getInstance()
              .getArray(ShareprefrenceKeys.folderOrderObjectId, [])); // 获取排序
      this.listOrderFolderModelObjectId =
          Utility.removeDuplicate(this.listOrderFolderModelObjectId); // 去重
    } catch (e) {
      print("object");
    }
    try {
      this.listOrderFolderModelObjectIdOtherFolder = List<String>.from(
          CloudSharepreferenceManagement.getInstance().getArray(
              ShareprefrenceKeys.folderOrderObjectIdForOtherFolders,
              [])); // 获取其他文件夹排序
      this.listOrderFolderModelObjectIdOtherFolder = Utility.removeDuplicate(
          this.listOrderFolderModelObjectIdOtherFolder); // 去重
    } catch (e) {}
    try {
      this.listOrderFolderModelObjectIdArchived = List<String>.from(
          CloudSharepreferenceManagement.getInstance().getArray(
              ShareprefrenceKeys.folderOrderObjectIdArchived, [])); // 获取归档文件排序
      this.listOrderFolderModelObjectIdArchived = Utility.removeDuplicate(
          this.listOrderFolderModelObjectIdArchived); // 去重
    } catch (e) {
      print("object");
    }
    try {
      this.listOrderFolderModelObjectIdOtherFolderArchived = List<String>.from(
          CloudSharepreferenceManagement.getInstance().getArray(
              ShareprefrenceKeys.folderOrderObjectIdForOtherFoldersArchived,
              [])); // 获取其他文件夹归档排序
      this.listOrderFolderModelObjectIdOtherFolderArchived =
          Utility.removeDuplicate(
              this.listOrderFolderModelObjectIdOtherFolderArchived); // 去重
    } catch (e) {}

    if (this.curSelectedTitle == null) {
      this.curSelectedFolderModel =
          this.listDatasNormal?[0].folderModel; // 设置默认选中文件夹
      this.curSelectedTitle =
          this.listDatasNormal?[0].folderModel.title ?? ""; // 设置默认选中文件夹标题
    }
  }

  componentDidMount() {
    //监听广播 设置页面过来后用得上 todo 应该加一个action
    eventBus.on<EventFn>().listen((EventFn event) {
      //这个不需要也行 但是有一个用户反馈创建用户没刷新这里
      if (event.type == Params.ACTION_UPDATE_MISSION_CONTAINER) {
        // Future.delayed(Duration(seconds: 1), () {
        this.requestDatas(shouldRefresh: true); // 请求数据
        FolderModel? folderModel = event.obj['data']; // 获取数据
        if (this.curSelectedFolderModel?.objectId == folderModel?.objectId) {
          this.curSelectedFolderModel?.layoutType = event.obj['layoutType'];
          this.curSelectedFolderModel = event.obj['data'];
          Utility.pushDesktopNavigator(
              Utility.getGlobalContext(),
              'MissionPage',
              {
                'data': this.curSelectedFolderModel,
                'folderStatus': event.obj['layoutType']
              },
              forceUpdate: true); // 跳转任务页
        }
        // });
      }
    });
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onCreateMissionFolderListener': // 创建任务文件夹
        onCreateMissionFolderListener(data);
        break;
      case 'onTapFoldedListener':
        onTapFoldedListener(data);
        break;
      case 'onEnterListener': // 进入文件夹
        onEnterFolderTitleListener(data);
        break;
      case 'onTapShowFolderChartListener': // 显示图表
        onTapShowFolderChartListener(data);
        break;
      case 'onCancelListener': // 取消
        onCancelListener();
        break;
      case 'onTapArchiveListener':
        //归档
        onTapArchiveListener(data);
        break;
      //创建文件夹
      case 'onClickCreateListing': // 创建清单
        onClickCreateListing();
        break;
      case 'onClickCreateFolder': // 创建文件夹
        onClickCreateFolder();
        break;
      case 'onClickObjective': // 创建目标
        onClickObjective();
        break;
      case 'onClickAddGroup': // 添加组
        onClickAddGroup();
        break;
      case 'onClickMissionPage': //跳转任务页
        this.curSelectedFolderModel = data;
        this.curSelectedTitle = data.title;
        if (data.iconType == 5 && Utility.isHandsetBySize() == false) {
          //PC端跳转到日程
          Utility.pushDesktopMainContainerNavigator(
              context, "CalendarContainerPage", {});
        } else if (data.iconType == 5 && Utility.isHandsetBySize() == true) {
          Utility.showCurTab(
              context, CONSTANTS.getCurPage(PageEnum.CalendarPage), {});
        } else {
          //打开mission页
          onClickMissionPage(data, data.iconType);
        }
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
      case 'onTapCreateFilterListener': //创建筛选器
        onTapCreateFilterListener();
        break;
      case 'onTapEditFilterListener': //创建筛选器
        onTapEditFilterListener(data);
        break;
      case 'onTapMore': //PC端点击更多
        onClickPCMore(data);
        break;
    }
  }

  /**
   * 创建筛选器
   * data是文件夹的数据
   */
  void onTapEditFilterListener(FolderModelWithExtraData data) {
    if (Utility.isHandsetBySize()) {
      Utility.pushNavigator(
          context,
          new AddFilterPage(
            folderModel: data.folderModel,
            pageModeEnum: PageModeEnum.edit,
          ),
          callback: (res) {});
    } else {
      Utility.pushDesktopNavigator(context, 'CreateFilterFolderPage',
          {'PageEnum': PageModeEnum.edit, 'folderModel': data.folderModel});
    }
  }

  /**
   * 创建某文件夹的任务
   * data是文件夹的数据
   */
  void onCreateMissionFolderListener(FolderModelWithExtraData data) async {
    //创建任务
    // await Utility.pushDesktopMainContainerNavigator(
    //     context, "CreateMissionPage", {"folderModel": data.folderModel});

    FolderModel folderModel = FolderModel();
    folderModel.tag = 1; //1-circle 2-tag
    folderModel.color = CONSTANTS.getColors()[0].color;

    if (Utility.isHandsetBySize()) {
      Utility.pushNavigator(
          context,
          new CreateFolderPage(
            pageEnum: PageModeEnum.create,
            folderModel: folderModel,
            folderModelForFolder: data.folderModel,
          ),
          callback: (res) {});
    } else {
      Utility.pushDesktopNavigator(context, 'CreateFolderPage', {
        'PageEnum': PageModeEnum.create,
        'folderModel': folderModel,
        'folderModelForFolder': data.folderModel
      });
    }
  }

  /**
   * 归档
   * data是文件夹的数据
   */
  void onTapArchiveListener(FolderModelWithExtraData data) async {
    //1-表示各种图案circle mission;2-表示的是 tag; 3-代表文件夹;null-今天 明天 即将到来
    int? tag = data.folderModel.tag;
    if (tag == 3) {
      //文件夹
      Utility.setFolderModelsListArchiveStatus(folderModel: data.folderModel);
    } else {
      //任务
      if (data.folderModel?.folderStatus == 0) {
        data.folderModel?.folderStatus = 1; //归档
      } else {
        data.folderModel?.folderStatus = 0; //取消归档
      }
      await MongoApisManager.getInstance()
          .update_FolderModelWithFM(folderModel: data.folderModel!);
    }
    //更新listview
    eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
  }

  /**
   * 进入文件夹标题
   * data是文件夹的数据
   */
  void onEnterFolderTitleListener(FolderModel data) async {
    // FolderModel folderModel = FolderModel();
    // folderModel.title = data;
    // folderModel.tag = 3;
    // folderModel.folderStatus = 0; //0 未归档 1 归档 这个要看情况
    if (TextUtil.isEmpty(data.objectId)) {
      MongoDbSaved? res = await MongoApisManager.getInstance()
          .insertFolderModel(folderModel: data);
      if (res?.objectId != null) {
        this.isAddingFolder = false;
        updateUI();
      }
    } else {
      MongoDbUpdated? res = await MongoApisManager.getInstance()
          .update_FolderModelWithFM(folderModel: data);
      if (res?.success == true) {
        this.isAddingFolder = false;
        updateUI();
      }
    }
  }

  /**
   * 显示图表
   * data是文件夹的数据
   */
  void onTapShowFolderChartListener(data) {
    Utility.openPagePCAndMobile(context,
        child: FolderSummaryPage(
          folderModelWithExtraData: data,
          shouldShowNav: Utility.isHandsetBySize(),
        ));
  }

  /**
   * 取消
   */
  void onCancelListener() {
    this.isAddingFolder = false;
    updateUI();
  }

  /**
   * PC端点击更多
   * data是文件夹的数据
   */
  void onClickPCMore(data) {
    SelectDateDialogUtil.show(context,
        title: data.folderModel.title,
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

  /**
   * 创建筛选器
   */
  void onTapCreateFilterListener() {
    FolderModel folderModel = FolderModel();
    folderModel.tag = 2; //1-normal 2-tag 3-circle
    folderModel.color = CONSTANTS.getColors()[0].color;
    AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
      "sceneType": "folderpage",
      "eventType": "folderpage_create_tag",
      "description": "创建标签",
    });
    if (Utility.isHandsetBySize()) {
      Utility.pushNavigator(
          context,
          new AddFilterPage(
            folderModel: folderModel,
            pageModeEnum: PageModeEnum.create,
          ),
          callback: (res) {});
    } else {
      Utility.pushDesktopNavigator(context, 'CreateFilterFolderPage',
          {'PageEnum': PageModeEnum.create, 'folderModel': folderModel});
    }
  }

  void onTapCreateTagListener() {
    FolderModel folderModel = FolderModel();
    folderModel.tag = 2; //1-normal 2-tag 3-circle
    folderModel.color = CONSTANTS.getColors()[0].color;
    AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
      "sceneType": "folderpage",
      "eventType": "folderpage_create_tag",
      "description": "创建标签",
    });
    if (Utility.isHandsetBySize()) {
      Utility.pushNavigator(
          context,
          new CreateFolderPage(
            pageEnum: PageModeEnum.create,
            folderModel: folderModel,
          ),
          callback: (res) {});
    } else {
      Utility.pushDesktopNavigator(context, 'CreateFolderPage',
          {'PageEnum': PageModeEnum.create, 'folderModel': folderModel});
    }
  }

  /**
   * 编辑item
   * data是文件夹的数据
   */
  void onClickEditItem(FolderModelWithExtraData data) {
    if (data.folderModel.tag == 4) {
      onTapEditFilterListener(data);
      return;
    }
    if (data.folderModel.tag == 5) {
      if (Utility.isHandsetBySize()) {
        Utility.pushNavigator(
            context,
            new CreateObjectiveFolderPage(
              pageEnum: PageModeEnum.edit,
              folderModel: data.folderModel,
            ),
            callback: (res) {});
      } else {
        Utility.pushDesktopNavigator(context, 'CreateObjectiveFolderPage',
            {'PageEnum': PageModeEnum.edit, 'folderModel': data.folderModel});
      }
      return;
    }

    if (Utility.isHandsetBySize()) {
      Utility.pushNavigator(
          context,
          new CreateFolderPage(
            pageEnum: PageModeEnum.edit,
            folderModel: data.folderModel,
          ),
          callback: (res) {});
    } else {
      Utility.pushDesktopNavigator(context, 'CreateFolderPage',
          {'PageEnum': PageModeEnum.edit, 'folderModel': data.folderModel});
    }
  }

  /**
   * 删除item
   * data是文件夹的数据
   */
  Future onClickDeleteItem(FolderModelWithExtraData data) async {
    DialogManagement.getInstance().showCustomIconTitleAndDescDialog(
        Utility.getGlobalContext(),
        checkBoxDesc: data.folderModel.tag == 3
            ? getI18NKey()
                .confirm_delete_mission_models(data.folderModel.title ?? "")
            : null,
        btnConfirm: getI18NKey().confirm,
        btnCancel: getI18NKey().cancel,
        iconWidget: Utility.getSVGPicture(R.assetsImgIcDeleteRemind, size: 40),
        title: getI18NKey().confirm_delete_folder(data.folderModel.title ?? ""),
        okCallback: (bool isCheck) async {
      FolderModel folderModel = data.folderModel;
      if (folderModel.tag == 3) {
        deleteFolderModelForFolder(data, isCheck: isCheck);
      } else {
        await deleteFolderModel(data);
      }
    });

    // OkCancelResult result = await showOkCancelAlertDialog(
    //     context: context,
    //     title: getI18NKey(context).delete,
    //     message: getI18NKey(context).confirmToDelete,
    //     okLabel: getI18NKey(context).confirm,
    //     cancelLabel: getI18NKey(context).cancel,
    //     onWillPop: () async {
    //       //点击对话框外围黑色区域才会走这里
    //       return true;
    //     });
    // if (result == OkCancelResult.ok) {
    //   if (Utility.isMyFolderModel(folderModel: data.folderModel)) {
    //     await Future.wait([
    //       MongoApisManager.getInstance()
    //           .delete_FolderModel(currentObjectId: data.folderModel.objectId),
    //       MongoApisManager.getInstance().batchdelete_GroupModelByFolderId(
    //           folder_id: data.folderModel.objectId),
    //       MongoApisManager.getInstance()
    //           .batchdelete_MissionModel(folder_id: data.folderModel.objectId),
    //       MongoApisManager.getInstance()
    //           .delete_CourseModel(data.folderModel.courseModelId)
    //     ]);
    //   } else {
    //     List<Future> updateMongoList = [];
    //     List listOtherUids = data.folderModel.otherUids ?? [];
    //     listOtherUids.remove(LoginManager.getInstance().userBean.uid);
    //     Utility.deleteUserInfoMapByUid(data.folderModel.otherUserInfo,
    //         LoginManager.getInstance().userBean.uid);
    //     updateMongoList.add(MongoApisManager.getInstance()
    //         .update_FolderModelWithFM(folderModel: data.folderModel));
    //
    //     CourseModel? courseModel = await MongoApisManager.getInstance()
    //         .requestCourseModelByFolderId(
    //             folder_id: data.folderModel.objectId ?? "");
    //     if (courseModel != null) {
    //       courseModel.otherUids
    //           ?.remove(LoginManager.getInstance().userBean.uid);
    //       Utility.deleteUserInfoMapByUid(courseModel.otherUserInfo ?? [],
    //           LoginManager.getInstance().userBean.uid);
    //       updateMongoList.add(MongoApisManager.getInstance().update_CourseModel(
    //           courseModel?.objectId ?? "",
    //           courseModel: courseModel));
    //     }
    //     await Future.wait(updateMongoList);
    //   }
    //   this.requestDatas(shouldRefresh: true);
    // }
  }

  Future<void> deleteFolderModelForFolder(FolderModelWithExtraData data,
      {required bool isCheck}) async {
    if (Utility.isMyFolderModel(folderModel: data.folderModel)) {
      //只删除当前文件夹
      if (isCheck == false) {
        MongoApisManager.getInstance()
            .delete_FolderModel(currentObjectId: data.folderModel.objectId);
      } else {
        //删除当前文件夹及其下的所有文件夹
        Utility.deleteFolderModelsList(
          folderModel: data.folderModel,
        );
      }
    } else {
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
        "sceneType": "GroupChatPage",
        "eventType": "GroupChatPage_leave_group",
        "description": "退群",
      });
      ChatGroupManager.exitGroup(folderModel: data.folderModel);
      Utility.popupDesktopRightNavigator(context);

      // List<Future> updateMongoList = [];
      // List listOtherUids = data.folderModel.otherUids ?? [];
      // listOtherUids.remove(LoginManager.getInstance().userBean.uid);
      // Utility.deleteUserInfoMapByUid(data.folderModel.otherUserInfo,
      //     LoginManager.getInstance().userBean.uid);
      // updateMongoList.add(MongoApisManager.getInstance()
      //     .update_FolderModelWithFM(folderModel: data.folderModel));
      //
      // CourseModel? courseModel = await MongoApisManager.getInstance()
      //     .requestCourseModelByFolderId(
      //         folder_id: data.folderModel.objectId ?? "");
      // if (courseModel != null) {
      //   courseModel.otherUids?.remove(LoginManager.getInstance().userBean.uid);
      //   Utility.deleteUserInfoMapByUid(courseModel.otherUserInfo ?? [],
      //       LoginManager.getInstance().userBean.uid);
      //   updateMongoList.add(MongoApisManager.getInstance().update_CourseModel(
      //       courseModel?.objectId ?? "",
      //       courseModel: courseModel));
      // }
      // await Future.wait(updateMongoList);
    }
    this.requestDatas(shouldRefresh: true);
  }

  /**
   * 删除文件夹
   * data是文件夹的数据
   */
  Future<void> deleteFolderModel(FolderModelWithExtraData data) async {
    if (Utility.isMyFolderModel(folderModel: data.folderModel)) {
      await Future.wait([
        MongoApisManager.getInstance()
            .delete_FolderModel(currentObjectId: data.folderModel.objectId),
        MongoApisManager.getInstance().batchdelete_GroupModelByFolderId(
            folder_id: data.folderModel.objectId),
        MongoApisManager.getInstance()
            .batchdelete_MissionModel(folder_id: data.folderModel.objectId),
        MongoApisManager.getInstance()
            .delete_CourseModel(data.folderModel.courseModelId)
      ]);
    } else {
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
        "sceneType": "GroupChatPage",
        "eventType": "GroupChatPage_leave_group",
        "description": "退群",
      });
      ChatGroupManager.exitGroup(folderModel: data.folderModel);
      Utility.popupDesktopRightNavigator(context);

      // List<Future> updateMongoList = [];
      // List listOtherUids = data.folderModel.otherUids ?? [];
      // listOtherUids.remove(LoginManager.getInstance().userBean.uid);
      // Utility.deleteUserInfoMapByUid(data.folderModel.otherUserInfo,
      //     LoginManager.getInstance().userBean.uid);
      // updateMongoList.add(MongoApisManager.getInstance()
      //     .update_FolderModelWithFM(folderModel: data.folderModel));
      //
      // CourseModel? courseModel = await MongoApisManager.getInstance()
      //     .requestCourseModelByFolderId(
      //         folder_id: data.folderModel.objectId ?? "");
      // if (courseModel != null) {
      //   courseModel.otherUids?.remove(LoginManager.getInstance().userBean.uid);
      //   Utility.deleteUserInfoMapByUid(courseModel.otherUserInfo ?? [],
      //       LoginManager.getInstance().userBean.uid);
      //   updateMongoList.add(MongoApisManager.getInstance().update_CourseModel(
      //       courseModel?.objectId ?? "",
      //       courseModel: courseModel));
      // }
      // await Future.wait(updateMongoList);
    }
    this.requestDatas(shouldRefresh: true);
  }

  /**
   * 根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成
   * data是文件夹的数据
   */
  void onClickMissionPage(FolderModel data, folderStatus) {
    // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单 8 其他 9 现在做 Do it now 12 待定任务 13 碎片清单
    switch (data.iconType) {
      case 1: // 今天
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_today",
          "description": "今天",
        });
        break;
      case 2: // 明天
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_tomorrow",
          "description": "明天",
        });
        break;
      case 3: // 本周
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_recent_days",
          "description": "最近几天",
        });
        break;
      case 4: // 所有未完成任务
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_all_pending_tasks",
          "description": "所有未完成任务",
        });
        break;
      case 5: // 日程
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_schedule",
          "description": "日程",
        });
        break;
      case 6: // 已完成
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_completed",
          "description": "已完成",
        });
        break;
      case 7: //  创建清单
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_create_listing",
          "description": "创建清单",
        });
        break;
      case 8: // 其他
        break;
      case 9: // 现在做 Do it now
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_current_tasks",
          "description": "现在做",
        });
        break;
      case 10: //所有任务
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_all_tasks",
          "description": "所有任务",
        });
        break;
      case 12: // 待定任务
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_proxy_list",
          "description": "代办清单",
        });
        break;
      case 13: // 碎片清单
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_fragment_list",
          "description": "碎片清单",
        });
        break;
    }
    this.curSelectedFolderModel = data;
    if (Utility.isHandsetBySize()) {
      Utility.pushCurFolderModel(context,
          folderModel: data, folderStatus: folderStatus);
      if (this.widget.onTapListener != null) {
        this.widget.onTapListener!(
            {"folderModel": data, "folderStatus": folderStatus});
      }
    } else {
      if (data.tag == 1 || data.tag == 5) {
        Utility.openRightSideDesktopNavigator(context, 'GroupChatPage', {});
      } else {
        Utility.popupDesktopRightNavigator(context);
      }
      Utility.pushCurFolderModel(context,
          folderModel: data, folderStatus: folderStatus);
      Utility.pushDesktopNavigator(
          context, 'MissionPage', {'data': data, 'folderStatus': folderStatus});
    }
  }

  /**
   * 添加组
   */
  onClickAddGroup() {
    DialogManagement.getInstance().showSearchFriendGroupWidget();
  }

  /**
   * 创建文件夹
   */
  void onClickCreateFolder() {
    this.isAddingFolder = true;
    // FolderModel folderModel = FolderModel();
    // folderModel.tag = 3; ////1-表示各种图案circle mission;2-表示的是 tag; 3-代表文件夹;null-今天 明天 即将到来
    // folderModel.color = CONSTANTS.getColors()[0].color;
    // FolderModelWithExtraData folderModelWithExtraData = FolderModelWithExtraData(folderModel: folderModel, folderTimeModel: FolderTimeModel());
    // folderModelWithExtraData.isEditingTitle = true;
    // // 添加到this.listDatasListing第一位
    // this.listDatasListing.length == 0 ? this.listDatasListing.add(folderModelWithExtraData) : this.listDatasListing.insert(0, folderModelWithExtraData);
    updateUI();
// this.listDatasNormal.add(folderModel);
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

  /**
   * 创建目标
   */
  void onClickObjective() {
    FolderModel folderModel = FolderModel();
    folderModel.tag = 5; //1-circle 2-tag
    folderModel.color = CONSTANTS.getColors()[0].color;
    if (folderModel.tag == 5) {
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
        "sceneType": "folderpage",
        "eventType": "folderpage_create_objective",
        "description": "创建目标",
      });
    }
    if (Utility.isHandsetBySize()) {
      Utility.pushNavigator(
          context,
          new CreateObjectiveFolderPage(
            pageEnum: PageModeEnum.create,
            folderModel: folderModel,
          ),
          callback: (res) {});
    } else {
      Utility.pushDesktopNavigator(context, 'CreateObjectiveFolderPage',
          {'PageEnum': PageModeEnum.create, 'folderModel': folderModel});
    }
  }

  /**
   * 创建清单
   */
  void onClickCreateListing() {
    FolderModel folderModel = FolderModel();
    folderModel.tag = 1; //1-circle 2-tag
    folderModel.color = CONSTANTS.getColors()[0].color;
    if (folderModel.tag == 1) {
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
        "sceneType": "folderpage",
        "eventType": "folderpage_create_listing",
        "description": "创建清单",
      });
    }
    if (Utility.isHandsetBySize()) {
      Utility.pushNavigator(
          context,
          new CreateFolderPage(
            pageEnum: PageModeEnum.create,
            folderModel: folderModel,
          ),
          callback: (res) {});
    } else {
      Utility.pushDesktopNavigator(context, 'CreateFolderPage',
          {'PageEnum': PageModeEnum.create, 'folderModel': folderModel});
    }
  }

  /**
   * 构建
   */
  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    return Selector<GlobalStateEnv, List<FolderModel>>(
        selector: (_, globalStateEnv) => globalStateEnv.listFolderModels,
        builder: (_, listFolderModels, __) {
          _folderModelList = listFolderModels;
          CONSTANTS.folderModelList = _folderModelList;
          this.requestDatas();
          return Selector<GlobalStateEnv, CalendarModel>(
              selector: (_, globalStateEnv) => globalStateEnv.calendarModel,
              builder: (_, calendarModel, __) {
                this.calendarModel = calendarModel;

                return Scaffold(
                    key: ValueKey('Scaffold11114'),
                    backgroundColor: widget.useUnifiedStyle
                        ? const Color(0xFFF4E4D7)
                        : null,
                    body: widget.useUnifiedStyle
                        ? _buildUnifiedSidebarShell(context)
                        : _buildDefaultSidebarShell(context));
              });
        });
  }

  Widget _buildDefaultSidebarShell(BuildContext context) {
    return Container(
        key: ValueKey('Container111114'),
        color: ThemeManager.getInstance().getLeftMenuColor(
            defaultColor:
                ThemeManager.getInstance().getLightDefaultThemeColor()),
        child: _buildSidebarColumn(context, showLegacyHeader: true));
  }

  Widget _buildUnifiedSidebarShell(BuildContext context) {
    return Container(
      key: const ValueKey('new_folder_page_shell'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF7D6BE),
            Color(0xFFF5E8DA),
            Color(0xFFDCEADD),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -70,
            left: -50,
            child: _buildAccentBlob(
              const Color(0xFFFFD9BB),
              180,
            ),
          ),
          Positioned(
            top: 220,
            left: -65,
            child: _buildAccentBlob(
              const Color(0xFFCDE4D6),
              160,
            ),
          ),
          Positioned(
            right: -55,
            top: 70,
            child: _buildAccentBlob(
              const Color(0xFFF6E6D3),
              140,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: ThemeManager.getInstance().isDark()
                    ? ThemeManager.getInstance().getLeftMenuColor()
                    : ColorsConfig.missionSidebarShellBackground,
                border: Border.all(
                  color: ThemeManager.getInstance().isDark()
                      ? ThemeManager.getInstance().getLineColor()
                      : const Color(0xFFF0DBC8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: _buildSidebarColumn(context, showLegacyHeader: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccentBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }

  Widget _buildSidebarColumn(BuildContext context,
      {required bool showLegacyHeader}) {
    return Column(
      children: [
        if (showLegacyHeader) ...[
          Utility.isHandsetBySize()
              ? SizedBox.shrink()
              : CustomHeaderGridView(
                  key: ValueKey('custom_header_grid_view_1'),
                  onTap: (ResourceDeliveryInfoBean bean) {
                    JumpNavigator.onClickCustomHeaderGridView(
                        context, bean?.deliveryName ?? "");
                  },
                ),
          CustomMarquee(
            key: ValueKey('custom_marquee_1'),
            bean: MarqueInfo.marqueFolderpage,
            paddingTop: 0,
          ),
        ] else ...[
          _buildUnifiedHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 18, 6),
            child: Opacity(
              opacity: 0.78,
              child: CustomMarquee(
                key: const ValueKey('custom_marquee_unified'),
                bean: MarqueInfo.marqueFolderpage,
                paddingTop: 0,
              ),
            ),
          ),
        ],
        Expanded(
            key: ValueKey('expanded_1'),
            child: Padding(
              padding: widget.useUnifiedStyle
                  ? const EdgeInsets.only(top: 6)
                  : EdgeInsets.zero,
              child: getMenuList(),
            )),
        screenType == ScreenType.Handset
            ? SizedBox.shrink()
            : Padding(
                padding: widget.useUnifiedStyle
                    ? const EdgeInsets.fromLTRB(14, 8, 14, 16)
                    : EdgeInsets.zero,
                child: getItem(context),
              )
      ],
    );
  }

  Widget _buildUnifiedHeader() {
    final bool isDark = ThemeManager.getInstance().isDark();
    final Color titleColor = ThemeManager.getInstance().getTextColor(
        defaultColor: ColorsConfig.missionSidebarTextPrimary,
        defaultDarkColor: Colors.white);
    final Color subtitleColor = ThemeManager.getInstance().getTextColor(
        defaultColor: ColorsConfig.missionSidebarTextSecondary,
        defaultDarkColor: Colors.white70);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 18, 8),
      child: Row(
        children: [
          Icon(
            Icons.menu_rounded,
            size: 20,
            color: titleColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time Bureau',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Unified workspace',
                  style: TextStyle(
                    fontSize: 11,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : ColorsConfig.missionSidebarHeaderChipBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 14,
                  color: titleColor,
                ),
                const SizedBox(width: 6),
                Text(
                  'Focus',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /**
   * 获取菜单列表
   */
  CustomScrollView getMenuList() {
    //
    return CustomScrollView(
      key: ValueKey('custom_scroll_view_1'),
      slivers: [
        getMenuSliverList(
            list: this.listDatasNormal,
            key: ValueKey('menu_silver_list_1'),
            folderPageViewEnum: FolderPageViewEnum.normal),
        FolderSectionTitleWidget(
          title: getI18NKey().listing,
          useUnifiedStyle: widget.useUnifiedStyle,
          trailingWidget: CustomPopupWidget(
              onSelected: (res) {
                switch (res.code) {
                  case 'listing':
                    // this.onClick?.call('listing');
                    this.onClick('onClickCreateListing', {});
                    break;
                  case 'folder':
                    this.onClick('onClickCreateFolder', {});
                    // this.onClick?.call('folder');
                    break;
                  case 'group':
                    this.onClick("onClickAddGroup", {});
                    break;
                  case 'objective':
                    this.onClick('onClickObjective', {});
                    break;
                }
              },
              list: CONSTANTS.getFolderButtonList(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: ThemeManager.getInstance().isDark()
                      ? Colors.white.withValues(alpha: 0.08)
                      : ColorsConfig.missionSidebarHeaderChipBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  getI18NKey().create,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ThemeManager.getInstance().getTextColor(
                        defaultColor: ColorsConfig.missionSidebarTextPrimary,
                        defaultDarkColor: Colors.white),
                  ),
                ),
              )),
        ),
        getMenuSliverListFolders(
            list: Utility.filterFolderModelWithExtraData(this.listDatasListing,
                isAddingFolderModel: this.isAddingFolder,
                listOrderFolderModelObjectId: this.listOrderFolderModelObjectId,
                listOrderFolderModelObjectIdForOtherFolder:
                    this.listOrderFolderModelObjectIdOtherFolder),
            key: ValueKey('menu_silver_list_2'),
            folderPageViewEnum: FolderPageViewEnum.listing_unarchive),

        FolderSectionTitleWidget(
            title: getI18NKey().filterer,
            useUnifiedStyle: widget.useUnifiedStyle,
            onClick: () {
              if (LoginManager.getInstance().isVIP(
                  shouldShowDialog: true,
                  paymentPromotionAdsModeEnum:
                      PaymentPromotionAdsModeEnum.Filterer)) {
                this.onClick('onTapCreateFilterListener', {});
              }
            }),
        getMenuSliverList(
            list: this.listDatasFilteres,
            key: ValueKey('menu_silver_list_3we'),
            folderPageViewEnum: FolderPageViewEnum.filterer),
        FolderSectionTitleWidget(
            title: getI18NKey().tag,
            useUnifiedStyle: widget.useUnifiedStyle,
            onClick: () {
              this.onClick('onTapCreateTagListener', {});
            }),

        getMenuSliverList(
            list: this.listDatasTags,
            key: ValueKey('menu_silver_list_3'),
            folderPageViewEnum: FolderPageViewEnum.tag),
        FolderSectionTitleWidget(
          title: getI18NKey().archive,
          useUnifiedStyle: widget.useUnifiedStyle,
        ),
        getMenuSliverListFolders(
            list: Utility.filterFolderModelWithExtraData(this.listDatasArchive,
                isAddingFolderModel: false,
                listOrderFolderModelObjectId:
                    this.listOrderFolderModelObjectIdArchived,
                listOrderFolderModelObjectIdForOtherFolder:
                    this.listOrderFolderModelObjectIdOtherFolderArchived),
            key: ValueKey('menu_silver_list_4'),
            folderPageViewEnum: FolderPageViewEnum.listing_archive),
        // getMenuSliverList(
        //     list: this.listDatasArchive,
        //     key: ValueKey('menu_silver_list_53'),
        //     folderPageViewEnum: FolderPageViewEnum.listing_archive),
      ],
    );
  }

  /**
   * 获取菜单列表
   */
  MenuSilverList getMenuSliverList(
      {required List<FolderModelWithExtraData> list,
      required ValueKey key,
      required FolderPageViewEnum folderPageViewEnum}) {
    return MenuSilverList(
      useUnifiedStyle: widget.useUnifiedStyle,
      folderPageViewEnum: folderPageViewEnum,
      key: key,
      datas: list,
      calendarModel: calendarModel ?? CalendarModel(),
      onTapArchiveListener: (data) {
        this.onClick('onTapArchiveListener', data);
      },
      onTapShowFolderChartListener: (data) {
        this.onClick('onTapShowFolderChartListener', data);
      },
      onTapListener: (data) {
        // 如果pc右侧有MissionDetailPage则隐藏
        if (!Utility.isHandsetBySize()) {
          Utility.popupDesktopRightNavigator(context);
        }
        if (data.type == 3) {
          //创建页面
          this.onClick('onClickCreateListing', data);
        } else {
          this.onClick('onClickMissionPage', data);
        }
      },
      onTapShareListener: (data) async {
        // bool isCourseModelExist = await MongoApisManager.getInstance()
        //     .isCourseModelExist(fid: data.folderModel.objectId);
        // if (isCourseModelExist == true) {
        //   Utility.showToast(
        //       context: context, msg: getI18NKey().already_exist);
        //   return;
        // }
        CourseModel? courseModel = null;
        if (!TextUtil.isEmpty(data.folderModel.objectId)) {
          courseModel = await MongoApisManager.getInstance()
              .getCourseModelByFid(data.folderModel.objectId);
        }
        Utility.openPagePCAndMobile(context,
            child: CreateShareFolderPage(
                courseModel: courseModel, folderModel: data.folderModel));
      },
      onTapDeleteListener: (data) async {
        // 如果pc右侧有MissionDetailPage则隐藏
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
      curSelectedTitle: this.curSelectedTitle ?? "",
      onUpdateTitleListener: (title) {
        this.curSelectedTitle = title;
      },
    );
  }

  /**
   * 折叠
   * data是文件夹的数据
   */
  void onTapFoldedListener(FolderModelWithExtraData data) async {
    await MongoApisManager.getInstance()
        .update_FolderModelWithFM(folderModel: data.folderModel!);
    //更新listview
    eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
  }

  /**
   * 获取菜单列表
   */
  FolderSilverList getMenuSliverListFolders(
      {required List<FolderModelWithExtraData> list,
      required ValueKey key,
      required FolderPageViewEnum folderPageViewEnum}) {
    return FolderSilverList(
      useUnifiedStyle: widget.useUnifiedStyle,
      folderPageViewEnum: folderPageViewEnum,
      key: key,
      datas: list,
      calendarModel: calendarModel ?? CalendarModel(),
      onCancelListener: () {
        this.onClick('onCancelListener', {});
      },
      onTapArchiveListener: (data) {
        this.onClick('onTapArchiveListener', data);
      },
      onTapShowFolderChartListener: (data) {
        this.onClick('onTapShowFolderChartListener', data);
      },
      onTapListener: (data) {
        // 如果pc右侧有MissionDetailPage则隐藏
        if (!Utility.isHandsetBySize()) {
          Utility.popupDesktopRightNavigator(context);
        }
        if (data.type == 3) {
          //创建页面
          this.onClick('onClickCreateListing', data);
        } else {
          this.onClick('onClickMissionPage', data);
        }
      },
      onTapShareListener: (data) async {
        CourseModel? courseModel = null;
        if (!TextUtil.isEmpty(data.folderModel.objectId)) {
          courseModel = await MongoApisManager.getInstance()
              .getCourseModelByFid(data.folderModel.objectId);
        }
        Utility.openPagePCAndMobile(context,
            child: CreateShareFolderPage(
                courseModel: courseModel, folderModel: data.folderModel));
      },
      onTapDeleteListener: (data) async {
        // 如果pc右侧有MissionDetailPage则隐藏
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
      curSelectedTitle: this.curSelectedTitle ?? "",
      onUpdateTitleListener: (title) {
        this.curSelectedTitle = title;
      },
      onEnterListener: (FolderModel folderModel) {
        this.onClick('onEnterListener', folderModel);
      },
      onReorderEnd: (List<String>? listObjectIds,
          List<String>? otherListObjectIds,
          List<FolderModelWithExtraData>? listFolderModelWithExtraData) async {
        if (listObjectIds == null &&
            listFolderModelWithExtraData == null &&
            otherListObjectIds == null) {
          return;
        }
        if (folderPageViewEnum == FolderPageViewEnum.listing_unarchive) {
          await onClickRorderEndForUnarchived(
              listObjectIds, otherListObjectIds, listFolderModelWithExtraData);
        } else {
          await onClickRorderEndForArchived(
              listObjectIds, otherListObjectIds, listFolderModelWithExtraData);
        }
      },
      onCreateMissionFolderListener: (item) {
        this.onClick('onCreateMissionFolderListener', item);
      },
      onTapFoldedListener: (item) {
        updateUI();
        this.onClick('onTapFoldedListener', item);
      },
    );
  }

  /**
   * unarchived滑动结束完
   */
  Future<void> onClickRorderEndForUnarchived(
      List<String>? listObjectIds,
      List<String>? otherListObjectIds,
      List<FolderModelWithExtraData>? listFolderModelWithExtraData) async {
    if (listObjectIds != null && listObjectIds.length > 0) {
      listObjectIds = Utility.removeDuplicate(listObjectIds);
      await CloudSharepreferenceManagement.getInstance()
          .setArray(ShareprefrenceKeys.folderOrderObjectId, listObjectIds!);
      this.listOrderFolderModelObjectId = listObjectIds;
    }

    if (otherListObjectIds != null && otherListObjectIds.length > 0) {
      otherListObjectIds = Utility.removeDuplicate(otherListObjectIds);
      await CloudSharepreferenceManagement.getInstance().setArray(
          ShareprefrenceKeys.folderOrderObjectIdForOtherFolders,
          otherListObjectIds!);
      this.listOrderFolderModelObjectIdOtherFolder = otherListObjectIds;
    }

    if (listFolderModelWithExtraData != null &&
        listFolderModelWithExtraData.length > 0) {
      List<FolderModel> list = [];
      listFolderModelWithExtraData.forEach((element) {
        list.add(element.folderModel);
      });

      await MongoApisManager.getInstance()
          .batchUpdate_folderModelWithParams(listFolderModel: list);
    }
    updateUI();
  }

  /**
   * archived滑动结束完
   */
  Future<void> onClickRorderEndForArchived(
      List<String>? listObjectIds,
      List<String>? otherListObjectIds,
      List<FolderModelWithExtraData>? listFolderModelWithExtraData) async {
    if (listObjectIds != null && listObjectIds.length > 0) {
      listObjectIds = Utility.removeDuplicate(listObjectIds);
      await CloudSharepreferenceManagement.getInstance().setArray(
          ShareprefrenceKeys.folderOrderObjectIdArchived, listObjectIds!);
      this.listOrderFolderModelObjectIdArchived = listObjectIds;
    }

    if (otherListObjectIds != null && otherListObjectIds.length > 0) {
      otherListObjectIds = Utility.removeDuplicate(otherListObjectIds);
      await CloudSharepreferenceManagement.getInstance().setArray(
          ShareprefrenceKeys.folderOrderObjectIdForOtherFoldersArchived,
          otherListObjectIds!);
      this.listOrderFolderModelObjectIdOtherFolderArchived = otherListObjectIds;
    }

    if (listFolderModelWithExtraData != null &&
        listFolderModelWithExtraData.length > 0) {
      List<FolderModel> list = [];
      listFolderModelWithExtraData.forEach((element) {
        list.add(element.folderModel);
      });

      await MongoApisManager.getInstance()
          .batchUpdate_folderModelWithParams(listFolderModel: list);
    }
    updateUI();
  }

  /**
   * 请求数据
   */
  requestDatas({bool shouldRefresh = false}) {
    calendarModel = context.read<GlobalStateEnv>().calendarModel;
    _folderModelList = context.read<GlobalStateEnv>().listFolderModels;
    // List<FolderModel> datas = await MongoApisManager.getInstance()
    //     .queryWhereEqual_folderModel(shouldRefresh: shouldRefresh);
    listDatasNormal = CONSTANTS.getMenuList(this._folderModelList,
        folderPageViewEnum: FolderPageViewEnum.normal,
        isMobile: screenType == ScreenType.Handset,
        calendarModel: calendarModel);
    listDatasListing = CONSTANTS.getMenuList(this._folderModelList,
        folderPageViewEnum: FolderPageViewEnum.listing_unarchive,
        isMobile: screenType == ScreenType.Handset,
        calendarModel: calendarModel);
    listDatasListingObjetives = CONSTANTS.getMenuList(this._folderModelList,
        folderPageViewEnum: FolderPageViewEnum.objective,
        isMobile: screenType == ScreenType.Handset,
        calendarModel: calendarModel);
    // 把目标清单放在清单的前面
    listDatasListing.addAll(listDatasListingObjetives);

    listDatasTags = CONSTANTS.getMenuList(this._folderModelList,
        folderPageViewEnum: FolderPageViewEnum.tag,
        isMobile: screenType == ScreenType.Handset,
        calendarModel: calendarModel);
    listDatasFilteres = CONSTANTS.getMenuList(this._folderModelList,
        folderPageViewEnum: FolderPageViewEnum.filterer,
        isMobile: screenType == ScreenType.Handset,
        calendarModel: calendarModel);

    listDatasArchive = CONSTANTS.getMenuList(this._folderModelList,
        folderPageViewEnum: FolderPageViewEnum.listing_archive,
        isMobile: screenType == ScreenType.Handset,
        calendarModel: calendarModel);
    if (shouldRefresh == true) {
      updateUI();
    }
  }

  /**
   * 获取item
   */
  InkWell getItem(BuildContext context) {
    FolderModelWithExtraData _folderModelWithExtraData =
        CONSTANTS.getCreateFolderModel();
    List<Widget> children = <Widget>[
      Container(
          key: ValueKey('Container4'),
          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Icon(
              key: ValueKey('Icons14'),
              Icons.add,
              size: 25,
              color: ThemeManager.getInstance().getIconColor(
                  defaultColor:
                      ThemeManager.getInstance().getDefautThemeColor()))),
      SizedBox(
        key: ValueKey('SizedBox14'),
        width: 10,
      ),
      Expanded(
          key: ValueKey('Expanded14'),
          child: Text(_folderModelWithExtraData.folderModel.title ?? "",
              key: ValueKey('Text14'),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: ThemeManager.getInstance().getTextColor(
                      defaultColor:
                          _folderModelWithExtraData.folderModel.iconType == 7
                              ? ThemeManager.getInstance().getDefautThemeColor()
                              : ColorsConfig.gray_40))),
          flex: 3),
    ];
    children.addAll([
      Wrap(
        key: ValueKey('Wrap114'),
        children: [
          // IconButton(
          //
          //     key: ValueKey('IconButton111412'),
          //     icon: Icon(
          //       key: ValueKey('Icon11114'),
          //       Icons.create_new_folder,
          //       color: ColorsConfig.create_folder,
          //       size: 25,
          //     ),
          //     onPressed: () {
          //       this.onClick('onTapCreateTagListener', {});
          //     }),
          IconButton(
              key: ValueKey('IconButton1114'),
              icon: Icon(
                key: ValueKey('Icon1114'),
                Icons.local_offer,
                color: ThemeManager.getInstance().getIconColor(
                    defaultColor:
                        ThemeManager.getInstance().getDefautThemeColor()),
                size: 22,
              ),
              onPressed: () {
                this.onClick('onTapCreateTagListener', {});
              }),

          SizedBox(
            key: ValueKey('SizedBox1112114'),
            width: 10,
          ),
        ],
      )
    ]);
    return InkWell(
        key: ValueKey('InkWell_1'),
        onTap: () {
          // listen 设为false，不建立依赖关系
          // context.read<Counter2>().increment();
          // Provider.of<Counter2>(context, listen: false).increment();
          this.onClick('onClickCreateListing', {});
          // context.read<Counter>().increment();
        },
        child: Container(
          key: ValueKey('Container2'),
          height: 50,
          alignment: Alignment.centerLeft,
          child: Row(
            key: ValueKey('Row2'),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ));
  }

  void reset() {
    this.listDatasNormal = [];
    this.listDatasListing = [];
    this.listDatasTags = [];
    this.listDatasArchive = [];
    this.listOrderFolderModelObjectId = [];
    this.listOrderFolderModelObjectIdOtherFolder = [];
    this.listOrderFolderModelObjectIdArchived = [];
    this.listOrderFolderModelObjectIdOtherFolderArchived = [];
    this.calendarModel = null;
    this._folderModelList = [];
  }
}
