import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/beans/BillModel.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../beans/CreditCardModel.dart';
import '../../../components/CustomPopupWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../util/TextUtil.dart';

class ListViewForBillDetail extends StatelessWidget {
  int time = Utility.getTimeStampToday();
  CreditCardModel creditCardModel = CreditCardModel();
  final double space = 5;
  final double fontSize = 14;
  final Color colorGray = Color(0xff9c9c9c);
  final Color colorBlack = Color(0xff333333);
  final Color colorRed = Colors.red;
  final double titleSize = 14;
  final double subtitleSize = 14;
  final Color lineColor = Color(0xFFe5e5e5);
  Function onTapUpdateListener;

  ListViewForBillDetail(
      {required this.time,
      required this.creditCardModel,
      required this.onTapUpdateListener,
      });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int length = this.creditCardModel.repaymentData?.length ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 10,
        ),
        for (int i = 0; i < length; i++)
          getItem(data: this.creditCardModel.repaymentData![i]),
      ],
    );
  }

  /**
   *row 左边有Column 两行 标题是12月 第二行是11-11至12-10 右边也有两行 第一行是数字8.00 第二行是蓝色的修改
   */
  getItem({required Map data}) {
    DateTime dateTime = Utility.getDateTimeFromTimeStamp(data['month']);
    double billAmount = data["billAmount"].toDouble();
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Text(Utility.getMonthName(dateTime.month),
                      style: TextStyle(
                          color: colorBlack,
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 5),
                  Text(dateTime.year.toString(),
                      style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: titleSize - 4,
                          )),
                ],
              ),
              SizedBox(
                height: space,
              ),
              Text(getDateString(dateTime.month, dateTime.month + 1 > 12 ? 1 : dateTime.month + 1),
                  style: TextStyle(color: colorGray, fontSize: subtitleSize)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${billAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: colorBlack,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: space,
              ),
              GestureDetector(
                onTap: () {
                  // onTapUpdateBillListener(billModel);
                },
                child: Text(getI18NKey().edit,
                    style: TextStyle(color: Colors.blue, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getDateString(int month, int nextMonth) {
    return getI18NKey().date1_to_date2(Utility.formatDecimal(month, shouldAddZero: true) + "-" + Utility.formatDecimal(this.creditCardModel.billDay ?? 1, shouldAddZero: true ),  Utility.formatDecimal(nextMonth, shouldAddZero: true) + "-" + Utility.formatDecimal(((this.creditCardModel.billDay ?? 1) + 1), shouldAddZero: true ));
  }
}
