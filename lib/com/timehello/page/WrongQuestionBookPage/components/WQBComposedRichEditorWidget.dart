import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/BlackCheckButtonListWidget.dart';
import 'package:time_hello/com/timehello/components/EmptyWidget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/page/WrongQuestionBookPage/components/WQBImageWidget.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../components/ImagesWrapperWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../models/CheckButtonStateModel.dart';
import '../../../models/WQBMissionModel.dart';
import '../../AppFlowyPage/AppflowyPage.dart';
import '../../statisticPage/components/TitleContainerWidget.dart';
import '../WQBReadOnlyPage.dart';
import 'WQBAudioRecordListWidget.dart';
import 'WQBRichEditorPage.dart';
import 'WQPlainTextWidget.dart';

/**
 * 组合的富文本编辑器
 */
class WQBComposedRichEditorWidget extends StatefulWidget {
  String title;
  SaveModeEnum saveModeEnum;
  Function onTapOk;
  WQBMissionModel wqbMissionModel;
  WQBWrongQuestBookSceneEnum wqbSceneEnum = WQBWrongQuestBookSceneEnum.knowledge_point;

  WQBComposedRichEditorWidget(
      {Key? key,
      required this.onTapOk,
      required this.wqbSceneEnum,
      required this.title,
      required this.saveModeEnum,
      required this.wqbMissionModel})
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
    return WQBComposedRichEditorWidgetState(
        saveModeEnum: this.saveModeEnum,
        wqbMissionModelTmp: this.wqbMissionModel);
  }
}

