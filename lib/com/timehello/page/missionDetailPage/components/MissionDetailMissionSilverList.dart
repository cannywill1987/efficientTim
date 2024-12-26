import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/RatingBar.dart';
import 'package:time_hello/com/timehello/components/StateImage.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../../../common/database/apis/MongoApisManager.dart';
import '../../../components/MissionCountDownTextWidget.dart';
import '../../../components/SubmissionColumnList.dart';
import '../../../config/ENUMS.dart';
import '../../../util/DeviceInfoManagement.dart';
import '../../../util/WidgetManager.dart';

typedef OnTapFinishListener = void Function(dynamic obj);
typedef OnTapPlayListener = void Function(dynamic obj);
typedef OnTapUnFinishListener = void Function(dynamic obj);

class MissionDetailMissionSilverList extends StatefulWidget {
  List? _datas = [];
  OnTapListener? onTapListener;
  MissionSilverState? menuSilverListState;
  OnTapFinishListener? onTapFinishListener;
  OnTapPlayListener? onTapPlayListener;
  OnTapUnFinishListener? onTapUnFinishListener;
  bool? isSlideEnable;
  MultiSelectModeEnum multiSelectModeEnum;

  MissionDetailMissionSilverList(
      {Key? key,
      List? datas,
      OnTapListener? onTapListener,
      this.multiSelectModeEnum = MultiSelectModeEnum.normal,
      this.onTapFinishListener,
      this.onTapUnFinishListener,
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

class MissionSilverState extends State<MissionDetailMissionSilverList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return MissionDetailMissionSilverListItem(
          multiSelectModeEnum: this.widget.multiSelectModeEnum,
          isSlideEnable: this.widget.isSlideEnable ?? false,
          onTapListener: this.widget.onTapListener,
          index: index,
          missionModel: this.widget._datas?[index],
          onTapUnFinishListener: this.widget.onTapUnFinishListener,
          onTapFinishListener: this.widget.onTapFinishListener,
          onTapPlayListener: this.widget.onTapPlayListener,
        );
      }, childCount: this.widget._datas?.length ?? 0),
    );
  }
}

class MissionDetailMissionSilverListItem extends StatefulWidget {
  OnTapListener? onTapListener;
  OnTapPlayListener? onTapPlayListener;
  int index = 0;
  bool isVisible = false;
  bool isSlideEnable = true;
  MissionModel? _missionModel;
  OnTapFinishListener? onTapFinishListener;
  Function? onTapDoItNow;
  OnTapUnFinishListener? onTapUnFinishListener;
  MultiSelectModeEnum multiSelectModeEnum;

