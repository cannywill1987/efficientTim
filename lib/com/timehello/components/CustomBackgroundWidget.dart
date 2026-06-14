import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/ScreenUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../config/CONSTANTS.dart';
import '../util/CounterManagement.dart';
import '../util/DialogManagement.dart';
import '../util/SharePreferenceUtil.dart';
import '../util/ThemeManager.dart';
import 'BlackCheckButtonListWidget.dart';
import 'DottedCircularProgressWidget.dart';

class CustomBackgroundWidget extends StatefulWidget {
  double progress = 0;
  int bgMode = 0;
  int fontMode = 0;
  String sec;
  String min;
  String? text;
  bool shouldShowProgressBar = true;
  Function onSizedChange;
  late List<Widget> headerChildrenWidget;
  late List<Widget> centerChildrenWidget;
  late List<Widget> bottomChildrenWidget;
  List<Widget>? rightChildrenWidget;

  CustomBackgroundWidget(
      {Key? key,
      List<Widget>? headerChildrenWidget,
      List<Widget>? centerChildrenWidget,
      this.rightChildrenWidget,
      bool shouldShowProgressBar = true,
      List<Widget>? bottomChildrenWidget,
      required this.onSizedChange,
      this.bgMode = 0,
      this.fontMode = 0,
      this.progress = 0,
      this.text,
      this.sec = "00",
      this.min = "00"})
      : super(key: key) {
    this.shouldShowProgressBar = shouldShowProgressBar;
    if (headerChildrenWidget != null) {
      this.headerChildrenWidget = headerChildrenWidget;
    } else {
      this.headerChildrenWidget = [];
    }
    if (centerChildrenWidget != null) {
      this.centerChildrenWidget = centerChildrenWidget;
    } else {
      this.centerChildrenWidget = [];
    }

    if (bottomChildrenWidget != null) {
      this.bottomChildrenWidget = bottomChildrenWidget;
    } else {
      this.bottomChildrenWidget = [];
    }
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomBackgroundWidgetState();
  }
}

