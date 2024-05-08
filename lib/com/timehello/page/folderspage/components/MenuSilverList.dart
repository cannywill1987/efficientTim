import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:time_hello/com/timehello/components/ListingSecurityWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderModelWithExtraData.dart';
import 'package:time_hello/com/timehello/page/folderspage/components/FolderSilverListItem.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../components/CustomMissionLayoutTypeWidget.dart';
import '../../../models/CalendarModel.dart';
import '../../../util/DeviceInfoManagement.dart';

typedef OnTapFinishListener = void Function(dynamic obj);
typedef OnTapEditListener = void Function(dynamic obj);
typedef OnTapDeleteListener = void Function(dynamic obj);
typedef OnTapShareListener = void Function(dynamic obj);
typedef OnTapCreateFolderListener = void Function(dynamic obj);
typedef OnTapShowFolderChartListener = void Function(dynamic obj);
typedef OnTapCreateTagListener = void Function(dynamic obj);
typedef OnTapArchiveListener = void Function(dynamic obj);

class MenuSilverList extends StatefulWidget {
  List<FolderModelWithExtraData> datas = [];
  OnTapListener? onTapListener;
  Function? onTapMoreListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapShareListener? onTapShareListener;
  OnTapArchiveListener? onTapArchiveListener;
  MenuSilverListState? menuSilverListState;
  OnTapShowFolderChartListener? onTapShowFolderChartListener;
  OnTapCreateTagListener? onTapCreateTagListener;
  OnTapCreateFolderListener? onTapCreateFolderListener;
  Function onUpdateTitleListener;
  CalendarModel calendarModel;
  FolderPageViewEnum folderPageViewEnum = FolderPageViewEnum.normal;
  String curSelectedTitle;

  // String curSelectedTitle;
  MenuSilverList(
      {Key? key,
      required this.datas,
      // required this.curSelectedTitle,
      OnTapListener? onTapListener,
      required this.curSelectedTitle,
      required this.folderPageViewEnum,
      required this.onUpdateTitleListener,
      this.onTapArchiveListener,
      required this.calendarModel,
      this.onTapMoreListener,
      this.onTapShowFolderChartListener,
      this.onTapFinishListener,
      this.onTapDeleteListener,
      this.onTapShareListener,
      this.onTapCreateTagListener,
      this.onTapCreateFolderListener,
      this.onTapEditListener})
      : super(key: key) {
    this.onTapListener = onTapListener;
    // datas.sort((FolderModel folderModel1, FolderModel folderModel2) {
    //   if((folderModel1.tag ?? 0) > (folderModel2.tag ?? 0)) {
    //     return 1;
    //   } else if(folderModel1.tag == folderModel2.tag) {
    //     return 0;
    //   }  else if((folderModel1.tag ?? 0) < (folderModel2.tag ?? 0)) {
    //     return -1;
    //   }
    //   if(this.folderPageViewEnum == FolderPageViewEnum.normal) {
    //     this.curSelectedTitle = this._datas?[0].folderModel.title ?? "";
    //   }
    //   // if (folderModel2.tag == 2) {
    //   //   return -1;
    //   // }
    //   return 0;
    // });
  }

  // set datas(List<FolderModelWithExtraData> datas) {
  //   _datas = datas;
  // }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return menuSilverListState = new MenuSilverListState();
  }
}

class MenuSilverListState extends State<MenuSilverList> {
  double iconSize = 18;

  // late String curSelectedTitle;

  @override
  void initState() {
    // this.curSelectedTitle = this.widget._datas?[0].folderModel.title ?? "";
  } // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单

  /**
   * folderTimeModel
   * 预计时间
   */
  // 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单
  String getPreviewTimeString(
      FolderModelWithExtraData folderModelWithExtraData) {
    switch (folderModelWithExtraData.folderModel.iconType) {
      case 0:
        return folderModelWithExtraData
            .folderTimeModel.previewTimeString; //预计时间
      case 1:
        return folderModelWithExtraData.folderTimeModel.previewTimeString;
      case 2:
        return folderModelWithExtraData.folderTimeModel.previewTimeString;
      case 3:
        return folderModelWithExtraData.folderTimeModel.previewTimeString;
      case 4:
        return folderModelWithExtraData.folderTimeModel.previewTimeString;
      case 9:
        return folderModelWithExtraData.folderTimeModel.previewTimeString;
      case 6:
        return folderModelWithExtraData.folderTimeModel.finishedTimeString;
      case 10:
        String finishedTimeString = Utility.formatTimestampWithoutZero(folderModelWithExtraData.folderTimeModel.previewTime??0 + (folderModelWithExtraData.folderTimeModel.finishedTime ??0));
        return finishedTimeString;
    }
    return '';
  }

