import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/beans/UserBean.dart';
import 'package:time_hello/com/timehello/components/LoginAvatarWidget.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/BeanParser.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../../../../../r.dart';
import '../../../beans/BaseBean.dart';
import '../../../beans/GameRankingBean.dart';
import '../../../common/httpclient/HttpManager.dart';
import '../../../config/Params.dart';
import '../../../util/SharePreferenceUtil.dart';

class GameRankingListWidget extends StatefulWidget {
  OnTapListener? onTapListener;
  GameRankingListWidgetState? gameRankingListWidgetState;
  String gameCode;
  String? gameMode;
  GameRankingBean gameRankingBean;
  Function onRequestComplete;
  String? gameLevel;
  GameRankingListWidget({
    Key? key,
    required this.gameLevel,
    required this.gameCode,
    this.gameMode = "",
    required this.gameRankingBean,
    required this.onRequestComplete,
    OnTapListener? onTapListener,
  }) : super(key: key) {
    this.onTapListener = onTapListener;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return gameRankingListWidgetState = new GameRankingListWidgetState();
  }
}

class GameRankingListWidgetState extends State<GameRankingListWidget> {
  int page = 1;
  int pageSize = 10;
  List<GameRankingBean>? list = null;

  Future<void> requestGetUserRankingList(
      {required int page, required int pageSize}) async {
    BaseBean response = await HttpManager.getInstance().doPostRequest(
        Apis.gameRankingGetList,
        params: {
          "page": page,
          "pageSize": pageSize,
          "valRanking": this.widget.gameRankingBean.time,
          "mode": "Order_By_Time",
          "gameLevel": this.widget.gameLevel,
          "gameCode": this.widget.gameCode
        },
        context: context,
        isCachableOn: true,
        shouldShowErrorToast: false);
    if (response.success == true) {
      Map data = response.data;
      this.list = BeanParser.parseGameRankingBeanList(data['data']['data']);
      this.widget.onRequestComplete(response.data);
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
            Text(
              getI18NKey().finish_time + ":" +
                  Utility.formatHourAndMinAndSec(bean.time ?? 0),
              style: TextStyle(color: Color(0xff909090), fontSize: 12),
            ),
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
