import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/action_pane_motions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/actions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/slidable.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../models/StartTimeMissionModel.dart';
import '../../../models/MissionModel.dart';
import '../../../util/DeviceInfoManagement.dart';
import '../../../util/TextUtil.dart';
import '../models/Countup.dart';
import 'CountUpTextWidget.dart';

class CountupItem extends StatefulWidget {
  final StartTimeMissionModel missionModel;
  int cpt = 0;
  Function onTapFinishListener;
  Function onTapUnFinishListener;
  Function onTapEditListener;
  Function onTapDeleteListener;
  Function onTapListener;
  CountupItem({required this.missionModel, required this.cpt, required this.onTapListener, required this.onTapFinishListener, required this.onTapUnFinishListener, required this.onTapEditListener, required this.onTapDeleteListener});

  @override
  _CountupItemState createState() => _CountupItemState();
}

class _CountupItemState extends State<CountupItem> {
  // Timer? _timer;
  Duration? _elapsedTime;
  bool isHover = false;
  ImageProvider? imageProvider;

  @override
  void initState() {
    super.initState();
    _elapsedTime = DateTime.now().difference(Utility.getDateTimeFromTimeStamp(widget.missionModel.start_time ?? 0));
    // _startTimer();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

  // void _startTimer() {
  //   // _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       _elapsedTime = DateTime.now().difference(widget.countup.startTime);
  //     });
  //   // });
  // }


  @override
  void didUpdateWidget(CountupItem oldWidget) {
    if(this.widget.cpt != oldWidget.cpt) {
      _elapsedTime = DateTime.now().difference(Utility.getDateTimeFromTimeStamp(widget.missionModel.start_time ?? 0));
    }
  }

  String _formatElapsedTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitDays = twoDigits(duration.inDays);
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return getI18NKey().count_up(twoDigitDays, twoDigitHours, twoDigitMinutes, twoDigitSeconds);
    // return '$twoDigitDays天$twoDigitHours时$twoDigitMinutes分$twoDigitSeconds秒';
  }

  List<Widget> getUnfinishIconSlideActions(StartTimeMissionModel _missionModel) {
    return <Widget>[
      SlidableAction(
        label: getI18NKey().edit,
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        icon: Icons.edit,
        onPressed: (e) {
          if (this.widget.onTapEditListener != null)
            this.widget.onTapEditListener!(_missionModel);
        },
      ),
      SlidableAction(
        label: getI18NKey().delete,
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        icon: Icons.delete,
        onPressed: (e) {
          if (this.widget.onTapDeleteListener != null)
            this.widget.onTapDeleteListener!(_missionModel);
        },
      ),
    ];
  }

