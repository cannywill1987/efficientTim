
// import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static PermissionManager? _instance;

  static PermissionManager getInstance() {
    if(_instance == null) {
      _instance = new PermissionManager();
      _instance?.init();
    }
    return _instance!;
  }

  void init() {
  }

  // Future<bool> hasPermission(Permission permission) async {
  //   final status = await permission.request();
  //   if (status.isGranted) {
  //     return true;
  //   }
  //
  //   if (status.isPermanentlyDenied) {
  //     await openAppSettings();
  //   }
  //
  //   return false;
  // }

  // Future<bool> isNotificationOn() async {
  //   // bool isGranted = await Permission.notification.isGranted;
  //   // bool isDenied = await Permission.notification.isDenied;
  //   // bool isLimited = await Permission.notification.isLimited;
  //   // bool isPermanentlyDenied = await Permission.notification.isPermanentlyDenied;
  //   // bool isRestricted = await Permission.notification.isRestricted;
  //   // return isGranted;
  // }

  requestStoragePermission() async {
    // final status = await Permission.storage.request();
    // print(status);
  }

  Future<bool> isMicrophoneOn() async {
    // bool isGranted = await Permission.microphone.isGranted;
    return true;
  }

  openAppSettings() {
    // openAppSettings();
  }

// Future<void> requestPermission(Permission permission) async {
//   // final status = await permission.request();
// }

}