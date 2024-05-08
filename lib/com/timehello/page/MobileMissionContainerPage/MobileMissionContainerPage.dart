import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/ChatGptPage.dart';
import 'package:time_hello/com/timehello/page/folderspage/FoldersPage.dart';
import 'package:time_hello/com/timehello/page/missionPage/MissionPage.dart';
import 'package:time_hello/com/timehello/util/ScreenUtil.dart';

import '../../config/CONSTANTS.dart';
import '../../config/ENUMS.dart';
import '../../models/FolderModel.dart';
import '../missionPage/MissionContainerPage.dart';

class MobileMissionContainerPage extends StatefulWidget {
  final Key key;
  const MobileMissionContainerPage({required this.key}) : super(key: key);
  @override
  _MobileMissionContainerPageState createState() => _MobileMissionContainerPageState();
}

class _MobileMissionContainerPageState extends State<MobileMissionContainerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Function? onTapListener;
  FolderModel? folderModel;
  int folderStatus = 1;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
          width: ScreenUtil.getScreenW(context) * 9 / 10,
        child: ChatGptPage(),
      ),
      drawer: Drawer(
          width: ScreenUtil.getScreenW(context) * 9 / 10,
        child: FoldersPage(onTapListener: (Map data) {
          this.folderModel = data['folderModel'];
          this.folderStatus = data['folderStatus'];
          _scaffoldKey.currentState?.closeDrawer();
          setState(() {

          });
          // {"folderModel": data, "folderStatus": folderStatus}

        }),
      ),
      body: MissionContainerPage(key: ValueKey('MissionPage21312'), folderModel: folderModel, folderStatusDate: folderStatus, onTapRightNavMenuListener:() {
        _scaffoldKey.currentState?.openEndDrawer();
      },onTapNavMenuListener: () {
        _scaffoldKey.currentState?.openDrawer();
      },),
    );
  }
}