import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/LoginAvatarWidget.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/BeanParser.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../../../r.dart';
import '../../../../../beans/BaseBean.dart';
import '../../../../../beans/GameRankingBean.dart';
import '../../../../../common/httpclient/HttpManager.dart';
import '../../../../../config/ENUMS.dart';
import '../../../../../config/Params.dart';
import '../../../components/GameRankingNumWidget.dart';

/**
 *
 * 嵌入在 Game4RankingDialogUtil
 */
class Game4RankingListWidget extends StatefulWidget {
  OnTapListener? onTapListener;
  Game4RankingListWidgetState? gameRankingListWidgetState;
  String gameCode;
  String? gameMode;
  GameRankingBean? gameRankingBean;
  Function onRequestComplete;
  GameStatusModeEnum? gameStatusModeEnum;

  Game4RankingListWidget({
    Key? key,
    required this.gameCode,
     this.gameStatusModeEnum,
    this.gameMode = "",
     this.gameRankingBean,
    required this.onRequestComplete,
    OnTapListener? onTapListener,
  }) : super(key: key) {
    this.onTapListener = onTapListener;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return gameRankingListWidgetState = new Game4RankingListWidgetState();
  }
}

class Game4RankingListWidgetState extends State<Game4RankingListWidget> {
  int page = 1;
  int pageSize = 10;
  List<GameRankingBean>? list = null;

  Future<void> requestGetUserRankingList(
      {required int page, required int pageSize}) async {
    BaseBean response =
        await HttpManager.getInstance().doPostRequest(Apis.gameRankingGetList,
            params: {
              "page": page,
              "pageSize": pageSize,
              "valRanking": this.widget.gameRankingBean?.score ?? 0,
              "mode": "Order_By_Score",
              "gameLevel": this.widget.gameMode,
              "gameCode": this.widget.gameCode
            },
            context: context,
            isCachableOn: true,
            shouldShowErrorToast: false);
    if (response.success == true) {
      Map data = response.data;
      this.list = BeanParser.parseGameRankingBeanList(data['data']['data']);
      this.widget?.onRequestComplete(response.data);
      setState(() {});
    } else {}
  }

  @override
  void initState() {
    super.initState();
    this.requestGetUserRankingList(pageSize: 10, page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return (this.list?.length ?? [].length) > 0
        ? Container(
            height: 200,
            padding: EdgeInsets.only(left: 12, right: 12),
            child: SingleChildScrollView(
                child: Column(
              children: [...buildList()],
            )))
        : SizedBox.shrink();
    // return getSliverList();
  }

  List<Widget> buildList() {
    List<Widget> listWidget = [];
    int index = 0;
    this.list?.forEach((GameRankingBean bean) {
      listWidget.add(getItem(index, bean));
      listWidget.add(SizedBox(
        height: 5,
      ));
      index++;
    });

    return listWidget;
  }

  // getSliverList() {
  //   return SliverList(
  //     delegate: SliverChildBuilderDelegate((context, index) {
  //       return getItem(index);
  //     }, childCount: this.widget._datas?.length, addAutomaticKeepAlives: false),
  //   );
  // }

  Widget getNumWidget(int ranking) {
    double svgSize = 22;
    if (ranking == 0) {
      return Container(
        width: svgSize,
        height: svgSize,
        child: Utility.getSVGPicture(R.assetsImgIcNum1, size: svgSize),
      );
    } else if (ranking == 1) {
      return Container(
        width: svgSize,
        height: svgSize,
        child: Utility.getSVGPicture(R.assetsImgIcNum2, size: svgSize),
      );
    }
    if (ranking == 2) {
      return Container(
        width: svgSize,
        height: svgSize,
        child: Utility.getSVGPicture(R.assetsImgIcNum3, size: svgSize),
      );
    }
    return Container(
        alignment: Alignment.center,
        width: svgSize,
        height: svgSize,
        child: Text(
          (ranking + 1).toString(),
          style: TextStyle(
              color: Color(0xff404040),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ));
  }

  Widget getItem(int index, GameRankingBean bean) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            getNumWidget(index),
            LoginAvatarWidget(),
            Text(
              bean.username!.isEmpty
                  ? getI18NKey().unname_user
                  : bean.username.toString(),
              style: TextStyle(
                  color: Color(0xff404040),
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Row(
              children: [
                GameRankingNumWidget(
                  val: bean.val1!.toInt().toString(),
                  color: Color(0xff1afa29),
                  icon: Utility.getSVGPicture(R.assetsImgIcCorrect, size: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                GameRankingNumWidget(
                  val: bean.val2!.toInt().toString(),
                  color: Color(0xffd81e06),
                  icon: Utility.getSVGPicture(R.assetsImgIcError, size: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                // GameRankingNumWidget(
                //   val: Utility.getFunnel(
                //       numCharsCorrect: bean.val1, numCharsErrors: bean.val2),
                //   color: Color(0xff1296db),
                //   icon: Utility.getSVGPicture(R.assetsImgIcFunnel, size: 20),
                // )
              ],
            ),
            // Text(
            //   getI18NKey().finish_time + ":" +
            //       Utility.formatHourAndMinAndSec(bean.time),
            //   style: TextStyle(color: Color(0xff909090), fontSize: 12),
            // ),
            Text(
              getI18NKey().my_ranking((index + 1).toString()),
              style: TextStyle(color: Color(0xff909090), fontSize: 10),
            )
          ],
        )
      ],
    );
  }
}
