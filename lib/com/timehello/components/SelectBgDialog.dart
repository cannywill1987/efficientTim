//a dialog has listview, each item of listview has a container and image which will load source url ,To add a tap listener using InkWell, replace ${INSERT_HERE} with the following code:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';

import '../config/Params.dart';
import '../util/Utility.dart';

/**
 * 背景选择页面
 */
class SelectBgDialog extends StatelessWidget {
  List list = [];
  Function onTapListener;

  SelectBgDialog({required this.onTapListener, required this.list});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Stack(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
              child: ListView.builder(
                  itemCount: list.length + 1,
                  itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () => {
                  this.onTapListener!(ResourceInfo.pcMissionBackgroundResourceLocationInfoBean?.deliveryList?[index].resourcePictureUrl)
                  // add your onTap callback function here
                },
                child: Container(
                  // your container widget here
                  child: CachedNetworkImage(
                      width: 100,
                      height: 50,
                      imageUrl:
                      Utility.filterHttpUrl(ResourceInfo.pcMissionBackgroundResourceLocationInfoBean?.deliveryList?[index].resourceIconUrl  ?? '', prefix: "oss")
                      ,
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
                ),
              );
                  },
                ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: InkWell(
                onTap: () {
                  OverlayManagement.getInstance().hideSelectBgDialog();
                },
                child: Container(
                  // your container widget here
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ],
        ));
  }
}
