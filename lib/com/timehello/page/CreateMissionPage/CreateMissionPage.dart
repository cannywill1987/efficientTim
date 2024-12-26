import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/BlackCheckButtonListWidget.dart';
import 'package:time_hello/com/timehello/components/PriorityButtonListWidget.dart';
import 'package:time_hello/com/timehello/components/SectionTitleWidget.dart';
import 'package:time_hello/com/timehello/components/SelectDatePeriodDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SelectTagDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SelectTomatoesDialogUtil.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/libs/mongodb/response/MongoDbUpdated.dart';
import 'package:time_hello/com/timehello/models/DateTimeModel.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../../../../r.dart';
import '../../beans/BaseBean.dart';
import '../../beans/UserBean.dart';
import '../../common/httpclient/HttpManager.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/CustomMarquee.dart';
import '../../components/IconButtonListWidget.dart';
import '../../components/MenuItem2.dart';
import '../../components/SelectCircleDialogUtil.dart';
import '../../components/TomatoInputNumber.dart';
import '../../config/ENUMS.dart';
import '../../libs/methodChannel/CounterMethodChannelManager.dart';
import '../../libs/mongodb/response/MongoDbSaved.dart';
import '../../util/DialogManagement.dart';
import '../../util/LoginManager.dart';
import '../../util/OverlayManagement.dart';
import 'components/TagsGridViewWidget.dart';

/**
 * 从MissionPage设置过来的
 * todo 点击还没分配到onClick
 */
class CreateMissionPage extends BaseWidget {
  int fromNormal = 0; //0是正常创建更新 1表示CreateAIChatGptMissionPage不需要刷新数据，直接更新即可
  MissionModel missionModel = MissionModel();
  Function? onRefresh;
  Function? popOkCallback;

  CreateMissionPage(
      {this.fromNormal = 0,
      MissionModel? missionModel,
      Function? onRefresh,
      this.popOkCallback}) {
    this.onRefresh = onRefresh;
    if (missionModel == null) {
      this.missionModel = MissionModel();
    } else {
      this.missionModel = missionModel;
    }
  }

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _CreateMissionPageWidgetState();
  }
}

