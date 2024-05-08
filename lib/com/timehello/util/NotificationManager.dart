import 'package:time_hello/com/timehello/util/CounterManagement.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../beans/BaseBean.dart';
import '../common/httpclient/HttpManager.dart';
import '../config/CONSTANTS.dart';
import '../config/Params.dart';
import '../libs/methodChannel/CounterMethodChannelManager.dart';
import '../models/CalendarModel.dart';
import '../models/PushDataModel.dart';
import '../models/PushDataModelList.dart';

class NotificationManager {
  static NotificationManager? mNotificationManager;
  String? deviceId;
  String aliyunMessageId = '';

  static NotificationManager? getInstance() {
    if (mNotificationManager == null) {
      mNotificationManager = new NotificationManager();
      mNotificationManager?.init();
    }
    return mNotificationManager;
  }

  init() async {
    deviceId = await CounterMethodChannelManager.getInstance().aliyunDeviceId();
    //绑定当前用户alias
    // HttpManager.getInstance().doPostRequest(
    //   Apis.bindAliyunAlias,
    //   context: Utility.getGlobalContext(),
    //   params: {"deviceId": deviceId, "aliasName": deviceId},
    //   shouldShowErrorToast: false,
    //   callback: (BaseBean response, String scene, bool isFromCache) {
    //     if (response.success == true) {
    //       String requestId = response.data['RequestId'];
    //     }
    //   },
    // );
  }
  //每天早上提示任务时间
  push8MorningNotification(CalendarModel calendarModel) {
    int hour = 8;
    int mins = 0;
    int numMissionUnfinshedDelayed = 0;
    int dateTimeDelayed = 0;

    for (int i = 0; i < calendarModel.dayModelList.length; i++) {
      DayModel dayModel = calendarModel.dayModelList[i];
      DateTime dateTime = DateTime(dayModel.dateTime?.year ?? 0, dayModel.dateTime?.month ?? 0, dayModel.dateTime?.day ?? 0, hour, mins);
      int numMissionUnfinshed = Utility.getMissionModelUnfinished(dayModel.missionModelList).length;
      int previewTime = Utility.getPreviewTimeFromFolderModel(dayModel.missionModelList);
      // String duration = Utility.getHour(previewTime) + ":" + Utility.getMins(previewTime);
      // Utility.getDateTimeFromTimeStamp(timeStamp);
      String delayText = numMissionUnfinshedDelayed == 0 ? getI18NKey().no_delayed_task : getI18NKey().notification_num_mission_to_finish_delay(
          numMissionUnfinshedDelayed, Utility.getHourFromTimeStamp(dateTimeDelayed),
          Utility.getMinsFromTimeStamp(dateTimeDelayed));
        CONSTANTS.pushDataModelList.list.add(PushDataModel(
            title: getI18NKey().notification_title + " " + dateTime.toString(),
            content: getI18NKey().notification_num_mission_to_finish(
                numMissionUnfinshed, Utility.getHourFromTimeStamp(previewTime),
                Utility.getMinsFromTimeStamp(previewTime)) + "\n" + delayText,
            whenMilliseconds: dateTime.millisecondsSinceEpoch,
            id: "2000$i",
            summaryText: ''));
      dateTimeDelayed += Utility.getPreviewTimeFromFolderModelWithoutRepeative(dayModel.missionModelList);
      numMissionUnfinshedDelayed += Utility.getMissionModelUnfinishedDelay(dayModel.missionModelList).length;

    }
    // CONSTANTS.pushDataModelList.list.forEach((element) {
    //   DateTime dateTime = Utility.getDateTimeFromTimeStamp(element.whenMilliseconds);
    //   print( "${dateTime.year}:${dateTime.month}:${dateTime.day} ${element.content}");
    // });
    // print(222);
    // notification_num_mission_to_finish
  }


  /**
   * 晚上定时8点推送 设置
   */
  push20OclockNotifiocation() {
    CONSTANTS.getPushDataModelList().list.forEach((element) {
      CONSTANTS.pushDataModelList.list.add(element);
    });
    // CounterMethodChannelManager.getInstance().pushListNotificationWithWhen(
    //     pushDataModelList: CONSTANTS.getPushDataModelList());
  }

  cancelNotificationById(String id) {
    CounterMethodChannelManager.getInstance()
        .cancelPushNotificationWidthId(id: id);
  }

  cancelAllPendingNotification() {
    CounterMethodChannelManager.getInstance()
        .cancelAllPendingNotification();
  }

  pushNotificationWithdelay(
      {required String title,
      required String content,
      required int delay,
      required String extendsParams,
      required String id}) {
    CounterMethodChannelManager.getInstance().requestPushNotificationWithDelay(
        title: title,
        content: content,
        delay: delay,
        extendsParams: extendsParams,
        id: Params.PUSH_COUNTER_NOTIFICATION_ID);
  }

  pushNotificationWithWhen(
      {required String title,
      required String content,
      required int whenMilliseconds,
      required String id}) {
    CounterMethodChannelManager.getInstance().pushNotificationWithWhen(
        title: title,
        content: content,
        id: id,
        whenMilliseconds: whenMilliseconds);
  }

  pushAliyunNotificationWithAlias(
      {required String title,
      required String duration,
      required int delay,
      required String extendsParams}) {
    String statusText =
        Utility.getStatusText(CounterManagement.getInstance().counterStatus);
    String nextStatusText = Utility.getNextStatusText(
        CounterManagement.getInstance().counterStatus);
    String body = getI18NKey()
        .push_counter_status_notification(statusText, nextStatusText, duration);
    this.pushNotificationWithdelay(
        title: title,
        content: body,
        extendsParams: extendsParams,
        id: Params.PUSH_COUNTER_NOTIFICATION_ID,
        delay: delay);
    //绑定当前用户alias
    HttpManager.getInstance().doPostRequest(
      Apis.pushAliyunNotificationWithAlias,
      context: Utility.getGlobalContext(),
      params: {
        "title": title,
        "content": duration,
        "targetValue": deviceId,
        "extendsParams": extendsParams,
        "delay": delay
      },
      shouldShowErrorToast: false,
      callback: (BaseBean response, String scene, bool isFromCache) {
        if (response.success == true) {
          String requestId = response.data['RequestId'];
          aliyunMessageId = response.data['MessageId'];
        }
      },
    );
  }

  delAliyunSchedule() async {
    //绑定当前用户alias
    CounterMethodChannelManager.getInstance()
        .cancelPushNotificationWidthId(id: Params.PUSH_COUNTER_NOTIFICATION_ID);
    if (aliyunMessageId.isEmpty) return;
    HttpManager.getInstance().doPostRequest(
      Apis.delAliyunSchedule,
      context: Utility.getGlobalContext(),
      params: {"MessageId": aliyunMessageId},
      shouldShowErrorToast: false,
      callback: (BaseBean response, String scene, bool isFromCache) {
        if (response.success == true) {
          // String requestId = response.data['RequestId'];
        }
      },
    );
  }
}
