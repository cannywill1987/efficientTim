import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../beans/CreditCardModel.dart';
import '../../../components/CustomPopupWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../util/TextUtil.dart';

class ListViewForBill extends StatelessWidget {
  int time = Utility.getTimeStampToday();
  List<CreditCardModel> datas = [];
  final double space = 5;
  final double fontSize = 14;
  final Color colorGray = Color(0xff9c9c9c);
  final Color colorBlack = Color(0xff333333);
  final Color colorRed = Colors.red;
  final double titleSize = 18;
  final double subtitleSize = 14;
  final Color lineColor = Color(0xFFe5e5e5);
  Function onTapCreateListener;
  Function onTapUpdateListener;
  Function onTapItemListener;
  Function onTapUpdateBillListener;
  Function onTapDeleteListener;
  Function onTapRepaymentListener;

  ListViewForBill(
      {required this.time,
      required this.datas,
        required this.onTapItemListener,
      required this.onTapUpdateBillListener,
      required this.onTapCreateListener,
      required this.onTapUpdateListener,
      required this.onTapDeleteListener,
      required this.onTapRepaymentListener});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(getI18NKey().add_credit_card_bill),
                InkWell(
                  onTap: () {
                    this.onTapCreateListener.call();
                    // Utility.openPagePCAndMobile(context,
                    //     child: CreateCreditCardPage(
                    //       creditCardModel: CreditCardModel(),
                    //     ));
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF333333),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        getI18NKey().add_bill,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
          getSummaryHeader(),
          for (int i = 0; i < datas.length; i++)
            getItem(creditCardModel: datas[i]),
        ],
      ),
    );
  }

  getItem({required CreditCardModel creditCardModel}) {
    double billAmount = Utility.getBillAmount(creditModel: creditCardModel);
    return InkWell(
      onTap: (){
        this.onTapItemListener.call(creditCardModel);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: lineColor, width: 1))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                      Utility.getSVGPicture(R.assetsImgIcBank, size: 12),
                      SizedBox(
                        width: space,
                      ),
                      if (TextUtil.isEmpty(creditCardModel.bankName) == false)
                        Text(
                          creditCardModel.bankName ?? "",
                          style: TextStyle(
                              color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff585858)), fontSize: fontSize),
                        ),
                      if (TextUtil.isEmpty(creditCardModel.name) == false)
                        SizedBox(
                          width: space,
                        ),
                      if (TextUtil.isEmpty(creditCardModel.name) == false)
                        Text(
                          creditCardModel.name ?? "",
                          style: TextStyle(color: colorGray, fontSize: fontSize),
                        ),
                      if (TextUtil.isEmpty(creditCardModel.bankId) == false)
                        SizedBox(
                          width: space,
                        ),
                      if (TextUtil.isEmpty(creditCardModel.bankId) == false)
                        Text(
                          creditCardModel?.bankId ?? "",
                          style: TextStyle(color: colorGray, fontSize: fontSize),
                        ),
                    ])),
                InkWell(
                  child: CustomPopupWidget(
                    onSelected: (val) async {
                      switch (val.code) {
                        case 'update':
                          this.onTapUpdateListener.call(creditCardModel);
                          // onTapUpdateCreditCard(creditCardModel: creditCardModel);
                          break;
                        case 'repayment_instantly': //立即还款
                          break;
                        case 'update_bill': //更新账单
                          this.onTapUpdateBillListener.call(creditCardModel);
                          // onTapShowUpdateBillDialogWidget(creditModel: creditCardModel);
                          break;
                        case 'mark_repayment_amount':
                          this.onTapRepaymentListener.call(creditCardModel);
                          // onTapRepaymentDialogWidget(creditCardModel);
                          break;
                        case 'delete':
                          this.onTapDeleteListener.call(creditCardModel);
                          // onTapDeleteCreditModel(creditCardModel);
                          break;
                      }
                      // updateUI();
                    },
                    list: CONSTANTS.getCreditCardList(),
                    child: Icon(
                      Icons.more_horiz,
                      color: Color(0xffcccccc),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          billAmount == 0 ? "--" : billAmount.toString(),
                          style: TextStyle(
                              color: ThemeManager.getInstance().getTextColor(defaultColor: colorBlack),
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: space,
                        ),
                        InkWell(
                          onTap: () {
                            this.onTapUpdateListener.call(creditCardModel);
                            // onTapShowUpdateBillDialogWidget(creditModel: creditCardModel);
                          },
                          child: Text(
                            getI18NKey().edit,
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: space,
                    ),
                    Text(
                      getI18NKey().bill_this_statement,
                      style: TextStyle(color: colorGray, fontSize: subtitleSize),
                    ),
                  ],
                )),
                Expanded(
                    child: getItemRightPartWidget(
                        creditCardModel: creditCardModel,
                        billAmount: billAmount)),
                getRepayButton(creditCardModel),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  InkWell getRepayButton(CreditCardModel creditCardModel) {
    double billAmount = Utility.getBillAmountFromRepaymentDatas(
        repaymentData: creditCardModel.repaymentData ?? [],
        curMonthTimeStamp: time);
    return InkWell(
      onTap: () {
        if (billAmount <= 0) {
          return;
        }
        this.onTapRepaymentListener.call(creditCardModel);
        // onTapRepaymentDialogWidget(creditCardModel);
      },
      child: Container(
        constraints: BoxConstraints(
          minWidth: 100,
        ),
        // width: 100,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: billAmount <= 0
              ? LinearGradient(colors:ThemeManager.getInstance().isDark() ? ThemeManager.getInstance().getButtonLinearGradientBackgroundColor() : [Color(0xfff6f5fa), Color(0xfff6f5fa)])
              : LinearGradient(colors: ColorsConfig.listColorsGold),
        ),
        // decoration: BoxDecoration(
        //   color: Color(0xFF333333),
        //   borderRadius: BorderRadius.circular(20),
        // ),
        child: Center(
          child: Text(
            billAmount <= 0 ? getI18NKey().bill_cleared : getI18NKey().repayment,
            style: TextStyle(
              color: billAmount <= 0 ? Color(0xffcfcfcf) : Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  getSummaryHeader() {
    return Container(
        height: 80,
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: this.lineColor, width: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: getSummaryItem()),
            // Container(
            //   color: lineColor,
            //   width: 1,
            //   height: 40,
            // ),
            // Expanded(
            //     child: getSummaryItem(
            //   child: Utility.getSVGPicture(R.assetsImgIcBank, size: 12),
            // )),
          ],
        ));
  }

  getSummaryItem({Widget? child}) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 5,
        ),
        if (child != null) child,
        if (child != null)
          SizedBox(
            width: 5,
          ),
        Text(
          getI18NKey().all_pending_repayment,
          style: TextStyle(color: Color(0xffa9a9a9)),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          getTotalBillAmount(datas: datas),
          style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff424242))),
        ),
        SizedBox(
          width: 5,
        ),
        Icon(
          Icons.arrow_forward_ios,
          color: Color(0xffa9a9a9),
          size: 12,
        )
      ],
    );
  }

  Wrap getItemRightPartWidget(
      {required CreditCardModel creditCardModel, required double billAmount}) {
    Map repayDayStatus = getRepaymentDayStatus(creditModel: creditCardModel);
    int status = repayDayStatus['status'];
    int day = repayDayStatus['day'];
    // status 0:未到账单日 1:账单日 2:已过账单日未到还款日 3:还款日(未还款 预期) 4:已过还款
    if ((status == 0 && billAmount > 0 && day < 4)) {
      // 3 还款日  4 过还款日 且还有金额就是逾期
      return getThreeObjectWidgets(
          day: day,
          subDay: creditCardModel.billDay,
          status: status,
          creditCardModel: creditCardModel,
          title: getI18NKey().days_after_bill_day,
          colorFirstObj: colorRed,
          colorSecondObj: colorRed,
          colorThirdObj: colorGray);
    } else if (status == 0) {
      return getThreeObjectWidgets(
          day: day,
          subDay: creditCardModel.billDay,
          status: status,
          creditCardModel: creditCardModel,
          title: getI18NKey().days_after_bill_day,
          colorFirstObj: colorBlack,
          colorSecondObj: colorBlack,
          colorThirdObj: colorGray);
    } else if (status == 1) {
      //账单日
      return getTwoLinesWidget(
          title: getI18NKey().bill_day,
          creditCardModel: creditCardModel,
          colorFirstObj: billAmount > 0 ? colorRed : colorBlack,
          colorSecondObj: billAmount > 0 ? colorRed : colorBlack);
    } else if ((status == 2 && billAmount > 0 && day < 4)) {
      // 3 还款日  4 过还款日 且还有金额就是逾期
      return getThreeObjectWidgets(
          day: day,
          status: status,
          creditCardModel: creditCardModel,
          title: getI18NKey().days_after_repayment_day,
          colorFirstObj: colorRed,
          colorSecondObj: colorRed,
          colorThirdObj: colorGray);
    } else if (status == 2) {
      return getThreeObjectWidgets(
          day: day,
          status: status,
          creditCardModel: creditCardModel,
          title: getI18NKey().days_after_repayment_day,
          colorFirstObj: colorBlack,
          colorSecondObj: colorBlack,
          colorThirdObj: colorGray);
    } else if (status == 3) {
      //3:还款日(未还款 预期)
      return getTwoLinesWidget(
          title: getI18NKey().repayment_day,
          creditCardModel: creditCardModel,
          colorFirstObj: billAmount > 0 ? colorRed : colorBlack,
          colorSecondObj: billAmount > 0 ? colorRed : colorBlack);
    } else if (status == 4 && billAmount > 0) {
      // 4:已过还款日 且还有金额就是逾期
      return getTwoLinesWidget(
          title: getI18NKey().n_days_overdue(day),
          creditCardModel: creditCardModel,
          colorFirstObj: colorRed,
          colorSecondObj: colorRed);
    } else if (status == 4 && billAmount <= 0) {
      // 4:已过还款日 还完钱就是已还款
      return getTwoLinesWidget(
          title: getI18NKey().repaid,
          creditCardModel: creditCardModel,
          colorFirstObj: Color(0xff999999),
          colorSecondObj: Color(0xff999999));
    } else {
      return getThreeObjectWidgets(
          day: day,
          status: status,
          creditCardModel: creditCardModel,
          title: status == 0
              ? getI18NKey().days_after_bill_day
              : status == 2
                  ? getI18NKey().days_after_repayment_day
                  : "",
          colorFirstObj: colorBlack,
          colorSecondObj: colorBlack,
          colorThirdObj: colorGray);
    }
  }

  Wrap getThreeObjectWidgets(
      {required int day,
      int? subDay,
      required int status,
      required CreditCardModel creditCardModel,
      required String title,
      required Color colorFirstObj,
      required Color colorSecondObj,
      required Color colorThirdObj}) {
    return Wrap(
      children: [
        Text(
          day.toString(),
          style: TextStyle(
              color: ThemeManager.getInstance().getTextColor(defaultColor: colorFirstObj), fontSize: 36, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: space,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // status 0:未到账单日 1:已到账单日 2:已过账单日 未到还款日 3:已过还款日(未还款 预期) 4:已过还款
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: colorSecondObj), fontSize: titleSize),
                ),
                // if(status == 1)
                // Text(
                //   "今日是账单日",
                //   style: TextStyle(color: colorRed, fontSize: titleSize - 3),
                // ),
              ],
            ),
            SizedBox(
              width: space,
            ),
            Text(
              Utility.getCurMonth() +
                  "-" +
                  (subDay != null
                      ? subDay.toString()
                      : creditCardModel.repayDay.toString()),
              style: TextStyle(color: colorThirdObj, fontSize: subtitleSize),
            ),
          ],
        ),
      ],
    );
  }

  Wrap getTwoLinesWidget(
      {required String title,
      required CreditCardModel creditCardModel,
      required Color colorFirstObj,
      required Color colorSecondObj}) {
    return Wrap(
      children: [
        SizedBox(
          width: space,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              //0天显示还款日 n>0显示 预期n天
              title,
              style: TextStyle(color: colorFirstObj, fontSize: titleSize),
            ),
            SizedBox(
              width: space,
            ),
            Text(
              Utility.getCurMonth() + "-" + creditCardModel.repayDay.toString(),
              style: TextStyle(color: colorSecondObj, fontSize: subtitleSize),
            ),
          ],
        ),
      ],
    );
  }

  String getTotalBillAmount({required List<CreditCardModel> datas}) {
    double totalBillAmount = 0;
    datas.forEach((element) {
      double billAmount = Utility.getBillAmountFromRepaymentDatas(
        repaymentData: element.repaymentData ?? [],
        curMonthTimeStamp: time,
      );
      if (billAmount != -1) {
        totalBillAmount += billAmount;
      }
    });
    return totalBillAmount.toString();
  }

  // {status:0, day: 1} status 0:未到账单日 1:已到账单日 2:已过账单日 未到还款日 3:已过还款日(未还款 预期) 4:已过还款
  Map getRepaymentDayStatus({required CreditCardModel creditModel}) {
    double billuAmont = Utility.getBillAmountFromRepaymentDatas(
      repaymentData: creditModel.repaymentData ?? [],
      curMonthTimeStamp: time,
    );
    DateTime dateTimeNow = Utility.getDateTimeFromTimeStamp(time);
    int timestampNow = dateTimeNow.millisecondsSinceEpoch;
    int dayNow = dateTimeNow.day;
    //账单日
    int billDay = creditModel.billDay!;
    DateTime billDayDateTime =
        DateTime(dateTimeNow.year, dateTimeNow.month, billDay);
    int billDayTimestamp = billDayDateTime.millisecondsSinceEpoch;
    int repayDay = creditModel.repayDay!;
    DateTime repayDayDateTime =
        DateTime(dateTimeNow.year, dateTimeNow.month, repayDay);
    int repayDayTimestamp = repayDayDateTime.millisecondsSinceEpoch;

    if (dayNow < billDay) {
      return {"status": 0, "day": billDay - dayNow};
    } else if (dayNow == billDay) {
      return {"status": 1, "day": 0};
    } else if (dayNow > billDay && dayNow < repayDay) {
      return {"status": 2, "day": repayDay - dayNow};
    } else if (dayNow == repayDay) {
      return {"status": 3, "day": 0};
    } else if (dayNow > repayDay) {
      return {"status": 4, "day": dayNow - repayDay};
    }
    return {"status": 0, "day": 0};

    // // if (creditModel == null) {
    // //   return "";
    // // }
    // int day = creditModel.repayDay!;
    // if (dayNow < 0) {
    //   dayNow = 0;
    // }
    // return dayNow.toString();
  }
}
