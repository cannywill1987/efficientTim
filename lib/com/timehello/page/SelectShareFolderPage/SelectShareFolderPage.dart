import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/EasyLoadingManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../components/AvatarWidget.dart';
import '../../components/BaseWidget.dart';
import '../../components/ImagesWrapperWidget.dart';
import '../../config/ENUMS.dart';
import '../../config/Params.dart';
import '../../models/CourseModel.dart';
import '../../models/FolderModel.dart';
import '../../util/DialogManagement.dart';
import '../../util/LoginManager.dart';
import '../../util/TextUtil.dart';
import '../../util/ThemeManager.dart';
import '../RichEditor/ReadOnlyPage.dart';

class CarouselPage extends StatelessWidget {
  List<CourseModel> listCourseModel = [];

  CarouselPage({required this.listCourseModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carousel Example'),
      ),
      body: Container(
        color: Colors.black54,
        child: PageView.builder(
          itemCount: listCourseModel.length, // 设置carousel中的页面数量
          itemBuilder: (BuildContext context, int index) {
            return SelectShareFolderPage(courseModel: listCourseModel[index]);
          },
          controller:
              PageController(viewportFraction: 0.8), // 设置viewportFraction为0.8
        ),
      ),
    );
  }
}

class SelectShareFolderPage extends BaseWidget {
  // const CoursePage();

  CourseModel courseModel;


  SelectShareFolderPage({required this.courseModel});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return SelectShareFolderPageState();
  }
}

class SelectShareFolderPageState extends BaseWidgetState<SelectShareFolderPage> {
  // CourseModel courseModel;
  String? password;
  TextEditingController controllerPassword = TextEditingController();
  // BuildContext? context;
  // {required this.courseModel}
  SelectShareFolderPageState();

  double avatarWidth = 60;
  final List<ImageProvider> _imageProviders = [
    Image.network("https://picsum.photos/id/1001/4912/3264").image,
    Image.network("https://picsum.photos/id/1003/1181/1772").image,
    Image.network("https://picsum.photos/id/1004/4912/3264").image,
    Image.network("https://picsum.photos/id/1005/4912/3264").image
  ];

  void onClick(type, data) async {
    switch (type) {
      case 'onClickGetShareData':
        this.onClickGetShareData();
        break;
    }
  }

  onClickGetShareData() async {
    //密码登录 是否是自己创建的
    if (this.widget.courseModel?.uid == LoginManager.getInstance().userBean.uid) {
      Utility.showToastMsg(
          context: context, msg: getI18NKey().your_created_class);
      return;
    }
      if ((this.widget.courseModel?.type ?? 0) == 2 &&
          this.widget.courseModel?.password != password) {
        Utility.showToastMsg(
            context: context, msg: getI18NKey().please_input_correct_password);
        return;
      }

      EasyLoadingManager.getInstance().showLoading();
      // 类型 - 1 免费开放 需要id 2 私有 - 需要搜索 3 销售（只针对国内）
      //密码登录查看是否已经拥有该课程
      if ((this.widget.courseModel?.type ?? 0) == 2) {
        FolderModel? folderModel = await MongoApisManager.getInstance()
            .requestFolderModelByFolderId(
                folder_id: this.widget.courseModel?.courseFid ?? "");
        if(folderModel == null) {
          Utility.showToastMsg(msg: getI18NKey().request_fail);
          EasyLoadingManager.getInstance().hideLoading();
          return;
        }
        // 添加uid
        if (folderModel?.otherUids == null) folderModel?.otherUids = [];
        if(folderModel?.otherUids!.contains(LoginManager.getInstance().userBean.uid) == false) {
          folderModel?.isOtherUserEditable = this.widget.courseModel?.isEditable;
          folderModel?.otherUids?.add(LoginManager.getInstance().userBean.uid);
          folderModel?.otherUserInfo?.add(ChatGroupManager.getUserInfoBean(role: 2));

          this.widget.courseModel?.otherUids = folderModel?.otherUids;
          this.widget.courseModel?.otherUserInfo = folderModel?.otherUserInfo;
          //主要目的是更新uid
          ;
          List resList = await Future.wait([MongoApisManager.getInstance()
              .update_CourseModel(this.widget.courseModel?.objectId ?? "", courseModel: this.widget.courseModel),
            MongoApisManager.getInstance()
                .update_FolderModelWithFM(folderModel: folderModel)
          ]);
        } else {
          Utility.showToastMsg(msg: getI18NKey().already_in_course);
        }
      } else {
        // 类型 - 1 免费开放 需要id 3 销售（只针对国内）
        if (await MongoApisManager.getInstance()
            .isCourseModelIdExist(this.widget.courseModel?.objectId ?? "")) {
          Utility.showToastMsg(context: context, msg: getI18NKey().already_exist);
          return;
        }

        await MongoApisManager.getInstance().insertCourseIntoUser(
            this.widget.courseModel?.objectId ?? "", this.widget.courseModel?.courseFid ?? "");
      }
      Utility.showToastMsg(
          context: context,
          msg: getI18NKey()
              .get_train_plan_successful(this.widget.courseModel?.title ?? ""));
      EasyLoadingManager.getInstance().hideLoading();
      Utility.popupPagePCAndMobile(this.context ?? Utility.getGlobalContext());

  }


  @override
  void initState() {
    super.initState();
    this.isAppBarVisible = Utility.isHandsetBySize() ? true : false;
    this.forceAppBarVisible = Utility.isHandsetBySize() ? true : false;

  }

