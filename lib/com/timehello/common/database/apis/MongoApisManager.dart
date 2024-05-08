import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/libs/mongodb/MongoDb.dart';
import 'package:time_hello/com/timehello/models/ChatGptFolderModel.dart';
import 'package:time_hello/com/timehello/models/ChatGptMessageModel.dart';
import 'package:time_hello/com/timehello/models/CommentModel.dart';
import 'package:time_hello/com/timehello/models/EndTimeMissionModel.dart';
import 'package:time_hello/com/timehello/models/EventCollectionModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/models/SharePreferenceModel.dart';
import 'package:time_hello/com/timehello/models/StatsModel.dart';
import 'package:time_hello/com/timehello/models/User.dart';
import 'package:time_hello/com/timehello/models/UserInfoModel.dart';
import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';
import 'package:time_hello/com/timehello/util/CounterManagement.dart';
import 'package:time_hello/com/timehello/util/CryptoManager.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/NotificationManager.dart';
import 'package:time_hello/com/timehello/util/SettingManager.dart';
import 'package:time_hello/com/timehello/util/TablesInit.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/UserInfoManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:uuid/uuid.dart';

import '../../../beans/BillModel.dart';
import '../../../beans/CreditCardModel.dart';
import '../../../libs/methodChannel/CounterMethodChannelManager.dart';
import '../../../libs/mongodb/MongoDbBatch.dart';
import '../../../libs/mongodb/MongoDbQuery.dart';
import '../../../libs/mongodb/response/MongoDbError.dart';
import '../../../libs/mongodb/response/MongoDbHandled.dart';
import '../../../libs/mongodb/response/MongoDbSaved.dart';
import '../../../libs/mongodb/response/MongoDbUpdated.dart';
import '../../../models/CourseModel.dart';
import '../../../models/EventFn.dart';
import '../../../models/FlomoMissionModel.dart';
import '../../../models/GroupModel.dart';
import '../../../models/PresentModel.dart';
import '../../../models/TimelineMissionModel.dart';
import '../../../models/WQBFolderModel.dart';
import '../../../page/loginPage/LoginPage.dart';
import '../../../util/DeviceInfoManagement.dart';
import '../../../util/DialogManagement.dart';
import '../../../util/Perf.dart';
import '../../../util/SharePreferenceUtil.dart';
import '../../provider/GlobalStateEnv.dart';

class MongoApisManager {
  static MongoApisManager? _instance;
  String? device_id;
  bool hasLoadedGroupModels = false;
  bool hasLoadedFolderModels = false;
  bool hasLoadedChatGptMessageModel = false;
  bool hasLoadedWQBFolderModels = false;
  bool hasLoadedPresentModels = false;
  bool hasLoadedChatGptFolderModel = false;
  bool hasLoadedWQBMissionModels = false;
  bool hasLoadedCreditCardModels = false;
  bool hasLoadedMissionModels = false;
  bool hasLoadedCourseModel = false;
  bool hasLoadedBillModel = false;
  bool hasLoadedSharePreferenceModel = false;
  bool hasLoadedTimeLineMissionModel = false;
  bool hasLoadedEndTimeMissionModels = false;
  bool hasLoadedFlomoMissionModels = false;
  bool hasLoadedStatsModels = false;
  bool hasInit = false;
  List<CourseModel> listCourseModel = [];
  List<FlomoMissionModel> listFlomoMissionModel = [];

  /**
   * 登录会走这里到loginSuccess调用 但是调用了应该用缓存数据
   */
  void reset({bool shouldResetAllData = false}) {
    this.hasInit = false;
    if (shouldResetAllData == true) {
      hasLoadedGroupModels = false;
      hasLoadedFolderModels = false;
      hasLoadedChatGptMessageModel = false;
      hasLoadedWQBFolderModels = false;
      hasLoadedPresentModels = false;
      hasLoadedWQBMissionModels = false;
      hasLoadedCreditCardModels = false;
      hasLoadedMissionModels = false;
      hasLoadedCourseModel = false;
      hasLoadedBillModel = false;
      hasLoadedSharePreferenceModel = false;
      hasLoadedTimeLineMissionModel = false;
      hasLoadedEndTimeMissionModels = false;
      hasLoadedFlomoMissionModels = false;
      hasLoadedChatGptFolderModel = false;
      hasLoadedStatsModels = false;
      listCourseModel = [];
      listFlomoMissionModel = [];
      listFolderModels = [];
      listSharePreferenceModel = [];
      listWQBFolderModel = [];
      listCreditCardModel = [];
      listBillModel = [];
      listGroupModel = [];
      listWQBMissionModel = [];
      listTimelineMissionModel = [];
      listMissionModels = [];
      listEndTimeMissionModels = [];
      listStatsModels = [];
      listPresentModel = [];
      listEventCollectionModel = [];
      listChatGptMessageModel = [];
      Utility.getGlobalContext().read<GlobalStateEnv>().listCourseModel =
          this.listCourseModel;
      Utility.getGlobalContext().read<GlobalStateEnv>().listFlomoMissionModel =
          this.listFlomoMissionModel;
      Utility.getGlobalContext().read<GlobalStateEnv>().listFolderModels =
          listFolderModels;
      Utility.getGlobalContext()
          .read<GlobalStateEnv>()
          .listSharePreferenceModel = listSharePreferenceModel;
      Utility.getGlobalContext().read<GlobalStateEnv>().listWQBFolderModel =
          listWQBFolderModel;
      Utility.getGlobalContext().read<GlobalStateEnv>().listCreditCardModel =
          listCreditCardModel;
      Utility.getGlobalContext().read<GlobalStateEnv>().listBillModel =
          listBillModel;
      Utility.getGlobalContext().read<GlobalStateEnv>().listGroupModel =
          listGroupModel;
      Utility.getGlobalContext().read<GlobalStateEnv>().listWQBMissionModel =
          listWQBMissionModel;
      Utility.getGlobalContext()
          .read<GlobalStateEnv>()
          .listTimelineMissionModel = listTimelineMissionModel;
      Utility.getGlobalContext().read<GlobalStateEnv>().listMissionModels =
          listMissionModels;
      Utility.getGlobalContext()
          .read<GlobalStateEnv>()
          .listEndTimeMissionModel = listEndTimeMissionModels;
      Utility.getGlobalContext().read<GlobalStateEnv>().listStatsModels =
          listStatsModels;
      Utility.getGlobalContext().read<GlobalStateEnv>().listPresentModel =
          listPresentModel;
      Utility.getGlobalContext()
          .read<GlobalStateEnv>()
          .listEventCollectionModel = listEventCollectionModel;
      Utility.getGlobalContext()
          .read<GlobalStateEnv>()
          .listChatGptMessageModel = listChatGptMessageModel;
      Utility.initCalendarModel();
    }
  }

  // listFlomoMissionModel
  List<FolderModel> listFolderModels = [];
  List<SharePreferenceModel> listSharePreferenceModel = [];
  List<WQBFolderModel> listWQBFolderModel = [];
  List<CreditCardModel> listCreditCardModel = [];
  List<BillModel> listBillModel = [];
  List<GroupModel> listGroupModel = [];

  List<WQBMissionModel> listWQBMissionModel = [];
  List<TimelineMissionModel> listTimelineMissionModel = [];
  List<MissionModel> listMissionModels = [];
  List<EndTimeMissionModel> listEndTimeMissionModels = [];
  List<StatsModel> listStatsModels = [];
  List<PresentModel> listPresentModel = [];
  List<ChatGptFolderModel> listChatGptFolderModel = [];

  List<EventCollectionModel> listEventCollectionModel = [];

  // List<FlomoMissionModel> listFlomoMissionModel = [];

  List<ChatGptMessageModel> listChatGptMessageModel = [];
  BuildContext? context;

  static MongoApisManager getInstance([BuildContext? context]) {
    if (_instance == null) {
      _instance = new MongoApisManager();
    }
    _instance?.init();
    _instance?.initDeviceId();
    return _instance!;
  }

  init() {
    this.context = context ?? Utility.getGlobalContext();
    // TablesInit tables = TablesInit();
    // tables.init();
    getDeviceId();
  }

  //就是android id
  initDeviceId() async {
    if (TextUtil.isEmpty(this.device_id) == true) {
      String? deviceId2;
      try {
        deviceId2 = await Utility.getDeviceId();
        // deviceId2 = "12e2jie";
      } catch (e) {
        print(e);
      }
      this.device_id = deviceId2 ?? "";
      // this.device_id = "";
    }
  }

  // reset() {
  //   this.hasInit = false;
  // }

  ///获取设备ID
  getDeviceId() async {
    // String installationId = await Utility.getDeviceId() ??
    //     await BmobInstallationManager.getInstallationId();
    // String deviceId2;
    // try {
    //   deviceId2 = await Utility.getDeviceId();
    // } catch (e) {
    //   print(e);
    // }
    // this.device_id = deviceId2;
    await initDeviceId();
    //登录或者deviceId有值
    if (hasInit == false) {
      if ((TextUtil.isEmpty(this.device_id) == false) ||
          LoginManager.isLogin() == true) {
        hasInit = true;
        // final perf = Perf();
        // perf.start();
        try {
          await Future.wait([
            queryWhereEqual_folderModel(), //初始化listFolderModel
            queryWhereEqual_groupModel(),
            queryWhereEqual_missionData(),
            queryWhereEqual_FlomoMissionModel(),
            queryWhereEqual_sharePreferenceModel()
            // queryWhereEqual_creditModel()
          ]).then((value) {
            Utility.reinitBottomCounter();
            // eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
            // eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
          });
        } catch (e) {
          print(e);
        }
        queryWhereEqual_ChatGptMessageModel();
        queryWhereEqual_WQBMissionModel();
        queryWhereEqual_WQBFolderModel();
        //下面这些直接异步 不需要等
        queryWhereEqual_statsModel();
        queryWhereEqual_presentModel();
        queryWhereEqual_TimelineMissionModel();
        queryWhereEqual_EndTimeMissionModel();
        queryWhereEqual_CourseModel();
        // perf.stop();
        // queryWhereEqual_folderModel(); //初始化listFolderModel
        // queryWhereEqual_missionData();
        // queryWhereEqual_statsModel();
        // queryWhereEqual_presentModel();
        // queryWhereEqual_TimelineMissionModel();
      } else {
        Utility.initCalendarModel();
      }
    }
    // print(installationId);
  }


  Future delete_ChatGptFolderModel([String? objectId, Function? callback]) async {
    if (LoginManager.isLogin() == false) {
      Utility.showToast(msg: getI18NKey().loginFirst);
      LoginManager.getInstance()
          .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
      return null;
    }
    if (TextUtil.isEmpty(objectId)) {
      return null;
    }
    ChatGptFolderModel chatGptFolderModel = ChatGptFolderModel();
    chatGptFolderModel.objectId = objectId;
    MongoDbHandled bmobHandled = await chatGptFolderModel.delete();
    await queryWhereEqual_ChatGptFolderModel(shouldRefresh: true);

    if (callback != null) {
      callback(bmobHandled);
    }
    Utility.print("删除一条数据成功：${bmobHandled.message}");
    return bmobHandled;
  }


  // 删除 CourseModel
  Future delete_CourseModel([String? objectId, Function? callback]) async {
    if (LoginManager.isLogin() == false) {
      Utility.showToast(msg: getI18NKey().loginFirst);
      LoginManager.getInstance()
          .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
      // Utility.pushNavigator(Utility.getGlobalContext(), new LoginPage(), callback: (res) {
      // });
      return null;
    }

    if (TextUtil.isEmpty(objectId)) {
      return null;
    }
    CourseModel courseModel = CourseModel();
    courseModel.objectId = objectId;
    MongoDbHandled bmobHandled = await courseModel.delete();
    await queryWhereEqual_CourseModel(shouldRefresh: true);

    if (callback != null) {
      callback(bmobHandled);
    }
    Utility.print("删除一条数据成功：${bmobHandled.message}");
    return bmobHandled;
  }

  // 等于条件查询 CourseModel
  Future<bool> isCourseModelExist({
    required String fid,
  }) async {
    // bool isCourseModelExist = false;
    // if(this.listCourseModel.length > 0) {
    //   this.listCourseModel.forEach((element) {
    //     if(element.courseFid == true) {
    //       isCourseModelExist = true;
    //     }
    //   });
    //   if(isCourseModelExist == true) {
    //     return true;
    //   }
    // }
    MongoDbQuery<CourseModel> query = MongoDbQuery();
    query.addWhereEqualTo("courseFid", fid);
    List<dynamic> data = await query.queryObjects();
    if (data.length > 0) {
      return true;
    }
    return false;
  }

  Future<CourseModel?> getCourseModelByFid(String courseModelId) async {
    for (int i = 0; i < this.listCourseModel.length; i++) {
      if (this.listCourseModel[i].courseFid == courseModelId) {
        return this.listCourseModel[i];
      }
    }
    return null;
  }

  Future<bool> isCourseModelIdExist(String courseModelId) async {
    for (int i = 0; i < this.listFolderModels.length; i++) {
      if (this.listFolderModels[i].courseModelId == courseModelId) {
        return true;
      }
    }
    return false;
  }

  //用于分享用户课程
  insertCourseIntoUser(String courseModelId, String folderModelObjectId) async {
    MongoDbQuery<FolderModel> query = MongoDbQuery();
    // 查找folderModel
    query.addWhereEqualTo("_id", folderModelObjectId);
    if (folderModelObjectId != null) {
      Map<String, dynamic> data = await query.queryObject(folderModelObjectId);
      // List<FolderModel> folderModelList = data.map((i) {
      //   return FolderModel.fromJson(i);
      // }).toList();
      // if (folderModelList.length > 0) {
      try {
        FolderModel folderModel = FolderModel.fromJson(data);
        //清空objectId用于方便保存新的
        folderModel.originalFolderId = folderModel.objectId; //把原始id创建
        folderModel.courseModelId = courseModelId;
        folderModel.objectId = null;
        folderModel.uid = LoginManager.getInstance().userBean.uid;
        folderModel.device_id = this.device_id;
        MongoDbSaved? res = await folderModel.save();
        folderModel.objectId = res?.objectId;
        folderModel.createdAt = res?.createdAt;

        List<MissionModel> listMissionModel =
            await queryWhereEqual_missionDataByParams(
                folder_id: folderModelObjectId);
        //更新新的fid uid device_id,批量保存数据
        listMissionModel.forEach((data) {
          data.objectId = null;
          data.folder_id = folderModel.objectId;
          data.uid = LoginManager.getInstance().userBean.uid;
          data.device_id = this.device_id;
        });

        //批量更新missionModel数据到用户本地
        await batchInsert_MissionModelsWithParams(listParam: listMissionModel);
        await Future.wait([
          queryWhereEqual_folderModel(shouldRefresh: true),
          queryWhereEqual_missionData(shouldRefresh: true)
        ]);
        Utility.print("");
      } catch (e) {
        Utility.print(e.toString());
      }
      // await queryWhereEqual_missionDataByOtherUser(folder_id: fo)
      // }
    }
  }

  Future<FolderModel?> requestFolderModelByFolderId(
      {required String folder_id, callback}) async {
    MongoDbQuery<FolderModel> query = MongoDbQuery();
    // query.addWhereEqualTo("folder_id", folder_id);
    // query.skip = 0;
    // query.limit = 1;
    dynamic res = await query.queryObject(folder_id);
    if (res == null) {
      return null;
    }
    FolderModel folderModel = FolderModel.fromJson(res);
    // print(data.toString());
    // List<MissionModel> missionModels =
    // data.map((i) => MissionModel.fromJson(i)).toList();
    if (callback != null) {
      callback(folderModel);
    }
    return folderModel;
  }

  Future<List<SharePreferenceModel>> queryWhereEqual_sharePreferenceModel(
      {shouldRefresh = true, callback}) async {
    if (shouldRefresh == false && this.hasLoadedSharePreferenceModel == true)
      return this.listSharePreferenceModel;
    List<MongoDbQuery<SharePreferenceModel>> list = [];
    MongoDbQuery<SharePreferenceModel> query1 = MongoDbQuery();
    String uid = LoginManager.getInstance().getUid();
    if (uid.isNotEmpty == true) {
      query1.addWhereEqualTo("uid", uid);
      list.add(query1);
    }
    MongoDbQuery<SharePreferenceModel> query2 = MongoDbQuery();
    query2.addWhereEqualTo(
        "device_id", this.device_id ?? ""); //todo 这里有问题 闪屏页进来拿到空的数据
    list.add(query2);
    MongoDbQuery<SharePreferenceModel> query = MongoDbQuery();
    query.or(list);
    query.skip = 0;
    query.limit = 100000;
    List<dynamic> data = await query.queryObjects();
    List<SharePreferenceModel> sharePreferenceModelList =
        data.map((i) => SharePreferenceModel.fromJson(i)).toList();
    sharePreferenceModelList.forEach((element) {
      if (TextUtil.isEmpty(element.uid) == true) {
        element.uid = LoginManager.getInstance().getUid();
      }
      if (TextUtil.isEmpty(this.device_id) == false) {
        element.device_id = this.device_id;
      }
      // if (element.update_time == null) element.update_time = 0;
      // if (element.create_time == null) element.create_time = 0;
    });
    SettingManager.getSyncInstance().init();
    // UserInfoManager.getSyncInstance().init();
    Utility.getGlobalContext().read<Env>().settingModel =
        SettingManager.getSyncInstance().settingModel;
    // Utility.getGlobalContext().read<Env>().userInfoModel =
    //     UserInfoManager.getSyncInstance().userInfoModel;

    this.hasLoadedSharePreferenceModel = true;
    this.listSharePreferenceModel = sharePreferenceModelList;
    if (callback != null) {
      callback(listCreditCardModel);
    }
    // context?.read<GlobalStateEnv>().listBillModel = listBillModel;
    return listSharePreferenceModel;
  }

  Future<CourseModel?> requestCourseModelByFolderId(
      {required String folder_id, callback}) async {
    try {
      MongoDbQuery<CourseModel> query = MongoDbQuery();
      query.addWhereEqualTo("courseFid", folder_id);
      // query.addWhereEqualTo("folder_id", folder_id);
      // query.skip = 0;
      // query.limit = 1;
      List<dynamic> data = await query.queryObjects();
      // CourseModel courseModel = CourseModel.fromJson(res);
      List<CourseModel> courseModels =
          data.map((i) => CourseModel.fromJson(i)).toList();

      // print(data.toString());
      // List<MissionModel> missionModels =
      // data.map((i) => MissionModel.fromJson(i)).toList();
      if (callback != null) {
        callback(courseModels[0]);
      }
      return courseModels[0];
    } catch (e) {
      return null;
    }
  }

  Future<List<MissionModel>> queryWhereEqual_missionDataByParams(
      {required String folder_id, callback}) async {
    MongoDbQuery<MissionModel> query = MongoDbQuery();
    query.addWhereEqualTo("folder_id", folder_id);

    // query.and(list);
    query.skip = 0;
    query.limit = 100000;
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    // query.addWhereEqualTo("title", "博客标题");
    List<dynamic> data = await query.queryObjects();
    Utility.print(data.toString());
    List<MissionModel> missionModels =
        data.map((i) => MissionModel.fromJson(i)).toList();
    if (callback != null) {
      callback(missionModels);
    }
    return missionModels;
  }

  // 更新 FolderModel
  Future<bool?> setFolderModelType(String currentObjectId,
      {isSharing = 0, isOtherUserEditable = false, Function? callback}) async {
    MongoDbQuery<FolderModel> query = MongoDbQuery();
    query.addWhereEqualTo("_id", currentObjectId);
    if (currentObjectId != null) {
      List<dynamic> data = await query.queryObjects();
      List<FolderModel> folderModelList = data.map((i) {
        return FolderModel.fromJson(i);
      }).toList();
      List<Future> list = [];
      if (folderModelList.length > 0) {
        for (int i = 0; i < folderModelList.length; i++) {
          FolderModel folderModel = folderModelList[i];
          folderModel.isSharing = isSharing;
          folderModel.isOtherUserEditable = isOtherUserEditable;
          folderModel.update_time = Utility.getTimeStampToday();
          list.add(folderModel.update());
        }
      }
      List listRes = await Future.wait(list);

      await queryWhereEqual_folderModel(shouldRefresh: true);
      if (callback != null) {
        callback(true);
      }
      Utility.print("修改一条数据成功：${true}");
      return true;
    } else {
      Utility.print("请先新增一条数据");
      // showError(context, "请先新增一条数据");
    }
  }

// 等于条件查询 CourseModel
  Future<List<CourseModel>> queryWhereEqual_CourseModel(
      {shouldRefresh = true,
      // String id,
      // String title,
      // int type,
      Function? callback}) async {
    if (TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid) ==
            true &&
        TextUtil.isEmpty(this.device_id) == true) {
      return [];
    }
    if (shouldRefresh == false && this.hasLoadedFolderModels == true)
      return this.listCourseModel;

    List<MongoDbQuery<CourseModel>> list = [];
    MongoDbQuery<CourseModel> query1 = MongoDbQuery();
    query1.addWhereEqualTo("languageCode",
        DeviceInfoManagement.getLanguage()); //todo 这里有问题 闪屏页进来拿到空的数据
    MongoDbQuery<CourseModel> query2 = MongoDbQuery();
    query2.addWhereEqualTo("countryCode",
        DeviceInfoManagement.getCountryCode()); //todo 这里有问题 闪屏页进来拿到空的数据

    list.add(query1);
    list.add(query2);
    //国家语言都算
    MongoDbQuery<CourseModel> queryCond = MongoDbQuery();
    queryCond.or(list);
    //需要验证审批通过才可以
    List<MongoDbQuery<CourseModel>> list2 = [];
    MongoDbQuery<CourseModel> query3 = MongoDbQuery();
    query3.addWhereEqualTo("verifiedtatus", 2);
    list2.add(queryCond);
    list2.add(query3);

    MongoDbQuery<CourseModel> query = MongoDbQuery();
    query.and(list2);
    query.skip = 0;
    query.limit = 100000;
    List<dynamic> data = await query.queryObjects();
    List<CourseModel> courseModelList = data.map((i) {
      return CourseModel.fromJson(i);
    }).toList();
    this.hasLoadedCourseModel = true;
    this.listCourseModel = courseModelList;
    Utility.getGlobalContext().read<GlobalStateEnv>().listCourseModel =
        this.listCourseModel;
    // eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    if (callback != null) {
      callback(courseModelList);
    }
    return courseModelList;
  }

  insertSubmission(MissionModel missionModel,
      {required int notificationTime, required String title}) async {
    missionModel.subMissions?.add({
      "id": Utility.getRandom(from: 0, max: 100000),
      "isFinished": false,
      "notificationTime": notificationTime,
      "title": title
    });
    MongoDbUpdated? res =
        await this.update_MissionModel(missionModel: missionModel);
    return res;
  }

  deleteSubmissionById(MissionModel missionModel, {required int id}) async {
    missionModel.subMissions?.removeWhere((element) => element['id'] == id);
    MongoDbUpdated? res =
        await this.update_MissionModel(missionModel: missionModel);
    return res;
  }

  // 插入 CourseModel
  Future<MongoDbSaved?> insertCourseModel(CourseModel courseModel,
      {Function? callback}) async {
    try {
      //没登录且deviceId为空， 提示去登录
      if (LoginManager.isLogin() == false) {
        Utility.showToast(msg: getI18NKey().loginFirst);
        LoginManager.getInstance()
            .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
        return null;
      }

      // CourseModel courseModel = CourseModel();
      // // folderModel.id = id;
      // courseModel.title = title;
      // courseModel.description = description;
      // courseModel.device_id = this.device_id;
      // courseModel.number = number;
      // courseModel.tag = tag;
      // courseModel.icon = icon ?? Icons.local_offer.codePoint;
      // courseModel.tagName = tagName;
      // courseModel.color = color;
      courseModel.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      courseModel.countryCode = DeviceInfoManagement.getCountryCode();
      courseModel.verifiedtatus = 0;
      courseModel.updated_at = Utility.getTimeStampToday();
      courseModel.created_at = Utility.getTimeStampToday();
      User user = User();
      String? uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      user.setObjectId(uid ?? "");
      // BmobAcl bmobAcl = BmobAcl();
      // bmobAcl.setPublicReadAccess(true);
      // folderModel.setAcl(bmobAcl);
      // if (await isTagNameExist_folderModel(title: title) == true) {
      //   if (callback != null) {
      //     callback(null);
      //   }
      //   return null;
      // }
      MongoDbSaved? bmobSaved = await courseModel.save();
      await queryWhereEqual_CourseModel(shouldRefresh: true);
      String message =
          "创建一条数据成功：${bmobSaved?.objectId} - ${bmobSaved?.createdAt}";

      // print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      return bmobSaved;
    } catch (e) {
      Utility.print(MongoDbError.convert(e)?.error);
    } finally {
      // await dbUtil.close();
    }
    return null;
  }

  Future<List<FolderModel>> queryWhereEqual_FolderModel(
      {required String uid, Function? callback}) async {
    MongoDbQuery<FolderModel> query = MongoDbQuery();
    query.addWhereEqualTo("otherUids", uid);
    query.skip = 0;
    query.limit = 100000;
    List<dynamic> data = await query.queryObjects();
    List<FolderModel> listTmp =
        data.map((i) => FolderModel.fromJson(i)).toList();
    if (callback != null) {
      callback(listTmp);
    }
    return listTmp;
  }

  Future<TimelineMissionModel?> queryWhereEqual_TimelineMissionModelByObjectId(
      {required String objectId, Function? callback}) async {
    MongoDbQuery<TimelineMissionModel> query = MongoDbQuery();
    query.addWhereEqualTo("_id", objectId ?? "");
    try {
      query.skip = 0;
      query.limit = 1;
      List data = await query.queryObjects();
      List<TimelineMissionModel> listTmp =
          data.map((i) => TimelineMissionModel.fromJson(i)).toList();
      if (callback != null) {
        callback(data);
      }
      return listTmp[0];
    } catch (e) {
      Utility.print(e);
    }
    return null;
  }

