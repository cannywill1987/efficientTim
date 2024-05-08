import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/beans/UserBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/Loading.dart';
import 'package:time_hello/com/timehello/components/LoginAvatarWidget.dart';
import 'package:time_hello/com/timehello/components/SettingMenuItem.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../util/DialogManagement.dart';
import '../../util/EasyLoadingManager.dart';
import '../EditPage/EditPage.dart';


class SettingUserInfoPage extends BaseWidget {
  SettingUserInfoPage();

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _SettingUserInfoPageWidgetState();
  }
}

class _SettingUserInfoPageWidgetState<T>
    extends BaseWidgetState<SettingUserInfoPage> {
  @override
  void onCreate() {
    super.onCreate();
    curPage = "SettingUserInfoPage";
  }

  @override
  void initState() {}

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    //return super.baseBuild(context);
    return Column(
      children: [
        Expanded(
            child:
                SingleChildScrollView(child: getUserInfoListWidget(context))),
      ],
    );
  }

  Column getUserInfoListWidget(BuildContext context) {
    return Column(children: [
      SettingMenuItem(
          title: getI18NKey().avatar,
          description: '',
          rightPartContainer: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  LoginAvatarWidget(onAvatarUpdatedComplete: () {
                    updateUI();
                  })
                ],
              )
            ],
          ),
          icon: Icon(Icons.arrow_drop_down, color: ColorsConfig.gray_a3_icon)),
      SettingMenuItem(
          title: getI18NKey().username,
          description: '',
          onTapListener: (data) {
            Utility.pushNavigator(
                context,
                EditPage(
                    initialText: LoginManager.getInstance().userBean.username),
                callback: (res) {
              if (res.isEmpty == false) {
                EasyLoadingManager.getInstance().showLoading();
                HttpManager.getInstance().doPostRequest(Apis.updateUser,
                    params: {"username": res}, context: context, callback:
                        (BaseBean response, String scene, bool isFromCache) {
                          EasyLoadingManager.getInstance().dismiss();
                  if (response.success == true) {
                    // Utility.showToast(msg:getI18NKey().update_success);
                    LoginManager.getInstance()
                        .setUserBean(UserBean.fromJson(response.data));
                    this.updateUI();
                    eventBus.fire(
                        EventFn(Params.ACTION_UPDATE_USERINFO_AVATAR, {}));
                  }
                });
              }
            });
          },
          rightPartContainer: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    LoginManager.getInstance().userBean.username,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: ColorsConfig.common_color),
                  ),
                ],
              )
            ],
          ),
          icon: Icon(Icons.arrow_drop_down, color: ColorsConfig.gray_a3_icon)),
    ]);
  }
}
