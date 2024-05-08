import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../r.dart';
import '../config/Params.dart';
import '../util/EasyLoadingManager.dart';
import '../util/LoginManager.dart';
import '../util/Utility.dart';

class ThirdPartyLoginWidget extends StatelessWidget {
  Function onTapGoogle;
  Function onTapFacebook;

  ThirdPartyLoginWidget(
      {required this.onTapGoogle, required this.onTapFacebook});

  @override
  Widget build(BuildContext context) {
    double iconSize = 18;
    const double width = 140;
    bool isChina = Utility.isChina();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Utility.isMobile() == true && ABTestSetting.isFacebookOn == true && isChina == false? InkWell(
        //   onTap: () async {
        //     EasyLoadingManager.getInstance().showLoading();
        //     await LoginManager.getInstance().thirdPartyLoginWithFacebook(context);
        //     EasyLoadingManager.getInstance().hideLoading();
        //     this.onTapFacebook();
        //   },
        //   child: Utility.getSVGPicture(R.assetsImgIcFacebook, size: iconSize),
        // ): SizedBox.shrink(),
        SizedBox(
          width: 10,
        ),
        (Utility.isProductEnv() == false ||
                (isChina == false))
            ? InkWell(
                onTap: () async {
                  // EasyLoadingManager.getInstance().showLoading();
                  await LoginManager.getInstance()
                      .thirdPartyLoginWithGoogle(context);
                  // EasyLoadingManager.getInstance().hideLoading();
                  this.onTapGoogle();
                },
                child: Container(
                  alignment: Alignment.center,
                    width: width,
                    height: 45,
                    decoration: BoxDecoration(
                        border: Border.all(color: ThemeManager.getInstance().isDark() ? Colors.white : ThemeManager.getInstance().getDefautThemeColor(), width: 1),
                        borderRadius: BorderRadius.circular(4),
                        color: ThemeManager.getInstance().getCardBackgroundColor()),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Utility.getSVGPicture(R.assetsImgIcGoogle,
                            size: iconSize),
                        SizedBox(
                          width: 5,
                        ),
                          Text(
                            getI18NKey().google_login,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                      ],
                    )),
              )
            : SizedBox.shrink(),
        SizedBox(
          width: 20,
        ),
        (Utility.isProductEnv() == false ||
                (Utility.isMobile() == true && isChina == false))
            ?
        InkWell(
          onTap: () async {
            await LoginManager.getInstance()
                .thirdPartyLoginWithApple(context);
          },
          child: Container(
              alignment: Alignment.center,
              width: width,
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: ThemeManager.getInstance().isDark() ? Colors.white : ThemeManager.getInstance().getDefautThemeColor(), width: 1),
                  borderRadius: BorderRadius.circular(4),
                  color: ThemeManager.getInstance().getCardBackgroundColor()),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Utility.getSVGPicture(R.assetsImgIcApple,
                      size: iconSize, color: ThemeManager.getInstance().isDark() ? Colors.white : Colors.black),
                  SizedBox(
                    width: 5,
                  ),

                        Text(
                          getI18NKey().apple_login,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                ],
              )),
        )

            : SizedBox.shrink()
      ],
    );
  }
}
