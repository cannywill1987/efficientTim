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
import '../../../../beans/BaseBean.dart';
import '../../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../../beans/Word/VocabularyLevelBean.dart';
import '../../../../beans/Word/VocabularyLevelList.dart';
import '../../../../beans/Word/WordBean.dart';
import '../../../../common/httpclient/HttpManager.dart';
import '../../../../common/httpclient/Oberver.dart';
import '../../../../config/Params.dart';
import '../../../../util/DialogManagement.dart';
import '../../../../util/EasyLoadingManager.dart';
import '../../../../util/VocabularyManager.dart';
import '../../components/CustomTextGridviewWidget.dart';
import '../../components/GameHeaderWidget.dart';
import 'Games4Page.dart';
import 'Games4UnitGridViewPage.dart';

/**
 * game2 是记各种word
 */
class Games4GridViewPage extends BaseWidget {
  ResourceDeliveryInfoBean resourceDeliveryInfoBean;
  // GameComparePictureBean? gameComparePictureBean;
  bool? canFinishedManually;

  Games4GridViewPage(
      {Key? key,
      // this.gameComparePictureBean,
      required this.resourceDeliveryInfoBean,
      this.canFinishedManually: false})
      : super(key: key);

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _Games4GridViewPageWidgetState();
  }
}

class _Games4GridViewPageWidgetState<T>
    extends BaseWidgetState<Games4GridViewPage> implements Observer {
  // GameComparePictureBean? bean;
  // List<GameComparePictureBean> list = [];
  List<VocabularyLevelBean> vocabularyLevelList = [];
  List<WordBean>? listWordBean;

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

  initData() async {
    EasyLoadingManager.getInstance().showLoading();
    VocabularyLevelList? vocabularyLevelList = await VocabularyManager.getInstance()?.requestGetVocabulariLevelList();
    this.vocabularyLevelList = vocabularyLevelList?.list ?? [];
    // listWordBean = await VocabularyManager.getInstance()?.requestGetRandomWordList(vocabularyLevelList?.list?[0].url ?? "", 5);
    updateUI();
    EasyLoadingManager.getInstance().dismiss();
  }

  // void requestGetRandomItem() async {
  //   // Loading.show(context);
  //   DialogManagement.getInstance().showLoadingDialog(context);
  //   await HttpManager.getInstance()
  //       .doPostRequest(Apis.getComparePicturesList, observer: this);
  // }

  Widget baseBuild(BuildContext context) {
    return GameHeaderWidget(
        resourceDeliveryInfoBean: this.widget.resourceDeliveryInfoBean,
        children: [
          CustomTextGridviewWidget(
            datas: this.vocabularyLevelList,
            itemWidth: 50,
            onTapListener: (param) {
              // GameComparePictureBean bean = param;
              if (Utility.isMobile()) {
                // Utility.setScreenOrientationHorizontal();
                Utility.pushNavigator(
                    context,
                    new Games4UnitGridViewPage(
                      resourceDeliveryInfoBean:
                          this.widget.resourceDeliveryInfoBean,
                      canFinishedManually: true, vocabularyLevelBean: param,
                    ));
              } else {
                DialogManagement.getInstance().showPCCustomDialog(
                    context: context,
                    widget: new Games4UnitGridViewPage(
                      resourceDeliveryInfoBean:
                      this.widget.resourceDeliveryInfoBean,
                      vocabularyLevelBean: param,
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
    Loading.hide(context);
    if (response.success) {
      if (scene == Apis.getComparePicturesList) {
        // list = Utility.parseGameComparePictureBean(response.data);
        updateUI();
      }
    } else {
      Utility.showToast(msg: response.message);
    }
  }


}
