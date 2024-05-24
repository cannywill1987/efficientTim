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
    if(folderModel?.uid == LoginManager.getInstance().userBean.uid) {
      return true;
    }
    print(
        "folderId:${folderId} ${folderModel?.isSharing} isOtherUserEditable:${folderModel?.isOtherUserEditable} uid:${folderModel?.otherUids?.contains(uid)}");
    //0 未分享中 仅仅我自己 1 之后分享中 - 1 私有 - 需要搜索 仅仅好友 2 所有人可查看 3 所有人可编辑
    if (!(folderModel?.isSharing == 1 && folderModel?.isOtherUserEditable == true) || folderModel?.isSharing == 3) {
      return false;
    } else {
      return true;
    }
  }

  bool hasPassword({required FolderModel folderModel}) {
    if(folderModel.groupChatPassword != null && folderModel.groupChatPassword!.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool isGroupManager({required UserInfoBean bean}) {
    if (bean.uid == LoginManager.getInstance().userBean.uid) {
      return true;
    }
    return false;
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
