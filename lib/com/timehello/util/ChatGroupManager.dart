import 'package:time_hello/com/timehello/util/LoginManager.dart';

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

  bool isGroupManager({required Map member}) {
    if (member['uid'] == LoginManager.getInstance().userBean.uid) {
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
