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
            InkWell(
              onTap: () {
                DialogManagement.getInstance().showSelectBgDialog(context,
                    list: ResourceInfo.missionItemBackgroundLocationInfoBean
                            ?.deliveryList ??
                        [], onTapListener: (String imgUrl) {
                  setState(() {
                    this.backgroundUrl = imgUrl;
                    this.widget.courseModel?.backgroundUrl = imgUrl;
                  });
                  DialogManagement.getInstance().hideDialog(context);
                });
              },
              child: Container(
                height: 150,
                child: Stack(
                  children: [
                    // 网络加载的图片
                    Container(
                      height: 150,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: Utility.filterHttpUrl(backgroundUrl ?? '', prefix: "oss"),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      top: 18,
                      left: 18,
                      child: Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: IconButton(
                          onPressed: () {
                            print('关闭');
                            Utility.popupPagePCAndMobile(context);
                          },
                          icon: Icon(
                            Icons.close, // 设置为关闭图标
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 18,
                      right: 18,
                      child: Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: IconButton(
                          onPressed: () {
                            // print('更换背景');
                            this.onClickSave();
                          },
                          icon: Icon(
                            Icons.check, // 更改为打钩图标
                            size: 20,
                            color: Colors.green, // 设置图标颜色为绿色
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: avatarWidth * 2 / 6,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),

                    Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AvatarWidget(
                                  width: 45,
                                  avatar: LoginManager.getInstance()
                                      .userBean
                                      .avatar)
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      controller: controllerTitle,
                      maxLength: 200,
                      onChanged: (String title) async {
                        this.widget.courseModel?.title = title;
                      },
                      style: TextStyle(
                        color: Color(0xFF404040),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '标题',
                        hintStyle: TextStyle(
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () {
                          LoginManager.getInstance().hasUserName(
                              context: context,
                              callback: () {
                                setState(() {});
                                // Utility.pushToGame(context: context, bean: res);
                              });
                        },
                        child: Text(
                          TextUtil.isEmpty(
                                  LoginManager.getInstance().userBean.username)
                              ? getI18NKey().please_input_your_username
                              : "--" +
                                  LoginManager.getInstance().userBean.username,
                          style: TextStyle(
                              color: TextUtil.isEmpty(LoginManager.getInstance()
                                      .userBean
                                      .username)
                                  ? ColorsConfig.red
                                  : Color(0xff404040)),
                        )),
                  ),
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
                                        enabledBorder: OutlineInputBorder(
                                          //未选中时候的颜色
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: ThemeManager.getInstance().getInputBorderColor(defaultColor: Color(0xffffffff)),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          //选中时外边框颜色
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: ThemeManager.getInstance().getInputBorderColor(defaultColor: Color(0xffffffff)),
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
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
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        getI18NKey().yuan,
                                        style: TextStyle(
                                            color: Color(0xff404040),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      // Icon(
                                      //   Icons.star,
                                      //   size: 12,
                                      //   color: Colors.yellow,
                                      // ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    getI18NKey().author_intro,
                    style: TextStyle(
                      color: Color(0xFF404040),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(6)),
                    child: TextField(
                      controller: controllerAuthorIntro,
                      maxLines: 3000,
                      keyboardType: TextInputType.multiline,
                      textAlign: TextAlign.left,
                      onChanged: (String authorIntro) async {
                        this.widget.courseModel?.authorIntro = authorIntro;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        fillColor: Colors.transparent,
                        hintText:
                            getI18NKey().author_presentation_content,
                        hintStyle: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  // Text(
                  //   '作者简介内容xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 作者简介内容xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 作者简介内容xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 作者简介内容xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                  //   style: TextStyle(
                  //     color: Color(0xFF999999),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    getI18NKey().course_intro,
                    style: TextStyle(
                      color: Color(0xFF404040),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(6)),
                    child: TextField(
                      controller: controllerCourseIntro,
                      maxLines: 3000,
                      keyboardType: TextInputType.multiline,
                      textAlign: TextAlign.left,
                      onChanged: (String courseIntro) async {
                        this.widget.courseModel?.courseIntro = courseIntro;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        fillColor: Colors.transparent,
                        hintText:
                            getI18NKey().course_introduction,
                        hintStyle: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      if (Utility.isHandsetBySize() == true) {
                        Future.delayed(Duration(milliseconds: 100), () {
                          Utility.pushNavigator(
                              context,
                              RichEditorPage(
                                  onOkListener: (url, timelineMissionModelObjectId, numberNoteWords) {
                                    this.widget.courseModel?.courseDetailPlan =
                                        url;
                                    setState(() {});
                                    print(url);
                                  },
                                  richTextModeEnum: RichTextModeEnum.getUrl));
                        });
                      } else {
                        Future.delayed(Duration(milliseconds: 100), () {
                          DialogManagement.getInstance().showPCCustomDialog(
                              context: context,
                              widget: RichEditorPage(
                                  onOkListener: (url, timelineMissionModelObjectId, numberNoteWords) {
                                    this.widget.courseModel?.courseDetailPlan =
                                        url;
                                    setState(() {});
                                    print(url);
                                  },
                                  richTextModeEnum: RichTextModeEnum.getUrl));
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getI18NKey().detailed_training_plan,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    this.widget.courseModel?.courseDetailPlan ??
                                        getI18NKey()
                                            .detailed_training_plan_desc,
                                    style: TextStyle(
                                        color: Color(0xff999999),
                                        fontSize: 13,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              getI18NKey().detailed_training_plan_optional,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ImagesWrapperWidget(
                    listBigImages: this.widget.courseModel?.imageBigUrls,
                    listSmallImages: this.widget.courseModel?.imageSmallUrls,
                    listOriginImages: this.widget.courseModel?.imageOriginUrls,
                    onChange:
                        (listOriginImages, listSmallImages, listBigImages) {
                      this.widget.courseModel?.imageSmallUrls = listSmallImages;
                      this.widget.courseModel?.imageBigUrls = listBigImages;
                      this.widget.courseModel?.imageOriginUrls =
                          listOriginImages;
                    },
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
