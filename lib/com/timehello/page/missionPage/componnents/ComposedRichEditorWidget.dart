import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/components/BlackCheckButtonListWidget.dart';
import 'package:time_hello/com/timehello/components/EmptyWidget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/page/AppFlowyPage/components/HeaderNavBar.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/RedisStoreManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../components/ImagesWrapperWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../models/CheckButtonStateModel.dart';
import '../../../models/MissionModel.dart';
import '../../AppFlowyPage/AppflowyPage.dart';
import '../../WrongQuestionBookPage/WQBReadOnlyPage.dart';
import '../../WrongQuestionBookPage/components/WQBAudioRecordListWidget.dart';
import '../../WrongQuestionBookPage/components/WQBRichEditorPage.dart';
import '../../WrongQuestionBookPage/components/WQPlainTextWidget.dart';
import '../../statisticPage/components/TitleContainerWidget.dart';
import 'NoteWidget.dart';

/**
 * 组合的富文本编辑器
 */
class ComposedRichEditorWidget extends StatefulWidget {
  String title;
  SaveModeEnum saveModeEnum;
  Function onTapOk;
  MissionModel missionModel;
  FocusNode? focusNode;

  // WQBWrongQuestBookSceneEnum wqbSceneEnum = WQBWrongQuestBookSceneEnum.knowledge_point;

  ComposedRichEditorWidget(
      {Key? key,
      required this.onTapOk,
      // required this.wqbSceneEnum,
        this.focusNode,
      required this.title,
      required this.saveModeEnum,
      required this.missionModel})
      : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return Expanded(
  //       child: this.editTypeEnum == EditTypeEnum.readOnly ? WQBReadOnlyPage(
  //     richTextModeEnum: RichTextModeEnum.note,
  //   ) : WQBRichEditorPage(richTextModeEnum: RichTextModeEnum.note,));
  // }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ComposedRichEditorWidgetState(
        saveModeEnum: this.saveModeEnum, missionModelTmp: this.missionModel);
  }
}

class ComposedRichEditorWidgetState extends State<ComposedRichEditorWidget> {
  SaveModeEnum saveModeEnum;
  MissionModel missionModel = MissionModel();
  List<CheckButtonStateModel> blackButtonListForReading =
      CONSTANTS.getWQBEditTypeModelList();
  GlobalKey<BlackCheckButtonListWidgetState>
      localKeyBlackCheckButtonListWidget =
      GlobalKey<BlackCheckButtonListWidgetState>();
  GlobalKey<HeaderNavBarState> localKeyHeaderNavBar =
      GlobalKey<HeaderNavBarState>();
  GlobalKey<AppflowyPageState> appflowyPageStateKey =
      GlobalKey<AppflowyPageState>();
  AppflowyPage? appflowyPage;

  // image,
  // record,
  // plain_text,
  // rich_text
  WQBEditModeEnum editModeEnum = WQBEditModeEnum.new_rich_text;

  ComposedRichEditorWidgetState(
      {required this.saveModeEnum, required MissionModel missionModelTmp}) {
    if (missionModelTmp != null)
      missionModel = MissionModel.fromJson(missionModelTmp.toJson());
  }

  GlobalKey<WQBRichEditorPageState> localKeyWQBRichEditorPageState =
      GlobalKey<WQBRichEditorPageState>();

  @override
  void initState() {
    // String slashPlaceHolder = getI18NKey().slashPlaceHolder;
    editModeEnum = getEditModeEnum();
    // AppFlowyEditorLocalizations.delegate.load(const Locale('zh', 'CN'));
    // AppFlowyEditorLocalizations.delegate.reload();
    // blackButtonListForReading = this.getWQBEditTypeModelList();
  }

  @override
  void didUpdateWidget(ComposedRichEditorWidget oldWidget) {
    //如果有新数据会走这里 加了页面刷新数据会被清空
    if (this.widget.missionModel != null &&
        this.widget.missionModel.objectId != this.missionModel.objectId) {
      missionModel = MissionModel.fromJson(this.widget.missionModel.toJson());
      // this.saveModeEnum = SaveModeEnum.normal;
      this.editModeEnum = getEditModeEnum();
      jumpToTabIndexForEditMode(0);
    }
    // blackButtonListForReading = this.getWQBEditTypeModelList();
  }

