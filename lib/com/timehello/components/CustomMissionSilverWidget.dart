import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/components/GridSectionTitleWidget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/models/SessionMissionModel.dart';
import 'package:time_hello/com/timehello/page/missionPage/componnents/GridMissionSilverList.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class CustomMissionSilverWidget extends StatelessWidget {
  List<MissionModel> listMissionModel = [];
  CustomMissionSilverWidget({required this.listMissionModel});

  List<Widget> buildListWidget(List<SessionMissionModel> list, bool isFinish) {
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      SessionMissionModel model = list[i];
      if((model.datas?.length ?? 0) > 0) {
        listWidget.add(SliverToBoxAdapter(
          child: GridSectionTitleWidget(
            title: model.title ?? "",
          ),
        ));
        listWidget.add(GridMissionSilverList(
          datas: Utility.parseMissionModelsByIsFinishedAndPriority(
              model.datas ?? []),
          onTapMultiSelectListener: (MissionModel? list) {
            // this.onClick('onTapMultiSelectListener', list);
          },
          onTapDoItNow: (data) {
            // this.onClick('onTapDoItNow', data);
          },
          //未完成任务列表
          onTapUnFinishListener: (data) {
            // this.onClick('onClickUnFinishListener', data); //点击完成任务
          },
          onTapEditTitleListener: (obj) {
            // this.onClick('onTapEditTitleListener', obj); //跳转到任务详情页MissionPage开始任务
          },
          onTapPlayListener: (obj) {
            // this.onClick('onClickMissionDetail', obj); //跳转到任务详情页MissionPage开始任务
          },
          onTapListener: (obj) {
            // this.onClick('onClickMissionSetting', obj); //跳转到设置叶敏
          },
          onTapDeleteListener: (data) async {
            // this.onClick('onClickDeleteItem', data); //侧滑点击删除
          },
          onTapEditListener: (data) {
            // this.onClick('onClickMissionSetting', data);
          },
          onTapFinishListener: (data) {
            // this.onClick('onClickFinishItem', data); //点击完成任务
          },
          // multiSelectModeEnum: this.multiSelectModeEnum,
        ));
      }
    }
    return listWidget;
    // return [
    //   SliverPadding(padding: EdgeInsets.only(top: 3)),
    //   SliverToBoxAdapter(
    //     child: SectionTitleWidget(
    //       title: '优先级',
    //     ),
    //   ),
    //
    // ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<SessionMissionModel>? list = Utility.getListAfterOrder(MissionOrderEnum.orderByTime, listMissionModel);
    return CustomScrollView(
      slivers: buildListWidget(list ?? [], false),);
  }
}