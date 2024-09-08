import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/ListingSecurityWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/missionPage/componnents/MissionSilverList.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/com/timehello/util/WidgetManager.dart';
import 'package:time_hello/r.dart';

import '../../../common/database/apis/MongoApisManager.dart';
import '../../../components/MissionCountDownTextWidget.dart';
import '../../../components/SubmissionColumnList.dart';
import '../../../config/ENUMS.dart';
import '../../../util/DeviceInfoManagement.dart';

class GridMissionSilverList extends StatefulWidget {
  List? _datas = [];
  OnTapListener? onTapListener;
  MissionSilverState? menuSilverListState;
  OnTapEditTitleListener? onTapEditTitleListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapPlayListener? onTapPlayListener;
  OnTapMultiSelectListener? onTapMultiSelectListener;
  OnTapUnFinishListener? onTapUnFinishListener;
  Function? onTapDoItNow;
  bool? isSlideEnable;
  MultiSelectModeEnum multiSelectModeEnum;

  GridMissionSilverList(
      {Key? key,
      List? datas,
      OnTapListener? onTapListener,
      this.multiSelectModeEnum = MultiSelectModeEnum.normal,
      this.onTapMultiSelectListener,
      this.onTapFinishListener,
      this.onTapDoItNow,
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

class MissionSilverState extends State<GridMissionSilverList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return GridMissionSilverListItem(
          multiSelectModeEnum: this.widget.multiSelectModeEnum,
          isSlideEnable: this.widget.isSlideEnable ?? false,
          onTapListener: this.widget.onTapListener,
          index: index,
          missionModel: this.widget._datas?[index],
          onTapDoItNow: this.widget.onTapDoItNow,
          onTapUnFinishListener: this.widget.onTapUnFinishListener,
          onTapEditTitleListener: this.widget.onTapEditTitleListener,
          onTapEditListener: this.widget.onTapEditListener,
          onTapDeleteListener: this.widget.onTapDeleteListener,
          onTapFinishListener: this.widget.onTapFinishListener,
          onTapMultiSelectListener: this.widget.onTapMultiSelectListener,
          onTapPlayListener: this.widget.onTapPlayListener,
        );
      }, childCount: this.widget._datas?.length ?? 0),
    );
  }
}

class GridMissionSilverListItem extends StatefulWidget {
  OnTapListener? onTapListener;
  OnTapPlayListener? onTapPlayListener;
  int index = 0;
  bool isVisible = false;
  bool isSlideEnable = true;
  MissionModel? _missionModel;
  OnTapFinishListener? onTapFinishListener;
  Function? onTapDoItNow;
  OnTapMultiSelectListener? onTapMultiSelectListener;
  OnTapUnFinishListener? onTapUnFinishListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapEditTitleListener? onTapEditTitleListener;
  MultiSelectModeEnum multiSelectModeEnum;

  // Map<int, Image> map = {};
  GridMissionSilverListItem(
      {Key? key,
      bool isVisible = true,
      OnTapListener? onTapListener,
      MissionModel? missionModel,
      int index = 0,
      required this.multiSelectModeEnum,
      this.onTapMultiSelectListener,
      this.onTapEditTitleListener,
      this.onTapDoItNow,
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
    return GridMissionSilverListItemState();
  }
}

class GridMissionSilverListItemState extends State<GridMissionSilverListItem> {
  bool isHover = false;
  double height = 125;
  ImageProvider? imageProvider;

