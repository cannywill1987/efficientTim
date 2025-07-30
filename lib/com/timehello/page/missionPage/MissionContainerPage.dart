import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/CreateMissionPage/CreateMissionPage.dart';
import 'package:time_hello/com/timehello/page/missionDetailPage/MissionDetailPage.dart';
import 'package:time_hello/com/timehello/page/missionPage/GroupMissionPage.dart';
import 'package:time_hello/com/timehello/page/missionPage/MissionPage.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../common/provider/Env.dart';
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

  componentDidMount() {
    //监听广播 设置页面过来后用得上 todo 应该加一个action
    // eventBus.on<EventFn>().listen((EventFn event) {
    //   //这个不需要也行 但是有一个用户反馈创建用户没刷新这里
    //   //这个不需要也行 但是有一个用户反馈创建用户没刷新这里
    //   if (event.type == Params.ACTION_UPDATE_MISSION_CONTAINER) {
    //     if(this.mounted){
    //       this.setState(() {});
    //     }
    //   }
    // });
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    return Stack(
      children: <Widget>[
        ////布局类型 0 列表 1 group分组 2 时间线
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