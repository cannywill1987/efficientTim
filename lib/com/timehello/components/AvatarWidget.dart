import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/Oberver.dart';
import 'package:time_hello/com/timehello/common/httpclient/Observable.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../config/ColorsConfig.dart';
import '../config/ENUMS.dart';

class AvatarWidget extends StatelessWidget implements Observer {
  OnTapListener? onTapListener;
  Function? onAvatarUpdatedComplete;
  double width = 40;
  String? avatar;
  AvatarEnum avatarEnum;
  Color borderColor;
  double borderWidth = 2;

  AvatarWidget(
      {this.avatarEnum = AvatarEnum.defaut,
      this.width = 40,
      this.borderWidth = 2,
      this.borderColor = Colors.white,
      this.avatar,
      this.onTapListener,
      this.onAvatarUpdatedComplete}) {}

  /**
   * PC端更换头像
   */

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextButton(
      onPressed: () {
        if (this.onTapListener != null) {
          this.onTapListener!({});
        }
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.all(Radius.circular(250)),
              border:
                  Border.all(width: this.borderWidth, color: this.borderColor)),
          width: this.width,
          height: this.width,

          child: getAvatar()
      ),
    );
  }

  Widget getAvatar() {
    Widget? avatar = null;
    if (this.avatar != null) {
      if (this.avatar?.indexOf('http') != -1) {
        return Stack(children: [
          CachedNetworkImage(
            width: this.width,
            height: this.width,
            fit: BoxFit.cover,
            imageUrl: Utility.filterHttpUrl(this.avatar ?? "", prefix: "oss"),
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
        if (this.avatarEnum == AvatarEnum.defaut) {
          avatar =
              CONSTANTS.getAvatarFromAvatarList(this.avatar ?? "", this.width - 8);
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