  FolderModel? getFolderModel(MissionModel? missionModel) {
    if (!TextUtil.isEmpty(this.widget._missionModel?.folder_id)) {
      List<FolderModel> wqbFolderModelList = MongoApisManager.getInstance()
          .queryWhereEqual_folderModelWithFolderId(
              this.widget._missionModel?.folder_id);
      if (wqbFolderModelList.length > 0) {
        return wqbFolderModelList[0];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // print("grid mission silver list");
    MissionModel? _missionModel = this.widget._missionModel;
    // FolderModel? folderModel = getFolderModel(_missionModel);
    bool isDoItNow = this.isDoItNow(_missionModel);
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
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          InkWell(
              onTap: () {
                this.widget.onTapPlayListener!(_missionModel);
              },
              child: Icon(
                Icons.play_circle_outline,
                color: Color(0xfffd5553),
                size: 16,
              )),
          ListingSecurityWidget(
            missionModdel_id: _missionModel?.objectId,
            folder_id: _missionModel?.folder_id ?? "",
            cryptoVersion: _missionModel?.cryptoVersion ?? -1,
            marginLeft: 5,
            size: 14,
          )
        ],
      ),
      SizedBox(
        width: 5,
      ),
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(TextSpan(
                    // text: 'Hello', // default text style
                    children: [
                      TextSpan(
                          text: this.widget._missionModel?.title ?? "",
                          style: ThemeManager.getInstance().getTextStyle(
                              defaultTextStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  decoration: _missionModel?.isFinished == true
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationColor: Color(0xffa0a0a0),
                                  decorationThickness: 2,
                                  color: ColorsConfig.gray_40))),
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              if ((_missionModel?.subMissions?.length ?? 0) >
                                  0) ...[
                                Utility.getSVGPicture(R.assetsImgIcSubmission,
                                    size: 14),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  _missionModel?.subMissions?.length
                                          .toString() ??
                                      "0",
                                  textAlign: TextAlign.left,
                                  style: ThemeManager.getInstance()
                                      .getTextStyle(
                                          defaultTextStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Color(0xff9DA7B2))),
                                ),
                              ],
                            ],
                          )),
                      ...WidgetManager.getTagsWidgetSpan(
                          _missionModel ?? MissionModel(),
                          fontSize: 12),
                      ...WidgetManager.getIsNoteWidget(
                        _missionModel ?? MissionModel(),
                      ),
                    ])),
                if ((_missionModel?.subMissions?.length ?? 0) > 0)
                  SubmissionColumnList(
                    missionModel: _missionModel ?? MissionModel(),
                  ),

              ]),
          flex: 3),
      // Spacer(),
      Container(
          margin: EdgeInsets.fromLTRB(
              0, 0, (this.isHover == false && isDoItNow) ? 3 : 4, 0),
          alignment: Alignment.centerRight,
          width: (this.isHover == false && isDoItNow) ? 120 : 25,
          height: 25,
          child: (this.isHover == true)
              ? PopupMenuButton<String>(
                  tooltip: '',
                  iconSize: 14,
                  icon: Icon(
                    Icons.more_vert,
                    color: ThemeManager.getInstance()
                        .getIconColor(defaultColor: Colors.black87),
                  ),
                  onCanceled: () {},
                  itemBuilder: (context) {
                    // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
                    if (_missionModel?.isFinished == false) {
                      return getUnfinishedPopupList(
                          _missionModel ?? MissionModel());
                    } else {
                      return getFinishedPopupList(
                          _missionModel ?? MissionModel());
                    }
                  },
                )
              : isDoItNow
                  ? MissionCountDownTextWidget(
                      fontSize: 12,
                      color: 0xff909090,
                      end_time: _missionModel?.do_it_now?[0]['end_time'] as int,
                      end_buffer_time: _missionModel?.do_it_now?[0]
                          ['buffer_end_time'],
                      isFinished: _missionModel?.isFinished ?? false,
                    )
                  : CheckImage(
                      width: 25,
                      height: 25,
                      isSizeConfigured: true,
                      onTapListener: (res) {
                        if (_missionModel?.isFinished == true) {
                          if (this.widget.onTapUnFinishListener != null)
                            this
                                .widget
                                .onTapUnFinishListener
                                ?.call(_missionModel);
                        } else {
                          if (this.widget.onTapFinishListener != null)
                            this.widget.onTapFinishListener!(_missionModel);
                        }
                      },
                      checked: _missionModel?.isFinished ?? false,
                      checkIcon: Icon(Icons.check_circle,
                          size: 20, color: ColorsConfig.calendar_green),
                      uncheckIcon: Icon(Icons.radio_button_unchecked_outlined,
                          color: ColorsConfig.gray_a7, size: 20),
                    )),
    ];
    return Slidable(
      key: ValueKey(_missionModel),
      enabled: DeviceInfoManagement.isMoible() == true ||
          DeviceInfoManagement.isWebMobileBySize(),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.15,
        children: _missionModel?.isFinished == false
            ? getUnfinishIconSlideActions(_missionModel ?? MissionModel())
            : getFinishIconSlideActions(_missionModel ?? MissionModel()),
      ),
      child: InkWell(
        onTap: () {
          if (this.widget.multiSelectModeEnum == MultiSelectModeEnum.multiSelect) {
            if (this.widget.onTapMultiSelectListener != null) {
              _missionModel?.isSelected =
              _missionModel.isSelected ? false : true;
              this.widget.onTapMultiSelectListener?.call(_missionModel);
              setState(() {});
            }
          } else {
            if (this.widget.onTapListener != null) {
              this.widget.onTapListener!(_missionModel);
            }
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
                left: CONSTANTS.missionPageMargin + 4,
                right: CONSTANTS.missionPageMargin + 4),
            decoration: BoxDecoration(
              border: this.widget.multiSelectModeEnum == MultiSelectModeEnum.normal
                  ? Border.all(
                  width: 1.0,
                  color: ThemeManager.getInstance().isDark()
                      ? Color(CONSTANTS.getPriorityColor(
                      _missionModel?.priorityStatus ?? 3))
                      : Color(0xfff0f0f0))
                  : Border.all(
                  width: 2.0,
                  color: Color((CONSTANTS.getPriorityColor(
                      _missionModel?.priorityStatus ?? 3) -
                      (this.widget._missionModel?.isSelected == true
                          ? 0x00000000
                          : 0xe0000000)))),
              image: imageProvider == null
                  ? null
                  : ThemeManager.getInstance().isDark()
                  ? DecorationImage(
                  image: imageProvider!,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      ThemeManager.getInstance().isDark()
                          ? ThemeManager.getInstance()
                          .getCardBackgroundColor(alpha: 150)
                          : Colors.white,
                      BlendMode.colorBurn))
                  : DecorationImage(
                  image: imageProvider!,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white, BlendMode.colorBurn)),
              color: ThemeManager.getInstance().isDark()
                  ? ThemeManager.getInstance()
                  .getCardBackgroundColor(alpha: 150)
                  : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Stack(
              children: [
                TextUtil.isEmpty(_missionModel?.background_url ?? "")
                    ? SizedBox.shrink()
                    : CachedNetworkImage(
                    imageUrl: Utility.filterHttpUrl(
                        _missionModel?.background_url ?? '',
                        prefix: "oss"),
                    imageBuilder: (context, imageProviderTmp) {
                      Future.delayed(Duration(seconds: 0), () {
                        imageProvider = imageProviderTmp;
                        if (mounted) {
                          // setState(() {});
                        }
                      });
                      return Container();
                    }),
                Container(
                  color: ThemeManager.getInstance()
                      .getCardBackgroundColor(defaultColor: Color(0xb0ffffff), alpha: 150),
                  constraints: BoxConstraints(minHeight: 30),
                  padding: EdgeInsets.only(top: 0, bottom: 0),
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

  bool isDoItNow(MissionModel? _missionModel) =>
      (_missionModel != null && Utility.isDoingItNow(_missionModel));
  double fontSize = Utility.isHandsetBySize() ? 11 : 15;

  List<Widget> getFinishIconSlideActions(MissionModel _missionModel) {
    return <Widget>[
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapUnFinishListener != null) {
            this.widget.onTapUnFinishListener!(_missionModel);
          }
        },
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        icon: Icons.check,
        label: getI18NKey().unfinished,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapMultiSelectListener != null) {
            this.widget.onTapMultiSelectListener!(null);
          }
        },
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        icon: Icons.select_all,
        label: getI18NKey().multi_select,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapDeleteListener != null) {
            this.widget.onTapDeleteListener!(_missionModel);
          }
        },
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: getI18NKey().delete,
      ),
    ];
  }

  List<Widget> getUnfinishIconSlideActions(MissionModel _missionModel) {
    return <Widget>[
      SlidableAction(
        onPressed: (context) {
          this.widget.onTapPlayListener!(_missionModel);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.play_arrow,
        label: getI18NKey().play,
      ),
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
          if (this.widget.onTapMultiSelectListener != null)
            this.widget.onTapMultiSelectListener!(null);
        },
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        icon: Icons.select_all,
        label: getI18NKey().multi_select,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapDeleteListener != null)
            this.widget.onTapDeleteListener!(_missionModel);
        },
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: getI18NKey().delete,
      ),
    ];
  }

  List<PopupMenuEntry<String>> getUnfinishedPopupList(
      MissionModel _missionModel) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'start_focus',
        onTap: () {
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapPlayListener!(_missionModel);
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Utility.getSVGPicture(R.assetsImgIcFocusTarget, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().start_focus,
                style: TextStyle(fontSize: 15, color: Colors.red)),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'complete',
        onTap: () {
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapFinishListener!(_missionModel);
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.check, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().finish, style: TextStyle(fontSize: 15))
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'doItNow',
        onTap: () {
          Future.delayed(Duration(milliseconds: 100), () {
            //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
            this.widget.onTapDoItNow!(_missionModel);
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Utility.getSVGPicture(R.assetsImgIcInstantly, size: fontSize),
            // Icon(Icons.check, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().do_it_now,
                style: TextStyle(fontSize: 15, color: Color(0xffff8800)))
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'edit',
        onTap: () {
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapEditListener!(_missionModel);
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.edit, color: Colors.green, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().edit,
                style: TextStyle(color: Colors.green, fontSize: 15))
          ],
        ),
      ),
      PopupMenuItem<String>(
          value: 'multi_select',
          onTap: () {
            this.widget.onTapMultiSelectListener?.call(null);
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.select_all, color: Colors.blue, size: fontSize),
              SizedBox(width: 5),
              Text(getI18NKey().multi_select,
                  style: TextStyle(color: Colors.blue, fontSize: 15)),
            ],
          )),
      PopupMenuItem<String>(
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          value: 'delete',
          onTap: () {
            Future.delayed(Duration(milliseconds: 100), () {
              this.widget.onTapDeleteListener!(_missionModel);
            });
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.delete, color: Colors.grey, size: fontSize),
              SizedBox(width: 5),
              Text(
                getI18NKey().delete,
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          )),
    ];
  }

  List<PopupMenuEntry<String>> getFinishedPopupList(
      MissionModel _missionModel) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
        value: 'unfinished',
        onTap: () {
          if (this.widget.onTapUnFinishListener != null)
            this.widget.onTapUnFinishListener?.call(_missionModel);
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.check, color: Colors.green, size: fontSize),
            Text(
              getI18NKey().unfinished,
              style: TextStyle(color: Colors.green, fontSize: 15),
            ),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'multi_select',
        onTap: () {
          this.widget.onTapMultiSelectListener?.call(null);
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          // Future.delayed(Duration(milliseconds: 100), () {
          //   this.widget.onTapEditListener!(_missionModel);
          // });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.select_all, color: Colors.blue, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().multi_select,
                style: TextStyle(color: Colors.blue, fontSize: 15)),
          ],
        ),
      ),
      PopupMenuItem<String>(
        //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
        value: 'delete',
        onTap: () {
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapDeleteListener!(_missionModel);
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.grey, size: fontSize),
            SizedBox(width: 5),
            Text(
              getI18NKey().delete,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      ),
    ];
  }
}
