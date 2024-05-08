import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/CreateMissionPage/CreateMissionPage.dart';
import 'package:time_hello/com/timehello/page/missionDetailPage/MissionDetailPage.dart';
import 'package:time_hello/com/timehello/page/missionPage/GroupMissionPage.dart';
import 'package:time_hello/com/timehello/page/missionPage/MissionPage.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../components/ViewStub.dart';
import 'componnents/TimeManagementMissionPage.dart';

class MissionContainerPage extends BaseWidget {
  Key? key;
  FolderModel? folderModel;
  int? folderStatusDate = 1;
  Function? onTapNavMenuListener;
  Function? onTapRightNavMenuListener;

  MissionContainerPage({this.key, this.folderModel,
      this.folderStatusDate, this.onTapNavMenuListener, this.onTapRightNavMenuListener}); // 根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 6 已完成

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return MissionContainerPageState();
  }

}

class MissionContainerPageState extends BaseWidgetState<MissionContainerPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isNavBackBtnVisible = false;
    this.isAppBarVisible = false;
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
         return Stack(
      children: <Widget>[
        ViewStubWidget(
          isShowed: this.widget.folderModel?.layoutType == 2 || this.widget.folderModel?.layoutType == 0 || this.widget.folderModel?.layoutType == null,
          child: MissionPage(onTapRightNavMenuListener: this.widget.onTapRightNavMenuListener, onTapNavMenuListener: this.widget.onTapNavMenuListener, folderModel: this.widget.folderModel, folderStatusDate: this.widget.folderStatusDate),
        ),
        ViewStubWidget(
        // , folderModel: this.widget.folderModel
          child: Container(child: GroupMissionPage(key: ValueKey("eiwfjiwef"),onTapRightNavMenuListener: this.widget.onTapRightNavMenuListener,  onTapNavMenuListener: this.widget.onTapNavMenuListener),),
          isShowed: this.widget.folderModel?.layoutType == 1,
        ),
        ViewStubWidget(
          // , folderModel: this.widget.folderModel
          child: Container(child: TimeManagementMissionPage(key: ValueKey("eiwfjiwefwe"), onTapRightNavMenuListener: this.widget.onTapRightNavMenuListener, onTapCreateMissionListener: (MissionModel missionModel){
            if (Utility.isHandsetBySize() == true) {
              Utility.pushNavigator(context,
                  CreateMissionPage(missionModel: missionModel, onRefresh: () {}));
            } else {
              DialogManagement.getInstance().showPCCustomDialog(
                  context: context,
                  widget: CreateMissionPage(
                      missionModel: missionModel, onRefresh: () {}));
            }
          }, onTapNavMenuListener: this.widget.onTapNavMenuListener),),
          isShowed: this.widget.folderModel?.layoutType == 2,
        ),
        // Offstage(
      ],
    );
    // return super.baseBuild(context);
  }

}