  @override
  Widget baseBuild(BuildContext context) {
    // this.context = context;
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
              height: 150,
              child: Stack(
                children: [
                  // 网络加载的图片
                  Container(
                    height: 150,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: Utility.filterHttpUrl(this.widget.courseModel?.backgroundUrl ?? '', prefix: "oss"),
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
                          print('更换背景');
                        },
                        icon: Icon(
                          Icons.share,
                          size: 16,
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
                                avatar:
                                    LoginManager.getInstance().userBean.avatar)
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    this.widget.courseModel?.title == this.widget.courseModel?.folderTitle ?  (this.widget.courseModel?.title ?? "") : (this.widget.courseModel?.title ?? "")  + "-" + (this.widget.courseModel?.folderTitle ?? ""),
                    style: TextStyle(
                      color: Color(0xFF404040),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(!TextUtil.isEmpty(this.widget.courseModel?.authorName)
                        ? "--" + (this.widget.courseModel?.authorName ?? "")
                        : ""),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (this.widget.courseModel?.type ?? 0) != 2
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
                                        this.password =
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
                    height: 10,
                  ),

                  TextUtil.isEmpty(this.widget.courseModel?.authorIntro) ? SizedBox.shrink() : Text(
                    getI18NKey().author_intro,
                    style: TextStyle(
                      color: Color(0xFF404040),
                    ),
                  ),
                  TextUtil.isEmpty(this.widget.courseModel?.authorIntro) ? SizedBox.shrink() : SizedBox(
                    height: 10,
                  ),
                  TextUtil.isEmpty(this.widget.courseModel?.authorIntro) ? SizedBox.shrink() : Text(
                    this.widget.courseModel?.authorIntro ?? "",
                    style: TextStyle(
                      color: Color(0xFF999999),
                    ),
                  ),
                  TextUtil.isEmpty(this.widget.courseModel?.courseIntro) ? SizedBox.shrink() : SizedBox(
                    height: 10,
                  ),
                  TextUtil.isEmpty(this.widget.courseModel?.courseIntro) ? SizedBox.shrink() : Text(
                    getI18NKey().course_intro,
                    style: TextStyle(
                      color: Color(0xFF404040),
                    ),
                  ),
                  TextUtil.isEmpty(this.widget.courseModel?.courseIntro) ? SizedBox.shrink() : SizedBox(
                    height: 10,
                  ),
                  TextUtil.isEmpty(this.widget.courseModel?.courseIntro) ? SizedBox.shrink() : Text(
                    this.widget.courseModel?.courseIntro ?? "",
                    style: TextStyle(
                      color: Color(0xFF999999),
                    ),
                  ),
                  TextUtil.isEmpty(this.widget.courseModel?.courseDetailPlan)
                      ? SizedBox.shrink()
                      : SizedBox(
                    height: 10,
                  ),
                  TextUtil.isEmpty(this.widget.courseModel?.courseDetailPlan)
                      ? SizedBox.shrink()
                      : InkWell(
                          onTap: () {
                            if (Utility.isHandsetBySize() == true) {
                              Utility.pushNavigator(
                                  context,
                                  ReadOnlyPage(
                                      ossUrl: this.widget.courseModel?.courseDetailPlan,
                                      richTextModeEnum: RichTextModeEnum.note));
                            } else {
                              DialogManagement.getInstance().showPCCustomDialog(
                                  context: context,
                                  widget: ReadOnlyPage(
                                      ossUrl: this.widget.courseModel?.courseDetailPlan,
                                      richTextModeEnum:
                                          RichTextModeEnum.getUrl));
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  .detailed_training_plan_desc_2,
                                          style: TextStyle(
                                            color: Color(0xff999999),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    getI18NKey().browse,
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
                    isEditable: false,
                    listSmallImages: this.widget.courseModel?.imageSmallUrls,
                    listBigImages: this.widget.courseModel?.imageBigUrls,
                    listOriginImages: this.widget.courseModel?.imageOriginUrls,
                    onChange:
                        (listOriginImages, listSmallImages, listBigImages) {
                      // this.widget.courseModel?.imageSmallUrls = listSmallImages;
                      // this.widget.courseModel?.imageBigUrls = listBigImages;
                      // this.widget.courseModel?.imageOriginUrls =
                      //     listOriginImages;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  // this.widget.courseModel?.uid == LoginManager.getInstance().userBean.uid ? SizedBox.shrink() :
                  InkWell(
                    onTap: () async {
                      this.onClick("onClickGetShareData", null);
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      height: 45,
                      decoration: BoxDecoration(
                        color: ColorsConfig.red,
                        border: Border.all(width: 4, color: ColorsConfig.red),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        this.widget.courseModel?.type == 3
                            ? getI18NKey().buy_training_plan
                            : getI18NKey().get_training_plan,
                        //3是购买
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 100,
                  //   child: GridView.builder(
                  //     itemCount: 10, // 设置item数量
                  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: 3, // 一行展示3个item
                  //       mainAxisSpacing: 10,
                  //       crossAxisSpacing: 10,
                  //     ),
                  //     itemBuilder: (_, index) {
                  //       return GestureDetector(
                  //         onTap: () {
                  //           // 打开图片浏览器
                  //         },
                  //         child: Image.network(
                  //           'http://oss.timerbell.com/resourceOss/4KA壁纸102.jpg',
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
