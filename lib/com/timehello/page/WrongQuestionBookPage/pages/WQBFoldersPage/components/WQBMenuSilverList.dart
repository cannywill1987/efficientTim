import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderModelWithExtraData.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/com/timehello/util/WidgetManager.dart';

import '../../../../../../../r.dart';
import '../../../../../models/CalendarModel.dart';
import '../../../../../models/WQBFolderModel.dart';
import '../../../../../models/WQBFolderModelWithExtraData.dart';


typedef OnTapFinishListener = void Function(dynamic obj);
typedef OnTapEditListener = void Function(dynamic obj);
typedef OnTapDeleteListener = void Function(dynamic obj);
typedef OnTapShareListener = void Function(dynamic obj);
typedef OnTapCreateFolderListener = void Function(dynamic obj);
typedef OnTapCreateTagListener = void Function(dynamic obj);

class WQBMenuSilverList extends StatefulWidget {
  List<WQBFolderModelWithExtraData> _datas = [];
  OnTapListener? onTapListener;
  Function? onTapMoreListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapShareListener? onTapShareListener;
  WQBMenuSilverListState? menuSilverListState;
  OnTapCreateTagListener? onTapCreateTagListener;
  OnTapCreateFolderListener? onTapCreateFolderListener;
  CalendarModel calendarModel;

  // String curSelectedTitle;
  WQBMenuSilverList(
      {Key? key,
      required List<WQBFolderModel> datas,
      // required this.curSelectedTitle,
      OnTapListener? onTapListener,
      required this.calendarModel,
      this.onTapMoreListener,
      this.onTapFinishListener,
      this.onTapDeleteListener,
      this.onTapShareListener,
      this.onTapCreateTagListener,
      this.onTapCreateFolderListener,
      this.onTapEditListener})
      : super(key: key) {
    this.onTapListener = onTapListener;
    datas.sort((WQBFolderModel folderModel1, WQBFolderModel folderModel2) {
      if((folderModel1.tag ?? 0) > (folderModel2.tag ?? 0)) {
        return 1;
      } else if(folderModel1.tag == folderModel2.tag) {
        return 0;
      }  else if((folderModel1.tag ?? 0) < (folderModel2.tag ?? 0)) {
        return -1;
      }
      // if (folderModel2.tag == 2) {
      //   return -1;
      // }
      return 0;
    });
    this.datas = CONSTANTS.getWQBMenuList(datas,
        isMobile: screenType == ScreenType.Handset,
        calendarModel: calendarModel, shouldAddDayType: false);


  }

  set datas(List<WQBFolderModelWithExtraData> datas) {
    _datas = datas;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return menuSilverListState = new WQBMenuSilverListState();
  }
}