class _CreateMissionPageWidgetState<T>
    extends BaseWidgetState<CreateMissionPage> {
  TextEditingController? inputNodeConroller;
  List<FolderModel> folderModelTags = [];
  FolderModel? folderModel;
  TextEditingController inputTitleController = TextEditingController();

// GlobalKey<BlackCheckButtonListWidgetS>
  GlobalKey<BlackCheckButtonListWidgetState> blackCheckButtonListWidgetState =
      GlobalKey<BlackCheckButtonListWidgetState>();

  // MissionModel missionModel;
  bool isNeedUpdateBmob =
      false; //是否需要更新BMOB 需要更新就EventBus发送广播让MssionPage重新发起requestData请求
  FocusNode _titleFocusNode = FocusNode();
  FocusNode _noteFocusNode = FocusNode();
  OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    gapPadding: 0,
    borderRadius: BorderRadius.circular(300),
    borderSide: BorderSide(
      color: ThemeManager.getInstance()
          .getInputBorderColor(defaultColor: Color(0xffa0a0a0)),
    ),
  );

  @override
  void onCreate() {
    super.onCreate();
    curPage = "CreateMissionPage";
  }

  @override
  void initState() {
    //查找当前mission所属的FolderModel
    forceAppBarVisible = true;
    isAppBarVisible = true;

    inputNodeConroller =
        TextEditingController(text: this.widget.missionModel?.message ?? '');
    // await requestGetTags(this.widget.missionModel?.tagNames.split(',') ?? ['ejizfjize']);
    if (this.widget.missionModel.tagNames == null)
      this.widget.missionModel.tagNames = '';
    if (this.widget.missionModel.tagNames != null) {
      requestGetTags(this.widget.missionModel.tagNames?.split(',') ?? []);
    }
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onTapTagListener': //创建mission时选择tag
        await onClickCreateTag();
        break;
      case "onClickPriority": //点击选择优先级
        await onTapPriority(data);
        break;
      case "onClickUpdate": //点击更新按钮
        await onClickUpdate();
        break;
      case 'onTapCircleListener': //穿件mission时选择目标文件夹
        this.onTapCircleListener();
        break;
      case 'onClickSelectTomatoes':
        this.onClickSelectTomatoes(context);
        break;
      case 'onClickChangeTomatoesNum': //修改番茄数
        this.onClickChangeTomatoesNum(data);
        break;
    }
  }

  onClickChangeTomatoesNum(data) {
    this.widget.missionModel.total_tomotoes = data['count'];
    this.widget.missionModel.tomato_duration = data['duration'];
    if (mounted) updateUI();
  }

  void unfocus() {
    _titleFocusNode.unfocus();
    _noteFocusNode.unfocus();
  }

  /**
   * 创建mission时选择tag
   */
  Future onClickCreateTag() async {
    SelectTagDialogUtil.show(context,
        title: getI18NKey().selectTag,
        content: '',
        okCallBack: (FolderModel data) {}, onTapCreateTagListener: (data) {
      this.onClick("onTapCreateTagListener", data);
    }, onTapListener: (data) {
      String title = data.title;
      if (this.widget.missionModel.tagNames == null)
        this.widget.missionModel.tagNames = '';
      List<String> titleList =
          this.widget.missionModel.tagNames?.split(',') ?? [];
      if (titleList.indexOf(title) == -1 && title.isEmpty == false) {
        titleList.add(title);
        this.widget.missionModel.tagNames = titleList.join(',');
        this.updateUI();
        this.isNeedUpdateBmob = true;
        requestGetTags(this.widget.missionModel.tagNames?.split(',') ?? []);
        Navigator.of(context).pop();
      } else {}
      unfocus();
    });
  }

  requestGetTags(List<String> list) async {
    this.folderModelTags =
        await CONSTANTS.getFolderModelListFromStringList(list);
    this.updateUI();
  }

  @override
  void didUpdateWidget(CreateMissionPage oldWidget) {
    inputNodeConroller =
        TextEditingController(text: this.widget.missionModel?.message ?? '');
  }

  @override
  void deactivate() {}

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> requestSaveData() async {
    if (ChatGroupManager.isFolderModelEnabled(
            folderId: this?.widget?.missionModel?.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }

    this.widget.missionModel.message = inputNodeConroller?.text;
    this.widget.missionModel.title = inputTitleController.text;
    if (TextUtil.isEmpty(this.widget.missionModel.title) == true) {
      Utility.showToastMsg(
          context: context, msg: getI18NKey().please_input_the_mission_title);
      return;
    }
    if ((this.widget.missionModel.alert_time ?? 0) > 0) {
      //加了这个 才会刷新提醒时间
      Params.shouldRefreshPushModelList = true;
    }
    //如果是从ai过来的那就不用更新
    if (this.widget.fromNormal == 1 && this.widget.popOkCallback != null) {
      this.widget.popOkCallback!(this?.widget?.missionModel);
      Utility.popNavigator(context, null);
      return;
    }
    try {
      if (TextUtil.isEmpty(this.widget.missionModel.objectId)) {
        MongoDbSaved? mongoDbSaved = await MongoApisManager.getInstance()
            .insertMissiontData(missionModel: this.widget.missionModel);
        if (mongoDbSaved != null) {
          Utility.showToastMsg(
              context: context, msg: getI18NKey().createSuccess);
          //todo 敢做这个没用了 因为用env了
          //mobile端返回上一页
          Utility.popNavigator(context, null);
          if (this.widget.onRefresh != null) {
            this.widget.onRefresh!();
          }
        } else {
          Utility.showToastMsg(
              context: context, msg: getI18NKey().network_error);
        }
      } else {
        MongoDbUpdated? mongoDbSaved = await MongoApisManager.getInstance()
            .update_MissionModel(missionModel: this.widget.missionModel);
        if (mongoDbSaved != null) {
          Utility.showToastMsg(
              context: context, msg: getI18NKey().createSuccess);
          //todo 敢做这个没用了 因为用env了
          //mobile端返回上一页
          Utility.popNavigator(context, null);
          if (this.widget.onRefresh != null) {
            this.widget.onRefresh!();
          }
        } else {
          Utility.showToastMsg(
              context: context, msg: getI18NKey().network_error);
        }
      }
    } catch (e) {
      Utility.showToastMsg(context: context, msg: getI18NKey().network_error);
    }
  }

  /**
   * 选择标签
   */
  Future onTapTag() async {
    SelectTagDialogUtil.show(context,
        title: getI18NKey().selectTag,
        content: '',
        okCallBack: (FolderModel data) {}, onTapCreateTagListener: (data) {
      this.onClick("onTapCreateTagListener", data);
    }, onTapListener: (data) {});
  }

  @override
  baseAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: ThemeManager.getInstance()
            .getIconColor(defaultColor: Colors.black), //修改颜色
      ),
      backgroundColor: ThemeManager.getInstance()
          .getNavigationBarColor(defaultColor: Colors.white),
      actions: [
        // IconButton(
        //     icon: Icon(
        //       Icons.play_circle_outline,
        //       color: ThemeManager.getInstance().getIconColor(),
        //     ),
        //     onPressed: () {
        //       this.onClick("onClickPlay", this.widget.missionModel);
        //     }),
        // IconButton(
        //     icon: Icon(
        //       Icons.delete,
        //       color: ThemeManager.getInstance().getIconColor(),
        //     ),
        //     onPressed: () {
        //       this.onClick("onClickDustBin", null);
        //     }),
        TextButton(
            onPressed: () async {
              // await onClickSave();
              onClickUpdate();
            },
            child: Text(
              TextUtil.isEmpty(this.widget.missionModel.objectId)
                  ? getI18NKey().create
                  : getI18NKey().update,
              style: TextStyle(color: Colors.red),
            ))
      ],
      // title: Text(getI18NKey().setting),
      //标题居中显示
      centerTitle: true,
    );
  }

  /**
   * 穿件mission时选择目标文件夹
   */
  Future onTapCircleListener() async {
    SelectCircleDialogUtil.show(context,
        title: getI18NKey().selectMission,
        content: '', okCallBack: (FolderModel data) {
      this.widget.missionModel.folder_id = data.objectId;
      updateUI();
      unfocus();
    }, onTapCreateTagListener: (data) {
      // this.onClick("onTapCreateTagListener", data);
    }, onTapListener: (data) {});
  }

  Future requestNotification() async {
    BaseBean res =
        await CounterMethodChannelManager.getInstance().isNotificationEnabled();
    if (res.data == false) {
      OkCancelResult result = await showOkCancelAlertDialog(
          context: context,
          title: getI18NKey().no_notification_permission_title,
          message: getI18NKey().need_notification_permission_content,
          okLabel: getI18NKey().go_to_setting,
          cancelLabel: getI18NKey().cancel,
          onWillPop: () async {
            //点击对话框外围黑色区域才会走这里
            return true;
          });
      if (result == OkCancelResult.ok) {
        await CounterMethodChannelManager.getInstance().openSetting();
      }
    }
  }

  /**
   * 更新alert_time
   * 如果是重复 直接用重复的开始时间
   * 如果是不重复 用开始时间+结束时间 因为结束时间 是 年月日到日
   */
  void updateAlertTime() {
    if (this.widget.missionModel.time_mode == 1) {
      this.widget.missionModel?.alert_time =
          (this.widget.missionModel?.start_time ?? 0);
    } else {
      if (this.widget.missionModel?.repetiveType == 0 &&
          this.widget.missionModel?.end_time != null) {
        this.widget.missionModel?.alert_time =
            (this.widget.missionModel?.daily_start_time ?? 0) +
                (this.widget.missionModel?.end_time ?? 0);
      } else {
        this.widget.missionModel?.alert_time =
            (this.widget.missionModel?.daily_start_time ?? 0);
      }
    }
  }

  Container getBgSettingItem(ImageProvider<Object>? imageProviderTmp) {
    return Container(
        height: 50,
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          image: imageProviderTmp == null
              ? null
              : DecorationImage(
                  image: imageProviderTmp,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      ThemeManager.getInstance().getCardBackgroundColor(
                          defaultColor: Colors.white, alpha: 150),
                      BlendMode.colorBurn)),
        ),
        // color: Colors.white,
        child: Container(
          color: ThemeManager.getInstance().getCardBackgroundColor(
              defaultColor: Color(0xa0ffffff), alpha: 150),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...getBarWidget(),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ));
  }

  List<Widget> getBarWidget() {
    return [
      InkWell(
        onTap: () {
          DialogManagement.getInstance().showSelectBgDialog(context,
              list: ResourceInfo
                      .missionItemBackgroundLocationInfoBean?.deliveryList ??
                  [], onTapListener: (String imgUrl) {
            this.widget.missionModel.background_url = imgUrl;
            updateUI();
            DialogManagement.getInstance().hideDialog(context);
          });
        },
        child: Text(getI18NKey().change_bg),
      ),
    ];
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    //return super.baseBuild(context);
    this.folderModel = MongoApisManager.getInstance()
        .queryWhereEqual_folderModelWithFolderIdOfMission(
            this.widget.missionModel.folder_id, 1);
    DateTime? dateTimeNextTime = Utility.getNextDateTime(
        missionModelParam: this.widget.missionModel,
        calendarModel: context.watch<GlobalStateEnv>().calendarModel);
    String repetiveString =
        CONSTANTS.getRepetiveDateString1(this.widget.missionModel);
    return RawKeyboardListener(
      autofocus: true,
      onKey: (event) {
        if (event.runtimeType == RawKeyDownEvent) {
          if (event.physicalKey == PhysicalKeyboardKey.enter) {
            this.onClick("onClickUpdate", null);
          }
        }
      },
      focusNode: FocusNode(),
      child: SingleChildScrollView(
          child: Column(children: [
        SizedBox(
          height: 10,
        ),
        Container(
            constraints:
                BoxConstraints(maxWidth: double.infinity, minHeight: 100),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            color: ThemeManager.getInstance()
                .getBackgroundColor(defaultColor: Colors.white),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    child: Stack(
                      children: [
                        Focus(
                            onKey: (FocusNode node, RawKeyEvent event) {
                              return KeyEventResult.ignored;
                            },
                            child: TextField(
                              maxLength: 255,
                              textAlign: TextAlign.center,
                              focusNode: _titleFocusNode,
                              controller: inputTitleController,
                              onChanged: (text) {
                                // _value = text;
                                // this.widget.onChangeListener(text);
                              },
                              // onSubmitted: (String value) {
                              //   if (this.widget.onSubmitListener != null) {
                              //     this.widget.onSubmitListener(
                              //         {"inputContent": value, "folderModel": curFolderModel});
                              //   }
                              //
                              //   print(value);
                              // },
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  decorationColor: Color(0xffd5d5d5),
                                  color: ThemeManager.getInstance()
                                      .getTextColor(
                                          defaultColor: Color(0xff404040)),
                                  fontWeight: FontWeight.w500),
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(top: 0, bottom: 0),
                                  counterStyle: TextStyle(
                                      color: Colors.transparent, fontSize: 0),
                                  //右边距是为了放置番茄计数器
                                  fillColor: ThemeManager.getInstance()
                                      .getInputThemeColor(
                                          defaultColor: Color(0xffe0e0e0)),
                                  //背景颜色，必须结合filled: true,才有效
                                  // hoverColor: Colors.white,
                                  // focusColor: Colors.white,
                                  filled: true,
                                  //重点，必须设置为true，fillColor才有效
                                  // border: OutlineInputBorder(),
                                  // prefixIcon: Icon(
                                  //   Icons.search,
                                  //   color: Color(0xffd5d5d5),
                                  // ),
                                  prefixIconColor: Color(0xffd5d5d5),
                                  floatingLabelStyle: TextStyle(
                                      color: Color(0xffff0000), fontSize: 14),
                                  border: _outlineInputBorder,
                                  //边框，一般下面的几个边框一起设置
                                  //keyboardType: TextInputType.number, //键盘类型
                                  //obscureText: true,//密码模式
                                  focusedBorder: _outlineInputBorder,
                                  enabledBorder: _outlineInputBorder,
                                  disabledBorder: _outlineInputBorder,
                                  focusedErrorBorder: _outlineInputBorder,
                                  errorBorder: _outlineInputBorder,
                                  // labelStyle:
                                  //     TextStyle(color: Color(0x00000000), fontSize: 14),
                                  // labelText: getI18NKey().search,
                                  hintStyle: TextStyle(fontSize: 13),
                                  hintText: getI18NKey()
                                      .please_input_the_mission_title),
                            )),
                        Align(
                          alignment: Alignment(1, -0.5),
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 20,
                            height: 20,
                            child: IconButton(
                                onPressed: () {},
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.close,
                                  size: 20,
                                ),
                                iconSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TagsGridViewWidget(
                    datas: this.folderModelTags,
                    onTapAddTagListener: (data) {
                      this.onClick('onTapTagListener', data);
                    },
                    onTapDeleteTagListener: (data) {
                      List<String> tagNamesList =
                          this.widget.missionModel?.tagNames?.split(',') ?? [];
                      tagNamesList.remove(data.title);
                      this.widget.missionModel.tagNames =
                          tagNamesList.join(',');
                      requestGetTags(
                          this.widget.missionModel?.tagNames?.split(',') ?? []);
                      this.isNeedUpdateBmob = true;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  PriorityButtonListWidget(
                    list: CONSTANTS.getPriorityButtonList(),
                    initIndex: this.widget.missionModel.priorityStatus ?? 3,
                    onTapListener: (data) {
                      int index = data['index'];
                      this.onClick("onClickPriority", index);
                    },
                  ),
                ])),
            if (Utility.shouldShowWallpaper(missionModelType: this.widget.missionModel.missionModelType))
        SizedBox(height: 5),
        if (Utility.shouldShowWallpaper(missionModelType: this.widget.missionModel.missionModelType))
        TextUtil.isEmpty(this.widget.missionModel.background_url)
            ? getBgSettingItem(null)
            : CachedNetworkImage(
                imageUrl: Utility.filterHttpUrl(
                    this.widget.missionModel.background_url ?? '',
                    prefix: "oss"),
                imageBuilder: (context, imageProviderTmp) {
                  return getBgSettingItem(imageProviderTmp);
                }),
        SizedBox(height: 5),

        SectionTitleWidget(
          title: getI18NKey().setting,
          child: BlackCheckButtonListWidget(
            key: blackCheckButtonListWidgetState,
            // initIndex: 1,
            initIndex: this.widget.missionModel.time_mode,
            backgroundColor: ColorsConfig.gray_40,
            list: CONSTANTS.getSettingItemDetailCheckButtonList(
                defaultVal: this.widget.missionModel.time_mode ?? 0),
            onTapListener: (index) async {
              this.widget.missionModel.time_mode = index;
              this.widget.missionModel?.end_time = 0;
              this.widget.missionModel?.start_time = 0;
              setState(() {});
            },
          ),
        ),
        if (DeviceInfoManagement.isMacOs() || DeviceInfoManagement.isIOS())
          MenuItem2(
              title: getI18NKey().save_mode,
              subTitle: "",
              onTapListener: (data) async {},
              rightPartContainer: IconButtonListWidget(
                popupModeEnum: PopupModeEnum.popup,
                initIndex: this.widget.missionModel.missionModelType ?? 0,
                list: CONSTANTS.getMissionTypeButtonList(defaultVal: 0),
                onTapListener: (obj) {
                  switch (obj['data'].code) {
                    case 'normal':
                      blackCheckButtonListWidgetState.currentState
                          ?.setCurIndex(0);
                      this.widget.missionModel.missionModelType = 0;
                      this.widget.missionModel.time_mode = 0;
                      // this.time_mode = 0;
                      break;
                    case 'calendar':
                      blackCheckButtonListWidgetState.currentState
                          ?.setCurIndex(1);
                      this.widget.missionModel.time_mode = 1;
                      // _tabBarKey.currentState?.setChecked(0);
                      this.widget.missionModel.missionModelType = 1;
                      // this.time_mode = 1;
                      break;
                    case 'alarm':
                      blackCheckButtonListWidgetState.currentState
                          ?.setCurIndex(0);
                      this.widget.missionModel.time_mode = 0;
                      // _tabBarKey.currentState?.setChecked(0);
                      this.widget.missionModel.missionModelType = 2;
                      // this.time_mode = 0;
                      break;
                  }
                  setState(() {});
                },
              ),
              icon: Utility.getSVGPicture(R.assetsImgIcCalendarMode,
                  size: StylesConfig.iconSize,
                  color: ThemeManager.getInstance().getDefautThemeColor())),
        if (Utility.shouldShowBeginTime(
            missionModelType: this.widget.missionModel.missionModelType))
          MenuItem2(
              title: (this.widget.missionModel.repetiveType == 0 ||
                      this.widget.missionModel.time_mode == 1)
                  ? getI18NKey().start_time
                  : getI18NKey().daily_start_time,
              subTitle: this.widget.missionModel.repetiveType == 1
                  ? ""
                  : "(${getI18NKey().optional})",
              onTapListener: (data) async {
                if (this.widget.missionModel.time_mode == 1) {
                  DateTimeModel? model =
                      await Utility.showDateTimePickerDialog(context);
                  updateAlertTime();
                  this.setState(() {
                    this.isNeedUpdateBmob = true;
                    this.widget.missionModel?.start_time =
                        model?.datetime?.millisecondsSinceEpoch ?? 0; //计划到期日
                  });
                } else {
                  DateTimeModel model;
                  TimeOfDay? timeOfDay;
                  timeOfDay = await Utility.showTimePickerDialog(context);
                  if (timeOfDay == null) {
                    return;
                  }
                  this.widget.missionModel.daily_start_time =
                      timeOfDay.hour * 60 * 60 * 1000 +
                          timeOfDay.minute * 60 * 1000;
                  // if((this.widget.missionModel.alert_time??0) > 0) {
                  //   Params.shouldRefreshPushModelList = true;
                  // }
                  updateAlertTime();
                  this.setState(() {
                    this.isNeedUpdateBmob = true;
                  });
                }
                // this.requestNotification();
                // NotificationManager.getInstance()
              },
              rightPartContainer: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    this.widget.missionModel.time_mode == 1
                        ? CONSTANTS.getAlertDateString(
                            Utility.getDateTimeModelFromTimeStamp(
                                this.widget.missionModel?.start_time ?? 0))
                        : TextUtil.isEmpty(this
                                    .widget
                                    .missionModel
                                    .daily_start_time) ==
                                false
                            ? Utility.formatHourAndMin2(
                                this.widget?.missionModel?.daily_start_time ??
                                    0)
                            : getI18NKey().none,
                    style: TextStyle(
                        fontSize: 15, color: ColorsConfig.gray_a3_icon),
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel,
                        size: 20, color: ColorsConfig.gray_cc_cancel),
                    onPressed: () {
                      this.isNeedUpdateBmob = true;
                      // this.widget.missionModel.daily_start_time = 0;
                      this.widget.missionModel?.daily_start_time = 0;
                      this.widget.missionModel?.start_time = null;
                      this.updateUI();
                    },
                  )
                ],
              ),
              icon: Utility.getSVGPicture(R.assetsImgIcStarttimeOrange,
                  size: StylesConfig.iconSize,
                  color: ThemeManager.getInstance().getDefautThemeColor())),
        if (Utility.shouldShowEndTime(
            missionModelType: this.widget.missionModel.missionModelType))
          MenuItem2(
              title: (this.widget.missionModel.repetiveType == 0 ||
                      this.widget.missionModel.time_mode == 1)
                  ? getI18NKey().end_time
                  : getI18NKey().daily_end_time,
              subTitle: this.widget.missionModel.repetiveType == 1
                  ? ""
                  : "(${getI18NKey().optional})",
              onTapListener: (data) async {
                if (this.widget.missionModel.time_mode == 1) {
                  if (this.widget.missionModel?.start_time == null) {
                    Utility.showToastMsg(
                        context: context,
                        msg: getI18NKey().please_select_daily_start_time);
                    return;
                  }
                  DateTimeModel? model =
                      await Utility.showDateTimePickerDialog(context);
                  if ((model?.datetime?.millisecondsSinceEpoch ?? 0) <
                      (this.widget.missionModel?.start_time ?? 0)) {
                    Utility.showToastMsg(
                        context: context,
                        msg: getI18NKey().end_time_cannot_before_start_time);
                    this.widget.missionModel?.end_time = null;
                    return;
                  }
                  this.setState(() {
                    this.isNeedUpdateBmob = true;
                    this.widget.missionModel?.end_time =
                        model?.datetime?.millisecondsSinceEpoch ?? 0; //计划到期日
                  });
                } else {
                  if (this.widget.missionModel.daily_start_time == null) {
                    Utility.showToastMsg(
                        context: context,
                        msg: getI18NKey().please_select_daily_start_time);
                    return;
                  }
                  TimeOfDay? timeOfDay;
                  timeOfDay = await Utility.showTimePickerDialog(context);
                  if (timeOfDay == null) {
                    return;
                  }
                  int endTime = timeOfDay.hour * 60 * 60 * 1000 +
                      timeOfDay.minute * 60 * 1000;
                  if (endTime <
                      (this.widget.missionModel.daily_start_time ?? 0)) {
                    Utility.showToastMsg(
                        context: context,
                        msg: getI18NKey().end_time_cannot_before_start_time);
                    this.widget.missionModel.daily_end_time = null;
                    return;
                  }
                  this.widget.missionModel.daily_end_time = endTime;

                  this.setState(() {
                    this.isNeedUpdateBmob = true;
                  });
                }
                // this.requestNotification();
                // NotificationManager.getInstance()
              },
              rightPartContainer: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    this.widget.missionModel.time_mode == 1
                        ? CONSTANTS.getAlertDateString(
                            Utility.getDateTimeModelFromTimeStamp(
                                this.widget.missionModel?.end_time ?? 0))
                        : TextUtil.isEmpty(
                                    this.widget.missionModel.daily_end_time) ==
                                false
                            ? Utility.formatHourAndMin2(
                                this.widget.missionModel.daily_end_time ?? 0)
                            : getI18NKey().none,
                    style: TextStyle(
                        fontSize: 15, color: ColorsConfig.gray_a3_icon),
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel,
                        size: 20, color: ColorsConfig.gray_cc_cancel),
                    onPressed: () {
                      this.isNeedUpdateBmob = true;
                      this.widget.missionModel?.end_time = 0;
                      this.widget.missionModel?.daily_end_time = 0;
                      this.updateUI();
                    },
                  )
                ],
              ),
              icon: Utility.getSVGPicture(R.assetsImgIcEndtimeOrange,
                  size: StylesConfig.iconSize,
                  color: ThemeManager.getInstance().getDefautThemeColor())),
        // SizedBox(height: 20,),
        if (Utility.shouldShowCircleFolderId(
            missionModelType: this.widget.missionModel.missionModelType))
          MenuItem2(
              title: getI18NKey().mission,
              subTitle: "(${getI18NKey().optional})",
              onTapListener: (data) async {
                this.onClick('onTapCircleListener', data);
              },
              rightPartContainer: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    this.folderModel != null && this.folderModel?.title != null
                        ? (this.folderModel?.title ?? "")
                        : getI18NKey().none,
                    style: TextStyle(
                        fontSize: 15,
                        color: this.folderModel != null &&
                                this.folderModel?.color != null
                            ? Color(this.folderModel?.color ?? 0)
                            : ColorsConfig.gray_a3_icon),
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel,
                        size: 20, color: ColorsConfig.gray_cc_cancel),
                    onPressed: () {
                      this.isNeedUpdateBmob = true;
                      this.widget.missionModel.alert_time = 0;
                      this.updateUI();
                    },
                  )
                ],
              ),
              icon: folderModel?.icon != null
                  ? Icon(
                      IconData(folderModel?.icon ?? 0,
                          fontFamily: 'MaterialIcons'),
                      size: 25,
                      color: folderModel?.icon != null
                          ? Color(folderModel?.color ?? 0)
                          : ColorsConfig.gray_a3_icon)
                  : Utility.getSVGPicture(R.assetsImgIcFolderOrange,
                      size: StylesConfig.iconSize,
                      color: ThemeManager.getInstance().getDefautThemeColor())),
        this.widget.missionModel.isFinished == true
            ? SizedBox.shrink()
            : Utility.shouldShowTomatoes(
                        missionModelType:
                            this.widget.missionModel.missionModelType) ==
                    false
                ? SizedBox.shrink()
                : MenuItem2(
                    title: getI18NKey().tomatoNums,
                    subTitle: getI18NKey().tomatoNums3,
                    onTapListener: (data) {
                      this.onClick('onClickSelectTomatoes', null);
                    },
                    rightPartContainer:
                        TomatoInputNumber(onValueChangeListener: (v, duration) {
                      this.onClick('onClickChangeTomatoesNum',
                          {"count": v, "duration": duration});
                    }),
                    icon: Utility.getSVGPicture(R.assetsImgIcFocusOrange,
                        size: StylesConfig.iconSize,
                        color:
                            ThemeManager.getInstance().getDefautThemeColor())),
        if (Utility.shouldShowMissionValue(
                missionModelType: this.widget.missionModel.missionModelType) ==
            true)
          MenuItem2(
              title: getI18NKey().mission_value,
              // subTitle: getI18NKey().tomatoNums3,
              onTapListener: (data) {
                if (LoginManager.getInstance().userBean.valuePerHour == null ||
                    LoginManager.getInstance().userBean.valuePerHour == 0) {
                  OverlayManagement.getInstance()
                      .openSelectMoneyPerHourOfMeOverlay(context,
                          title: getI18NKey().mission_value,
                          okCallBack: (valuePerHour) async {
                    OverlayManagement.getInstance().removeSelectDialogOverlay();
                    BaseBean response = await HttpManager.getInstance()
                        .doPostRequest(Apis.updateValuePerHour,
                            params: {"valuePerHour": valuePerHour},
                            context: context,
                            shouldShowErrorToast: false);
                    if (response.success == true) {
                      LoginManager.getInstance()
                          .setUserBean(UserBean.fromJson(response.data));
                    }
                  });
                  return;
                }
                OverlayManagement.getInstance()
                    .openSelectMoneyPerHourOfMeOverlay(context,
                        title: getI18NKey().mission_value, cancelCallBack: () {
                  OverlayManagement.getInstance()
                      .dismissSelectValueMoneyOverlay();
                }, okCallBack: (data) {
                  this.setState(() {
                    this.widget.missionModel?.mission_value = data;
                    // this.mission_value = data;
                  });
                  OverlayManagement.getInstance()
                      .dismissSelectValueMoneyOverlay();
                });
              },
              rightPartContainer: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          // Text(
                          //   this.widget.missionModel.mission_value == null ? getI18NKey().none : (this.widget.missionModel.mission_value.toString() + getI18NKey().dollar),
                          //   style: TextStyle(
                          //       fontSize: 15,
                          //       color: this.widget.missionModel.mission_value == null ? ColorsConfig.gray_a3_icon : ColorsConfig.colorGold),
                          // ),
                          Text(
                            this.widget.missionModel.mission_value == null
                                ? getI18NKey().none
                                : (this
                                        .widget
                                        .missionModel
                                        .mission_value
                                        .toString() +
                                    getI18NKey().dollar +
                                    "(" +
                                    getI18NKey().value_per_hour(Utility
                                        .getMissionValuePerHourByMissionModel(
                                            missionModel:
                                                this.widget.missionModel!)) +
                                    ")"),
                            style: TextStyle(
                                fontSize: 15,
                                color: this.widget.missionModel.mission_value ==
                                        null
                                    ? ColorsConfig.gray_a3_icon
                                    : ColorsConfig.colorGold),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel,
                            size: 20, color: ColorsConfig.gray_cc_cancel),
                        onPressed: () {
                          this.widget.missionModel.mission_value = 0;
                          updateUI();
                          // this.isNeedUpdateBmob = true;
                          // this.widget.missionModel.mission_value = 0;
                          // this.updateUI();
                        },
                      )
                    ],
                  ),
                ],
              ),
              icon: Utility.getSVGPicture(R.assetsImgIcMoney2,
                  size: StylesConfig.iconSize,
                  color: ThemeManager.getInstance().getDefautThemeColor())),

        (this.widget.missionModel.isFinished == true ||
                this.widget.missionModel?.time_mode == 1)
            ? SizedBox.shrink()
            : MenuItem2(
                title: getI18NKey().deadLine,
                subTitle: "(${getI18NKey().optional})",
                onTapListener: (data) async {
                  DateTimeModel? model = await Utility.showDatePickerDialog(
                      context, this.widget.missionModel.end_time ?? 0);
                  this.setState(() {
                    this.isNeedUpdateBmob = true;
                    this.widget.missionModel.end_time =
                        model?.datetime?.millisecondsSinceEpoch ?? 0; //计划到期日
                  });
                },
                rightPartContainer: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      TextUtil.isEmpty(this.widget.missionModel.end_time) ==
                              false
                          ? CONSTANTS.getWeekDayString(
                              Utility.getDateTimeModelFromTimeStamp(
                                  this.widget.missionModel.end_time ?? 0))
                          : getI18NKey().none,
                      style:
                          TextStyle(fontSize: 15, color: ColorsConfig.darkRed),
                    ),
                    IconButton(
                      //点击x按钮清空数据
                      icon: Icon(Icons.cancel,
                          size: 20, color: ColorsConfig.gray_cc_cancel),
                      onPressed: () {
                        this.isNeedUpdateBmob = true;
                        this.widget.missionModel.end_time = null;
                        // this.widget.missionModel.end_time =
                        //     Utility.getTimeStampToday();
                        // this.widget.missionModel.end_time = 0;
                        this.updateUI();
                      },
                    )
                  ],
                ),
                icon: Utility.getSVGPicture(R.assetsImgIcEndtime2Orange,
                    size: StylesConfig.iconSize,
                    color: ThemeManager.getInstance().getDefautThemeColor())),
        this.widget.missionModel.isFinished == true
            ? SizedBox.shrink()
            : Utility.shouldShowAlert(
                        missionModelType:
                            this.widget.missionModel.missionModelType) ==
                    false
                ? SizedBox.shrink()
                : MenuItem2(
                    title: getI18NKey().alert,
                    subTitle: "(${getI18NKey().optional})",
                    onTapListener: (data) async {
                      DateTimeModel? model;
                      TimeOfDay? timeOfDay;
                      if (this.widget.missionModel.repetiveType == 0) {
                        model = await Utility.showDateTimePickerDialog(context);
                        if (model == null) {
                          return;
                        }
                        // this.alertTimeModel = model;
                        this.widget.missionModel.alert_time =
                            model.timestamp; //设置提醒时间
                        // if (model.timestamp > 0) {
                        //   Params.shouldRefreshPushModelList = true;
                        // }
                      } else {
                        timeOfDay = await Utility.showTimePickerDialog(context);
                        if (timeOfDay == null) {
                          return;
                        }
                        this.widget.missionModel.alert_time =
                            timeOfDay.hour * 60 * 60 * 1000 +
                                timeOfDay.minute * 60 * 1000;
                        // if((this.widget.missionModel.alert_time??0) > 0) {
                        //   Params.shouldRefreshPushModelList = true;
                        // }
                      }
                      this.setState(() {
                        this.isNeedUpdateBmob = true;
                      });
                      this.requestNotification();
                      // NotificationManager.getInstance()
                    },
                    rightPartContainer: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          TextUtil.isEmpty(
                                      this.widget.missionModel.alert_time) ==
                                  false
                              ? (this.widget.missionModel.repetiveType == 0
                                  ? CONSTANTS.getAlertDateString(
                                      Utility.getDateTimeModelFromTimeStamp(
                                          this.widget.missionModel.alert_time ??
                                              0))
                                  : Utility.formatHourAndMin2(
                                      this.widget.missionModel.alert_time ?? 0))
                              : getI18NKey().none,
                          style: TextStyle(
                              fontSize: 15, color: ColorsConfig.gray_a3_icon),
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel,
                              size: 20, color: ColorsConfig.gray_cc_cancel),
                          onPressed: () {
                            this.isNeedUpdateBmob = true;
                            this.widget.missionModel.alert_time = 0;
                            this.updateUI();
                          },
                        )
                      ],
                    ),
                    icon: Utility.getSVGPicture(R.assetsImgIcAlarmOrange,
                        size: StylesConfig.iconSize,
                        color:
                            ThemeManager.getInstance().getDefautThemeColor())),
        if (this.widget.missionModel?.time_mode == 0)
          (this.widget.missionModel.isFinished == true)
              ? SizedBox.shrink()
              : Utility.shouldShowAlert(
                          missionModelType:
                              this.widget.missionModel.missionModelType) ==
                      false
                  ? SizedBox.shrink()
                  : MenuItem2(
                      title: getI18NKey().repetive,
                      subTitle: "(${getI18NKey().optional})",
                      onTapListener: (data) {
                        SelectDatePeriodDialogUtil.show(context, okCallBack:
                            (valueMiddleSelected, valueRightSelected,
                                listCheckModels) {
                          this.isNeedUpdateBmob = true;
                          this.widget.missionModel.repetiveValue =
                              valueMiddleSelected; //更新值
                          if (this.widget.missionModel.repetiveType !=
                              valueRightSelected) {
                            this.widget.missionModel.alert_time = 0;
                          }
                          this.widget.missionModel.repetiveType =
                              valueRightSelected; // 0关闭重复 1 按天重复 2 按周重复 3 按月重复 4 按年重复
                          if (this.widget.missionModel.repetiveWeekDay ==
                                  null ||
                              (this
                                          .widget
                                          .missionModel
                                          .repetiveWeekDay
                                          ?.length ??
                                      0) ==
                                  0)
                            this.widget.missionModel.repetiveWeekDay = [
                              false,
                              false,
                              false,
                              false,
                              false,
                              false,
                              false,
                            ];
                          if (listCheckModels.length > 5) {
                            this.widget.missionModel.repetiveWeekDay?[0] =
                                listCheckModels[0].isChecked;
                            this.widget.missionModel.repetiveWeekDay?[1] =
                                listCheckModels[1].isChecked;
                            this.widget.missionModel.repetiveWeekDay?[2] =
                                listCheckModels[2].isChecked;
                            this.widget.missionModel.repetiveWeekDay?[3] =
                                listCheckModels[3].isChecked;
                            this.widget.missionModel.repetiveWeekDay?[4] =
                                listCheckModels[4].isChecked;
                            this.widget.missionModel.repetiveWeekDay?[5] =
                                listCheckModels[5].isChecked;
                            this.widget.missionModel.repetiveWeekDay?[6] =
                                listCheckModels[6].isChecked;
                          }
                          updateAlertTime();
                          updateUI();
                          // this.isNeedUpdateBmob = true;
                        });
                      },
                      rightPartContainer: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: Utility.isHandsetBySize() ? 160 : 160,
                                  child: new Text.rich(
                                    //富文本文本框构造方法，可以显示多种样式的text，第一个参数为 TextSpan
                                    new TextSpan(
                                      text: repetiveString,
                                      //文字样式，如果后面的子 TextSpan 没有覆盖该 TextStyle 中的属性，则使用该 TextStyle 指定的样式
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorsConfig.darkRed),
                                      //应该是手势识别监听器，后面用到手势监听再详细学习该类用法
//          recognizer: ,
                                      //子 TextSpan，可以指定多个
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                                dateTimeNextTime == null
                                    ? SizedBox.shrink()
                                    : Text(
                                        CONSTANTS.getRepetiveDateString2(
                                            dateTimeNextTime),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: ColorsConfig.gray_a3_icon),
                                      ),
                              ]),
                          IconButton(
                            icon: Icon(Icons.cancel,
                                size: 20, color: ColorsConfig.gray_cc_cancel),
                            onPressed: () {
                              resetRepeativeValue();
                            },
                          )
                        ],
                      ),
                      icon: Utility.getSVGPicture(R.assetsImgIcAlarmOrange,
                          size: StylesConfig.iconSize,
                          color: ThemeManager.getInstance()
                              .getDefautThemeColor())),
        SizedBox(height: 20),
        Container(
          height: Utility.isHandsetBySize() == true ? 100 : 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: ThemeManager.getInstance()
                .getInputPlaceholderColor(defaultColor: Color(0xfff0f0f0)),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            focusNode: _noteFocusNode,
            controller: inputNodeConroller,
            onChanged: (data) {
              this.isNeedUpdateBmob = true;
            },
            keyboardType: TextInputType.multiline,
            maxLines: 40,
            //不限制行数
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: getI18NKey().note,
                hintStyle: new TextStyle(
                    fontSize: 14, color: Color.fromRGBO(187, 187, 187, 1))),
            maxLength: 1000,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        InkWell(
            onTap: () {
              this.onClick("onClickUpdate", null);
            },
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10),
                width: 260,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      colors: ThemeManager.getInstance()
                          .getButtonLinearGradientBackgroundColor()),
                ),
                child: Text(
                  getI18NKey().create,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ))),
        SizedBox(
          height: 20,
        ),
      ])),
    );
  }

  void resetRepeativeValue() {
    this.isNeedUpdateBmob = true;
    if (this.widget.missionModel?.repetiveValue != null) {
      this.widget.missionModel?.alert_time = 0;
    }
    this.widget.missionModel?.repetiveValue = null;
    this.widget.missionModel?.repetiveType = 0;
    this.widget.missionModel?.repetiveWeekDay = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ];
    this.isNeedUpdateBmob = true;
    // requestMongoDbUpdateData();
    this.updateUI();
  }

  void onClickSelectTomatoes(BuildContext context) {
    SelectTomatoesDialogUtil.show(context,
        numTomatoes: (this.widget.missionModel.total_tomotoes ?? 1) - 1,
        duration: this.widget.missionModel.tomato_duration != null
            ? ((this.widget.missionModel.tomato_duration ?? 0) / (60 * 1000) -
                    1)
                .toInt()
            : 25, okCallBack: (numTomatoes, duration) {
      this.widget.missionModel.tomato_duration = (duration + 1) * 60 * 1000;
      this.widget.missionModel.total_tomotoes = numTomatoes + 1;
      this.isNeedUpdateBmob = true;
      updateUI();
      unfocus();
    });
  }

  Future onClickUpdate() async {
    await requestSaveData();
    unfocus();
    // if (Utility.isHandsetBySize()) {
    //   //mobile端返回上一页
    //   Utility.popNavigator(context, null);
    // } else {
    //   //pc端把右端设置隐藏
    //   Utility.popupDesktopRightNavigator(context);
    // }
    // eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    // eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
  }

  /**
   * 点击选择优先级
   */
  Future onTapPriority(int priority) async {
    this.widget.missionModel.priorityStatus = priority;
  }

  /**
   * 获取优先级Icon
   */
  Widget getPriorityIcon(missionModel, {double iconSize = 30}) {
    int priorityStatus = missionModel?.priorityStatus ?? 3;
    return CONSTANTS
            .getPriorityModels(iconSize: iconSize)[priorityStatus]
            .icon ??
        SizedBox.shrink();
  }
}
