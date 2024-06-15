import 'package:time_hello/com/timehello/beans/UserBean.dart';
import 'package:time_hello/com/timehello/beans/UserInfoBean.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

class ChatGroupManager {
  static ChatGroupManager? chatGroupManager;

  static getInstance() {
    if (chatGroupManager == null) {
      chatGroupManager = ChatGroupManager();
      chatGroupManager?.init();
    }
    return chatGroupManager;
  }

  void init() {
    print('init');
  }

  // static final ChatGroupManager _instance = ChatGroupManager._internal();
  // factory ChatGroupManager() => _instance;
  // ChatGroupManager._internal();

  static isMyFolder({required FolderModel folderModel}) {
    if (folderModel.uid == LoginManager.getInstance().userBean.uid) {
      return true;
    }
    return false;
  }
  //是否已经在群清单
  static isInTheFolder({required FolderModel folderModel, String uid = ""}) {
    if (TextUtil.isEmpty(uid)) {
      uid = LoginManager.getInstance().userBean.uid ?? "";
    }
    if(folderModel.otherUids != null && folderModel.otherUids!.contains(uid)) {
      return true;
    } else {
      return false;
    }
    // folderModel.otherUids?.forEach((element) {
    //   if (element == uid) {
    //     return true;
    //   }
    // });
    // if (folderModel.uid == uid) {
    //   return true;
    // }
    // if (folderModel.otherUids != null && folderModel.otherUids!.contains(uid)) {
    //   return true;
    // }
    // return false;
  }

  /**
   *
   */
  static isFolderModelEnabledForMissionList(
      {required List<MissionModel> list, String uid = ""}) {
    for (int i = 0; i < list.length; i++) {
      MissionModel missionModel = list[i];
      if (missionModel is MissionModel) {
        if (isFolderModelEnabled(folderId: missionModel.folder_id, uid: uid) ==
            false) {
          return false;
        }
      }
    }
    return true;
  }

  /**
   * folderId是missionModel的id
   * folderModel是否可编辑
   */
  static isFolderModelEnabled({String? folderId, String uid = ""}) {
    if (TextUtil.isEmpty(uid)) {
      uid = LoginManager.getInstance().userBean.uid ?? "";
    }
    FolderModel? folderModel =
    MongoApisManager.getInstance().getFolderModelByFolderId(folderId ?? "");
    // 清单创建本人 默认有权限
    //foldermodel为空则在今日插入
    if(folderModel == null || folderModel?.uid == LoginManager.getInstance().userBean.uid) {
      return true;
    }
    print(
        "folderId:${folderId} ${folderModel?.isSharing} isOtherUserEditable:${folderModel?.isOtherUserEditable} uid:${folderModel?.otherUids?.contains(uid)}");
    //0 未分享中 仅仅我自己 1 之后分享中 - 1 私有 - 需要搜索 仅仅好友 2 所有人可查看 3 所有人可编辑
    if ((folderModel?.isSharing == 1 && folderModel?.isOtherUserEditable == true) || folderModel?.isSharing == 3) {
      return true;
    } else {
      return false;
    }
  }

  // 0-创建者 1-管理员 2-普通用户
  static UserInfoBean getUserInfoBean({required int role}) {
    UserInfoBean userInfoBean = UserInfoBean();
    userInfoBean.username = LoginManager.getInstance().userBean.username;
    userInfoBean.avatar = LoginManager.getInstance().userBean.avatar;
    userInfoBean.uid = LoginManager.getInstance().userBean.uid;
    userInfoBean.role = role;
    userInfoBean.onlineStatus = 1;
    return userInfoBean;
  }

  static bool hasPassword({required FolderModel folderModel}) {
    if(folderModel.groupChatPassword != null && folderModel.groupChatPassword!.isNotEmpty) {
      return true;
    }
    return false;
  }

  static bool isGroupManagerForUserInfoBean({required UserInfoBean userInfoBean}) {
    if (userInfoBean.uid == LoginManager.getInstance().userBean.uid) {
      return true;
    }
    if (userInfoBean.role == 0 || userInfoBean.role == 1) {
      return true;
    }
    return false;
  }

