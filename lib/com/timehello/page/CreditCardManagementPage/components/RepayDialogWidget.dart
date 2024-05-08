import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/CONSTANTS.dart';
import '../../../models/CheckButtonStateModel.dart';
import 'RepayCheckButtonListWidget.dart';

class RepayDialogWidget extends StatefulWidget {
  Function? onTapConfirmListener;
  Function? onTapClose;
  String defaultVal = "";

  RepayDialogWidget(
      {required this.onTapConfirmListener,
      required this.onTapClose,
      required this.defaultVal});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RepayDialogWidgetState(defaultVal: defaultVal);
  }
}

class RepayDialogWidgetState extends State<RepayDialogWidget> {
  Color colorBlack = Color(0xFF373737);
  String val = "";
  int paymentMethod = 0;
  TextEditingController controller = TextEditingController(
    text: "",
  );

  RepayDialogWidgetState({required String defaultVal}) {
    controller.text = defaultVal;
    this.val = defaultVal;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 380),
          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  getI18NKey().mark_repaid_amount,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              getDivider(),
              Row(
                children: [
                  Text(
                    getI18NKey().amount,
                    style: TextStyle(
                      color: colorBlack,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      //textfield不需要下划线和任何decoration和下划线
                      child: TextField(
                          // focusNode: focusNode,
                          onChanged: (val) {
                            // this.widget.data.title = val;
                            // // if (this.widget.onChangeListener != null) {
                            // this.widget.onChangeListener.call(this.widget.data);
                            // }
                            this.val = val;
                          },
                          onSubmitted: (String value) {
                            // if (this.widget.onSubmitListener != null) {
                            //   this.widget.onSubmitListener.call();
                            // }

                            print(value);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: getI18NKey().enter_amount,
                            hintStyle: TextStyle(
                              fontSize: 17,
                              color: Color(0xff909090),
                            ),
                          ),
                          controller: controller,
                          style: TextStyle(fontSize: 14)),
                    ),
                  )
                ],
              ),
              getDivider(),
              Text(
                getI18NKey().repayment_channel,
                style: TextStyle(
                  color: colorBlack,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RepayCheckButtonListWidget(
                onTapListener: (res) {
                  switch (res.creditCardModel['code']) {
                    case "bank":
                      paymentMethod = 0;
                      break;
                    case "alipay":
                      paymentMethod = 1;
                      break;
                    case "wechat":
                      paymentMethod = 2;
                      break;
                    case "cash":
                      paymentMethod = 3;
                      break;
                  }
                },
                list: CONSTANTS.getRepayDialogList() ?? [],
              ),
              getDivider(),
              Container(
                padding: EdgeInsets.only(right: 10),
                color: Color(0xfff7f7f7),
                height: 40,
                child: Row(
                  children: [
                    Spacer(),
                    Text(
                      getI18NKey().repayment_record,
                      style: TextStyle(color: Color(0xff51a9f8), fontSize: 14),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //黄色背景按钮
              Container(
                margin: EdgeInsets.only(top: 10),
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xffffd800),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () {
                    this
                        .widget
                        .onTapConfirmListener
                        ?.call(this.val, this.paymentMethod);
                  },
                  child: Text(
                    getI18NKey().confirm,
                    style: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    this.widget.onTapClose?.call();
                  },
                  child: Text(
                    getI18NKey().close,
                    style: TextStyle(color: Color(0xff999999)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container getDivider() => Container(
        height: 1,
        margin: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        color: Color(0xffcfcfcf),
      );
}