  // Map<int, Image> map = {};
  MissionDetailMissionSilverListItem(
      {Key? key,
      bool isVisible = true,
      OnTapListener? onTapListener,
      MissionModel? missionModel,
      int index = 0,
      required this.multiSelectModeEnum,
      this.onTapDoItNow,
      this.onTapPlayListener,
      this.onTapUnFinishListener,
      this.onTapFinishListener,
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
    return MissionDetailMissionSilverListItemState();
  }
}

class MissionDetailMissionSilverListItemState
    extends State<MissionDetailMissionSilverListItem> {
  bool isHover = false;
  double height = 125;
  ImageProvider? imageProvider;
  double fontSize = Utility.isHandsetBySize() ? 11 : 12;
  double space = 15;

  // double fontSize = 12;
  /**
   * 标签的widget
   */
  List<Widget> getTagsTextView(MissionModel missionModel) {
    List<FolderModel> list = CONSTANTS
        .getFolderModelListFromStringList(missionModel.tagNames?.split(','));
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      FolderModel folderModel = list[i];
      listWidget.add(SizedBox(
        width: 5,
      ));
      listWidget.add(Text("#" + (folderModel.title ?? ""),
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Color(folderModel.color))));
    }
    return listWidget;
  }

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

  bool isDoItNow(MissionModel? _missionModel) =>
      (_missionModel != null && Utility.isDoingItNow(_missionModel));

  @override
  Widget build(BuildContext context) {
    MissionModel? _missionModel = this.widget._missionModel;
    FolderModel? folderModel = getFolderModel(_missionModel);
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
      Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: CheckImage(
            width: 18,
            height: 18,
            isSizeConfigured: true,
            onTapListener: (res) {
              if (_missionModel?.isFinished == true) {
                if (this.widget.onTapUnFinishListener != null)
                  this.widget.onTapUnFinishListener?.call(_missionModel);
              } else {
                if (this.widget.onTapFinishListener != null)
                  this.widget.onTapFinishListener!(_missionModel);
              }
            },
            checked: _missionModel?.isFinished ?? false,
            checkIcon: Icon(Icons.check_circle,
                size: 20, color: ColorsConfig.calendar_green),
            uncheckIcon: Icon(Icons.radio_button_unchecked_outlined,
                color: ColorsConfig.gray_a7, size: 18),
          )),
      SizedBox(
        width: 3,
      ),
      // 完成不需要显示
      _missionModel?.isFinished == true
          ? SizedBox.shrink()
          : Container(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: InkWell(
                      onTap: () {
                        if (this.widget.onTapPlayListener != null) {
                          this.widget.onTapPlayListener!(_missionModel);
                        }
                      },
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Color(0xfffd5553),
                        size: 18,
                      ))),
            ),
      SizedBox(
        width: 3,
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
                            fontSize: 12,
                            decoration: _missionModel?.isFinished == true
                                ? TextDecoration.lineThrough
                                : null,
                            decorationStyle: TextDecorationStyle.solid,
                            decorationColor: ThemeManager.getInstance()
                                .getTextColor(defaultColor: Color(0xffa0a0a0)),
                            decorationThickness: 2,
                            color: ThemeManager.getInstance().getTextColor(
                                defaultColor: ColorsConfig.gray_40))),
                    SizedBox(
                      width: 8,
                    ),
                    if ((_missionModel?.subMissions?.length ?? 0) > 0)
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Utility.getSVGPicture(R.assetsImgIcSubmission,
                              size: 11),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            _missionModel?.subMissions?.length.toString() ??
                                "0",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                                color: ThemeManager.getInstance().getTextColor(
                                    defaultColor: Color(0xff9DA7B2))),
                          ),
                        ],
                      ),

                    // GestureDetector(
                    //   child: Icon(Icons.edit, size: 14),
                    //   onTap: () {
                    //     if (this.widget.onTapEditTitleListener != null)
                    //       this.widget.onTapEditTitleListener!(_missionModel);
                    //   },
                    // ),

                    ...getTagsTextView(_missionModel ?? MissionModel()),
                  ],
                ),
                if ((_missionModel?.subMissions?.length ?? 0) > 0)
                  SubmissionColumnList(
                    missionModel: _missionModel ?? MissionModel(),
                  ),
                if ((_missionModel?.subMissions?.length ?? 0) > 0)
                  SizedBox(
                    height: 3,
                  ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if(Utility.shouldShowTomatoes(missionModelType: _missionModel?.missionModelType))
                    RatingBar(
                      size: this.fontSize,
                      curNumber: _missionModel?.no_tomotoes_finished ?? 0,
                      number: _missionModel?.total_tomotoes ?? 0,
                    ),
                    if(Utility.shouldShowTomatoes(missionModelType: _missionModel?.missionModelType))
                    SizedBox(
                      width: this.space,
                    ),
                    Icon(
                      Icons.calendar_today_rounded,
                      color: ColorsConfig.darkRed,
                      size: this.fontSize,
                    ),
                    SizedBox(width: 2),
                    Text(
                      CONSTANTS.getDateStringSubtitle(
                          _missionModel ?? MissionModel()),
                      style: TextStyle(
                          fontSize: this.fontSize, color: ColorsConfig.darkRed),
                    ),
                    SizedBox(
                      width: this.space,
                    ),
                    if (this.widget._missionModel?.mission_value != null)
                      Text(
                        getI18NKey().value(
                                this.widget._missionModel?.mission_value ??
                                    "") +
                            getI18NKey().dollar +
                            "(" +
                            getI18NKey().value_per_hour(
                                Utility.getMissionValuePerHourByMissionModel(
                                    missionModel: this.widget._missionModel!)) +
                            ")",
                        style: TextStyle(
                            color: ColorsConfig.colorGold,
                            fontSize: this.fontSize),
                      )
                    // SizedBox(width: 2),
                    // Row(
                    //   children: [
                    //
                    //   ],
                    // )
                  ],
                )
              ]),
          flex: 3),

      DeviceInfoManagement.isMoible() == false
          ? SizedBox(
              width: 15,
            )
          : SizedBox(
              width: 0,
            )
    ];
    return Container(
      clipBehavior: ThemeManager.getInstance().isDark()
          ? Clip.none
          : Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.only(
          bottom: 2,
          left: CONSTANTS.missionPageMargin + 2,
          right: CONSTANTS.missionPageMargin + 2),
      decoration: ThemeManager.getInstance().isDark()
          ? null
          : new BoxDecoration(
              border: this.widget.multiSelectModeEnum ==
                      MultiSelectModeEnum.normal
                  ? new Border.all(
                      width: 1.0,
                      color: ThemeManager.getInstance()
                          .getLineColor(defaultColor: new Color(0xfff0f0f0)))
                  : Border.all(
                      width: 3.0,
                      color: new Color((CONSTANTS.getPriorityColor(
                              _missionModel?.priorityStatus ?? 3) -
                          (this.widget._missionModel?.isSelected == true
                              ? 0x00000000
                              : 0xe0000000)))),
              image: imageProvider == null
                  ? null
                  : DecorationImage(
                      image: imageProvider!,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          ThemeManager.getInstance()
                              .getCardBackgroundColor(defaultColor: Colors.white, alpha: 150),
                          BlendMode.colorBurn)),
              color: ThemeManager.getInstance()
                  .getCardBackgroundColor(defaultColor: Colors.white, alpha: 150),
              borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
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
                      if (mounted == true) {
                        // setState(() {});
                      }
                    });
                    return Container();
                  }),
          Container(
            color: ThemeManager.getInstance()
                .getCardBackgroundColor(defaultColor: Colors.white, alpha: 160),
            // color: Colors.yellow,
            constraints: BoxConstraints(minHeight: 40),
            padding: EdgeInsets.only(top: 0, bottom: 0),
            alignment: Alignment.centerLeft,
            child: Stack(children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: childrenRow,
                  ),
                ],
              ),
            ]),
          ),
          if (isDoItNow == true)
            Positioned(
                right: 3,
                top: 0,
                child: MissionCountDownTextWidget(
                  fontSize: 12,
                  color: 0xff909090,
                  end_time: _missionModel?.do_it_now?[0]['end_time'] as int,
                  end_buffer_time: _missionModel?.do_it_now?[0]
                      ['buffer_end_time'],
                  isFinished: _missionModel?.isFinished ?? false,
                )),
          Positioned(
              bottom: 3,
              right: 3,
              child: Row(
                children: [
                  folderModel == null
                      ? SizedBox.shrink()
                      : (WidgetManager.getFolderModelIcon(folderModel!, 12) ??
                          SizedBox.shrink()),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    folderModel?.title ?? "",
                    style: TextStyle(
                        fontSize: 10,
                        color: ThemeManager.getInstance()
                            .getTextColor(defaultColor: Color(0xff666666))),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
