import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/ListingSecurityWidget.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../components/GridSectionTitleWidget.dart';
import '../../../components/MoreWidget.dart';
import '../../../components/SectionTitleWidget.dart';
import '../../../config/ENUMS.dart';
import '../../../interface/OnCallbackListener.dart';
import '../../../models/MissionModel.dart';
import '../../../models/SessionMissionModel.dart';
import 'GridMissionSilverList.dart';
import 'MissionCustomButton.dart';
import 'MissionSilverList.dart';

class MissionGridView extends StatelessWidget {
  MultiSelectModeEnum multiSelectModeEnum;
  List<SessionMissionModel> list;
  OnTapListener onTapListener;
  double width = 300;
  MissionOrderEnum missionOrderEnum;

  // MissionSilverState? menuSilverListState;
  OnTapEditTitleListener? onTapEditTitleListener;
  OnTapEditListener? onTapEditListener;
  Function onTapCreateListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapPlayListener? onTapPlayListener;
  OnTapMultiSelectListener? onTapMultiSelectListener;
  OnTapUnFinishListener? onTapUnFinishListener;
  Function? onTapDoItNow;
  Function onTapShowFolderChartListener;
  int folderStatus = -1;

  MissionGridView(
      {required this.onTapListener,
      required this.onTapCreateListener,
      this.onTapDoItNow,
        required this.folderStatus,
      required this.missionOrderEnum,
      this.onTapEditTitleListener,
      this.onTapEditListener,
      this.onTapDeleteListener,
      this.onTapFinishListener,
      this.onTapPlayListener,
      required this.onTapShowFolderChartListener,
      this.onTapMultiSelectListener,
      this.onTapUnFinishListener,
      required this.multiSelectModeEnum,
      required this.list});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        // crossAxisCount: 2,
        maxCrossAxisExtent: width, // 固定宽度
        childAspectRatio: 0.7, // 宽高比
        mainAxisSpacing: 10.0, // 主轴间距
        crossAxisSpacing: 10.0, // 横轴间距
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return SliverGridviewItem(
            onTapListener: this.onTapListener,
            onTapCreateListener: this.onTapCreateListener,
            onTapDoItNow: this.onTapDoItNow,
            onTapEditTitleListener: this.onTapEditTitleListener,
            onTapEditListener: this.onTapEditListener,
            onTapDeleteListener: this.onTapDeleteListener,
            onTapFinishListener: this.onTapFinishListener,
            onTapPlayListener: this.onTapPlayListener,
            onTapMultiSelectListener: this.onTapMultiSelectListener,
            onTapUnFinishListener: this.onTapUnFinishListener,
            missionOrderEnum: this.missionOrderEnum,
            folderStatus: this.folderStatus,
            item: list[index],
            width: width,
            multiSelectModeEnum: this.multiSelectModeEnum,
            onTapShowFolderChartListener: this.onTapShowFolderChartListener,
          );
        },
        childCount: list.length,
      ),
    );
  }
}

class SliverGridviewItem extends StatelessWidget {
  int folderStatus = -1;
  MultiSelectModeEnum multiSelectModeEnum;
  SessionMissionModel item;
  Color color = Colors.red;
  double subFontSize = 12;
  Color subColor = Color(0xff666666);
  double headerHeight = 80;
  FolderModel? folderModel;
  OnTapListener onTapListener;
  MissionOrderEnum missionOrderEnum;

  double width = 300;
  OnTapEditTitleListener? onTapEditTitleListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapPlayListener? onTapPlayListener;
  OnTapMultiSelectListener? onTapMultiSelectListener;
  Function? onTapDoItNow;
  OnTapUnFinishListener? onTapUnFinishListener;
  Function onTapCreateListener;
  Function onTapShowFolderChartListener;

  SliverGridviewItem({
    required this.multiSelectModeEnum,
    required this.width,
    required this.item,
    required this.onTapListener,
    required this.onTapCreateListener,
    required this.onTapShowFolderChartListener,
    required this.missionOrderEnum,
    required this.folderStatus,
    this.onTapEditTitleListener,
    this.onTapEditListener,
    this.onTapDoItNow,
    this.onTapDeleteListener,
    this.onTapFinishListener,
    this.onTapPlayListener,
    this.onTapMultiSelectListener,
    this.onTapUnFinishListener,
  });

  double getFinishedPercent() {
    return Utility.getMissionModelFinished(item.datas ?? []).length.toDouble() /
        ((item.datas?.length ?? 0) > 0 ? (item.datas?.length ?? 1) : 1);
  }

