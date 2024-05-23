import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/beans/GameComparePictureBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/Observable.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/Loading.dart';
import 'package:time_hello/com/timehello/page/gamesPage/pages/games3/Games3Page.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../../../../../../r.dart';
import '../../../../beans/BaseBean.dart';
import '../../../../beans/GameAnswerJsonBean.dart';
import '../../../../beans/GameRankingBean.dart';
import '../../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../../common/httpclient/HttpManager.dart';
import '../../../../common/httpclient/Oberver.dart';
import '../../../../common/provider/Env.dart';
import '../../../../components/GameComparePicture.dart';
import '../../../../components/LivesWidget.dart';
import '../../../../config/ENUMS.dart';
import '../../../../config/Params.dart';
import '../../../../util/DialogManagement.dart';
import '../../../../util/EasyLoadingManager.dart';
import '../../../../util/GameCounterManagement.dart';
import '../../../../util/LoginManager.dart';
import '../../../../util/ScreenUtil.dart';
import '../../../../util/SharePreferenceUtil.dart';
import '../../../../util/WidgetManager.dart';
import '../../components/CircleBackNavigator.dart';
import '../../components/CustomFinishStateTableWidget.dart';
import '../../components/CustomGameItemBackground.dart';
import '../../components/CustomGameText.dart';
import '../../components/CustomNumsMissionGridviewWidget.dart';
import '../../components/GameCounterWidget.dart';
import '../../components/GameHeaderWidget.dart';
import '../../components/GameRankingDialogUtil.dart';

/**
 * game2 是记各种word
 */
class Games3GridViewPage extends BaseWidget {
  ResourceDeliveryInfoBean resourceDeliveryInfoBean;
  GameComparePictureBean? gameComparePictureBean;
  bool? canFinishedManually;

  Games3GridViewPage(
      {Key? key,
        this.gameComparePictureBean,
      required this.resourceDeliveryInfoBean,
      this.canFinishedManually: false})
      : super(key: key);

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _Games3GridViewPageWidgetState();
  }
}

class _Games3GridViewPageWidgetState<T>
    extends BaseWidgetState<Games3GridViewPage> implements Observer {
  // GameComparePictureBean? bean;
  List<GameComparePictureBean> list = [];

  @override
  void deactivate() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // this.isAppBarVisible = false;
    //初始化table的数据
  }

  componentDidMount() {
    initData();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'reset':
        break;
      case 'complete':
        break;
    }
  }

  initData() {
    requestGetRandomItem();
  }

  void requestGetRandomItem() async {
    // Loading.show(context);
    EasyLoadingManager.getInstance().showLoading();
    // DialogManagement.getInstance().showLoadingDialog(context);
    HttpManager.getInstance()
        .doPostRequest(Apis.getComparePicturesList, observer: this);
  }

  Widget baseBuild(BuildContext context) {
    return GameHeaderWidget(
        resourceDeliveryInfoBean: this.widget.resourceDeliveryInfoBean,
        children: [
          CustomNumsMissionGridviewWidget(
            datas: list,
            itemWidth: 50,
            onTapListener: (param) {
              GameComparePictureBean bean = param;
              if(Utility.isMobile()) {
                Utility.setScreenOrientationHorizontal();
              Utility.pushNavigator(
                  context,
                  new Games3Page(
                    gameComparePictureBean: bean,
                    resourceDeliveryInfoBean:
                        this.widget.resourceDeliveryInfoBean,
                    canFinishedManually: true,
                  ));
              } else {
                OverlayManagement.getInstance().openNewPageOverlay(context, new Games3Page(
                  gameComparePictureBean: bean,
                  resourceDeliveryInfoBean:
                  this.widget.resourceDeliveryInfoBean,
                  canFinishedManually: true,
                ));
              }
            },
          )
        ]);
  }

  @override
  void update(Observable o, BaseBean response, String scene) {
    // TODO: implement update
    EasyLoadingManager.getInstance().hideLoading();
    if (response.success) {
      if (scene == Apis.getComparePicturesList) {
        list = Utility.parseGameComparePictureBean(response.data);
        updateUI();
      }
    } else {
      Utility.showToastMsg(msg: response.message);
    }
  }
}
