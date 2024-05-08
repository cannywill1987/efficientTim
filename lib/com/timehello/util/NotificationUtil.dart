// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// /// Screen Util.
// class NotificationUtil {
//   static NotificationUtil _instance;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   static NotificationUtil getInstance([Function onSelectNotification]) {
//     if (_instance == null) {
//       _instance = new NotificationUtil();
//       _instance.init(onSelectNotification);
//     }
//     return _instance;
//   }
//
//   void init(Function onSelectNotification) {
//     flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//     var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOS = new IOSInitializationSettings();
//     final MacOSInitializationSettings initializationSettingsMacOS =
//     MacOSInitializationSettings(
//         requestAlertPermission: false,
//         requestBadgePermission: false,
//         requestSoundPermission: false);
//     var initSetttings = new InitializationSettings(android: android, iOS: iOS,
//         macOS: initializationSettingsMacOS);
//     flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);
//   }
//
//   void hideAllNotification() {
//     flutterLocalNotificationsPlugin?.cancelAll();
//   }
//
//    Future<void> _showNotificationWithChronometer(BuildContext context, int timeDelay) async {
//     final AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       importance: Importance.max,
//       priority: Priority.high,
//       when: DateTime
//           .now()
//           .millisecondsSinceEpoch + timeDelay,
//       usesChronometer: true,
//     );
//     final NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//         0, 'plain title', 'plain body', platformChannelSpecifics,
//         payload: 'item x');
//   }
//
//   Future<void> createNotificationChannelGroup(BuildContext context) async {
//     const String channelGroupId = 'your channel group id';
//     // create the group first
//     const AndroidNotificationChannelGroup androidNotificationChannelGroup =
//     AndroidNotificationChannelGroup(
//         channelGroupId, 'your channel group name',
//         description: 'your channel group description');
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         .createNotificationChannelGroup(androidNotificationChannelGroup);
//
//     // create channels associated with the group
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         .createNotificationChannel(const AndroidNotificationChannel(
//         'grouped channel id 1',
//         'grouped channel name 1',
//         groupId: channelGroupId));
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         .createNotificationChannel(const AndroidNotificationChannel(
//         'grouped channel id 2',
//         'grouped channel name 2',
//         groupId: channelGroupId));
//
//     await showDialog<void>(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           content: Text('Channel group with name '
//               '${androidNotificationChannelGroup.name} created'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ));
//   }
//
//   // Future<void> startForegroundService() async {
//   //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   //   AndroidNotificationDetails(
//   //       'your channel id', 'your channel name', 'your channel description',
//   //       importance: Importance.max,
//   //       priority: Priority.high,
//   //       ticker: 'ticker');
//   //   await flutterLocalNotificationsPlugin
//   //       .resolvePlatformSpecificImplementation<
//   //       AndroidFlutterLocalNotificationsPlugin>()
//   //       .startForegroundService(1, 'plain title', 'plain body',
//   //       notificationDetails: androidPlatformChannelSpecifics,
//   //       payload: 'item x');
//   // }
//   //
//   // Future<void> stopForegroundService() async {
//   //   await flutterLocalNotificationsPlugin
//   //       .resolvePlatformSpecificImplementation<
//   //       AndroidFlutterLocalNotificationsPlugin>()
//   //       ?.stopForegroundService();
//   // }
//
//   // Future<Widget> getActiveNotificationsDialogContent() async {
//   //   final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   //   final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//   //   if (!(androidInfo.version.sdkInt >= 23)) {
//   //     return const Text(
//   //       '"getActiveNotifications" is available only for Android 6.0 or newer',
//   //     );
//   //   }
//   //
//   //   try {
//   //     final List<ActiveNotification>? activeNotifications =
//   //     await flutterLocalNotificationsPlugin
//   //         .resolvePlatformSpecificImplementation<
//   //         AndroidFlutterLocalNotificationsPlugin>()!
//   //         .getActiveNotifications();
//   //
//   //     return Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       mainAxisSize: MainAxisSize.min,
//   //       children: <Widget>[
//   //         const Text(
//   //           'Active Notifications',
//   //           style: TextStyle(fontWeight: FontWeight.bold),
//   //         ),
//   //         const Divider(color: Colors.black),
//   //         if (activeNotifications!.isEmpty)
//   //           const Text('No active notifications'),
//   //         if (activeNotifications.isNotEmpty)
//   //           for (ActiveNotification activeNotification in activeNotifications)
//   //             Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: <Widget>[
//   //                 Text(
//   //                   'id: ${activeNotification.id}\n'
//   //                       'channelId: ${activeNotification.channelId}\n'
//   //                       'title: ${activeNotification.title}\n'
//   //                       'body: ${activeNotification.body}',
//   //                 ),
//   //                 const Divider(color: Colors.black),
//   //               ],
//   //             ),
//   //       ],
//   //     );
//   //   } on PlatformException catch (error) {
//   //     return Text(
//   //       'Error calling "getActiveNotifications"\n'
//   //           'code: ${error.code}\n'
//   //           'message: ${error.message}',
//   //     );
//   //   }
//   // }
//
//   Future<void> getNotificationChannels(BuildContext context) async {
//     final Widget notificationChannelsDialogContent =
//     await getNotificationChannelsDialogContent();
//     await showDialog<void>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         content: notificationChannelsDialogContent,
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   /**
//    * 有个2分钟前的时间显示
//    */
//   Future<void> showNotificationWithCustomTimestamp() async {
//     final AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       importance: Importance.max,
//       priority: Priority.high,
//       when: DateTime.now().millisecondsSinceEpoch - 120 * 1000,
//     );
//     final NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//         0, 'plain title', 'plain body', platformChannelSpecifics,
//         payload: 'item x');
//   }
//
//   Future<void> showNotificationUpdateChannelDescription() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails('your channel id', 'your channel name',
//         importance: Importance.max,
//         priority: Priority.high,
//         channelAction: AndroidNotificationChannelAction.update);
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//         0,
//         'updated notification channel',
//         'check settings to see updated channel description',
//         platformChannelSpecifics,
//         payload: 'item x');
//   }
//
//   Future<void> showIndeterminateProgressNotification() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//         'indeterminate progress channel',
//         'indeterminate progress channel',
//         channelShowBadge: false,
//         importance: Importance.max,
//         priority: Priority.high,
//         onlyAlertOnce: true,
//         showProgress: true,
//         indeterminate: true);
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//         0,
//         'indeterminate progress notification title',
//         'indeterminate progress notification body',
//         platformChannelSpecifics,
//         payload: 'item x');
//   }
//   Future<void> showProgressNotification({String title = 'progress notification title', String content, int progress, int maxProgress = 100, String payload = '', Color color = Colors.red}) async {
//       await Future<void>.delayed(const Duration(seconds: 1), () async {
//         final AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails('progress channel', 'progress channel',
//             channelShowBadge: true,
//             // ledColor: Colors.red,
//             color: color,
//             importance: Importance.max,
//             priority: Priority.high,
//             onlyAlertOnce: true,
//             showProgress: true,
//             maxProgress: maxProgress,
//             progress: progress);
//         final NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//         await flutterLocalNotificationsPlugin.show(
//             0,
//             title,
//             content,
//             platformChannelSpecifics,
//             payload: 'item x');
//       });
//   }
//
//   //下拉可以展示更多
//   Future<void> showInboxNotification() async {
//     final List<String> lines = <String>['line <b style="color:red">1</b>', 'line <i>2</i>'];
//     final InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
//         lines,
//         htmlFormatLines: true,
//         contentTitle: 'overridden <b>inbox</b> context title',
//         htmlFormatContentTitle: true,
//         summaryText: 'summary <i>text</i>',
//         htmlFormatSummaryText: true);
//     final AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails('inbox channel id', 'inboxchannel name',
//         styleInformation: inboxStyleInformation);
//     final NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//         0, 'inbox title', 'inbox body', platformChannelSpecifics);
//   }
//
//
//   Future<Widget> getNotificationChannelsDialogContent() async {
//     try {
//       final List<AndroidNotificationChannel> channels =
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//           .getNotificationChannels();
//
//       return Container(
//         width: double.maxFinite,
//         child: ListView(
//           children: <Widget>[
//             const Text(
//               'Notifications Channels',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const Divider(color: Colors.black),
//             if (channels.isEmpty ?? true)
//               const Text('No notification channels')
//             else
//               for (AndroidNotificationChannel channel in channels)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text('id: ${channel.id}\n'
//                         'name: ${channel.name}\n'
//                         'description: ${channel.description}\n'
//                         'groupId: ${channel.groupId}\n'
//                         'importance: ${channel.importance.value}\n'
//                         'playSound: ${channel.playSound}\n'
//                         'sound: ${channel.sound?.sound}\n'
//                         'enableVibration: ${channel.enableVibration}\n'
//                         'vibrationPattern: ${channel.vibrationPattern}\n'
//                         'showBadge: ${channel.showBadge}\n'
//                         'enableLights: ${channel.enableLights}\n'
//                         'ledColor: ${channel.ledColor}\n'),
//                     const Divider(color: Colors.black),
//                   ],
//                 ),
//           ],
//         ),
//       );
//     } on PlatformException catch (error) {
//       return Text(
//         'Error calling "getNotificationChannels"\n'
//             'code: ${error.code}\n'
//             'message: ${error.message}',
//       );
//     }
//   }
//
//   Future<void> showPeriodicNotificaiton() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails('repeating channel id',
//         'repeating channel name');
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
//         'repeating body', RepeatInterval.everyMinute, platformChannelSpecifics,
//         androidAllowWhileIdle: true);
//   }
//
// }