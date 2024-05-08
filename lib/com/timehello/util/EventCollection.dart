import 'dart:async';

import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/util/BeanParser.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../config/Params.dart';
import '../models/EventCollectionModel.dart';

class EventCollection {
  static EventCollection? eventCollection;
  static final int _THRESHOLD = 5;

  //发送时间间隔阈值，超过10分钟发送
  static int _THRESHOLD_TIME = 1 * 10 * 1000;

  List<EventCollectionModel>? eventInfos = [];
  List<EventCollectionModel>? eventBuffer = [];
  static String EVENT_INFO = "eventInfos";
  static String SEND_TIME = "send_event_time";
  static int UPLOAD_DATA = 1001;
  static int _countdownTime = 0;
  bool isUploading = false;
  int uploadSize = 0;
  Timer? _timer;

  EventCollection();

  static void init() {
    if (eventCollection == null) {
      eventCollection = new EventCollection();
    }
    String str = "";
    str = SharePreferenceUtil.getSyncInstance().getString(key: EVENT_INFO);
    if (str == null || str.isEmpty == true) {
      print("no event");
      return;
    }
    try {
      List<EventCollectionModel> list =
          BeanParser.parseEventCollectionModel(Utility.jsonToList(str));
      eventCollection?.eventInfos?.addAll(list);
    } catch (e) {
      eventCollection?.eventInfos?.clear();
      eventCollection?.eventBuffer?.clear();
      SharePreferenceUtil.getSyncInstance()
          .setString(key: EVENT_INFO, content: "");
    }

    EventCollection.uploadData();
  }

  static void onResume() {
    EventCollection?.uploadData();
  }

  static void onStop() {
    if (eventCollection == null) {
      init();
    }
    if (eventCollection?.eventInfos == null) {
      eventCollection?.eventInfos = [];
    }
    if (eventCollection?.eventBuffer == null) {
      eventCollection?.eventBuffer = [];
    }
    if (eventCollection?.eventInfos?.length == 0) {
      String str = "";
      str = SharePreferenceUtil.getSyncInstance().getString(key: EVENT_INFO);
      if (str == null || str.isEmpty == true) {
        print("no event");
        return;
      }
      try {
        List<EventCollectionModel> list =
            BeanParser.parseEventCollectionModel(Utility.jsonToList(str));
        eventCollection?.eventInfos?.addAll(list);
      } catch (e) {
        eventCollection?.eventInfos?.clear();
        eventCollection?.eventBuffer?.clear();
        SharePreferenceUtil.getSyncInstance()
            .setString(key: EVENT_INFO, content: "");
      }

      print("on stop event.size: ${eventCollection?.eventInfos?.length}");
      int time = 0;
      try {
        time = int.parse(
            SharePreferenceUtil.getSyncInstance().getString(key: SEND_TIME) ??
                "0");
      } catch(e) {

      }
      if (Utility.getTimeStampToday() - time > _THRESHOLD_TIME) {
        uploadData();
      }
    }
  }

  /**
   * json方式上报
   */
  static void onCollectionJSON(Map map) {
    try {
      onCollection(sceneType: map['sceneType'],
          eventType: map['eventType'],
          eventChannel: map['eventChannel'],
          resultType: map['resultType'],
          message: map['message'],
          testType: map['testType'],
          testChannel: map['testChannel'],
          value1: map['value1'] ?? -10000);
    } catch(e) {
      print(e);
    }
  }

  static void onCollection(
      {required String sceneType,
      required String eventType,
      String? eventChannel,
      String? resultType,
      String? message,
      String? testType,
        double value1 = 0,
      String? testChannel}) {
    if (eventType == null) {
      return;
    }
    if (eventCollection == null) {
      init();
    }
    EventCollectionModel eventInfo = new EventCollectionModel();
    eventInfo.eventType = eventType;
    eventInfo.sceneType = sceneType;
    eventInfo.testType = testType;
    eventInfo.resultType = resultType;
    eventInfo.message = message;
    eventInfo.value1 = value1;
    eventInfo.testType = testType;
    eventInfo.create_time = Utility.getTimeStampToday();
    eventInfo.create_time_utc = Utility.getDateTimeNowUtc();
    if (Params.isDebug == true) {
      print('埋点:${eventInfo.toJson().toString()}');
    }
    if (eventCollection?.eventInfos == null) {
      eventCollection?.eventInfos = [];
    }
    if (eventCollection?.eventBuffer == null) {
      eventCollection?.eventBuffer = [];
    }
    if (eventCollection?.eventInfos?.length == 0) {
      String str = "";
      // try {
      //   str = SharePreferenceUtil.getSyncInstance().getString(key: EVENT_INFO);
      //   List<EventCollectionModel> list =
      //   BeanParser.parseEventCollectionModel(Utility.jsonToList(str));
      //   eventCollection?.eventInfos?.addAll(list);
      // } catch (e) {}
      // if (str == null || str.isEmpty == true) {
        print("str is empty");
        eventCollection?.eventInfos?.add(eventInfo);
        try {
          SharePreferenceUtil.getSyncInstance().setString(
              key: EVENT_INFO,
              content:
                  Utility.listToJsonString(eventCollection?.eventInfos ?? []));
        } catch (e) {
          eventCollection?.eventInfos?.clear();
          SharePreferenceUtil.getSyncInstance()
              .setString(key: EVENT_INFO, content: "");
          return;
        }
      // }
    } else {
      eventCollection?.eventInfos?.add(eventInfo);
    }
    if ((eventCollection?.eventInfos?.length ?? 0) -
            eventCollection!.uploadSize >=
        _THRESHOLD) {
      uploadData();
    } else {
      try {
        SharePreferenceUtil.getSyncInstance().setString(
            key: EVENT_INFO,
            content:
                Utility.listToJsonString(eventCollection?.eventInfos ?? []));
        if ((eventCollection?.eventInfos?.length ?? 0) > 0) {
          eventCollection?.startCountdownTimer();
        }
      } catch (e) {
        eventCollection?.eventInfos?.clear();
        eventCollection?.eventBuffer?.clear();
        SharePreferenceUtil.getSyncInstance()
            .setString(key: EVENT_INFO, content: "");
      }
    }
  }

