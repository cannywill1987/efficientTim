import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

import '../../models/CommentModel.dart';
import '../../util/ThemeManager.dart';
import '../../util/Utility.dart';
import '../gamesPage/pages/games4/components/WordListView.dart';
import 'components/FeedbackListView.dart';

/**
 * 设置页面
 */
class FeedbackPage extends BaseWidget {
  FeedbackPage();

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _FeedbackPageWidgetState();
  }
}

class _FeedbackPageWidgetState<T> extends BaseWidgetState<FeedbackPage> {
  bool isNotificationOn = false;
  bool aliPushOn = false;
  List<CommentModel> list = [];
  FocusNode _contentFocusNode = FocusNode();
  String? value;

  // _FeedbackPageWidgetState() {}
  TextEditingController inputController = TextEditingController();
  OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    gapPadding: 0,
    borderSide: BorderSide(
      color: ThemeManager.getInstance().getInputBorderColor(defaultColor: Colors.white),
    ),
  );

  @override
  void onCreate() {
    super.onCreate();
    curPage = "FeedbackPage";
  }

  @override
  void initState() {
    this.requestCommentModels();
  }

  void requestCommentModels() async {
    list = await MongoApisManager.getInstance().queryWhereEqual_CommentModel();
    updateUI();
  }

  // @override
  // void didUpdateWidget(Widget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {}

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    return Stack(
      children: [
        FeedbackListView(
          datas: list,
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: ThemeManager.getInstance().getInputThemeColor(defaultColor: Colors.white),
                  width: double.infinity,
                  child: TextField(
                    maxLength: 255,
                    focusNode: _contentFocusNode,
                    controller: inputController,
                    onChanged: (text) {
                      value = text;
                      // inputController.clear();
                      print(text);
                    },
                    onSubmitted: (String value) {
                      this.value = value;
                      // if (this.widget.onSubmitListener != null) {
                      //   this.widget.onSubmitListener({"inputContent": value, "folderModel": curFolderModel});
                      // }
                      onClickComment(value);
                      print(value);
                    },
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        // decorationColor: Color(0xffd5d5d5),
                        color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)),
                        fontWeight: FontWeight.w500),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
    counterText: '',
                        counterStyle: TextStyle(height: double.minPositive,),
    floatingLabelStyle:TextStyle(color: Colors.transparent, fontSize: 0),
                        // counterStyle: TextStyle(height: double.minPositive,),
                        // counterStyle: TextStyle(color: Colors.red, fontSize: 0),
                        contentPadding: EdgeInsets.symmetric(horizontal: 65),
                        //右边距是为了放置番茄计数器
                        fillColor: ThemeManager.getInstance().getInputThemeColor(defaultColor: Colors.white),
                        //背景颜色，必须结合filled: true,才有效
                        hoverColor: ThemeManager.getInstance().getInputThemeColor(defaultColor: Colors.white),
                        focusColor: ThemeManager.getInstance().getInputThemeColor(defaultColor: Colors.white),
                        filled: true,
                        //重点，必须设置为true，fillColor才有效
                        // border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.add,
                          color: Color(0xffd5d5d5),
                        ),
                        prefixIconColor: Color(0xffd5d5d5),
                        // floatingLabelStyle:
                        //     TextStyle(color: Color(0xffff0000), fontSize: 14),
                        labelStyle:
                            TextStyle(color: Color(0xffd5d5d5), fontSize: 14),
                        border: _outlineInputBorder,
                        //边框，一般下面的几个边框一起设置
                        //keyboardType: TextInputType.number, //键盘类型
                        //obscureText: true,//密码模式
                        focusedBorder: _outlineInputBorder,
                        enabledBorder: _outlineInputBorder,
                        disabledBorder: _outlineInputBorder,
                        focusedErrorBorder: _outlineInputBorder,
                        errorBorder: _outlineInputBorder,
                        labelText: getI18NKey().comment_placeholder,
                        helperText: ''),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white),
                  child: TextButton(
                      onPressed: () {
                        onClickComment(value ?? "");
                      },
                      child: Text(getI18NKey().comment)),
                )
              ],
            )),
      ],
    );
  }

  void onClickComment(String value) async {
    if (TextUtil.isEmpty(value)) {
      Utility.showToastMsg(context: context, msg: getI18NKey().comment_not_empty);
      return;
    }
    await MongoApisManager.getInstance().insertCommentModel(
        title: value,
        content: value,
        username: LoginManager.getInstance().getUserBean().username,
        avatar: LoginManager.getInstance().getUserBean().avatar);
    requestCommentModels();
    inputController.text = '';
  }
}
