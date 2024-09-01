import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/SelectCashSettingDialogUtil.dart';
import 'package:time_hello/com/timehello/models/CourseModel.dart';
import 'package:time_hello/com/timehello/util/EasyLoadingManager.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

import '../../components/AvatarWidget.dart';
import '../../components/BaseWidget.dart';
import '../../components/BlackCheckButtonListWidget.dart';
import '../../components/ImagesWrapperWidget.dart';
import '../../config/CONSTANTS.dart';
import '../../config/ColorsConfig.dart';
import '../../config/ENUMS.dart';
import '../../config/Params.dart';
import '../../config/StylesConfig.dart';
import '../../libs/mongodb/response/MongoDbSaved.dart';
import '../../models/FolderModel.dart';
import '../../util/DeviceInfoManagement.dart';
import '../../util/DialogManagement.dart';
import '../../util/ThemeManager.dart';
import '../../util/Utility.dart';
import '../RichEditor/RichEditorPage.dart';

class CreateShareFolderPage extends BaseWidget {
  CourseModel? courseModel;
  FolderModel? folderModel;

  CreateShareFolderPage({CourseModel? courseModel,  this.folderModel}) {
    if (courseModel == null) {
      this.courseModel = new CourseModel();
    } else {
      this.courseModel = courseModel;
    }
  }

  @override
  BaseWidgetState<BaseWidget> getState() {
    return CreateShareFolderPageWidget();
  }
}

