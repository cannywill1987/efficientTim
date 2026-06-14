import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/action_pane_motions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/actions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/slidable.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/ColorsConfig.dart';
import '../../../models/EndTimeMissionModel.dart';
import '../../../util/DeviceInfoManagement.dart';
import 'CountDownTextWidget.dart';

/**
 * 文件类型：组件
 * 文件作用：倒计时列表中的单个卡片，负责展示标题、目标时间、完成状态和剩余时间。
 * 主要职责：保留原有滑动编辑/删除能力，并提供更接近仪表盘卡片的桌面端视觉。
 */
class CountdownItem extends StatefulWidget {
  final EndTimeMissionModel missionModel;
  final int cpt;
  final Function onTapFinishListener;
  final Function onTapUnFinishListener;
  final Function onTapEditListener;
  final Function onTapDeleteListener;
  final Function onTapListener;
  CountdownItem(
      {required this.missionModel,
      required this.cpt,
      required this.onTapListener,
      required this.onTapFinishListener,
      required this.onTapUnFinishListener,
      required this.onTapEditListener,
      required this.onTapDeleteListener});

  @override
  _CountdownItemState createState() => _CountdownItemState();
}

class _CountdownItemState extends State<CountdownItem> {
  // Timer? _timer;
  Duration? _remainingTime;
  bool isHover = false;

  @override
  void initState() {
    super.initState();
    _remainingTime =
        Utility.getDateTimeFromTimeStamp(widget.missionModel.end_time ?? 0)
            .difference(DateTime.now());
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
  //       _remainingTime = widget.countdown.targetTime.difference(DateTime.now());
  //     });
  //   // });
  // }

  @override
  void didUpdateWidget(CountdownItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (this.widget.cpt != oldWidget.cpt) {
      _remainingTime =
          Utility.getDateTimeFromTimeStamp(widget.missionModel.end_time ?? 0)
              .difference(DateTime.now());
    }
  }

  List<Widget> getUnfinishIconSlideActions(EndTimeMissionModel _missionModel) {
    return <Widget>[
      SlidableAction(
        label: getI18NKey().edit,
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        icon: Icons.edit,
        onPressed: (e) {
          this.widget.onTapEditListener(_missionModel);
        },
      ),
      SlidableAction(
        label: getI18NKey().delete,
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        icon: Icons.delete,
        onPressed: (e) {
          this.widget.onTapDeleteListener(_missionModel);
        },
      ),
    ];
  }

  List<Widget> getFinishIconSlideActions(EndTimeMissionModel _missionModel) {
    return <Widget>[
      SlidableAction(
        onPressed: (context) {
          this.widget.onTapDeleteListener(_missionModel);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: getI18NKey().delete,
      ),
    ];
  }

  List<PopupMenuEntry<String>> getUnfinishedPopupList(
      EndTimeMissionModel _missionModel) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'edit',
        onTap: () {
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapEditListener(_missionModel);
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
            this.widget.onTapDeleteListener(_missionModel);
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
      EndTimeMissionModel _missionModel) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
        value: 'delete',
        onTap: () {
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapDeleteListener(_missionModel);
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
          this.widget.onTapListener(this.widget.missionModel);
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
            margin: const EdgeInsets.fromLTRB(34, 10, 34, 10),
            child: buildCountdownCard(),
          ),
        ),
      ),
    );
  }

  /**
   * 功能：构建倒计时列表卡片主体。
   * 说明：卡片左侧色条和图标用于快速识别类型；高度控制在紧凑尺寸，避免列表一屏显示过少。
   */
  Widget buildCountdownCard() {
    final DateTime dateTime =
        Utility.getDateTimeFromTimeStamp(widget.missionModel.end_time ?? 0);
    final Color accentColor = getAccentColor();
    final bool isFinished = widget.missionModel.isFinished == true ||
        (_remainingTime?.inMilliseconds ?? 0) <= 0;

    return Container(
      height: 100,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 7,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 28, 16),
            child: Row(
              children: [
                buildTypeIcon(accentColor, isFinished),
                const SizedBox(width: 24),
                Expanded(
                  child: buildTitleAndMeta(dateTime, isFinished),
                ),
                const SizedBox(width: 20),
                buildTrailingStatus(accentColor, isFinished),
                if (isHover) ...[
                  const SizedBox(width: 10),
                  PopupMenuButton<String>(
                    tooltip: '',
                    icon: const Icon(Icons.more_vert,
                        color: Color(0xff98a1ad), size: 20),
                    itemBuilder: (context) {
                      if (this.widget.missionModel.isFinished == false) {
                        return getUnfinishedPopupList(this.widget.missionModel);
                      }
                      return getFinishedPopupList(this.widget.missionModel);
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTypeIcon(Color accentColor, bool isFinished) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Icon(
        getTypeIcon(isFinished),
        color: accentColor,
        size: 28,
      ),
    );
  }

  Widget buildTitleAndMeta(DateTime dateTime, bool isFinished) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.missionModel.title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 22,
            height: 1,
            fontWeight: FontWeight.w800,
            color: Color(0xff181c24),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.calendar_month,
                size: 14, color: Color(0xff566071)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                '${DateFormat('yyyy.MM.dd HH:mm EEEE').format(dateTime)} ${Utility.getLunarCalendar(year: dateTime.year, month: dateTime.month, day: dateTime.day)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff566071),
                ),
              ),
            ),
            const SizedBox(width: 12),
            buildStatusChip(isFinished),
          ],
        ),
      ],
    );
  }

  Widget buildStatusChip(bool isFinished) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffdce8ff),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        isFinished ? getI18NKey().finished : getI18NKey().counting,
        style: const TextStyle(
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w800,
          color: Color(0xff526179),
        ),
      ),
    );
  }

  Widget buildTrailingStatus(Color accentColor, bool isFinished) {
    if (isFinished) {
      return Icon(
        widget.missionModel.isFinished == true
            ? Icons.history
            : Icons.flag_circle,
        size: 28,
        color: accentColor.withValues(alpha: 0.42),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        DefaultTextStyle(
          style: TextStyle(
            fontSize: 16,
            height: 1,
            fontWeight: FontWeight.w900,
            color: accentColor,
          ),
          child: CountDownTextWidget(
            end_time: this.widget.missionModel.end_time ?? 0,
            fontSize: 16,
            color: accentColor.toARGB32(),
            onTapFinishListener: () {
              if (mounted) {
                setState(() {});
              }
            },
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'REMAINING TIME',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 2.2,
            fontWeight: FontWeight.w900,
            color: Color(0xff697180),
          ),
        ),
      ],
    );
  }

  Color getAccentColor() {
    if (widget.missionModel.isFinished == true) {
      return const Color(0xff0a68c9);
    }
    final List<Color> colors = [
      const Color(0xff0a68c9),
      const Color(0xffdf214f),
      const Color(0xff0d5fa8),
      const Color(0xff2b74d8),
    ];
    return colors[
        (widget.missionModel.title ?? '').hashCode.abs() % colors.length];
  }

  IconData getTypeIcon(bool isFinished) {
    if (isFinished) {
      return Icons.check_circle_outline;
    }
    final String title = widget.missionModel.title ?? '';
    if (title.contains('生日') || title.contains('纪念')) {
      return Icons.cake;
    }
    if (title.contains('高考') || title.contains('考试')) {
      return Icons.school;
    }
    return Icons.check_circle_outline;
  }
}
