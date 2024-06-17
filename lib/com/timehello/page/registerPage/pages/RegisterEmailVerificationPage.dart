import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/beans/UserBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/Oberver.dart';
import 'package:time_hello/com/timehello/common/httpclient/Observable.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/GoogleMailLoginManager.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/LoginUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class RegisterEmailVerificationPage extends BaseWidget {
  PageFromEnum pageFromEnum;
  String email;
  String password;
  RegisterEmailVerificationPage({required this.pageFromEnum, required this.email, required this.password});
  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return RegisterEmailVerificationPageState();
  }

}

class RegisterEmailVerificationPageState extends BaseWidgetState<RegisterEmailVerificationPage> implements LoginResult, Observer{
  @override
  componentDidMount() {
    // TODO: implement componentDidMount
    GoogleMailLoginManager.getInstance().checkEmailVerifiedPeriodic(
        callSuccess: () {
          if(TextUtil.isEmpty(this.widget.email) || TextUtil.isEmpty(this.widget.password)) {
            return;
          }
          LoginManager.getInstance().register(
            // mobile: this.curTab == 0? this._mobile : "",
              email: this.widget.email,
              password: this.widget.password,
              onComplete: this);
        }
    );
    return super.componentDidMount();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  dispose() {
    GoogleMailLoginManager.getInstance().cancelTimer();
    super.dispose();
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.discreteCircle(
            // leftDotColor: const Color(0xFF1A1A3F),
            // rightDotColor: const Color(0xFFEA3799),
            size: 70, color: Colors.blue,
          ),
          SizedBox(height: 20,),
          Text(getI18NKey().login_email_to_verifie, style: TextStyle(fontSize: 20, ),),
        ],
      ),
    );
  }

  @override
  void loginFail(Map errorMsg, {LoginMode? loginMode}) {
    // TODO: implement loginFail
  }

  @override
  void loginSuccess({UserBean? loginInfoModel}) async {
    // TODO: implement loginSuccess
    await LoginManager.getInstance().handleLoginSuccess(context);

    // Utility.pushAndRemoveUntil(context, MainContainerWidget(), 'MainContainerWidget');
    // Utility.pushAndRemoveUntil(context, MainContainerWidget2(), 'BottomTabBarHome');
  }



  @override
  void update(Observable o, BaseBean response, String scene) async {
    // TODO: implement update
  }
}