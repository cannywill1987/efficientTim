import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/beans/CreditCardModel.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';

import '../../../common/provider/Env.dart';
import '../../../common/provider/GlobalStateEnv.dart';
import '../../../components/CustomTabBarWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../util/Utility.dart';
import '../components/ListViewForBillDetail.dart';
import '../components/TitleAndSubtitleWidget.dart';
import '../components/WhiteContainer.dart';

class CreditCardDetailPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return CreditCardDetailPageState();
  }
}

class CreditCardDetailPageState extends BaseWidgetState<CreditCardDetailPage> {
  CreditCardModel creditCardModel = CreditCardModel();
  int curTab = 0;

  @override
  Widget build(BuildContext context) {
    return Selector<Env, Map?>(
        selector: (_, env) => env.creditCardDetailData,
        builder: (_, creditCardDetailData, __) {
          creditCardModel = creditCardDetailData?['data'] ?? CreditCardModel();
          return Container(
            decoration: BoxDecoration(
              //添加渐变色
              gradient: LinearGradient(
                colors: [Color(0xff5e6075), Color(0xff2a2c3a)],
                stops: [1, 0.9],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   mainAxisSize: MainAxisSize.max,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: <Widget>[
                  //     // Container(
                  //     //   width: 200,
                  //     //   height: 100,
                  //     //   alignment: Alignment.center,
                  //     //   decoration: BoxDecoration(
                  //     //     color: Color(0xff5e6075),
                  //     //     borderRadius: BorderRadius.circular(4),
                  //     //   ),
                  //     //   child: Column(
                  //     //     mainAxisAlignment: MainAxisAlignment.center,
                  //     //     children: <Widget>[
                  //     //       Icon(Icons.add, color: Colors.white),
                  //     //       Text('关联卡权益',
                  //     //           style: TextStyle(
                  //     //               color: Colors.white, fontSize: 14)),
                  //     //     ],
                  //     //   ),
                  //     // ),
                  //     SizedBox(width: 20),
                  //     Padding(
                  //       padding: const EdgeInsets.only(top: 5.0),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(this.creditCardModel.bankName ?? "",
                  //               style: TextStyle(
                  //                   color: Colors.white, fontSize: 20)),
                  //           SizedBox(
                  //             height: 5,
                  //           ),
                  //           Text(this.creditCardModel.bankId ?? "",
                  //               textAlign: TextAlign.left,
                  //               style: TextStyle(
                  //                   color: Colors.white, fontSize: 20)),
                  //         ],
                  //       ),
                  //     ),
                  //     SizedBox(width: 20),
                  //     IconButton(
                  //       icon: Icon(
                  //         Icons.settings,
                  //         size: 22,
                  //       ),
                  //       onPressed: () {},
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  CreditCardContainer(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TitleAndSubtitleWidget(
                            title: getI18NKey().bill_day,
                            subtitle: Utility.getCurMonth() +
                                "-" +
                                Utility.formatDecimal(
                                    this.creditCardModel.billDay ?? 1,
                                    shouldAddZero: true),
                          ),
                        ),
                        Expanded(
                          child: TitleAndSubtitleWidget(
                            title: getI18NKey().repayment_day,
                            subtitle: Utility.getCurMonth() +
                                "-" +
                                Utility.formatDecimal(
                                    this.creditCardModel.repayDay ?? 1,
                                    shouldAddZero: true),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // CreditCardContainer(
                  //   child: Column(
                  //     children: [
                  //       CustomTabBarWidget(
                  //         list: CONSTANTS.getCreditCardDetailButtonList(),
                  //         onCheckedListener: (int index) {
                  //           this.curTab = index;
                  //         },
                  //       ),
                  //       if(this.curTab == 0)
                  //         ListViewForBillDetail(
                  //           creditCardModel: this.creditCardModel,
                  //           time: Utility.getTimeStampToday(),
                  //           onTapUpdateListener: () {},
                  //         )
                  //     ],
                  //   ),
                  // ),

                  // Add the other two parts here
                ],
              ),
            ),
          );
        });
  }
}
