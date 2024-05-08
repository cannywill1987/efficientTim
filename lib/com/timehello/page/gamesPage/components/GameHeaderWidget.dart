import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../../../r.dart';
import '../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../util/Utility.dart';

class GameHeaderWidget extends StatelessWidget {
  ResourceDeliveryInfoBean resourceDeliveryInfoBean;
  List<Widget> children;

  GameHeaderWidget(
      {required this.resourceDeliveryInfoBean, required this.children});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
        child: SingleChildScrollView(
            child: Column(children: [
          Container(
              height: 200,
              child: Stack(children: [
                CachedNetworkImage(
                  imageUrl: Utility.filterHttpUrl(this.resourceDeliveryInfoBean.resourceIconUrl ?? '', prefix: "oss"),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.red, BlendMode.colorBurn)),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ])),
          SizedBox(
            height: 4,
          ),
          Padding(padding: EdgeInsets.only(left: 10, right: 10), child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 4),
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Utility.getSVGPicture(
                      R.assetsImgIcObjective,
                      size: 14,
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 3),
                  Expanded(
                      child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                        new Text.rich(
                          //富文本文本框构造方法，可以显示多种样式的text，第一个参数为 TextSpan
                          new TextSpan(
                              text: '${getI18NKey().objective}:',
                              //文字样式，如果后面的子 TextSpan 没有覆盖该 TextStyle 中的属性，则使用该 TextStyle 指定的样式
                              style:
                                  TextStyle(fontSize: 14, color: Colors.orange),
                              //应该是手势识别监听器，后面用到手势监听再详细学习该类用法
//          recognizer: ,
                              //子 TextSpan，可以指定多个
                              children: <TextSpan>[
                                new TextSpan(
                                    text: this
                                        .resourceDeliveryInfoBean
                                        .resourceTitle!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: ThemeManager.getInstance()
                                            .getTextColor(
                                                defaultColor: Color(0xff404040)))),
                              ]),
                          textDirection: TextDirection.ltr,
                        ),
                      ]))
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Utility.getSVGPicture(
                    R.assetsImgIcMethod,
                    size: 20,
                    // color: Colors.white,
                  ),
                  Expanded(
                      child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                        new Text.rich(
                          //富文本文本框构造方法，可以显示多种样式的text，第一个参数为 TextSpan
                          new TextSpan(
                              text: '${getI18NKey().method}:',
                              //文字样式，如果后面的子 TextSpan 没有覆盖该 TextStyle 中的属性，则使用该 TextStyle 指定的样式
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xfff9d879)),
                              //应该是手势识别监听器，后面用到手势监听再详细学习该类用法
//          recognizer: ,
                              //子 TextSpan，可以指定多个
                              children: <TextSpan>[
                                new TextSpan(
                                    text: this
                                        .resourceDeliveryInfoBean
                                        .resourceContent!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: ThemeManager.getInstance()
                                            .getTextColor(
                                            defaultColor: Color(0xff404040), defaultDarkColor: Color(0xffc0c0c0)))),
                              ]),
                          textDirection: TextDirection.ltr,
                        ),
                      ]))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              ...this.children
            ],
          ),)
        ])));
  }
}
