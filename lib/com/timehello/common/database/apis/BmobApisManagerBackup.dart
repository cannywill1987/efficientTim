// import 'package:data_plugin/bmob/bmob_installation_manager.dart';
// import 'package:data_plugin/bmob/bmob_query.dart';
// import 'package:data_plugin/bmob/bmob_sms.dart';
// import 'package:data_plugin/bmob/response/bmob_error.dart';
// import 'package:data_plugin/bmob/response/bmob_handled.dart';
// import 'package:data_plugin/bmob/response/bmob_registered.dart';
// import 'package:data_plugin/bmob/response/bmob_saved.dart';
// import 'package:data_plugin/bmob/response/bmob_sent.dart';
// import 'package:data_plugin/bmob/response/bmob_updated.dart';
// import 'package:data_plugin/bmob/table/bmob_installation.dart';
// import 'package:data_plugin/bmob/table/bmob_user.dart';
// import 'package:data_plugin/bmob/type/bmob_acl.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
// import 'package:time_hello/com/timehello/config/ENUMS.dart';
// import 'package:time_hello/com/timehello/config/Params.dart';
// import 'package:time_hello/com/timehello/libs/bmob/bmob/bmob_batch.dart';
// import 'package:time_hello/com/timehello/models/Blog.dart';
// import 'package:time_hello/com/timehello/models/FolderModel.dart';
// import 'package:time_hello/com/timehello/models/MissionModel.dart';
// import 'package:time_hello/com/timehello/models/StatsModel.dart';
// import 'package:time_hello/com/timehello/models/User.dart';
// import 'package:time_hello/com/timehello/util/DBUtil.dart';
// import 'package:time_hello/com/timehello/util/LoginManager.dart';
// import 'package:time_hello/com/timehello/util/TablesInit.dart';
// import 'package:time_hello/com/timehello/util/TextUtil.dart';
// import 'package:time_hello/com/timehello/util/Utility.dart';
//
// /**
//  * 请参考 https://www.bmob.cn/app/secret/311157
//  * https://github.com/bmob/bmob-flutter-sdk
//  * ApplicationId: 0f3592baa6ce18dcab13dde4660a0ed1
//  * REST API KEY:d20617f5d73c96a94509a77e3856ef39
//  * SECRET KEY: 8057ce55d5a89d7a
//  * MASTER KEY: cfe56bc01ee90da9285ec62e6ba2b698
//  * 文档: http://doc.bmob.cn/data/flutter/index.html#28
//  * {'success': true, 'data': bmobUser, 'message': null}
//  */
// class BmobApisManager {
//   static BmobApisManager _instance;
//   DBUtil dbUtil;
//   String device_id;
//   bool hasLoadedFolderModels = false;
//   bool hasLoadedMissionModels = false;
//   bool hasLoadedStatsModels = false;
//   List<FolderModel> listFolderModels = [];
//   List<MissionModel> listMissionModels = [];
//   List<StatsModel> listStatsModels = [];
//
//   static BmobApisManager getInstance() {
//     if (_instance == null) {
//       _instance = new BmobApisManager();
//       _instance.init();
//     }
//     return _instance;
//   }
//
//   init() {
//     TablesInit tables = TablesInit();
//     tables.init();
//     dbUtil = new DBUtil();
//   }
//
//   ///获取设备ID
//   getDeviceId(BuildContext context) async {
//     // String installationId = await Utility.getDeviceId() ??
//     //     await BmobInstallationManager.getInstallationId();
//     String deviceId1, deviceId2;
//     try {
//       deviceId1 = await BmobInstallationManager.getInstallationId();
//     } catch (e) {
//       print(e);
//     }
//     try {
//       deviceId2 = await Utility.getDeviceId();
//     } catch (e) {
//       print(e);
//     }
//     this.device_id = deviceId1 ?? deviceId2;
//     await queryWhereEqual_folderModel(); //初始化listFolderModel
//     await queryWhereEqual_missionData();
//     await queryWhereEqual_statsModel();
//     // print(installationId);
//   }
//
//   //初始化设备，与原生交互
//   ///初始化设备
//   initInstallation(BuildContext context) async {
//     try {
//       await BmobInstallationManager.init();
//     } catch (e) {}
//     // BmobInstallationManager.init().then((BmobInstallation bmobInstallation) {
//     //   print(bmobInstallation.toJson().toString());
//     // }).catchError((e) {
//     //   print(BmobError.convert(e).error);
//     // });
//     await getDeviceId(context);
//   }
//
//   ///用户名和密码登录
//   Future<Map> login(mobile, password, {callback}) async {
//     try {
//       BmobUser bmobUserRegister = BmobUser();
//       bmobUserRegister.username = mobile;
//       bmobUserRegister.password = password;
//       BmobUser bmobUser = await bmobUserRegister.login();
//
//       if (callback != null) {
//         // print(context, bmobUser.getObjectId() + "\n" + bmobUser.username);
//         callback({'success': true, 'data': bmobUser, 'message': null});
//       }
//       return {'success': true, 'data': bmobUser, 'message': null};
//     } catch (e) {
//       if (callback != null) {
//         callback({'success': false, 'message': e.response.data['error']});
//       }
//       return {'success': false, 'message': e.response.data['error']};
//     }
//   }
//
//   loginBySms(String phoneNumber, String smsCode, {callback}) async {
//     try {
//       BmobUser bmobUserRegister = BmobUser();
//       bmobUserRegister.mobilePhoneNumber = phoneNumber;
//       BmobUser bmobUser = await bmobUserRegister.loginBySms(smsCode);
//
//       if (callback != null) {
//         print("登录成功：" + bmobUser.getObjectId() + "\n" + bmobUser.username);
//         callback(true, bmobUser);
//       }
//       return bmobUser;
//     } catch (e) {
//       callback(false);
//     }
//   }
//
//   ///发送短信验证码：需要手机号码
//   sendSms(phonenumber, {callback}) async {
//     try {
//       BmobSms bmobSms = BmobSms();
//       bmobSms.template = "";
//       bmobSms.mobilePhoneNumber = phonenumber;
//       BmobSent bmobSent = await bmobSms.sendSms();
//
//       if (callback != null) {
//         print("发送成功:" + bmobSent.smsId.toString());
//         callback(true, bmobSent);
//       }
//     } catch (e) {
//       print(BmobError.convert(e).error);
//       callback(false);
//     }
//   }
//
//   ///用户名密码注册
//   register(username, password, {callback}) async {
//     try {
//       BmobUser bmobUserRegister = BmobUser();
//       bmobUserRegister.username = username;
//       bmobUserRegister.mobilePhoneNumber = username;
//       bmobUserRegister.password = password;
//       BmobRegistered bmobUser = await bmobUserRegister.register();
//       if (callback != null) {
//         print(bmobUser.objectId);
//         callback(true, {'success': true, 'message': ''});
//       }
//       return {'success': true, 'message': ''};
//     } catch (e) {
//       callback({'success': false, 'message': e.response.data['error']});
//       return e.response.data['error'];
//     }
//   }
//
//   ///验证短信验证码：需要手机号码和验证码
//   Future<Map> verifySmsCode(mobile, msn, {callback}) async {
//     try {
//       BmobSms bmobSms = BmobSms();
//       bmobSms.mobilePhoneNumber = mobile;
//
//       BmobHandled bmobUser = await bmobSms.verifySmsCode(msn);
//       if (callback != null) {
//         callback(true, bmobUser);
//       }
//       return {'success': true, 'message': ''};
//     } catch (e) {
//       if (callback != null) {
//         callback(false, e.response.error);
//       }
//       return {'success': false, 'message': '短信验证码错误'};
//     }
//   }
//
//   ///等于条件查询
//   List<MissionModel> queryWhereEqual_missionDataByEndTime(
//       {int start_endTime,
//         int end_endTime,
//         List<FolderModel> folderModelList,
//         callback}) {
//     List<MissionModel> list = [];
//
//     for (int i = 0; i < this.listMissionModels.length; i++) {
//       MissionModel model = this.listMissionModels[i];
//       if (start_endTime != null && end_endTime != null) {
//         if (start_endTime != null && model.end_time >= start_endTime) {
//           if (end_endTime != null && model.end_time <= end_endTime) {
//             // model.ic
//             list.add(model);
//           }
//         }
//       } else if (start_endTime != null && end_endTime == null) {
//         if (model.end_time >= start_endTime) {
//           list.add(model);
//         }
//       } else if (start_endTime == null && end_endTime != null) {
//         if (model.end_time <= end_endTime) {
//           list.add(model);
//         }
//       } else {
//         list.add(model);
//       }
//     }
//     return list;
//   }
//
//   static List<MissionModel> getFinishedMissionModelsFromList(
//       List<MissionModel> list) {
//     List<MissionModel> listTmp = [];
//     list.forEach((element) {
//       if (element.isFinished == false) {
//         listTmp.add(element);
//       }
//     });
//     return listTmp;
//   }
//
//   ///等于条件查询
//   List<MissionModel> queryWhereEqual_missionDataByFinished({callback}) {
//     List<MissionModel> list = [];
//
//     for (int i = 0; i < this.listMissionModels.length; i++) {
//       MissionModel model = this.listMissionModels[i];
//       if (model.isFinished == true) {
//         list.add(model);
//       }
//     }
//     return list;
//   }
//
//   FolderModel getIcon(int folderId, List<FolderModel> folderModelList) {
//     for (int i = 0; i < folderModelList.length; i++) {
//       FolderModel folderModel = folderModelList[i];
//       if (folderModel.objectId == folderId) {
//         return folderModel;
//       }
//     }
//     return null;
//   }
//
//   ///完成任务数量
//   List<MissionModel> queryWhereEqual_missionDataByObjectId({String objectId}) {
//     List<MissionModel> list = [];
//     for (int i = 0; i < this.listMissionModels.length; i++) {
//       MissionModel model = this.listMissionModels[i];
//       if (model.objectId == objectId) {
//         list.add(model);
//       }
//     }
//     return list;
//   }
//
//   ///完成任务数量
//   List<MissionModel> queryWhereEqual_missionDataByFolderId({String folder_id}) {
//     List<MissionModel> list = [];
//     for (int i = 0; i < this.listMissionModels.length; i++) {
//       MissionModel model = this.listMissionModels[i];
//       if (model.folder_id == folder_id) {
//         list.add(model);
//       }
//     }
//     return list;
//   }
//
//   List<MissionModel> queryWhereEqual_missionDataByTagName({String tagName}) {
//     if (TextUtil.isEmpty(tagName)) {
//       return [];
//     }
//     List<MissionModel> list = [];
//     for (int i = 0; i < this.listMissionModels.length; i++) {
//       MissionModel model = this.listMissionModels[i];
//       if (model.tagNames != null && model.tagNames.indexOf(tagName) != -1) {
//         list.add(model);
//       }
//     }
//     return list;
//   }
//
//   ///完成任务数量
//   List<MissionModel> queryWhereEqual_missionDataByFolderModelObjectId(
//       {String objectId}) {
//     List<MissionModel> list = [];
//     for (int i = 0; i < this.listMissionModels.length; i++) {
//       MissionModel model = this.listMissionModels[i];
//       if (model.folder_id == objectId) {
//         list.add(model);
//       }
//     }
//     return list;
//   }
//
//   ///完成任务数量
//   List<MissionModel> queryWhereEqual_missionDataByFinishedMission(
//       {isFinished = true}) {
//     List<MissionModel> list = [];
//     for (int i = 0; i < this.listMissionModels.length; i++) {
//       MissionModel model = this.listMissionModels[i];
//       if (model.isFinished) {
//         list.add(model);
//       }
//     }
//     return list;
//   }
//
//   ///等于条件查询
//   Future<List<MissionModel>> queryWhereEqual_missionData(
//       {String folder_id,
//         String currentObjectId,
//         bool shouldRefresh = true,
//         title,
//         description,
//         device_id,
//         order_index,
//         dateStatus,
//         tagName,
//         tagId,
//         priorityStatus,
//         total_tomotoes,
//         no_tomotoes_finished,
//         tomato_duration,
//         callback}) async {
//     if (shouldRefresh == false && this.hasLoadedMissionModels == true)
//       return this.listMissionModels;
//
//     this.hasLoadedMissionModels = true;
//     BmobQuery<MissionModel> query = BmobQuery();
//     BmobQuery<MissionModel> queryUid = BmobQuery();
//     BmobQuery<MissionModel> queryUidAndDeviceId = BmobQuery();
//
//     BmobQuery<MissionModel> query1, query2, query3, query4, query5, query6;
//
//     BmobQuery<MissionModel> queryDeviceId = BmobQuery();
//     queryDeviceId.addWhereEqualTo("device_id", this.device_id);
//
//     List<BmobQuery<MissionModel>> list2 = new List();
//     String uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//         ? ''
//         : LoginManager.getInstance().getUserBean().uid;
//     if (uid.isNotEmpty == true) {
//       queryUid.addWhereEqualTo("uid", uid);
//       list2.add(queryUid);
//     }
//     list2.add(queryDeviceId);
//
//     queryUidAndDeviceId.or(list2);
//
//     if (TextUtil.isEmpty(folder_id) != true) {
//       query1 = BmobQuery();
//       query1.addWhereEqualTo("folder_id", folder_id);
//     }
//     if (TextUtil.isEmpty(tagName) != true) {
//       query2 = BmobQuery();
//       query2.addWhereEqualTo("tagName", tagName);
//     }
//     if (TextUtil.isEmpty(title) != true) {
//       query3 = BmobQuery();
//       query3.addWhereEqualTo("title", title);
//     }
//     if (TextUtil.isEmpty(currentObjectId) != true) {
//       query4 = BmobQuery();
//       query4.addWhereEqualTo("objectId", currentObjectId);
//     }
//     if (TextUtil.isEmpty(tagId) != true) {
//       query5 = BmobQuery();
//       query5.addWhereEqualTo("tagIds", tagId);
//     }
//     if (TextUtil.isEmpty(device_id) != true) {
//       query6 = BmobQuery();
//       query6.addWhereEqualTo("device_id", device_id);
//     }
//     List<BmobQuery<MissionModel>> list = new List();
//     list.add(queryUidAndDeviceId);
//     if (query1 != null) list.add(query1);
//     if (query2 != null) list.add(query2);
//     if (query3 != null) list.add(query3);
//     if (query4 != null) list.add(query4);
//     if (query5 != null) list.add(query5);
//     if (query6 != null) list.add(query6);
//     if (query2 != null) list.add(query2);
//     query.and(list);
//     query.skip = 0;
//     query.limit = 100000;
//     // BmobAcl bmobAcl = BmobAcl();
//     // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
//     // query.addWhereEqualTo("title", "博客标题");
//     List<dynamic> data = await query.queryObjects();
//     print(data.toString());
//     List<MissionModel> missionModels =
//     data.map((i) => MissionModel.fromJson(i)).toList();
//     missionModels.forEach((element) {
//       if (TextUtil.isEmpty(element.uid) == true) {
//         element.uid =
//         !TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//             ? LoginManager.getInstance().getUserBean().uid
//             : '';
//       }
//       if (element.no_tomotoes_finished == null)
//         element.no_tomotoes_finished = 0;
//       if (element.total_tomotoes == null) element.total_tomotoes = 0;
//       if (element.tomato_duration == null) element.tomato_duration = 0;
//       if (element.order_index == null) element.order_index = 0;
//       if (element.end_time == null) element.end_time = 0;
//       if (element.alert_time == null) element.alert_time = 0;
//     });
//
//     this.listMissionModels = missionModels;
//     if (callback != null) {
//       callback(missionModels);
//     }
//     return missionModels;
//   }
//
//   ///等于条件查询
//   List<StatsModel> queryWhereEqual_statModelsByTime(
//       {int start_endTime, int end_endTime, int type = 0, callback}) {
//     List<StatsModel> list = [];
//     for (int i = 0; i < this.listStatsModels.length; i++) {
//       StatsModel model = this.listStatsModels[i];
//       if (start_endTime != null && end_endTime != null) {
//         if (start_endTime != null &&
//             Utility.getTimestampFromDateTime(model.updatedAt) >=
//                 start_endTime) {
//           if (end_endTime != null &&
//               Utility.getTimestampFromDateTime(model.updatedAt) <=
//                   end_endTime) {
//             if (model.type == type) {
//               list.add(model);
//             }
//           }
//         }
//       } else if (start_endTime != null && end_endTime == null) {
//         if (Utility.getTimestampFromDateTime(model.updatedAt) >=
//             start_endTime) {
//           if (model.type == type) {
//             list.add(model);
//           }
//         }
//       } else if (start_endTime == null && end_endTime != null) {
//         if (Utility.getTimestampFromDateTime(model.updatedAt) <= end_endTime) {
//           if (model.type == type) {
//             list.add(model);
//           }
//         }
//       } else {
//         if (model.type == type) {
//           list.add(model);
//         }
//       }
//     }
//     return list;
//   }
//
//   ///等于条件查询
//   Future<List<StatsModel>> queryWhereEqual_statsModel(
//       {type = 0,
//         tagName,
//         category,
//         shouldRefresh = true,
//         value,
//         callback}) async {
//     if (shouldRefresh == false && this.hasLoadedStatsModels == true) {
//       return this.listStatsModels;
//     }
//     BmobQuery<StatsModel> query = BmobQuery();
//     BmobQuery<StatsModel> query1;
//     String uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//         ? ''
//         : LoginManager.getInstance().getUserBean().uid;
//     if (uid.isNotEmpty == true) {
//       query1 = BmobQuery();
//       query1.addWhereEqualTo("uid", uid);
//     }
//     // if (TextUtil.isEmpty(tagName) != true) {
//     //   query.addWhereEqualTo("tagName", tagName);
//     // }
//     // if (TextUtil.isEmpty(title) != true) {
//     //   query.addWhereEqualTo("title", title);
//     // }
//     // if (TextUtil.isEmpty(begin_time) != true) {
//     //   query.addWhereEqualTo("objectId", begin_time);
//     // }
//     // if (TextUtil.isEmpty(finish_time) != true) {
//     //   query.addWhereEqualTo("tagId", finish_time);
//     // }
//     BmobQuery<StatsModel> query2 = BmobQuery();
//     query2.addWhereEqualTo("device_id", this.device_id);
//
//     List<BmobQuery<StatsModel>> list = new List();
//     if (query1 != null) {
//       list.add(query1);
//     }
//     list.add(query2);
//     query.or(list);
//     query.skip = 0;
//     query.limit = 100000;
//     // BmobAcl bmobAcl = BmobAcl();
//     // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
//     // query.addWhereEqualTo("title", "博客标题");
//     List<dynamic> data = await query.queryObjects();
//     print(data.toString());
//     List<StatsModel> listStatsModels = data.map((i) {
//       return StatsModel.fromJson(i);
//     }).toList();
//     this.listStatsModels = listStatsModels;
//     listStatsModels.forEach((element) {
//       if (element.title == null) element.title = '';
//       if (element.type == null) element.type = 0;
//       if (element.color == null) element.color = 0;
//       if (element.icon == null) element.icon = 0;
//       if (element.device_id == null) element.device_id = this.device_id;
//       if (TextUtil.isEmpty(element.uid) == true) {
//         element.uid =
//         !TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//             ? LoginManager.getInstance().getUserBean().uid
//             : '';
//       }
//     });
//     hasLoadedStatsModels = true;
//     if (callback != null) {
//       callback(listStatsModels);
//     }
//     return listStatsModels;
//   }
//
//   ///等于条件查询
//   List<FolderModel> queryWhereEqual_folderModelWithTag({callback}) {
//     List<FolderModel> list = [];
//     for (int i = 0; i < this.listFolderModels.length; i++) {
//       FolderModel folderModel = this.listFolderModels[i];
//       if (folderModel.tag == 2) {
//         list.add(folderModel);
//       }
//     }
//     if (callback != null) {
//       callback(list);
//     }
//     return list;
//   }
//
//   ///等于条件查询
//   List<FolderModel> queryWhereEqual_folderModelWithFolderId(folder_id,
//       {callback}) {
//     List<FolderModel> listFolderModel = [];
//     for (int i = 0; i < this.listFolderModels.length; i++) {
//       FolderModel folderModel = this.listFolderModels[i];
//       if (folderModel.objectId == folder_id) {
//         listFolderModel.add(folderModel);
//       }
//     }
//     return listFolderModel;
//   }
//
//   ///等于条件查询
//   Future<List<FolderModel>> queryWhereEqual_folderModelWithCircle(
//       {callback}) async {
//     List<FolderModel> list = [];
//     for (int i = 0; i < this.listFolderModels.length; i++) {
//       FolderModel folderModel = this.listFolderModels[i];
//       if (folderModel.tag == 1) {
//         list.add(folderModel);
//       }
//     }
//     if (callback != null) {
//       callback(list);
//     }
//     return list;
//   }
//
//   /**
//    * shouldRefresh 是否需要更新
//    * 主要folderpage进入页面会不断请求这个api
//    * 但是如果有数据就不需要刷新
//    */
//   Future<List<FolderModel>> queryWhereEqual_folderModel(
//       {shouldRefresh = true, callback}) async {
//     if (shouldRefresh == false && this.hasLoadedFolderModels == true)
//       return this.listFolderModels;
//     List<BmobQuery<FolderModel>> list = new List();
//     BmobQuery<FolderModel> query1 = BmobQuery();
//     String uid = TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//         ? ''
//         : LoginManager.getInstance().getUserBean().uid;
//     if (uid.isNotEmpty == true) {
//       query1.addWhereEqualTo("uid", uid);
//       list.add(query1);
//     }
//     BmobQuery<FolderModel> query2 = BmobQuery();
//     query2.addWhereEqualTo(
//         "device_id", this.device_id); //todo 这里有问题 闪屏页进来拿到空的数据
//     list.add(query2);
//     BmobQuery<FolderModel> query = BmobQuery();
//     query.or(list);
//     query.skip = 0;
//     query.limit = 100000;
//     List<dynamic> data = await query.queryObjects();
//     List<FolderModel> folderModelList =
//     data.map((i) => FolderModel.fromJson(i)).toList();
//     folderModelList.forEach((element) {
//       if (TextUtil.isEmpty(element.uid) == true) {
//         element.uid =
//         !TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//             ? LoginManager.getInstance().getUserBean().uid
//             : '';
//       }
//       if (element.color == null) element.color = 0;
//       if (element.update_time == null) element.update_time = 0;
//       if (element.create_time == null) element.create_time = 0;
//       if (element.tagColor == null) element.tagColor = 0;
//       if (element.tag == null) element.tag = 0;
//       if (element.icon == null) element.icon = 0;
//     });
//     this.hasLoadedFolderModels = true;
//     this.listFolderModels = folderModelList;
//     if (callback != null) {
//       callback(folderModelList);
//     }
//     return folderModelList;
//   }
//
//   Future<bool> isTagNameExist_folderModel({title, callback}) async {
//     BmobQuery<FolderModel> query = BmobQuery();
//     query.addWhereEqualTo(
//         "uid",
//         TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//             ? ''
//             : LoginManager.getInstance().getUserBean().uid);
//     query.addWhereEqualTo("title", title);
//
//     query.setLimit(1);
//     query.setSkip(0);
//     // BmobAcl bmobAcl = BmobAcl();
//     // bmobAcl.addRoleReadAccess(user.getObjectId(), true);
//     // query.addWhereEqualTo("title", "博客标题");
//     List<dynamic> data = await query.queryObjects();
//     print(data.toString());
//     List<FolderModel> folderModelList =
//     data.map((i) => FolderModel.fromJson(i)).toList();
//     for (FolderModel folderModel in folderModelList) {
//       if (folderModel != null) {
//         print(folderModel.objectId);
//         print(folderModel.title);
//         // print(missionModel.content);
//       }
//     }
//     if (callback != null) {
//       callback(folderModelList.length > 0 ? true : false);
//     }
//     return folderModelList.length > 0 ? true : false;
//   }
//
//   Future<BmobSaved> insertMissiontData(
//       {MissionModel missionModel,
//         folder_id,
//         title,
//         description,
//         priorityStatus,
//         end_time,
//         device_id,
//         tagName,
//         order_index,
//         tagId,
//         total_tomotoes,
//         no_tomotoes_finished,
//         dateStatus,
//         tomato_duration,
//         Function callback}) async {
//     try {
//       MissionModel missionModelTmp = missionModel ?? MissionModel();
//       missionModelTmp.uid =
//       TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//           ? ''
//           : LoginManager.getInstance().getUserBean().uid;
//       missionModelTmp.no_tomotoes_finished = 0;
//       missionModelTmp.device_id = this.device_id;
//       if (missionModel == null) {
//         missionModel.end_time = end_time ?? CONSTANTS.getDeadLineTme(1);
//         missionModelTmp.total_tomotoes = total_tomotoes;
//         missionModelTmp.folder_id = folder_id;
//         missionModelTmp.title = title;
//         // missionModel.tagId = tagId;
//         missionModelTmp.tagNames = tagName;
//         missionModelTmp.order_index = order_index;
//         missionModelTmp.priorityStatus = priorityStatus;
//
//         missionModelTmp.dateStatus = dateStatus;
//         missionModelTmp.tomato_duration = tomato_duration;
//       }
//       BmobAcl bmobAcl = BmobAcl();
//       bmobAcl.setPublicReadAccess(true);
//       missionModelTmp.setAcl(bmobAcl);
//
//       BmobSaved bmobSaved = await missionModelTmp.save();
//       await queryWhereEqual_missionData(
//         shouldRefresh: true,
//       ); //更新 missionModels
//       String message =
//           "创建一条数据成功：${bmobSaved.objectId} - ${bmobSaved.createdAt}";
//       print(message);
//       if (callback != null) {
//         callback(bmobSaved);
//       }
//       return bmobSaved;
//     } finally {
//       // await dbUtil.close();
//     }
//   }
//
//   Future<BmobSaved> insertStatsModel(
//       {StatsModel statsModel,
//         title,
//         type = 0,
//         tagName,
//         category,
//         color,
//         icon,
//         value,
//         begin_time,
//         finish_time,
//         Function callback}) async {
//     try {
//       StatsModel statsModelTmp = statsModel ?? StatsModel();
//       statsModelTmp.uid =
//       TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//           ? ''
//           : LoginManager.getInstance().getUserBean().uid;
//       statsModelTmp.device_id = this.device_id;
//       if (statsModel == null) {
//         statsModelTmp.title = title;
//         statsModelTmp.value = value;
//         statsModelTmp.color = color;
//         statsModelTmp.icon = icon;
//         statsModelTmp.type = type;
//         // missionModel.tagId = tagId;
//         statsModelTmp.tagNames = tagName != null ? tagName : '';
//         statsModelTmp.begin_time = begin_time;
//         statsModelTmp.finish_time = finish_time;
//       }
//       // BmobAcl bmobAcl = BmobAcl();
//       // bmobAcl.setPublicReadAccess(true);
//       // statsModelTmp.setAcl(bmobAcl);
//
//       BmobSaved bmobSaved = await statsModelTmp.save();
//       await queryWhereEqual_statsModel(); //更新 missionModels
//       String message =
//           "创建一条数据成功：${bmobSaved.objectId} - ${bmobSaved.createdAt}";
//       print(message);
//       if (callback != null) {
//         callback(bmobSaved);
//       }
//       return bmobSaved;
//     } finally {
//       // await dbUtil.close();
//     }
//   }
//
//   Future<BmobSaved> insertFolderData(
//       {id,
//         title,
//         description,
//         number,
//         color,
//         icon,
//         tagName,
//         tag,
//         order_index,
//         no_tomotoes_finished,
//         tomato_duration,
//         Function callback}) async {
//     try {
//       FolderModel folderModel = FolderModel();
//       // folderModel.id = id;
//       folderModel.title = title;
//       folderModel.description = description;
//       folderModel.device_id = this.device_id;
//       folderModel.number = number;
//       folderModel.tag = tag;
//       folderModel.icon = icon ?? Icons.local_offer.codePoint;
//       folderModel.tagName = tagName;
//       folderModel.color = color;
//       folderModel.uid =
//       TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//           ? ''
//           : LoginManager.getInstance().getUserBean().uid;
//       folderModel.update_time = Utility.getTimeStampToday();
//       folderModel.create_time = Utility.getTimeStampToday();
//       User user = User();
//       user.setObjectId(
//           TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//               ? ''
//               : LoginManager.getInstance().getUserBean().uid);
//       BmobAcl bmobAcl = BmobAcl();
//       bmobAcl.setPublicReadAccess(true);
//       folderModel.setAcl(bmobAcl);
//       if (await isTagNameExist_folderModel(title: title) == true) {
//         if (callback != null) {
//           callback(null);
//         }
//         return null;
//       }
//       BmobSaved bmobSaved = await folderModel.save();
//       await queryWhereEqual_folderModel(shouldRefresh: true);
//       String message =
//           "创建一条数据成功：${bmobSaved.objectId} - ${bmobSaved.createdAt}";
//       print(message);
//       if (callback != null) {
//         callback(bmobSaved);
//       }
//       return bmobSaved;
//     } catch (e) {
//       print(BmobError.convert(e).error);
//     } finally {
//       // await dbUtil.close();
//     }
//   }
//
//   /**
//    * 完成该任务
//    */
//   finish_MissionModel({
//     MissionModel missionModel,
//     Function callback,
//   }) async {
//     // if (currentObjectId != null) {
//     //   MissionModel missionModel = MissionModel();
//     //   missionModel.objectId = currentObjectId;
//     missionModel.isFinished = true;
//     // missionModel.update_time = Utility.getTimeStamp();
//     missionModel.uid =
//     TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//         ? ''
//         : LoginManager.getInstance().getUserBean().uid;
//     BmobUpdated bmobUpdated = await missionModel.update();
//     await queryWhereEqual_missionData(
//       shouldRefresh: true,
//     ); //更新 missionModels
//     if (callback != null) {
//       callback(bmobUpdated);
//     }
//     print("修改一条数据成功：${bmobUpdated.updatedAt}");
//     return bmobUpdated;
//     // } else {
//     //   print("请先新增一条数据");
//     //   // showError(context, "请先新增一条数据");
//     // }
//   }
//
//   ///修改一条数据
//   update_MissionModel(
//       {
//         // folder_id,
//         // title,
//         // description,
//         // device_id,
//         // order_index,
//         // end_time,
//         // dateStatus,
//         // tagName,
//         // tagId,
//         // priorityStatus,
//         // total_tomotoes,
//         // time_finished,
//         // no_tomotoes_finished,
//         // tomato_duration,
//         MissionModel missionModel,
//         Function callback,
//         currentObjectId}) async {
//     // if (currentObjectId != null) {
//     MissionModel missionModelTmp = missionModel ?? MissionModel();
//     if (!TextUtil.isEmpty(currentObjectId)) {
//       missionModelTmp.objectId = currentObjectId;
//     }
//     // if (!TextUtil.isEmpty(end_time)) {
//     //   missionModelTmp.end_time = end_time;
//     // }
//     // if (!TextUtil.isEmpty(folder_id)) {
//     //   missionModelTmp.folder_id = folder_id;
//     // }
//     // if (!TextUtil.isEmpty(title)) {
//     //   missionModelTmp.title = title;
//     // }
//     // if (!TextUtil.isEmpty(total_tomotoes)) {
//     //   missionModelTmp.total_tomotoes = total_tomotoes;
//     // }
//     // if (!TextUtil.isEmpty(dateStatus)) {
//     //   missionModelTmp.dateStatus = dateStatus;
//     // }
//     // if (!TextUtil.isEmpty(tagName)) {
//     //   missionModelTmp.tagNames = tagName;
//     // }
//     //
//     // if (!TextUtil.isEmpty(time_finished)) {
//     //   missionModelTmp.time_finished = time_finished;
//     // }
//     // if (!TextUtil.isEmpty(no_tomotoes_finished)) {
//     //   missionModelTmp.no_tomotoes_finished = no_tomotoes_finished;
//     // }
//     // if (!TextUtil.isEmpty(priorityStatus)) {
//     //   missionModelTmp.priorityStatus = priorityStatus;
//     // }
//     // // if (!TextUtil.isEmpty(tagId)) {
//     // //   missionModelTmp.tagId = tagId;
//     // // }
//     //
//     // if (!TextUtil.isEmpty(tomato_duration)) {
//     //   missionModelTmp.tomato_duration = tomato_duration;
//     // }
//     // missionModelTmp.device_id = this.device_id;
//     // if (!TextUtil.isEmpty(order_index)) {
//     //   missionModelTmp.order_index = order_index;
//     // }
//
//     // missionModelTmp.update_time = Utility.getTimeStamp();
//     missionModelTmp.uid =
//     TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//         ? ''
//         : LoginManager.getInstance().getUserBean().uid;
//     BmobUpdated bmobUpdated = await missionModelTmp.update();
//     await queryWhereEqual_missionData(
//       shouldRefresh: true,
//     ); //更新 missionModels
//     if (callback != null) {
//       callback(bmobUpdated);
//     }
//     print("修改一条数据成功：${bmobUpdated.updatedAt}");
//     return bmobUpdated;
//     // } else {
//     //   print("请先新增一条数据");
//     //   // showError(context, "请先新增一条数据");
//     // }
//   }
//
//   ///修改一条数据
//   update_StatsModel(
//       {StatsModel missionModel,
//         title,
//         type,
//         tagName,
//         category,
//         value,
//         color,
//         icon,
//         begin_time,
//         finish_time,
//         Function callback,
//         currentObjectId}) async {
//     // if (currentObjectId != null) {
//     StatsModel missionModelTmp = missionModel ?? StatsModel();
//
//     if (!TextUtil.isEmpty(icon)) {
//       missionModelTmp.icon = icon;
//     }
//
//     if (!TextUtil.isEmpty(color)) {
//       missionModelTmp.color = color;
//     }
//
//     if (!TextUtil.isEmpty(currentObjectId)) {
//       missionModelTmp.objectId = currentObjectId;
//     }
//     if (!TextUtil.isEmpty(title)) {
//       missionModelTmp.title = title;
//     }
//     if (!TextUtil.isEmpty(type)) {
//       missionModelTmp.type = type;
//     }
//     if (!TextUtil.isEmpty(tagName)) {
//       missionModelTmp.tagNames = tagName;
//     }
//     if (!TextUtil.isEmpty(category)) {
//       missionModelTmp.category = category;
//     }
//     if (!TextUtil.isEmpty(value)) {
//       missionModelTmp.value = value;
//     }
//
//     if (!TextUtil.isEmpty(begin_time)) {
//       missionModelTmp.begin_time = begin_time;
//     }
//     if (!TextUtil.isEmpty(finish_time)) {
//       missionModelTmp.finish_time = finish_time;
//     }
//     missionModelTmp.device_id = this.device_id;
//
//     // missionModelTmp.update_time = Utility.getTimeStamp();
//     missionModelTmp.uid =
//     TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//         ? ''
//         : LoginManager.getInstance().getUserBean().uid;
//     BmobUpdated bmobUpdated = await missionModelTmp.update();
//     await queryWhereEqual_statsModel(); //更新 missionModels
//     if (callback != null) {
//       callback(bmobUpdated);
//     }
//     print("修改一条数据成功：${bmobUpdated.updatedAt}");
//     return bmobUpdated;
//     // } else {
//     //   print("请先新增一条数据");
//     //   // showError(context, "请先新增一条数据");
//     // }
//   }
//
//   ///修改一条数据
//   update_FolderModel(
//       {id,
//         title,
//         description,
//         number,
//         icon,
//         tagName,
//         color,
//         order_index,
//         tag,
//         no_tomotoes_finished,
//         tomato_duration,
//         Function callback,
//         currentObjectId}) async {
//     if (currentObjectId != null) {
//       FolderModel folderModel = FolderModel();
//       if (!TextUtil.isEmpty(currentObjectId)) {
//         folderModel.objectId = currentObjectId;
//       }
//       if (!TextUtil.isEmpty(title)) {
//         folderModel.title = title;
//       }
//       if (!TextUtil.isEmpty(description)) {
//         folderModel.description = description;
//       }
//       if (!TextUtil.isEmpty(color)) {
//         folderModel.color = color;
//       }
//       if (!TextUtil.isEmpty(icon)) {
//         folderModel.icon = icon;
//       }
//       if (!TextUtil.isEmpty(device_id)) {
//         folderModel.device_id = device_id;
//       }
//       if (!TextUtil.isEmpty(tagName)) {
//         folderModel.tagName = tagName;
//       }
//       if (!TextUtil.isEmpty(tag)) {
//         folderModel.tag = tag;
//       }
//       if (!TextUtil.isEmpty(number)) {
//         folderModel.number = number;
//       }
//       folderModel.uid =
//       TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//           ? ''
//           : LoginManager.getInstance().getUserBean().uid;
//       // folderModel.update_time = Utility.getTimeStamp();
//       BmobUpdated bmobUpdated = await folderModel.update();
//       await queryWhereEqual_folderModel(shouldRefresh: true);
//       if (callback != null) {
//         callback(bmobUpdated);
//       }
//       print("修改一条数据成功：${bmobUpdated.updatedAt}");
//       return bmobUpdated;
//     } else {
//       print("请先新增一条数据");
//       // showError(context, "请先新增一条数据");
//     }
//   }
//
//   batchUpdate_MissionModel(
//       {currentObjectId, folder_id, Function callback}) async {
//     List<MissionModel> listParam = await queryWhereEqual_missionData(
//       shouldRefresh: true,
//     );
//     BmobBatch batch = BmobBatch();
//     listParam.forEach((element) {
//       element.uid =
//       TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//           ? ''
//           : LoginManager.getInstance().getUserBean().uid;
//     });
//     User user = User();
//     user.setObjectId(
//         TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//             ? ''
//             : LoginManager.getInstance().getUserBean().uid);
//     BmobAcl bmobAcl = BmobAcl();
//     bmobAcl.addRoleReadAccess(user.getObjectId(), true);
//     List list = await batch.updateBatch(listParam);
//     if (callback != null) {
//       callback(list);
//     }
//     currentObjectId = null;
//     return list;
//   }
//
//   batchUpdate_FolderModel({currentObjectId, Function callback}) async {
//     List<FolderModel> listParam =
//     await queryWhereEqual_folderModel(shouldRefresh: true);
//     BmobBatch batch = BmobBatch();
//     User user = User();
//     user.setObjectId(
//         TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//             ? ''
//             : LoginManager.getInstance().getUserBean().uid);
//     BmobAcl bmobAcl = BmobAcl();
//     bmobAcl.addRoleReadAccess(user.getObjectId(), true);
//     List list = await batch.updateBatch(listParam);
//     if (callback != null) {
//       callback(list);
//     }
//     currentObjectId = null;
//     return list;
//   }
//
//   batchUpdate_StatsModel({currentObjectId, Function callback}) async {
//     List<StatsModel> listParam =
//     await queryWhereEqual_statsModel(shouldRefresh: true);
//     BmobBatch batch = BmobBatch();
//     User user = User();
//     user.setObjectId(
//         TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//             ? ''
//             : LoginManager.getInstance().getUserBean().uid);
//     BmobAcl bmobAcl = BmobAcl();
//     bmobAcl.addRoleReadAccess(user.getObjectId(), true);
//     List list = await batch.updateBatch(listParam);
//     if (callback != null) {
//       callback(list);
//     }
//     currentObjectId = null;
//     return list;
//   }
//
//   batchdelete_MissionModel(
//       {currentObjectId, folder_id, Function callback}) async {
//     List<MissionModel> listParam =
//     await queryWhereEqual_missionDataByFolderId(folder_id: folder_id);
//     BmobBatch batch = BmobBatch();
//
//     List list = await batch.deleteBatch(listParam);
//     await queryWhereEqual_missionData(
//       shouldRefresh: true,
//     ); //更新 missionModels
//     if (callback != null) {
//       callback(list);
//     }
//     currentObjectId = null;
//     return list;
//   }
//
//   ///删除一条数据
//   delete_MissionModel(
//       {currentObjectId,
//         title,
//         description,
//         folder_id,
//         device_id,
//         order_index,
//         dateStatus,
//         tagName,
//         tagId,
//         priorityStatus,
//         total_tomotoes,
//         no_tomotoes_finished,
//         tomato_duration,
//         Function callback}) async {
//     // if (currentObjectId != null) {
//     MissionModel missionModel = MissionModel();
//     if (!TextUtil.isEmpty(currentObjectId)) {
//       missionModel.objectId = currentObjectId;
//     }
//     if (!TextUtil.isEmpty(folder_id)) {
//       missionModel.folder_id = folder_id;
//     }
//
//     if (!TextUtil.isEmpty(title)) {
//       missionModel.title = title;
//     }
//     if (!TextUtil.isEmpty(device_id)) {
//       missionModel.device_id = device_id;
//     }
//     // if (!TextUtil.isEmpty(tagId)) {
//     //   missionModel.tagId = tagId;
//     // }
//     missionModel.uid =
//     TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
//         ? ''
//         : LoginManager.getInstance().getUserBean().uid;
//     BmobHandled bmobHandled = await missionModel.delete();
//     await queryWhereEqual_missionData(
//       shouldRefresh: true,
//     ); //更新 missionModels
//     if (callback != null) {
//       callback(bmobHandled);
//     }
//     currentObjectId = null;
//     print("删除一条数据成功：${bmobHandled.msg}");
//     return bmobHandled;
//     // } else {
//     //   print("请先新增一条数据");
//     //   // showError(context, "请先新增一条数据");
//     // }
//   }
//
//   ///删除一条数据
//   delete_FolderModel({currentObjectId, Function callback}) async {
//     if (currentObjectId != null) {
//       FolderModel folderModel = FolderModel();
//       folderModel.objectId = currentObjectId;
//       BmobHandled bmobHandled = await folderModel.delete();
//       await queryWhereEqual_folderModel(shouldRefresh: true);
//       if (callback != null) {
//         callback(bmobHandled);
//       }
//       currentObjectId = null;
//       print("删除一条数据成功：${bmobHandled.msg}");
//       return bmobHandled;
//     } else {
//       print("请先新增一条数据");
//       // showError(context, "请先新增一条数据");
//     }
//   }
//
//   ///查询一条数据
//   querySingle(BuildContext context, {currentObjectId}) {
//     if (currentObjectId != null) {
//       BmobQuery<Blog> bmobQuery = BmobQuery();
//       bmobQuery.setInclude("author");
//       bmobQuery.queryObject(currentObjectId).then((data) {
//         Blog blog = Blog.fromJson(data);
//         print(
//             "查询一条数据成功：${blog.title} - ${blog.content} - ${blog.author.username}");
//       }).catchError((e) {
//         print("查询一条数据成功：${BmobError.convert(e).error}");
//         // showError(context, BmobError.convert(e).error);
//       });
//     } else {
//       // print("查询一条数据成功：${blog.title} - ${blog.content} - ${blog.author.username}");
//       // showError(context, "请先新增一条数据");
//     }
//   }
//
//   ///修改一条数据
//   updateSingle(BuildContext context, {currentObjectId}) {
//     if (currentObjectId != null) {
//       Blog blog = Blog();
//       blog.objectId = currentObjectId;
//       blog.title = "修改一条数据";
//       blog.content = "修改一条数据";
//       blog.update().then((BmobUpdated bmobUpdated) {
//         // showSuccess(context, "修改一条数据成功：${bmobUpdated.updatedAt}");
//         print("修改一条数据成功：${bmobUpdated.updatedAt}");
//       }).catchError((e) {
//         print(BmobError.convert(e).error);
//         // showError(context, BmobError.convert(e).error);
//       });
//     } else {
//       print("请先新增一条数据");
//       // showError(context, "请先新增一条数据");
//     }
//   }
//
//   ///删除一条数据
//   deleteSingle(BuildContext context, {currentObjectId}) {
//     if (currentObjectId != null) {
//       Blog blog = Blog();
//       blog.objectId = currentObjectId;
//       blog.delete().then((BmobHandled bmobHandled) {
//         currentObjectId = null;
//         print("删除一条数据成功：${bmobHandled.msg}");
//         // showSuccess(context, "删除一条数据成功：${bmobHandled.msg}");
//       }).catchError((e) {
//         print(BmobError.convert(e).error);
//         // showError(context, BmobError.convert(e).error);
//       });
//     } else {
//       print("请先新增一条数据");
//       // showError(context, "请先新增一条数据");
//     }
//   }
//
//   ///保存一条数据
//   saveSingle(BuildContext context) {
//     BmobUser bmobUser = BmobUser();
//     bmobUser.objectId = "7c7fd3afe1";
//     Blog blog = Blog();
//     blog.title = "博客标题";
//     blog.content = "博客内容";
//     blog.author = bmobUser;
//     blog.like = 77;
//     blog.save().then((BmobSaved bmobSaved) {
//       String message =
//           "创建一条数据成功：${bmobSaved.objectId} - ${bmobSaved.createdAt}";
//       // currentObjectId = bmobSaved.objectId;
//       print(message);
//       // showSuccess(context, message);
//     }).catchError((e) {
//       print(BmobError.convert(e).error);
//       // showError(context, BmobError.convert(e).error);
//     });
//   }
//
//   ///等于条件查询
//   void queryWhereEqual(BuildContext context) {
//     BmobQuery<Blog> query = BmobQuery();
//     // query.addWhereEqualTo("title", "博客标题");
//     query.queryObjects().then((data) {
//       print(data.toString());
//       List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
//       for (Blog blog in blogs) {
//         if (blog != null) {
//           print(blog.objectId);
//           print(blog.title);
//           print(blog.content);
//         }
//       }
//     }).catchError((e) {
//       print(BmobError.convert(e).error);
//     });
//   }
// }