  @override
  Widget build(BuildContext context) {
    // if (!TextUtil.isEmpty(item.folder_id)) {
    //   folderModel = MongoApisManager.getInstance()
    //       .queryfolderModelWithFolderId(item.folder_id);
    // } else if ((item.datas?.length ?? 0) > 0) {
    folderModel = MongoApisManager.getInstance()
        .queryfolderModelWithFolderId(item.folder_id);
    // }
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // print('Stack width: ${constraints.maxWidth}');
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                Container(
                  color: Color(item.color ?? 0xffff8800),
                  width: constraints.maxWidth * getFinishedPercent(),
                  height: headerHeight,
                ),
                Container(
                  color: Color((folderModel?.color ?? 0xffff8800) - 0xa0000000),
                  height: headerHeight,
                ),
                Container(
                  height: headerHeight,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Text(
                              item.title ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: subFontSize + 2,
                                  color: ThemeManager.getInstance().isDark() ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ListingSecurityWidget(folder_id: folderModel?.objectId ?? "", cryptoVersion: folderModel?.cryptoVersion ?? -1, size: 14, marginRight: 4,),
                              if (folderModel != null)
                                InkWell(
                                  onTap: () {
                                    this
                                        .onTapShowFolderChartListener
                                        ?.call(folderModel);
                                  },
                                  child: Utility.getSVGPicture(
                                      R.assetsImgIcBarChart,
                                      size: 15),
                                ),
                              if (folderModel != null)
                                SizedBox(
                                  width: 5,
                                ),
                              MissionCustomButton(
                                text: getI18NKey().create,
                                fontSize: 12,
                                color: Color(item?.color ?? 0xffff8800),
                                onTapListener: () {
                                  this.onTapCreateListener.call(folderModel);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 15,
                            color: ThemeManager.getInstance().getIconColor(defaultColor: subColor),
                          ),
                          Text(
                            Utility.getTimeString(
                                startTime: folderModel?.start_time,
                                endTime: folderModel?.end_time),
                            style: TextStyle(
                                fontSize: subFontSize, color: ThemeManager.getInstance().getTextColor(defaultColor: subColor)),
                          ),
                          Spacer(),
                          Text(
                            '',
                            style: TextStyle(
                                fontSize: subFontSize, color: ThemeManager.getInstance().getTextColor(defaultColor: subColor)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          (item.datas?.length ?? 0) == 0
                              ? SizedBox.shrink()
                              : Text(
                                  getI18NKey().repeative_content(Utility
                                          .getMissionModelRepeativeUnfinished(
                                              item.datas ?? [])
                                      .length),
                                  style: TextStyle(
                                      fontSize: subFontSize, color: ThemeManager.getInstance().getTextColor(defaultColor: subColor)),
                                ),
                          Spacer(),
                          Text(
                            (item.datas?.length ?? 0) == 0
                                ? getI18NKey().no_data
                                : getI18NKey().num_mission_total(
                                    Utility.getMissionModelFinished(
                                            item.datas ?? [])
                                        .length,
                                    item.datas?.length ?? 0),
                            style: TextStyle(
                                fontSize: subFontSize, color: ThemeManager.getInstance().getTextColor(defaultColor: subColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Color(0xfff0f0f0)),
                child: CustomScrollView(slivers: getList()),
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> getList() {
    List<Widget> listWidget = [];
    listWidget.addAll(buildListWidget(Utility.getListAfterOrder(
        this.missionOrderEnum, Utility.filterMissionModelByFinishedState(list: this.item.datas ?? [], isFinished: false), this.folderStatus) ?? [], false));
    listWidget.add(MoreWidget(
      text: getI18NKey().missionCompleted,
      // onTapListener: () {
      //   this.onTapMoreListener.call();
      // },
    ));
    listWidget.addAll(buildListWidget(Utility.getListAfterOrder(
        this.missionOrderEnum, Utility.filterMissionModelByFinishedState(list: this.item.datas ?? [], isFinished: true), this.folderStatus) ?? [], true));
    return listWidget;
  }

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
          onTapListener: (v) {
            this.onTapListener.call(v);
          },
          onTapDoItNow: (v) {
            this.onTapDoItNow?.call(v);
          },
          multiSelectModeEnum: this.multiSelectModeEnum,
          onTapMultiSelectListener: (MissionModel? list) {
            this.onTapMultiSelectListener?.call(list);
          },
          //未完成任务列表
          onTapUnFinishListener: (data) {
            this.onTapUnFinishListener?.call(data);
          },
          onTapEditTitleListener: (obj) {
            this.onTapEditTitleListener?.call(obj);
          },
          onTapPlayListener: (obj) {
            this.onTapPlayListener?.call(obj);
          },
          onTapDeleteListener: (data) async {
            this.onTapDeleteListener?.call(data);
          },
          onTapEditListener: (data) {
            this.onTapEditListener?.call(data);
          },
          onTapFinishListener: (data) {
            this.onTapFinishListener?.call(data);
          },
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
}
