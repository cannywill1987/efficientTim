import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/beans/UserBean.dart';
import 'package:time_hello/com/timehello/components/LoginAvatarWidget.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/BeanParser.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../../../../../r.dart';
import '../../../beans/BaseBean.dart';
import '../../../common/httpclient/HttpManager.dart';
import '../../../components/AvatarWidget.dart';
import '../../../config/Params.dart';
import '../../../util/LoginManager.dart';

class RankingListWidget extends StatefulWidget {
  List<UserBean>? _datas = [];
  OnTapListener? onTapListener;
  RankingListWidgetState? rankingListWidgetState;

  RankingListWidget({
    Key? key,
    List<FolderModel>? datas,
    OnTapListener? onTapListener,
  }) : super(key: key) {
    this.onTapListener = onTapListener;
  }

  set datas(List<UserBean> datas) {
    _datas = datas;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return rankingListWidgetState = new RankingListWidgetState();
  }
}

class RankingListWidgetState extends State<RankingListWidget> {
  int page = 1;
  int pageSize = 10;
  List<UserBean>? list = null;

  Future<void> requestGetUserRankingList(
      {required int page, required int pageSize}) async {
    BaseBean response = await HttpManager.getInstance().doPostRequest(
        Apis.getUserRankingList,
        params: {"page": page, "pageSize": pageSize},
        context: context,
        isCachableOn: true,
        shouldShowErrorToast: false);
    if (response.success == true) {
      this.list = BeanParser.parseUserBeanList(response.data);
      setState(() {});
    } else {}
  }

  @override
  void initState() {
    super.initState();
    this.requestGetUserRankingList(pageSize: 50, page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return (this.list?.length ?? [].length) > 0
        ? Container(
        padding: EdgeInsets.only(left:12, right: 12),
        child: Column(
          children: [...buildList()],
        ))
        : SizedBox.shrink();
    // return getSliverList();
  }

  List<Widget> buildList() {
    List<Widget> listWidget = [];
    int index = 0;
    this.list?.forEach((UserBean userBean) {
      listWidget.add(getItem(index, userBean));
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
              color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ));
  }

  Widget getItem(int index, UserBean userBean) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            getNumWidget(index),
            AvatarWidget(avatar: userBean.avatar),
            Text(
              userBean.username.isEmpty
                  ? getI18NKey().unname_user
                  : userBean.username.toString(),
              style: TextStyle(
                  color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)),
                  // color: Color(0xff404040),
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
              getI18NKey().total_focus_time + ":" +
                  Utility.formatHourAndMin(userBean.totalFocusTime ?? 0),
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
