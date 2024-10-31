import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/action_pane_motions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/actions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/slidable.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../../../common/provider/Env.dart';
import '../../../models/WQBFolderModel.dart';
import '../../../models/WQBMissionModel.dart';
import '../../../util/DeviceInfoManagement.dart';
import '../../../util/WidgetManager.dart';

typedef OnTapFinishListener = void Function(dynamic obj);
typedef OnTapEditListener = void Function(dynamic obj);
typedef OnTapEditTitleListener = void Function(dynamic obj);
typedef OnTapDeleteListener = void Function(dynamic obj);
typedef OnTapPlayListener = void Function(dynamic obj);
typedef OnTapUnFinishListener = void Function(dynamic obj);

class WQBMissionSilverList extends StatefulWidget {
  List? _datas = [];
  OnTapListener? onTapListener;
  MissionSilverState? menuSilverListState;
  OnTapEditTitleListener? onTapEditTitleListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapPlayListener? onTapPlayListener;
  OnTapUnFinishListener? onTapUnFinishListener;
  bool? isSlideEnable;
  WQBMissionModel wqbMissionModel;

  WQBMissionSilverList(
      {Key? key,
      List? datas,
      OnTapListener? onTapListener,
      required this.wqbMissionModel,
      this.onTapFinishListener,
      this.onTapUnFinishListener,
      this.onTapDeleteListener,
      this.onTapEditListener,
      this.onTapEditTitleListener,
      this.onTapPlayListener,
      this.isSlideEnable = true})
      : super(key: key) {
    this.onTapListener = onTapListener;
    this._datas = datas;
  }

  set datas(List datas) {
    _datas = datas;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return menuSilverListState = new MissionSilverState();
  }
}

class MissionSilverState extends State<WQBMissionSilverList> {
  @override
  Widget build(BuildContext context) {
    return Selector<Env, Map?>(
        selector: (_, env) => env.wqbRouterMissionDetailData,
        builder: (_, wqbRouterMissionDetailData, __) {
          // String? page = wqbRouterMissionDetailData?['page'];
          WQBMissionModel missionData =
              wqbRouterMissionDetailData?['data'] ?? WQBMissionModel();
          // WQBFolderModel folderData = wqbRouterMissionDetailData?['folderdata'] ?? WQBFolderModel();
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return WQBMissionSilverListItem(
                curMissionModel: missionData,
                isSlideEnable: this.widget.isSlideEnable ?? false,
                onTapListener: this.widget.onTapListener,
                index: index,
                missionModel: this.widget._datas?[index],
                onTapUnFinishListener: this.widget.onTapUnFinishListener,
                onTapEditTitleListener: this.widget.onTapEditTitleListener,
                onTapEditListener: this.widget.onTapEditListener,
                onTapDeleteListener: this.widget.onTapDeleteListener,
                onTapFinishListener: this.widget.onTapFinishListener,
                onTapPlayListener: this.widget.onTapPlayListener,
              );
            }, childCount: this.widget._datas?.length ?? 0),
          );
        });
  }
}

class WQBMissionSilverListItem extends StatefulWidget {
  OnTapListener? onTapListener;
  OnTapPlayListener? onTapPlayListener;
  int index = 0;
  bool isVisible = false;
  bool isSlideEnable = true;
  WQBMissionModel? _missionModel;
  OnTapFinishListener? onTapFinishListener;
  OnTapUnFinishListener? onTapUnFinishListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapEditTitleListener? onTapEditTitleListener;
  WQBMissionModel curMissionModel;

  // Map<int, Image> map = {};
  WQBMissionSilverListItem(
      {Key? key,
      bool isVisible = true,
      OnTapListener? onTapListener,
      WQBMissionModel? missionModel,
      int index = 0,
      required this.curMissionModel,
      this.onTapEditTitleListener,
      this.onTapPlayListener,
      this.onTapUnFinishListener,
      this.onTapFinishListener,
      this.onTapDeleteListener,
      this.onTapEditListener,
      this.isSlideEnable = false})
      : super(key: key) {
    this.onTapListener = onTapListener;
    this.index = index;
    this.isVisible = isVisible;
    this._missionModel = missionModel;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw MenuSilverListItem(onTapListener);
    return WQBMissionSilverListItemState();
  }
}