  List<Widget> getFinishIconSlideActions(StartTimeMissionModel _missionModel) {
    return <Widget>[
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapDeleteListener != null)
            this.widget.onTapDeleteListener!(_missionModel);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: getI18NKey().delete,
      ),
    ];
  }

  List<PopupMenuEntry<String>> getUnfinishedPopupList(
      StartTimeMissionModel _missionModel) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'edit',
        onTap: () {
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapEditListener!(_missionModel);
          });
        },
        child: Text(getI18NKey().edit,
            style: TextStyle(color: Colors.green, fontSize: 15)),
      ),
      PopupMenuItem<String>(
        //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
        value: 'delete',
        onTap: () {
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapDeleteListener!(_missionModel);
          });
        },
        child: Text(
          getI18NKey().delete,
          style: TextStyle(color: ColorsConfig.red, fontSize: 15),
        ),
      ),
    ];
  }

  List<PopupMenuEntry<String>> getFinishedPopupList(
      StartTimeMissionModel _missionModel) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
        value: 'delete',
        onTap: () {
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapDeleteListener!(_missionModel);
          });
        },
        child: Text(
          getI18NKey().delete,
          style: TextStyle(color: ColorsConfig.red, fontSize: 15),
        ),
      ),
    ];
  }

  double ratio = Utility.getRatioForSlider(
    numItem: 5,
  );
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = Utility.getDateTimeFromTimeStamp(widget.missionModel.start_time ?? 0);
    ListTile child = ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.missionModel.title ?? ""),
          CountUpTextWidget(start_time: this.widget.missionModel.start_time ?? 0, fontSize: 14, color: 0xff404040, onTapFinishListener: () {
            if(mounted) {
              setState(() {

              });
            }
          },),
          // if ((_elapsedTime?.inMilliseconds ?? 0) > 0 )
          //   Text(_formatElapsedTime(_elapsedTime!)),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(DateFormat('yyyy.MM.dd HH:mm EEEE').format(dateTime) + " " + Utility.getLunarCalendar(year: dateTime.year, month: dateTime.month, day: dateTime.day)),
          Text((_elapsedTime?.inMilliseconds ?? 0) > 0 ?getI18NKey().counting : getI18NKey().not_started),
        ],
      ),
    );

    return Slidable(
      key: ValueKey(this.widget.missionModel),
      enabled: DeviceInfoManagement.isMoible() == true ||
          DeviceInfoManagement.isWebMobileBySize(),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: ratio,
        children: this.widget.missionModel.isFinished == false
            ? getUnfinishIconSlideActions(this.widget.missionModel)
            : getFinishIconSlideActions(this.widget.missionModel),
      ),
      child: InkWell(
        onTap: () {
          if (this.widget.onTapListener != null) {
            this.widget.onTapListener!(this.widget.missionModel);
          }
        },
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              this.isHover = true;
            });
          },
          onHover: (_) {},
          onExit: (_) {
            setState(() {
              this.isHover = false;
            });
          },
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.only(
              bottom: 2,
              left: CONSTANTS.missionPageMargin,
              right: CONSTANTS.missionPageMargin,
            ),
            decoration: BoxDecoration(
              image: imageProvider == null
                  ? null
                  : DecorationImage(
                image: imageProvider!,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn),
              ),
              color: Colors.white,
              border: Border.all(
                width: 1.0,
                color: ThemeManager.getInstance().getBackgroundColor(
                  defaultColor: Color(0xfff0f0f0),
                ),
              ),
              borderRadius: BorderRadius.all(Radius.circular(0.0)),
            ),
            child: Stack(
              children: [
                TextUtil.isEmpty(this.widget.missionModel.background_url)
                    ? SizedBox.shrink()
                    : CachedNetworkImage(
                  imageUrl: Utility.filterHttpUrl(
                    this.widget.missionModel.background_url ?? '',
                    prefix: "oss",
                  ),
                  imageBuilder: (context, imageProviderTmp) {
                    Future.delayed(Duration(seconds: 0), () {
                      imageProvider = imageProviderTmp;
                    });
                    return Container();
                  },
                ),
                Container(
                  color: ThemeManager.getInstance().getCardBackgroundColor(
                    defaultColor: Color(0xb0ffffff),
                    alpha: TextUtil.isEmpty(this.widget.missionModel.background_url) ? 255 : 150,
                  ),
                  padding: EdgeInsets.only(top: 6, bottom: 6),
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      child,
                      Align(
                        alignment: Alignment.topRight,
                        child: (this.isHover == true)
                            ? PopupMenuButton<String>(
                          tooltip: '',
                          padding: EdgeInsets.only(left: 18, bottom: 20),
                          iconSize: 14,
                          icon: Icon(
                            Icons.more_vert,
                            color: ThemeManager.getInstance().getIconColor(),
                          ),
                          onCanceled: () {},
                          itemBuilder: (context) {
                            if (this.widget.missionModel.isFinished == false) {
                              return getUnfinishedPopupList(this.widget.missionModel);
                            } else {
                              return getFinishedPopupList(this.widget.missionModel);
                            }
                          },
                        )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );  }
} 