  String getUnfinishMissionString(
      FolderModelWithExtraData folderModelWithExtraData) {
    switch (folderModelWithExtraData.folderModel.iconType) {
      case 0:
        return folderModelWithExtraData.folderTimeModel.numMissionToFinished
            .toString(); //预计时间
      case 1:
        return folderModelWithExtraData.folderTimeModel.numMissionToFinished
            .toString();
      case 2:
        return folderModelWithExtraData.folderTimeModel.numMissionToFinished
            .toString();
      case 3:
        return folderModelWithExtraData.folderTimeModel.numMissionToFinished
            .toString();
      case 4:
        return folderModelWithExtraData.folderTimeModel.numMissionToFinished
            .toString();
      case 9:
        return folderModelWithExtraData.folderTimeModel.numMissionToFinished
            .toString();
      case 6:
        return folderModelWithExtraData.folderTimeModel.numMissionFinished
            .toString();
      case 10:
        return ((folderModelWithExtraData.folderTimeModel.numMissionFinished ?? 0)+ (folderModelWithExtraData.folderTimeModel?.numMissionToFinished ?? 0))
            .toString();
      case 11:
        return folderModelWithExtraData.folderTimeModel.numMissionFinished
            .toString();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    // if(screenType == ScreenType.Handset) {
    return getSliverList();
    // } else {
    return Container();
    // }
  }

  getSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return FolderSilverListItem(
            index: index,
            folderPageViewEnum:this.widget.folderPageViewEnum,
            calendarModel: this.widget.calendarModel,
            curSelectedTitle: this.widget.curSelectedTitle,
            // key: ValueKey(item.folderModel.objectId),
            folderModelWithExtraData: this.widget.datas[index],
            onTapListener: (folderModelWithExtraData) {
              this.widget.onTapListener?.call(folderModelWithExtraData);
            },
            onTapArchiveListener: (folderModelWithExtraData) {
              this.widget.onTapArchiveListener?.call(folderModelWithExtraData);
            },
            onTapMoreListener: (folderModelWithExtraData) {
              this.widget.onTapMoreListener?.call(folderModelWithExtraData);
            },
            onTapShowFolderChartListener: (folderModelWithExtraData) {
              this
                  .widget
                  .onTapShowFolderChartListener
                  ?.call(folderModelWithExtraData);
            },
            onTapFinishListener: (folderModelWithExtraData) {
              this.widget.onTapFinishListener?.call(folderModelWithExtraData);
            },
            onTapDeleteListener: (folderModelWithExtraData) {
              this.widget.onTapDeleteListener?.call(folderModelWithExtraData);
            },
            onTapShareListener: (folderModelWithExtraData) {
              this.widget.onTapShareListener?.call(folderModelWithExtraData);
            },
            onTapCreateTagListener: (folderModelWithExtraData) {
              this
                  .widget
                  .onTapCreateTagListener
                  ?.call(folderModelWithExtraData);
            },
            onTapCreateFolderListener: (folderModelWithExtraData) {
              this
                  .widget
                  .onTapCreateFolderListener
                  ?.call(folderModelWithExtraData);
            },
            onTapEditListener: (folderModelWithExtraData) {
              this.widget.onTapEditListener?.call(folderModelWithExtraData);
            },
            isOthers: false,
            onReorderEnd: (listListingObjectId, listOtherObjectIds,
                listFolderModelWithExtraData) {
              // this.widget.onReorderEnd?.call(listListingObjectId,
              //     listOtherObjectIds, listFolderModelWithExtraData);
            },
            onEnterListener: (FolderModel) {
              // this.widget.onEnterListener?.call(FolderModel);
            },
            onCancelListener: () {
              // this.widget.onCancelListener?.call();
            },
            onUpdateTitleListener:
                (FolderModelWithExtraData folderModelWithExtraData) {
              this.widget.onUpdateTitleListener?.call(folderModelWithExtraData);
            });
        // return getItem(index);
      }, childCount: this.widget.datas?.length, addAutomaticKeepAlives: false),
    );
  }

}
