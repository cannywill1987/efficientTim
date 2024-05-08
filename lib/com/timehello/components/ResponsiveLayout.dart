import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/ScreenUtil.dart';

import '../common/provider/Env.dart';

typedef OnOSListener = void Function(ScreenType screenType, BoxConstraints obj);
typedef OnResizeOSListener = void Function(ScreenType screenType, BoxConstraints obj);
/**
 * 根据LayoutBuilder做页面的响应式开发
 */
class  ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopbody;
  OnOSListener onOSListener;
  OnResizeOSListener onResizeListener;
  ResponsiveLayout({Key? key, required this.onResizeListener, required this.mobileBody, required this.tabletBody, required this.desktopbody, required this.onOSListener}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimens) {
        double width = ScreenUtil.getScreenW(context);
        // print('width:' + width.toString() + ",screenWidth:" + dimens.maxWidth.toString());
        if (width < kTabletBreakpoint) {
          if (this.onOSListener != null && screenType != ScreenType.Handset) {
            screenType = ScreenType.Handset;
            this.onOSListener(ScreenType.Handset, dimens);
          }
          this.onResizeListener(screenType, dimens);
          // print('mobileBody');
          return mobileBody;
        } else if (width > kTabletBreakpoint && width < kDesktopBreakpoint) {
          if (this.onOSListener != null && screenType != ScreenType.Tablet) {
            screenType = ScreenType.Tablet;
            this.onOSListener(ScreenType.Tablet, dimens);
          }
          this.onResizeListener(screenType, dimens);
          // print('tabletBody');
          return tabletBody ?? mobileBody;
        } else {
          if (this.onOSListener != null && screenType != ScreenType.Desktop) {
            screenType = ScreenType.Desktop;
            this.onOSListener(ScreenType.Desktop, dimens);
          }
          this.onResizeListener(screenType, dimens);
          // print('desktopbody');
          return desktopbody;
        }
      },

    );
  }
}