  static bool isMe({required UserInfoBean userInfoBean}) {
    if (userInfoBean.uid == LoginManager.getInstance().userBean.uid) {
      return true;
    }
    return false;

  }

  static bool isGroupManager({required FolderModel folderModel, String? uid}) {
    if(uid == null) {
      uid = LoginManager.getInstance().userBean.uid;
    }
    if (folderModel.uid == uid) {
      return true;
    }
    if (folderModel.otherUserInfoBean != null) {
      UserInfoBean? userInfoBean;
      folderModel.otherUserInfoBean?.forEach((element) {
        if(element?.uid == uid) {
          userInfoBean = element;
        }
      });
      if(userInfoBean != null) {
        return userInfoBean?.role == 0 || userInfoBean?.role == 1;
      }
    }
    return false;
  }

  /**
   * 是否foldermodel只有我
   */
  static bool onlyMeInGroup({required FolderModel folderModel}) {
    if(folderModel.otherUids != null && folderModel.otherUids!.length == 0) {
      return true;
    }
    if(folderModel.otherUids?.length == 1 && (folderModel.otherUids ?? []).contains(LoginManager.getInstance().userBean.uid)) {
      return true;
    }
    return false;
  }

  static bool isCreator({required FolderModel folderModel}) {
    if (folderModel.uid == LoginManager.getInstance().userBean.uid) {
      return true;
    }
    return false;
  }

  static bool isCreatorForUserBean({required FolderModel folderModel,required UserInfoBean userBean}) {
    return folderModel.uid == userBean.uid;
  }

  static setRoleForUserBean({required FolderModel folderModel, required UserInfoBean userBean, required int role}) async {
    // if (folderModel.otherUserInfoBean != null) {
    //   folderModel.otherUserInfoBean?.forEach((element) {
    //     if(element?.uid == userBean.uid) {
    //       element?.role = role;
    //     }
    //   });
    // }
    if (folderModel.otherUserInfo != null) {
      folderModel.otherUserInfo?.forEach((element) {
        if(element['uid'] == userBean.uid) {
          element['role'] = role;
        }
      });
      folderModel.otherUserInfo = folderModel.otherUserInfo;
    }
     await MongoApisManager.getInstance().update_FolderModelWithFM(
        folderModel: folderModel, shouldQueryMissionModel: true);
  }

  static removeUserFromGroup({required FolderModel folderModel, required UserInfoBean userBean}) async {
    if (folderModel.otherUids != null) {
      folderModel.otherUids?.remove(userBean.uid);
      folderModel.otherUserInfo?.removeWhere((element) =>
      element['uid'] == userBean.uid);
      folderModel.otherUserInfo = folderModel.otherUserInfo;
      await MongoApisManager.getInstance().update_FolderModelWithFM(
          shouldCheckPermission: false,
          folderModel: folderModel, shouldQueryMissionModel: true);
    }
  }

  static exitGroup({ FolderModel? folderModel}) {
    if(folderModel != null) {
      if (isCreator(folderModel: folderModel)) {
        folderModel.otherUids = [LoginManager
            .getInstance()
            .userBean
            .uid
        ];
        folderModel.otherUserInfoBean = [getUserInfoBean(role: 1)];
        folderModel.otherUserInfo = [getUserInfoBean(role: 1).toJson()];
        MongoApisManager.getInstance().update_FolderModelWithFM(
            folderModel: folderModel, shouldQueryMissionModel: true);
      } else {
        folderModel.otherUids?.remove(LoginManager
            .getInstance()
            .userBean
            .uid);
        folderModel.otherUserInfo?.removeWhere((element) =>
        element['uid'] == LoginManager
            .getInstance()
            .userBean
            .uid);
        folderModel.otherUserInfo = folderModel.otherUserInfo;
        MongoApisManager.getInstance().update_FolderModelWithFM(
            shouldCheckPermission: false,
            folderModel: folderModel, shouldQueryMissionModel: true);
      }
    }
  }


// void createGroup() {
//   print('createGroup');
// }
//
// void joinGroup() {
//   print('joinGroup');
// }
//
// void leaveGroup() {
//   print('leaveGroup');
// }
//
// void sendMessage() {
//   print('sendMessage');
// }
}
