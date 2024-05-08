// import 'dart:html';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../config/Params.dart';

class AutoUpdateManager {
  static AutoUpdateManager? mAutoUpdateManager;

  // // String serviceVersionCode = '';
  // String appId = '';
  // // ProgressDialog? pr;
  // String apkName = 'app-release.apk';
  String curVersion = '';
  // String appPath = '';
  // ReceivePort _port = ReceivePort();
  // late bool _permissionReady;

  static AutoUpdateManager getInstance() {
    if (mAutoUpdateManager == null) {
      mAutoUpdateManager = new AutoUpdateManager();
    }
    return mAutoUpdateManager!;
  }

  init() async {
    // _permissionReady = false;
    getCurrentVersion();
    // Plugin must be initialized before using
    // try {
    //   await FlutterDownloader.initialize(
    //       debug: true,
    //       // optional: set to false to disable printing logs to console (default: true)
    //       ignoreSsl:
    //           true // option: set to false to disable working with http links (default: false)
    //       );
    // } catch (e) {
    //   print(e);
    // }
    if(Utility.isMobile() == true) {
      await _checkPermission();
    }
    // bool isSuccess = IsolateNameServer.registerPortWithName(
    //     _port.sendPort, 'downloader_send_port');
    // FlutterDownloader.registerCallback(_downLoadCallback as DownloadCallback);
    // _port.listen(_updateDownLoadInfo);
  }

  /// 检查当前版本是否为最新，若不是，则更新
  void getCurrentVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      this.curVersion = packageInfo.version;
      Params.curVersion = this.curVersion;
    });
  }
  //
  // /// 执行版本更新的网络请求
  // // getNewVersionAPP(BuildContext context) async {
  // //   HttpUtils.send(
  // //     context,
  // //     'http://update.rwworks.com:8088/appManager/monitor/app/version/check/flutterTempldate',
  // //   ).then((res) {
  // //     serviceVersionCode = res.data["versionNo"];
  // //     appId = res.data['id'];
  // //     checkVersionCode(context);
  // //   });
  // // }
  //
  // /// 检查当前版本是否为最新，若不是，则更新
  // void checkVersionCode(BuildContext context, String latestVersionCode) {
  //   if (SharePreferenceUtil.getSyncInstance()
  //           .getJumpToVersion(latestVersionCode) ==
  //       false) {
  //     PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
  //       var currentVersionCode = packageInfo.version;
  //       if (Utility.compareVersion(latestVersionCode, currentVersionCode) ==
  //           1) {
  //         _showNewVersionAppDialog(context);
  //       }
  //     });
  //   }
  // }
  //
  // /// 版本更新提示对话框
  // Future<void> _showNewVersionAppDialog(BuildContext context) async {
  //   return showDialog<void>(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: new Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[new Text(getI18NKey().find_new_version)],
  //           ),
  //           content: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: getContentWidget(),
  //           ),
  //           actionsAlignment: MainAxisAlignment.spaceBetween,
  //           // contentTextStyle:TextStyle()
  //           actions: <Widget>[
  //             new TextButton(
  //               child: new Text(
  //                 getI18NKey().jump_to_this_version,
  //                 style: TextStyle(fontSize: 12, color: Color(0xff999999)),
  //               ),
  //               onPressed: () {
  //                 SharePreferenceUtil.getSyncInstance()
  //                     .setJumpToVersion(Params.latestVersion);
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 new TextButton(
  //                   child: new Text(getI18NKey().next_time),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //                 new TextButton(
  //                   child: new Text(
  //                     getI18NKey().update_now,
  //                     style: TextStyle(color: Colors.red),
  //                   ),
  //                   onPressed: () {
  //                     mAutoUpdateManager!.init();
  //                     if (DeviceInfoManagement.isAndroid() ==
  //                         true) {
  //                       _doUpdate(context);
  //                     } else {
  //                       Utility.openUrl(
  //                           url: Params.updateInfoDeliveryInfoBean
  //                               ?.resourceRedirectUrl);
  //                     }
  //                   },
  //                 )
  //               ],
  //             )
  //           ],
  //         );
  //       });
  // }
  //
  // List<Widget> getContentWidget() {
  //   List<Widget> listWidgets = [];
  //   String? content = Params.updateInfoDeliveryInfoBean?.resourceContent;
  //   List<String>? listContent = content?.split(' ');
  //   listContent?.forEach((element) {
  //     listWidgets.add(Text(element));
  //   });
  //   return listWidgets;
  // }
  //
  Future<bool> _checkPermission() async {
    if (Utility.isIOS()) return true;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (DeviceInfoManagement.isAndroid() == true &&
        androidInfo.version.sdkInt! <= 28) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
  //
  // /// 执行更新操作
  // _doUpdate(BuildContext context) async {
  //   Navigator.pop(context);
  //   _executeDownload(context);
  // }
  //
  // /// 下载最新apk包
  // Future<void> _executeDownload(BuildContext context) async {
  //   // pr = new ProgressDialog(
  //   //   context,
  //   //   type: ProgressDialogType.Download,
  //   //   isDismissible: true,
  //   //   showLogs: true,
  //   // );
  //   // pr?.style(message: getI18NKey().ready_to_download + '...');
  //   // if (!pr!.isShowing()) {
  //   //   pr?.show();
  //   // }
  //
  //   final path = await _apkLocalPath;
  //   if (File(appPath + "/" + apkName).existsSync() == false) {
  //     // await FlutterDownloader.enqueue(
  //     //     url: Params.updateInfoDeliveryInfoBean?.resourcePictureUrl ?? '',
  //     //     savedDir: path,
  //     //     fileName: apkName,
  //     //     showNotification: true,
  //     //     openFileFromNotification: true);
  //   } else {
  //     _installApk();
  //   }
  // }
  //
  // /// 下载进度回调函数
  // @pragma('vm:entry-point')
  // static void _downLoadCallback(
  //   //   String id, DownloadTaskStatus status, int progress) {
  //   // final SendPort? send =
  //   //     IsolateNameServer.lookupPortByName('downloader_send_port');
  //   // send?.send([id, status, progress]);
  // }
  //
  // /// 更新下载进度框
  // _updateDownLoadInfo(dynamic data) {
  //   // DownloadTaskStatus status = data[1];
  //   // int progress = data[2];
  //   // print('progress:${progress}');
  //   // if (status == DownloadTaskStatus.running) {
  //   //   pr?.update(
  //   //       progress: double.parse(progress.toString()),
  //   //       message: getI18NKey().downloading_please_wait);
  //   // }
  //   // if (status == DownloadTaskStatus.failed) {
  //   //   if (pr!.isShowing()) {
  //   //     pr!.hide();
  //   //   }
  //   // }
  //   //
  //   // if (status == DownloadTaskStatus.complete) {
  //   //   if (pr!.isShowing()) {
  //   //     pr!.hide();
  //   //   }
  //   //   _installApk();
  //   // }
  // }
  //
  // /// 安装apk
  // Future<Null> _installApk() async {
  //   await OpenFile.open(appPath + '/' + apkName);
  // }
  //
  // /// 获取apk存储位置
  // Future<String> get _apkLocalPath async {
  //   final directory = await getExternalStorageDirectory();
  //   String path = directory!.path + Platform.pathSeparator + 'Download';
  //   ;
  //   final savedDir = Directory(path);
  //   bool hasExisted = await savedDir.exists();
  //   if (!hasExisted) {
  //     await savedDir.create();
  //   }
  //   appPath = path;
  //   // this.setState((){
  //   //   appPath = path;
  //   // });
  //   return path;
  // }
}
