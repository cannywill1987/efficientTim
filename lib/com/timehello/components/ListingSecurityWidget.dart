import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/CryptoManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';
import '../common/database/apis/MongoApisManager.dart';
import '../models/MissionModel.dart';

/**
 * 安全小组件
 */
class ListingSecurityWidget extends StatelessWidget {
  double size;
  String folder_id;
  String? missionModdel_id;
  int cryptoVersion;
  double marginLeft = 0;
  double marginRight = 0;
  double marginTop = 0;

  ListingSecurityWidget(
      {Key? key,
      this.size = 20,
      required this.folder_id,
      this.missionModdel_id,
      this.cryptoVersion = -1,
      this.marginTop = 0,
      this.marginLeft = 0,
      this.marginRight = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (this.cryptoVersion >= 0) {
      bool shouldShowRedDot = CryptoManager.getInstance()
          .shouldShowRedDotForFolderModel(folderId: this.folder_id);
      return InkWell(
        onDoubleTap: () async {
          await showPasswordDialog();
        },
        onTap: () async {
          int isPasswordCorrect = CryptoManager.getInstance()
              .isPasswordCorrectForFolderModel(folderId: this.folder_id);
          if (isPasswordCorrect == 0 && shouldShowRedDot == true) {
            Utility.showToastMsg(msg: getI18NKey().input_correct_password);
            //   CryptoManager.getInstance().showPasswordDialog(folderId: this.folder_id);
            await showPasswordDialog();
          } else {
            //没有任务
            if(isPasswordCorrect == 2) {
              Utility.showToastMsg(msg: getI18NKey().no_mission_desc);
            }
            else {
              Utility.showToastMsg(msg: getI18NKey().password_correct_desc);
            }
          }
        },
        child: shouldShowRedDot ? Stack(
          children: [
            getBody(),
            Positioned(
              top: 1,
              right: 2,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4)
                ),
              ),
            )
          ],
        ) : getBody(),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Future<void> showPasswordDialog() async {
    bool res = await CryptoManager.getInstance().showTwoPasswordDialog(
        folderId: this.folder_id,
        okCallback: (password) {
          List<MissionModel>? listMissionModels =
              MongoApisManager.getInstance()
                  .queryEncryptMissioinModelsByFolderId(
                      folderId: this.folder_id);
          if (listMissionModels == null ||
              listMissionModels.length == 0) {
            return true;
          }
          // todo 有点问题 如果Update失败更新密码就失败 没任何意义了
          CryptoManager.getInstance().setDigitPassword(
              folderId: this.folder_id, password: password);
          String pwd = CryptoManager.getInstance()
              .getDigitPassword(folderId: this.folder_id);
          CryptoManager.getInstance().updateMissionModelList(
              listMissionModelsTmp: listMissionModels);
        });
  }

  Container getBody() {
    return Container(
          margin: EdgeInsets.only(
              top: marginTop, left: marginLeft, right: marginRight),
          width: size,
          height: size,
          child: Utility.getSVGPicture(R.assetsImgIcSecure, size: size));
  }
}
