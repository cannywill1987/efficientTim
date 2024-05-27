import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/libs/pinput/src/pinput.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/page/GroupChatPage/components/FolderListView.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../common/provider/Env.dart';
import '../../../config/Params.dart';
import '../../../models/FolderModel.dart';

class SearchFriendGroupWidget extends StatefulWidget {
  double width;

  SearchFriendGroupWidget({Key? key, this.width = 200}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchFriendGroupWidgetState();
  }
}

class SearchFriendGroupWidgetState extends State<SearchFriendGroupWidget> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _originPasswordController =
      TextEditingController();

  // final TextEditingController _confirmPasswordController =
  //     TextEditingController();
  List<FolderModel> listFolderModels = [];
  bool _isPasswordMatch = true;
  double height = 50;
  bool checkedPasswordOrigin = false;
  bool checkedPassword1 = false;
  int inputLength = 6;

  String pwd = "";
  String group = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pinController.text = "";
  }

  String getOriginPassword() {
    return _originPasswordController.text;
  }

  // String getPassword2() {
  //   return _confirmPasswordController.text;
  // }

  setOriginPassword(String password) {
    _originPasswordController.text = password;
  }

  requestData({required String group, required String pwd}) async {
    this.listFolderModels = await MongoApisManager.getInstance()
            ?.requestFolderModelByGroup(
                groupChatPassword: pwd,
                folderTeamWorkId: group,
                isSharingList: [2, 3]) ??
        [];
    setState(() {});
  }

  // setPassword2(String password) {
  //   _confirmPasswordController.text = password;
  // }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        SizedBox(height: 2),
        Directionality(
          // Specify direction if desired
          textDirection: TextDirection.ltr,
          child: Pinput(
            length: inputLength,
            // smsRetriever: SmsRetrieverImpl(
            //   SmartAuth(),
            // ),
            // smsRetriever: SmsRetrieverImpl(
            //   SmartAuth(),
            // ),
            controller: pinController,
            focusNode: focusNode,
            defaultPinTheme: defaultPinTheme,
            separatorBuilder: (index) => const SizedBox(width: 8),
            // validator: (value) {
            //   return value == '2222' ? null : 'Pin is incorrect';
            // },
            // onClipboardFound: (value) {
            //   debugPrint('onClipboardFound: $value');
            //   pinController.setText(value);
            // },
            hapticFeedbackType: HapticFeedbackType.lightImpact,
            onCompleted: (pin) {
              this.group = pin;
              requestData(group: this.group, pwd: pwd);
              debugPrint('onCompleted: $pin');
            },
            onChanged: (value) {
              debugPrint('onChanged: $value');
            },
            cursor: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  width: 22,
                  height: 1,
                  color: focusedBorderColor,
                ),
              ],
            ),
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: focusedBorderColor),
              ),
            ),
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                color: fillColor,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: focusedBorderColor),
              ),
            ),
            errorPinTheme: defaultPinTheme.copyBorderWith(
              border: Border.all(color: Colors.redAccent),
            ),
          ),
        ),
        SizedBox(height: 20),
        FolderListView(
          datas: this.listFolderModels,
          onTapJoin: (FolderModel folderModelTmp) async {
            FolderModel? folderModel = await MongoApisManager.getInstance()
                .requestFolderModelByFolderId(
                    folder_id: folderModelTmp?.objectId ?? "");

            if (folderModel != null) {
              // if(ChatGroupManager.isInTheFolder(folderModel: folderModel)) {
              //   Utility.showToastMsg(msg: getI18NKey().already_in_group);
              //   return;
              // }
              if(!TextUtil.isEmpty(folderModel.groupChatPassword)) {
                DialogManagement.getInstance().showPasswordDialog(title: folderModelTmp.title, okCallback: (val) async  {
                  if(folderModel.groupChatPassword == Utility.encryptCTRAES(val, Params.AES_PWD)) {
                    DialogManagement.getInstance()
                        .hideDialog(Utility.getGlobalContext(), true);
                    await addUser(folderModel, context);
                  } else {
                    Utility.showToastMsg(msg: "密码错误");
                  }
                });
              } else {
                // 添加uid
                await addUser(folderModel, context);
              }


              // this.widget.courseModel?.otherUids = folderModel?.otherUids;
              // this.widget.courseModel?.otherUserInfo = folderModel?.otherUserInfo;
              //主要目的是更新uid
              //     ;
              // List resList = await Future.wait([MongoApisManager.getInstance()
              //     .update_CourseModel(this.widget.courseModel?.objectId ?? "", courseModel: this.widget.courseModel),
              //
              // ]);
            }

            // // 添加uid
            // if (folderModel?.otherUids == null) folderModel?.otherUids = [];
            // if(folderModel?.otherUids!.contains(LoginManager.getInstance().userBean.uid) == false) {
            //   folderModel?.isOtherUserEditable = this.widget.courseModel?.isEditable;
            //   folderModel?.otherUids?.add(LoginManager.getInstance().userBean.uid);
            //   folderModel?.otherUserInfo?.add({"uid": LoginManager.getInstance().userBean.uid, "avatar": LoginManager.getInstance().userBean.avatar, "username": LoginManager.getInstance().userBean.username});
            //
            //   this.widget.courseModel?.otherUids = folderModel?.otherUids;
            //   this.widget.courseModel?.otherUserInfo = folderModel?.otherUserInfo;
            //   //主要目的是更新uid
            //       ;
            //   List resList = await Future.wait([MongoApisManager.getInstance()
            //       .update_CourseModel(this.widget.courseModel?.objectId ?? "", courseModel: this.widget.courseModel),
            //     MongoApisManager.getInstance()
            //         .update_FolderModelWithFM(folderModel: folderModel)
            //   ]);
            // } else {
            //   Utility.showToast(msg: getI18NKey().already_in_course);
            // }
          },
        ),
        // Container(
        //   height: height,
        //   width: this.widget.width,
        //   child: TextField(
        //     controller: _originPasswordController,
        //     obscureText: !this.checkedPasswordOrigin,
        //     maxLength: 6,
        //     keyboardType: TextInputType.number,
        //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        //     decoration: InputDecoration(
        //       filled: true,
        //       suffixIcon: Align(
        //         alignment: Alignment.centerRight,
        //         widthFactor: 1.0,
        //         child: CheckImage(
        //           //显示隐藏密码的眼睛
        //           onTapListener: (isChecked) {
        //             checkedPasswordOrigin = !isChecked;
        //             setState(() {});
        //           },
        //           checked: checkedPasswordOrigin,
        //           autoCheck: true,
        //           checkIcon:
        //           Utility.getSVGPicture(R.assetsImgIcEyeSlash, size: 20),
        //           uncheckIcon:
        //           Utility.getSVGPicture(R.assetsImgIcEyeClose, size: 20),
        //         ),
        //       ),
        //       fillColor: ThemeManager.getInstance().getInputDecorationColor(),
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(30.0),
        //         borderSide: BorderSide.none,
        //       ),
        //       hintText: getI18NKey().please_origin_password,
        //       hintStyle: TextStyle(
        //           color:
        //           ThemeManager.getInstance().getInputPlaceholderColor(),
        //           fontSize: 12),
        //     ),
        //   ),
        // ),
        // if (!_isPasswordMatch)
        //   Text(
        //     getI18NKey().encrypt_password_not_match,
        //     style: TextStyle(color: Colors.red),
        //   ),
      ],
    );
  }

  Future<void> addUser(FolderModel folderModel, BuildContext context) async {
     // 添加uid
    if (folderModel?.otherUids == null) folderModel?.otherUids = [];
    if (folderModel.uid != LoginManager.getInstance().userBean.uid && folderModel?.otherUids!
            .contains(LoginManager.getInstance().userBean.uid) ==
        false ) {
      // folderModel?.isOtherUserEditable = this.widget.courseModel?.isEditable;
      folderModel?.otherUids
          ?.add(LoginManager.getInstance().userBean.uid);
      folderModel?.otherUserInfo?.add({
        "uid": LoginManager.getInstance().userBean.uid,
        "avatar": LoginManager.getInstance().userBean.avatar,
        "username": LoginManager.getInstance().userBean.username,
        "numTasksDone": 0,
        "totalDurationFocus": 0
      });
      await MongoApisManager.getInstance()
          .update_FolderModelWithFM(folderModel: folderModel!);
      context.read<Env>().curFolderSelected = folderModel;
    } else {
      Utility.showToastMsg(msg: getI18NKey().already_in_group);
    }
  }
}