class CreateShareFolderPageWidget
    extends BaseWidgetState<CreateShareFolderPage> {
  String backgroundUrl = 'http://oss.timerbell.com/resourceOss/4KA壁纸102.jpg';
  double avatarWidth = 60;
  bool isRequesting = false;
  String password = "";
  int amount = 0;
  int curIndex = 0;
  final List<ImageProvider> _imageProviders = [];

  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerAuthorIntro = TextEditingController();
  TextEditingController controllerCourseIntro = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  onClickSave() async {
    this.widget.courseModel?.type = this.curIndex + 1;
    if (TextUtil.isEmpty(this.widget.courseModel?.title)) {
      Utility.showToastMsg(
          context: context,
          msg: getI18NKey().xxx_cannot_be_empty(getI18NKey().title));
      return;
    }
    // if (TextUtil.isEmpty(this.widget.courseModel?.authorIntro)) {
    //   Utility.showToast(
    //       context: context,
    //       msg: getI18NKey().xxx_cannot_be_empty(getI18NKey().author_intro));
    //   return;
    // }
    // if (TextUtil.isEmpty(this.widget.courseModel?.courseIntro)) {
    //   Utility.showToast(
    //       context: context,
    //       msg: getI18NKey().xxx_cannot_be_empty(getI18NKey().course_intro));
    //   return;
    // }
    if (this.widget.courseModel?.type == 2 &&
        TextUtil.isEmpty(this.password) == true) {
      Utility.showToastMsg(context: context, msg: getI18NKey().four_pws);
      return;
    }

    if (TextUtil.isEmpty(this.widget.courseModel?.type)) {
      Utility.showToastMsg(
          context: context,
          msg: getI18NKey().xxx_cannot_be_empty(getI18NKey().course_intro));
      return;
    }
    EasyLoadingManager.getInstance().showLoading();
    this.widget.courseModel?.courseFid = this.widget.folderModel?.objectId;
    this.widget.courseModel?.backgroundUrl = this.backgroundUrl;
    this.widget.courseModel?.languageCode = DeviceInfoManagement.getLanguage();
    this.widget.courseModel?.folderTitle = this.widget.folderModel?.title;
    this.widget.courseModel?.isEditable = this.widget.folderModel?.isOtherUserEditable;
    this.widget.courseModel?.code = Utility.generateRandomNDigitString(4);
    this.widget.courseModel?.authorAvatar =
        LoginManager.getInstance().userBean.avatar;
    this.widget.courseModel?.authorName =
        LoginManager.getInstance().userBean.username;
    if (TextUtil.isEmpty(this.widget.courseModel?.objectId)) {
      MongoDbSaved? bmobSaved = await MongoApisManager.getInstance()
          .insertCourseModel(this.widget.courseModel ?? CourseModel());
      this.widget.folderModel?.courseModelId = bmobSaved?.objectId ?? "";
      MongoApisManager.getInstance().update_FolderModelWithFM(folderModel: this.widget.folderModel ?? FolderModel());
    } else {
      await MongoApisManager.getInstance().update_CourseModel(
          this.widget.courseModel?.objectId ?? "",
          courseModel: this.widget.courseModel ?? CourseModel());
    }
    await MongoApisManager.getInstance().setFolderModelType(
        this.widget.folderModel?.objectId ?? "",
        isSharing: this.widget.courseModel?.type ?? 0, isOtherUserEditable: (this
        .widget
        .folderModel
        ?.isOtherUserEditable ?? false));
    EasyLoadingManager.getInstance().hideLoading();
    Utility.popupPagePCAndMobile(context);
  }

  @override
  void initState() {
    super.initState();
    setDatas();
  }

  Future<void> setDatas() async {
    if (!TextUtil.isEmpty(this.widget.courseModel?.objectId)) {
      controllerTitle.text = this.widget.courseModel?.title ?? "";
      controllerAuthorIntro.text = this.widget.courseModel?.authorIntro ?? "";
      controllerCourseIntro.text = this.widget.courseModel?.courseIntro ?? "";
      this.curIndex = (this.widget.courseModel?.type ?? 1) - 1;
      if (!TextUtil.isEmpty(this.widget.courseModel?.password)) {
        this.password = Utility.decryptCTRAES(
            this.widget.courseModel?.password ?? "", Params.AES_PWD);
        controllerPassword.text = this.password;
        updateUI();
      }
    }
  }

  // List listImages = [];
  // List<String> listSmallImages = [];
  // List<String> listBigImages = [];
  // List<String> listOriginImages = [];
  // late final _easyEmbeddedImageProvider = MultiImageProvider(_imageProviders);

  @override
  Widget build(BuildContext context) {
    return Container(
      // clipBehavior: Clip.antiAlias,
      // height: MediaQuery.of(context).size.height * 2 / 3,
      // width: MediaQuery.of(context).size.width * 2 / 3,
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(6),
      // ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: BlackCheckButtonListWidget(
                      // key: blackCheckButtonListWidgetGlobalKey,
                      initIndex: curIndex,
                      list: CONSTANTS.getcourseButtonList(),
                      onTapListener: (index) async {
                        this.curIndex = index;
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            getI18NKey().isEditable,
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff404040)),
                          ),
                        ),
                        BlackCheckButtonListWidget(
                          initIndex: (this
                                          .widget
                                          .folderModel
                                          ?.isOtherUserEditable !=
                                      null &&
                                  this.widget.folderModel?.isOtherUserEditable ==
                                      true)
                              ? 0
                              : 1,
                          list: CONSTANTS.getYesNoButtonList(),
                          onTapListener: (index) async {
                            this.widget.folderModel?.isOtherUserEditable =
                                (index == 0);
                            print(this.widget.folderModel?.isOtherUserEditable);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  this.curIndex != 1
                      ? SizedBox.shrink()
                      : Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 9),
                                child: Text(
                                  getI18NKey().four_pws,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 80,
                                alignment: Alignment.centerLeft,
                                // decoration: BoxDecoration(
                                //   border: Border.all(
                                //     color: Colors.red,
                                //     width: 1,
                                //   ),
                                //   borderRadius: BorderRadius.circular(20),
                                // ),
                                child: Container(
                                    width: 60,
                                    child: TextField(
                                      controller: controllerPassword,
                                      maxLength: 4,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff404040)),
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              signed: false),
                                      // focusNode: focusNode,
                                      // controller: textEditingController,
                                      cursorColor: ColorsConfig.red,
                                      onChanged: (String text) async {
                                        this.password = text;
                                        this.widget.courseModel?.password =
                                            await Utility.encryptCTRAES(
                                                text, Params.AES_PWD);
                                      },
                                      onSubmitted: (value) {
                                        print(value);
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        hintText: getI18NKey().custom,
                                        // fillColor: Colors.red,//背景颜色，必须结合filled: true,才有效
                                        // focusColor: Colors.red,
                                        // hoverColor: Colors.red,
                                        contentPadding: EdgeInsets.only(
                                            top: 15.0, bottom: 10.0),
                                        filled: true,
                                        //重点，必须设置为true，fillColor才有效
                                        isCollapsed: true,
                                        //重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
                                        focusedBorder: StylesConfig.buildOutlineInputBorder(),
                                        enabledBorder: StylesConfig.buildOutlineInputBorder(),
                                        border: StylesConfig.buildOutlineInputBorder(),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  this.curIndex != 2
                      ? SizedBox.shrink()
                      : Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              SelectCashSettingDialogUtil.show(context,
                                  okCallBack: (val) {
                                this.amount = val;
                                this.widget.courseModel?.price = val;
                                setState(() {});
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  getI18NKey().sales_amount,
                                  style: TextStyle(
                                      color: Color(0xff404040),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 13),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFf0f0f0),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('$amount'),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        height: 14,
                                        width: 1,
                                        color: Color(0xFF999999),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
