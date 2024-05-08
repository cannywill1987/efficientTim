import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';

import '../../components/SelectDateDialog.dart';
import '../../config/CONSTANTS.dart';
import '../../config/ColorsConfig.dart';
import '../../config/ENUMS.dart';
import '../../models/FlomoMissionModel.dart';
import '../../models/FolderModel.dart';
import '../../models/WQBFolderModel.dart';
import '../../models/WQBMissionModel.dart';
import '../../util/ScreenUtil.dart';
import '../../util/TextUtil.dart';
import '../../util/Utility.dart';
import '../statisticPage/components/ContainerWidget.dart';
import 'components/WQBBottomBar.dart';
import 'components/WQBHeaderWidget.dart';
import 'components/WQBKnowledgetPoint.dart';
import 'components/WQBMasteringSiturationWidget.dart';
import 'components/WQBNoteWidget.dart';
import 'components/WQBResultListView.dart';
import 'components/WQBReviceDateListView.dart';
import 'components/WQBSelectCircleDialogUtil.dart';
import 'components/WQBSelectTagDialogUtil.dart';
import 'components/WQBTagsGridViewWidget.dart';

class WrongQuestionBookPage extends BaseWidget {
  final WQBFolderModel? folderModel; //FoldersPage页面传入的数据
  final WQBMissionModel wqbMissionModel;
  final SaveModeEnum saveModeEnum;
  final WQBSceneEnum sceneEnum;
  // final bool isEditable;

  // required this.isEditable,
  const WrongQuestionBookPage(
      {required Key key,
      this.folderModel,
        required this.sceneEnum,
      required this.saveModeEnum,
      required this.wqbMissionModel})
      : super(key: key);

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return WrongQuestionBookPageState();
  }
}

