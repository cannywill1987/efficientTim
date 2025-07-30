import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/InputNumber.dart';
import 'package:time_hello/com/timehello/libs/mongodb/response/MongoDbUpdated.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../beans/BillModel.dart';
import '../../../beans/CreditCardModel.dart';
import '../../../components/InputMenuItem.dart';
import '../../../components/MenuItem2.dart';
import '../../../config/ColorsConfig.dart';
import '../../../config/StylesConfig.dart';
import '../../../libs/mongodb/response/MongoDbSaved.dart';
import '../../../util/DeviceInfoManagement.dart';

class CreateCreditCardPage extends BaseWidget {
  CreditCardModel creditCardModel = CreditCardModel();

  CreateCreditCardPage({required this.creditCardModel});

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return CreateCreditCardPageState();
  }
}

class CreateCreditCardPageState extends BaseWidgetState<CreateCreditCardPage> {
  final _formKey = GlobalKey<FormState>();
  String? cardNumber = "",
      bankName = "",
      realName = "",
      currentAmount = "",
      creditLimit = "";
  bool isRequesting = false;
  double curBillAmount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(this.widget.creditCardModel.objectId != null) {
      curBillAmount = Utility.getBillAmountFromRepaymentDatas(
          repaymentData:
          this.widget.creditCardModel.repaymentData ?? [],
          curMonthTimeStamp: Utility.getTimeStampToday());
      if (curBillAmount == -1) {
        curBillAmount = 0;
      }
    }
  }

  //头部黑色333333 显示text信用卡账单
//下面是9c9c9c 的 添加账单，提醒还款，避免预期 text文案
//
//在下面是色值e5e5e5的分割线组成的item
//每个item左边是333333标题，右边是背景色透明的色值为c6c6c8的输入框，输入框色值333333
//
//每个item的内容分别是
//第一个 标题 卡号，placeholder 请输入完整卡号，输入框只能输入数字
//第二个 标题 银行，placeholder 请输入银行名称，输入框只能输入数字
//第三个 标题 姓名，placeholder 请输入真是姓名
//第四个 出账日，右边输入框改为333333 Text 最右边有向右灰色箭头
//第五个 还款日，右边输入框改为333333 Text 最右边有向右灰色箭头
//第六个 标题 本期金额，placeholder 请输入账单金额，输入框只能输入数字和.
//第七个 标题 信用额度，placeholder 请输入信用额度(选填)，输入框只能输入数字和.

