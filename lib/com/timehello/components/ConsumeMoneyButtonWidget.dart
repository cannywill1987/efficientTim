import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/EasyLoadingManager.dart';
import '../common/database/apis/MongoApisManager.dart';
import '../config/ENUMS.dart';
import '../models/PresentModel.dart';
import '../util/DialogManagement.dart';
import '../util/LoginManager.dart';
import '../util/MoneyManager.dart';
import '../util/Utility.dart';
import 'Loading.dart';
import 'LoadingDialogUtil.dart';
import 'NineLoterryWidget.dart';
import 'SelectMoneySettingDialogUtil.dart';
import 'SelectPresentDialogUtil.dart';

/**
 * 我要花 按钮
 */
class ConsumeMoneyButtonWidget extends StatefulWidget {
  OnTapListener onTapListener;
  PageFromEnum? pageFrom = PageFromEnum.MobileMinePage;

  ConsumeMoneyButtonWidget({required this.onTapListener, this.pageFrom}) {}

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ConsumeMoneyButtonWidgetState();
  }
}

class ConsumeMoneyButtonWidgetState extends State<ConsumeMoneyButtonWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getPopupMenu(Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
            border: Border.all(
                color: this.widget.pageFrom == PageFromEnum.MobileMinePage
                    ? Colors.white
                    : Colors.red,
                width: 2),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Text(
          getI18NKey().i_consume,
          style: TextStyle(
              color: this.widget.pageFrom == PageFromEnum.MobileMinePage
                  ? Colors.white
                  : Colors.red,
              fontSize: Utility.isHandsetBySize() ? 12 : 14),
        )));
  }

  Container getPopupMenu(Widget child) {
    return Container(
        margin: EdgeInsets.only(right: 15),
        child: PopupMenuButton<String>(
          tooltip: '',
          padding: EdgeInsets.all(0.0),
          child: Container(
            // width: 40,
            // height: 35,
            // decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius:
            //     BorderRadius.all(Radius.circular(8))),
            child: child,
          ),
          onSelected: (String val) {
            if (val == "select_lottery") {
              NineLoterryController nineLotteryController =
                  NineLoterryController();
              DialogManagement.getInstance().showNineLotteryDialog(
                  context: context,
                  nineLotteryController: nineLotteryController);
            } else if (val == 'input_manually') {
              if ((LoginManager.getInstance().userBean.localMoney ?? 0) > 0) {
                SelectMoneySettingDialogUtil.show(context,
                    title: getI18NKey().title_consume, okCallBack: (val) async {
                  DialogManagement.getInstance().showLoadingDialog(context);
                  await MoneyManager.getInstance().requestUpdateLocalMoney(
                      context: context, localMoney: -val);
                  MongoApisManager.getInstance().insertTimelineMissionModel(
                      missionModel:
                      Utility.getTimelineMissionModelFromMissionModel(
                          sceneType: 'transaction',
                          eventType: 'spend_money_manually',
                          color: 0xffff8800,
                          icon: Icons.attach_money.codePoint,
                          timelineMessage: getI18NKey().consume_money(val)));

                  DialogManagement.getInstance().hideDialog(context);
                });
              } else {
                Utility.showToastMsg(msg: getI18NKey().money_not_enough_toast);
              }
            } else if (val == 'select_prize') {
              SelectPresentDialogUtil.show(context,
                  title: "",
                  content: "",
                  isCloseAuto: false,
                  isCheckButtonShow: true,
                  okCallBack: (List<PresentModel> list) async {
                if (list.length == 0) {
                  Utility.showToastMsg(
                      context: context, msg: getI18NKey().at_least_one_prize);
                  return;
                }
                int moneyConsumption = -Utility.getSumFromPresentModels(list).toInt();
                MongoApisManager.getInstance().insertTimelineMissionModel(
                    missionModel:
                    Utility.getTimelineMissionModelFromMissionModel(
                        sceneType: 'transaction',
                        eventType: 'spend_money_buy_present',

                        color: list[0].color ?? 0xffff8800,
                        icon: list[0].icon ?? 0,
                        timelineMessage: getI18NKey().consume_money_buy_present(moneyConsumption, Utility.getTitlesFromPresentModels(list))));
                EasyLoadingManager.getInstance().showLoading();
                // DialogManagement.getInstance().showLoadingDialog(context);
                await MoneyManager.getInstance().requestUpdateLocalMoney(
                    context: context,
                    localMoney: moneyConsumption);
                EasyLoadingManager.getInstance().dismiss();
                // DialogManagement.getInstance().hideDialog(context);
                Navigator.of(context).pop();
              });
            }
          },
          itemBuilder: (context) {
            // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'input_manually',
                child: Text(getI18NKey().input_manually,
                    style: TextStyle(fontSize: 13)),
              ),
              PopupMenuItem<String>(
                value: 'select_prize',
                child: Text(
                  getI18NKey().select_prize,
                  style: TextStyle(fontSize: 13),
                ),
              ),
              // PopupMenuItem<String>(
              //   value: 'select_lottery',
              //   child: Text(
              //     getI18NKey().select_prize,
              //     style: TextStyle(fontSize: 13),
              //   ),
              // ),
            ];
          },
        ));
  }
}
