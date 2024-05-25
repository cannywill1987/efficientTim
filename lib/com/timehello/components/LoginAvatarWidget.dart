
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';

import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/beans/UserBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/common/httpclient/Oberver.dart';
import 'package:time_hello/com/timehello/common/httpclient/Observable.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../config/ColorsConfig.dart';
import '../config/ENUMS.dart';
import '../util/DeviceInfoManagement.dart';
import 'AvatarGridViewWidget.dart';
import 'SelectCustomDialogUtil.dart';

class LoginAvatarWidget extends StatelessWidget implements Observer {
  bool isLogin;
  OnTapListener? onTapListener;
  Function? onAvatarUpdatedComplete;
  double width = 40;
  String? curAvatarSelected = LoginManager.getInstance().getUserBean().avatar;
  AvatarEnum avatarEnum;
  bool isRequesting = false;
  LoginAvatarWidget(
      {this.avatarEnum = AvatarEnum.defaut,
      this.isLogin = false,
      this.onTapListener,
      this.onAvatarUpdatedComplete}) {
    this.isLogin = LoginManager.isLogin();
  }

  /**
   * PC端更换头像
   */
  void onClickToChangeAvatar(BuildContext context) async {
    if (this.avatarEnum == AvatarEnum.defaut) {
      //默认 点击头像显示对话框

      SelectCustomDialogUtil.show(context,
          title: getI18NKey().select_avatar,
          maxHeight: 380, child: AvatarGridViewWidget(
        onTapListener: (data) {
          this.curAvatarSelected = data;
        },
      ), okCallBack: (duration) {
        HttpManager.getInstance().doPostRequest(Apis.updateAvatar,
            params: {'avatar': this.curAvatarSelected},
            context: context,
            callback: (BaseBean response, String scene, bool isFromCache) {
          if (response.success == true) {
            eventBus.fire(EventFn(Params.ACTION_UPDATE_USERINFO_AVATAR, {}));
            Utility.showToastMsg(msg: getI18NKey().update_success);
            LoginManager.getInstance()
                .setUserBean(UserBean.fromJson(response.data));
            if (this.onAvatarUpdatedComplete != null) {
              this.onAvatarUpdatedComplete!();
            }
            // DialogManagement.getInstance().hideDialog(context);
          }
        });
      });
    } else {
      //编辑模式
      if (DeviceInfoManagement.isMoible()) {
      File? file = await Utility.pickImage();
      File? fileCropped = await Utility.cropImage(file);
      // Image.file(fileCropped);
      if(fileCropped == null) {
        return;
      }
      BaseBean baseBean = await HttpManager.getInstance().uploadImage(key: 'key', file:fileCropped, url: Apis.uploadOss);
      //   String url =
      //       'http://fsclould.timerbell.com/20220422-image_cropper_065ADC93-B347-4F1F-8257-C0514ED1F4AF-2043-000001C1516A6E53.jpg?imageMogr2/thumbnail/300x300';
      isRequesting = true;
        HttpManager.getInstance()
            .doPostRequest(Apis.updateAvatar, params: {'avatar': baseBean.data['smallImage']},
            context: context,
                callback: (BaseBean response, String scene, bool isFromCache) {
                  isRequesting = false;
          if (response.success == true) {
            eventBus.fire(EventFn(Params.ACTION_UPDATE_USERINFO_AVATAR, {}));
            Utility.showToastMsg(msg: getI18NKey().update_success);
            LoginManager.getInstance()
                .setUserBean(UserBean.fromJson(response.data));
            DialogManagement.getInstance().hideDialog(context);
            // if (this.onAvatarUpdatedComplete != null) {
            //   this.onAvatarUpdatedComplete();
            // }
          }
        });
      } else {
        Utility.showToastMsg(msg: getI18NKey().pc_not_available);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (this.isLogin) {
      return InkWell(
        onTap: () {
          if (this.onTapListener != null) {
            this.onTapListener!({});
          }
          this.onClickToChangeAvatar(context);
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(width: 2, color: Colors.white)),
            width: this.width,
            height: this.width,
            child: getAvatar()),
      );
    } else {
      return InkWell(
          onTap: () {
            if (this.onTapListener != null) {
              this.onTapListener!({});
            }
            // Utility.showToast(msg: "未登录");
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(width: 2, color: Colors.white)),
            width: this.width,
            height: this.width,
            child: Text(
              getI18NKey().login,
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ));
    }
    return throw UnimplementedError();
  }

  Widget getAvatar() {
    Widget? avatar = null;
    if (LoginManager.getInstance().getUserBean().avatar != null) {
      if (LoginManager.getInstance().getUserBean().avatar?.indexOf('http') !=
          -1) {
        return Stack(children: [
          CachedNetworkImage(
            width: this.width,
            height: this.width,
            fit: BoxFit.cover,
            imageUrl: Utility.filterHttpUrl(LoginManager.getInstance().getUserBean().avatar ?? "", prefix: "oss"),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    // colorFilter:
                    //     ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                ),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          this.avatarEnum == AvatarEnum.edit
              ? Align(
                  alignment: Alignment(-0, -0.2),
                  child: Container(
                    width: 20,
                    height: 20,
                    child: Icon(
                      Icons.add_a_photo,
                      size: 15,
                      color: ColorsConfig.white,
                    ),
                  ),
                )
              : SizedBox.shrink()
        ]);
      } else {
        if(this.avatarEnum == AvatarEnum.defaut) {
          avatar = CONSTANTS.getAvatarFromAvatarList(
              LoginManager.getInstance().getUserBean().avatar ?? "", this.width - 8);
        } else {
          avatar = Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(width: 2, color: Color(0xffa0a0a0))),
              width: this.width,
              height: this.width,
          child: Icon(Icons.add_a_photo, color: Color(0xffa0a0a0), size: 15),
          );
        }
      }
    } else {
      avatar = CONSTANTS.getAvatarFromAvatarList(
          'avatar_${Utility.getRandomString(
            from: 1,
            max: 40,
            pureInt: 2,
          )}',
          this.width - 8);
    }
    return avatar;
  }

  @override
  void update(Observable o, BaseBean response, String scene) {
    // TODO: implement update
  }
}