//最下面是一个按钮，按钮文案是添加账单，按钮背景色是333333，按钮文案色值是ffffff
  @override
  baseBuild(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            this.widget.creditCardModel.objectId == null ? getI18NKey().addBill : getI18NKey().update_bill,
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xFF333333))),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            this.widget.creditCardModel.objectId == null ? getI18NKey().addBillReminder : getI18NKey().update_credit_card_bill,
            style: TextStyle(color: Color(0xFF9C9C9C)),
          ),
          SizedBox(height: 16.0),
          // Divider(
          //   color: Color(0xFFE5E5E5),
          // ),
          SizedBox(height: 16.0),
          // MenuItem2(
          //     title: "title",
          //     subTitle: "(${getI18NKey().optional})",
          //     onTapListener: (data) async {
          //     },
          //     rightPartContainer: ,
          //     icon: Utility.getSVGPicture(R.assetsImgIcStarttimeOrange,
          //         size: StylesConfig.iconSize)),
          buildItem(getI18NKey().card_number,
              placeholder: getI18NKey().enterFullCardNumber,
              keyboardType: TextInputType.number,
              defaultVal: this.widget.creditCardModel.bankId == null
                  ? ""
                  : this.widget.creditCardModel.bankId,
              inputFormattersList: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")), //数字包括小数
              ], onChange: (v) {
            this.widget.creditCardModel.bankId = v;
          }),

          buildItem(getI18NKey().bank,
              placeholder: getI18NKey().enterBankName,
              keyboardType: TextInputType.text,
              defaultVal: this.widget.creditCardModel.bankName == null
                  ? ""
                  : this.widget.creditCardModel.bankName, onChange: (v) {
            this.widget.creditCardModel.bankName = v;
          }),
          buildItem(getI18NKey().name,
              placeholder: getI18NKey().enterRealName,
              keyboardType: TextInputType.text,
              defaultVal: this.widget.creditCardModel.name, onChange: (v) {
            this.widget.creditCardModel.name = v;
          }),
          buildItem(getI18NKey().billing_day,
              rightChild: Container(
                  width: 200,
                  child: InputNumber(
                    defaultVal: this.widget.creditCardModel.billDay ?? 1,
                    unit: DeviceInfoManagement.getLanguage() == "zh" ? "日" : "",
                    onValueChangeListener: (obj, int? durationEachTomato) {
                      this.widget.creditCardModel.billDay = obj;
                    },
                  ))),
          buildItem(getI18NKey().repayment_day,
              rightChild: Container(
                  width: 200,
                  child: InputNumber(
                    defaultVal: this.widget.creditCardModel.repayDay ?? 1,
                    unit: DeviceInfoManagement.getLanguage() == "zh" ? "日" : "",
                    onValueChangeListener: (obj, int? durationEachTomato) {
                      this.widget.creditCardModel.repayDay = obj;
                    },
                  ))),
          // buildItem('还款日', placeholder: '请选择还款日', keyboardType: TextInputType.number,
          //     defaultVal: this.widget.creditCardModel.repayDay == null
          //         ? ""
          //         : this.widget.creditCardModel.repayDay.toString(),
          //     onChange: (v) {
          //   this.widget.creditCardModel.repayDay = int.parse(v);
          // }),
          buildItem(getI18NKey().current_amount,
              placeholder: getI18NKey().enterBillAmount,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormattersList: [
                FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //数字包括小数
              ],
              defaultVal: Utility.getBillAmountFromRepaymentDatas(
                          repaymentData:
                              this.widget.creditCardModel.repaymentData ?? [],
                          curMonthTimeStamp: Utility.getTimeStampToday()) ==
                      -1
                  ? ""
                  : Utility.getBillAmountFromRepaymentDatas(
                          repaymentData:
                              this.widget.creditCardModel.repaymentData ?? [],
                          curMonthTimeStamp: Utility.getTimeStampToday())
                      .toString(), onChange: (v) {
            if (this.widget.creditCardModel.repaymentData == null) {
              this.widget.creditCardModel.repaymentData = [];
            }
            Utility.addAndUpdateRepaymentDay(
                this.widget.creditCardModel.repaymentData!,
                amount: curBillAmount = double.parse(v),
                repaymentStatus: 0);
            // this.widget.creditCardModel.repayDay = v;
          }),
          buildItem(getI18NKey().credit_limit,
              placeholder: getI18NKey().enterCreditLimit,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormattersList: [
                FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //数字包括小数
              ],
              defaultVal: this.widget.creditCardModel.creditAmount.toString(),
              onChange: (v) {
            this.widget.creditCardModel.creditAmount = int.parse(v);
          }),
          SizedBox(height: 16.0),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              onTapCreateAndUpdateItem();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    ColorsConfig.colorB58D67,
                    ColorsConfig.colorB58D67,
                    ColorsConfig.colorE5D1B2,
                    ColorsConfig.colorF9EED2,
                    ColorsConfig.colorEFEFED,
                    ColorsConfig.colorF9EED2,
                    ColorsConfig.colorB58D67,
                  ],
                  begin: Alignment(-1, -4),
                  end: Alignment(1, 4),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: Text(
                getI18NKey().submit,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'halter',
                  fontSize: 14,
                  package: 'flutter_credit_card',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTapCreateAndUpdateItem() async {
    if(this.isRequesting == true) {
      return;
    }
    this.isRequesting = true;
    //创建
    if (TextUtil.isEmpty(this.widget.creditCardModel.objectId)) {
      MongoDbSaved? res = await MongoApisManager.getInstance()
          .insertCreditCardModel(creditCardModel: this.widget.creditCardModel);
      if (res != null) {
        MongoApisManager.getInstance().insertBillModel(billModel: BillModel(
          creditCardId: res.objectId,
          status: 0,
          value: 0 ,
          amount: curBillAmount,
          paymentMethod: -1,
        ));
        Utility.popupPagePCAndMobile(context);
      }
    } else { //更新
      MongoDbUpdated? res = await MongoApisManager.getInstance()
          .update_CreditCardModel(creditCardModel: this.widget.creditCardModel);

      if (res != null) {
        MongoApisManager.getInstance().insertBillModel(billModel: BillModel(
          creditCardId: this.widget.creditCardModel.objectId,
          status: 1,
          value: 0 ,
          amount: curBillAmount,
          paymentMethod: -1,
        ));
        Utility.popupPagePCAndMobile(context);
      }
    }
    this.isRequesting = false;
  }

  Widget buildItem(String title,
      {Widget? rightChild,
      String? placeholder,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormattersList,
      dynamic? defaultVal = "",
      Function? onChange}) {
    if (inputFormattersList == null) inputFormattersList = [];
    return InputMenuItem(
      title: title,
      maxWidth: 120,
      rightPartContainer: rightChild != null
          ? rightChild
          : Expanded(
              child: TextFormField(
                textAlign: TextAlign.end,
                initialValue: defaultVal,
                inputFormatters: inputFormattersList ?? [],
                onChanged: (val) {
                  onChange?.call(val);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: placeholder,
                  filled: true,
                  fillColor: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
                ),
                keyboardType: keyboardType,
              ),
            ),
      // onChange: onChange, icon: null,
    );
  }

  Widget buildItemWithSuffixIcon(
      String title, TextInputType keyboardType, IconData suffixIcon) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Color(0xFF333333)),
          ),
          Row(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFC6C6C8),
                ),
                keyboardType: keyboardType,
              ),
              Icon(suffixIcon, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}
