import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';

import '../models/CheckButtonStateModel.dart';
import '../page/CreateAIChatGptMissionPage/CreateAIChatGptMissionPage.dart';
import '../util/LoginManager.dart';
import '../util/Utility.dart';

class CustomCircleWidget extends StatelessWidget {
  List<CheckButtonStateModel> list;
  OnTapListener? onTapListener;
  Color color;

  CustomCircleWidget({required this.list, this.onTapListener, this.color = Colors.purple});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // if (this.onTapListener != null) {
    //   return GestureDetector(
    //     onTap: () {
    //       if (this.onTapListener != null) {
    //         this.onTapListener!(null);
    //       }
    //     },
    //     child: getWidget(),
    //   );
    // } else {
    return getWidget(context);
    // }
  }

  Card getWidget(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(30)),
        alignment: Alignment.center,
        child: PopupMenuButton<String>(
          icon: Icon(
            Icons.add,
            color: Colors.white,
            size: 14,
          ),
          onSelected: (String result) {
            if (LoginManager.isLogin() == false) {
              Utility.showToastMsg(msg: getI18NKey().loginFirst);
              LoginManager.getInstance()
                  .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
              return null;
            }
              if (this.onTapListener != null) {
                CheckButtonStateModel? model = getCheckButtonStateModel(result);
                if(model!= null) {
                  this.onTapListener!(model);
                }
              }
            // Handle your menu selection here
          },
          itemBuilder: (BuildContext context) => getButtonList(),
        ),
      ),
    );
  }

  CheckButtonStateModel? getCheckButtonStateModel(String code) {
    for (int i = 0; i < this.list.length; i++ ) {
      if (this.list[i].code == code) {
        return this.list[i];
      }
    }
    return null;
  }

  List<PopupMenuEntry<String>> getButtonList() {
    List<PopupMenuEntry<String>> list = [];
    for (CheckButtonStateModel model in this.list) {
      // if (model.isCheck) {
        list.add(PopupMenuItem<String>(
          // onTap: () {
          //   if (this.onTapListener != null) {
          //     this.onTapListener?.call(model);
          //   }
          //   //隐藏popup
          //   Navigator.pop(Utility.getGlobalContext());
          // },
          value: model.code,
          child: Text(model.title ?? ""),
        ));
      // }
    }
    return list;
  }
}
