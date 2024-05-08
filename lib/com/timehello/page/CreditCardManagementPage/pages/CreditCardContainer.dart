import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/EmptyWidget.dart';
import 'package:time_hello/com/timehello/page/WrongQuestionBookPage/WQBMissionPage.dart';
import 'package:time_hello/com/timehello/page/WrongQuestionBookPage/pages/WQBFoldersPage/WQBFoldersPage.dart';

import '../../../util/Utility.dart';
import 'CreditCardDetailPage.dart';
import 'CreditCardPage.dart';

class CreditCardContainer extends BaseWidget {
  const CreditCardContainer();

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return CreditCardContainerState();
  }
}

class CreditCardContainerState extends BaseWidgetState<CreditCardContainer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isAppBarVisible = true;
    this.rightNavChildren = [
      IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
          // if (this.widget.onTapNavMenuListener != null) {
          //   this.widget.onTapNavMenuListener!();
          // }
        },
      )
    ];
  }

  // @override
  // Widget baseBuild(BuildContext context) {
  //   // TODO: implement build
  //   return Scaffold(
  //     key: _scaffoldKey,
  //     // appBar: AppBar(
  //     //   // title: Text('Test Page'),
  //     // ),
  //     drawer: Drawer(
  //       width: ScreenUtil.getScreenW(context) * 9 / 10,
  //       child: WQBFoldersPage(onTapItemListener: () {
  //         _scaffoldKey.currentState?.closeDrawer();
  //       },),
  //     ),
  //     body: Stack(
  //       children: [
  //         WQBMissionPage(key: ValueKey('MissionPage21312'), onTapNavMenuListener: () {
  //           // _scaffoldKey.currentState?.openDrawer();
  //         },),
  //         Align(
  //           alignment: Utility.isHandsetBySize() == true
  //               ? Alignment(0.0, 0.75)
  //               : Alignment(0.0, 0.75),
  //           child: WQBButtonListWidget(
  //             width: Utility.isHandsetBySize() == true ? 55 : 80,
  //             initIndex: getInitIndex(),
  //             list: CONSTANTS.getWQBButtonsList(),
  //             onTapListener: (obj) {
  //               WQBModeEnum modeEnum = WQBModeEnum.values[obj['index']];
  //               context.read<GlobalStateEnv>().wqbModeEnum = modeEnum;
  //               // timelineModeEnum = TimelineModeEnum.values[obj['index']];
  //               // requestDatas();
  //             },
  //           ),
  //         )
  //       ],
  //     ),
  //   );;
  // }

  Widget baseBuild(context) {
    return Row(
      children: [
        Container(width: 500, child: CreditCardPage(onTapItemListener: () {},)),
        Container(width: 1, color: Color(0xFFe5e5e5), height: double.infinity,),
        // Container(
        //     width: 300, child: WQBMissionPage(key: ValueKey("12121"))),
        // Expanded(child:  WQBMissionPage(key: ValueKey("12121"))),

        Expanded(child:  CreditCardDetailPage())
        // Expanded(child:  WrongQuestionBookPage(key: ValueKey("12121"), wqbMissionModel: WQBMissionModel(), isEditable: false,))
      ],
    );
  }

  // int getInitIndex() {
  //   WQBModeEnum modeEnum = context.read<GlobalStateEnv>().wqbModeEnum;
  //   switch(modeEnum) {
  //     case WQBModeEnum.wrong_question_book:
  //       return 1;
  //     case WQBModeEnum.card:
  //       return 2;
  //     case WQBModeEnum.note:
  //       return 3;
  //     case WQBModeEnum.memorandum:
  //       return 4;
  //     default:
  //       return 0;
  //   }
  //   WQBModeEnum.values;
  // }
}