// 更新 CourseModel
  Future<MongoDbUpdated?> update_CourseModel(String currentObjectId,
      {required CourseModel courseModel, Function? callback}) async {
    MongoDbQuery<CourseModel> query = MongoDbQuery();
    query.addWhereEqualTo("_id", courseModel.objectId ?? "");
    if (currentObjectId != null) {
      if (!TextUtil.isEmpty(currentObjectId)) {
        courseModel.objectId = currentObjectId;
      }
      courseModel.updated_at = Utility.getTimeStampToday();
      // courseModel.uid =
      //     TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
      //         ? ''
      //         : LoginManager.getInstance().getUserBean().uid;
      // folderModel.update_time = Utility.getTimeStamp();
      MongoDbUpdated bmobUpdated = await courseModel.update();
      await queryWhereEqual_CourseModel(shouldRefresh: true);
      if (callback != null) {
        callback(bmobUpdated);
      }
      Utility.print("修改一条数据成功：${bmobUpdated.message}");
      return bmobUpdated;
    } else {
      Utility.print("请先新增一条数据");
      // showError(context, "请先新增一条数据");
    }
  }

  static bool isIntersectDate1AndDate2(
      {int? startTime1, int? endTime1, int? startTime2, int? endTime2}) {
    if (startTime1 == null ||
        endTime1 == null ||
        startTime2 == null ||
        endTime2 == null) {
      return false;
    }
    if (startTime1 >= endTime2 || endTime1 <= startTime2) {
      return false;
    }
    return true;
  }

  /**
   * 等于条件查询
   * start_endTime null end_endTime null 搜索全部
   */
  List<MissionModel> queryWhereEqual_missionDataByEndTime(
      {int? start_endTime,
      int? end_endTime,
      List<MissionModel>? listMissionModels,
      // int? time_mode,
      String? fid,
        bool? isFinished,
      int? repetiveType = null,
      callback}) {
    List<MissionModel> list = [];
    List<MissionModel> listMissionModelsTmp =
        listMissionModels ?? this.listMissionModels;
    for (int i = 0; i < listMissionModelsTmp.length; i++) {
      MissionModel model = listMissionModelsTmp[i];
      if (start_endTime != null && end_endTime != null) {
        if (model.time_mode == 1) {
          //时间段 判断时间有没有交叉
          // if (start_endTime != null && model.end_time! >= start_endTime) {
          //   if (end_endTime != null && model.end_time! <= end_endTime) {
          bool isIntersect = isIntersectDate1AndDate2(
              startTime1: start_endTime,
              endTime1: end_endTime,
              startTime2: model.start_time,
              endTime2: model.end_time);
          if (isIntersect == true) {
            if (repetiveType == null || model.repetiveType == repetiveType) {
              if (fid == null || model.folder_id == fid) {
                if(isFinished == null || model.isFinished == isFinished) {
                  list.add(model);
                }
                // list.add(model);
                //     }
                //   }
              }
            }
          }
        } else {
          if (start_endTime != null && model.end_time! >= start_endTime) {
            if (end_endTime != null && model.end_time! <= end_endTime) {
              // model.ic
              if (repetiveType == null || model.repetiveType == repetiveType) {
                if (fid == null || model.folder_id == fid) {
                  // if(time_mode == null || model.time_mode == time_mode) {
                  if(isFinished == null || model.isFinished == isFinished) {
                    list.add(model);
                  }
                  // }
                }
              }
            }
          }
        }
      } else if (start_endTime != null && end_endTime == null) {
        if (model.end_time! >= start_endTime) {
          if (repetiveType == null || model.repetiveType == repetiveType) {
            if (fid == null || model.folder_id == fid) {
              // if(time_mode == null || model.time_mode == time_mode) {
              if(isFinished == null || model.isFinished == isFinished) {
                list.add(model);
              }
              // }
            }
          }
        }
      } else if (start_endTime == null && end_endTime != null) {
        if (model.end_time! <= end_endTime) {
          if (repetiveType == null || model.repetiveType == repetiveType) {
            if (fid == null || model.folder_id == fid) {
              if(isFinished == null || model.isFinished == isFinished) {
                list.add(model);
              }
            }
          }
        }
      } else {
        if (fid == null || model.folder_id == fid) {
          if(isFinished == null || model.isFinished == isFinished) {
            list.add(model);
          }
        }
      }
    }
    return list;
  }

  /**
   * 等于条件查询
   * start_endTime null end_endTime null 搜索全部
   */
  List<WQBMissionModel> queryWhereEqual_wqbmissionDataByEndTime(
      {int? start_endTime,
      int? end_endTime,
      String? fid,
      int? repetiveType = null,
      callback}) {
    List<WQBMissionModel> list = [];

    for (int i = 0; i < this.listWQBMissionModel.length; i++) {
      WQBMissionModel model = this.listWQBMissionModel[i];
      if (start_endTime != null && end_endTime != null) {
        if (start_endTime != null && model.update_time! >= start_endTime) {
          if (end_endTime != null && model.update_time! <= end_endTime) {
            // model.ic
            if (repetiveType == null) {
              if (fid == null || model.folder_id == fid) {
                list.add(model);
              }
            }
          }
        }
      } else if (start_endTime != null && end_endTime == null) {
        if (model.update_time! >= start_endTime) {
          if (repetiveType == null) {
            if (fid == null || model.folder_id == fid) {
              list.add(model);
            }
          }
        }
      } else if (start_endTime == null && end_endTime != null) {
        if (model.update_time! <= end_endTime) {
          if (repetiveType == null) {
            if (fid == null || model.folder_id == fid) {
              list.add(model);
            }
          }
        }
      } else {
        if (fid == null || model.folder_id == fid) {
          list.add(model);
        }
      }
    }
    return list;
  }

  /**
   * 等于条件查询
   * start_endTime null end_endTime null 搜索全部
   */
  List<FlomoMissionModel> queryWhereEqual_flomoMissionDataByEndTime(
      {int? start_endTime,
      int? end_endTime,
      String? fid,
      int? repetiveType = null,
      callback}) {
    List<FlomoMissionModel> list = [];

    for (int i = 0; i < this.listFlomoMissionModel.length; i++) {
      FlomoMissionModel model = this.listFlomoMissionModel[i];
      if (start_endTime != null && end_endTime != null) {
        if (start_endTime != null && model.end_time! >= start_endTime) {
          if (end_endTime != null && model.end_time! <= end_endTime) {
            // model.ic
            if (repetiveType == null || model.repetiveType == repetiveType) {
              if (fid == null || model.folder_id == fid) {
                list.add(model);
              }
            }
          }
        }
      } else if (start_endTime != null && end_endTime == null) {
        if (model.end_time! >= start_endTime) {
          if (repetiveType == null || model.repetiveType == repetiveType) {
            if (fid == null || model.folder_id == fid) {
              list.add(model);
            }
          }
        }
      } else if (start_endTime == null && end_endTime != null) {
        if (model.end_time! <= end_endTime) {
          if (repetiveType == null || model.repetiveType == repetiveType) {
            if (fid == null || model.folder_id == fid) {
              list.add(model);
            }
          }
        }
      } else {
        if (fid == null || model.folder_id == fid) {
          list.add(model);
        }
      }
    }
    return list;
  }

  /**
   * 等于条件查询
   * start_endTime null end_endTime null 搜索全部
   */
  List<TimelineMissionModel> queryWhereEqual_timelineMissionModelsByEndTime(
      {int? start_endTime,
      int? end_endTime,
      String? fid,
      String? scene,
      int? repetiveType,
      callback}) {
    List<TimelineMissionModel> list = [];

    for (int i = 0; i < this.listTimelineMissionModel.length; i++) {
      TimelineMissionModel model = this.listTimelineMissionModel[i];
      if (start_endTime != null && end_endTime != null) {
        if (start_endTime != null && model.end_time! >= start_endTime) {
          if (end_endTime != null && model.end_time! <= end_endTime) {
            // model.ic
            if (repetiveType == null || model.repetiveType == repetiveType) {
              if (fid == null || model.folder_id == fid) {
                if (scene == null || model.sceneType == scene) {
                  list.add(model);
                }
              }
            }
          }
        }
      } else if (start_endTime != null && end_endTime == null) {
        if (model.end_time! >= start_endTime) {
          if (repetiveType == null || model.repetiveType == repetiveType) {
            if (fid == null || model.folder_id == fid) {
              if (scene == null || model.sceneType == scene) {
                list.add(model);
              }
            }
          }
        }
      } else if (start_endTime == null && end_endTime != null) {
        if (model.end_time! <= end_endTime) {
          if (repetiveType == null || model.repetiveType == repetiveType) {
            if (fid == null || model.folder_id == fid) {
              if (scene == null || model.sceneType == scene) {
                list.add(model);
              }
            }
          }
        }
      } else {
        if (fid == null || model.folder_id == fid) {
          if (scene == null || model.sceneType == scene) {
            list.add(model);
          }
        }
      }
    }
    return list;
  }

  ///等于条件查询
  List<MissionModel> queryWhereEqual_missionDataByRepetiveTypes(
      {required List repetiveType,
      List<MissionModel>? listMissionModel,
      callback}) {
    List<MissionModel>? listMissionModels =
        listMissionModel ?? this.listMissionModels;
    List<MissionModel> list = [];
    for (int i = 0; i < listMissionModels.length; i++) {
      MissionModel model = listMissionModels[i];
      if (repetiveType.indexOf(model.repetiveType) != -1) {
        list.add(model);
      }
    }
    return list;
  }

  List<FlomoMissionModel> queryWhereEqual_flomoMissionDataByRepetiveTypes(
      {required List repetiveType, callback}) {
    List<FlomoMissionModel> list = [];
    for (int i = 0; i < this.listFlomoMissionModel.length; i++) {
      FlomoMissionModel model = this.listFlomoMissionModel[i];
      if (repetiveType.indexOf(model.repetiveType) != -1) {
        list.add(model);
      }
    }
    return list;
  }

  static List<MissionModel> getMissionModelsFromList(List<MissionModel> list) {
    List<MissionModel> listTmp = [];
    list.forEach((element) {
      // if (element.isFinished == false) {
      listTmp.add(element);
      // }
    });
    return listTmp;
  }

  static List<MissionModel> getFinishedMissionModelsFromList(
      List<MissionModel> list) {
    List<MissionModel> listTmp = [];
    list.forEach((element) {
      if (element.isFinished == false) {
        listTmp.add(element);
      }
    });
    return listTmp;
  }

  static List<WQBMissionModel> getWQBFinishedMissionModelsFromList(
      List<WQBMissionModel> list) {
    List<WQBMissionModel> listTmp = [];
    list.forEach((element) {
      if (element.isFinished == false) {
        listTmp.add(element);
      }
    });
    return listTmp;
  }

  ///等于条件查询
  List<MissionModel> queryWhereEqual_missionDataByFinished({callback}) {
    List<MissionModel> list = [];
    for (int i = 0; i < this.listMissionModels.length; i++) {
      MissionModel model = this.listMissionModels[i];
      if (model.isFinished == true) {
        list.add(model);
      }
    }
    return list;
  }

  List<WQBMissionModel> queryWhereEqual_wqbmissionDataByFinished({callback}) {
    List<WQBMissionModel> list = [];
    for (int i = 0; i < this.listWQBMissionModel.length; i++) {
      WQBMissionModel model = this.listWQBMissionModel[i];
      if (model.isFinished == true) {
        list.add(model);
      }
    }
    return list;
  }

  FolderModel? getFolderModelByFolderId(String folderId) {
    for (int i = 0; i < this.listFolderModels.length; i++) {
      FolderModel folderModel = this.listFolderModels[i];
      if (folderModel.objectId == folderId) {
        return folderModel;
      }
    }
    return null;
  }

  WQBFolderModel? getWQBFolderModelByFolderId(String folderId) {
    for (int i = 0; i < this.listWQBFolderModel.length; i++) {
      WQBFolderModel folderModel = this.listWQBFolderModel[i];
      if (folderModel.objectId == folderId) {
        return folderModel;
      }
    }
    return null;
  }

  ///完成任务数量
  MissionModel? queryWhereEqual_missionDataByObjectId(
      {required String objectId}) {
    // List<MissionModel> list = [];
    for (int i = 0; i < this.listMissionModels.length; i++) {
      MissionModel model = this.listMissionModels[i];
      if (model.objectId == objectId) {
        return model;
      }
    }
    return null;
  }

  ///完成任务数量
  List<MissionModel> queryWhereEqual_missionDataByFolderId(
      {String? folder_id}) {
    List<MissionModel> list = [];
    for (int i = 0; i < this.listMissionModels.length; i++) {
      MissionModel model = this.listMissionModels[i];
      if (model.folder_id == folder_id) {
        list.add(model);
      }
    }
    return list;
  }

  List<MissionModel> queryWhereEqual_missionDataByTagName(
      {required String tagName}) {
    if (TextUtil.isEmpty(tagName)) {
      return [];
    }
    List<MissionModel> list = [];
    for (int i = 0; i < this.listMissionModels.length; i++) {
      MissionModel model = this.listMissionModels[i];
      if (model.tagNames != null && model.tagNames?.indexOf(tagName) != -1) {
        list.add(model);
      }
    }
    return list;
  }

  List<WQBMissionModel> queryWhereEqual_wqbmissionDataByTagName(
      {required String tagName}) {
    if (TextUtil.isEmpty(tagName)) {
      return [];
    }
    List<WQBMissionModel> list = [];
    for (int i = 0; i < this.listWQBMissionModel.length; i++) {
      WQBMissionModel model = this.listWQBMissionModel[i];
      if (model.tagNames != null && model.tagNames?.indexOf(tagName) != -1) {
        list.add(model);
      }
    }
    return list;
  }

  FolderModel? queryWhereEqualFolderModelByObjectId({String? objectId}) {
    // FolderModel folderModel = FolderModel();
    for (int i = 0; i < this.listFolderModels.length; i++) {
      FolderModel item = this.listFolderModels[i];
      if (item.objectId == objectId) {
        return item;
      }
    }
    return null;
  }

  WQBFolderModel? queryWhereEqualWQBFolderModelByObjectId({String? objectId}) {
    // FolderModel folderModel = FolderModel();
    for (int i = 0; i < this.listWQBFolderModel.length; i++) {
      WQBFolderModel item = this.listWQBFolderModel[i];
      if (item.objectId == objectId) {
        return item;
      }
    }
    return null;
  }

  ///完成任务数量
  List<MissionModel> queryWhereEqual_missionDataByFolderModelObjectId(
      {String? objectId, List<MissionModel>? listMissionModels}) {
    List<MissionModel> list = [];
    if (objectId == null) {
      return listMissionModels ?? [];
    }
    if (listMissionModels == null) {
      listMissionModels = this.listMissionModels;
    }
    for (int i = 0; i < listMissionModels.length; i++) {
      MissionModel model = listMissionModels[i];
      if (objectId == null) {}
      if (objectId != null && model.folder_id == objectId) {
        list.add(model);
      } else {
        if (objectId == null &&
            (model?.folder_id == null || model?.folder_id?.isEmpty == true)) {
          list.add(model);
        }
      }
    }
    return list;
  }

  ///完成任务数量
  List<WQBMissionModel> queryWhereEqual_wqbmissionDataByFolderModelObjectId(
      {String? folder_objectId, int type = -1, int state = -1}) {
    List<WQBMissionModel> list = [];
    for (int i = 0; i < this.listWQBMissionModel.length; i++) {
      WQBMissionModel model = this.listWQBMissionModel[i];
      if (folder_objectId != null && model.folder_id == folder_objectId) {
        if (type == -1 || type == model.type) {
          if (state == -1 || state == model.state) {
            list.add(model);
          }
        }
      } else if (folder_objectId == null) {
        if (model?.folder_id == null ||
            model?.folder_id?.isEmpty == true ||
            folder_objectId == null) {
          if (type == -1 || type == model.type) {
            if (state == -1 || state == model.state) {
              list.add(model);
            }
            // list.add(model);
          }
        }
      }
    }
    return list;
  }

  ///完成任务数量
  List<WQBMissionModel> queryWhereEqual_wqbmissionDataByFolderModelTag(
      {required String tag}) {
    List<WQBMissionModel> list = [];
    for (int i = 0; i < this.listWQBMissionModel.length; i++) {
      WQBMissionModel model = this.listWQBMissionModel[i];
      if (hasTag(model.tagNames ?? [], tag) == true) {
        list.add(model);
      }
    }
    return list;
  }

  bool hasTag(List list, String tag) {
    for (int i = 0; i < list.length; i++) {
      Map item = list[i];
      if (item['title'] == tag) {
        return true;
      }
    }
    return false;
  }

  ///完成任务数量
  List<MissionModel> queryWhereEqual_missionDataByFinishedMission(
      {isFinished = true}) {
    List<MissionModel> list = [];
    for (int i = 0; i < this.listMissionModels.length; i++) {
      MissionModel model = this.listMissionModels[i];
      if (model?.isFinished ?? false) {
        list.add(model);
      }
    }
    return list;
  }

  List<MissionModel> queryWhereEqual_missionDataByDoItNowMission() {
    List<MissionModel> list = [];
    for (int i = 0; i < this.listMissionModels.length; i++) {
      MissionModel model = this.listMissionModels[i];
      if ((model.do_it_now?.length ?? 0) > 0) {
        list.add(model);
      }
    }
    return list;
  }

  List<MissionModel> queryWhereEqual_missionDataByDoItNowMissionWithoutFinish(
      {isFinished = true}) {
    List<MissionModel> list = [];
    int timestampToday = Utility.getTimeStampToday();
    for (int i = 0; i < this.listMissionModels.length; i++) {
      MissionModel model = this.listMissionModels[i];
      if (model.isFinished == false && (model.do_it_now?.length ?? 0) > 0) {
        int end_time = model.do_it_now?[0]['buffer_end_time'] ??
            model.do_it_now?[0]['end_time'] ??
            0;
        if (timestampToday < end_time) {
          list.add(model);
        }
      }
    }
    return list;
  }

  List<MissionModel> queryWhereEqual_missionDataByDateStatus({dateStatus = 0}) {
    List<MissionModel> list = [];
    for (int i = 0; i < this.listMissionModels.length; i++) {
      MissionModel model = this.listMissionModels[i];
      if (model.dateStatus == dateStatus) {
        list.add(model);
      }
    }
    return list;
  }

  ///等于条件查询
  Future<List<EndTimeMissionModel>> queryWhereEqual_EndTimeMissionModel(
      {String? folder_id,
      String? currentObjectId,
      bool shouldRefresh = true,
      title,
      description,
      device_id,
      order_index,
      dateStatus,
      tagName,
      tagId,
      priorityStatus,
      total_tomotoes,
      no_tomotoes_finished,
      tomato_duration,
      callback}) async {
    // print("device_id:" + TextUtil.isEmpty(this.device_id).toString() + ", isLogin ${LoginManager.isLogin().toString()} value:" + this.device_id, );
    // Utility.showToast(context: Utility.getGlobalContext(), msg: "device_id:" + this.device_id);
    if (TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid) ==
            true &&
        TextUtil.isEmpty(this.device_id) == true) {
      return [];
    }
    if (shouldRefresh == false && this.hasLoadedEndTimeMissionModels == true)
      return this.listEndTimeMissionModels;

    this.hasLoadedEndTimeMissionModels = true;
    MongoDbQuery<EndTimeMissionModel> query = MongoDbQuery();
    MongoDbQuery<EndTimeMissionModel> queryUid = MongoDbQuery();
    MongoDbQuery<EndTimeMissionModel> queryUidAndDeviceId = MongoDbQuery();

    MongoDbQuery<EndTimeMissionModel>? query1,
        query2,
        query3,
        query4,
        query5,
        query6;

    MongoDbQuery<EndTimeMissionModel> queryDeviceId = MongoDbQuery();
    queryDeviceId.addWhereEqualTo("device_id", this.device_id ?? "");

    List<MongoDbQuery<EndTimeMissionModel>> list2 = [];
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    if (uid?.isNotEmpty == true) {
      queryUid.addWhereEqualTo("uid", uid ?? "");
      list2.add(queryUid);
    }
    list2.add(queryDeviceId);

    queryUidAndDeviceId.or(list2);

    if (TextUtil.isEmpty(folder_id) != true) {
      query1 = MongoDbQuery();
      query1.addWhereEqualTo("folder_id", folder_id ?? '');
    }
    if (TextUtil.isEmpty(tagName) != true) {
      query2 = MongoDbQuery();
      query2.addWhereEqualTo("tagName", tagName);
    }
    if (TextUtil.isEmpty(title) != true) {
      query3 = MongoDbQuery();
      query3.addWhereEqualTo("title", title);
    }
    if (TextUtil.isEmpty(currentObjectId) != true) {
      query4 = MongoDbQuery();
      query4.addWhereEqualTo("_id", currentObjectId ?? '');
    }
    if (TextUtil.isEmpty(tagId) != true) {
      query5 = MongoDbQuery();
      query5.addWhereEqualTo("tagIds", tagId);
    }
    if (TextUtil.isEmpty(device_id) != true) {
      query6 = MongoDbQuery();
      query6.addWhereEqualTo("device_id", device_id);
    }
    List<MongoDbQuery<EndTimeMissionModel>> list = [];
    list.add(queryUidAndDeviceId);
    if (query1 != null) list.add(query1);
    if (query2 != null) list.add(query2);
    if (query3 != null) list.add(query3);
    if (query4 != null) list.add(query4);
    if (query5 != null) list.add(query5);
    if (query6 != null) list.add(query6);
    if (query2 != null) list.add(query2);
    query.and(list);
    query.skip = 0;
    query.limit = 100000;
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    // query.addWhereEqualTo("title", "博客标题");
    List<dynamic> data = await query.queryObjects();
    Utility.print(data.toString());
    List<EndTimeMissionModel> missionModels =
        data.map((i) => EndTimeMissionModel.fromJson(i)).toList();
    missionModels.forEach((element) {
      if (TextUtil.isEmpty(element.uid) == true) {
        element.uid =
            !TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? LoginManager.getInstance().getUserBean().uid
                : '';
      }
      if (TextUtil.isEmpty(this.device_id) == false) {
        element.device_id = this.device_id;
      }
      if (element.no_tomotoes_finished == null)
        element.no_tomotoes_finished = 0;
      if (element.total_tomotoes == null) element.total_tomotoes = 0;
      if (element.tomato_duration == null) element.tomato_duration = 0;
      if (element.order_index == null) element.order_index = 0;
      if (element.end_time == null) element.end_time = 0;
      if (element.alert_time == null) element.alert_time = 0;
    });

    this.listEndTimeMissionModels = missionModels;
    Utility.getGlobalContext().read<GlobalStateEnv>().listEndTimeMissionModel =
        this.listEndTimeMissionModels;
    if (callback != null) {
      callback(missionModels);
    }
    return missionModels;
  }

  Future<List<MissionModel>> queryWhereEqual_missionDataByOtherUser(
      {required String folder_id, callback}) async {
    // print("device_id:" + TextUtil.isEmpty(this.device_id).toString() + ", isLogin ${LoginManager.isLogin().toString()} value:" + this.device_id, );
    // Utility.showToast(context: Utility.getGlobalContext(), msg: "device_id:" + this.device_id);
    MongoDbQuery<MissionModel> query = MongoDbQuery();

    if (TextUtil.isEmpty(folder_id) != true) {
      query = MongoDbQuery();
      query.addWhereEqualTo("folder_id", folder_id);
    }
    query.skip = 0;
    query.limit = 100000;
    List<dynamic> data = await query.queryObjects();
    Utility.print(data.toString());
    List<MissionModel> missionModels =
        data.map((i) => MissionModel.fromJson(i)).toList();

    this.listMissionModels = missionModels;
    await Utility.initCalendarModel();
    if (callback != null) {
      callback(missionModels);
    }
    return missionModels;
  }

  ///等于条件查询
  Future<List<MissionModel>> queryWhereEqual_missionData(
      {String? folder_id,
      String? currentObjectId,
      bool shouldRefresh = true,
      title,
      description,
      device_id,
      order_index,
      dateStatus,
      tagName,
      tagId,
      priorityStatus,
      total_tomotoes,
      no_tomotoes_finished,
      tomato_duration,
      callback}) async {
    // print("device_id:" + TextUtil.isEmpty(this.device_id).toString() + ", isLogin ${LoginManager.isLogin().toString()} value:" + this.device_id, );
    // Utility.showToast(context: Utility.getGlobalContext(), msg: "device_id:" + this.device_id);
    if (TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid) ==
            true &&
        TextUtil.isEmpty(this.device_id) == true) {
      return [];
    }
    if (shouldRefresh == false && this.hasLoadedMissionModels == true)
      return this.listMissionModels;

    this.hasLoadedMissionModels = true;
    MongoDbQuery<MissionModel> query = MongoDbQuery();
    MongoDbQuery<MissionModel> queryUid = MongoDbQuery();
    MongoDbQuery<MissionModel> queryUidAndDeviceId = MongoDbQuery();

    MongoDbQuery<MissionModel>? query1, query2, query3, query4, query5, query6;

    MongoDbQuery<MissionModel> queryDeviceId = MongoDbQuery();
    queryDeviceId.addWhereEqualTo("device_id", this.device_id ?? "");

    List<MongoDbQuery<MissionModel>> list2 = [];
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    if (uid?.isNotEmpty == true) {
      queryUid.addWhereEqualTo("uid", uid ?? '');
      list2.add(queryUid);
    }
    list2.add(queryDeviceId);

    queryUidAndDeviceId.or(list2);

    if (TextUtil.isEmpty(folder_id) != true) {
      query1 = MongoDbQuery();
      query1.addWhereEqualTo("folder_id", folder_id ?? '');
    }
    if (TextUtil.isEmpty(tagName) != true) {
      query2 = MongoDbQuery();
      query2.addWhereEqualTo("tagName", tagName);
    }
    if (TextUtil.isEmpty(title) != true) {
      query3 = MongoDbQuery();
      query3.addWhereEqualTo("title", title);
    }
    if (TextUtil.isEmpty(currentObjectId) != true) {
      query4 = MongoDbQuery();
      query4.addWhereEqualTo("_id", currentObjectId ?? "");
    }
    if (TextUtil.isEmpty(tagId) != true) {
      query5 = MongoDbQuery();
      query5.addWhereEqualTo("tagIds", tagId);
    }
    if (TextUtil.isEmpty(device_id) != true) {
      query6 = MongoDbQuery();
      query6.addWhereEqualTo("device_id", device_id);
    }
    List<MongoDbQuery<MissionModel>> list = [];
    list.add(queryUidAndDeviceId);
    if (query1 != null) list.add(query1);
    if (query2 != null) list.add(query2);
    if (query3 != null) list.add(query3);
    if (query4 != null) list.add(query4);
    if (query5 != null) list.add(query5);
    if (query6 != null) list.add(query6);
    if (query2 != null) list.add(query2);
    query.and(list);
    query.skip = 0;
    query.limit = 100000;
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    // query.addWhereEqualTo("title", "博客标题");
    List<dynamic> data = await query.queryObjects();
    // Utility.print(data.toString());
    List<MissionModel> missionModels = [];
    missionModels = data.map((i) {
      try {
        return MissionModel.fromJson(i);
      } catch (e) {
        Utility.print(e);
        return MissionModel();
      }
    }).toList();
    int curTimeStamp = Utility.getTimeStampToday();
    missionModels.forEach((element) {
      if (TextUtil.isEmpty(element.uid) == true) {
        element.uid =
            !TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? LoginManager.getInstance().getUserBean().uid
                : '';
      }
      if (TextUtil.isEmpty(this.device_id) == false) {
        element.device_id = this.device_id;
      }
      if (element.no_tomotoes_finished == null)
        element.no_tomotoes_finished = 0;
      if (element.total_tomotoes == null) element.total_tomotoes = 0;
      if (element.tomato_duration == null) element.tomato_duration = 0;
      if (element.order_index == null) element.order_index = 0;
      if (element.end_time == null) element.end_time = 0;
      if (element.alert_time == null) element.alert_time = 0;
      element.isDelayed = false;
      // 延期任务
      if (element.isFinished == false &&
          element.end_time != null &&
          element.end_time! > 0) {
        element.isDelayed = element.end_time! < curTimeStamp;
      }
    });
    //批量解密需要解密的 cryptoVersion=0的 -1不需要解密
    missionModels = await CryptoManager.getInstance()
        .batchDecryptMissionModels(missionModels);
    this.listMissionModels = missionModels;
    //用于缓存专注时离开app再次进入时的数据 防止销毁的情况发生
    await Utility.initCalendarModel();
    if (callback != null) {
      callback(missionModels);
    }
    return missionModels;
  }

  ///等于条件查询
  Future<List<FlomoMissionModel>> queryWhereEqual_FlomoMissionModel(
      {String? folder_id,
      String? currentObjectId,
      bool shouldRefresh = true,
      title,
      description,
      device_id,
      order_index,
      dateStatus,
      tagName,
      tagId,
      priorityStatus,
      total_tomotoes,
      no_tomotoes_finished,
      tomato_duration,
      maxLines: 500,
      callback}) async {
    // print("device_id:" + TextUtil.isEmpty(this.device_id).toString() + ", isLogin ${LoginManager.isLogin().toString()} value:" + this.device_id, );
    // Utility.showToast(context: Utility.getGlobalContext(), msg: "device_id:" + this.device_id);
    if (TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid) ==
            true &&
        TextUtil.isEmpty(this.device_id) == true) {
      return [];
    }
    if (shouldRefresh == false && this.hasLoadedFlomoMissionModels == true)
      return this.listFlomoMissionModel;

    this.hasLoadedFlomoMissionModels = true;
    MongoDbQuery<FlomoMissionModel> query = MongoDbQuery();
    MongoDbQuery<FlomoMissionModel> queryUid = MongoDbQuery();
    MongoDbQuery<FlomoMissionModel> queryUidAndDeviceId = MongoDbQuery();

    MongoDbQuery<FlomoMissionModel>? query1,
        query2,
        query3,
        query4,
        query5,
        query6;

    MongoDbQuery<FlomoMissionModel> queryDeviceId = MongoDbQuery();
    queryDeviceId.addWhereEqualTo("device_id", this.device_id ?? "");

    List<MongoDbQuery<FlomoMissionModel>> list2 = [];
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    if (uid?.isNotEmpty == true) {
      queryUid.addWhereEqualTo("uid", uid ?? "");
      list2.add(queryUid);
    }
    list2.add(queryDeviceId);

    queryUidAndDeviceId.or(list2);

    if (TextUtil.isEmpty(folder_id) != true) {
      query1 = MongoDbQuery();
      query1.addWhereEqualTo("folder_id", folder_id ?? "");
    }
    if (TextUtil.isEmpty(tagName) != true) {
      query2 = MongoDbQuery();
      query2.addWhereEqualTo("tagName", tagName);
    }
    if (TextUtil.isEmpty(title) != true) {
      query3 = MongoDbQuery();
      query3.addWhereEqualTo("title", title);
    }
    if (TextUtil.isEmpty(currentObjectId) != true) {
      query4 = MongoDbQuery();
      query4.addWhereEqualTo("_id", currentObjectId ?? "");
    }
    if (TextUtil.isEmpty(tagId) != true) {
      query5 = MongoDbQuery();
      query5.addWhereEqualTo("tagIds", tagId);
    }
    if (TextUtil.isEmpty(device_id) != true) {
      query6 = MongoDbQuery();
      query6.addWhereEqualTo("device_id", device_id);
    }
    List<MongoDbQuery<FlomoMissionModel>> list = [];
    list.add(queryUidAndDeviceId);
    if (query1 != null) list.add(query1);
    if (query2 != null) list.add(query2);
    if (query3 != null) list.add(query3);
    if (query4 != null) list.add(query4);
    if (query5 != null) list.add(query5);
    if (query6 != null) list.add(query6);
    if (query2 != null) list.add(query2);
    query.and(list);
    query.order = "createdAt";
    query.orderValue = -1; // 排序顺序 如果是时间，-1 则是最新时开始 1 最远时间开始
    query.skip = 0;
    query.limit = maxLines;
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    // query.addWhereEqualTo("title", "博客标题");
    List<dynamic> data = await query.queryObjects();
    Utility.print(data.toString());
    List<FlomoMissionModel> missionModels =
        data.map((i) => FlomoMissionModel.fromJson(i)).toList();
    missionModels.forEach((element) {
      if (TextUtil.isEmpty(element.uid) == true) {
        element.uid =
            !TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? LoginManager.getInstance().getUserBean().uid
                : '';
      }
      if (TextUtil.isEmpty(this.device_id) == false) {
        element.device_id = this.device_id;
      }
      if (element.no_tomotoes_finished == null)
        element.no_tomotoes_finished = 0;
      if (element.total_tomotoes == null) element.total_tomotoes = 0;
      if (element.tomato_duration == null) element.tomato_duration = 0;
      if (element.order_index == null) element.order_index = 0;
      if (element.end_time == null) element.end_time = 0;
      if (element.alert_time == null) element.alert_time = 0;
    });

    this.listFlomoMissionModel = missionModels;
    Utility.getGlobalContext().read<GlobalStateEnv>().listFlomoMissionModel =
        this.listFlomoMissionModel;
    await Utility.initCalendarModel();
    CounterMethodChannelManager.getInstance()
        .storeFlomoMissionList(Utility.getGlobalContext());
    if (callback != null) {
      callback(missionModels);
    }
    return missionModels;
  }

  /**
   * 设置桌面组件时需要清空当前组件的order_index再添加新的
   */
  update_WQBMissionModelByOrderIndex(
      {required WQBMissionModel missionModelParam,
      required int order_index}) async {
    WQBMissionModel? missionModel =
        queryWhereEqual_WQBMissionModelByOrderIndex(order_index: order_index);
    if (missionModel != null) {
      missionModel.order_index = 0;
      // CounterMethodChannelManager.getInstance().storeWQBNoteMissionData(missionModel);
      await update_WQBMissionModel(missionModel: missionModel);
    }
    missionModelParam?.order_index = order_index;
    await update_WQBMissionModel(missionModel: missionModelParam);
  }

  /**
   * 打开app第一次需要更新桌面便签组件
   */
  update_WQBMissionModelByDesktopWiddgetFirstTime() {
    if (Params.hasDesktopNoteWidgetInit == true) {
      return null;
    }
    for (int i = 0; i < this.listWQBMissionModel.length; i++) {
      WQBMissionModel missionModel = this.listWQBMissionModel[i];
      if (missionModel.order_index != null && missionModel.order_index! > 0) {
        CounterMethodChannelManager.getInstance()
            .storeWQBNoteMissionData(missionModel);
        // return missionModel;
      }
    }
    Params.hasDesktopNoteWidgetInit = true;
    return null;
  }

  WQBMissionModel? queryWhereEqual_WQBMissionModelByOrderIndex(
      {required int order_index}) {
    for (int i = 0; i < this.listWQBMissionModel.length; i++) {
      WQBMissionModel missionModel = this.listWQBMissionModel[i];
      if (missionModel.order_index == order_index) {
        return missionModel;
      }
    }
    return null;
  }

  ///等于条件查询
  Future<List<WQBMissionModel>> queryWhereEqual_WQBMissionModel(
      {String? folder_id,
      String? currentObjectId,
      bool shouldRefresh = true,
      title,
      description,
      device_id,
      order_index,
      dateStatus,
      tagName,
      tagId,
      priorityStatus,
      total_tomotoes,
      no_tomotoes_finished,
      tomato_duration,
      maxLines: 500,
      callback}) async {
    // print("device_id:" + TextUtil.isEmpty(this.device_id).toString() + ", isLogin ${LoginManager.isLogin().toString()} value:" + this.device_id, );
    // Utility.showToast(context: Utility.getGlobalContext(), msg: "device_id:" + this.device_id);
    if (TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid) ==
            true &&
        TextUtil.isEmpty(this.device_id) == true) {
      return [];
    }
    if (shouldRefresh == false && this.hasLoadedWQBMissionModels == true)
      return this.listWQBMissionModel;

    this.hasLoadedWQBMissionModels = true;
    MongoDbQuery<WQBMissionModel> query = MongoDbQuery();
    MongoDbQuery<WQBMissionModel> queryUid = MongoDbQuery();
    MongoDbQuery<WQBMissionModel> queryUidAndDeviceId = MongoDbQuery();

    MongoDbQuery<WQBMissionModel>? query1,
        query2,
        query3,
        query4,
        query5,
        query6;

    MongoDbQuery<WQBMissionModel> queryDeviceId = MongoDbQuery();
    queryDeviceId.addWhereEqualTo("device_id", this.device_id ?? "");

    List<MongoDbQuery<WQBMissionModel>> list2 = [];
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    if (uid?.isNotEmpty == true) {
      queryUid.addWhereEqualTo("uid", uid ?? "");
      list2.add(queryUid);
    }
    list2.add(queryDeviceId);

    queryUidAndDeviceId.or(list2);

    if (TextUtil.isEmpty(folder_id) != true) {
      query1 = MongoDbQuery();
      query1.addWhereEqualTo("folder_id", folder_id ?? "");
    }
    if (TextUtil.isEmpty(tagName) != true) {
      query2 = MongoDbQuery();
      query2.addWhereEqualTo("tagName", tagName);
    }
    if (TextUtil.isEmpty(title) != true) {
      query3 = MongoDbQuery();
      query3.addWhereEqualTo("title", title);
    }
    if (TextUtil.isEmpty(currentObjectId) != true) {
      query4 = MongoDbQuery();
      query4.addWhereEqualTo("_id", currentObjectId ?? "");
    }
    if (TextUtil.isEmpty(tagId) != true) {
      query5 = MongoDbQuery();
      query5.addWhereEqualTo("tagIds", tagId);
    }
    if (TextUtil.isEmpty(device_id) != true) {
      query6 = MongoDbQuery();
      query6.addWhereEqualTo("device_id", device_id);
    }
    List<MongoDbQuery<WQBMissionModel>> list = [];
    list.add(queryUidAndDeviceId);
    if (query1 != null) list.add(query1);
    if (query2 != null) list.add(query2);
    if (query3 != null) list.add(query3);
    if (query4 != null) list.add(query4);
    if (query5 != null) list.add(query5);
    if (query6 != null) list.add(query6);
    if (query2 != null) list.add(query2);
    query.and(list);
    query.order = "createdAt";
    query.orderValue = -1; // 排序顺序 如果是时间，-1 则是最新时开始 1 最远时间开始
    query.skip = 0;
    query.limit = maxLines;
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    // query.addWhereEqualTo("title", "博客标题");
    List<dynamic> data = await query.queryObjects();
    Utility.print(data.toString());
    List<WQBMissionModel> missionModels =
        data.map((i) => WQBMissionModel.fromJson(i)).toList();
    missionModels.forEach((element) {
      if (TextUtil.isEmpty(element.uid) == true) {
        element.uid =
            !TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? LoginManager.getInstance().getUserBean().uid
                : '';
      }
      if (TextUtil.isEmpty(this.device_id) == false) {
        element.device_id = this.device_id;
      }
      // if (element.no_tomotoes_finished == null)
      //   element.no_tomotoes_finished = 0;
      // if (element.total_tomotoes == null) element.total_tomotoes = 0;
      // if (element.tomato_duration == null) element.tomato_duration = 0;
      if (element.order_index == null) element.order_index = 0;
      // if (element.end_time == null) element.end_time = 0;
      // if (element.alert_time == null) element.alert_time = 0;
    });

    this.listWQBMissionModel = missionModels;
    Utility.getGlobalContext().read<GlobalStateEnv>().listWQBMissionModel =
        this.listWQBMissionModel;
    this.update_WQBMissionModelByDesktopWiddgetFirstTime();
    // Utility.initCalendarModel();
    if (callback != null) {
      callback(missionModels);
    }
    return missionModels;
  }

  ///等于条件查询
  Future<List<TimelineMissionModel>> queryWhereEqual_TimelineMissionModel(
      {String? folder_id,
      String? currentObjectId,
      bool shouldRefresh = true,
      title,
      description,
      device_id,
      order_index,
      dateStatus,
      tagName,
      tagId,
      priorityStatus,
      total_tomotoes,
      no_tomotoes_finished,
      tomato_duration,
      maxLines: 500,
      callback}) async {
    // print("device_id:" + TextUtil.isEmpty(this.device_id).toString() + ", isLogin ${LoginManager.isLogin().toString()} value:" + this.device_id, );
    // Utility.showToast(context: Utility.getGlobalContext(), msg: "device_id:" + this.device_id);
    if (TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid) ==
            true &&
        TextUtil.isEmpty(this.device_id) == true) {
      return [];
    }
    if (shouldRefresh == false && this.hasLoadedEndTimeMissionModels == true)
      return this.listTimelineMissionModel;

    this.hasLoadedEndTimeMissionModels = true;
    MongoDbQuery<TimelineMissionModel> query = MongoDbQuery();
    MongoDbQuery<TimelineMissionModel> queryUid = MongoDbQuery();
    MongoDbQuery<TimelineMissionModel> queryUidAndDeviceId = MongoDbQuery();

    MongoDbQuery<TimelineMissionModel>? query1,
        query2,
        query3,
        query4,
        query5,
        query6;

    MongoDbQuery<TimelineMissionModel> queryDeviceId = MongoDbQuery();
    queryDeviceId.addWhereEqualTo("device_id", this.device_id ?? "");

    List<MongoDbQuery<TimelineMissionModel>> list2 = [];
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    if (uid?.isNotEmpty == true) {
      queryUid.addWhereEqualTo("uid", uid ?? "");
      list2.add(queryUid);
    }
    list2.add(queryDeviceId);

    queryUidAndDeviceId.or(list2);

    if (TextUtil.isEmpty(folder_id) != true) {
      query1 = MongoDbQuery();
      query1.addWhereEqualTo("folder_id", folder_id ?? "");
    }
    if (TextUtil.isEmpty(tagName) != true) {
      query2 = MongoDbQuery();
      query2.addWhereEqualTo("tagName", tagName);
    }
    if (TextUtil.isEmpty(title) != true) {
      query3 = MongoDbQuery();
      query3.addWhereEqualTo("title", title);
    }
    if (TextUtil.isEmpty(currentObjectId) != true) {
      query4 = MongoDbQuery();
      query4.addWhereEqualTo("_id", currentObjectId ?? "");
    }
    if (TextUtil.isEmpty(tagId) != true) {
      query5 = MongoDbQuery();
      query5.addWhereEqualTo("tagIds", tagId);
    }
    if (TextUtil.isEmpty(device_id) != true) {
      query6 = MongoDbQuery();
      query6.addWhereEqualTo("device_id", device_id);
    }
    List<MongoDbQuery<TimelineMissionModel>> list = [];
    list.add(queryUidAndDeviceId);
    if (query1 != null) list.add(query1);
    if (query2 != null) list.add(query2);
    if (query3 != null) list.add(query3);
    if (query4 != null) list.add(query4);
    if (query5 != null) list.add(query5);
    if (query6 != null) list.add(query6);
    if (query2 != null) list.add(query2);
    query.and(list);
    query.order = "createdAt";
    query.orderValue = -1; // 排序顺序 如果是时间，-1 则是最新时开始 1 最远时间开始
    query.skip = 0;
    query.limit = maxLines;
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    // query.addWhereEqualTo("title", "博客标题");
    List<dynamic> data = await query.queryObjects();
    Utility.print(data.toString());
    List<TimelineMissionModel> missionModels =
        data.map((i) => TimelineMissionModel.fromJson(i)).toList();
    missionModels.forEach((element) {
      if (TextUtil.isEmpty(element.uid) == true) {
        element.uid =
            !TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? LoginManager.getInstance().getUserBean().uid
                : '';
      }
      if (TextUtil.isEmpty(this.device_id) == false) {
        element.device_id = this.device_id;
      }
      if (element.no_tomotoes_finished == null)
        element.no_tomotoes_finished = 0;
      if (element.total_tomotoes == null) element.total_tomotoes = 0;
      if (element.tomato_duration == null) element.tomato_duration = 0;
      if (element.order_index == null) element.order_index = 0;
      if (element.end_time == null) element.end_time = 0;
      if (element.alert_time == null) element.alert_time = 0;
    });

    this.listTimelineMissionModel = missionModels;
    Utility.getGlobalContext().read<GlobalStateEnv>().listTimelineMissionModel =
        this.listTimelineMissionModel;
    Utility.initCalendarModel();
    if (callback != null) {
      callback(missionModels);
    }
    return missionModels;
  }

  ///等于条件查询
  List<StatsModel> queryWhereEqual_statModelsByTime(
      {String? folder_id,
      int? start_endTime,
      int? end_endTime,
      int type = 0,
      callback}) {
    List<StatsModel> list = [];
    for (int i = 0; i < this.listStatsModels.length; i++) {
      StatsModel model = this.listStatsModels[i];
      if (start_endTime != null && end_endTime != null) {
        if (start_endTime != null &&
            Utility.getTimestampFromDateTime(model.updatedAt!) >=
                start_endTime) {
          if (end_endTime != null &&
              Utility.getTimestampFromDateTime(model.updatedAt!) <=
                  end_endTime) {
            if (folder_id == null ||
                (folder_id == model.folder_id &&
                    folder_id != null &&
                    folder_id.isNotEmpty)) {
              if (model.type == type) {
                list.add(model);
              }
            }
          }
        }
      } else if (start_endTime != null && end_endTime == null) {
        if (Utility.getTimestampFromDateTime(model.updatedAt!) >=
            start_endTime) {
          if (folder_id == null ||
              (folder_id == model.folder_id &&
                  folder_id != null &&
                  folder_id.isNotEmpty)) {
            if (model.type == type) {
              list.add(model);
            }
          }
        }
      } else if (start_endTime == null && end_endTime != null) {
        if (Utility.getTimestampFromDateTime(model.updatedAt!) <= end_endTime) {
          if (folder_id == null ||
              (folder_id == model.folder_id &&
                  folder_id != null &&
                  folder_id.isNotEmpty)) {
            if (model.type == type) {
              list.add(model);
            }
          }
        }
      } else {
        if (folder_id == null ||
            (folder_id == model.folder_id &&
                folder_id != null &&
                folder_id.isNotEmpty)) {
          if (model.type == type) {
            list.add(model);
          }
        }
      }
    }
    return list;
  }

  ///等于条件查询
  Future<List<StatsModel>> queryWhereEqual_statsModel(
      {type = 0,
      tagName,
      category,
      shouldRefresh = true,
      value,
      callback}) async {
    if (shouldRefresh == false && this.hasLoadedStatsModels == true) {
      return this.listStatsModels;
    }
    MongoDbQuery<StatsModel> query = MongoDbQuery();
    MongoDbQuery<StatsModel>? query1;
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    if (uid?.isNotEmpty == true) {
      query1 = MongoDbQuery();
      query1.addWhereEqualTo("uid", uid ?? "");
    }
    // if (TextUtil.isEmpty(tagName) != true) {
    //   query.addWhereEqualTo("tagName", tagName);
    // }
    // if (TextUtil.isEmpty(title) != true) {
    //   query.addWhereEqualTo("title", title);
    // }
    // if (TextUtil.isEmpty(begin_time) != true) {
    //   query.addWhereEqualTo("_id", begin_time);
    // }
    // if (TextUtil.isEmpty(finish_time) != true) {
    //   query.addWhereEqualTo("tagId", finish_time);
    // }
    MongoDbQuery<StatsModel> query2 = MongoDbQuery();
    query2.addWhereEqualTo("device_id", this.device_id ?? "");

    List<MongoDbQuery<StatsModel>> list = [];
    if (query1 != null) {
      list.add(query1);
    }
    list.add(query2);
    query.or(list);
    query.skip = 0;
    query.limit = 100000;
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    // query.addWhereEqualTo("title", "博客标题");
    List<dynamic> data = await query.queryObjects();
    // print(data.toString());
    List<StatsModel> listStatsModels = data.map((i) {
      return StatsModel.fromJson(i);
    }).toList();
    this.listStatsModels = listStatsModels;
    listStatsModels.forEach((element) {
      if (element.title == null) element.title = '';
      if (element.type == null) element.type = 0;
      if (element.color == null) element.color = 0;
      if (element.icon == null) element.icon = 0;
      if (element.device_id == null) element.device_id = this.device_id;
      if (TextUtil.isEmpty(element.uid) == true) {
        element.uid =
            !TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? LoginManager.getInstance().getUserBean().uid
                : '';
      }
      if (TextUtil.isEmpty(this.device_id) == false) {
        element.device_id = this.device_id;
      }
    });
    hasLoadedStatsModels = true;
    if (callback != null) {
      callback(listStatsModels);
    }
    return listStatsModels;
  }

  ///等于条件查询
  List<FolderModel> queryWhereEqual_folderModelWithTag({callback}) {
    List<FolderModel> list = [];
    for (int i = 0; i < this.listFolderModels.length; i++) {
      FolderModel folderModel = this.listFolderModels[i];
      if (folderModel.tag == 2) {
        list.add(folderModel);
      }
    }
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  List<WQBFolderModel> queryWhereEqual_WQBFolderModelWithTag({callback}) {
    List<WQBFolderModel> list = [];
    for (int i = 0; i < this.listWQBFolderModel.length; i++) {
      WQBFolderModel folderModel = this.listWQBFolderModel[i];
      if (folderModel.tag == 2) {
        list.add(folderModel);
      }
    }
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  ///等于条件查询
  //1-表示各种图案circle mission;2-表示的是 tag;null-今天 明天 即将到来
  FolderModel? queryWhereEqual_folderModelWithFolderIdOfMission(folder_id, tag,
      {callback}) {
    List<FolderModel> listFolderModel = [];
    for (int i = 0; i < this.listFolderModels.length; i++) {
      FolderModel folderModel = this.listFolderModels[i];
      if (folderModel.objectId == folder_id && folderModel.tag == tag) {
        return folderModel;
      }
    }
    return null;
  }

  //1-表示各种图案circle mission;2-表示的是 tag;null-今天 明天 即将到来
  WQBFolderModel? queryWhereEqual_WQBFolderModelWithFolderIdOfMission(
      folder_id, tag,
      {callback}) {
    List<WQBFolderModel> listFolderModel = [];
    for (int i = 0; i < this.listFolderModels.length; i++) {
      WQBFolderModel folderModel = this.listWQBFolderModel[i];
      if (folderModel.objectId == folder_id && folderModel.tag == tag) {
        return folderModel;
      }
    }
    return null;
  }

  FolderModel? queryfolderModelWithMissionModelId(mission_id, {callback}) {
    MissionModel? missionModel =
        queryWhereEqual_missionDataByObjectId(objectId: mission_id);
    if (missionModel == null) {
      return null;
    }
    return queryfolderModelWithFolderId(missionModel.folder_id);
  }

  FolderModel? queryfolderModelWithFolderTitle(folder_title, {callback}) {
    for (int i = 0; i < this.listFolderModels.length; i++) {
      FolderModel folderModel = this.listFolderModels[i];
      if (folderModel.title?.contains(folder_title) == true ||
          folder_title?.contains(folderModel.title) == true) {
        return folderModel;
      }
    }
    return null;
  }

  FolderModel? queryfolderModelWithFolderId(folder_id, {callback}) {
    List<FolderModel> listFolderModel = [];
    for (int i = 0; i < this.listFolderModels.length; i++) {
      FolderModel folderModel = this.listFolderModels[i];
      if (folderModel.objectId == folder_id) {
        return folderModel;
      }
    }
    return null;
  }

  WQBFolderModel? queryWQBFolderModelWithFolderId(folder_id, {callback}) {
    List<WQBFolderModel> listFolderModel = [];
    for (int i = 0; i < this.listWQBFolderModel.length; i++) {
      WQBFolderModel folderModel = this.listWQBFolderModel[i];
      if (folderModel.objectId == folder_id) {
        return folderModel;
      }
    }
    return null;
  }

  ///等于条件查询
  List<FolderModel> queryWhereEqual_folderModelWithFolderId(folder_id,
      {Function? callback}) {
    List<FolderModel> listFolderModel = [];
    for (int i = 0; i < this.listFolderModels.length; i++) {
      FolderModel folderModel = this.listFolderModels[i];
      if (folderModel.objectId == folder_id) {
        listFolderModel.add(folderModel);
      }
    }
    return listFolderModel;
  }

  ///等于条件查询
  List<WQBFolderModel> queryWhereEqual_WQBFolderModelWithFolderId(folder_id,
      {callback}) {
    List<WQBFolderModel> listFolderModel = [];
    for (int i = 0; i < this.listWQBFolderModel.length; i++) {
      WQBFolderModel folderModel = this.listWQBFolderModel[i];
      if (folderModel.objectId == folder_id) {
        listFolderModel.add(folderModel);
      }
    }
    return listFolderModel;
  }

  ///等于条件查询
  List<FolderModel> queryWhereEqual_folderModelWithCircle({callback}) {
    List<FolderModel> list = [];
    for (int i = 0; i < this.listFolderModels.length; i++) {
      FolderModel folderModel = this.listFolderModels[i];
      if (folderModel.tag == 1) {
        list.add(folderModel);
      }
    }
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  ///等于条件查询
  List<FolderModel> queryWhereEqual_folderModelWithFolderTag({callback}) {
    List<FolderModel> list = [];
    for (int i = 0; i < this.listFolderModels.length; i++) {
      FolderModel folderModel = this.listFolderModels[i];
      if (folderModel.tag == 3) {
        list.add(folderModel);
      }
    }
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  List<WQBFolderModel> queryWhereEqual_wqbfolderModelWithCircle({callback}) {
    List<WQBFolderModel> list = [];
    for (int i = 0; i < this.listWQBFolderModel.length; i++) {
      WQBFolderModel folderModel = this.listWQBFolderModel[i];
      if (folderModel.tag == 1) {
        list.add(folderModel);
      }
    }
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  /**
   * shouldRefresh 是否需要更新
   * 主要folderpage进入页面会不断请求这个api
   * 但是如果有数据就不需要刷新
   */
  Future<List<FolderModel>> queryWhereEqual_folderModel(
      {shouldRefresh = true, callback}) async {
    if (TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid) ==
            true &&
        TextUtil.isEmpty(this.device_id) == true) {
      return [];
    }
    if (shouldRefresh == false && this.hasLoadedFolderModels == true)
      return this.listFolderModels;
    List<MongoDbQuery<FolderModel>> list = [];
    MongoDbQuery<FolderModel> query1 = MongoDbQuery();
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    if (uid?.isNotEmpty == true) {
      query1.addWhereEqualTo("uid", uid ?? "");
      list.add(query1);
    }
    if (!TextUtil.isEmpty(this.device_id)) {
      MongoDbQuery<FolderModel> query2 = MongoDbQuery();
      query2.addWhereEqualTo(
          "device_id", this.device_id ?? ""); //todo 这里有问题 闪屏页进来拿到空的数据
      list.add(query2);
    }

    MongoDbQuery<FolderModel> query3 = MongoDbQuery();
    if (uid?.isNotEmpty == true) {
      query3.addWhereEqualTo("otherUids", uid ?? "");
      list.add(query3);
    }

    MongoDbQuery<FolderModel> query = MongoDbQuery();
    query.or(list);
    query.skip = 0;
    query.limit = 100000;
    List<dynamic> data = await query.queryObjects();
    List<FolderModel> folderModelList = [];
    try {
      folderModelList = data.map((i) => FolderModel.fromJson(i)).toList();
    } catch (e) {
      Utility.print(e);
    }
    folderModelList.forEach((element) {
      if (TextUtil.isEmpty(element.uid) == true) {
        element.uid =
            !TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? LoginManager.getInstance().getUserBean().uid
                : '';
      }
      if (TextUtil.isEmpty(this.device_id) == false) {
        element.device_id = this.device_id;
      }
      if (element.color == null) element.color = 0;
      if (element.update_time == null) element.update_time = 0;
      if (element.create_time == null) element.create_time = 0;
      if (element.tagColor == null) element.tagColor = 0;
      if (element.tag == null) element.tag = 0;
      if (element.icon == null) element.icon = 0;
    });
    this.hasLoadedFolderModels = true;
    // folderModelList = await CryptoManager.getInstance().batchDecryptFolderModels(folderModelList);
    this.listFolderModels = folderModelList;
    Utility.getGlobalContext().read<GlobalStateEnv>().listFolderModels =
        folderModelList;
    // eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    if (callback != null) {
      callback(folderModelList);
    }
    return folderModelList;
  }

  Future<List<WQBFolderModel>> queryWhereEqual_WQBFolderModel(
      {shouldRefresh = true, callback}) async {
    if (TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid) ==
            true &&
        TextUtil.isEmpty(this.device_id) == true) {
      return [];
    }
    if (shouldRefresh == false && this.hasLoadedWQBFolderModels == true)
      return this.listWQBFolderModel;
    List<MongoDbQuery<WQBFolderModel>> list = [];
    MongoDbQuery<WQBFolderModel> query1 = MongoDbQuery();
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    if (uid?.isNotEmpty == true) {
      query1.addWhereEqualTo("uid", uid ?? "");
      list.add(query1);
    }
    if (!TextUtil.isEmpty(this.device_id)) {
      MongoDbQuery<WQBFolderModel> query2 = MongoDbQuery();
      query2.addWhereEqualTo(
          "device_id", this.device_id ?? ""); //todo 这里有问题 闪屏页进来拿到空的数据
      list.add(query2);
    }

    MongoDbQuery<WQBFolderModel> query3 = MongoDbQuery();
    if (uid?.isNotEmpty == true) {
      query3.addWhereEqualTo("otherUids", uid ?? "");
      list.add(query3);
    }

    MongoDbQuery<WQBFolderModel> query = MongoDbQuery();
    query.or(list);
    query.skip = 0;
    query.limit = 100000;
    List<dynamic> data = await query.queryObjects();
    List<WQBFolderModel> folderModelList = [];
    try {
      folderModelList = data.map((i) => WQBFolderModel.fromJson(i)).toList();
    } catch (e) {
      Utility.print(e);
    }
    folderModelList.forEach((element) {
      if (TextUtil.isEmpty(element.uid) == true) {
        element.uid =
            !TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? LoginManager.getInstance().getUserBean().uid
                : '';
      }
      if (TextUtil.isEmpty(this.device_id) == false) {
        element.device_id = this.device_id;
      }
      if (element.color == null) element.color = 0;
      if (element.update_time == null) element.update_time = 0;
      if (element.create_time == null) element.create_time = 0;
      if (element.tagColor == null) element.tagColor = 0;
      if (element.tag == null) element.tag = 0;
      if (element.icon == null) element.icon = 0;
    });
    this.hasLoadedWQBFolderModels = true;
    this.listWQBFolderModel = folderModelList;
    Utility.getGlobalContext().read<GlobalStateEnv>().listWQBFolderModel =
        folderModelList;
    // eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    if (callback != null) {
      callback(folderModelList);
    }
    return folderModelList;
  }

  Future<List<CreditCardModel>> queryWhereEqual_creditModel(
      {shouldRefresh = true, callback}) async {
    if (shouldRefresh == false && this.hasLoadedCreditCardModels == true)
      return this.listCreditCardModel;
    List<MongoDbQuery<CreditCardModel>> list = [];
    MongoDbQuery<CreditCardModel> query1 = MongoDbQuery();
    String uid = LoginManager.getInstance().getUid();
    if (uid.isNotEmpty == true) {
      query1.addWhereEqualTo("uid", uid);
      list.add(query1);
    }
    MongoDbQuery<CreditCardModel> query2 = MongoDbQuery();
    query2.addWhereEqualTo(
        "device_id", this.device_id ?? ""); //todo 这里有问题 闪屏页进来拿到空的数据
    list.add(query2);
    MongoDbQuery<CreditCardModel> query = MongoDbQuery();
    query.or(list);
    query.skip = 0;
    query.limit = 100000;
    List<dynamic> data = await query.queryObjects();
    List<CreditCardModel> creditCardModelList =
        data.map((i) => CreditCardModel.fromJson(i)).toList();
    creditCardModelList.forEach((element) {
      if (TextUtil.isEmpty(element.uid) == true) {
        element.uid = LoginManager.getInstance().getUid();
      }
      if (TextUtil.isEmpty(this.device_id) == false) {
        element.device_id = this.device_id;
      }
      // if (element.update_time == null) element.update_time = 0;
      // if (element.create_time == null) element.create_time = 0;
    });
    this.hasLoadedCreditCardModels = true;
    this.listCreditCardModel = creditCardModelList;
    if (callback != null) {
      callback(listCreditCardModel);
    }
    context?.read<GlobalStateEnv>().listCreditCardModel = creditCardModelList;
    return listCreditCardModel;
  }

  Future<List<GroupModel>> queryWhereEqual_groupModel(
      {shouldRefresh = true, callback}) async {
    if (shouldRefresh == false && this.hasLoadedGroupModels == true)
      return this.listGroupModel;
    List<MongoDbQuery<GroupModel>> list = [];
    MongoDbQuery<GroupModel> query1 = MongoDbQuery();
    String uid = LoginManager.getInstance().getUid();
    if (uid.isNotEmpty == true) {
      query1.addWhereEqualTo("uid", uid);
      list.add(query1);
    }
    MongoDbQuery<GroupModel> query2 = MongoDbQuery();
    query2.addWhereEqualTo(
        "device_id", this.device_id ?? ""); //todo 这里有问题 闪屏页进来拿到空的数据
    list.add(query2);
    MongoDbQuery<GroupModel> query = MongoDbQuery();
    query.or(list);
    query.skip = 0;
    query.limit = 100000;
    List<dynamic> data = await query.queryObjects();
    List<GroupModel> groupModelList =
        data.map((i) => GroupModel.fromJson(i)).toList();
    groupModelList.forEach((element) {
      if (TextUtil.isEmpty(element.uid) == true) {
        element.uid = LoginManager.getInstance().getUid();
      }
      if (TextUtil.isEmpty(this.device_id) == false) {
        element.device_id = this.device_id;
      }
      // if (element.update_time == null) element.update_time = 0;
      // if (element.create_time == null) element.create_time = 0;
    });
    this.hasLoadedGroupModels = true;
    this.listGroupModel = groupModelList;
    if (callback != null) {
      callback(listGroupModel);
    }
    context?.read<GlobalStateEnv>().listGroupModel = listGroupModel;
    return listGroupModel;
  }

  Future<List<ChatGptFolderModel>> queryWhereEqual_ChatGptFolderModel(
      {shouldRefresh = true, callback}) async {
    if (shouldRefresh == false && this.hasLoadedChatGptFolderModel == true)
      return this.listChatGptFolderModel;
    List<MongoDbQuery<ChatGptFolderModel>> list = [];
    MongoDbQuery<ChatGptFolderModel> query1 = MongoDbQuery();
    String uid = LoginManager.getInstance().getUid();
    if (uid.isNotEmpty == true) {
      query1.addWhereEqualTo("uid", uid);
      list.add(query1);
    }
    // MongoDbQuery<BillModel> query2 = MongoDbQuery();
    // query2.addWhereEqualTo(
    //     "device_id", this.device_id ?? ""); //todo 这里有问题 闪屏页进来拿到空的数据
    // list.add(query2);
    MongoDbQuery<ChatGptFolderModel> query = MongoDbQuery();
    // query.or(list);
    query.skip = 0;
    query.limit = 100000;
    List<dynamic> data = await query.queryObjects();
    List<ChatGptFolderModel> listChatGptFolderModel =
    data.map((i) => ChatGptFolderModel.fromJson(i)).toList();
    listChatGptFolderModel.forEach((element) {
      if (TextUtil.isEmpty(element.uid) == true) {
        element.uid = LoginManager.getInstance().getUid();
      }
      // if (TextUtil.isEmpty(this.device_id) == false) {
      //   element.device_id = this.device_id;
      // }
      // if (element.update_time == null) element.update_time = 0;
      // if (element.create_time == null) element.create_time = 0;
    });
    this.hasLoadedChatGptFolderModel = true;
    this.listChatGptFolderModel = listChatGptFolderModel;
    if (callback != null) {
      callback(listChatGptFolderModel);
    }
    context?.read<GlobalStateEnv>().listChatGptFolderModel = listChatGptFolderModel;
    return listChatGptFolderModel;
  }

  Future<List<BillModel>> queryWhereEqual_billModel(
      {shouldRefresh = true, callback}) async {
    if (shouldRefresh == false && this.hasLoadedBillModel == true)
      return this.listBillModel;
    List<MongoDbQuery<BillModel>> list = [];
    MongoDbQuery<BillModel> query1 = MongoDbQuery();
    String uid = LoginManager.getInstance().getUid();
    if (uid.isNotEmpty == true) {
      query1.addWhereEqualTo("uid", uid);
      list.add(query1);
    }
    MongoDbQuery<BillModel> query2 = MongoDbQuery();
    query2.addWhereEqualTo(
        "device_id", this.device_id ?? ""); //todo 这里有问题 闪屏页进来拿到空的数据
    list.add(query2);
    MongoDbQuery<BillModel> query = MongoDbQuery();
    query.or(list);
    query.skip = 0;
    query.limit = 100000;
    List<dynamic> data = await query.queryObjects();
    List<BillModel> billModelList =
        data.map((i) => BillModel.fromJson(i)).toList();
    billModelList.forEach((element) {
      if (TextUtil.isEmpty(element.uid) == true) {
        element.uid = LoginManager.getInstance().getUid();
      }
      if (TextUtil.isEmpty(this.device_id) == false) {
        element.device_id = this.device_id;
      }
      // if (element.update_time == null) element.update_time = 0;
      // if (element.create_time == null) element.create_time = 0;
    });
    this.hasLoadedBillModel = true;
    this.listBillModel = billModelList;
    if (callback != null) {
      callback(listCreditCardModel);
    }
    context?.read<GlobalStateEnv>().listBillModel = listBillModel;
    return listBillModel;
  }

  /**
   * shouldRefresh 是否需要更新
   * 主要PresentModel进入页面会不断请求这个api
   * 但是如果有数据就不需要刷新
   */
  Future<List<PresentModel>> queryWhereEqual_presentModel(
      {shouldRefresh = true, callback}) async {
    if (shouldRefresh == false && this.hasLoadedPresentModels == true)
      return this.listPresentModel;
    List<MongoDbQuery<PresentModel>> list = [];
    MongoDbQuery<PresentModel> query1 = MongoDbQuery();
    String uid = LoginManager.getInstance().getUid();
    if (uid.isNotEmpty == true) {
      query1.addWhereEqualTo("uid", uid);
      list.add(query1);
    }
    MongoDbQuery<PresentModel> query2 = MongoDbQuery();
    query2.addWhereEqualTo(
        "device_id", this.device_id ?? ""); //todo 这里有问题 闪屏页进来拿到空的数据
    list.add(query2);
    MongoDbQuery<PresentModel> query = MongoDbQuery();
    query.or(list);
    query.skip = 0;
    query.limit = 100000;
    List<dynamic> data = await query.queryObjects();
    List<PresentModel> presentModelList =
        data.map((i) => PresentModel.fromJson(i)).toList();
    presentModelList.forEach((element) {
      if (TextUtil.isEmpty(element.uid) == true) {
        element.uid = LoginManager.getInstance().getUid();
      }
      if (TextUtil.isEmpty(this.device_id) == false) {
        element.device_id = this.device_id;
      }
      if (element.update_time == null) element.update_time = 0;
      if (element.create_time == null) element.create_time = 0;
    });
    this.hasLoadedPresentModels = true;
    this.listPresentModel = presentModelList;
    if (callback != null) {
      callback(presentModelList);
    }
    return presentModelList;
  }

  Future<List<PresentModel>> queryWhereEqual_presentModelWithLottery(
      {callback}) async {
    List<PresentModel> list = [];
    for (int i = 0; i < this.listPresentModel.length; i++) {
      if (this.listPresentModel?[i]?.isLottery ?? false) {
        list.add(this.listPresentModel[i]);
      }
    }
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  Future<bool> isTagNameExist_wqbfolderModel({title, callback}) async {
    MongoDbQuery<WQBFolderModel> query = MongoDbQuery();
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    query.addWhereEqualTo("uid", uid ?? '');
    query.addWhereEqualTo("title", title);

    query.setLimit(1);
    query.setSkip(0);
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    // query.addWhereEqualTo("title", "博客标题");
    List<dynamic> data = await query.queryObjects();
    // print(data.toString());
    List<WQBFolderModel> folderModelList =
        data.map((i) => WQBFolderModel.fromJson(i)).toList();
    for (WQBFolderModel folderModel in folderModelList) {
      if (folderModel != null) {
        // print(folderModel.objectId);
        // print(folderModel.title);
        // print(missionModel.content);
      }
    }
    if (callback != null) {
      callback(folderModelList.length > 0 ? true : false);
    }
    return folderModelList.length > 0 ? true : false;
  }

  Future<bool> isTagNameExist_folderModel({title, callback}) async {
    MongoDbQuery<FolderModel> query = MongoDbQuery();
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    query.addWhereEqualTo("uid", uid ?? '');
    query.addWhereEqualTo("title", title);

    query.setLimit(1);
    query.setSkip(0);
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    // query.addWhereEqualTo("title", "博客标题");
    List<dynamic> data = await query.queryObjects();
    // print(data.toString());
    List<FolderModel> folderModelList =
        data.map((i) => FolderModel.fromJson(i)).toList();
    for (FolderModel folderModel in folderModelList) {
      if (folderModel != null) {
        // print(folderModel.objectId);
        // print(folderModel.title);
        // print(missionModel.content);
      }
    }
    if (callback != null) {
      callback(folderModelList.length > 0 ? true : false);
    }
    return folderModelList.length > 0 ? true : false;
  }

  ///修改一条数据
  update_EndTimeMissionModel(
      {required EndTimeMissionModel missionModel,
      Function? callback,
      currentObjectId}) async {
    EndTimeMissionModel endTimeMissionModel =
        missionModel ?? EndTimeMissionModel();
    if (!TextUtil.isEmpty(currentObjectId)) {
      endTimeMissionModel.objectId = currentObjectId;
    }

    // missionModelTmp.update_time = Utility.getTimeStamp();
    endTimeMissionModel.uid =
        TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
            ? ''
            : LoginManager.getInstance().getUserBean().uid;
    MongoDbUpdated bmobUpdated = await endTimeMissionModel.update();
    await queryWhereEqual_EndTimeMissionModel(
      shouldRefresh: true,
    ); //更新 missionModels
    if (callback != null) {
      callback(bmobUpdated);
    }
    print("修改一条数据成功：${bmobUpdated.message}");
    return bmobUpdated;
  }

  /**
   *  更新messages [{"date": 时间戳, satisfaction: "", message: ""}]
   */
  update_FlomoMissionModelMessage(
      {required String ymd,
      required FlomoMissionModel flomoMissionModel,
      required String satisfaction,
      required String message}) async {
    List? messages = flomoMissionModel.messages;
    if (messages == null) {
      messages = [];
    }
    messages.add({
      "ymd": ymd,
      "date": DateTime.now().millisecondsSinceEpoch,
      "satisfaction": satisfaction,
      "message": message
    });
    flomoMissionModel.messages = messages;
    await update_FlomoMissionModel(missionModel: flomoMissionModel);
  }

  /**
   * 更新打卡次数 [{"2023-01-02": [{numClock, totalClocks, timestamp}] }]
   * 自加1
   * numClock: 今天打卡次数
   * totalClocks: 总打卡次数
   * timestamp: 今天的时间戳
   */
  update_FlomoMissionModelClocksIn(
      {required FlomoMissionModel flomoMissionModel,
      String? ymd,
      Function? callback}) async {
    if (ymd == null) {
      ymd = Utility.getYMDToday();
    }
    DateTime dateTimeStart = Utility.getFilterDateTimeFromTimeStamp(
        flomoMissionModel.start_time ?? 0);
    DateTime dateTimeEnd = Utility.getFilterDateTimeFromTimeStamp(
        flomoMissionModel.end_time ?? 0, true);
    DateTime dateTime = DateTime.parse(ymd);
    if (dateTime.isBefore(dateTimeStart) || dateTime.isAfter(dateTimeEnd)) {
      return;
    }
    //如果打卡时间大于当前时间，不允许打卡
    if (Utility.isProductEnv() &&
        dateTime.millisecondsSinceEpoch >
            Utility.getFilterDateTimeFromTimeStamp(
                    DateTime.now().millisecondsSinceEpoch ?? 0, true)
                .millisecondsSinceEpoch) {
      Utility.showToast(msg: getI18NKey().time_not_arrive_cannot_clcokin);
      return;
    }
    // String ymd = Utility.getYMDToday();
    List clockInList = flomoMissionModel.clockIn?[ymd] ?? [];
    // MongoDbSaved? res = await MongoApisManager.getInstance()
    //     .insertTimelineMissionModel(
    //     missionModel: Utility.getTimelineMissionModelFromMissionModel(
    //         icon: Icons.check_circle.codePoint,
    //         color: Colors.greenAccent.value,
    //         sceneType: "mission",
    //         eventType: "clockin_time",
    //         timelineMessage: getI18NKey().create_name_flomo_mission(clockInList.length, flomoMissionModel.daily_num_times, flomoMissionModel.title ?? "?")));

    if (clockInList.length >= flomoMissionModel.daily_num_times) {
      return;
    }
    clockInList.add({
      "numClock": ((flomoMissionModel.clockIn?.length ?? 0) + 1),
      "totalClocks": (flomoMissionModel?.daily_num_times ?? 0) + 1,
      "timestamp": Utility.getTimeStampToday()
    });
    if (flomoMissionModel.clockIn == null) {
      flomoMissionModel.clockIn = {};
    }
    flomoMissionModel.clockIn?[ymd] = clockInList;
    callback?.call();
    await update_FlomoMissionModel(missionModel: flomoMissionModel);
  }

  ///修改一条数据
  update_FlomoMissionModel(
      {required FlomoMissionModel missionModel,
      Function? callback,
      currentObjectId}) async {
    FlomoMissionModel flomoMissionModel = missionModel ?? FlomoMissionModel();
    if (!TextUtil.isEmpty(currentObjectId)) {
      flomoMissionModel.objectId = currentObjectId;
    }

    // missionModelTmp.update_time = Utility.getTimeStamp();
    flomoMissionModel.uid =
        TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
            ? ''
            : LoginManager.getInstance().getUserBean().uid;
    MongoDbUpdated bmobUpdated = await flomoMissionModel.update();
    await queryWhereEqual_FlomoMissionModel(
      shouldRefresh: true,
    ); //更新 missionModels
    if (callback != null) {
      callback(bmobUpdated);
    }
    print("修改一条数据成功：${bmobUpdated.message}");
    return bmobUpdated;
  }

  ///修改一条数据
  update_TimelineMissionModel(
      {required TimelineMissionModel missionModel,
      Function? callback,
      currentObjectId}) async {
    TimelineMissionModel timelineMissionModel =
        missionModel ?? TimelineMissionModel();
    if (!TextUtil.isEmpty(currentObjectId)) {
      timelineMissionModel.objectId = currentObjectId;
    }

    // missionModelTmp.update_time = Utility.getTimeStamp();
    timelineMissionModel.uid =
        TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
            ? ''
            : LoginManager.getInstance().getUserBean().uid;
    MongoDbUpdated bmobUpdated = await timelineMissionModel.update();
    await queryWhereEqual_TimelineMissionModel(
      shouldRefresh: true,
    ); //更新 missionModels
    if (callback != null) {
      callback(bmobUpdated);
    }
    print("修改一条数据成功：${bmobUpdated.message}");
    return bmobUpdated;
  }

  Future<MongoDbSaved?> insertFolderModel(
      {FolderModel? folderModel, Function? callback}) async {
    try {
      if ((this.device_id == null || this.device_id?.isEmpty == true) &&
          LoginManager.isLogin() == false) {
        Utility.showToast(msg: getI18NKey().loginFirst);
        LoginManager.getInstance()
            .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
        // Utility.pushNavigator(Utility.getGlobalContext(), new LoginPage(), callback: (res) {
        // });
        return null;
      }
      FolderModel missionModelTmp = folderModel ?? FolderModel();
      missionModelTmp.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      missionModelTmp.device_id = this.device_id;

      MongoDbSaved? bmobSaved = await missionModelTmp.save();
      await queryWhereEqual_folderModel(shouldRefresh: true);
      String message =
          "创建一条数据成功：${bmobSaved?.objectId} - ${bmobSaved?.createdAt}";
      // print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      return bmobSaved;
    } catch (e) {
      return null;
      // throw new Error();
    } finally {
      // await dbUtil.close();
    }
  }

  Future<MongoDbSaved?> insertEndTimeMissionModel(
      {EndTimeMissionModel? missionModel, Function? callback}) async {
    try {
      if ((this.device_id == null || this.device_id?.isEmpty == true) &&
          LoginManager.isLogin() == false) {
        Utility.showToast(msg: getI18NKey().loginFirst);
        LoginManager.getInstance()
            .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
        // Utility.pushNavigator(Utility.getGlobalContext(), new LoginPage(), callback: (res) {
        // });
        return null;
      }
      EndTimeMissionModel missionModelTmp =
          missionModel ?? EndTimeMissionModel();
      missionModelTmp.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      missionModelTmp.device_id = this.device_id;

      MongoDbSaved? bmobSaved = await missionModelTmp.save();
      await queryWhereEqual_EndTimeMissionModel(
        shouldRefresh: true,
      ); //更新 missionModels
      String message =
          "创建一条数据成功：${bmobSaved?.objectId} - ${bmobSaved?.createdAt}";
      // print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      return bmobSaved;
    } catch (e) {
      return null;
      // throw new Error();
    } finally {
      // await dbUtil.close();
    }
  }

  Future<MongoDbSaved?> insertFlomoMissionModel(
      {required FlomoMissionModel missionModel, Function? callback}) async {
    try {
      if ((this.device_id == null || this.device_id?.isEmpty == true) &&
          LoginManager.isLogin() == false) {
        Utility.showToast(msg: getI18NKey().loginFirst);
        LoginManager.getInstance()
            .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
        // Utility.pushNavigator(Utility.getGlobalContext(), new LoginPage(), callback: (res) {
        // });
        return null;
      }
      FlomoMissionModel missionModelTmp = missionModel ?? FlomoMissionModel();
      missionModelTmp.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      missionModelTmp.device_id = this.device_id;

      MongoApisManager.getInstance().insertTimelineMissionModel(
          missionModel: Utility.getTimelineMissionModelFromMissionModel(
              icon: Icons.check_circle.codePoint,
              color: Colors.greenAccent.value,
              sceneType: "mission",
              eventType: "create_flomo_mission",
              timelineMessage: getI18NKey()
                  .create_name_flomomission2(missionModel.title ?? "?")));

      MongoDbSaved? bmobSaved = await missionModelTmp.save();
      await queryWhereEqual_FlomoMissionModel(
        shouldRefresh: true,
      ); //更新 missionModels
      String message =
          "创建一条数据成功：${bmobSaved?.objectId ?? ""} - ${bmobSaved?.createdAt ?? ""}";
      // print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      return bmobSaved;
    } catch (e) {
      return null;
      // throw new Error();
    } finally {
      // await dbUtil.close();
    }
  }

  List<GroupModel> queryGroupModelsByFolderId({String folderId = ""}) {
    List<GroupModel> groupModels = [];
    if (folderId == null || folderId.isEmpty == true) {
      return groupModels;
    }
    for (GroupModel groupModel in this.listGroupModel) {
      if (groupModel.folder_id == folderId) {
        groupModels.add(groupModel);
      }
    }
    return groupModels;
  }

  List<MissionModel> queryEncryptMissioinModelsByFolderId(
      {String folderId = ""}) {
    List<MissionModel> missionModels = [];
    if (folderId == null || folderId.isEmpty == true) {
      return missionModels;
    }
    for (MissionModel missionModel in this.listMissionModels) {
      if (missionModel.folder_id == folderId &&
          (missionModel.cryptoVersion ?? -1) >= 0) {
        missionModels.add(missionModel);
      }
    }
    return missionModels;
  }

  List<MissionModel> queryMissioinModelsByOtherFolderId({bool? isFinished}) {
    List<MissionModel> missionModels = [];
    for (MissionModel missionModel in this.listMissionModels) {
      if (TextUtil.isEmpty(missionModel.folder_id)) {
        if (isFinished == null) {
          missionModels.add(missionModel);
        } else if (isFinished == missionModel?.isFinished) {
          missionModels.add(missionModel);
        }
      }
    }
    return missionModels;
  }

  List<MissionModel> queryMissioinModelsByFolderId(
      {String folderId = "", bool? isFinished}) {
    List<MissionModel> missionModels = [];
    if (folderId == null || folderId.isEmpty == true) {
      return missionModels;
    }
    for (MissionModel missionModel in this.listMissionModels) {
      if (missionModel.folder_id == folderId) {
        if (isFinished == null) {
          missionModels.add(missionModel);
        } else if (isFinished == missionModel?.isFinished) {
          missionModels.add(missionModel);
        }
      }
    }
    return missionModels;
  }

  List<MissionModel> queryMissioinModelsByWithoutGroupId(
      {String folderId = ""}) {
    List<MissionModel> missionModels = [];
    if (folderId == null || folderId.isEmpty == true) {
      return missionModels;
    }
    for (MissionModel missionModel in this.listMissionModels) {
      if (missionModel.group_id == null ||
          missionModel.group_id?.isEmpty == true) {
        missionModels.add(missionModel);
      }
    }
    return missionModels;
  }

  List<MissionModel> queryMissioinModelsByGroupId({String groupId = ""}) {
    List<MissionModel> missionModels = [];
    if (groupId == null || groupId.isEmpty == true) {
      return missionModels;
    }
    for (MissionModel missionModel in this.listMissionModels) {
      if (missionModel.group_id == groupId) {
        missionModels.add(missionModel);
      }
    }
    return missionModels;
  }

  Future<MongoDbSaved?> insertGroupModelModel(
      {required GroupModel groupModel, Function? callback}) async {
    try {
      if ((this.device_id == null || this.device_id?.isEmpty == true) &&
          LoginManager.isLogin() == false) {
        Utility.showToast(msg: getI18NKey().loginFirst);
        LoginManager.getInstance()
            .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
        // Utility.pushNavigator(Utility.getGlobalContext(), new LoginPage(), callback: (res) {
        // });
        return null;
      }
      // GroupModel groupModel =
      //     groupModel ?? GroupModel();
      groupModel.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      groupModel.device_id = this.device_id;

      MongoDbSaved? bmobSaved = await groupModel.save();
      await queryWhereEqual_groupModel(
        shouldRefresh: true,
      ); //更新 missionModels
      String message =
          "创建一条数据成功：${bmobSaved?.objectId ?? ""} - ${bmobSaved?.createdAt ?? ""}";
      // print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      return bmobSaved;
    } catch (e) {
      return null;
      // throw new Error();
    } finally {
      // await dbUtil.close();
    }
  }

  Future<MongoDbSaved?> insertTimelineMissionModel(
      {required TimelineMissionModel missionModel, Function? callback}) async {
    try {
      if ((this.device_id == null || this.device_id?.isEmpty == true) &&
          LoginManager.isLogin() == false) {
        Utility.showToast(msg: getI18NKey().loginFirst);
        LoginManager.getInstance()
            .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
        // Utility.pushNavigator(Utility.getGlobalContext(), new LoginPage(), callback: (res) {
        // });
        return null;
      }
      TimelineMissionModel missionModelTmp =
          missionModel ?? TimelineMissionModel();
      missionModelTmp.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      missionModelTmp.device_id = this.device_id;

      MongoDbSaved? bmobSaved = await missionModelTmp.save();
      await queryWhereEqual_TimelineMissionModel(
        shouldRefresh: true,
      ); //更新 missionModels
      String message =
          "创建一条数据成功：${bmobSaved?.objectId ?? ""} - ${bmobSaved?.createdAt ?? ""}";
      // print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      return bmobSaved;
    } catch (e) {
      return null;
      // throw new Error();
    } finally {
      // await dbUtil.close();
    }
  }

  Future<MongoDbSaved?> insertWQBMissiontData(
      {required WQBMissionModel missionModel, Function? callback}) async {
    MongoDbSaved? bmobSaved;
    try {
      if (LoginManager.isLogin() == false) {
        Utility.showToast(msg: getI18NKey().loginFirst);
        LoginManager.getInstance()
            .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
        // Utility.pushNavigator(Utility.getGlobalContext(), new LoginPage(), callback: (res) {
        // });
        return null;
      }
      WQBMissionModel missionModelTmp = missionModel ?? WQBMissionModel();
      missionModelTmp.update_time = Utility.getTimeStampToday();
      missionModelTmp.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      missionModelTmp.device_id = this.device_id;

      bmobSaved = await missionModelTmp.save();
      await queryWhereEqual_WQBMissionModel(
        shouldRefresh: true,
      ); //更新 missionModels
      if (callback != null) {
        callback(bmobSaved);
      }
      String? objectId = bmobSaved?.objectId;
      if (objectId?.isEmpty == false) {}
      return bmobSaved;
    } catch (e) {
      return null;
      // throw new Error();
    } finally {
      // await dbUtil.close();
    }
  }

  Future<MongoDbSaved?> insertMissiontData(
      {required MissionModel missionModel, Function? callback}) async {
    MongoDbSaved? bmobSaved;
    try {
      if (LoginManager.isLogin() == false) {
        Utility.showToast(msg: getI18NKey().loginFirst);
        LoginManager.getInstance()
            .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
        // Utility.pushNavigator(Utility.getGlobalContext(), new LoginPage(), callback: (res) {
        // });
        return null;
      }
      //有folderModel的missionModel创建时需要检查是否能通过
      if (!TextUtil.isEmpty(missionModel.folder_id)) {
        bool res = await CryptoManager.getInstance()
            .checkFolderModelSecurityPasswordSetting(
                folderId: missionModel.folder_id);
        //res == false 说明取消了  不再继续
        if (res == false) {
          return null;
        }
      }
      if (!TextUtil.isEmpty(missionModel.folder_id)) {
        // FolderModel判断是不是需要给missionmodel加密
        bool shouldMissionModelEncrypt = CryptoManager.getInstance()
            .shouldMissionModelEncrypt(missionModel.folder_id!);
        if (shouldMissionModelEncrypt) {
          missionModel.cryptoVersion = shouldMissionModelEncrypt ? 0 : -1;
          missionModel = await CryptoManager.getInstance()
              .encryptMissionModelTitle(missionModel);
          // MissionModel model = await CryptoManager.getInstance().decryptMissionModelTitle(missionModel);
          print("");
        }
      }
      MissionModel missionModelTmp = missionModel ?? MissionModel();
      bool validate = validMissionModel(missionModel: missionModelTmp);
      if (validate == false) {
        return null;
      }
      missionModelTmp.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      missionModelTmp.device_id = this.device_id;

      bmobSaved = await missionModelTmp.save();
      await queryWhereEqual_missionData(
        shouldRefresh: true,
      ); //更新 missionModels

      if (TextUtil.isEmpty(missionModelTmp.folder_id) == true) {
        missionModel.objectId = bmobSaved?.objectId;
        MongoDbSaved? res = await MongoApisManager.getInstance()
            .insertTimelineMissionModel(
                missionModel: Utility.getTimelineMissionModelFromMissionModel(
                    icon: Icons.check_circle.codePoint,
                    color: Colors.greenAccent.value,
                    missionModel: missionModel,
                    sceneType: "mission",
                    eventType: "create_mission",
                    timelineMessage: getI18NKey()
                        .create_name_mission2(missionModel.title ?? "?")));
      } else {
        FolderModel? folderModel = MongoApisManager.getInstance()
                .queryWhereEqualFolderModelByObjectId(
                    objectId: missionModelTmp.folder_id) ??
            null;
        missionModel.objectId = bmobSaved?.objectId;
        MongoDbSaved? res = await MongoApisManager.getInstance()
            .insertTimelineMissionModel(
                missionModel: Utility.getTimelineMissionModelFromMissionModel(
                    icon: Icons.check_circle.codePoint,
                    color: Colors.greenAccent.value,
                    missionModel: missionModel,
                    sceneType: "mission",
                    eventType: "create_mission",
                    timelineMessage: getI18NKey().create_name_mission(
                        folderModel?.title ?? "", missionModel.title ?? "?")));
      }
      String message =
          "创建一条数据成功：${bmobSaved?.objectId} - ${bmobSaved?.createdAt}";
      // insertTimelineMissionModel(
      //     missionModel: Utility.getTimelineMissionModelFromMissionModel(
      //         sceneType: "mission",
      //         eventType: "create_mission",
      //         missionModel: missionModel));

      // print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      String? objectId = bmobSaved?.objectId;
      if (objectId?.isEmpty == false) {
        // String id = Utility.getObjectIdWithId(objectId ?? "");
        // if (missionModelTmp.alert_time != null) {
        //   NotificationManager.getInstance().pushNotificationWithWhen(
        //       title: getI18NKey().mission_alert_with_name(
        //           missionModelTmp.title),
        //       content: getI18NKey().your_mission_with_name_has_begun(
        //           missionModelTmp.title),
        //       whenMilliseconds: missionModelTmp.alert_time,
        //       id: id);
        // }
      }
      return bmobSaved;
    } catch (e) {
      return null;
      // throw new Error();
    } finally {
      // await dbUtil.close();
    }
  }

  Future<MongoDbSaved?> insertStatsModel(
      {title,
      fid,
      mission_id,
      type = 0,
      tagName,
      category,
      color,
      icon,
      value,
      begin_time,
      finish_time,
      Function? callback}) async {
    try {
      StatsModel statsModelTmp = StatsModel();
      statsModelTmp.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      statsModelTmp.device_id = this.device_id;
      // if (statsModel == null) {
      statsModelTmp.mission_id = mission_id;
      statsModelTmp.folder_id = fid;
      statsModelTmp.title = title;
      statsModelTmp.value = value;
      statsModelTmp.color = color;
      statsModelTmp.icon = icon;
      statsModelTmp.type = type;
      // missionModel.tagId = tagId;
      statsModelTmp.tagNames = tagName != null ? tagName : '';
      statsModelTmp.begin_time = begin_time;
      statsModelTmp.finish_time = finish_time;
      // }
      // BmobAcl bmobAcl = BmobAcl();
      // bmobAcl.setPublicReadAccess(true);
      // statsModelTmp.setAcl(bmobAcl);

      MongoDbSaved? bmobSaved = await statsModelTmp.save();
      await queryWhereEqual_statsModel(); //更新 missionModels
      String message =
          "创建一条数据成功：${bmobSaved?.objectId} - ${bmobSaved?.createdAt}";
      // print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      return bmobSaved;
    } finally {
      // await dbUtil.close();
    }
  }

  Future<MongoDbSaved?> insertWQBFolderData(
      {id,
      title,
      description,
      number,
      color,
      icon,
      tagName,
      tag,
      order_index,
      no_tomotoes_finished,
      tomato_duration,
      Function? callback}) async {
    try {
      //没登录且deviceId为空， 提示去登录
      if (LoginManager.isLogin() == false) {
        Utility.showToast(msg: getI18NKey().loginFirst);
        LoginManager.getInstance()
            .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
        return null;
      }
      WQBFolderModel folderModel = WQBFolderModel();
      // folderModel.id = id;
      folderModel.title = title;
      folderModel.description = description;
      folderModel.device_id = this.device_id;
      folderModel.number = number;
      folderModel.tag = tag;
      folderModel.icon = icon ?? Icons.local_offer.codePoint;
      folderModel.tagName = tagName;
      folderModel.color = color;
      folderModel.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      folderModel.update_time = Utility.getTimeStampToday();
      folderModel.create_time = Utility.getTimeStampToday();
      User user = User();
      String? uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      user.setObjectId(uid ?? "");
      // BmobAcl bmobAcl = BmobAcl();
      // bmobAcl.setPublicReadAccess(true);
      // folderModel.setAcl(bmobAcl);
      // if (tag == 1) {
      //   insertTimelineMissionModel(
      //       missionModel: TimelineMissionModel(
      //           sceneType: "mission",
      //           eventType: "create_folder_model",
      //           title: folderModel.title,
      //           tagNames: folderModel.tagName,
      //           color: folderModel.color,
      //           icon: folderModel.icon,
      //           tagColor: folderModel.tagColor,
      //           timelineMessage: getI18NKey().create_name_listing(title)));
      // } else if (tag == 2) {
      //   insertTimelineMissionModel(
      //       missionModel: TimelineMissionModel(
      //           sceneType: "mission",
      //           eventType: "create_tag",
      //           title: folderModel.title,
      //           tagNames: folderModel.tagName,
      //           color: folderModel.color,
      //           icon: folderModel.icon,
      //           tagColor: folderModel.tagColor,
      //           timelineMessage: getI18NKey().create_name_tag(title)));
      // }
      if (await isTagNameExist_wqbfolderModel(title: title) == true) {
        if (callback != null) {
          callback(null);
        }
        return null;
      }
      MongoDbSaved? bmobSaved = await folderModel.save();
      await queryWhereEqual_WQBFolderModel(shouldRefresh: true);
      String message =
          "创建一条数据成功：${bmobSaved?.objectId} - ${bmobSaved?.createdAt}";
      // print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      return bmobSaved;
    } catch (e) {
      print(MongoDbError.convert(e)?.error);
    } finally {
      // await dbUtil.close();
    }
  }

  Future<MongoDbSaved?> insertFolderData(
      {id,
      title,
      description,
      number,
      start_time,
      end_time,
      color,
      cryptoVersion,
      layoutType,
      icon,
      tagName,
      tag,
      order_index,
      no_tomotoes_finished,
      tomato_duration,
      bool shouldQuery = true,
      Function? callback}) async {
    try {
      //没登录且deviceId为空， 提示去登录
      if (LoginManager.isLogin() == false) {
        Utility.showToast(msg: getI18NKey().loginFirst);
        LoginManager.getInstance()
            .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
        return null;
      }
      FolderModel folderModel = FolderModel();
      folderModel.layoutType = layoutType;
      // folderModel.id = id;
      folderModel.cryptoVersion = cryptoVersion;
      folderModel.title = title;
      folderModel.description = description;
      folderModel.start_time = start_time;
      folderModel.end_time = end_time;
      folderModel.device_id = this.device_id;
      folderModel.number = number;
      folderModel.tag = tag;
      folderModel.icon = icon ?? Icons.local_offer.codePoint;
      folderModel.tagName = tagName;
      folderModel.color = color;
      folderModel.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      folderModel.update_time = Utility.getTimeStampToday();
      folderModel.create_time = Utility.getTimeStampToday();
      User user = User();
      String? uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      user.setObjectId(uid ?? "");
      // BmobAcl bmobAcl = BmobAcl();
      // bmobAcl.setPublicReadAccess(true);
      // folderModel.setAcl(bmobAcl);
      if (tag == 1) {
        insertTimelineMissionModel(
            missionModel: TimelineMissionModel(
                sceneType: "mission",
                eventType: "create_folder_model",
                title: folderModel.title,
                tagNames: folderModel.tagName,
                color: folderModel.color,
                icon: folderModel.icon,
                tagColor: folderModel.tagColor,
                timelineMessage: getI18NKey().create_name_listing(title)));
      } else if (tag == 2) {
        insertTimelineMissionModel(
            missionModel: TimelineMissionModel(
                sceneType: "mission",
                eventType: "create_tag",
                title: folderModel.title,
                tagNames: folderModel.tagName,
                color: folderModel.color,
                icon: folderModel.icon,
                tagColor: folderModel.tagColor,
                timelineMessage: getI18NKey().create_name_tag(title)));
      }
      if (await isTagNameExist_folderModel(title: title) == true) {
        if (callback != null) {
          callback(null);
        }
        return null;
      }
      MongoDbSaved? bmobSaved = await folderModel.save();
      if (shouldQuery == true)
        await queryWhereEqual_folderModel(shouldRefresh: true);

      String message =
          "创建一条数据成功：${bmobSaved?.objectId} - ${bmobSaved?.createdAt}";
      // print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      return bmobSaved;
    } catch (e) {
      print(MongoDbError.convert(e)?.error);
    } finally {
      // await dbUtil.close();
    }
  }

  finishWQBMissionModel({
    required WQBMissionModel missionModel,
    Function? callback,
  }) async {
    // if (currentObjectId != null) {
    //   MissionModel missionModel = MissionModel();
    //   missionModel.objectId = currentObjectId;
    missionModel.isFinished = true;
    // missionModel.repetiveType = 0; //把重复去掉 以免日历不断显示
    // missionModel.repetiveValue = null;
    // missionModel.end_time_before_finished =
    //     missionModel.end_time; //把SettingItemDetailPage设置的end_time预存
    //如果任务完成时间大于当前时间 则预期
    // if (Utility.getYearMonthAndDayDateTimeByTimestamp(
    //     missionModel?.end_time ?? 0)
    //     .compareTo(Utility.getYearMonthAndDayDateTimeByTimestamp(
    //     Utility.getTimeStampToday())) >
    //     0) {
    //   missionModel.isDelayed = true;
    // }
    // missionModel.finish_time = Utility.getTimeStampToday(); //end_time是真实时间
    // missionModel.update_time = Utility.getTimeStamp();
    missionModel.uid =
        TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
            ? ''
            : LoginManager.getInstance().getUserBean().uid;
    MongoDbUpdated bmobUpdated = await missionModel.update();
    await queryWhereEqual_WQBMissionModel(
      shouldRefresh: true,
    ); //更新 missionModels
    if (callback != null) {
      callback(bmobUpdated);
    }
    print("修改一条数据成功：${bmobUpdated.message}");
    return bmobUpdated;
    // } else {
    //   print("请先新增一条数据");
    //   // showError(context, "请先新增一条数据");
    // }
  }

  /**
   * 完成该任务
   */
  finishMissionModel({
    required BuildContext context,
    required MissionModel missionModel,
    bool? isFinished = true, //用于repeatModel
    bool shouldForceFinishedWithoutRepeativeDialog =
        true, //直接设置missionModel的isFinished 而不是repetiveType > 1的处理
    int? curMonthTimeStamp,
    Function? callback,
  }) async {
    if (curMonthTimeStamp == null) {
      curMonthTimeStamp = Utility.getTimeStampToday();
    }
    Function request = (shouldForceFinishedForRepetiveTmp) async {
      if (shouldForceFinishedForRepetiveTmp == true) {
        missionModel.isFinished = true;
        // missionModel.repetiveType = 0; //把重复去掉 以免日历不断显示
      } else {
        Utility.addAndUpdateMissionModelRepeativeDate(
            missionModel: missionModel,
            curMonthTimeStamp: curMonthTimeStamp ?? 0,
            isFinished: isFinished ?? true);
      }
      // missionModel.isFinished = true;
      missionModel.repetiveValue = null;
      missionModel.end_time_before_finished =
          missionModel.end_time; //把SettingItemDetailPage设置的end_time预存
      //如果任务完成时间大于当前时间 则预期
      if (Utility.getYearMonthAndDayDateTimeByTimestamp(
                  missionModel?.end_time ?? 0)
              .compareTo(Utility.getYearMonthAndDayDateTimeByTimestamp(
                  Utility.getTimeStampToday())) >
          0) {
        missionModel.isDelayed = true;
      }
      missionModel.finish_time = Utility.getTimeStampToday(); //end_time是真实时间
      // missionModel.update_time = Utility.getTimeStamp();
      missionModel.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      MongoDbUpdated bmobUpdated = await missionModel.update();
      await queryWhereEqual_missionData(
        shouldRefresh: true,
      ); //更新 missionModels
      if (callback != null) {
        callback(bmobUpdated);
      }
      print("修改一条数据成功：${bmobUpdated.message}");
      return bmobUpdated;
      // } else {
      //   print("请先新增一条数据");
      //   // showError(context, "请先新增一条数据");
      // }
    };
    //强制请求
    if (shouldForceFinishedWithoutRepeativeDialog == true ||
        missionModel.repetiveType == 0) {
      request(shouldForceFinishedWithoutRepeativeDialog);
    } else {
      bool isFinish = Utility.getIsFinishOfMissionModel(
          missionModel: missionModel,
          curMonthTimeStamp: curMonthTimeStamp ?? 0);
      if (isFinish == true) {
        //如果完成
        request(false);
      } else {
        DialogManagement.getInstance().showFinishDialog(context,
            okCallback: (isCheck) {
          if (isCheck == true) {
            // shouldForceFinishedForRepetive = true
            request(true);
          } else {
            request(false);
          }
        });
      }
    }
    // if (currentObjectId != null) {
    //   MissionModel missionModel = MissionModel();
    //   missionModel.objectId = currentObjectId;

    // return bmobUpdated;
    // } else {
    //   print("请先新增一条数据");
    //   // showError(context, "请先新增一条数据");
    // }
  }

  /**
   * 把objectid放到文件夹FolderModel里
   */
  updateFolderModelsForFolderObjectId(
      {required String objectId,
      required FolderModel? folderModelForFolder}) async {
    List<FolderModel> listFolderModels = [];
    for (int i = 0; i < this.listFolderModels.length; i++) {
      FolderModel folderModelTmp = this.listFolderModels[i];
      //遍历 如果是文件夹 并且包含该objectid 则删除
      if (folderModelTmp.tag == 3) {
        // 文件夹
        if (folderModelTmp.folderModelObjectIdOrderList?.contains(objectId) ==
            true) {
          folderModelTmp.folderModelObjectIdOrderList?.remove(objectId);
          listFolderModels.add(folderModelTmp);
        }
      }
    }
    if (folderModelForFolder != null) {
      if (folderModelForFolder.folderModelObjectIdOrderList == null) {
        folderModelForFolder.folderModelObjectIdOrderList = [];
      }
      if (folderModelForFolder.folderModelObjectIdOrderList
              ?.contains(objectId) ==
          false) {
        folderModelForFolder.folderModelObjectIdOrderList?.add(objectId);
      }
      listFolderModels.add(folderModelForFolder);
    }
    // 批量更新
    List list = await this
        .batchUpdate_folderModelWithParams(listFolderModel: listFolderModels);
    return list;
  }

  /**
   * 查找根据folderModel的objectid文件夹
   */
  FolderModel? queryFolderModelForForFolderObjectId(
      {required String objectId}) {
    for (int i = 0; i < this.listFolderModels.length; i++) {
      FolderModel folderModel = this.listFolderModels[i];
      if (folderModel.tag == 3) {
        // 文件夹
        if (folderModel.folderModelObjectIdOrderList?.contains(objectId) ==
            true) {
          return folderModel;
        }
      }
    }
    return null;
  }

  /**
   * 完成该任务
   */
  finishEndTimeMissionModel({
    required EndTimeMissionModel missionModel,
    Function? callback,
  }) async {
    // if (currentObjectId != null) {
    //   MissionModel missionModel = MissionModel();
    //   missionModel.objectId = currentObjectId;
    missionModel.isFinished = true;
    missionModel.repetiveType = 0; //把重复去掉 以免日历不断显示
    missionModel.repetiveValue = null;
    missionModel.end_time_before_finished =
        missionModel.end_time; //把SettingItemDetailPage设置的end_time预存
    //如果任务完成时间大于当前时间 则预期
    if (Utility.getYearMonthAndDayDateTimeByTimestamp(
                missionModel.end_time ?? 0)
            .compareTo(Utility.getYearMonthAndDayDateTimeByTimestamp(
                Utility.getTimeStampToday())) >
        0) {
      missionModel.isDelayed = true;
    }
    missionModel.finish_time = Utility.getTimeStampToday(); //end_time是真实时间
    // missionModel.update_time = Utility.getTimeStamp();
    missionModel.uid =
        TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
            ? ''
            : LoginManager.getInstance().getUserBean().uid;
    MongoDbUpdated bmobUpdated = await missionModel.update();
    await queryWhereEqual_EndTimeMissionModel(
      shouldRefresh: true,
    ); //更新 missionModels
    if (callback != null) {
      callback(bmobUpdated);
    }
    print("修改一条数据成功：${bmobUpdated.message}");
    return bmobUpdated;
    // } else {
    //   print("请先新增一条数据");
    //   // showError(context, "请先新增一条数据");
    // }
  }

  bool validMissionModel({MissionModel? missionModel}) {
    if (missionModel?.time_mode == 1 &&
        (missionModel?.start_time == null || missionModel?.start_time == 0)) {
      Utility.showToast(
          msg: getI18NKey().please_input_xxx_name(getI18NKey().start_time));
      return false;
    }
    if (missionModel?.time_mode == 1 &&
        (missionModel?.end_time == null || missionModel?.end_time == 0)) {
      Utility.showToast(
          msg: getI18NKey().please_input_xxx_name(getI18NKey().end_time));
      return false;
    }
    //时间段不重复提醒
    // if(missionModel?.time_mode == 1) {
    //   missionModel?.repetiveType= 0;
    // }
    return true;
  }

  ///修改一条数据
  Future<MongoDbUpdated?> update_MissionModel(
      {required MissionModel missionModel,
      bool shouldCheckPermission = true,
      bool shouldQueryMissionModel = true,
      Function? callback}) async {
    if (shouldCheckPermission == true &&
        Utility.isFolderModelEnabled(
                folderId: missionModel.folder_id ?? "",
                uid: LoginManager.getInstance().userBean.uid ?? "") ==
            false) {
      Utility.showToast(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return null;
    }

    // eventBus.fire(Params.ACTION_UPDATE_SETTING_ITEM_DETAIL, {"objectId": missionModel.objectId});
    try {
      MissionModel missionModelTmp = missionModel ?? MissionModel();
      bool validate = validMissionModel(missionModel: missionModelTmp);
      if (validate == false) {
        return null;
      }

      MongoDbUpdated bmobUpdated = await missionModelTmp.update();
      if (shouldQueryMissionModel == true) {
        await queryWhereEqual_missionData(
          shouldRefresh: true,
        ); //更新 missionModels
      } else {
        //更新 missionModels
        for (int i = 0; i < this.listMissionModels.length; i++) {
          if (this.listMissionModels[i].objectId == missionModelTmp.objectId) {
            this.listMissionModels[i] = missionModelTmp;
            print("");
          }
        }
        // context?.read<GlobalStateEnv>().listMissionModels =
        //     this.listMissionModels;
        // this.listMissionModels = missionModels;
      }
      if (TextUtil.isEmpty(missionModelTmp.folder_id) == true) {
        MongoDbSaved? res = await MongoApisManager.getInstance()
            .insertTimelineMissionModel(
                missionModel: Utility.getTimelineMissionModelFromMissionModel(
                    icon: Icons.check_circle.codePoint,
                    color: Colors.greenAccent.value,
                    missionModel: missionModel,
                    sceneType: "mission",
                    eventType: "update_mission",
                    timelineMessage: getI18NKey()
                        .update_name_mission2(missionModel.title ?? "?")));
      } else {
        FolderModel? folderModel = MongoApisManager.getInstance()
                .queryWhereEqualFolderModelByObjectId(
                    objectId: missionModelTmp.folder_id) ??
            null;
        MongoDbSaved? res = await MongoApisManager.getInstance()
            .insertTimelineMissionModel(
                missionModel: Utility.getTimelineMissionModelFromMissionModel(
                    icon: Icons.check_circle.codePoint,
                    color: Colors.greenAccent.value,
                    missionModel: missionModel,
                    sceneType: "mission",
                    eventType: "update_mission",
                    timelineMessage: getI18NKey().update_name_mission(
                        folderModel?.title ?? "", missionModel.title ?? "?")));
      }
//如果计数中需要更新missionModel
      CounterManagement.getInstance().updateMissionModel(missionModel);
      eventBus.fire(EventFn(
          Params.ACTION_UPDATE_SETTING_ITEM_DETAIL, {"data": missionModel}));
      // String id = Utility.getObjectIdWithId(missionModelTmp.objectId);
      if (callback != null) {
        callback(bmobUpdated);
      }
      print("修改一条数据成功：${bmobUpdated.message}");
      return bmobUpdated;
    } catch (e) {
      return null;
    }
  }

  Future<MongoDbUpdated?> update_WQBMissionModel(
      {required WQBMissionModel missionModel,
      bool shouldCheckPermission = true,
      Function? callback}) async {
    // if (shouldCheckPermission == true &&
    //     Utility.isFolderModelEnabled(
    //         folderId: missionModel.folder_id ?? "",
    //         uid: LoginManager.getInstance().userBean.uid ?? "") ==
    //         false) {
    //   Utility.showToast(
    //       context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
    //   return null;
    // }
    try {
      WQBMissionModel missionModelTmp = missionModel ?? WQBMissionModel();
      missionModelTmp.update_time = Utility.getTimeStampToday();
      MongoDbUpdated bmobUpdated = await missionModelTmp.update();
      await queryWhereEqual_WQBMissionModel(
        shouldRefresh: true,
      ); //更新 missionModels
      // String id = Utility.getObjectIdWithId(missionModelTmp.objectId);
      if (callback != null) {
        callback(bmobUpdated);
      }
      print("修改一条数据成功：${bmobUpdated.message}");
      return bmobUpdated;
    } catch (e) {
      return null;
    }
  }

  ///修改一条数据
  Future<MongoDbUpdated?> update_WQBFolderModelWithFM(
      {WQBFolderModel? folderModel, Function? callback}) async {
    WQBFolderModel folderModelTmp = folderModel ?? WQBFolderModel();
    MongoDbUpdated bmobUpdated = await folderModelTmp.update();
    await queryWhereEqual_WQBFolderModel(
      shouldRefresh: true,
    ); //更新 missionModels
    if (callback != null) {
      callback(bmobUpdated);
    }
    print("修改一条数据成功：${bmobUpdated.message}");
    return bmobUpdated;
  }

  Future<MongoDbUpdated?> update_CreditCardModel(
      {required CreditCardModel creditCardModel, Function? callback}) async {
    CreditCardModel creditCardModelTmp = creditCardModel ?? CreditCardModel();
    MongoDbUpdated bmobUpdated = await creditCardModelTmp.update();
    await queryWhereEqual_creditModel(
      shouldRefresh: true,
    ); //更新 missionModels
    if (callback != null) {
      callback(bmobUpdated);
    }
    print("修改一条数据成功：${bmobUpdated.message}");
    return bmobUpdated;
  }



  Future<MongoDbUpdated?> update_ChatGptFolderModel(
      {ChatGptFolderModel? chatGptFolderModel, Function? callback}) async {
    ChatGptFolderModel chatGptFolderModelTmp = chatGptFolderModel ?? ChatGptFolderModel();
    MongoDbUpdated bmobUpdated = await chatGptFolderModelTmp.update();
    await queryWhereEqual_ChatGptFolderModel(
      shouldRefresh: true,
    ); //更新 missionModels
    if (callback != null) {
      callback(bmobUpdated);
    }
    print("修改一条数据成功：${bmobUpdated.message}");
    return bmobUpdated;
  }

  Future<MongoDbUpdated?> update_BillModel(
      {BillModel? billModel, Function? callback}) async {
    BillModel billModelTmp = billModel ?? BillModel();
    MongoDbUpdated bmobUpdated = await billModelTmp.update();
    await queryWhereEqual_billModel(
      shouldRefresh: true,
    ); //更新 missionModels
    if (callback != null) {
      callback(bmobUpdated);
    }
    print("修改一条数据成功：${bmobUpdated.message}");
    return bmobUpdated;
  }

  Future<MongoDbUpdated?> update_GroupModel(
      {GroupModel? groupModel,
      bool shouldQueryMissionModel = true,
      Function? callback}) async {
    GroupModel billModelTmp = groupModel ?? GroupModel();
    MongoDbUpdated bmobUpdated = await billModelTmp.update();
    if (shouldQueryMissionModel == true) {
      await queryWhereEqual_groupModel(
        shouldRefresh: true,
      ); //更新 missionModels
    } else {
      //更新 missionModels
      for (int i = 0; i < this.listGroupModel.length; i++) {
        if (this.listGroupModel[i].objectId == groupModel?.objectId) {
          this.listGroupModel[i] = groupModel ?? GroupModel();
        }
      }
      context?.read<GlobalStateEnv>().listGroupModel = listGroupModel;
    }
    // await queryWhereEqual_billModel(
    //   shouldRefresh: true,
    // ); //更新 missionModels
    if (callback != null) {
      callback(bmobUpdated);
    }
    print("修改一条数据成功：${bmobUpdated.message}");
    return bmobUpdated;
  }

  Future<MongoDbUpdated?> update_ChatGptMessageModel(
      {ChatGptMessageModel? chatGptMessageModel,
      bool shouldQueryModel = true,
      Function? callback}) async {
    ChatGptMessageModel chatMsgModelTmp =
        chatGptMessageModel ?? ChatGptMessageModel();
    //如果是当前选中的文件夹 则取消之前的
    if (chatGptMessageModel?.isCurrentSelectFolder == true) {
      List<ChatGptMessageModel> listChatGptMessageModel = [];
      ChatGptMessageModel? chatGptMessageModelTmp;
      for (int i = 0; i < this.listChatGptMessageModel.length; i++) {
        ChatGptMessageModel item = this.listChatGptMessageModel[i];
        if (item?.isCurrentSelectFolder == true &&
            item?.objectId != chatGptMessageModel?.objectId) {
          chatGptMessageModelTmp = item;
          chatGptMessageModelTmp?.isCurrentSelectFolder = false;
          listChatGptMessageModel.add(chatGptMessageModelTmp);
          // chatGptMessageModelTmp?.update();
        }
      }
      if (chatGptMessageModelTmp != null &&
          listChatGptMessageModel.length > 0) {
        await MongoApisManager.getInstance().batchUpdate_ChatGptMessageModel(
            shouldRefresh: false, listParam: listChatGptMessageModel);
      }
      // chatGptMessageModel?.isCurrentSelectFolder = false;
    }

    chatMsgModelTmp?.updated_at = Utility.getTimeStampToday();
    MongoDbUpdated bmobUpdated = await chatMsgModelTmp.update();
    if (shouldQueryModel == true) {
      await queryWhereEqual_ChatGptMessageModel(
        shouldRefresh: true,
      ); //更新 missionModels
    } else {
      //更新 missionModels
      for (int i = 0; i < this.listChatGptMessageModel.length; i++) {
        if (this.listChatGptMessageModel[i].objectId ==
            chatGptMessageModel?.objectId) {
          this.listChatGptMessageModel[i] =
              chatGptMessageModel ?? ChatGptMessageModel();
        }
      }
      context?.read<GlobalStateEnv>().listChatGptMessageModel =
          listChatGptMessageModel;
    }
    // await queryWhereEqual_billModel(
    //   shouldRefresh: true,
    // ); //更新 missionModels
    if (callback != null) {
      callback(bmobUpdated);
    }
    print("修改一条数据成功：${bmobUpdated.message}");
    return bmobUpdated;
  }

  ///修改一条数据
  Future<MongoDbUpdated?> update_FolderModelWithFM(
      {required FolderModel folderModel,
      bool shouldQueryMissionModel = true,
      Function? callback}) async {
    FolderModel folderModelTmp = folderModel ?? FolderModel();
    MongoDbUpdated bmobUpdated = await folderModelTmp.update();
    if (shouldQueryMissionModel == true) {
      await queryWhereEqual_folderModel(
        shouldRefresh: true,
      ); //更新 missionModels
    } else {
      //更新 missionModels
      for (int i = 0; i < this.listFolderModels.length; i++) {
        if (this.listFolderModels[i].objectId == folderModel?.objectId) {
          this.listFolderModels[i] = folderModel;
          print("");
        }
      }
      Utility.getGlobalContext().read<GlobalStateEnv>().listFolderModels =
          this.listFolderModels;
    }
    if (callback != null) {
      callback(bmobUpdated);
    }
    print("修改一条数据成功：${bmobUpdated.message}");
    return bmobUpdated;
  }

  ///修改一条数据
  update_StatsModel(
      {StatsModel? missionModel,
      title,
      type,
      tagName,
      category,
      value,
      color,
      icon,
      begin_time,
      finish_time,
      Function? callback,
      currentObjectId}) async {
    // if (currentObjectId != null) {
    StatsModel missionModelTmp = missionModel ?? StatsModel();

    if (!TextUtil.isEmpty(icon)) {
      missionModelTmp.icon = icon;
    }

    if (!TextUtil.isEmpty(color)) {
      missionModelTmp.color = color;
    }

    if (!TextUtil.isEmpty(currentObjectId)) {
      missionModelTmp.objectId = currentObjectId;
    }
    if (!TextUtil.isEmpty(title)) {
      missionModelTmp.title = title;
    }
    if (!TextUtil.isEmpty(type)) {
      missionModelTmp.type = type;
    }
    if (!TextUtil.isEmpty(tagName)) {
      missionModelTmp.tagNames = tagName;
    }
    if (!TextUtil.isEmpty(category)) {
      missionModelTmp.category = category;
    }
    if (!TextUtil.isEmpty(value)) {
      missionModelTmp.value = value;
    }

    if (!TextUtil.isEmpty(begin_time)) {
      missionModelTmp.begin_time = begin_time;
    }
    if (!TextUtil.isEmpty(finish_time)) {
      missionModelTmp.finish_time = finish_time;
    }
    missionModelTmp.device_id = this.device_id;

    // missionModelTmp.update_time = Utility.getTimeStamp();
    missionModelTmp.uid =
        TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
            ? ''
            : LoginManager.getInstance().getUserBean().uid;
    MongoDbUpdated bmobUpdated = await missionModelTmp.update();
    await queryWhereEqual_statsModel(shouldRefresh: true); //更新 missionModels
    if (callback != null) {
      callback(bmobUpdated);
    }
    print("修改一条数据成功：${bmobUpdated.message}");
    return bmobUpdated;
    // } else {
    //   print("请先新增一条数据");
    //   // showError(context, "请先新增一条数据");
    // }
  }

  ///修改一条数据
  update_FolderModel(
      {id,
      title,
      description,
      number,
      icon,
      tagName,
      shouldRefresh: true,
      color,
      order_index,
      tag,
      no_tomotoes_finished,
      tomato_duration,
      Function? callback,
      currentObjectId}) async {
    if (currentObjectId != null) {
      FolderModel folderModel = FolderModel();
      if (!TextUtil.isEmpty(currentObjectId)) {
        folderModel.objectId = currentObjectId;
      }
      if (!TextUtil.isEmpty(title)) {
        folderModel.title = title;
      }
      if (!TextUtil.isEmpty(description)) {
        folderModel.description = description;
      }
      if (!TextUtil.isEmpty(color)) {
        folderModel.color = color;
      }
      if (!TextUtil.isEmpty(icon)) {
        folderModel.icon = icon;
      }
      if (!TextUtil.isEmpty(device_id)) {
        folderModel.device_id = device_id;
      }
      if (!TextUtil.isEmpty(tagName)) {
        folderModel.tagName = tagName;
      }
      if (!TextUtil.isEmpty(tag)) {
        folderModel.tag = tag;
      }
      if (!TextUtil.isEmpty(number)) {
        folderModel.number = number;
      }
      folderModel.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      // folderModel.update_time = Utility.getTimeStamp();
      MongoDbUpdated bmobUpdated = await folderModel.update();
      await queryWhereEqual_folderModel(shouldRefresh: shouldRefresh);
      if (callback != null) {
        callback(bmobUpdated);
      }
      print("修改一条数据成功：${bmobUpdated.message}");
      return bmobUpdated;
    } else {
      print("请先新增一条数据");
      // showError(context, "请先新增一条数据");
    }
  }

  ///修改一条数据
  update_PresentModel(
      {id,
      title,
      imageUrl,
      required int color,
      shouldRefresh: true,
      int icon = 0,
      value,
      Function? callback,
      currentObjectId}) async {
    if (currentObjectId != null) {
      PresentModel presentModel = PresentModel();
      if (!TextUtil.isEmpty(currentObjectId)) {
        presentModel.objectId = currentObjectId;
      }
      if (!TextUtil.isEmpty(title)) {
        presentModel.title = title;
      }
      if (!TextUtil.isEmpty(color)) {
        presentModel.color = color;
      }
      if (icon != 0) {
        presentModel.icon = icon;
      }
      if (!TextUtil.isEmpty(device_id)) {
        presentModel.device_id = device_id;
      }
      if (!TextUtil.isEmpty(value)) {
        presentModel.value = value;
      }
      presentModel.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
      MongoDbUpdated bmobUpdated = await presentModel.update();
      await queryWhereEqual_presentModel(shouldRefresh: shouldRefresh);
      if (callback != null) {
        callback(bmobUpdated);
      }
      print("修改一条数据成功：${bmobUpdated.message}");
      return bmobUpdated;
    } else {
      print("请先新增一条数据");
      // showError(context, "请先新增一条数据");
    }
  }

  Future<List> batchUpdate_folderModelWithParams(
      {required List<FolderModel> listFolderModel, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    //先批量加密 query那会批量解密
    List list = await batch.updateBatch(listFolderModel);
    if (callback != null) {
      callback(list);
    }
    await queryWhereEqual_folderModel(
      shouldRefresh: true,
    ); //更新 missionModels

    return list;
  }

  /**
   * 没地方用
   */
  batchUpdate_MissionModelWithParams(
      {required List<MissionModel> listMissionModel,
      Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    //先批量加密 query那会批量解密
    CryptoManager.getInstance().batchDecryptMissionModels(listMissionModel);
    List list = await batch.updateBatch(listMissionModel);
    if (callback != null) {
      callback(list);
    }
    await queryWhereEqual_missionData(
      shouldRefresh: true,
    ); //更新 missionModels

    MongoDbSaved? res = await MongoApisManager.getInstance()
        .insertTimelineMissionModel(
            missionModel: Utility.getTimelineMissionModelFromMissionModel(
                icon: Icons.check_circle.codePoint,
                color: Colors.greenAccent.value,
                sceneType: "mission",
                eventType: "batch_update_mission",
                timelineMessage: getI18NKey()
                    .batch_update_missions(listMissionModel?.length ?? 0)));
    return list;
  }

  Future batchUpdate_MissionModel(
      {currentObjectId,
      folder_id,
      shouldRefresh: true,
      bool shouldUpdateUid = false,
      Function? callback}) async {
    List<MissionModel> listParam = this.listMissionModels;
    List<MissionModel> listParamUidNull = [];
    listParam.forEach((element) {
      if (TextUtil.isEmpty(element.uid)) {
        element.uid =
            TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? ''
                : LoginManager.getInstance().getUserBean().uid;
        listParamUidNull.add(element);
      }
    });

    CryptoManager.getInstance().batchEncryptMissionModels(listParamUidNull);

    MongoDbBatch batch = MongoDbBatch();
    User user = User();
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    user.setObjectId(uid ?? '');
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    List list = await batch.updateBatch(listParamUidNull);
    if (callback != null) {
      callback(list);
    }
    listParam = await queryWhereEqual_missionData(
      shouldRefresh: shouldRefresh,
    );
    currentObjectId = null;
    return list;
  }

  Future batchUpdate_TimelineMissionModel(
      {currentObjectId,
      shouldRefresh: true,
      folder_id,
      Function? callback}) async {
    List<TimelineMissionModel> listTimelineMissionModel =
        this.listTimelineMissionModel;
    List<TimelineMissionModel> listParam = [];

    listTimelineMissionModel.forEach((element) {
      //uid为空 且设备相等
      if (element.device_id == this.device_id &&
          TextUtil.isEmpty(element.uid)) {
        element.uid =
            TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? ''
                : LoginManager.getInstance().getUserBean().uid;
        listParam.add(element);
      }
    });

    MongoDbBatch batch = MongoDbBatch();
    listParam.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    User user = User();
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    user.setObjectId(uid ?? '');
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    List list = await batch.updateBatch(listParam);
    await queryWhereEqual_TimelineMissionModel(
      shouldRefresh: shouldRefresh,
    );
    if (callback != null) {
      callback(list);
    }
    currentObjectId = null;
    return list;
  }

  Future batchUpdate_FlomoMissionModel(
      {currentObjectId,
      shouldRefresh: true,
      folder_id,
      Function? callback}) async {
    List<FlomoMissionModel> listFlomoMissionModel = this.listFlomoMissionModel;
    List<FlomoMissionModel> listParam = [];

    listFlomoMissionModel.forEach((element) {
      //uid为空 且设备相等
      if (element.device_id == this.device_id &&
          TextUtil.isEmpty(element.uid)) {
        element.uid =
            TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? ''
                : LoginManager.getInstance().getUserBean().uid;
        listParam.add(element);
      }
    });

    MongoDbBatch batch = MongoDbBatch();
    listParam.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    User user = User();
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    user.setObjectId(uid ?? '');
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    List list = await batch.updateBatch(listParam);
    await queryWhereEqual_FlomoMissionModel(
      shouldRefresh: shouldRefresh,
    );
    if (callback != null) {
      callback(list);
    }
    currentObjectId = null;
    return list;
  }

  Future batchUpdate_FolderModel(
      {currentObjectId, shouldRefresh: true, Function? callback}) async {
    List<FolderModel> listParam = this.listFolderModels;
    List<FolderModel> listParamUidNull = [];
    listParam.forEach((element) {
      if (TextUtil.isEmpty(element.uid)) {
        element.uid =
            TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? ''
                : LoginManager.getInstance().getUserBean().uid;
        listParamUidNull.add(element);
      }
    });
    MongoDbBatch batch = MongoDbBatch();
    User user = User();
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    user.setObjectId(uid ?? '');
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    List list = await batch.updateBatch(listParamUidNull);
    await queryWhereEqual_folderModel(shouldRefresh: shouldRefresh);
    if (callback != null) {
      callback(list);
    }
    currentObjectId = null;
    return list;
  }

  Future batchUpdate_FolderModelSync(
      {currentObjectId, Function? callback}) async {
    late List<FolderModel> listFolderModelTmp;
    if (this.listFolderModels != null) {
      listFolderModelTmp = this.listFolderModels;
    } else {
      listFolderModelTmp =
          await queryWhereEqual_folderModel(shouldRefresh: true);
    }
    List<FolderModel> listParam = [];
    listFolderModelTmp.forEach((element) {
      //如果不是分享的图片 表示都是自己创建的
      if (element.isSharing == 0 && (element.otherUids?.length ?? 0) == 0) {
        listParam.add(element);
      }
    });
    //非本人uid都需要重新设置
    List<FolderModel> listParamUidNull = [];
    //自己创建的
    listParam.forEach((element) {
      if (TextUtil.isEmpty(element.uid) ||
          (element.device_id == this.device_id &&
              element.uid != LoginManager.getInstance().userBean.uid)) {
        element.uid =
            TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? ''
                : LoginManager.getInstance().getUserBean().uid;
        listParamUidNull.add(element);
      }
    });

    MongoDbBatch batch = MongoDbBatch();
    User user = User();
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    user.setObjectId(uid ?? '');
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    List list = await batch.updateBatch(listParamUidNull);
    await queryWhereEqual_folderModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    currentObjectId = null;
    return list;
  }

  Future batchUpdate_MissionModelSync(
      {currentObjectId,
      folder_id,
      bool shouldUpdateUid = false,
      Function? callback}) async {
    late List<FolderModel> listFolderModelTmp;
    if (this.listFolderModels != null) {
      listFolderModelTmp = this.listFolderModels;
    } else {
      listFolderModelTmp =
          await queryWhereEqual_folderModel(shouldRefresh: true);
    }
    List<FolderModel> listFolderModelParam = [];
    List<MissionModel> listMissionModelTmp = [];
    listFolderModelTmp.forEach((element) {
      //如果不是分享的图片 表示都是自己创建的
      if (element.isSharing == 0 && (element.otherUids?.length ?? 0) == 0) {
        List<MissionModel> listMissionModels =
            queryWhereEqual_missionDataByFolderModelObjectId(
                objectId: element?.objectId ?? "");
        listMissionModels.forEach((elementMissionModel) {
          //用户存在且用户不是自己 folderModel属于自己时
          if (TextUtil.isEmpty(elementMissionModel.uid) != true &&
              elementMissionModel.uid !=
                  LoginManager.getInstance().userBean.uid) {
            elementMissionModel.uid = LoginManager.getInstance().userBean.uid;
            listMissionModelTmp.add(elementMissionModel);
          }
        });
      }
    });

    this.listMissionModels.forEach((element) {
      //folder_id为空代表肯定是自己的
      if (TextUtil.isEmpty(element.folder_id) == true) {
        listMissionModelTmp.add(element);
      }
    });

    // if(this.listMissionModels != null) {
    //   listMissionModelTmp = this.listMissionModels;
    // } else {
    //   listMissionModelTmp = await queryWhereEqual_missionData(shouldRefresh: true);
    // }

    // List<MissionModel> listParam = await queryWhereEqual_missionData(
    //   shouldRefresh: true,
    // );
    List<MissionModel> listParamUidNull = [];
    listMissionModelTmp.forEach((element) {
      if (TextUtil.isEmpty(element.uid)) {
        element.uid =
            TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? ''
                : LoginManager.getInstance().getUserBean().uid;
        listParamUidNull.add(element);
      }
    });

    MongoDbBatch batch = MongoDbBatch();
    User user = User();
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    user.setObjectId(uid ?? '');
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    List list = await batch.updateBatch(listParamUidNull);
    await queryWhereEqual_folderModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    currentObjectId = null;
    return list;
  }

  Future batchUpdate_StatsModel(
      {bool shouldRefresh = true, Function? callback}) async {
    List<StatsModel> listStatsModels = this.listStatsModels;
    MongoDbBatch batch = MongoDbBatch();
    User user = User();
    String? uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    user.setObjectId(uid ?? "");
    List<StatsModel> listParam = [];
    // BmobAcl bmobAcl = BmobAcl();
    // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
    listStatsModels.forEach((element) {
      if (element.device_id == this.device_id &&
          TextUtil.isEmpty(element.uid)) {
        element.uid =
            TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? ''
                : LoginManager.getInstance().getUserBean().uid;
        listParam.add(element);
      }
    });

    List list = await batch.updateBatch(listParam);
    await queryWhereEqual_statsModel(shouldRefresh: shouldRefresh);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  ///完成任务数量
  List<GroupModel> queryWhereEqual_groupModelsByFolderId({String? folder_id}) {
    List<GroupModel> list = [];
    for (int i = 0; i < this.listGroupModel.length; i++) {
      GroupModel model = this.listGroupModel[i];
      if (model.folder_id == folder_id) {
        list.add(model);
      }
    }
    return list;
  }

  Future batchdelete_GroupModelByFolderId(
      {currentObjectId, folder_id, Function? callback}) async {
    List<GroupModel> listParam =
        await queryWhereEqual_groupModelsByFolderId(folder_id: folder_id);
    MongoDbBatch batch = MongoDbBatch();

    List list = await batch.deleteBatch(listParam);
    await queryWhereEqual_groupModel(
      shouldRefresh: true,
    ); //更新 missionModels
    if (callback != null) {
      callback(list);
    }
    // MongoDbSaved? res = await MongoApisManager.getInstance()
    //     .insertTimelineMissionModel(
    //     missionModel: Utility.getTimelineMissionModelFromMissionModel(
    //         icon: Icons.check_circle.codePoint,
    //         color: Colors.greenAccent.value,
    //         sceneType: "mission",
    //         eventType: "create_mission",
    //         timelineMessage: getI18NKey()
    //             .batch_delete_missions(listParam?.length ?? 0)));
    // listParam.forEach((MissionModel element) {
    //   if(element.alert_time != null && element.alert_time != 0) {
    //     NotificationManager.getInstance().cancelNotificationById(
    //         Utility.getObjectIdWithId(element.objectId));
    //   }
    // });
    currentObjectId = null;
    return list;
  }

  Future batchdelete_MissionModel(
      {currentObjectId, folder_id, Function? callback}) async {
    List<MissionModel> listParam =
        await queryWhereEqual_missionDataByFolderId(folder_id: folder_id);
    MongoDbBatch batch = MongoDbBatch();

    List list = await batch.deleteBatch(listParam);
    await queryWhereEqual_missionData(
      shouldRefresh: true,
    ); //更新 missionModels
    if (callback != null) {
      callback(list);
    }
    MongoDbSaved? res = await MongoApisManager.getInstance()
        .insertTimelineMissionModel(
            missionModel: Utility.getTimelineMissionModelFromMissionModel(
                icon: Icons.check_circle.codePoint,
                color: Colors.greenAccent.value,
                sceneType: "mission",
                eventType: "batch_delete_mission",
                timelineMessage: getI18NKey()
                    .batch_delete_missions(listParam?.length ?? 0)));
    // listParam.forEach((MissionModel element) {
    //   if(element.alert_time != null && element.alert_time != 0) {
    //     NotificationManager.getInstance().cancelNotificationById(
    //         Utility.getObjectIdWithId(element.objectId));
    //   }
    // });
    currentObjectId = null;
    return list;
  }

  batchdelete_EndTimeMissionModel(
      {List<EndTimeMissionModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    await queryWhereEqual_EndTimeMissionModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  batchdelete_TimelineMissionModel(
      {List<TimelineMissionModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    await queryWhereEqual_TimelineMissionModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  batchdelete_FlomoMissionModel(
      {List<FlomoMissionModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    await queryWhereEqual_FlomoMissionModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  ///删除一条数据
  delete_EndTimeMissionModel(
      {currentObjectId,
      title,
      description,
      folder_id,
      device_id,
      order_index,
      dateStatus,
      tagName,
      tagId,
      priorityStatus,
      total_tomotoes,
      no_tomotoes_finished,
      tomato_duration,
      Function? callback}) async {
    if (LoginManager.isLogin() == false) {
      Utility.showToast(msg: getI18NKey().loginFirst);
      LoginManager.getInstance()
          .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
      // Utility.pushNavigator(Utility.getGlobalContext(), new LoginPage(), callback: (res) {
      // });
      return null;
    }
    // if (currentObjectId != null) {
    EndTimeMissionModel missionModel = EndTimeMissionModel();
    if (!TextUtil.isEmpty(currentObjectId)) {
      missionModel.objectId = currentObjectId;
    }
    if (!TextUtil.isEmpty(folder_id)) {
      missionModel.folder_id = folder_id;
    }

    if (!TextUtil.isEmpty(title)) {
      missionModel.title = title;
    }
    if (!TextUtil.isEmpty(device_id)) {
      missionModel.device_id = device_id;
    }
    // if (!TextUtil.isEmpty(tagId)) {
    //   missionModel.tagId = tagId;
    // }
    missionModel.uid =
        TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
            ? ''
            : LoginManager.getInstance().getUserBean().uid;
    MongoDbHandled bmobHandled = await missionModel.delete();
    await queryWhereEqual_EndTimeMissionModel(
      shouldRefresh: true,
    ); //更新 missionModels
    if (callback != null) {
      callback(bmobHandled);
    }
    // NotificationManager.getInstance().cancelNotificationById(Utility.getObjectIdWithId(currentObjectId));
    currentObjectId = null;
    print("删除一条数据成功：${bmobHandled.message}");
    return bmobHandled;
    // } else {
    //   print("请先新增一条数据");
    //   // showError(context, "请先新增一条数据");
    // }
  }

  delete_WQBMissionModel({currentObjectId, Function? callback}) async {
    if (LoginManager.isLogin() == false) {
      Utility.showToast(msg: getI18NKey().loginFirst);
      LoginManager.getInstance()
          .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
      return null;
    }
    WQBMissionModel missionModel = WQBMissionModel();
    if (!TextUtil.isEmpty(currentObjectId)) {
      missionModel.objectId = currentObjectId;
    }
    if (!TextUtil.isEmpty(device_id)) {
      missionModel.device_id = device_id;
    }
    missionModel.uid =
        TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
            ? ''
            : LoginManager.getInstance().getUserBean().uid;
    MongoDbHandled bmobHandled = await missionModel.delete();
    await queryWhereEqual_WQBMissionModel(
      shouldRefresh: true,
    ); //更新 missionModels
    if (callback != null) {
      callback(bmobHandled);
    }
    currentObjectId = null;
    print("删除一条数据成功：${bmobHandled.message}");
    return bmobHandled;
  }

  ///删除一条数据
  delete_MissionModel(
      {currentObjectId,
      title,
      description,
      folder_id,
      device_id,
      order_index,
      dateStatus,
      tagName,
      tagId,
      priorityStatus,
      total_tomotoes,
      no_tomotoes_finished,
      tomato_duration,
      Function? callback}) async {
    if (LoginManager.isLogin() == false) {
      Utility.showToast(msg: getI18NKey().loginFirst);
      LoginManager.getInstance()
          .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
      return null;
    }
    MissionModel missionModel = MissionModel();
    if (!TextUtil.isEmpty(currentObjectId)) {
      missionModel.objectId = currentObjectId;
    }
    if (!TextUtil.isEmpty(folder_id)) {
      missionModel.folder_id = folder_id;
    }

    if (!TextUtil.isEmpty(title)) {
      missionModel.title = title;
    }
    if (!TextUtil.isEmpty(device_id)) {
      missionModel.device_id = device_id;
    }
    missionModel.uid =
        TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
            ? ''
            : LoginManager.getInstance().getUserBean().uid;
    MongoDbHandled bmobHandled = await missionModel.delete();
    await queryWhereEqual_missionData(
      shouldRefresh: true,
    ); //更新 missionModels
    if (callback != null) {
      callback(bmobHandled);
    }
    currentObjectId = null;
    print("删除一条数据成功：${bmobHandled.message}");
    return bmobHandled;
  }

  ///删除一条数据
  delete_TimelineMissionModel({currentObjectId, Function? callback}) async {
    if (currentObjectId != null) {
      TimelineMissionModel timelineMissionModel = TimelineMissionModel();
      timelineMissionModel.objectId = currentObjectId;
      MongoDbHandled bmobHandled = await timelineMissionModel.delete();
      await queryWhereEqual_TimelineMissionModel(shouldRefresh: true);
      if (callback != null) {
        callback(bmobHandled);
      }
      currentObjectId = null;
      print("删除一条数据成功：${bmobHandled.message}");
      return bmobHandled;
    } else {
      print("请先新增一条数据");
      // showError(context, "请先新增一条数据");
    }
  }

  delete_FlomoMissionModel({currentObjectId, Function? callback}) async {
    if (currentObjectId != null) {
      FlomoMissionModel flomoMissionModel = FlomoMissionModel();
      flomoMissionModel.objectId = currentObjectId;
      MongoDbHandled bmobHandled = await flomoMissionModel.delete();
      await queryWhereEqual_FlomoMissionModel(shouldRefresh: true);
      if (callback != null) {
        callback(bmobHandled);
      }
      currentObjectId = null;
      print("删除一条数据成功：${bmobHandled.message}");
      return bmobHandled;
    } else {
      print("请先新增一条数据");
      // showError(context, "请先新增一条数据");
    }
  }

  delete_GroupModel({currentObjectId, Function? callback}) async {
    if (currentObjectId != null) {
      GroupModel groupModel = GroupModel();
      groupModel.objectId = currentObjectId;
      MongoDbHandled bmobHandled = await groupModel.delete();
      await queryWhereEqual_groupModel(shouldRefresh: true);
      if (callback != null) {
        callback(bmobHandled);
      }
      currentObjectId = null;
      print("删除一条数据成功：${bmobHandled.message}");
      return bmobHandled;
    } else {
      print("请先新增一条数据");
      // showError(context, "请先新增一条数据");
    }
  }

  delete_CreditCardModel({currentObjectId, Function? callback}) async {
    if (currentObjectId != null) {
      CreditCardModel creditCardModel = CreditCardModel();
      creditCardModel.objectId = currentObjectId;
      MongoDbHandled bmobHandled = await creditCardModel.delete();
      await queryWhereEqual_creditModel(shouldRefresh: true);
      if (callback != null) {
        callback(bmobHandled);
      }
      currentObjectId = null;
      print("删除一条数据成功：${bmobHandled.message}");
      return bmobHandled;
    } else {
      print("请先新增一条数据");
      // showError(context, "请先新增一条数据");
    }
  }

  ///删除一条数据
  delete_PresentModel({currentObjectId, Function? callback}) async {
    if (currentObjectId != null) {
      PresentModel presentModel = PresentModel();
      presentModel.objectId = currentObjectId;
      MongoDbHandled bmobHandled = await presentModel.delete();
      await queryWhereEqual_presentModel(shouldRefresh: true);
      if (callback != null) {
        callback(bmobHandled);
      }
      currentObjectId = null;
      print("删除一条数据成功：${bmobHandled.message}");
      return bmobHandled;
    } else {
      print("请先新增一条数据");
      // showError(context, "请先新增一条数据");
    }
  }

  Future<MongoDbHandled?> delete_WQBFolderModel(
      {currentObjectId, Function? callback}) async {
    if (LoginManager.isLogin() == false) {
      Utility.showToast(msg: getI18NKey().loginFirst);
      LoginManager.getInstance()
          .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
      // Utility.pushNavigator(Utility.getGlobalContext(), new LoginPage(), callback: (res) {
      // });
      return null;
    }

    if (currentObjectId != null) {
      WQBFolderModel folderModel = WQBFolderModel();
      folderModel.objectId = currentObjectId;
      MongoDbHandled bmobHandled = await folderModel.delete();
      await queryWhereEqual_WQBFolderModel(shouldRefresh: true);
      if (callback != null) {
        callback(bmobHandled);
      }
      currentObjectId = null;
      print("删除一条数据成功：${bmobHandled.message}");
      return bmobHandled;
    } else {
      print("请先新增一条数据");
      // showError(context, "请先新增一条数据");
    }
    return null;
  }

  ///删除一条数据
  Future<MongoDbHandled?> delete_FolderModel(
      {currentObjectId, Function? callback}) async {
    if (LoginManager.isLogin() == false) {
      Utility.showToast(msg: getI18NKey().loginFirst);
      LoginManager.getInstance()
          .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
      // Utility.pushNavigator(Utility.getGlobalContext(), new LoginPage(), callback: (res) {
      // });
      return null;
    }

    if (currentObjectId != null) {
      FolderModel folderModel = FolderModel();
      folderModel.objectId = currentObjectId;
      MongoDbHandled bmobHandled = await folderModel.delete();
      await queryWhereEqual_folderModel(shouldRefresh: true);
      if (callback != null) {
        callback(bmobHandled);
      }
      currentObjectId = null;
      print("删除一条数据成功：${bmobHandled.message}");
      return bmobHandled;
    } else {
      print("请先新增一条数据");
      // showError(context, "请先新增一条数据");
    }
    return null;
  }

  Future<MongoDbSaved?> insertPresentModel(
      {title,
      imageUrl,
      required int color,
      required int icon,
      value,
      Function? callback}) async {
    try {
      if (LoginManager.isLogin() == false) {
        Utility.showToast(msg: getI18NKey().loginFirst);
        LoginManager.getInstance()
            .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
        return null;
      }
      PresentModel presentModel = PresentModel();
      // folderModel.id = id;
      presentModel.icon = icon;
      presentModel.title = title;
      presentModel.color = color;
      presentModel.imageUrl = imageUrl;
      presentModel.value = value ?? 0;
      presentModel.uid = LoginManager.getInstance().getUid();
      presentModel.device_id = this.device_id;
      User user = User();
      user.setObjectId(LoginManager.getInstance().getUid());
      MongoDbSaved? bmobSaved = await presentModel.save();
      await queryWhereEqual_presentModel(shouldRefresh: true);
      String message =
          "创建一条数据成功：${bmobSaved?.objectId} - ${bmobSaved?.createdAt}";
      print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      return bmobSaved;
    } catch (e) {
      print(MongoDbError.convert(e)?.error);
    } finally {
      // await dbUtil.close();
    }
  }

  List<ChatGptMessageModel> getChatGptMessageModelListByFolderId(
      String folderId) {
    List<ChatGptMessageModel> list = [];
    this.listChatGptMessageModel.forEach((element) {
      if (element.folder_objectId == folderId) {
        list.add(element);
      }
    });
    return list;
  }

  ChatGptMessageModel? getCurChatGptMessageModel() {
    ChatGptMessageModel? chatGptMessageModel;
    List<ChatGptMessageModel> listChatGptMessageModel =
        MongoApisManager.getInstance().listChatGptMessageModel;
    for (int i = 0; i < listChatGptMessageModel.length; i++) {
      ChatGptMessageModel model = listChatGptMessageModel[i];
      if (model.modelType == 1 && model.isCurrentSelectFolder == true) {
        return model;
      }
    }
    return null;
  }

  resetAllChatGptMessageModelIsCurrentSelectFolder() async {
    List<ChatGptMessageModel> listChatGptMessageModel =
        MongoApisManager.getInstance().listChatGptMessageModel;
    List<ChatGptMessageModel> list = [];
    List<ChatGptMessageModel> listEmpty = [];
    for (int i = 0; i < listChatGptMessageModel.length; i++) {
      ChatGptMessageModel model = listChatGptMessageModel[i];
      if (model.modelType == 1) {
        model.isCurrentSelectFolder = false;
        list.add(model);
        if (TextUtil.isEmpty(model.folderTitle)) {
          listEmpty.add(model);
        }
      }
    }
    await MongoApisManager.getInstance().batchDelete_ChatGptMessageModel(
        shouldRefresh: false, listParam: listEmpty);
    await MongoApisManager.getInstance()
        .batchUpdate_ChatGptMessageModel(shouldRefresh: false, listParam: list);
  }

  Future<MongoDbSaved?> insertChatGptMessageModel(
      {ChatGptMessageModel? chatGptMessageModel,
      bool shouldUpdate = true,
      Function? callback}) async {
    if (LoginManager.isLogin() == false) {
      Utility.showToast(msg: getI18NKey().loginFirst);
      return null;
    }
    try {
      User user = User();
      //把之前的folderModel的isCurrentSelectFolder设置为false
      if (chatGptMessageModel?.isCurrentSelectFolder == true) {
        List<ChatGptMessageModel> listChatGptMessageModel = [];
        ChatGptMessageModel? chatGptMessageModelTmp;
        for (int i = 0; i < this.listChatGptMessageModel.length; i++) {
          ChatGptMessageModel item = this.listChatGptMessageModel[i];
          if (item?.isCurrentSelectFolder == true) {
            chatGptMessageModelTmp = item;
            chatGptMessageModelTmp?.isCurrentSelectFolder = false;
            listChatGptMessageModel.add(chatGptMessageModelTmp);
            // chatGptMessageModelTmp?.update();
          }
        }
        if (chatGptMessageModelTmp != null &&
            listChatGptMessageModel.length > 0) {
          await MongoApisManager.getInstance().batchUpdate_ChatGptMessageModel(
              shouldRefresh: false, listParam: listChatGptMessageModel);
        }
        // chatGptMessageModel?.isCurrentSelectFolder = false;
      }
      chatGptMessageModel?.uid = LoginManager.getInstance().getUid();
      //文件夹需要加上标题
      if (chatGptMessageModel?.modelType == 1) {
        chatGptMessageModel?.folderTitle = chatGptMessageModel?.title;
      }
      chatGptMessageModel?.updated_at = Utility.getTimeStampToday();
      chatGptMessageModel?.created_at = Utility.getTimeStampToday();
      user.setObjectId(LoginManager.getInstance().getUid());
      MongoDbSaved? bmobSaved = await chatGptMessageModel?.save();
      String message =
          "创建一条数据成功：${bmobSaved?.objectId} - ${bmobSaved?.createdAt}";
      print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      if (shouldUpdate == true) {
        await queryWhereEqual_ChatGptMessageModel(shouldRefresh: true);
      } else {
        chatGptMessageModel?.objectId = bmobSaved?.objectId;
        if (chatGptMessageModel != null) {
          this.listChatGptMessageModel.add(chatGptMessageModel);
          context?.read<GlobalStateEnv>().listChatGptMessageModel =
              this.listChatGptMessageModel;
        }
      }
      return bmobSaved;
    } catch (e) {
      print(MongoDbError.convert(e)?.error);
    } finally {
      // await dbUtil.close();
    }
  }

  Future<MongoDbSaved?> insertCreditCardModel(
      {CreditCardModel? creditCardModel, Function? callback}) async {
    try {
      User user = User();
      user.setObjectId(LoginManager.getInstance().getUid());
      creditCardModel?.uid = LoginManager.getInstance().getUid();
      creditCardModel?.device_id = this.device_id;
      MongoDbSaved? bmobSaved = await creditCardModel?.save();
      String message =
          "创建一条数据成功：${bmobSaved?.objectId} - ${bmobSaved?.createdAt}";
      print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      await queryWhereEqual_creditModel(shouldRefresh: true);
      return bmobSaved;
    } catch (e) {
      print(MongoDbError.convert(e)?.error);
    } finally {
      // await dbUtil.close();
    }
  }

  Future<MongoDbSaved?> insertChatGptFolderModel(
      {ChatGptFolderModel? chatGptFolderModel, Function? callback}) async {
    try {
      User user = User();
      user.setObjectId(LoginManager.getInstance().getUid());
      chatGptFolderModel?.uid = LoginManager.getInstance().getUid();
      // chatGptFolderModel?.device_id = this.device_id;
      MongoDbSaved? bmobSaved = await chatGptFolderModel?.save();
      String message =
          "创建一条数据成功：${bmobSaved?.objectId} - ${bmobSaved?.createdAt}";
      print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      await queryWhereEqual_ChatGptFolderModel(shouldRefresh: true);
      return bmobSaved;
    } catch (e) {
      print(MongoDbError.convert(e)?.error);
    } finally {
      // await dbUtil.close();
    }
  }


  Future<MongoDbSaved?> insertBillModel(
      {BillModel? billModel, Function? callback}) async {
    try {
      User user = User();
      user.setObjectId(LoginManager.getInstance().getUid());
      billModel?.uid = LoginManager.getInstance().getUid();
      billModel?.device_id = this.device_id;
      MongoDbSaved? bmobSaved = await billModel?.save();
      String message =
          "创建一条数据成功：${bmobSaved?.objectId} - ${bmobSaved?.createdAt}";
      print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      await queryWhereEqual_billModel(shouldRefresh: true);
      return bmobSaved;
    } catch (e) {
      print(MongoDbError.convert(e)?.error);
    } finally {
      // await dbUtil.close();
    }
  }

  Future<MongoDbSaved?> insertAndUpdateUserInfoModel(
      {required UserInfoModel userInfoModel,
        Function? callback}) async {
    try {

      if(TextUtil.isEmpty(userInfoModel.uid)) {
        userInfoModel.uid = LoginManager.getInstance().getUid();
        User user = User();
        user.setObjectId(LoginManager.getInstance().getUid());
        MongoDbSaved? bmobSaved = await userInfoModel.save();
        String message =
            "创建一条数据成功：${bmobSaved?.objectId} - ${bmobSaved?.createdAt}";
        print(message);
        if (callback != null) {
          callback(bmobSaved);
        }
        UserInfoManager.getSyncInstance().userInfoModel = userInfoModel;
        return bmobSaved;
      } else {
        MongoDbUpdated bmobUpdated = await userInfoModel.update();
        if (callback != null) {
          callback(bmobUpdated);
        }
        UserInfoManager.getSyncInstance().userInfoModel = userInfoModel;
      }
    } catch (e) {
      print(MongoDbError.convert(e)?.error);
    } finally {
      // await dbUtil.close();
    }
  }

  Future<MongoDbSaved?> insertCommentModel(
      {title,
      content,
      String? avatar,
      String? username,
      Function? callback}) async {
    try {
      CommentModel commentModel = CommentModel();
      // folderModel.id = id;
      commentModel.title = title;
      commentModel.avatar = avatar ?? "";
      commentModel.username = username ?? "";
      commentModel.countryCode = DeviceInfoManagement.getCountryCode();
      commentModel.status = 0;
      commentModel.content = content;
      commentModel.uid = LoginManager.getInstance().getUid();
      commentModel.device_id = this.device_id ?? "";

      User user = User();
      user.setObjectId(LoginManager.getInstance().getUid());
      MongoDbSaved? bmobSaved = await commentModel.save();
      String message =
          "创建一条数据成功：${bmobSaved?.objectId} - ${bmobSaved?.createdAt}";
      print(message);
      if (callback != null) {
        callback(bmobSaved);
      }
      return bmobSaved;
    } catch (e) {
      print(MongoDbError.convert(e)?.error);
    } finally {
      // await dbUtil.close();
    }
  }

  /**
   * shouldRefresh 是否需要更新
   * 主要PresentModel进入页面会不断请求这个api
   * 但是如果有数据就不需要刷新
   */
  Future<List<CommentModel>> queryWhereEqual_CommentModel({callback}) async {
    MongoDbQuery<CommentModel> query = MongoDbQuery();
    query.skip = 0;
    query.limit = 100000;
    List<dynamic> data = await query.queryObjects();
    List<CommentModel> listTmp = data.map((i) {
      return CommentModel.fromJson(i);
    }).toList();
    listTmp = listTmp.where((i) {
      return i.countryCode == DeviceInfoManagement.getCountryCode();
    }).toList();
    listTmp = listTmp.reversed.toList();
    if (callback != null) {
      callback(listTmp);
    }
    return listTmp;
  }

  Future<UserInfoModel?> queryWhereEqual_UserInfoModel({callback}) async {
    MongoDbQuery<UserInfoModel> query = MongoDbQuery();
    query.addWhereEqualTo("uid", LoginManager.getInstance().getUid() ?? "");
    query.skip = 0;
    query.limit = 1;
    List<dynamic> data = await query.queryObjects();
    List<UserInfoModel> listTmp = data.map((i) {
      return UserInfoModel.fromJson(i);
    }).toList();
    if (callback != null) {
      callback(listTmp);
    }
    if(listTmp.length > 0) {
      return listTmp[0];
    } else {
      return null;
    }
  }

  /**
   * ChatGptMessageModel
   */
  Future<List<ChatGptMessageModel>> queryWhereEqual_ChatGptMessageModel(
      {bool shouldRefresh = false, callback}) async {
    if (TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid) ==
            true &&
        TextUtil.isEmpty(this.device_id) == true) {
      return [];
    }
    String uid = LoginManager.getInstance().getUid();
    if (TextUtil.isEmpty(uid)) {
      return [];
    }

    if (shouldRefresh == false && this.hasLoadedChatGptMessageModel == true)
      return this.listChatGptMessageModel;

    MongoDbQuery<ChatGptMessageModel> query = MongoDbQuery();

    query.addWhereEqualTo("uid", uid);
    //uid deviceId
    if ((uid == null || uid.isEmpty == true) &&
        (this.device_id == null || this.device_id?.isEmpty == true)) {
      return [];
    }

    query.skip = 0;
    query.limit = 100000;
    List<dynamic> data = await query.queryObjects();

    List<ChatGptMessageModel> listTmp =
        data.map((i) => ChatGptMessageModel.fromJson(i)).toList();
    if (callback != null) {
      callback(listTmp);
    }
    this.hasLoadedChatGptMessageModel = true;
    this.listChatGptMessageModel = listTmp;
    context?.read<GlobalStateEnv>().listChatGptMessageModel = listTmp;

    return listTmp;
  }

  Future batchUpdate_PresentModel(
      {List<PresentModel>? listParam,
      shouldRefresh: true,
      Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      if (element.device_id == this.device_id &&
          TextUtil.isEmpty(element.uid)) {
        element.uid =
            TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? ''
                : LoginManager.getInstance().getUserBean().uid;
      }
    });

    List list = await batch.updateBatch(listParam ?? []);
    await queryWhereEqual_presentModel(shouldRefresh: shouldRefresh);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  Future batchUpdate_MissionModel2(
      {List<MissionModel>? listParam,
      shouldRefresh: true,
      Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      if (element.device_id == this.device_id &&
          TextUtil.isEmpty(element.uid)) {
        element.uid =
            TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? ''
                : LoginManager.getInstance().getUserBean().uid;
      }
    });

    List list = await batch.updateBatch(listParam ?? []);
    await queryWhereEqual_missionData(shouldRefresh: shouldRefresh);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  Future batchUpdate_CreditCardModel(
      {List<CreditCardModel>? listParam,
      shouldRefresh: true,
      Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      if (element.device_id == this.device_id &&
          TextUtil.isEmpty(element.uid)) {
        element.uid =
            TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? ''
                : LoginManager.getInstance().getUserBean().uid;
      }
    });

    List list = await batch.updateBatch(listParam ?? []);
    await queryWhereEqual_creditModel(shouldRefresh: shouldRefresh);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  Future batchUpdate_ChatGptMessageModel(
      {List<ChatGptMessageModel>? listParam,
      shouldRefresh: true,
      Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      if (TextUtil.isEmpty(element.uid)) {
        element.uid =
            TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? ''
                : LoginManager.getInstance().getUserBean().uid;
      }
    });

    List list = await batch.updateBatch(listParam ?? []);
    if (shouldRefresh == true) {
      await queryWhereEqual_ChatGptMessageModel(shouldRefresh: shouldRefresh);
    } else {
      this.listChatGptMessageModel = this.listChatGptMessageModel.map((e) {
        if (listParam?.contains(e) == true) {
          return listParam?.firstWhere((element) {
                return element.objectId == e.objectId;
              }) ??
              e;
        }
        return e;
      }).toList();
      context?.read<GlobalStateEnv>().listChatGptMessageModel =
          this.listChatGptMessageModel;
    }
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  Future batchUpdate_GroupModel(
      {List<GroupModel>? listParam,
      shouldRefresh: true,
      Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      if (element.device_id == this.device_id &&
          TextUtil.isEmpty(element.uid)) {
        element.uid =
            TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? ''
                : LoginManager.getInstance().getUserBean().uid;
      }
    });

    List list = await batch.updateBatch(listParam ?? []);
    await queryWhereEqual_groupModel(shouldRefresh: shouldRefresh);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  Future batchUpdate_BillModel(
      {List<BillModel>? listParam,
      shouldRefresh: true,
      Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      if (element.device_id == this.device_id &&
          TextUtil.isEmpty(element.uid)) {
        element.uid =
            TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
                ? ''
                : LoginManager.getInstance().getUserBean().uid;
      }
    });

    List list = await batch.updateBatch(listParam ?? []);
    await queryWhereEqual_billModel(shouldRefresh: shouldRefresh);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  batchDelete_PresentModel(
      {List<PresentModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    await queryWhereEqual_presentModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  batchDelete_CreditModel(
      {List<CreditCardModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    await queryWhereEqual_creditModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  batchDelete_ChatGptMessageModel(
      {List<ChatGptMessageModel>? listParam,
      bool shouldRefresh = true,
      Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    if (shouldRefresh == true) {
      await queryWhereEqual_ChatGptMessageModel(shouldRefresh: shouldRefresh);
    } else {
      this.listChatGptMessageModel =
          this.listChatGptMessageModel.where((element) {
        return listParam?.contains(element) == false;
      }).toList();
      context?.read<GlobalStateEnv>().listChatGptMessageModel =
          this.listChatGptMessageModel;
    }
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  batchDelete_BillModel(
      {List<BillModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    await queryWhereEqual_billModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  batchDelete_ChatGptFolderModel(
      {List<ChatGptFolderModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
      TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
          ? ''
          : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    await queryWhereEqual_ChatGptFolderModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }



  batchDelete_GroupModel(
      {List<GroupModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    await queryWhereEqual_groupModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  batchDelete_WQBFolderModel(
      {List<WQBFolderModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    await queryWhereEqual_WQBFolderModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  batchDelete_EventCollectionModel(
      {List<EventCollectionModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  batchDelete_FolderModel(
      {List<FolderModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    await queryWhereEqual_folderModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  batchDelete_MissionModel(
      {List<MissionModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    await queryWhereEqual_missionData(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }

    MongoDbSaved? res = await MongoApisManager.getInstance()
        .insertTimelineMissionModel(
            missionModel: Utility.getTimelineMissionModelFromMissionModel(
                icon: Icons.check_circle.codePoint,
                color: Colors.greenAccent.value,
                sceneType: "mission",
                eventType: "batch_delete_mission",
                timelineMessage: getI18NKey()
                    .batch_delete_missions(listParam?.length ?? 0)));
    return list;
  }

  batchDelete_WQBMissionModel(
      {List<WQBMissionModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    await queryWhereEqual_WQBMissionModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }

    // MongoDbSaved? res = await MongoApisManager.getInstance()
    //     .insertTimelineMissionModel(
    //     missionModel: Utility.getTimelineMissionModelFromMissionModel(
    //         icon: Icons.check_circle.codePoint,
    //         color: Colors.greenAccent.value,
    //         sceneType: "mission",
    //         eventType: "create_mission",
    //         timelineMessage: getI18NKey()
    //             .batch_delete_missions(listParam?.length ?? 0)));
    return list;
  }

  batchDelete_StatisticModel(
      {List<StatsModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.deleteBatch(listParam ?? []);
    await queryWhereEqual_statsModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  // batchDelete_EventCollectionModel(
  //     {List<EventCollectionModel> listParam, Function? callback}) async {
  //   MongoDbBatch batch = MongoDbBatch();
  //   listParam.forEach((element) {
  //     element.uid =
  //     TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
  //         ? ''
  //         : LoginManager.getInstance().getUserBean().uid;
  //   });
  //   List list = await batch.deleteBatch(listParam);
  //   await queryWhereEqual_statsModel(shouldRefresh: true);
  //   if (callback != null) {
  //     callback(list);
  //   }
  //   return list;
  // }

  batchInsert_EndTimeMissionModels(
      {List<EndTimeMissionModel>? listParam, Function? callback}) async {
    if (TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid) ==
            true &&
        TextUtil.isEmpty(this.device_id) == true) {
      return;
    }
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.insertBatch(listParam ?? []);
    await queryWhereEqual_EndTimeMissionModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  batchInsert_MissionModelsWithParams(
      {List<MissionModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    List list = await batch.insertBatch(listParam ?? []);
    await queryWhereEqual_missionData(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  batchInsert_GroupModels(
      {List<GroupModel>? listParam, Function? callback}) async {
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.insertBatch(listParam ?? []);
    await queryWhereEqual_groupModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  List<FolderModel> queryFolderModelListByObjectIdList(
      List<String> listObjectIds) {
    List<FolderModel> list = [];
    listObjectIds.forEach((element) {
      FolderModel? folderModel = queryfolderModelWithFolderId(element);
      if (folderModel != null) {
        list.add(folderModel);
      }
    });
    return list;
  }

  batchInsert_MissionModels(
      {List<MissionModel>? listParam, Function? callback}) async {
    if (TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid) ==
            true &&
        TextUtil.isEmpty(this.device_id) == true) {
      return;
    }
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.insertBatch(listParam ?? []);
    await queryWhereEqual_missionData(shouldRefresh: true);

    MongoDbSaved? res = await MongoApisManager.getInstance()
        .insertTimelineMissionModel(
            missionModel: Utility.getTimelineMissionModelFromMissionModel(
                icon: Icons.check_circle.codePoint,
                color: Colors.greenAccent.value,
                sceneType: "mission",
                eventType: "create_mission",
                timelineMessage: getI18NKey()
                    .batch_update_missions(listParam?.length ?? 0)));

    if (callback != null) {
      callback(list);
    }
    return list;
  }

  batchInsert_EventCollection(
      {List<EventCollectionModel>? listParam, Function? callback}) async {
    if (TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid) ==
            true &&
        TextUtil.isEmpty(this.device_id) == true) {
      return;
    }
    MongoDbBatch batch = MongoDbBatch();
    listParam?.forEach((element) {
      element.uid =
          TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
              ? ''
              : LoginManager.getInstance().getUserBean().uid;
    });
    List list = await batch.insertBatch(listParam ?? []);
    await queryWhereEqual_presentModel(shouldRefresh: true);
    if (callback != null) {
      callback(list);
    }
    return list;
  }

  insert_SharePrefenceModel(
      {String? key,
      bool? valueBool,
      List? valueArray,
      int? valueInt,
      String? valueString,
      Function? callback}) async {
    if ((this.device_id == null || this.device_id?.isEmpty == true) &&
        LoginManager.isLogin() == false) {
      return null;
    }
    // List<SharePreferenceModel>? list =
    //     await get_SharePrefenceModel(key: key ?? "");
    // if (list != null && list.length == 0) {
    SharePreferenceModel model = SharePreferenceModel();
    model.key = key;
    model.intVal = valueInt;
    model.arrayVal = valueArray;
    model.boolVal = valueBool;
    model.stringVal = valueString;
    model.update_time = Utility.getTimeStampToday();
    model.create_time = Utility.getTimeStampToday();
    model.uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    model.device_id = this.device_id;
    MongoDbSaved? bmobUpdated = await model.save();
    if (callback != null) {
      callback(bmobUpdated);
    }
    queryWhereEqual_sharePreferenceModel(shouldRefresh: true);
    return bmobUpdated;
    // } else {
    //   return null;
    // }
  }

  update_SharePrefenceModel(
      {String? objectId,
      String? key,
      int? valueInt,
      bool? valueBool,
      String? valueString,
      List? valueArray,
      Function? callback}) async {
    if ((this.device_id == null || this.device_id?.isEmpty == true) &&
        LoginManager.isLogin() == false) {
      return null;
    }
    // List<SharePreferenceModel>? list =
    //     await get_SharePrefenceModel(key: key ?? "");
    // if (list != null) {
    if (TextUtil.isEmpty(objectId)) {
      return null;
    }
    SharePreferenceModel model = SharePreferenceModel();
    model.objectId = objectId;
    model.key = key;
    model.boolVal = valueBool;
    model.intVal = valueInt;
    model.arrayVal = valueArray;
    model.stringVal = valueString;
    model.update_time = Utility.getTimeStampToday();
    model.create_time = Utility.getTimeStampToday();
    model.uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
    model.device_id = this.device_id;
    MongoDbUpdated bmobUpdated = await model.update();
    if (callback != null) {
      callback(bmobUpdated);
    }
    queryWhereEqual_sharePreferenceModel(shouldRefresh: true);
    return bmobUpdated;
    // } else {
    //   return null;
    // }
  }

  List<SharePreferenceModel>? get_SharePrefenceModel(
      {required String key, String? uid, Function? callback}) {
    // if ((this.device_id == null || this.device_id?.isEmpty == true) &&
    //     LoginManager.isLogin() == false) {
    //   return null;
    // }
    //先本地查找 在网络查找 其实没必要网络查找了
    List<SharePreferenceModel> listSharePreferenceModelTmp = [];
    if (listSharePreferenceModel.length > 0) {
      listSharePreferenceModel.forEach((SharePreferenceModel element) {
        if (element.key == key) {
          listSharePreferenceModelTmp.add(element);
        }
      });

      if (listSharePreferenceModelTmp.length > 0) {
        return listSharePreferenceModelTmp;
      }
      return null;
    }
    // List<MongoDbQuery<SharePreferenceModel>> listQuery = [];
    // MongoDbQuery<SharePreferenceModel> query1 = MongoDbQuery();
    // String uid = LoginManager.getInstance().getUid();
    // //uid deviceId
    // if ((uid == null || uid.isEmpty == true) &&
    //     (this.device_id == null || this.device_id?.isEmpty == true)) {
    //   return [];
    // }
    // if (uid.isNotEmpty == true) {
    //   query1.addWhereEqualTo("uid", uid);
    //   listQuery.add(query1);
    // }
    // MongoDbQuery<SharePreferenceModel> query2 = MongoDbQuery();
    // query2.addWhereEqualTo(
    //     "device_id", this.device_id ?? ''); //todo 这里有问题 闪屏页进来拿到空的数据
    // MongoDbQuery<SharePreferenceModel> query3 = MongoDbQuery();
    // query3.addWhereEqualTo("key", key); //todo 这里有问题 闪屏页进来拿到空的数据
    //
    // listQuery.add(query2);
    // // list.add(query3);
    // MongoDbQuery<SharePreferenceModel> query = MongoDbQuery();
    // query.or(listQuery);
    // query.and([query3]);
    // query.skip = 0;
    // query.limit = 1;
    // try {
    //   //没有网络这里会跳过
    //   List<dynamic> data = await query.queryObjects();
    //
    //   List<SharePreferenceModel> sharePrefrenceModelList =
    //       data.map((i) => SharePreferenceModel.fromJson(i)).toList();
    //
    //   if (callback != null) {
    //     callback(sharePrefrenceModelList);
    //   }
    //   return sharePrefrenceModelList;
    // } catch (e) {
    //   return null;
    // }
  }
}