class CustomBackgroundWidgetState extends State<CustomBackgroundWidget>
    with TickerProviderStateMixin {
  double size = 300;
  double progress = 0;
  String? backgroundUrl;
  String? famousSentence;
  Function? onTimerTick;

  initState() {
    super.initState();
    progress = widget.progress;
    if (TextUtil.isEmpty(SharePreferenceUtil.getSyncInstance()
            .getString(key: ShareprefrenceKeys.pcBackground)) ==
        true) {
      this.backgroundUrl = Utility.getBackgroundImageUrl() ?? '';
    } else {
      this.backgroundUrl = SharePreferenceUtil.getSyncInstance()
          .getString(key: ShareprefrenceKeys.pcBackground);
    }
    this.famousSentence = Utility.getFamousSentence();

    // 中间计时数字会自己刷新，这里单独监听计时器，避免大圆环停留在初始进度。
    onTimerTick = (int time) {
      if (!mounted || widget.shouldShowProgressBar != true) return;
      setState(() {
        progress = _getCounterProgress();
      });
    };
    CounterManagement.getInstance()
        .addOnTimerTickListener(onTimerTickListener: onTimerTick!);
  }

  @override
  void didUpdateWidget(covariant CustomBackgroundWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    progress = widget.progress;
  }

  String? getCurBackground() {
    return this.backgroundUrl;
  }

  next() {
    // 背景模式 0 手动 1 自动 2 纯净

    String bgUrl = SharePreferenceUtil.getSyncInstance()
        .getString(key: ShareprefrenceKeys.pcBackground);
    if (TextUtil.isEmpty(bgUrl) == true) {
      this.backgroundUrl = Utility.getBackgroundImageUrl() ?? '';
    } else {
      this.backgroundUrl = bgUrl;
    }
    this.famousSentence = Utility.getFamousSentence();
    setState(() {});
  }

  double getHeightCircleSize() {
    return size;
  }

  @override
  void dispose() {
    // 资源释放
    if (onTimerTick != null) {
      CounterManagement.getInstance()
          .removeOnTimerTickListenerList(onTimerTickListenerList: onTimerTick!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // size = ScreenUtil.getScreenW(context) - 50;
    // if (size > 480) {
    //   size = 480;
    // }
    // int heightTop = 300;
    // int heightBtom = 160;
    // if ((ScreenUtil.getScreenH(context) - heightTop - heightBtom) < 400) {
    //   size = ScreenUtil.getScreenH(context) - heightTop - heightBtom;
    // }
    return Stack(
      children: [
        if (this.widget.bgMode != 2)
          new Image.asset(R.assetsImgBgMission,
              width: ScreenUtil.getScreenW(context),
              height: ScreenUtil.getScreenH(context),
              fit: BoxFit.cover),
        if (this.widget.bgMode != 2)
          CachedNetworkImage(
            width: ScreenUtil.getScreenW(context),
            height: ScreenUtil.getScreenH(context),
            fit: BoxFit.cover,
            errorWidget: (context, url, error) {
              return new Image.asset(R.assetsImgBgMission,
                  width: ScreenUtil.getScreenW(context),
                  height: ScreenUtil.getScreenH(context),
                  fit: BoxFit.cover);
            },
            imageUrl:
                Utility.filterHttpUrl(this.backgroundUrl ?? '', prefix: "oss"),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  // colorFilter: ColorFilter.mode(
                  //     Colors.red, BlendMode.colorBurn)
                ),
              ),
            ),
            // placeholder: (context, url) =>
            //     CircularProgressIndicator(),
          ),
        if (this.widget.bgMode == 2)
          Container(
            width: ScreenUtil.getScreenW(context),
            height: ScreenUtil.getScreenH(context),
            color: Colors.black,
          ),
        Align(
          alignment: Alignment.topCenter,
          child: this.widget.rightChildrenWidget == null
              ? getBody()
              : Row(
                  children: [
                    Expanded(child: getBody()),
                    SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: this.widget.rightChildrenWidget!)),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Column getBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...this.widget.headerChildrenWidget,
        SizedBox(
          height: Utility.isHandsetBySize() ? 5 : 30,
        ),
        if (this.widget.shouldShowProgressBar == false)
          _buildFamousSentence(width: 560),
        if (this.widget.shouldShowProgressBar == false)
          SizedBox(
            height: 10,
          ),
        if (this.widget.shouldShowProgressBar == true) getCircleWidget(),
        if (this.widget.shouldShowProgressBar == false)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [...this.widget.centerChildrenWidget],
            ),
          ),
        ...this.widget.bottomChildrenWidget
      ],
    );
  }

  Expanded getCircleWidget() {
    return Expanded(child: LayoutBuilder(builder: (context, constraints) {
      double sizeP = constraints.maxHeight > constraints.maxWidth
          ? constraints.maxWidth
          : constraints.maxHeight;
      this.widget.onSizedChange.call(this.size);
      this.size = sizeP;
      return Container(
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: sizeP,
        height: sizeP,
        child: Stack(
          children: [
            Opacity(
              opacity: this.widget.shouldShowProgressBar == false ? 0 : 1,
              child: Container(
                width: sizeP,
                height: sizeP,
                // 大屏专注页使用圆点环，和悬浮小计时器的圆弧进度区分开。
                child: DottedCircularProgressWidget(
                  progress: progress,
                  activeColor: _getProgressActiveColor(),
                  inactiveColor: _getProgressInactiveColor(),
                  dotRadius: sizeP > 520 ? 3.2 : 2.6,
                  activeDotRadius: sizeP > 520 ? 7 : 5.8,
                  dotCount: sizeP > 520 ? 120 : 96,
                ),
              ),
            ),
            Container(
              // color: Colors.red,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFamousSentence(width: sizeP * 0.58),
                  SizedBox(
                    height: sizeP > 520 ? 46 : 26,
                  ),
                  ...this.widget.centerChildrenWidget,
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }));
  }

  /// 背景组件独立刷新进度，避免父级计时文案局部 setState 后圆环不重绘。
  double _getCounterProgress() {
    final manager = CounterManagement.getInstance();
    if (manager.totalTime <= 0) return widget.progress;
    return (manager.timeUsed / manager.totalTime).clamp(0.0, 1.0).toDouble();
  }

  /// 专注进度主色跟随设置页里的实时主题色，避免纯净模式仍固定橙色。
  Color _getProgressActiveColor() {
    return ThemeManager.getInstance().getDefautThemeColor();
  }

  /// 未激活圆点在黑底上保持可见，同时用主题色轻微染色，整体更一致。
  Color _getProgressInactiveColor() {
    final themeColor = _getProgressActiveColor();
    return Color.lerp(Colors.white, themeColor, 0.16)!
        .withValues(alpha: ThemeManager.getInstance().isDark() ? 0.36 : 0.42);
  }

  Widget _buildFamousSentence({required double width}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width.clamp(260, 640).toDouble()),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '“',
            style: TextStyle(
              color: _getProgressActiveColor(),
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 0.8,
            ),
          ),
          Text(
            this.famousSentence ?? '',
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 13,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
