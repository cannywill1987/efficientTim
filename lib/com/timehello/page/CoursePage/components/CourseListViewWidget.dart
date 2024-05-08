
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import '../../../common/provider/GlobalStateEnv.dart';
import '../../../components/CustomMarquee.dart';
import '../../../config/ColorsConfig.dart';
import '../../../config/Params.dart';
import '../../../models/CourseModel.dart';
import '../../../util/Utility.dart';

class CourseListViewWidget extends StatefulWidget {
  List<CourseModel> datas = [];
  OnTapListener? onTapListener;
  CourseListViewWidgetState? gameGridViewWidgetState;

  CourseListViewWidget({
    Key? key,
    required List<CourseModel> datas,
    OnTapListener? onTapListener,
  }) : super(key: key) {
    this.datas = datas;
    this.onTapListener = onTapListener;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return gameGridViewWidgetState = new CourseListViewWidgetState();
  }
}

class CourseListViewWidgetState extends State<CourseListViewWidget> {
  int page = 1;
  int pageSize = 10;
  List<CourseModel>? list = null;

  @override
  void initState() {
    super.initState();
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

  Widget getItem(int index, CourseModel courseModel) {
    return GestureDetector(
      onTap: () {
        if (this.widget.onTapListener != null) {
          this.widget.onTapListener!(courseModel);
        }
      },
      child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          color: const Color(0xffffffff),
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
                        Utility.filterHttpUrl(courseModel.backgroundUrl ?? '', prefix: "oss"),
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
                                      ColorsConfig.listColorsOpacityToWhite),
                            ),
                          ))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 250,
                        child: Text(
                          courseModel.folderTitle ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color(0xff404040),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      )),
                      SizedBox(height: 3,),
                      Container(
                          width: 250,
                          child: Text(
                            courseModel.courseIntro ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(0xff707070),
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