  saveFinal() async {
    await globalSave();
    if (this.widget.saveModeEnum == SaveModeEnum.normal) {
      await MongoApisManager.getInstance()
          .update_MissionModel(missionModel: this.widget.missionModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(mainAxisSize: MainAxisSize.max, children: [
      HeaderNavBar(
        key: localKeyHeaderNavBar,
        onTapListener: (index, CheckButtonStateModel model) async {
          if (model.code == "expand") {
            if (context.read<Env>().isMiddleMissionPageVisible == true) {
              Utility.setDesktopMiddileMissionPage(context, isVisible: false);
            } else {
              Utility.setDesktopMiddileMissionPage(context, isVisible: true);
            }
          } else if (model.code == "refresh") {
            appflowyPageStateKey.currentState?.initData();
            // this.saveFinal();
          } else if (model.code == "share") {
            if(!TextUtil.isEmpty(this.missionModel.newRichEditorUrl)) {
              await RedisManager.getInstance().setString(scene: "mission_note_share",
                  key: this.missionModel.objectId ?? "",
                  value: this.missionModel.newRichEditorUrl ?? "",
                  time: 60 * 60 * 24);
              String url = Urls.missionNoteSharing + (this.missionModel.objectId ?? "");
              DialogManagement.getInstance().showCopyTextDialog(context,
                  title: this.missionModel.title ?? "",
                  okCallBack: (text) {
                    Utility.popNavigator(context);
                    Utility.showToastMsg(msg: getI18NKey().copy_success);
                    Utility.copyToClipboard(url);
                  },
                  cancelCallBack: () {
                    Utility.popNavigator(context);
                  },
                  content: getI18NKey().copy_and_share_with_title(this.missionModel.title ?? "", url));
            }
            // appflowyPageStateKey.currentState?.initData();
            // this.saveFinal();
          }
          if(index >= 0) {
            jumpToTabIndexForNormal(index);
          }
        },
      ),
      Container(
          width: double.infinity,
          height: 1,
          color: ThemeManager.getInstance().getDefautThemeColor()),
      Expanded(
        child: getWidget(),
      )
    ]);
  }

  void updateUi() {
    // blackButtonListForReading = this.getWQBEditTypeModelList();
    setState(() {});
  }

  Future<MissionModel> globalSave() async {
    setEditType();
    //保存
    if (localKeyWQBRichEditorPageState.currentState != null) {
      //有富文本
      var val = await localKeyWQBRichEditorPageState.currentState?.save();
      this.save(val);
      return this.widget.missionModel;
    } else {
      this.save({});
      return this.widget.missionModel;
    }
  }

  Widget getBlackChecnButtonListWidget() {
    if (this.saveModeEnum == SaveModeEnum.update ||
        this.saveModeEnum == SaveModeEnum.save) {
      return BlackCheckButtonListWidget(
          list: blackButtonListForReading,
          initIndex: 0,
          onTapListener: (index) {
            jumpToTabIndexForEditMode(index);
          });
    } else {
      localKeyBlackCheckButtonListWidget.currentState
          ?.updateList(blackButtonListForReading);

      return blackButtonListForReading.length == 0
          ? SizedBox.shrink()
          : BlackCheckButtonListWidget(
              key: localKeyBlackCheckButtonListWidget,
              list: blackButtonListForReading,
              initIndex: getCurIndex(),
              onTapListener: (val) {
                CheckButtonStateModel checkButtonStateModel =
                    this.getWQBEditTypeModelList()[val];
                switch (checkButtonStateModel.code) {
                  case "image":
                    editModeEnum = WQBEditModeEnum.image;
                    break;
                  case "record":
                    editModeEnum = WQBEditModeEnum.record;
                    break;
                  case "plain_text":
                    editModeEnum = WQBEditModeEnum.plain_text;
                    break;
                  case "rich_text":
                    editModeEnum = WQBEditModeEnum.rich_text;
                    break;
                  case "new_rich_editor":
                    editModeEnum = WQBEditModeEnum.new_rich_text;
                    break;
                }
                setEditType();
                updateUi();
              });
    }
  }

  void jumpToTabIndexForEditMode(index) {
    CheckButtonStateModel checkButtonStateModel =
        CONSTANTS.getWQBEditTypeModelList()[index];
    switch (checkButtonStateModel.code) {
      case "image":
        editModeEnum = WQBEditModeEnum.image;
        break;
      case "record":
        editModeEnum = WQBEditModeEnum.record;
        break;
      case "plain_text":
        editModeEnum = WQBEditModeEnum.plain_text;
        break;
      case "rich_text":
        editModeEnum = WQBEditModeEnum.rich_text;
        break;
      case "new_rich_editor":
        editModeEnum = WQBEditModeEnum.new_rich_text;
        break;
    }
    setEditType();
    localKeyHeaderNavBar.currentState?.setCheck(index);
    updateUi();
  }

  void jumpToTabIndexForNormal(index) {
    unfocus()?.currentState?.unfocus();

    if (blackButtonListForReading.length > 0) {
      CheckButtonStateModel checkButtonStateModel =
          blackButtonListForReading[index];
      switch (checkButtonStateModel.code) {
        case "image":
          editModeEnum = WQBEditModeEnum.image;
          break;
        case "record":
          editModeEnum = WQBEditModeEnum.record;
          break;
        case "plain_text":
          editModeEnum = WQBEditModeEnum.plain_text;
          break;
        case "rich_text":
          editModeEnum = WQBEditModeEnum.rich_text;
          break;
        case "new_rich_editor":
          editModeEnum = WQBEditModeEnum.new_rich_text;
          break;
      }
      // setEditType();
      updateUi();
    }
  }

  String getRichContentUrl() {
    String url = "";
    url =
        Utility.getOSSOriginFromUrl(this.missionModel.noteRichContentUrl ?? "");
    // switch (this.widget.wqbSceneEnum) {
    //   case WQBWrongQuestBookSceneEnum.knowledge_point:
    //     url = this.missionModel.wqbKnowledgeRichContentUrl;
    //     break;
    //   case WQBWrongQuestBookSceneEnum.question_wrong_question:
    //     url = this.missionModel.wqbWrongQuestionRichContentUrl;
    //     break;
    //   case WQBWrongQuestBookSceneEnum.correct_answer:
    //     url = this.missionModel.wqbAnswerRichContentUrl;
    //     break;
    // }
    return url;
  }

  void save(val) {
    if (TextUtil.isEmpty(val['url'] ?? "") == false) {
      this.missionModel.noteRichContentUrl = val['url'] ?? "";
    }
    this.widget.missionModel.noteSmallUrls = this.missionModel.noteSmallUrls;
    this.widget.missionModel.noteBigUrls = this.missionModel.noteBigUrls;
    this.widget.missionModel.noteOriginUrls = this.missionModel.noteOriginUrls;
    this.widget.missionModel.notePoint = this.missionModel.notePoint;
    this.widget.missionModel.message = this.missionModel.message;
    this.widget.missionModel.noteRichContentUrl =
        this.missionModel.noteRichContentUrl;
    this.widget.missionModel.noteRecordUrls = this.missionModel.noteRecordUrls;

    // switch (this.widget.wqbSceneEnum) {
    //   case WQBWrongQuestBookSceneEnum.knowledge_point:
    //     break;
    //   case WQBWrongQuestBookSceneEnum.question_wrong_question:
    //     if (TextUtil.isEmpty(val['url'] ?? "") == false) {
    //       this.missionModel.wqbWrongQuestionRichContentUrl =
    //           val['url'] ?? "";
    //     }
    //     break;
    //   case WQBWrongQuestBookSceneEnum.correct_answer:
    //     if (TextUtil.isEmpty(val['url'] ?? "") == false) {
    //       this.missionModel.wqbAnswerRichContentUrl = val['url'] ?? "";
    //     }
    //     break;
    // }
    // switch (this.widget.wqbSceneEnum) {
    //   case WQBWrongQuestBookSceneEnum.knowledge_point:
    //
    //     break;
    //   case WQBWrongQuestBookSceneEnum.question_wrong_question:
    //     this.widget.missionModel.wqbTypeWrongQuestion =
    //         this.missionModel.wqbTypeWrongQuestion;
    //     this.widget.missionModel.wqbWrongQuestionContent =
    //         this.missionModel.wqbWrongQuestionContent;
    //     this.widget.missionModel.wqbWrongQuestionRichContentUrl =
    //         this.missionModel.wqbWrongQuestionRichContentUrl;
    //     this.widget.missionModel.wqbWrongQuestionRecordUrls =
    //         this.missionModel.wqbWrongQuestionRecordUrls;
    //     this.widget.missionModel.wqbWrongQuestionSmallUrls =
    //         this.missionModel.wqbWrongQuestionSmallUrls;
    //     this.widget.missionModel.wqbWrongQuestionBigUrls =
    //         this.missionModel.wqbWrongQuestionBigUrls;
    //     this.widget.missionModel.wqbWrongQuestionOriginUrls =
    //         this.missionModel.wqbWrongQuestionOriginUrls;
    //
    //     break;
    //   case WQBWrongQuestBookSceneEnum.correct_answer:
    //     this.widget.missionModel.wqbTypeAnswer =
    //         this.missionModel.wqbTypeAnswer;
    //     this.widget.missionModel.wqbAnswerRecordUrls =
    //         this.missionModel.wqbAnswerRecordUrls;
    //     this.widget.missionModel.wqbAnswerSmallUrls =
    //         this.missionModel.wqbAnswerSmallUrls;
    //     this.widget.missionModel.wqbAnswerBigUrls =
    //         this.missionModel.wqbAnswerBigUrls;
    //     this.widget.missionModel.wqbAnswerOriginUrls =
    //         this.missionModel.wqbAnswerOriginUrls;
    //     this.widget.missionModel.wqbAnswerContent =
    //         this.missionModel.wqbAnswerContent;
    //     this.widget.missionModel.wqbAnswerRichContentUrl =
    //         this.missionModel.wqbAnswerRichContentUrl;
    //     break;
    // }
    missionModel = MissionModel.fromJson(this.widget.missionModel.toJson());
    // onResult?.call(wqbMissionModel);
    Future.delayed(Duration(seconds: 1), () {
      updateUi();
      saveModeEnum = SaveModeEnum.normal;
    });
  }

  void setRichContentUrl(String url) {
    this.missionModel.noteRichContentUrl = url;
    // switch (this.widget.wqbSceneEnum) {
    //   case WQBWrongQuestBookSceneEnum.knowledge_point:
    //     break;
    //   case WQBWrongQuestBookSceneEnum.question_wrong_question:
    //     this.missionModel.wqbWrongQuestionRichContentUrl = url;
    //     break;
    //   case WQBWrongQuestBookSceneEnum.correct_answer:
    //     this.missionModel.wqbAnswerRichContentUrl = url;
    //     break;
    // }
    updateUi();
  }

  List<CheckButtonStateModel> getWQBEditTypeModelList() {
    List<CheckButtonStateModel> list = [];
    // if (this.widget.wqbSceneEnum == WQBWrongQuestBookSceneEnum.knowledge_point) {
    // if (!TextUtil.isEmpty(this.missionModel.message)) {
    list.add(CheckButtonStateModel(
        code: "new_rich_editor",
        title: getI18NKey().new_rich_editor,
        isCheck: true));

    list.add(CheckButtonStateModel(
        code: "plain_text", title: getI18NKey().plain_text, isCheck: false));
    // }
    if ((this.missionModel.noteSmallUrls?.length ?? 0) > 0) {
      list.add(CheckButtonStateModel(
          code: "image", title: getI18NKey().image, isCheck: false));
    }
    if ((this.missionModel.noteRecordUrls?.length ?? 0) > 0) {
      list.add(CheckButtonStateModel(
          code: "record", title: getI18NKey().record, isCheck: false));
    }

    if (!TextUtil.isEmpty(this.missionModel.noteRichContentUrl)) {
      list.add(CheckButtonStateModel(
          code: "rich_text", title: getI18NKey().rich_text, isCheck: false));
    }
    if (list.length > 0) {
      list[0].isCheck = true;
    }
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~length:${list.length}");
    return list;
  }

  int getCurIndex() {
    for (int i = 0; i < blackButtonListForReading.length; i++) {
      if (blackButtonListForReading[i].isCheck) {
        return i;
      }
    }
    return 0;
  }

  WQBEditModeEnum getEditModeEnum() {
    return WQBEditModeEnum.new_rich_text;
  }

  /**
   * 这个应该用不上 因为默认展示第一个了
   */
  // 0 图片 1 录音 2 纯文本 3 富文本
  void setEditType() {
    // switch (this.widget.wqbSceneEnum) {
    //   case WQBWrongQuestBookSceneEnum.knowledge_point:
    if (this.editModeEnum == WQBEditModeEnum.image) {
      this.missionModel.notePoint = 0;
    } else if (this.editModeEnum == WQBEditModeEnum.record) {
      this.missionModel.notePoint = 1;
    } else if (this.editModeEnum == WQBEditModeEnum.plain_text) {
      this.missionModel.notePoint = 2;
    } else if (this.editModeEnum == WQBEditModeEnum.rich_text) {
      this.missionModel.notePoint = 3;
    } else if (this.editModeEnum == WQBEditModeEnum.new_rich_text) {
      // 新富文本
      this.missionModel.notePoint = 4;
    }
  }

  List<String> getSmallImageList() {
    return this.missionModel.noteSmallUrls ?? [];
  }

  List<String> getOriginalImageList() {
    return this.missionModel.noteOriginUrls ?? [];
  }

  List<String> getBigImageList() {
    return this.missionModel.noteBigUrls ?? [];
  }

  void setImageList(
      {required List<String> smallImageList,
      required List<String> originalImageList,
      required List<String> bigImageList}) {
    this.missionModel.noteSmallUrls = smallImageList;
    this.missionModel.noteBigUrls = bigImageList;
    this.missionModel.noteOriginUrls = originalImageList;
    updateUi();
  }
  unfocus() {
    appflowyPageStateKey.currentState?.unfocus();
  }

  Widget getWidget() {
    print(
        "editModeEnum:${this.editModeEnum}, editTypeEnum:${this.saveModeEnum}, smallImageList:${this.getSmallImageList().length}, bigImageList:${this.getBigImageList().length}, originalImageList:${this.getOriginalImageList().length}");
    if (this.editModeEnum == WQBEditModeEnum.new_rich_text) {
      // if(appflowyPage == null) {
      // if(!TextUtil.isEmpty(this.widget.missionModel.objectId)) {
      return appflowyPage = AppflowyPage(
          key: appflowyPageStateKey,
          onUploadCallback: (data) async {
            if (this.missionModel.attachmentUrls == null) {
              this.missionModel.attachmentUrls = [];
            }
            if(this.missionModel.attachmentUrls?.contains(data) == false) {
              this.missionModel.attachmentUrls?.add(data);
              await MongoApisManager.getInstance().update_MissionModel(
                  shouldQueryMissionModel: false,
                  missionModel: this.missionModel);
            }
          },
          onSaveCallback: (url) async {
            if (TextUtil.isEmpty(this.missionModel?.newRichEditorUrl) ==
                true) {
              this.missionModel?.newRichEditorUrl = url;
              await MongoApisManager.getInstance().update_MissionModel(
                  shouldQueryMissionModel: false,
                  missionModel: this.missionModel);
            }
          },
          isDebug: LoginManager.isLogin() == false &&
              getI18NKey().guide1 == this.missionModel.title,
          fileName: this.missionModel.objectId ?? "");
      // }
      // } else {
      //   return appflowyPage!;
      // }
    } else if (this.editModeEnum == WQBEditModeEnum.image) {
      // this.saveModeEnum == SaveModeEnum.normal
      //     ? ImagesWrapperWidget(
      //   isEditable: false,
      //   listSmallImages: this.getSmallImageList(),
      //   listBigImages: this.getBigImageList(),
      //   listOriginImages: this.getOriginalImageList(),
      //   onChange: (listOriginImages, listSmallImages, listBigImages) {
      //     this.setImageList(
      //         smallImageList: listSmallImages,
      //         originalImageList: listOriginImages,
      //         bigImageList: listBigImages);
      //   },
      // )
      //     :
      return ImagesWrapperWidget(
        isEditable: true,
        listBigImages: this.getSmallImageList(),
        // listBigImages: this.getBigImageList(),
        // listOriginImages: this.getOriginalImageList(),
        onChange: (listOriginImages, listSmallImages, listBigImages) {
          this.setImageList(
              smallImageList: listSmallImages,
              originalImageList: listOriginImages,
              bigImageList: listBigImages);
          this.saveFinal();
        },
      );
    } else if (this.editModeEnum == WQBEditModeEnum.plain_text) {
      return NoteWidget(
          missionModel: this.missionModel, circleTitle: '', priority: 0);
    } else if (this.editModeEnum == WQBEditModeEnum.rich_text) {
      return Container(
        child: WQBReadOnlyPage(
          ossUrl: getRichContentUrl(),
          richTextModeEnum: RichTextModeEnum.note,
        ),
      );

      // return Container(
      //   child: this.saveModeEnum == SaveModeEnum.normal
      //       ? WQBReadOnlyPage(
      //           ossUrl: getRichContentUrl(),
      //           richTextModeEnum: RichTextModeEnum.note,
      //         )
      //       : WQBRichEditorPage(
      //           key: localKeyWQBRichEditorPageState,
      //           url: getRichContentUrl(),
      //           onOkListener: (data) {
      //             setRichContentUrl(data['url']);
      //           },
      //           richTextModeEnum: RichTextModeEnum.note,
      //         ),
      // );
    } else if (this.editModeEnum == WQBEditModeEnum.record) {
      return WQBAudioRecordListWidget(
        missionModel: this.missionModel,
        saveModeEnum: SaveModeEnum.save,
        wqbSceneEnum: WQBWrongQuestBookSceneEnum.none,
        onChange: () {
          this.saveFinal();
        },
      );
    }
    return EmptyWidget();
  }
}
