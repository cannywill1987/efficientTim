import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/CustomMissionLayoutTypeWidget.dart';
import 'package:time_hello/com/timehello/components/ListingSecurityWidget.dart';
import 'package:time_hello/com/timehello/components/SliderWithCanvasWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/interface/OnCallbackListener.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/action_pane_motions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/actions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/slidable.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderModelWithExtraData.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../../../components/CalendarIconWidget.dart';
import '../../../components/CustomPainterCircleProgressWidget.dart';
import '../../../interface/Interface.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';

import '../../../../../r.dart';

/**
 * 要独立成item 否则isHover会有问题 会不生效
 * 文件夹银色列表item
 */
class FolderSilverListItem extends StatefulWidget {
  late int index; // 索引
  late FolderModelWithExtraData folderModelWithExtraData; // 文件夹数据
  bool isOthers = false; // 是否是其他文件夹
  OnTapListener? onTapListener; // 点击事件
  Function(List<String>?, List<String>?, List<FolderModelWithExtraData>?)
      onReorderEnd; // 重新排序
  Function? onTapMoreListener; // 点击更多
  Function? onCancelListener; // 取消
  final Function(FolderModel) onEnterListener; // 进入事件
  OnTapFinishListener? onTapFinishListener; // 完成事件
  OnTapEditListener? onTapEditListener; // 编辑事件
  OnTapDeleteListener? onTapDeleteListener; // 删除事件
  OnTapShareListener? onTapShareListener; // 分享事件
  OnTapArchiveListener? onTapArchiveListener; // 归档事件
  // FolderSilverListState? menuSilverListState;
  OnTapShowFolderChartListener? onTapShowFolderChartListener; // 显示图表事件
  OnTapCreateTagListener? onTapCreateTagListener; // 创建标签事件
  OnTapCreateFolderListener? onTapCreateFolderListener; // 创建文件夹事件
  Function onUpdateTitleListener; // 更新标题事件
  CalendarModel calendarModel; // 日历数据
  FolderPageViewEnum folderPageViewEnum = FolderPageViewEnum.normal; // 文件夹视图枚举
  String curSelectedTitle; // 当前选中的标题
  FolderSilverListItem(
      {required this.index,
      required this.folderModelWithExtraData,
      required this.isOthers,
      required this.onReorderEnd,
      required this.onEnterListener,
      required this.onUpdateTitleListener,
      required this.calendarModel,
      required this.curSelectedTitle,
      this.onTapListener,
      this.onTapMoreListener,
      this.onCancelListener,
      this.onTapFinishListener,
      this.onTapEditListener,
      this.onTapDeleteListener,
      this.onTapShareListener,
      this.onTapArchiveListener,
      // this.menuSilverListState,
      this.onTapShowFolderChartListener,
      this.onTapCreateTagListener,
      this.onTapCreateFolderListener,
      this.folderPageViewEnum = FolderPageViewEnum.normal});

  // FolderSilverListItem({required this.index, required this.folderModelWithExtraData, required this.isOthers});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FolderSilverListItemState();
  }
}

/**
 * 文件夹银色列表item状态
 */
