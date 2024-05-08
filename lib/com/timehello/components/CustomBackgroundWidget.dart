import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/ScreenUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../config/CONSTANTS.dart';
import '../util/DialogManagement.dart';
import '../util/SharePreferenceUtil.dart';
import 'BlackCheckButtonListWidget.dart';
import 'CustomPainterCircleProgressWidget.dart';

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
  String? backgroundUrl;
  String? famousSentence;

  initState() {
    super.initState();
    if (TextUtil.isEmpty(SharePreferenceUtil.getSyncInstance()
            .getString(key: ShareprefrenceKeys.pcBackground)) ==
        true) {
      this.backgroundUrl = Utility.getBackgroundImageUrl() ?? '';
    } else {
      this.backgroundUrl = SharePreferenceUtil.getSyncInstance()
          .getString(key: ShareprefrenceKeys.pcBackground);
    }
    this.famousSentence = Utility.getFamousSentence();
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
    super.dispose();
    // 资源释放
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
            imageUrl: Utility.filterHttpUrl(this.backgroundUrl ?? '', prefix: "oss"),
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
                    SizedBox(width: 5,),
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
        Container(
          constraints: BoxConstraints(minHeight: 50),
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Text(
            this.famousSentence ?? '',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
                  child: CustomPaint(
                      size: Size(sizeP, sizeP),
                      painter: CustomPainterCircleProgressWidget(
                          progressColor: ColorsConfig.standardColor,
                          progress: this.widget.progress))),
            ),
            Container(
              // color: Colors.red,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
}
