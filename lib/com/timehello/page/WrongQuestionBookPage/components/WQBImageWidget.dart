import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BlackCheckButtonListWidget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../components/ImagesWrapperWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../models/WQBMissionModel.dart';
import '../../statisticPage/components/TitleContainerWidget.dart';
import '../WQBReadOnlyPage.dart';
import 'WQBRichEditorPage.dart';

class WQBImageWidget extends StatefulWidget {
  WQBMissionModel wqbMissionModel;
  SaveModeEnum editTypeEnum;

  WQBImageWidget({required this.wqbMissionModel, required this.editTypeEnum});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WQBImageWidgetState(this.editTypeEnum);
  }
}

class WQBImageWidgetState extends State<WQBImageWidget> {
  SaveModeEnum editTypeEnum;

  late TextEditingController _controller;

  WQBImageWidgetState(this.editTypeEnum);

  @override
  void initState() {
    _controller =
        TextEditingController(text: this.widget.wqbMissionModel?.content ?? "");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return this.editTypeEnum == SaveModeEnum.normal
        ? CachedNetworkImage(
            // width: 100,
            // height: 50,
            imageUrl:
                "https://mbd.baidu.com/newspage/data/landingsuper?context=%7B%22nid%22%3A%22news_9815751780478916625%22%7D&n_type=-1&p_from=-1",
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
            })
        : ImagesWrapperWidget(
      listBigImages: [],
      listSmallImages: [],
      listOriginImages: [],
      onChange:
          (listOriginImages, listSmallImages, listBigImages) {
        // this.widget.courseModel?.imageSmallUrls = listSmallImages;
        // this.widget.courseModel?.imageBigUrls = listBigImages;
        // this.widget.courseModel?.imageOriginUrls =
        //     listOriginImages;
      },
    );
  }
}