  static void uploadData() async {
    // if(Utility.isProductEnv() == false) {
    //   return;
    // }
    eventCollection?.stopTimer();
    if (eventCollection?.isUploading == true) {
      return;
    }
    print("start uploadData");
    eventCollection?.isUploading = true;
    try {
      List<EventCollectionModel> monitorList = getMonitorInfo();
      print(Utility.listToJsonString(monitorList));

      int size = eventCollection?.eventInfos?.length ?? 0;
      // int diff = size - (eventCollection?.uploadSize ?? 0);
      if (size > 0) {
        print("upload success ${monitorList.length}");
        eventCollection?.eventBuffer?.clear();
        for (int i = (eventCollection?.uploadSize ?? 0); i < size; i++) {
          EventCollectionModel? item =
              eventCollection?.eventInfos?.elementAt(i);
          eventCollection?.eventBuffer?.add(item!);
        }
        SharePreferenceUtil.getSyncInstance().setString(
            key: EVENT_INFO,
            content:
                Utility.listToJsonString(eventCollection?.eventBuffer ?? []));
        await MongoApisManager.getInstance()
            .batchInsert_EventCollection(listParam: eventCollection?.eventInfos);
        eventCollection?.eventInfos?.clear();
      } else {
        SharePreferenceUtil.getSyncInstance()
            .setString(key: EVENT_INFO, content: "");
      }
    } catch (e) {
      print(e.toString());
    } finally {}
    eventCollection?.uploadSize = 0;
    eventCollection?.isUploading = false;
  }

  static List<EventCollectionModel> getMonitorInfo() {
    List<EventCollectionModel> datas = [];
    EventCollectionModel? ei;
    eventCollection?.uploadSize = eventCollection?.eventInfos?.length ?? 0;
    for (int i = 0; i < (eventCollection?.uploadSize ?? 0); i++) {
      ei = eventCollection?.eventInfos?.elementAt(i);
      if (ei == null) {
        continue;
      }
      ei = eventCollection?.eventInfos?.elementAt(i);
      Utility.initEventInfoWithEnvironment(ei ?? EventCollectionModel());
      ei?.update_time = Utility.getTimeStampToday();
      if (ei != null) {
        datas.add(ei);
      }
    }
    return datas;
  }

  //失败就换成信息
  void uploadFailSaveData() {
    if ((eventCollection?.eventInfos?.length ?? 0) < 50) {
      // 如果事件在本地累计数量达到200条了还没上传成功，就舍弃未上传成功的事件，以防app卡顿。后期如果加了异步上传埋点信息可以去掉该逻辑
      try {
        SharePreferenceUtil.getSyncInstance().setString(
            key: EVENT_INFO,
            content:
                Utility.listToJsonString(eventCollection?.eventInfos ?? []));
      } catch (e) {}
      eventCollection?.eventBuffer?.clear();
    } else {
      eventCollection?.eventBuffer?.clear();
      SharePreferenceUtil.getSyncInstance()
          .setString(key: EVENT_INFO, content: "");
    }
    eventCollection?.uploadSize = 0;
  }

  void startCountdownTimer() {
    stopTimer();
    const oneSec = const Duration(seconds: 1);
    _countdownTime = _THRESHOLD_TIME;
    var callback = (timer) {
      if (_timer != null) {
        if (_countdownTime < 2) {
          stopTimer();
          uploadData();
        } else {
          _countdownTime = _countdownTime - 1000;
        }
        // print("countdownTime ${_countdownTime}");
      }
    };

    _timer = Timer.periodic(oneSec, callback);
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
