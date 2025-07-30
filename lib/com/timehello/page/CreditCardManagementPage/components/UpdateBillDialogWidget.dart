import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class UpdateBillDialogWidget extends StatefulWidget {
  Function? onTapConfirmListener;
  Function? onTapClose;

  UpdateBillDialogWidget({this.onTapConfirmListener, this.onTapClose});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UpdateBillDialogWidgetState();
  }
}

class UpdateBillDialogWidgetState extends State<UpdateBillDialogWidget> {
  Color colorBlack = Color(0xFF373737);
  String val = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 290),
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
                  "标记已还款金额",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              getDivider(),
              Row(
                children: [
                  Text(
                    "金额",
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
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                            //数字包括小数
                          ],
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
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: getI18NKey().enter_amount,
                            hintStyle: TextStyle(
                              fontSize: 17,
                              color: Color(0xff909090),
                            ),
                          ),
                          controller: TextEditingController(
                            text: "",
                          ),
                          style: TextStyle(fontSize: 14)),
                    ),
                  )
                ],
              ),

              getDivider(),
              SizedBox(
                height: 5,
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
                    this.widget.onTapConfirmListener?.call(this.val);
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
              )
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
