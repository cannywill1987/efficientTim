import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/FolderSectionHeaderWidget.dart';
import 'package:time_hello/com/timehello/components/ListingSecurityWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/libs/DragAndDropLists/lib/drag_and_drop_list.dart';
import 'package:time_hello/com/timehello/libs/DragAndDropLists/lib/drag_and_drop_lists.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderModelWithExtraData.dart';
import 'package:time_hello/com/timehello/page/folderspage/components/FolderSilverListItem.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../components/CustomMissionLayoutTypeWidget.dart';
import '../../../interface/Interface.dart';
import '../../../models/CalendarModel.dart';
import '../../../util/DeviceInfoManagement.dart';

/**
 * 多个MenuSilverList组成的列表
 */
class FolderSilverList extends StatefulWidget {
  List<FolderModelWithExtraData> datas = [];
  OnTapListener? onTapListener;
  Function(List<String>?, List<String>?, List<FolderModelWithExtraData>?)
      onReorderEnd;
  Function? onTapMoreListener;
  Function? onCancelListener;
  Function? onCreateMissionFolderListener;
  final Function(FolderModel) onEnterListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapShareListener? onTapShareListener;
  OnTapArchiveListener? onTapArchiveListener;
  FolderSilverListState? menuSilverListState;
  Function(FolderModelWithExtraData)? onTapFoldedListener;
  OnTapShowFolderChartListener? onTapShowFolderChartListener;
  OnTapCreateTagListener? onTapCreateTagListener;
  OnTapCreateFolderListener? onTapCreateFolderListener;
  Function onUpdateTitleListener;
  CalendarModel calendarModel;
  FolderPageViewEnum folderPageViewEnum = FolderPageViewEnum.normal;
  String curSelectedTitle;

  // String curSelectedTitle;
  FolderSilverList(
      {Key? key,
      required this.datas,
      required this.onReorderEnd,
      // required this.curSelectedTitle,
      OnTapListener? onTapListener,
      required this.onTapFoldedListener,
      required this.curSelectedTitle,
      required this.folderPageViewEnum,
      required this.onEnterListener,
      this.onCancelListener,
      required this.onUpdateTitleListener,
      required this.onCreateMissionFolderListener,
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
    return menuSilverListState = new FolderSilverListState();
  }
}

class FolderSilverListState extends State<FolderSilverList> {
  double margin = 10;
  final ScrollController _scrollController = ScrollController();
  late List<DragAndDropList> _contentsForListing;

  // late String curSelectedTitle;

  @override
  void initState() {
    // this.curSelectedTitle = this.widget._datas?[0].folderModel.title ?? "";
    _contentsForListing = getSectionList();
  } // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单