class FolderSilverListItemState extends State<FolderSilverListItem> {
  double iconSize = 18; // 图标大小
  double ratio = Utility.getRatioForSlider(
    numItem: 5,
  );
  double itemPadding = 10; // 项目间距

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getItem(widget.index, widget.folderModelWithExtraData,
        isOthers: widget.isOthers);
  }

  /**
   * 获取item
   * index: 索引
   * folderModelWithExtraData: 文件夹数据
   * isOthers: 是否是其他文件夹
   */
  Widget getItem(int index, FolderModelWithExtraData folderModelWithExtraData,
      {bool isOthers = false}) {
    if (folderModelWithExtraData.folderModel.title ==
        getI18NKey().apple_alarm) {
      print("");
    }
    bool isItemHover = false; // 是否是item悬停
    //do it now有点问题 左边距不现实
    double marginLef =
        folderModelWithExtraData?.folderModel.iconType == 9 ? 12 : 15;
    List<Widget> children = <Widget>[
      // 容器
      Container(
          margin: EdgeInsets.fromLTRB(isOthers ? 0 : marginLef, 0, 0, 0),
          child: this.getIcon(folderModelWithExtraData.folderModel)),
      SizedBox(
        width: itemPadding,
      ),
      // 安全组件
      ListingSecurityWidget(
        folder_id: folderModelWithExtraData.folderModel.objectId ?? "",
        cryptoVersion: folderModelWithExtraData.folderModel.cryptoVersion ?? -1,
        size: 16,
        marginRight: 5,
      ),
      // 标题
      Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(folderModelWithExtraData.folderModel.title ?? "",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: ThemeManager.getInstance().getTextColor(
                          defaultColor:
                              folderModelWithExtraData.folderModel.iconType == 7
                                  ? ThemeManager.getInstance()
                                      .getDefautThemeColor()
                                  : ColorsConfig.gray_40))),
              if (folderModelWithExtraData.folderModel.start_time != null ||
                  folderModelWithExtraData.folderModel.end_time != null)
                Wrap(
                  children: [
                    ...getSegmentdateWidget(
                        folderModelWithExtraData.folderModel),
                  ],
                ),
              TextUtil.isEmpty(folderModelWithExtraData
                              .folderModel.courseModelId) ==
                          true &&
                      (folderModelWithExtraData.folderModel.isSharing == 0 ||
                          folderModelWithExtraData.folderModel.isSharing ==
                              null)
                  ? SizedBox.shrink()
                  : Text(
                      folderModelWithExtraData.folderModel.uid ==
                              LoginManager.getInstance().userBean.uid
                          ? getI18NKey()
                              .my(getSharingSubtitle(folderModelWithExtraData))
                          : getSharingSubtitle(folderModelWithExtraData),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: ThemeManager.getInstance()
                              .getTextColor(defaultColor: Color(0xffff8800)))),
            ],
          ),
          flex: 3),
    ];
    //用于展示 不用于存储 2-今天 明天 即将到来等 3-创建清单
    if (folderModelWithExtraData.folderModel.type == 2 ||
        folderModelWithExtraData.folderModel.type == null) {
      // if(folderModelWithExtraData.isHover == true) {
      //   print("1111111");
      // }
      //右侧分钟
      double percent = 0;
      if (folderModelWithExtraData.folderModel.tag == 5)
        percent = MongoApisManager.getInstance().getFolderModelPercent(
            folderModel: folderModelWithExtraData.folderModel);

      children.addAll([
        Wrap(
          children: [
            if (folderModelWithExtraData.folderModel.tag == 5)
              SizedBox(
                width: 5,
              ),
            if (folderModelWithExtraData.folderModel.tag == 5)
              Container(
                  width: 20,
                  height: 20,
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      CustomPaint(
                        size: Size(20, 20),
                        painter: CustomPainterCircleProgressWidget(
                          progressColor: ThemeManager.getInstance().isDark()
                              ? Color(
                                  folderModelWithExtraData.folderModel.color)
                              : Color(0xffff8800),
                          backgroundColor: ThemeManager.getInstance().isDark()
                              ? Color(
                                  folderModelWithExtraData.folderModel.color -
                                      0xa0000000)
                              : Color(0xffff8800 - 0xa0000000),
                          progress: percent >= 1 ? 1 : percent / 100,
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            percent >= 1
                                ? "100"
                                : (Utility.getPercent(percent)),
                            style: TextStyle(
                                color: ThemeManager.getInstance().isDark()
                                    ? Color(folderModelWithExtraData
                                        .folderModel.color)
                                    : Color(0xffff8800),
                                fontSize: 6),
                          ))
                    ],
                  )),

            folderModelWithExtraData.isHover == false
                ? Wrap(
                    children: [
                      if (folderModelWithExtraData.folderModel.tag != 5)
                        getPreviewTimeString(folderModelWithExtraData).isEmpty
                            ? SizedBox.shrink()
                            : Container(
                                width: 60,
                                // color: Colors.red,
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: 8, vertical: 4),
                                // decoration: BoxDecoration(
                                //     color: Color(0xffffbd4a),
                                //     borderRadius: BorderRadius.only(
                                //         topLeft: Radius.circular(20),
                                //         topRight: Radius.circular(20),
                                //         bottomRight: Radius.circular(20),
                                //         bottomLeft: Radius.circular(2))),
                                child: Text(
                                    Utility.formatTimestampWithoutZeroHM(
                                        folderModelWithExtraData
                                                .folderTimeModel.previewTime ??
                                            0), //右侧分钟
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xffb9b9b9)))),
                      SizedBox(
                        width: itemPadding,
                      ),
                      getUnfinishMissionString(folderModelWithExtraData).isEmpty
                          ? SizedBox.shrink()
                          : Container(
                              child: Text(
                                  folderModelWithExtraData
                                              .folderModel.iconType ==
                                          5
                                      ? getUnfinishMissionString(
                                          folderModelWithExtraData)
                                      : getUnfinishMissionString(
                                          folderModelWithExtraData), //右侧分钟
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 13, color: Color(0xffb9b9b9))))
                    ],
                  )
                : SizedBox.shrink(),
            SizedBox(
              width: itemPadding,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Offstage(
                    offstage: folderModelWithExtraData.isHover == false,
                    child: InkWell(
                        child: PopupMenuButton<String>(
                      tooltip: '',
                      offset: Offset(-70, 10), //弹出的popup便宜位置
                      onSelected: (String val) {
                        Future.delayed((Duration(milliseconds: 10)), () {
                          if (val == 'edit') {
                            this
                                .widget
                                .onTapEditListener!(folderModelWithExtraData);
                          } else if (val == 'delete') {
                            this
                                .widget
                                .onTapDeleteListener!(folderModelWithExtraData);
                          } else if (val == 'share') {
                            this
                                .widget
                                .onTapShareListener!(folderModelWithExtraData);
                          } else if (val == 'archive') {
                            if (this.widget.onTapArchiveListener != null)
                              this
                                  .widget
                                  .onTapArchiveListener
                                  ?.call(folderModelWithExtraData); //侧边栏编辑
                          } else if (val == 'unarchive') {
                            if (this.widget.onTapArchiveListener != null)
                              this
                                  .widget
                                  .onTapArchiveListener
                                  ?.call(folderModelWithExtraData); //侧边栏编辑
                          }
                        });
                      },
                      itemBuilder: (context) {
                        if (folderModelWithExtraData.folderModel.tag == 1 &&
                            folderModelWithExtraData.folderModel.uid ==
                                LoginManager.getInstance().userBean.uid) {
                          return get3PopupList(folderModelWithExtraData);
                        } else {
                          return get2PopupList(folderModelWithExtraData);
                        }
                      },
                    ))),
                if (folderModelWithExtraData.folderModel.tag == 1 ||
                    folderModelWithExtraData.folderModel.tag == 2)
                  SizedBox(
                    width: itemPadding,
                  ),
                //最右侧的chart
                if (folderModelWithExtraData.folderModel.tag == 1 ||
                    folderModelWithExtraData.folderModel.tag == 2)
                  InkWell(
                    onTap: () {
                      this
                          .widget
                          .onTapShowFolderChartListener
                          ?.call(folderModelWithExtraData);
                    },
                    child:
                        Utility.getSVGPicture(R.assetsImgIcBarChart, size: 15),
                  ),
                // if (folderModelWithExtraData.folderModel.tag == 1 ||
                //     folderModelWithExtraData.folderModel.tag == 2)
                //   SizedBox(
                //     width: itemPadding,
                //   ),
                if (this.widget.folderPageViewEnum ==
                        FolderPageViewEnum.listing_unarchive ||
                    this.widget.folderPageViewEnum ==
                        FolderPageViewEnum.listing_archive)
                  SizedBox(
                    width: itemPadding,
                  ),
                if (this.widget.folderPageViewEnum ==
                        FolderPageViewEnum.listing_unarchive ||
                    this.widget.folderPageViewEnum ==
                        FolderPageViewEnum.listing_archive ||
                    (this.widget.folderPageViewEnum ==
                            FolderPageViewEnum.normal &&
                        (folderModelWithExtraData.folderModel.iconType == 14 ||
                            folderModelWithExtraData.folderModel.iconType ==
                                15))) // 苹果日历 14 苹果提醒 15
                  CustomMissionLayoutTypeWidget(
                    folderModel: folderModelWithExtraData.folderModel,
                  )
              ],
            ),
            // SizedBox(
            //   width: itemPadding,
            // ),
          ],
          crossAxisAlignment: WrapCrossAlignment.center,
        )
      ]);
    } else if (folderModelWithExtraData.folderModel.type == 3 &&
        screenType == ScreenType.Handset) {
      //创建清单 移动端
      children.addAll([getCreateWidget(folderModelWithExtraData)]);
    }
    //用于展示 不用于存储 2-今天 明天 即将到来等 3-创建清单
    if ((DeviceInfoManagement.isMoible() == true ||
            DeviceInfoManagement.isWebMobileBySize()) ||
        folderModelWithExtraData.folderModel.tag == null ||
        DeviceInfoManagement.isIOS()) {
      return Slidable(
        key: ValueKey(folderModelWithExtraData.folderModel),
        enabled: folderModelWithExtraData.folderModel.tag != null &&
            (folderModelWithExtraData.folderModel.tag == 1 ||
                folderModelWithExtraData.folderModel.tag == 2||
                folderModelWithExtraData.folderModel.tag == 5),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: ratio,
          children: getSlideActions(folderModelWithExtraData),
        ),
        child: getInnerItemWithoutContainer(folderModelWithExtraData, children),
      );
    } else {
      //PC
      return MouseRegion(
          onEnter: (_) {
            setState(() {
              folderModelWithExtraData.isHover = true;
            });
          },
          onHover: (_) {},
          onExit: (_) {
            setState(() {
              folderModelWithExtraData.isHover = false;
            });
          },
          child: getInnerItemWithoutContainer(
              folderModelWithExtraData, children, isItemHover));
    }
  }

  /**
   * 获取分享子标题
   * _folderModelWithExtraData: 文件夹数据
   */
  String getSharingSubtitle(
      FolderModelWithExtraData _folderModelWithExtraData) {
    return _folderModelWithExtraData.folderModel.isSharing == 1
        ? getI18NKey().sharing_listing
        : getI18NKey().sharing_listing;
  }

  /**
   * 获取滑动动作
   * _folderModelWithExtraData: 文件夹数据
   */
  List<Widget> getSlideActions(
      FolderModelWithExtraData _folderModelWithExtraData) {
    //只有自己可以对课程编辑删除
    // !TextUtil.isEmpty(_folderModelWithExtraData.folderModel.courseModelId) &&
    if (_folderModelWithExtraData.folderModel.tag == 1 &&
        _folderModelWithExtraData.folderModel.uid ==
            LoginManager.getInstance().userBean.uid) {
      return <Widget>[
        SlidableAction(
          onPressed: (context) {
            if (this.widget.onTapEditListener != null) {
              this
                  .widget
                  .onTapEditListener!(_folderModelWithExtraData); // 侧边栏编辑
            }
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: Icons.edit,
          label: getI18NKey().edit,
        ),
        if (_folderModelWithExtraData.folderModel.tag == 1)
          SlidableAction(
            onPressed: (context) {
              if (this.widget.onTapArchiveListener != null) {
                this
                    .widget
                    .onTapArchiveListener
                    ?.call(_folderModelWithExtraData); // 侧边栏编辑
              }
            },
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange,
            icon: Icons.archive, // 添加一个图标
            label: getI18NKey().archive,
            // iconWidget: Utility.getSVGPicture(R.assetsImgIcArchive, size: 20),  // 如果需要自定义图标，可以在此处设置
          ),
        SlidableAction(
          onPressed: (context) {
            if (this.widget.onTapShareListener != null) {
              this
                  .widget
                  .onTapShareListener!(_folderModelWithExtraData); // 侧边栏分享
            }
          },
          backgroundColor: Colors.lightGreenAccent,
          foregroundColor: Colors.white,
          icon: Icons.share,
          label: _folderModelWithExtraData.folderModel.isSharing != 0 &&
                  !TextUtil.isEmpty(
                      _folderModelWithExtraData.folderModel.courseModelId)
              ? getI18NKey().edit_sharing
              : getI18NKey().share,
        ),
        SlidableAction(
          onPressed: (context) {
            if (this.widget.onTapDeleteListener != null) {
              this
                  .widget
                  .onTapDeleteListener!(_folderModelWithExtraData); // 侧边栏删除
            }
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
            if (this.widget.onTapEditListener != null) {
              this
                  .widget
                  .onTapEditListener!(_folderModelWithExtraData); // 侧边栏编辑
            }
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: Icons.edit,
          label: getI18NKey().edit,
        ),
        if (_folderModelWithExtraData.folderModel.tag == 1)
          SlidableAction(
            onPressed: (context) {
              if (this.widget.onTapArchiveListener != null) {
                this
                    .widget
                    .onTapArchiveListener
                    ?.call(_folderModelWithExtraData); // 侧边栏编辑
              }
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.archive, // 自定义图标
            label: getI18NKey().unarchive,
          ),
        SlidableAction(
          onPressed: (context) {
            if (this.widget.onTapDeleteListener != null) {
              this
                  .widget
                  .onTapDeleteListener!(_folderModelWithExtraData); // 侧边栏删除
            }
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: getI18NKey().delete,
        ),
      ];
    }
  }

  /**
   * 获取段日期组件
   * folderModel: 文件夹数据
   */
  List<Widget> getSegmentdateWidget(FolderModel folderModel) {
    return [
      Text(
        CONSTANTS.getSegmentDateStringSubtitleByFolderModel(folderModel),
        style: TextStyle(fontSize: 12, color: ColorsConfig.darkRed),
      ),
    ];
  }

  /**
   * 获取2个popup列表
   * _folderModelWithExtraData: 文件夹数据
   */
  List<PopupMenuEntry<String>> get2PopupList(
      FolderModelWithExtraData _folderModelWithExtraData) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'edit',
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.edit, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().edit, style: TextStyle(fontSize: 15)),
          ],
        ),
      ),

      PopupMenuItem<String>(
        value: 'delete',
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.delete, size: fontSize, color: ColorsConfig.red),
            SizedBox(width: 5),
            Text(
              getI18NKey().delete,
              style: TextStyle(color: ColorsConfig.red, fontSize: 15),
            ),
          ],
        ),
      ),
      // PopupMenuItem<String>(
      //   value: 'delete',
      //   child: Text(
      //     getI18NKey().delete,
      //     style: TextStyle(color: ColorsConfig.red, fontSize: 15),
      //   ),
      // ),
    ];
  }

  double fontSize = 15;

  /**
   * 获取3个popup列表
   * folderModelWithExtraData: 文件夹数据
   */
  List<PopupMenuEntry<String>> get3PopupList(
      FolderModelWithExtraData folderModelWithExtraData) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'edit',
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.edit, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().edit, style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
      // if (folderModelWithExtraData.folderModel.tag == 1)
      PopupMenuItem<String>(
        value: 'archive',
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Utility.getSVGPicture(R.assetsImgIcArchive, size: fontSize),
            // Icon(Icons.archive, size: fontSize),
            SizedBox(width: 5),
            Text(
                (folderModelWithExtraData.folderModel.tag == 1 &&
                        (folderModelWithExtraData.folderModel.folderStatus ==
                                0 ||
                            folderModelWithExtraData.folderModel.folderStatus ==
                                null))
                    ? getI18NKey().archive
                    : getI18NKey().unarchive,
                style: TextStyle(fontSize: 15, color: Colors.blue)),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'share',
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.share, size: fontSize, color: Color(0xffff8800)),
            SizedBox(width: 5),
            Text(
                folderModelWithExtraData.folderModel.isSharing != 0 &&
                        !TextUtil.isEmpty(
                            folderModelWithExtraData.folderModel.courseModelId)
                    ? getI18NKey().edit_sharing
                    : getI18NKey().share,
                style: TextStyle(color: Color(0xffff8800), fontSize: 15)),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'delete',
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.delete, size: fontSize, color: ColorsConfig.red),
            SizedBox(width: 5),
            Text(
              getI18NKey().delete,
              style: TextStyle(color: ColorsConfig.red, fontSize: 15),
            ),
          ],
        ),
      ),
    ];
  }

  /**
   * 获取内部item
   * _folderModelWithExtraData: 文件夹数据
   * children: 子组件
   * isItemHover: 是否是item悬停
   */
  InkWell getInnerItemWithoutContainer(
      FolderModelWithExtraData _folderModelWithExtraData, List<Widget> children,
      [bool isItemHover = false]) {
    return InkWell(
        onTap: () {
          if (this.widget.onTapListener != null) {
            this.widget.curSelectedTitle =
                _folderModelWithExtraData.folderModel.title ?? "";
            this
                .widget
                .onTapListener!(_folderModelWithExtraData.folderModel); //点击item
          }
        },
        child: Container(
          constraints: BoxConstraints(minHeight: 46),
          decoration: (Utility.isHandsetBySize() == false &&
                  this.widget.curSelectedTitle ==
                      _folderModelWithExtraData.folderModel.title)
              ? BoxDecoration(
                  border: Border(
                      right: BorderSide(
                          width: 5,
                          color: ThemeManager.getInstance()
                              .getDefautThemeColor())))
              : BoxDecoration(
                  border: Border(
                      right: BorderSide(
                          width: Utility.isHandsetBySize() == false ? 5 : 0,
                          color: ThemeManager.getInstance().isDark()
                              ? Colors.transparent
                              : Colors.transparent))),
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
  Wrap getCreateWidget(FolderModelWithExtraData _folderModelWithExtraData) {
    return Wrap(
      children: [
        IconButton(
            icon: Utility.getSVGPicture(R.assetsImgIcTags, size: iconSize),
            onPressed: () {
              if (this.widget.onTapCreateTagListener != null) {
                this.widget.onTapCreateTagListener!(_folderModelWithExtraData);
              }
            }),
        // IconButton(
        //     icon: Icon(
        //       Icons.create_new_folder,
        //       color: ColorsConfig.create_folder,
        //       size: iconSize,
        //     ),
        //     onPressed: () {
        //       if (this.widget.onTapCreateTagListener != null) {
        //         this
        //             .widget
        //             .onTapCreateFolderListener!(_folderModelWithExtraData);
        //       }
        //     }),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

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
        String finishedTimeString = Utility.formatTimestampWithoutZero(
            folderModelWithExtraData.folderTimeModel.previewTime ??
                0 +
                    (folderModelWithExtraData.folderTimeModel.finishedTime ??
                        0));
        return finishedTimeString;
      case 12:
        return folderModelWithExtraData.folderTimeModel.previewTimeString;
      case 13:
        return folderModelWithExtraData.folderTimeModel.previewTimeString;
    }
    return '';
  }

  /**
   * 获取未完成任务字符串
   * folderModelWithExtraData: 文件夹数据
   */
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
        return ((folderModelWithExtraData.folderTimeModel.numMissionFinished ??
                    0) +
                (folderModelWithExtraData
                        .folderTimeModel?.numMissionToFinished ??
                    0))
            .toString();
      case 11:
        return folderModelWithExtraData.folderTimeModel.numMissionFinished
            .toString();
      case 12:
        return folderModelWithExtraData.folderTimeModel.numMissionToFinished
            .toString();
      case 13:
        return folderModelWithExtraData.folderTimeModel.numMissionToFinished
            .toString();
      case 14:
        return folderModelWithExtraData.folderTimeModel.numMissionToFinished
            .toString();
      case 15:
        return folderModelWithExtraData.folderTimeModel.numMissionToFinished
            .toString();
    }
    return '';
  }

  /**
   * 获取图标
   * _folderModel: 文件夹数据
   */
  Widget? getIcon(FolderModel _folderModel) {
    int iconType = _folderModel.iconType ?? 0;
    if (iconType != null) {
      switch (iconType) {
        case 0:
          if (_folderModel.tag == 4) {
            return Icon(Icons.filter_alt_outlined,
                color: Color(_folderModel?.color ?? Colors.red.value),
                size: iconSize);
          } else {
            return Icon(
                (_folderModel.tag == 0 ||
                        _folderModel.tag == false ||
                        _folderModel.tag == null)
                    ? Icons.calendar_today //今天
                    : (_folderModel.tag == 1 || _folderModel.tag == 5)
                        ? IconData(_folderModel.icon ?? 0,
                            fontFamily: 'MaterialIcons') //任务folder
                        : Icons.local_offer, //标签
                color: (_folderModel.tag == 0 ||
                        _folderModel.tag == false ||
                        _folderModel.tag == null)
                    ? Colors.pink //todo 这个是干啥 应该是默认颜色吧
                    : Color(_folderModel.color),
                size: iconSize); //颜色
            break;
          }
        case 1:
          return Utility.getSVGPicture(R.assetsImgIcToday, size: iconSize);
        // return Icon(Icons.wb_sunny, size: iconSize, color: Colors.green);
        // break;
        case 2:
          return Utility.getSVGPicture(R.assetsImgIcTomorrow, size: iconSize);
        // return Icon(Icons.brightness_6,
        //     size: iconSize, color: Colors.deepOrange);
        case 3:
          return Utility.getSVGPicture(R.assetsImgIcThisWeek, size: 16);
        // return Icon(Icons.system_update_alt,
        //     size: iconSize, color: Colors.blue);
        case 4:
          return Utility.getSVGPicture(R.assetsImgIcUnfinishMissions, size: 16);

        case 5:
          return Utility.getSVGPicture(R.assetsImgIcCalendar, size: 16);
        // return Icon(Icons.calendar_today,
        //     size: iconSize, color: ColorsConfig.calendar_green);
        case 6:
          return Utility.getSVGPicture(R.assetsImgIcFinished, size: 18);
        case 7:
          return Utility.getSVGPicture(R.assetsImgIcCreateFolder,
              size: 18,
              color: ThemeManager.getInstance().getDefautThemeColor());
        case 9:
          return Utility.getSVGPicture(R.assetsImgIcInstantly, size: 22);
        case 10:
          return Utility.getSVGPicture(R.assetsImgIcAllMission, size: 14);

        case 12:
          return Utility.getSVGPicture(R.assetsImgIcTodo, size: 16);
        case 13:
          return Utility.getSVGPicture(R.assetsImgIcFragment, size: 16);
        case 14:
          return CalendarIconWidget(
            width: 16,
            height: 18,
          );
        case 15:
          return Utility.getSVGPicture(R.assetsImgIcAppleAlarm, size: 16);
        case 16:
          return Utility.getSVGPicture(R.assetsImgIc7Week, size: 16);
        // return Icon(Icons.add,
        //     size: iconSize, color: ColorsConfig.create_folder);
        // break;
      }
    } else {}
  }
}