class WQBMenuSilverListState extends State<WQBMenuSilverList> {
  double iconSize = 18;
  String curSelectedTitle = "";
  double ratio = Utility.getRatioForSlider(
    numItem: 5,
  );
  @override
  void initState() {
    if(this.widget._datas.length > 0) {
      this.curSelectedTitle = this.widget._datas?[0].folderModel.title ?? "";
    }
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
      case 6:
        return folderModelWithExtraData.folderTimeModel.finishedTimeString;
    }
    return '';
  }



  String getWQBUnfinishMissionString(
      WQBFolderModelWithExtraData folderModelWithExtraData) {
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
      case 6:
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
        if(this.widget._datas?.length == 0) {
          return SizedBox.shrink();
        } else {
          return getItem(index);
        }
      }, childCount: this.widget._datas?.length == 0 ? 1 : this.widget._datas?.length, addAutomaticKeepAlives: false),
    );
  }

  Widget getItem(int index) {
    bool isItemHover = false;
    WQBFolderModelWithExtraData _folderModelWithExtraData =
        this.widget._datas![index];
    // print("222222222222222222222222 title: ${_folderModelWithExtraData.folderModel.title}");
    // print("222222222222222222222222 isSharing: ${_folderModelWithExtraData.folderModel.isSharing}");
    // print(_folderModel.color);
    List<Widget> children = <Widget>[
      Container(
          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: WidgetManager.getWQBFolderModelIcon(_folderModelWithExtraData.folderModel, iconSize)),
      SizedBox(
        width: 10,
      ),
      //标题
      Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_folderModelWithExtraData.folderModel.title ?? "",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: ThemeManager.getInstance().getTextColor(defaultColor: _folderModelWithExtraData.folderModel.iconType == 7
                          ? ColorsConfig.create_folder
                          : ColorsConfig.gray_40))),
              TextUtil.isEmpty(_folderModelWithExtraData
                              .folderModel.courseModelId) ==
                          true &&
                      (_folderModelWithExtraData.folderModel.isSharing == 0 ||
                          _folderModelWithExtraData.folderModel.isSharing ==
                              null)
                  ? SizedBox.shrink()
                  : Text(
                  _folderModelWithExtraData.folderModel.uid == LoginManager.getInstance().userBean.uid ? getI18NKey().my(getCourseSubtitle(_folderModelWithExtraData)) : getCourseSubtitle(_folderModelWithExtraData),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: Color(0xffff8800))),
            ],
          ),
          flex: 3),
    ];
    //用于展示 不用于存储 2-今天 明天 即将到来等 3-创建清单
    if (_folderModelWithExtraData.folderModel.type == 2 ||
        _folderModelWithExtraData.folderModel.type == null) {
      //右侧分钟
      children.addAll([
        Wrap(
          children: [
            _folderModelWithExtraData.isHover == false
                ? Wrap(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      getWQBUnfinishMissionString(_folderModelWithExtraData)
                              .isEmpty
                          ? SizedBox.shrink()
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: ThemeManager.getInstance().getDefautThemeColor(),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(2))),
                              child: Text(
                                  _folderModelWithExtraData
                                              .folderModel.iconType ==
                                          5
                                      ? getI18NKey().focus_numbers_with_value(
                                          getWQBUnfinishMissionString(
                                              _folderModelWithExtraData))
                                      : getI18NKey().rest_focus_numbers_with_value(
                                          getWQBUnfinishMissionString(
                                              _folderModelWithExtraData)), //右侧分钟
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 12, color: ColorsConfig.white)))
                    ],
                  )
                : SizedBox.shrink(),
            Offstage(
                offstage: _folderModelWithExtraData.isHover == false,
                child: InkWell(
                    child: PopupMenuButton<String>(
                  tooltip: '',
                  offset: Offset(-70, 10), //弹出的popup便宜位置
                  onSelected: (String val) {
                    if (val == 'edit') {
                      this.widget.onTapEditListener!(_folderModelWithExtraData);
                    } else if (val == 'delete') {
                      this
                          .widget
                          .onTapDeleteListener!(_folderModelWithExtraData);
                    } else if (val == 'share') {
                      this
                          .widget
                          .onTapShareListener!(_folderModelWithExtraData);
                    }
                  },
                  itemBuilder: (context) {
                    // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
                    // !TextUtil.isEmpty(_folderModelWithExtraData
                    //     .folderModel.courseModelId) &&
                    if (_folderModelWithExtraData.folderModel.tag == 1 &&
                        _folderModelWithExtraData.folderModel.uid == LoginManager.getInstance().userBean.uid) {
                      return get3PopupList(_folderModelWithExtraData);
                    } else {
                      return get2PopupList();
                    }
                  },
                )
                    // IconButton(
                    //   onPressed: () {
                    //     this.widget?.onTapMoreListener(_folderModelWithExtraData);
                    //   },
                    //   icon: Icon(
                    //     Icons.more_horiz,
                    //     size: 20,
                    //   ),
                    // ),
                    )),
            SizedBox(
              width: 10,
            ),
          ],
          crossAxisAlignment: WrapCrossAlignment.center,
        )
      ]);
    } else if (_folderModelWithExtraData.folderModel.type == 3 &&
        screenType == ScreenType.Handset) {
      //创建清单 移动端
      children.addAll([getCreateWidget(_folderModelWithExtraData)]);
    }
    //用于展示 不用于存储 2-今天 明天 即将到来等 3-创建清单
    if ((DeviceInfoManagement.isMoible() == true || DeviceInfoManagement.isWebMobileBySize()) ||
        _folderModelWithExtraData.folderModel.tag == null) {
      return Slidable(
        key: ValueKey(_folderModelWithExtraData.folderModel),
        enabled: _folderModelWithExtraData.folderModel.tag != null &&
            (_folderModelWithExtraData.folderModel.tag == 1 ||
                _folderModelWithExtraData.folderModel.tag == 2),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: ratio,
          children: getSlideActions(_folderModelWithExtraData),
        ),
        child: getInnerItemWithoutContainer(_folderModelWithExtraData, children),
      );
    } else {
      //PC
      return MouseRegion(
          onEnter: (_) {
            setState(() {
              _folderModelWithExtraData.isHover = true;
            });
          },
          onHover: (_) {},
          onExit: (_) {
            setState(() {
              _folderModelWithExtraData.isHover = false;
            });
          },
          child: getInnerItemWithoutContainer(
              _folderModelWithExtraData, children, isItemHover));
    }
  }

  String getCourseSubtitle(WQBFolderModelWithExtraData _folderModelWithExtraData) {
    return _folderModelWithExtraData.folderModel.isSharing == 1
                        ? getI18NKey().public_course
                        : getI18NKey().sharing_course;
  }

  List<Widget> getSlideActions(WQBFolderModelWithExtraData _folderModelWithExtraData) {
    if (_folderModelWithExtraData.folderModel.tag == 1 &&
        _folderModelWithExtraData.folderModel.uid == LoginManager.getInstance().userBean.uid) {
      return <Widget>[
        SlidableAction(
          onPressed: (context) {
            if (this.widget.onTapEditListener != null)
              this.widget.onTapEditListener!(_folderModelWithExtraData); // 侧边栏编辑
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: Icons.edit,
          label: getI18NKey().edit,
        ),
        SlidableAction(
          onPressed: (context) {
            if (this.widget.onTapShareListener != null)
              this.widget.onTapShareListener!(_folderModelWithExtraData); // 侧边栏分享
          },
          backgroundColor: Colors.lightGreenAccent,
          foregroundColor: Colors.white,
          icon: Icons.share,
          label: _folderModelWithExtraData.folderModel.isSharing != 0 &&
              !TextUtil.isEmpty(_folderModelWithExtraData.folderModel.courseModelId)
              ? getI18NKey().edit_sharing
              : getI18NKey().share,
        ),
        SlidableAction(
          onPressed: (context) {
            if (this.widget.onTapDeleteListener != null)
              this.widget.onTapDeleteListener!(_folderModelWithExtraData); // 侧边栏删除
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: getI18NKey().delete,
        ),
      ];
    } else {
      return <Widget>[
        SlidableAction(
          onPressed: (context) {
            if (this.widget.onTapEditListener != null)
              this.widget.onTapEditListener!(_folderModelWithExtraData); // 侧边栏编辑
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: Icons.edit,
          label: getI18NKey().edit,
        ),
        SlidableAction(
          onPressed: (context) {
            if (this.widget.onTapDeleteListener != null)
              this.widget.onTapDeleteListener!(_folderModelWithExtraData); // 侧边栏删除
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: getI18NKey().delete,
        ),
      ];
    }
  }

  List<PopupMenuEntry<String>> get2PopupList() {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'edit',
        child: Text(getI18NKey().edit, style: TextStyle(fontSize: 15)),
      ),
      PopupMenuItem<String>(
        value: 'delete',
        child: Text(
          getI18NKey().delete,
          style: TextStyle(color: ColorsConfig.red, fontSize: 15),
        ),
      ),
    ];
  }

  List<PopupMenuEntry<String>> get3PopupList(
      WQBFolderModelWithExtraData folderModelWithExtraData) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'edit',
        child: Text(getI18NKey().edit, style: TextStyle(fontSize: 15)),
      ),
      // PopupMenuItem<String>(
      //   value: 'share',
      //   child: Text(
      //       folderModelWithExtraData.folderModel.isSharing != 0 &&
      //               !TextUtil.isEmpty(
      //                   folderModelWithExtraData.folderModel.courseModelId)
      //           ? getI18NKey().edit_sharing
      //           : getI18NKey().share,
      //       style: TextStyle(color: Color(0xffff8800), fontSize: 15)),
      // ),
      PopupMenuItem<String>(
        value: 'delete',
        child: Text(
          getI18NKey().delete,
          style: TextStyle(color: ColorsConfig.red, fontSize: 15),
        ),
      ),
    ];
  }

  InkWell getInnerItemWithoutContainer(
      WQBFolderModelWithExtraData _folderModelWithExtraData, List<Widget> children,
      [bool isItemHover = false]) {
    return InkWell(
        onTap: () {
          if (this.widget.onTapListener != null) {
            this.curSelectedTitle =
                _folderModelWithExtraData.folderModel.title ?? "";
            this
                .widget
                .onTapListener!(_folderModelWithExtraData.folderModel); //点击item
            setState(() {

            });
          }
        },
        child: Container(
          height: 46,
          decoration: (Utility.isHandsetBySize() == false &&
                  this.curSelectedTitle ==
                      _folderModelWithExtraData.folderModel.title)
              ? BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 5, color: ThemeManager.getInstance().getDefautThemeColor())))
              : BoxDecoration(
                  border: Border(
                      right: BorderSide(
                          width: Utility.isHandsetBySize() == false ? 5 : 0,
                          color: Colors.transparent))),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ));
  }

  /**
   * 创建清单的Item
   */
  Wrap getCreateWidget(WQBFolderModelWithExtraData _folderModelWithExtraData) {
    return Wrap(
      children: [
        IconButton(
            icon: Utility.getSVGPicture(R.assetsImgIcTags, size: iconSize),
            onPressed: () {
              if (this.widget.onTapCreateTagListener != null) {
                this.widget.onTapCreateTagListener!(_folderModelWithExtraData);
              }
            }),
        IconButton(
            icon: Icon(
              Icons.create_new_folder,
              color: ColorsConfig.create_folder,
              size: iconSize,
            ),
            onPressed: () {
              if (this.widget.onTapCreateTagListener != null) {
                this
                    .widget
                    .onTapCreateFolderListener!(_folderModelWithExtraData);
              }
            }),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