class WQBComposedRichEditorWidgetState
    extends State<WQBComposedRichEditorWidget> {
  SaveModeEnum saveModeEnum = SaveModeEnum.save;
  WQBMissionModel wqbMissionModel = WQBMissionModel();
  List<CheckButtonStateModel> blackButtonListForReading = CONSTANTS.getWQBEditTypeModelList();
  GlobalKey<BlackCheckButtonListWidgetState>
      localKeyBlackCheckButtonListWidget =
      GlobalKey<BlackCheckButtonListWidgetState>();
  // GlobalKey<HeaderNavBarState> localKeyHeaderNavBar =
  // GlobalKey<HeaderNavBarState>();
  AppflowyPage? appflowyPage;
  // image,
  // record,
  // plain_text,
  // rich_text
  WQBEditModeEnum editModeEnum = WQBEditModeEnum.new_rich_text;

  WQBComposedRichEditorWidgetState(
      {required this.saveModeEnum,
      required WQBMissionModel wqbMissionModelTmp}) {
    if (wqbMissionModelTmp != null)
      wqbMissionModel = WQBMissionModel.fromJson(wqbMissionModelTmp.toJson());
  }

  GlobalKey<WQBRichEditorPageState> localKeyWQBRichEditorPageState =
      GlobalKey<WQBRichEditorPageState>();

  @override
  void initState() {
    // editModeEnum = getEditModeEnum();
    // blackButtonListForReading = blackButtonListForReading;
  }

  @override
  void didUpdateWidget(WQBComposedRichEditorWidget oldWidget) {
    //如果有新数据会走这里 加了页面刷新数据会被清空
    if (this.widget.wqbMissionModel != null && this.widget.wqbMissionModel.objectId != this.wqbMissionModel.objectId) {
      wqbMissionModel =
          WQBMissionModel.fromJson(this.widget.wqbMissionModel.toJson());
      // this.saveModeEnum = SaveModeEnum.save;
      this.editModeEnum = getEditModeEnum();
      jumpToTabIndexForEditMode(0);
    }
    // blackButtonListForReading = blackButtonListForReading;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(mainAxisSize: MainAxisSize.max, children: [
      TitleContainerWidget(
          title: this.widget.title,
          rightPartContainer: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              getBlackChecnButtonListWidget(),
              SizedBox(
                width: 10,
              ),
              // InkWell(
              //   onTap: () async {
              //     //保存走这里
              //     // if (saveModeEnum == SaveModeEnum.normal) {
              //     //   // saveModeEnum = SaveModeEnum.update;
              //     //   jumpToTabIndexForEditMode(0);
              //     // } else if (saveModeEnum == SaveModeEnum.update) {
              //     //   await globalSave();
              //     //   if (this.widget.saveModeEnum == SaveModeEnum.normal) {
              //     //     await MongoApisManager.getInstance()
              //     //         .update_WQBMissionModel(
              //     //             missionModel: this.widget.wqbMissionModel);
              //     //   }
              //     // }
              //     // blackButtonListForReading = blackButtonListForReading;
              //     // jumpToTabIndexForNormal(0);
              //     updateUi();
              //     // this.widget.onTapEdit.call();
              //   },
              //   child: saveModeEnum == SaveModeEnum.save
              //       ? SizedBox.shrink()
              //       : Text(
              //           saveModeEnum == SaveModeEnum.normal
              //               ? getI18NKey().edit
              //               : getI18NKey().save,
              //           style: TextStyle(color: Colors.red, fontSize: 12),
              //         ),
              // ),
              // SizedBox(
              //   width: 10,
              // ),
              InkWell(
                onTap: () => {
                if(mounted) {
                  setState(() {
                    this.wqbMissionModel = WQBMissionModel.fromJson(
                        this.widget.wqbMissionModel.toJson());
                    if (saveModeEnum == SaveModeEnum.normal) {
                      // saveModeEnum = SaveModeEnum.update;
                    } else if (saveModeEnum == SaveModeEnum.update) {
                      blackButtonListForReading =
                          blackButtonListForReading;
                      jumpToTabIndexForNormal(0);
                      // saveModeEnum = SaveModeEnum.normal;
                    }
                  })
                }
                },
                child: (saveModeEnum == SaveModeEnum.normal ||
                        saveModeEnum == SaveModeEnum.save)
                    ? SizedBox.shrink()
                    : Text(
                        getI18NKey().cancel,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
              )
            ],
          )),
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
    // blackButtonListForReading = blackButtonListForReading;
    setState(() {});
  }

  Future<WQBMissionModel> globalSave() async {
    setEditType();
    //保存
    if (localKeyWQBRichEditorPageState.currentState != null) {
      //有富文本
      var val = await localKeyWQBRichEditorPageState.currentState?.save();
      this.save(val);
      return this.widget.wqbMissionModel;
    } else {
      this.save({});
      return this.widget.wqbMissionModel;
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
                    blackButtonListForReading[val];
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
    // localKeyHeaderNavBar.currentState?.setCheck(index);
    updateUi();
  }

  void jumpToTabIndexForNormal(index) {
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
    switch (this.widget.wqbSceneEnum) {
      case WQBWrongQuestBookSceneEnum.knowledge_point:
        url = this.wqbMissionModel.wqbKnowledgeRichContentUrl;
        break;
      case WQBWrongQuestBookSceneEnum.question_wrong_question:
        url = this.wqbMissionModel.wqbWrongQuestionRichContentUrl;
        break;
      case WQBWrongQuestBookSceneEnum.correct_answer:
        url = this.wqbMissionModel.wqbAnswerRichContentUrl;
        break;
    }
    return Utility.getOSSOriginFromUrl(url ?? "");
  }

  void save(val) {
    switch (this.widget.wqbSceneEnum) {
      case WQBWrongQuestBookSceneEnum.knowledge_point:
        if (TextUtil.isEmpty(val['url'] ?? "") == false) {
          this.wqbMissionModel.wqbKnowledgeRichContentUrl = val['url'] ?? "";
        }
        break;
      case WQBWrongQuestBookSceneEnum.question_wrong_question:
        if (TextUtil.isEmpty(val['url'] ?? "") == false) {
          this.wqbMissionModel.wqbWrongQuestionRichContentUrl =
              val['url'] ?? "";
        }
        break;
      case WQBWrongQuestBookSceneEnum.correct_answer:
        if (TextUtil.isEmpty(val['url'] ?? "") == false) {
          this.wqbMissionModel.wqbAnswerRichContentUrl = val['url'] ?? "";
        }
        break;
    }
    switch (this.widget.wqbSceneEnum) {
      case WQBWrongQuestBookSceneEnum.knowledge_point:
        this.widget.wqbMissionModel.wqbTypeKnowledgePoint =
            this.wqbMissionModel.wqbTypeKnowledgePoint;
        this.widget.wqbMissionModel.wqbKnowledgeContent =
            this.wqbMissionModel.wqbKnowledgeContent;
        this.widget.wqbMissionModel.wqbKnowledgeRichContentUrl =
            this.wqbMissionModel.wqbKnowledgeRichContentUrl;
        this.widget.wqbMissionModel.wqbKnowledgeRecordUrls =
            this.wqbMissionModel.wqbKnowledgeRecordUrls;
        this.widget.wqbMissionModel.wqbKnowledgeSmallUrls =
            this.wqbMissionModel.wqbKnowledgeSmallUrls;
        this.widget.wqbMissionModel.wqbKnowledgeBigUrls =
            this.wqbMissionModel.wqbKnowledgeBigUrls;
        this.widget.wqbMissionModel.wqbKnowledgeOriginUrls =
            this.wqbMissionModel.wqbKnowledgeOriginUrls;
        break;
      case WQBWrongQuestBookSceneEnum.question_wrong_question:
        this.widget.wqbMissionModel.wqbTypeWrongQuestion =
            this.wqbMissionModel.wqbTypeWrongQuestion;
        this.widget.wqbMissionModel.wqbWrongQuestionContent =
            this.wqbMissionModel.wqbWrongQuestionContent;
        this.widget.wqbMissionModel.wqbWrongQuestionRichContentUrl =
            this.wqbMissionModel.wqbWrongQuestionRichContentUrl;
        this.widget.wqbMissionModel.wqbWrongQuestionRecordUrls =
            this.wqbMissionModel.wqbWrongQuestionRecordUrls;
        this.widget.wqbMissionModel.wqbWrongQuestionSmallUrls =
            this.wqbMissionModel.wqbWrongQuestionSmallUrls;
        this.widget.wqbMissionModel.wqbWrongQuestionBigUrls =
            this.wqbMissionModel.wqbWrongQuestionBigUrls;
        this.widget.wqbMissionModel.wqbWrongQuestionOriginUrls =
            this.wqbMissionModel.wqbWrongQuestionOriginUrls;

        break;
      case WQBWrongQuestBookSceneEnum.correct_answer:
        this.widget.wqbMissionModel.wqbTypeAnswer =
            this.wqbMissionModel.wqbTypeAnswer;
        this.widget.wqbMissionModel.wqbAnswerRecordUrls =
            this.wqbMissionModel.wqbAnswerRecordUrls;
        this.widget.wqbMissionModel.wqbAnswerSmallUrls =
            this.wqbMissionModel.wqbAnswerSmallUrls;
        this.widget.wqbMissionModel.wqbAnswerBigUrls =
            this.wqbMissionModel.wqbAnswerBigUrls;
        this.widget.wqbMissionModel.wqbAnswerOriginUrls =
            this.wqbMissionModel.wqbAnswerOriginUrls;
        this.widget.wqbMissionModel.wqbAnswerContent =
            this.wqbMissionModel.wqbAnswerContent;
        this.widget.wqbMissionModel.wqbAnswerRichContentUrl =
            this.wqbMissionModel.wqbAnswerRichContentUrl;
        break;
    }
    wqbMissionModel =
        WQBMissionModel.fromJson(this.widget.wqbMissionModel.toJson());
    // onResult?.call(wqbMissionModel);
    Future.delayed(Duration(seconds: 1), () {
      updateUi();
      // saveModeEnum = SaveModeEnum.normal;
    });
  }

  void setRichContentUrl(String url) {
    switch (this.widget.wqbSceneEnum) {
      case WQBWrongQuestBookSceneEnum.knowledge_point:
        this.wqbMissionModel.wqbKnowledgeRichContentUrl = url;
        break;
      case WQBWrongQuestBookSceneEnum.question_wrong_question:
        this.wqbMissionModel.wqbWrongQuestionRichContentUrl = url;
        break;
      case WQBWrongQuestBookSceneEnum.correct_answer:
        this.wqbMissionModel.wqbAnswerRichContentUrl = url;
        break;

    }
    updateUi();
  }

  List<CheckButtonStateModel> getWQBEditTypeModelList() {
    List<CheckButtonStateModel> list = [];
    if (this.widget.wqbSceneEnum == WQBWrongQuestBookSceneEnum.knowledge_point) {
      if ((this.wqbMissionModel.wqbKnowledgeSmallUrls?.length ?? 0) > 0) {
        list.add(CheckButtonStateModel(
            code: "image", title: getI18NKey().image, isCheck: true));
      }
      if (this.wqbMissionModel.wqbKnowledgeRecordUrls.length > 0) {
        list.add(CheckButtonStateModel(
            code: "record", title: getI18NKey().record, isCheck: false));
      }
      if (!TextUtil.isEmpty(this.wqbMissionModel.wqbKnowledgeContent)) {
        list.add(CheckButtonStateModel(
            code: "plain_text",
            title: getI18NKey().plain_text,
            isCheck: false));
      }
      if (!TextUtil.isEmpty(this.wqbMissionModel.wqbKnowledgeRichContentUrl)) {
        list.add(CheckButtonStateModel(
            code: "rich_text", title: getI18NKey().rich_text, isCheck: false));
      }
    } else if (this.widget.wqbSceneEnum ==
        WQBWrongQuestBookSceneEnum.question_wrong_question) {
      if ((this.wqbMissionModel.wqbWrongQuestionSmallUrls?.length ?? 0) > 0) {
        list.add(CheckButtonStateModel(
            code: "image", title: getI18NKey().image, isCheck: true));
      }
      if (this.wqbMissionModel.wqbWrongQuestionRecordUrls.length > 0) {
        list.add(CheckButtonStateModel(
            code: "record", title: getI18NKey().record, isCheck: false));
      }
      if (!TextUtil.isEmpty(this.wqbMissionModel.wqbWrongQuestionContent)) {
        list.add(CheckButtonStateModel(
            code: "plain_text",
            title: getI18NKey().plain_text,
            isCheck: false));
      }
      if (!TextUtil.isEmpty(
          this.wqbMissionModel.wqbWrongQuestionRichContentUrl)) {
        list.add(CheckButtonStateModel(
            code: "rich_text", title: getI18NKey().rich_text, isCheck: false));
      }
    } else {
      if ((this.wqbMissionModel.wqbAnswerSmallUrls?.length ?? 0) > 0) {
        list.add(CheckButtonStateModel(
            code: "image", title: getI18NKey().image, isCheck: true));
      }
      if (this.wqbMissionModel.wqbAnswerRecordUrls.length > 0) {
        list.add(CheckButtonStateModel(
            code: "record", title: getI18NKey().record, isCheck: false));
      }
      if (!TextUtil.isEmpty(this.wqbMissionModel.wqbAnswerContent)) {
        list.add(CheckButtonStateModel(
            code: "plain_text",
            title: getI18NKey().plain_text,
            isCheck: false));
      }
      if (!TextUtil.isEmpty(this.wqbMissionModel.wqbAnswerRichContentUrl)) {
        list.add(CheckButtonStateModel(
            code: "rich_text", title: getI18NKey().rich_text, isCheck: false));
      }
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
    // if (this.widget.wqbSceneEnum == WQBSceneEnum.knowledge_point) {
    //   return this.wqbMissionModel.wqbTypeKnowledgePoint;
    // } else if (this.widget.wqbSceneEnum ==
    //     WQBSceneEnum.question_wrong_question) {
    //   return this.wqbMissionModel.wqbTypeWrongQuestion;
    // } else {
    //   return this.wqbMissionModel.wqbTypeAnswer;
    // }
  }

  WQBEditModeEnum getEditModeEnum() {
    // if (this.saveModeEnum == SaveModeEnum.normal) {
    //   if (this.widget.wqbSceneEnum == WQBWrongQuestBookSceneEnum.knowledge_point) {
    //     if ((this.wqbMissionModel.wqbKnowledgeSmallUrls?.length ?? 0) > 0) {
    //       return WQBEditModeEnum.image;
    //     }
    //     if (this.wqbMissionModel.wqbKnowledgeRecordUrls.length > 0) {
    //       return WQBEditModeEnum.record;
    //     }
    //     if (!TextUtil.isEmpty(this.wqbMissionModel.wqbKnowledgeContent)) {
    //       return WQBEditModeEnum.plain_text;
    //     }
    //     if (!TextUtil.isEmpty(
    //         this.wqbMissionModel.wqbKnowledgeRichContentUrl)) {
    //       return WQBEditModeEnum.rich_text;
    //     }
    //   } else if (this.widget.wqbSceneEnum ==
    //       WQBWrongQuestBookSceneEnum.question_wrong_question) {
    //     if ((this.wqbMissionModel.wqbWrongQuestionSmallUrls?.length ?? 0) > 0) {
    //       return WQBEditModeEnum.image;
    //     }
    //     if (this.wqbMissionModel.wqbWrongQuestionRecordUrls.length > 0) {
    //       return WQBEditModeEnum.record;
    //     }
    //     if (!TextUtil.isEmpty(this.wqbMissionModel.wqbWrongQuestionContent)) {
    //       return WQBEditModeEnum.plain_text;
    //     }
    //     if (!TextUtil.isEmpty(
    //         this.wqbMissionModel.wqbWrongQuestionRichContentUrl)) {
    //       return WQBEditModeEnum.rich_text;
    //     }
    //   } else {
    //     if ((this.wqbMissionModel.wqbAnswerSmallUrls?.length ?? 0) > 0) {
    //       return WQBEditModeEnum.image;
    //     }
    //     if (this.wqbMissionModel.wqbAnswerRecordUrls.length > 0) {
    //       return WQBEditModeEnum.record;
    //     }
    //     if (!TextUtil.isEmpty(this.wqbMissionModel.wqbAnswerContent)) {
    //       return WQBEditModeEnum.plain_text;
    //     }
    //     if (!TextUtil.isEmpty(this.wqbMissionModel.wqbAnswerRichContentUrl)) {
    //       return WQBEditModeEnum.rich_text;
    //     }
    //
    //   }
    // } else {
      if (this.widget.wqbSceneEnum == WQBWrongQuestBookSceneEnum.knowledge_point) {
        if (this.wqbMissionModel.wqbTypeKnowledgePoint == 0) {
          return WQBEditModeEnum.image;
        } else if (this.wqbMissionModel.wqbTypeKnowledgePoint == 1) {
          return WQBEditModeEnum.record;
        } else if (this.wqbMissionModel.wqbTypeKnowledgePoint == 2) {
          return WQBEditModeEnum.plain_text;
        } else if (this.wqbMissionModel.wqbTypeKnowledgePoint == 3) {
          return WQBEditModeEnum.rich_text;
        } else if (this.wqbMissionModel.wqbTypeKnowledgePoint == 4) {
          // 新富文本
          return WQBEditModeEnum.new_rich_text;
        }
      } else if (this.widget.wqbSceneEnum ==
          WQBWrongQuestBookSceneEnum.question_wrong_question) {
        if (this.wqbMissionModel.wqbTypeWrongQuestion == 0) {
          return WQBEditModeEnum.image;
        } else if (this.wqbMissionModel.wqbTypeWrongQuestion == 1) {
          return WQBEditModeEnum.record;
        } else if (this.wqbMissionModel.wqbTypeWrongQuestion == 2) {
          return WQBEditModeEnum.plain_text;
        } else if (this.wqbMissionModel.wqbTypeWrongQuestion == 3) {
          return WQBEditModeEnum.rich_text;
        } else if (this.wqbMissionModel.wqbTypeWrongQuestion == 4) {
          // 新富文本
          return WQBEditModeEnum.new_rich_text;
        }
      } else {
        if (this.wqbMissionModel.wqbTypeAnswer == 0) {
          return WQBEditModeEnum.image;
        } else if (this.wqbMissionModel.wqbTypeAnswer == 1) {
          return WQBEditModeEnum.record;
        } else if (this.wqbMissionModel.wqbTypeAnswer == 2) {
          return WQBEditModeEnum.plain_text;
        } else if (this.wqbMissionModel.wqbTypeAnswer == 3) {
          return WQBEditModeEnum.rich_text;
        } else if (this.wqbMissionModel.wqbTypeAnswer == 4) {
          // 新富文本
          return WQBEditModeEnum.new_rich_text;
        }
      }
    // }
    return WQBEditModeEnum.none;
  }

  void saveLeave() async {
    await globalSave();
    // if (this.widget.saveModeEnum == SaveModeEnum.normal) {
      await MongoApisManager.getInstance()
          .update_WQBMissionModel(
          missionModel: this.widget.wqbMissionModel);
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // saveLeave();
  }

  /**
   * 这个应该用不上 因为默认展示第一个了
   */
  // 0 图片 1 录音 2 纯文本 3 富文本
  void setEditType() {
    switch (this.widget.wqbSceneEnum) {
      case WQBWrongQuestBookSceneEnum.knowledge_point:
        if (this.editModeEnum == WQBEditModeEnum.image) {
          this.wqbMissionModel.wqbTypeKnowledgePoint = 0;
        } else if (this.editModeEnum == WQBEditModeEnum.record) {
          this.wqbMissionModel.wqbTypeKnowledgePoint = 1;
        } else if (this.editModeEnum == WQBEditModeEnum.plain_text) {
          this.wqbMissionModel.wqbTypeKnowledgePoint = 2;
        } else if (this.editModeEnum == WQBEditModeEnum.rich_text) {
          this.wqbMissionModel.wqbTypeKnowledgePoint = 3;
        } else if (this.editModeEnum == WQBEditModeEnum.new_rich_text) {
          // 新富文本
          this.wqbMissionModel.wqbTypeKnowledgePoint = 4;
        }
        break;
      case WQBWrongQuestBookSceneEnum.question_wrong_question:
        if (this.editModeEnum == WQBEditModeEnum.image) {
          this.wqbMissionModel.wqbTypeWrongQuestion = 0;
        } else if (this.editModeEnum == WQBEditModeEnum.record) {
          this.wqbMissionModel.wqbTypeWrongQuestion = 1;
        } else if (this.editModeEnum == WQBEditModeEnum.plain_text) {
          this.wqbMissionModel.wqbTypeWrongQuestion = 2;
        } else if (this.editModeEnum == WQBEditModeEnum.rich_text) {
          this.wqbMissionModel.wqbTypeWrongQuestion = 3;
        } else if (this.editModeEnum == WQBEditModeEnum.new_rich_text) {
          // 新富文本
          this.wqbMissionModel.wqbTypeWrongQuestion = 4;
        }
        break;
      case WQBWrongQuestBookSceneEnum.correct_answer:
        if (this.editModeEnum == WQBEditModeEnum.image) {
          this.wqbMissionModel.wqbTypeAnswer = 0;
        } else if (this.editModeEnum == WQBEditModeEnum.record) {
          this.wqbMissionModel.wqbTypeAnswer = 1;
        } else if (this.editModeEnum == WQBEditModeEnum.plain_text) {
          this.wqbMissionModel.wqbTypeAnswer = 2;
        } else if (this.editModeEnum == WQBEditModeEnum.rich_text) {
          this.wqbMissionModel.wqbTypeAnswer = 3;
        } else if (this.editModeEnum == WQBEditModeEnum.new_rich_text) {
          // 新富文本
          this.wqbMissionModel.wqbTypeAnswer = 4;
        }
        break;
    }
  }

  List<String> getSmallImageList() {
    switch (this.widget.wqbSceneEnum) {
      case WQBWrongQuestBookSceneEnum.knowledge_point:
        return this.wqbMissionModel.wqbKnowledgeSmallUrls ?? [];
      case WQBWrongQuestBookSceneEnum.question_wrong_question:
        return this.wqbMissionModel.wqbWrongQuestionSmallUrls ?? [];
      case WQBWrongQuestBookSceneEnum.correct_answer:
        return this.wqbMissionModel.wqbAnswerSmallUrls ?? [];
    }
    return [];
  }

  List<String> getOriginalImageList() {
    switch (this.widget.wqbSceneEnum) {
      case WQBWrongQuestBookSceneEnum.knowledge_point:
        return this.wqbMissionModel.wqbKnowledgeOriginUrls ?? [];
      case WQBWrongQuestBookSceneEnum.question_wrong_question:
        return this.wqbMissionModel.wqbWrongQuestionOriginUrls ?? [];
      case WQBWrongQuestBookSceneEnum.correct_answer:
        return this.wqbMissionModel.wqbAnswerOriginUrls ?? [];
    }
    return [];
  }

  List<String> getBigImageList() {
    switch (this.widget.wqbSceneEnum) {
      case WQBWrongQuestBookSceneEnum.knowledge_point:
        return this.wqbMissionModel.wqbKnowledgeBigUrls ?? [];
      case WQBWrongQuestBookSceneEnum.question_wrong_question:
        return this.wqbMissionModel.wqbWrongQuestionBigUrls ?? [];
      case WQBWrongQuestBookSceneEnum.correct_answer:
        return this.wqbMissionModel.wqbAnswerBigUrls ?? [];
    }
    return [];
  }

  void setImageList(
      {required List<String> smallImageList,
      required List<String> originalImageList,
      required List<String> bigImageList}) {
    switch (this.widget.wqbSceneEnum) {
      case WQBWrongQuestBookSceneEnum.knowledge_point:
        this.wqbMissionModel.wqbKnowledgeSmallUrls = smallImageList;
        this.wqbMissionModel.wqbKnowledgeBigUrls = bigImageList;
        this.wqbMissionModel.wqbKnowledgeOriginUrls = originalImageList;
        break;
      case WQBWrongQuestBookSceneEnum.question_wrong_question:
        this.wqbMissionModel.wqbWrongQuestionSmallUrls = smallImageList;
        this.wqbMissionModel.wqbWrongQuestionBigUrls = bigImageList;
        this.wqbMissionModel.wqbWrongQuestionOriginUrls = originalImageList;
        break;
      case WQBWrongQuestBookSceneEnum.correct_answer:
        this.wqbMissionModel.wqbAnswerSmallUrls = smallImageList;
        this.wqbMissionModel.wqbAnswerBigUrls = bigImageList;
        this.wqbMissionModel.wqbAnswerOriginUrls = originalImageList;
        break;
    }
    updateUi();
  }

  Widget getWidget() {
    print(
        "editModeEnum:${this.editModeEnum}, editTypeEnum:${this.saveModeEnum}, smallImageList:${this.getSmallImageList().length}, bigImageList:${this.getBigImageList().length}, originalImageList:${this.getOriginalImageList().length}");
    if (this.editModeEnum == WQBEditModeEnum.new_rich_text) {
      // if(appflowyPage == null) {
      // if(!TextUtil.isEmpty(this.widget.missionModel.objectId)) {
      return appflowyPage =
          AppflowyPage(fileName: this.widget.wqbMissionModel.objectId ?? "");
      // }
      // } else {
      //   return appflowyPage!;
      // }
    } else if (this.editModeEnum == WQBEditModeEnum.image) {
      return
      ImagesWrapperWidget(
              isEditable: true,
              listBigImages: this.getSmallImageList(),
              // listBigImages: this.getBigImageList(),
              // listOriginImages: this.getOriginalImageList(),
              onChange: (listOriginImages, listSmallImages, listBigImages) {
                this.setImageList(
                    smallImageList: listSmallImages,
                    originalImageList: listOriginImages,
                    bigImageList: listBigImages);
                saveLeave();
              },
            );
    } else if (this.editModeEnum == WQBEditModeEnum.plain_text) {
      return WQPlainTextWidget(
        wqbMissionModel: this.wqbMissionModel,
        editTypeEnum: saveModeEnum,
        wqbSceneEnum: this.widget.wqbSceneEnum,
      );
    } else if (this.editModeEnum == WQBEditModeEnum.rich_text) {
      return Container(
        child: WQBReadOnlyPage(
          ossUrl: getRichContentUrl(),
          richTextModeEnum: RichTextModeEnum.note,
        ),
      );
      // return Container(
      //   child:WQBRichEditorPage(
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
        onChange: (){
          saveLeave();
        },
        wqbMissionModel: this.wqbMissionModel,
        saveModeEnum: SaveModeEnum.save,
        wqbSceneEnum: this.widget.wqbSceneEnum,
      );
    }
    return EmptyWidget();
  }
}
