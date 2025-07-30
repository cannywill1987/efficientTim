import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/ChatGptPage.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/pages/GPTFoldersPage/GPTFoldersPage.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/pages/GPTRoleGridViewPage.dart';
import 'package:time_hello/com/timehello/page/WrongQuestionBookPage/WQBMissionPage.dart';
import 'package:time_hello/com/timehello/page/WrongQuestionBookPage/WrongQuestionBookPage.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';

import '../../common/provider/GlobalStateEnv.dart';
import '../../components/TransparentOverlayPage.dart';
import '../../config/CONSTANTS.dart';
import '../../config/ENUMS.dart';
import '../../util/ScreenUtil.dart';
import '../../util/Utility.dart';

class GPTContainer extends BaseWidget {
  const GPTContainer();

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return GPTContainerState();
  }
}

class GPTContainerState extends BaseWidgetState<GPTContainer> {
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

  @override
  Widget baseBuild(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   // title: Text('Test Page'),
      // ),
      drawer: Drawer(
        width: ScreenUtil.getScreenW(context) * 9 / 10,
        child: GPTFoldersPage(
          onTapItemListener: () {
            _scaffoldKey.currentState?.closeDrawer();
          },
        ),
      ),
      body: Stack(
        children: [
          ChatGptPage(
            pageGPTFromEnum: PageGPTFromEnum.AIHelperPage,
          ),
          // if (LoginManager.getInstance().isVIP(
          //     shouldShowDialog: false,
          //     paymentPromotionAdsModeEnum:
          //         PaymentPromotionAdsModeEnum.AIHelper) == false)
          //   Expanded(child: Container(
          //     child: TransparentOverlayPage(
          //       onTapCallback: () {
          //         LoginManager.getInstance().isVIP(
          //             shouldShowDialog: true,
          //             paymentPromotionAdsModeEnum:
          //                 PaymentPromotionAdsModeEnum.AIHelper);
          //       },
          //     ),
          //   ))
        ],
      ),
    );
  }

  Widget baseDesktoptBuild(context) {
    return Stack(
      children: [
        Row(
          children: [
            Container(
                width: 300,
                child: GPTFoldersPage(
                  onTapItemListener: () {},
                )),
            // Container(
            //     width: 300, child: WQBMissionPage(key: ValueKey("12121"))),
            // Expanded(child:  WQBMissionPage(key: ValueKey("12121"))),
            Expanded(
                child: ChatGptPage(
              pageGPTFromEnum: PageGPTFromEnum.AIHelperPage,
            )),
            // Expanded(child: GPTRoleGridViewPage())
            // Expanded(child:  WrongQuestionBookPage(key: ValueKey("12121"), wqbMissionModel: WQBMissionModel(), isEditable: false,))
          ],
        ),
        // if (LoginManager.getInstance().isVIP(
        //     shouldShowDialog: false,
        //     paymentPromotionAdsModeEnum:
        //     PaymentPromotionAdsModeEnum.AIHelper) == false)
        //   Expanded(child: Container(
        //     child: TransparentOverlayPage(
        //       onTapCallback: () {
        //         LoginManager.getInstance().isVIP(
        //             shouldShowDialog: true,
        //             paymentPromotionAdsModeEnum:
        //             PaymentPromotionAdsModeEnum.AIHelper);
        //       },
        //     ),
        //   )
    // )
      ],
    );
  }
}
