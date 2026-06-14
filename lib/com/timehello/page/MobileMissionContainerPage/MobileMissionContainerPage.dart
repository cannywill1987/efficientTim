import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/page/AIPage/AIPage.dart';
import 'package:time_hello/com/timehello/page/GroupChatPage/RightFolderContainerPage.dart';
import 'package:time_hello/com/timehello/page/folderspage/components/FoldersMobileDrawerStyleHelper.dart';
import 'package:time_hello/com/timehello/page/folderspage/FoldersPage.dart';
import 'package:time_hello/com/timehello/page/missionPage/MissionPage.dart';
import 'package:time_hello/com/timehello/util/ScreenUtil.dart';

import '../../config/CONSTANTS.dart';
import '../../config/ENUMS.dart';
import '../../models/FolderModel.dart';
import '../GroupChatPage/GroupChatPage.dart';
import '../missionPage/MissionContainerPage.dart';

class MobileMissionContainerPage extends StatefulWidget {
  final Key key;
  const MobileMissionContainerPage({required this.key}) : super(key: key);
  @override
  _MobileMissionContainerPageState createState() =>
      _MobileMissionContainerPageState();
}

class _MobileMissionContainerPageState
    extends State<MobileMissionContainerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Function? onTapListener;
  FolderModel? folderModel;
  int folderStatus = 1;
  bool isGpt = true; // true: GPT, false: Chat 右上角按钮

  @override
  Widget build(BuildContext context) {
    final FoldersMobileDrawerStyleMetrics drawerMetrics =
        FoldersMobileDrawerStyleHelper.modernMetrics;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        width: ScreenUtil.getScreenW(context) * 9 / 10,
        child: this.isGpt ? AIPage() : RightFolderContainerPage(),
        // child: AIPage(),
      ),
      drawer: Drawer(
        width: ScreenUtil.getScreenW(context) * drawerMetrics.widthFactor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(drawerMetrics.cornerRadius),
            bottomRight: Radius.circular(drawerMetrics.cornerRadius),
          ),
        ),
        child: FoldersPage(
          useMobileModernStyle: true,
          onCloseListener: () {
            _scaffoldKey.currentState?.closeDrawer();
          },
          onTapListener: (Map data) {
            this.folderModel = data['folderModel'];
            this.folderStatus = data['folderStatus'];
            _scaffoldKey.currentState?.closeDrawer();
            setState(() {});
            // {"folderModel": data, "folderStatus": folderStatus}
          },
        ),
      ),
      body: MissionContainerPage(
        key: ValueKey('MissionPage21312'),
        folderModel: folderModel,
        folderStatusDate: folderStatus,
        onTapRightNavMenuListener: (folderModel, isGpt) {
          this.isGpt = isGpt;
          setState(() {});
          Future.delayed(Duration(milliseconds: 100), () {
            _scaffoldKey.currentState?.openEndDrawer();
          });
          // _scaffoldKey.currentState?.openEndDrawer();
        },
        onTapNavMenuListener: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
    );
  }
}