  didUpdateWidget(FolderSilverList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.datas != widget.datas) {
      _contentsForListing = getSectionList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 14, top: 5),
      sliver: this.widget.datas.length == 0
          ? Container()
          : DragAndDropLists(
              children: _contentsForListing,
              lastItemTargetHeight: _contentsForListing.length == 0
                  ? 0
                  : margin, // 最后一个item的target高度
              //不能设置成0 否则无法拖动到文件夹 因为位置不够
              lastListTargetSize: 3, // 最后一个list的target大小
              //需要加点距离 否则最后个list无法被拖动到
              onItemReorder: _onItemReorder, // 拖拽item
              // onListAdd：_onListAdd,
              onListReorder: _onListReorder, // 拖拽list
              sliverList: true, // 是否是sliverList
              scrollController: _scrollController, // 滚动控制器
            ),
      key: ValueKey('menu_silver_list_2'),
    );
    // if(screenType == ScreenType.Handset) {
    // return getSliverList();
    // } else {
    // return Container();
    // }
  }

  /**
   * 获取列表
   */
  List<DragAndDropList> getSectionList() {
    List<FolderModelWithExtraData> list = this.widget.datas;
    List<DragAndDropList> _contents = [];

    for (int index = 0; index < list.length; index++) {
      FolderModelWithExtraData item = list[index];
      bool isOther = item.isOthers;
      FolderSectionHeaderWidget widget = FolderSectionHeaderWidget(
        onTapFoldedListener: (val) {
          item.folderModel.isFoldedForFolderCached = val;
          this.widget.onTapFoldedListener?.call(item);
        },
        isArchived: item.folderModel.folderStatus == 1,
        marginBottom: this.margin,
        key: ValueKey(item.folderModel.objectId),
        title: item.folderModel.title ?? "       ",
        isEditing: item.isEditingTitle,
        onEnterListener: (inputContent) {
          item.folderModel.title = inputContent;
          this.widget.onEnterListener.call(item.folderModel);
        },
        onCancelListener: () {
          this.widget.onCancelListener?.call();
        },
        onArchiveListener: () {
          this.widget.onTapArchiveListener?.call(item);
        },
        onUnarchiveListener: () {
          this.widget.onTapArchiveListener?.call(item);
        },
        onDeleteListener: () {
          this.widget.onTapDeleteListener?.call(item);
        },
        onCreateMissionFolderListener: () {
          this.widget.onCreateMissionFolderListener?.call(item);
        },
        isFoldedForFolder: item.folderModel.isFoldedForFolderCached ?? false,
      );
      _contents.add(DragAndDropList(
          data: item,
          // key: isOther ? "other_key" : item.folderModel.objectId.toString() + "_DragAndDropList_list",
          contentsWhenEmpty: SizedBox.shrink(),
          // lastTarget: Container(height: 20, color: Colors.red,),
          // isOther
          //     ? null
          //     :
          header: isOther ? null : widget,
          children: item.folderModel.isFoldedForFolderCached == true
              ? []
              : getList(item.listFolderModelWithExtraData ?? [],
                  isOthers: isOther)));
    }
    return _contents;
  }

  /**
   * 获取列表
   * list: 文件夹的数据
   * isOthers: 是否是其他文件夹
   */
  List<DragAndDropItem> getList(List<FolderModelWithExtraData> list,
      {bool isOthers = false}) {
    return List.generate(list.length, (index) {
      FolderModelWithExtraData item = list[index];
      return DragAndDropItem(
        data: item,
        child: FolderSilverListItem(
            index: index,
            folderPageViewEnum: this.widget.folderPageViewEnum,
            calendarModel: this.widget.calendarModel,
            curSelectedTitle: this.widget.curSelectedTitle,
            // key: ValueKey(item.folderModel.objectId),
            folderModelWithExtraData: item,
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
            isOthers: isOthers,
            onReorderEnd: (listListingObjectId, listOtherObjectIds,
                listFolderModelWithExtraData) {
              this.widget.onReorderEnd?.call(listListingObjectId,
                  listOtherObjectIds, listFolderModelWithExtraData);
            },
            onEnterListener: (FolderModel) {
              this.widget.onEnterListener?.call(FolderModel);
            },
            onCancelListener: () {
              this.widget.onCancelListener?.call();
            },
            onUpdateTitleListener:
                (FolderModelWithExtraData folderModelWithExtraData) {
              this.widget.onUpdateTitleListener?.call(folderModelWithExtraData);
            }),
        // child: getItem(index, item, isOthers: isOthers),
      );
    });
  }

  /**
   * 构建item
   * item: 文件夹的数据
   */
  _buildItem(FolderModelWithExtraData item) {
    return Text(item.folderModel.title ?? "");
  }

  /**
   * 拖拽item
   * oldItemIndex: 旧的item索引
   * oldListIndex: 旧的列表索引
   * newItemIndex: 新的item索引
   * newListIndex: 新的列表索引
   */
  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      DragAndDropItem movedItem =
          _contentsForListing[oldListIndex].children.removeAt(oldItemIndex);
      _contentsForListing[newListIndex]
          .children
          .insert(newItemIndex, movedItem);
      List<FolderModelWithExtraData> list =
          getFolderModelWithExtraDataFromContent();
      List<String>? listListingObjectId = null;
      List<FolderModelWithExtraData> listFolderModelWithExtraData = [];
      List<String>? listOtherObjectIds = null;
      //得到新的排序
      if (oldListIndex != newListIndex) {
        // 不同的列表 List和item都需要更新
        listListingObjectId = Utility.getFolderModelObjectIdOrderList(list);
        FolderModelWithExtraData folderModelWithExtraData1 = list[newListIndex];
        FolderModelWithExtraData folderModelWithExtraData2 = list[oldListIndex];
        if (folderModelWithExtraData1.folderModel.objectId !=
            CONSTANTS.OTHER_OBJECT_ID) {
          if (indexOfList(
                  listFolderModelWithExtraData, folderModelWithExtraData1) ==
              -1) listFolderModelWithExtraData.add(folderModelWithExtraData1);
        } else {
          // 动的是其他列表的话
          listOtherObjectIds = getOtherListObjectId();
        }
        if (folderModelWithExtraData2.folderModel.objectId !=
            CONSTANTS.OTHER_OBJECT_ID) {
          if (indexOfList(
                  listFolderModelWithExtraData, folderModelWithExtraData2) ==
              -1) listFolderModelWithExtraData.add(folderModelWithExtraData2);
        } else {
          // 动的是其他列表的话
          listOtherObjectIds = getOtherListObjectId();
        }
      } else {
        // 同一个列表 只需要更新当前listing的item
        FolderModelWithExtraData folderModelWithExtraData1 = list[newListIndex];
        if (folderModelWithExtraData1.folderModel.objectId !=
            CONSTANTS.OTHER_OBJECT_ID) {
          listFolderModelWithExtraData.add(folderModelWithExtraData1);
        } else {
          listOtherObjectIds = getOtherListObjectId();
        }
      }
      //listFolderModelWithExtraData 用于更新当前folder
      //listListingObjectId 用于更新当前folder的排序
      //listOtherObjectIds 用于更新其他folder的排序
      this.widget.onReorderEnd(listListingObjectId, listOtherObjectIds,
          listFolderModelWithExtraData);
    });
  }

  /**
   * 获取文件夹在列表中的索引
   */
  int indexOfList(List<FolderModelWithExtraData> listFolderModelWithExtraData,
      FolderModelWithExtraData folderModelWithExtraData) {
    for (int i = 0; i < listFolderModelWithExtraData.length; i++) {
      if (listFolderModelWithExtraData[i].folderModel.objectId ==
          folderModelWithExtraData.folderModel.objectId) {
        return i;
      }
    }
    return -1;
  }

  /**
   * 获取其他文件夹的objectId
   */
  List<String> getOtherListObjectId() {
    List<String> otherObjectId = [];
    _contentsForListing.forEach((element) {
      FolderModelWithExtraData folderModelWithExtraData = element.data;
      if (folderModelWithExtraData.folderModel.objectId ==
          CONSTANTS.OTHER_OBJECT_ID) {
        List<DragAndDropItem> children = element.children;
        children.forEach((item) {
          FolderModelWithExtraData folderModelWithExtraData = item.data;
          otherObjectId.add(folderModelWithExtraData.folderModel.objectId!);
        });
      }
    });
    return otherObjectId;
  }

  /**
   * 从DragAndDropList和DragAndDropItem拿到data数据 重新排序后的数据
   */
  List<FolderModelWithExtraData> getFolderModelWithExtraDataFromContent() {
    List<FolderModelWithExtraData> list = [];
    // List<String> listObjectIds = [];
    _contentsForListing.forEach((DragAndDropList element) {
      FolderModelWithExtraData folderModelWithExtraData = element.data;
      List<DragAndDropItem> children = element.children;
      List<String> listObjectIdsChildren = [];
      List<FolderModelWithExtraData> listChildren = [];
      children.forEach((DragAndDropItem item) {
        FolderModelWithExtraData folderModelWithExtraData = item.data;
        //用于填写folderObjectId
        if (!TextUtil.isEmpty(folderModelWithExtraData.folderModel.objectId)) {
          if (listObjectIdsChildren
                  .indexOf(folderModelWithExtraData.folderModel.objectId!) ==
              -1) {
            listObjectIdsChildren
                .add(folderModelWithExtraData.folderModel.objectId!);
          }
        }
        // listObjectIds.add(i)
        if (indexOfList(listChildren, folderModelWithExtraData) == -1) {
          listChildren.add(folderModelWithExtraData);
        }
      });
      folderModelWithExtraData.folderModel.folderModelObjectIdOrderList =
          listObjectIdsChildren;
      folderModelWithExtraData.listFolderModelWithExtraData = listChildren;
      list.add(folderModelWithExtraData);
    });
    return list;
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      // var movedList = this.widget.datas.removeAt(oldListIndex);
      // this.widget.datas.insert(newListIndex, movedList);
      var movedList = _contentsForListing.removeAt(oldListIndex);
      _contentsForListing.insert(newListIndex, movedList);
      List<FolderModelWithExtraData> list =
          getFolderModelWithExtraDataFromContent();
      List<String>? listObjectId = null;
      // List<FolderModelWithExtraData> listFolderModelWithExtraData = [];
      // List<String>? listOtherObjectIds = null;
      //得到新的排序
      if (oldListIndex != newListIndex) {
        // 不同的列表 List和item都需要更新
        listObjectId = Utility.getFolderModelObjectIdOrderList(list);
        //listFolderModelWithExtraData 用于更新当前folder
        //listListingObjectId 用于更新当前folder的排序
        //listOtherObjectIds 用于更新其他folder的排序
        this.widget.onReorderEnd(listObjectId, null, null);
      }
    });
  }
}