class WQBMissionSilverListItemState extends State<WQBMissionSilverListItem> {
  bool isHover = false;
  double height = 125;
  ImageProvider? imageProvider;
  double ratio = Utility.getRatioForSlider(
    numItem: 5,
  );
  /**
   * 标签的widget
   */
  List<Widget> getTagsTextView(WQBMissionModel missionModel) {
    List<WQBFolderModel> list = CONSTANTS
        .getWQBFolderModelListFromStringList(missionModel?.tagNames ?? []);
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      WQBFolderModel folderModel = list[i];
      listWidget.add(SizedBox(
        width: 5,
      ));
      listWidget.add(Text("#" + (folderModel.title ?? ""),
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Color(folderModel.color))));
    }
    return listWidget;
  }

  WQBFolderModel? getWQBFolderModel(WQBMissionModel? missionModel) {
    if (!TextUtil.isEmpty(this.widget._missionModel?.folder_id)) {
      List<WQBFolderModel> wqbFolderModelList = MongoApisManager.getInstance()
          .queryWhereEqual_WQBFolderModelWithFolderId(
              this.widget._missionModel?.folder_id);
      if (wqbFolderModelList.length > 0) {
        return wqbFolderModelList[0];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    WQBMissionModel? _missionModel = this.widget._missionModel;
    WQBFolderModel? folderModel = getWQBFolderModel(_missionModel);
    // TODO: implement build
    //左边文案和角标
    List<Widget> childrenRow = <Widget>[
      Container(
          height: 30,
          width: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(
                CONSTANTS.getPriorityColor(_missionModel?.priorityStatus ?? 3)),
          )),
      SizedBox(
        width: 5,
      ),
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(this.widget._missionModel?.title ?? "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            decoration: _missionModel?.isFinished == true
                                ? TextDecoration.lineThrough
                                : null,
                            decorationStyle: TextDecorationStyle.solid,
                            decorationColor: Color(0xffa0a0a0),
                            decorationThickness: 2,
                            color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.gray_40))),
                    SizedBox(
                      width: 3,
                    ),
                    GestureDetector(
                      child: Icon(Icons.edit, size: 14),
                      onTap: () {
                        if (this.widget.onTapEditTitleListener != null)
                          this.widget.onTapEditTitleListener!(_missionModel);
                      },
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    ...getTagsTextView(_missionModel ?? WQBMissionModel()),
                  ],
                ),
                SizedBox(
                  height: 1,
                ),
                Row(
                  children: [
                    folderModel == null
                        ? SizedBox.shrink()
                        : (WidgetManager.getWQBFolderModelIcon(
                                folderModel!, 12) ??
                            SizedBox.shrink()),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      folderModel?.title ?? "",
                      style: TextStyle(fontSize: 10, color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff666666))),
                    ),
                  ],
                )
              ]),
          flex: 3),
      // 完成不需要显示
      // _missionModel?.isFinished == true
      //     ? SizedBox.shrink()
      //     : Padding(
      //         padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      //         child: IconButton(
      //             onPressed: () {
      //               if (this.widget.onTapPlayListener != null) {
      //                 this.widget.onTapPlayListener!(_missionModel);
      //               }
      //             },
      //             icon: Icon(
      //               Icons.play_circle_outline,
      //               color: Color(0xfffd5553),
      //             ))),
      DeviceInfoManagement.isMoible() == false
          ? SizedBox(
              width: 15,
            )
          : SizedBox(
              width: 0,
            )
    ];
    return Slidable(
      key: ValueKey(_missionModel),
      enabled: DeviceInfoManagement.isMoible() == true ||
          DeviceInfoManagement.isWebMobileBySize(),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: ratio,
        children: _missionModel?.isFinished == false
            ? getUnfinishIconSlideActions(_missionModel ?? WQBMissionModel())
            : getFinishIconSlideActions(_missionModel ?? WQBMissionModel()),
      ),
      child: InkWell(
        onTap: () {
          if (this.widget.onTapListener != null) {
            this.widget.onTapListener!(_missionModel);
          }
        },
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              this.isHover = true;
            });
          },
          onHover: (_) {},
          onExit: (_) {
            setState(() {
              this.isHover = false;
            });
          },
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.only(
              bottom: 2,
              left: CONSTANTS.missionPageMargin,
              right: CONSTANTS.missionPageMargin,
            ),
            //背景
            decoration: BoxDecoration(
              color: ThemeManager.getInstance().getCardBackgroundColor(
                defaultColor: _missionModel?.type == 1
                    ? Color(
                    _missionModel?.color ??
                        CONSTANTS.getColors()[0].color - 0x30000000)
                    : Colors.white,
              ),
              border: Border.all(
                width: 3.0,
                color: Color(
                  this.widget.curMissionModel?.objectId == _missionModel?.objectId
                      ? (CONSTANTS.getPriorityColor(
                      _missionModel?.priorityStatus ?? 3) -
                      0xa0000000)
                      : 0x00000000,
                ),
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Stack(
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: 54),
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: childrenRow,
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: (this.isHover)
                            ? Container(
                          width: 30,
                          height: 30,
                          child: PopupMenuButton<String>(
                            tooltip: '',
                            padding: EdgeInsets.only(right: 5),
                            iconSize: 14,
                            icon: Icon(
                              Icons.more_vert,
                              color: ThemeManager.getInstance().getTextColor(
                                defaultColor: Colors.black87,
                              ),
                            ),
                            onCanceled: () {},
                            itemBuilder: (context) {
                              if (_missionModel?.isFinished == false) {
                                return getUnfinishedPopupList(
                                    _missionModel ?? WQBMissionModel());
                              } else {
                                return getFinishedPopupList(
                                    _missionModel ?? WQBMissionModel());
                              }
                            },
                          ),
                        )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      this.widget._missionModel?.type == 1 &&
                          TextUtil.isEmpty(
                              this.widget._missionModel?.order_index) ==
                              false
                          ? Text(
                        getI18NKey().desktop_widget_with_note_n(
                            this.widget._missionModel?.order_index ?? ""),
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeManager.getInstance().getTextColor(
                            defaultColor: Color(0xff909090),
                          ),
                        ),
                      )
                          : SizedBox.shrink(),
                      this.widget._missionModel?.type == 1 &&
                          TextUtil.isEmpty(
                              this.widget._missionModel?.order_index) ==
                              false
                          ? Container(
                        width: 1,
                        height: 10,
                        color: ThemeManager.getInstance().getTextColor(
                          defaultColor: Color(0xff909090),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                      )
                          : SizedBox.shrink(),
                      Text(
                        CONSTANTS.getWQBStringType(
                            this.widget._missionModel?.type ?? -1),
                        style: TextStyle(
                          color: ThemeManager.getInstance().getTextColor(
                            defaultColor: Color(0xff999999),
                          ),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getFinishIconSlideActions(WQBMissionModel _missionModel) {
    return <Widget>[
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapDeleteListener != null)
            this.widget.onTapDeleteListener!(_missionModel);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: getI18NKey().delete,
      ),
    ];
  }

  List<Widget> getUnfinishIconSlideActions(WQBMissionModel _missionModel) {
    return <Widget>[
      SlidableAction(
        onPressed: (context) {
          if (_missionModel.isFinished == false) {
            if (this.widget.onTapFinishListener != null)
              this.widget.onTapFinishListener!(_missionModel);
          } else {
            if (this.widget.onTapUnFinishListener != null)
              this.widget.onTapUnFinishListener!(_missionModel);
          }
        },
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        icon: Icons.check,
        label: getI18NKey().finish,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapEditListener != null)
            this.widget.onTapEditListener!(_missionModel);
        },
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        icon: Icons.edit,
        label: getI18NKey().edit,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapDeleteListener != null)
            this.widget.onTapDeleteListener!(_missionModel);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: getI18NKey().delete,
      ),
    ];
  }

  List<PopupMenuEntry<String>> getUnfinishedPopupList(
      WQBMissionModel _missionModel) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'complete',
        onTap: () {
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapFinishListener!(_missionModel);
          });
        },
        child: Text(getI18NKey().finish, style: TextStyle(fontSize: 15)),
      ),
      PopupMenuItem<String>(
        value: 'edit',
        onTap: () {
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapEditListener!(_missionModel);
          });
        },
        child: Text(getI18NKey().edit,
            style: TextStyle(color: Colors.green, fontSize: 15)),
      ),
      PopupMenuItem<String>(
        //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
        value: 'delete',
        onTap: () {
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapDeleteListener!(_missionModel);
          });
        },
        child: Text(
          getI18NKey().delete,
          style: TextStyle(color: ColorsConfig.red, fontSize: 15),
        ),
      ),
    ];
  }

  List<PopupMenuEntry<String>> getFinishedPopupList(
      WQBMissionModel _missionModel) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
        value: 'delete',
        onTap: () {
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapDeleteListener!(_missionModel);
          });
        },
        child: Text(
          getI18NKey().delete,
          style: TextStyle(color: ColorsConfig.red, fontSize: 15),
        ),
      ),
    ];
  }
}