class WrongQuestionBookPageState
    extends BaseWidgetState<WrongQuestionBookPage> {
  late FlomoMissionModel flomoMissionModel;
  List<DateTime?> extraTimeList = [];
  GlobalKey<WQBComposeRichEditorContainerWidgetState>
      knowledgeRichEditorGlobakKey = GlobalKey();
  GlobalKey<WQBComposeRichEditorContainerWidgetState>
      questionWidgetRichEditorGlobakKey = GlobalKey();
  GlobalKey<WQBComposeRichEditorContainerWidgetState>
      answerWidgetRichEditorGlobakKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // GlobalKey<WQBHeaderWidgetState>? HeaderWidgetStateGlobalKey = GlobalKey();
  GlobalKey<WQBBottomBarState>? bottomBarStateKey = GlobalKey();
  Icon? _circleIcon; //目标Icon
  // String? _title = '';
  String? _circleTitle = ''; //目标标题 从folderModel过来 或者从SelectCircleDialogUtil
  int? _circleColor = 0; //目标颜色
  // int _dateStatus = 3; //dateStatus 0-今天 1 明天 2 即将到来 3 待定 4 日程 5 已完成
  int _priorityStatus = 3; //优先级
  // String? _tagName = ''; //创建missionPage tagName
  bool isFocusing = false;
  // int? _tagColor; // SelectTagDialogUtil 过来，选择完标签返回
  String? _curFolderModelObjId; //目标objectId 即folderId
  initState() {
    super.initState();
    // this._circleIcon = Icon(
    //     IconData(this.widget.folderModel?.icon ?? Icons.circle.codePoint, fontFamily: 'MaterialIcons'),
    //     size: 20,
    //     color: Color(this._circleColor ?? 0xffff8800));
    if(this.widget.sceneEnum == WQBSceneEnum.question_wrong_book && Utility.isHandsetBySize()) {
      this.rightNavChildren = [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
            // if (this.widget.onTapNavMenuListener != null) {
            //   this.widget.onTapNavMenuListener!();
            // }
          },
        )
      ];
    }
    initData(); //用于创建mission时保存id
    flomoMissionModel = FlomoMissionModel();
    if (Utility.isHandsetBySize() ||
        this.widget.saveModeEnum == SaveModeEnum.save) {
      this.forceAppBarVisible = true;
    }
    if (this.widget.saveModeEnum == SaveModeEnum.save) {
      this.rightNavChildren = [
        TextButton(
          onPressed: () async {
            onClickSave();
          },
          child: Text(
            getI18NKey().save,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ];
      this.widget.wqbMissionModel?.masterScore = 2;
      this.widget.wqbMissionModel.causeAnalysis = [
        {"code": "confused", "weight": 0},
        {"code": "examination", "weight": 0},
        {"code": "wrong_thinking", "weight": 0},
        {"code": "arithmetic_error", "weight": 0},
        {"code": "carelessness", "weight": 0}
      ];
    }
  }

  @override
  void didUpdateWidget(covariant WrongQuestionBookPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    initData(); //用于创建mission时保存id
  }

  void initData() {
    this._curFolderModelObjId =
        this.widget.wqbMissionModel?.folder_id ?? ""; //用于创建mission时保存id
    // this._title = this.widget.wqbMissionModel.title;
    // this._priorityStatus = this.widget.wqbMissionModel.priorityStatus ?? 1;
    // this._tagName =
    //     Utility.getTagsFromWQBMissionModel(this.widget.wqbMissionModel);
    // this._tagColor = Utility.getFirstTagColorFromWQBMissionModel(
    //     this.widget.wqbMissionModel);
    bottomBarStateKey?.currentState?.setCurIndex(this.widget.wqbMissionModel.state);
    List<WQBFolderModel> list = MongoApisManager.getInstance()
        .queryWhereEqual_WQBFolderModelWithFolderId(this._curFolderModelObjId);
    if (list != null && list.length > 0) {
      WQBFolderModel folderModel = list?[0] ?? WQBFolderModel();
      this._circleColor = folderModel.color;
      this._circleTitle = folderModel.title;
      this._circleIcon = Icon(
          IconData(folderModel?.icon ?? Icons.circle.codePoint,
              fontFamily: 'MaterialIcons'),
          size: 20,
          color: Color(this._circleColor ?? 0xffff8800));
    } else {
      if(this.widget.saveModeEnum == SaveModeEnum.save) {
        if(this.widget.folderModel?.tag == 1) { // circle
          this._circleColor = this.widget.folderModel?.color;
          this._circleTitle = this.widget.folderModel?.title;
          this._circleIcon = Icon(
              IconData(this.widget.folderModel?.icon ?? Icons.circle.codePoint,
                  fontFamily: 'MaterialIcons'),
              size: 20,
              color: Color(this._circleColor ?? 0xffff8800));
        }
      }
    }
  }

  void onClickSave() async {
    await knowledgeRichEditorGlobakKey.currentState?.globalSave();
    await questionWidgetRichEditorGlobakKey.currentState?.globalSave();
    await answerWidgetRichEditorGlobakKey.currentState?.globalSave();
    // this.widget.wqbMissionModel.title = 'title';
    this.widget.wqbMissionModel.folder_id = this.widget.folderModel?.objectId;
    this.widget.wqbMissionModel.priorityStatus = this.widget.wqbMissionModel.priorityStatus ?? 4;

    if (TextUtil.isEmpty(this.widget.wqbMissionModel.title)) {
      int lengthTitle = 10;
      if(this.widget.sceneEnum == WQBSceneEnum.memorandum) {
        if(!TextUtil.isEmpty(this.widget.wqbMissionModel.wqbAnswerContent)) {
          this.widget.wqbMissionModel.title = this.widget.wqbMissionModel.wqbAnswerContent.substring(0, this.widget.wqbMissionModel.wqbAnswerContent.length > lengthTitle ? lengthTitle : this.widget.wqbMissionModel.wqbAnswerContent.length);
        } else {
          this.widget.wqbMissionModel.title = getI18NKey().memorandum;
        }
      } else if(this.widget.sceneEnum == WQBSceneEnum.card) {
        if(!TextUtil.isEmpty(this.widget.wqbMissionModel.wqbWrongQuestionContent)) {
          this.widget.wqbMissionModel.title = this.widget.wqbMissionModel.wqbWrongQuestionContent.substring(0, this.widget.wqbMissionModel.wqbWrongQuestionContent.length > lengthTitle ? lengthTitle : this.widget.wqbMissionModel.wqbWrongQuestionContent.length);
        } else {
          this.widget.wqbMissionModel.title = getI18NKey().card;
        }
      } else {
        if(!TextUtil.isEmpty(this.widget.wqbMissionModel.wqbWrongQuestionContent)) {
          this.widget.wqbMissionModel.title = this.widget.wqbMissionModel.wqbWrongQuestionContent.substring(0, this.widget.wqbMissionModel.wqbWrongQuestionContent.length > lengthTitle ? lengthTitle : this.widget.wqbMissionModel.wqbWrongQuestionContent.length);
        } else {
          this.widget.wqbMissionModel.title =
              getI18NKey().question_wrong_question;
        }
      }
      // return;
    }

    MongoApisManager.getInstance()
        .insertWQBMissiontData(missionModel: this.widget.wqbMissionModel);
    Utility.popupPagePCAndMobile(context);
    // await Future.wait([
    //   knowledgeRichEditorGlobakKey.currentState?.globalSave(),
    //   questionWidgetRichEditorGlobakKey.currentState?.globalSave(),
    //   answerWidgetRichEditorGlobakKey.currentState?.globalSave(),
    // ]).then((value) {
    //     this.widget.wqbMissionModel.title = 'title';
    //     this.widget.wqbMissionModel.folder_id =
    //         this.widget.folderModel?.objectId;
    //     MongoApisManager.getInstance()
    //         .insertWQBMissiontData(missionModel: this.widget.wqbMissionModel);
    //
    // });
  }

  // //把extraTimeList加到alert_times前面
  // addExtraTimeListToAlertTimes(FlomoMissionModel flomoMissionModel) {
  //   if (flomoMissionModel?.alert_times == null) {
  //     this.widget.flomoMissionModel?.alert_times = [];
  //   }
  //   this.widget.flomoMissionModel?.alert_times.insertAll(0, extraTimeList);
  // }
  /**
   * 穿件mission时选择目标文件夹
   */
  Future onTapCircleListener(WQBFolderModel data) async {
    // WQBSelectCircleDialogUtil.show(context,
    //     title: getI18NKey().selectMission,
    //     content: '', okCallBack: (WQBFolderModel data) {
    //   setState(() {
        this._circleColor = data.color;
        this._circleTitle = data.title;
        this._circleIcon = Icon(
            IconData(data.icon ?? 0, fontFamily: 'MaterialIcons'),
            size: 20,
            color: Color(this._circleColor ?? 0xffff8800));
        this._curFolderModelObjId = data.objectId;
        this.widget.wqbMissionModel.folder_id = data.objectId;
        if(this.widget.saveModeEnum == SaveModeEnum.normal) {
          MongoApisManager.getInstance().update_WQBMissionModel(
              missionModel: this.widget.wqbMissionModel, callback: (data) {
                updateUI();
          });
        }
      // });
      // updateUI();
    // }, onTapCreateTagListener: (data) {
    //   // this.onClick("onTapCreateTagListener", data);
    // }, onTapListener: (data) {});
  }

  /**
   * 创建mission时选择tag
   */
  Future onClickSelectTag(WQBFolderModel data) async {
    // WQBSelectTagDialogUtil.show(context,
    //     title: getI18NKey().selectTag,
    //     content: '', okCallBack: (WQBFolderModel data) {
      if (Utility.isTagExist(
          tags: this.widget.wqbMissionModel.tagNames ?? [],
          tag: data.title ?? '')) {
        return;
      }
      this
          .widget
          .wqbMissionModel
          .tagNames
          ?.add({"title": data.title, "color": data.color});
      if (this.widget.saveModeEnum == SaveModeEnum.normal) {
        MongoApisManager.getInstance()
            .update_WQBMissionModel(missionModel: this.widget.wqbMissionModel);
      }
      initData();
      updateUI();
      // setState(() {
      //   this._tagColor = data.color;
      //   this._tagName = data.title;
      //   this._tagId = data.objectId;
      //   this._missionModel?.tagNames = [this._tagName].join(',');
      //   this._missionModel?.tagIds = [data.objectId].join(',');
      // });
    // }, onTapCreateTagListener: (data) {
    //   // this.onClick("onTapCreateTagListener", data);
    // }, onTapListener: (data) {});
  }

  baseBuild(context) {
    if(this.widget.sceneEnum == WQBSceneEnum.question_wrong_book) {
      return Scaffold(
        key: _scaffoldKey,
        // appBar: AppBar(
        //   // title: Text('Test Page'),
        // ),
        drawer: Drawer(
          width: ScreenUtil.getScreenW(context) * 9 / 10,
          child: getMobileWrongQuestionBookWidgetDrawer(),
        ),
        body: getMobileWrongQuestionBookWidget(),
      );
    } else {
      return Column(children: [
        this.widget.sceneEnum == WQBSceneEnum.note
            ? SizedBox.shrink()
            : SizedBox(
          height: 10,
        ),
        this.widget.sceneEnum == WQBSceneEnum.note
            ? SizedBox.shrink()
            : WQBHeaderWidget( //这个好像用不上
          text: this.widget.wqbMissionModel.title,
          onChangeListener: (data) {
            this.widget.wqbMissionModel.title = data;
            // this._title = data;
            // updateUI();
          },
          onSubmitListener: (val) {
            String title = val['inputContent'];
            this.widget.wqbMissionModel.title = title;
            if (this.widget.saveModeEnum == SaveModeEnum.normal) {
              MongoApisManager.getInstance().update_WQBMissionModel(
                  missionModel: this.widget.wqbMissionModel);
              updateUI();
            }
          },
        ),
        this.widget.sceneEnum == WQBSceneEnum.note
            ? SizedBox.shrink()
            : getBottomBar(context, isVisible: true),
        Expanded(child: getComposeEditorWidget(context))
      ],);
    }
  }

  Widget getComposeEditorWidget(context) {
    // 横向布局 左边固定300px 右边自适应
    if (this.widget.sceneEnum == WQBSceneEnum.note) {
      int tagColor = Utility.getFirstTagColorFromWQBMissionModel(
          this.widget.wqbMissionModel);
      return WQBNoteWidget(
        //底部bar 用于创建任务用
        iconCircle: this._circleIcon,
        circleTitle: this._circleTitle ?? "",
        //dateStatus 0-今天 1 明天 2 即将到来 3 待定 4 日程 5 已完成
        priority: this.widget.wqbMissionModel.priorityStatus ?? 3,
        circleColor: !TextUtil.isEmpty(this._circleColor)
            ? Color(this._circleColor ?? 0xffff8800)
            : ColorsConfig.gray_cc_cancel,
        tagName: Utility.getTagsFromWQBMissionModel(this.widget.wqbMissionModel) ?? "",
        tagColor: tagColor != null
            ? Color(tagColor ?? 0xffff8800)
            : ColorsConfig.gray_cc_cancel,
        //todo 目前用不上 可以考虑删除
        onTapPriorityListener: (data) {
              this.widget.wqbMissionModel?.priorityStatus = data;
              if(this.widget.saveModeEnum == SaveModeEnum.normal) {
                MongoApisManager.getInstance().update_WQBMissionModel(
                    missionModel: this.widget.wqbMissionModel);
              }
              initData();
              updateUI();
        },
        onTapCircleListener: (data) {
          this.onTapCircleListener(data);
          // this.onClick('onTapCircleListener', data);
        },
        onTapTagListener: (data) async {
          this.onClickSelectTag(data);
          // this.onClick('onTapTagListener', data);
        },
        key: ValueKey("ejwfi"),
        missionModel: this.widget.wqbMissionModel,
      );
    } else if (this.widget.sceneEnum == WQBSceneEnum.memorandum) {
      return Padding(padding: EdgeInsets.only(top: 10), child: getMemorandumWidget());
    } else if (this.widget.sceneEnum == WQBSceneEnum.card) {
      return getMemoryCardWidget();
      // return Padding(padding: EdgeInsets.only(top: 10), child: getMemorandumWidget());
    } else {
      return Container();
    }
  }

  WQBBottomBar getBottomBar(BuildContext context, {bool isVisible: false}) {
    int tagColor = Utility.getFirstTagColorFromWQBMissionModel(
        this.widget.wqbMissionModel);
    if(this.widget.wqbMissionModel.priorityStatus == null) {
      this.widget.wqbMissionModel.priorityStatus = 3;
    }
    return WQBBottomBar(
      key: bottomBarStateKey,
      //底部bar 用于创建任务用
      initIndexState: this.widget.wqbMissionModel.state,
      iconCircle: this._circleIcon,
      isVisible: isVisible,
      circleTitle: this._circleTitle ?? "",
      dateStatus: 0,
      //dateStatus 0-今天 1 明天 2 即将到来 3 待定 4 日程 5 已完成
      priority: this.widget.wqbMissionModel.priorityStatus ?? 3,
      circleColor: !TextUtil.isEmpty(this._circleColor)
          ? Color(this._circleColor ?? 0xffff8800)
          : ColorsConfig.gray_cc_cancel,
      tagName: Utility.getTagsFromWQBMissionModel(this.widget.wqbMissionModel) ?? "",
      tagColor: tagColor != null
          ? Color(tagColor ?? 0xffff8800)
          : ColorsConfig.gray_cc_cancel,
      onTapFinishListener: ({data}) {
        this.onClick('onClickSubmit', data);
      },
      onTapEndTimeListener: ({data}) {
        this.widget.wqbMissionModel?.update_time = data;
      },
        onTapChangeStateListener: (data) {
          this.widget.wqbMissionModel?.state = data;
          if(this.widget.saveModeEnum == SaveModeEnum.normal) {
            MongoApisManager.getInstance().update_WQBMissionModel(
                missionModel: this.widget.wqbMissionModel);
          }
          initData();
          updateUI();

        },
      //todo 目前用不上 可以考虑删除
      onTapDateListener: ({data}) {},
      onTapPriorityListener: (data) {
            // this._priorityStatus = data.data;
            this.widget.wqbMissionModel?.priorityStatus = data;
            if(this.widget.saveModeEnum == SaveModeEnum.normal) {
              MongoApisManager.getInstance().update_WQBMissionModel(
                  missionModel: this.widget.wqbMissionModel);
            }
            initData();
            updateUI();
            // Navigator.of(context).pop();
      },
      onTapCircleListener: (data) {
        this.onTapCircleListener(data);
        // this.onClick('onTapCircleListener', data);
      },
      onTapTagListener: (data) async {
        this.onClickSelectTag(data);
        // this.onClick('onTapTagListener', data);
      },
      // onChangeListener: (data) => {this._numberTomatoes = data},
    );
  }

  baseDesktoptBuild(context) {
    // 横向布局 左边固定300px 右边自适应
    if (this.widget.sceneEnum == WQBSceneEnum.note) {
      int tagColor = Utility.getFirstTagColorFromWQBMissionModel(
          this.widget.wqbMissionModel);
      return WQBNoteWidget(
        //底部bar 用于创建任务用
        iconCircle: this._circleIcon,
        circleTitle: this._circleTitle ?? "",
        //dateStatus 0-今天 1 明天 2 即将到来 3 待定 4 日程 5 已完成
        priority: this.widget.wqbMissionModel.priorityStatus ?? 3,
        circleColor: !TextUtil.isEmpty(this._circleColor)
            ? Color(this._circleColor ?? 0xffff8800)
            : ColorsConfig.gray_cc_cancel,
        tagName: Utility.getTagsFromWQBMissionModel(this.widget.wqbMissionModel) ?? "",
        tagColor: tagColor != null
            ? Color(tagColor ?? 0xffff8800)
            : ColorsConfig.gray_cc_cancel,
        //todo 目前用不上 可以考虑删除
        onTapPriorityListener: (data) {
              // this._priorityStatus = data.data;
              this.widget.wqbMissionModel?.priorityStatus = data;
              if(this.widget.saveModeEnum == SaveModeEnum.normal) {
                MongoApisManager.getInstance().update_WQBMissionModel(
                    missionModel: this.widget.wqbMissionModel);
              }
              initData();
              updateUI();
              // Navigator.of(context).pop();
        },
        onTapCircleListener: (data) {
          this.onTapCircleListener(data);
          // this.onClick('onTapCircleListener', data);
        },
        onTapTagListener: (data) async {
          this.onClickSelectTag(data);
          // this.onClick('onTapTagListener', data);
        },
        key: ValueKey("ejwfi"),
        missionModel: this.widget.wqbMissionModel,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 10,
          ),
          WQBHeaderWidget( //这个好像用不上
            text: this.widget.wqbMissionModel.title,
            onChangeListener: (data) {
              this.widget.wqbMissionModel.title = data;
              // this._title = data;
              // updateUI();
            },
            onSubmitListener: (val) {
              String title = val['inputContent'];
              this.widget.wqbMissionModel.title = title;
              if (this.widget.saveModeEnum == SaveModeEnum.normal) {
                MongoApisManager.getInstance().update_WQBMissionModel(
                    missionModel: this.widget.wqbMissionModel);
                updateUI();
              }
            },
          ),
          this.widget.sceneEnum == WQBSceneEnum.note ? SizedBox.shrink() : getBottomBar(context, isVisible: true),
          Expanded(
            child: this.widget.sceneEnum == WQBSceneEnum.card
                ? getMemoryCardWidget()
                : this.widget.sceneEnum == WQBSceneEnum.memorandum
                ? getMemorandumWidget()
                : getPCWrongQuestionBookWidget(),
          ),
        ],
      );
    }
  }

  Row getMemorandumWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 3,
                child: ContainerWidget(
                  paddingTop: 0,
                  child: WQBComposeRichEditorContainerWidget(
                    key: answerWidgetRichEditorGlobakKey,
                    saveModeEnum: this.widget.saveModeEnum,
                    onTapOk: () {},
                    wqbMissionModel: this.widget.wqbMissionModel,
                    wqbSceneEnum: WQBWrongQuestBookSceneEnum.correct_answer,
                    title: getI18NKey().memorandum,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Row getMemoryCardWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [

        Expanded(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 2,
                  child: ContainerWidget(
                    paddingTop: 0,
                    child: WQBComposeRichEditorContainerWidget(
                      key: questionWidgetRichEditorGlobakKey,
                      saveModeEnum: this.widget.saveModeEnum,
                      onTapOk: () {},
                      wqbMissionModel: this.widget.wqbMissionModel,
                      wqbSceneEnum: WQBWrongQuestBookSceneEnum.question_wrong_question,
                      title: getI18NKey().front_card,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ContainerWidget(
                    paddingTop: 0,
                    child: WQBComposeRichEditorContainerWidget(
                      key: answerWidgetRichEditorGlobakKey,
                      saveModeEnum: this.widget.saveModeEnum,
                      onTapOk: () {},
                      wqbMissionModel: this.widget.wqbMissionModel,
                      wqbSceneEnum: WQBWrongQuestBookSceneEnum.correct_answer,
                      title: getI18NKey().back_card,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget getMobileWrongQuestionBookWidgetDrawer() {
    return  Container(
      // width: 400,
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // WQBContainerTitleWidget(title: ''),
            // ContainerWidget(
            //     paddingTop: 0,
            //     child: WQBReviceDateListView(
            //       flomoMissionModel: flomoMissionModel,
            //     )),

            ContainerWidget(
                paddingTop: 0,
                child: WQBMasteringSiturationWidget(
                  wqbMissionModel: this.widget.wqbMissionModel,
                  saveModeEnum: this.widget.saveModeEnum,
                )),
            ContainerWidget(
                paddingTop: 0,
                child: WQBResultListView(
                  wqbMissionModel: this.widget.wqbMissionModel,
                  saveModeEnum: this.widget.saveModeEnum,
                )),

            ContainerWidget(
                paddingTop: 0,
                child: WQBTagsGridViewWidget(
                  onTapAddTagListener: (data) {
                    this.onClickSelectTag(data);
                  },
                  onTapSelectedListener: (data) {
                    // WQBFolderModel folderModel = data;
                  },
                  wqbMissionModel: this.widget.wqbMissionModel,
                )),
            Container(
              height: 400,
              child: ContainerWidget(
                paddingTop: 0,
                child: WQBComposeRichEditorContainerWidget(
                  title: getI18NKey().wrong_question_knowledge_points,
                  onTapOk: () {},
                  wqbMissionModel: this.widget.wqbMissionModel,
                  saveModeEnum: this.widget.saveModeEnum,
                  key: knowledgeRichEditorGlobakKey,
                  wqbSceneEnum: WQBWrongQuestBookSceneEnum.knowledge_point,
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget getMobileWrongQuestionBookWidget() {
    return
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              getBottomBar(context, isVisible: true),
              Flexible(
                flex: 2,
                child: ContainerWidget(
                  paddingTop: 0,
                  child: WQBComposeRichEditorContainerWidget(
                    key: questionWidgetRichEditorGlobakKey,
                    saveModeEnum: this.widget.saveModeEnum,
                    onTapOk: () {},
                    wqbMissionModel: this.widget.wqbMissionModel,
                    wqbSceneEnum: WQBWrongQuestBookSceneEnum.question_wrong_question,
                    title: getI18NKey().question_mistake,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ContainerWidget(
                  paddingTop: 0,
                  child: WQBComposeRichEditorContainerWidget(
                    key: answerWidgetRichEditorGlobakKey,
                    saveModeEnum: this.widget.saveModeEnum,
                    onTapOk: () {},
                    wqbMissionModel: this.widget.wqbMissionModel,
                    wqbSceneEnum: WQBWrongQuestBookSceneEnum.correct_answer,
                    title: getI18NKey().normal_solution,
                  ),
                ),
              )
            ],
          ),
        );
  }

  Row getPCWrongQuestionBookWidget() {
    return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 400,
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // WQBContainerTitleWidget(title: ''),
                    // ContainerWidget(
                    //     paddingTop: 0,
                    //     child: WQBReviceDateListView(
                    //       flomoMissionModel: flomoMissionModel,
                    //     )),

                    ContainerWidget(
                        paddingTop: 0,
                        child: WQBMasteringSiturationWidget(
                          wqbMissionModel: this.widget.wqbMissionModel,
                          saveModeEnum: this.widget.saveModeEnum,
                        )),
                    ContainerWidget(
                        paddingTop: 0,
                        child: WQBResultListView(
                          wqbMissionModel: this.widget.wqbMissionModel,
                          saveModeEnum: this.widget.saveModeEnum,
                        )),

                    ContainerWidget(
                        paddingTop: 0,
                        child: WQBTagsGridViewWidget(
                          onTapAddTagListener: (data) {
                            this.onClickSelectTag(data);
                          },
                          onTapSelectedListener: (data) {
                            // WQBFolderModel folderModel = data;
                          },
                          wqbMissionModel: this.widget.wqbMissionModel,
                        )),
                    Container(
                      height: 400,
                      child: ContainerWidget(
                        paddingTop: 0,
                        child: WQBComposeRichEditorContainerWidget(
                          title: getI18NKey().wrong_question_knowledge_points,
                          onTapOk: () {},
                          wqbMissionModel: this.widget.wqbMissionModel,
                          saveModeEnum: this.widget.saveModeEnum,
                          key: knowledgeRichEditorGlobakKey,
                          wqbSceneEnum: WQBWrongQuestBookSceneEnum.knowledge_point,
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 2,
                      child: ContainerWidget(
                        paddingTop: 0,
                        child: WQBComposeRichEditorContainerWidget(
                          key: questionWidgetRichEditorGlobakKey,
                          saveModeEnum: this.widget.saveModeEnum,
                          onTapOk: () {},
                          wqbMissionModel: this.widget.wqbMissionModel,
                          wqbSceneEnum: WQBWrongQuestBookSceneEnum.question_wrong_question,
                          title: getI18NKey().question_mistake,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: ContainerWidget(
                        paddingTop: 0,
                        child: WQBComposeRichEditorContainerWidget(
                          key: answerWidgetRichEditorGlobakKey,
                          saveModeEnum: this.widget.saveModeEnum,
                          onTapOk: () {},
                          wqbMissionModel: this.widget.wqbMissionModel,
                          wqbSceneEnum: WQBWrongQuestBookSceneEnum.correct_answer,
                          title: getI18NKey().normal_solution,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        );
  }
}
