
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import '../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../common/provider/GlobalStateEnv.dart';
import '../../../components/CustomMarquee.dart';
import '../../../config/ColorsConfig.dart';
import '../../../config/Params.dart';

class GameListViewWidget extends StatefulWidget {
  List<ResourceDeliveryInfoBean> datas = [];
  OnTapListener? onTapListener;
  GameListViewWidgetState? gameGridViewWidgetState;

  GameListViewWidget({
    Key? key,
    required List<ResourceDeliveryInfoBean> datas,
    OnTapListener? onTapListener,
  }) : super(key: key) {
    this.datas = datas;
    this.onTapListener = onTapListener;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return gameGridViewWidgetState = new GameListViewWidgetState();
  }
}

class GameListViewWidgetState extends State<GameListViewWidget> {
  int page = 1;
  int pageSize = 10;
  List<ResourceDeliveryInfoBean>? list = null;

  requestData() {
    this.list = context.read<GlobalStateEnv>().gameBackgroundDeliveryInfoBeanList ?? [];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.requestData();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = this.widget.datas.length > 0
        ? ListView.builder(
            itemCount: this.widget.datas.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return CustomMarquee(bean: MarqueInfo.marqueGamepage,);
              } else {
                return getItem(index, this.widget.datas[index - 1]);
              }
            },
          )
        : SizedBox.shrink();
    return widget;
  }

  // getSliverList() {
  //   return SliverList(
  //     delegate: SliverChildBuilderDelegate((context, index) {
  //       return getItem(index);
  //     }, childCount: this.widget._datas?.length, addAutomaticKeepAlives: false),
  //   );
  // }

  Widget getItem(int index, ResourceDeliveryInfoBean resourceDeliveryInfoBean) {
    return GestureDetector(
      onTap: () {
        if (this.widget.onTapListener != null) {
          this.widget.onTapListener!(resourceDeliveryInfoBean);
        }
      },
      child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: const Color(0xffffffff)),
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        width: 100,
                        height: 50,
                        imageUrl:
                            resourceDeliveryInfoBean.resourceIconUrl ?? '',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                // colorFilter: ColorFilter.mode(
                                //     Colors.red, BlendMode.colorBurn)
                            ),
                          ),
                        ),
                        // placeholder: (context, url) =>
                        //     CircularProgressIndicator(),
                        errorWidget: (context, url, error) {
                          return Icon(Icons.error);
                        }
                      ),
                      Positioned(
                          right: 0,
                          child: Container(
                            width: 30,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors:
                                      ThemeManager.getInstance().isDark() ? ColorsConfig.listColorsCardBlackToPurple : ColorsConfig.listColorsOpacityToWhite),
                            ),
                          ))
                    ],
                  ),
                  SizedBox(width: 3,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 250,
                        child: Text(
                        resourceDeliveryInfoBean.resourceTitle ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      )),
                      SizedBox(height: 3,),
                      Container(
                          width: 250,
                          child: Text(
                            resourceDeliveryInfoBean.resourceContent ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff707070), defaultDarkColor: Color(0xffc0c0c0)),
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            ],
          )),
    );
  }
}
