import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/beans/BillModel.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/page/CreditCardManagementPage/components/UpdateBillDialogWidget.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../beans/CreditCardModel.dart';
import '../../../common/provider/GlobalStateEnv.dart';
import '../../../components/CustomPopupWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../components/ListViewForBill.dart';
import '../components/RepayDialogWidget.dart';
import 'CreateCreditCardPage.dart';

class CreditCardPage extends BaseWidget {
  final Function onTapItemListener;
  CreditCardPage({Key? key, required this.onTapItemListener}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return CreateCreditCardPageState();
  }
}

class CreateCreditCardPageState extends BaseWidgetState<CreditCardPage> {
//最下面是一个按钮，按钮文案是添加账单，按钮背景色是333333，按钮文案色值是ffffff
  List<CreditCardModel> datas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  baseBuild(BuildContext context) {
    return Selector<GlobalStateEnv, List<CreditCardModel>>(
        selector: (_, env) => env.listCreditCardModel,
        builder: (_, listCreditCardModel, __) {
          this.datas = listCreditCardModel;
          return ListViewForBill(
            time: Utility.getTimeStampToday(),
            datas: datas,
            onTapUpdateBillListener: (CreditCardModel data) {},
            onTapCreateListener: () {
              Utility.openPagePCAndMobile(context,
                  child: CreateCreditCardPage(
                    creditCardModel: CreditCardModel(),
                  ));
            },
            onTapUpdateListener: (CreditCardModel data) {
              onTapUpdateCreditCard(creditCardModel: data);
            },
            onTapDeleteListener: (CreditCardModel data) {
              onTapDeleteCreditModel(data);
            },
            onTapRepaymentListener: (CreditCardModel data) {
              onTapRepaymentDialogWidget(data);
            }, onTapItemListener: (data) {
            onTapCreditCardDetailPage(context, data);
          },
          );
        });
  }

  void onTapCreditCardDetailPage(BuildContext context, data) {
    Utility.pushCreditDetailDesktopMainContainerNavigator(
        context, 'CreditCardDetailPage', {'data': data});
  }




  void onTapUpdateCreditCard({required CreditCardModel creditCardModel}) {
    Utility.openPagePCAndMobile(context,
        child: CreateCreditCardPage(
          creditCardModel: creditCardModel,
        ));
  }

  void onTapDeleteCreditModel(CreditCardModel creditCardModel) {
    MongoApisManager.getInstance().delete_CreditCardModel(
        currentObjectId: creditCardModel.objectId ?? "");
  }


  void onTapRepaymentDialogWidget(CreditCardModel creditModel) {
    double billAmount = Utility.getBillAmount(creditModel: creditModel);
    DialogManagement.getInstance().showCustomDialogWithOnlyChild(context,
        child: RepayDialogWidget(
            defaultVal: billAmount == 0 ? "" : billAmount.toString(),
            onTapConfirmListener: (val, paymentMethod) {
              if (TextUtil.isEmpty(val)) {
                Utility.showToastMsg(msg: getI18NKey().please_input_bill_amount);
                return;
              }
              double value = double.parse(val);
              if (value <= 0) {
                Utility.showToastMsg(msg: getI18NKey().please_input_bill_amount);
                return;
              }

              double billAmount = Utility.getBillAmountFromRepaymentDatas(
                repaymentData: creditModel.repaymentData ?? [],
                curMonthTimeStamp: Utility.getTimeStampToday(),
              );
              if (billAmount > value) {
                billAmount = billAmount - value;
              } else {
                billAmount = 0;
              }
              // String? creditCardId; //信用卡id
              // int? status = 0; //0表示账单或者购买东西 1表示还款金额
              // int? paymentMethod = 0; // 0 银行 1 支付宝 2 微信 3 现金
              // double? billAmount = 0;
              // double? repayAmount = 0;
              // String? uid;
              // String? device_id;
              // String? product;

              MongoApisManager.getInstance().insertBillModel(billModel: BillModel(
                creditCardId: creditModel.objectId,
                  status: 1,
                  value: -value ,
                  amount: billAmount,
                  paymentMethod: paymentMethod,
              ));

              Utility.addAndUpdateRepaymentDay(creditModel.repaymentData!,
                  amount: billAmount, repaymentStatus: 0);
              MongoApisManager.getInstance()
                  .update_CreditCardModel(creditCardModel: creditModel);
              DialogManagement.getInstance().hideDialog(context);
            },
            onTapClose: () {
              DialogManagement.getInstance().hideDialog(context);
            }));
  }

  void onTapShowUpdateBillDialogWidget({required CreditCardModel creditModel}) {
    DialogManagement.getInstance()
        .showCustomDialogWithOnlyChild(Utility.getGlobalContext(),
            child: UpdateBillDialogWidget(onTapConfirmListener: (val) {
              if (TextUtil.isEmpty(val)) {
                Utility.showToastMsg(msg: getI18NKey().please_input_bill_amount);
                return;
              }
              double value = double.parse(val);
              if (value <= 0) {
                Utility.showToastMsg(msg: getI18NKey().please_input_bill_amount);
                return;
              }
              Utility.addAndUpdateRepaymentDay(creditModel.repaymentData!,
                  amount: value, repaymentStatus: 0);
              MongoApisManager.getInstance().insertBillModel(billModel: BillModel(
                value: 1,
                amount: value,
                creditCardId: creditModel.objectId,
                status: 0,
                billAmount: 0,
                paymentMethod: 0,
              ));
              MongoApisManager.getInstance()
                  .update_CreditCardModel(creditCardModel: creditModel);
              DialogManagement.getInstance().hideDialog(context);
            }, onTapClose: () {
              DialogManagement.getInstance().hideDialog(context);
            }));
  }
}
