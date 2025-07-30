import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/ListingSecurityWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class FolderListView extends StatelessWidget {
  List<FolderModel> datas;
  double iconSize = 18;
  Function(FolderModel) onTapJoin;

  FolderListView({required this.datas, required this.onTapJoin});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: datas
          .map((folderModel) => Container(
                height: 46,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Icon(
                            (folderModel.tag == 0 ||
                                    folderModel.tag == false ||
                                    folderModel.tag == null)
                                ? Icons.calendar_today //今天
                                : folderModel.tag == 1
                                    ? IconData(folderModel.icon ?? 0,
                                        fontFamily: 'MaterialIcons') //任务folder
                                    : Icons.local_offer, //标签
                            color: (folderModel.tag == 0 ||
                                    folderModel.tag == false ||
                                    folderModel.tag == null)
                                ? Colors.pink //todo 这个是干啥 应该是默认颜色吧
                                : Color(folderModel.color),
                            size: iconSize)),
                    SizedBox(
                      width: 10,
                    ),
                    ListingSecurityWidget(
                      folder_id: folderModel.objectId ?? "",
                      cryptoVersion: folderModel.cryptoVersion ?? -1,
                      size: 16,
                      marginRight: 5,
                    ),

                    //标题
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(folderModel.title ?? "",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: ThemeManager.getInstance()
                                        .getTextColor(
                                            defaultColor:
                                                folderModel.iconType == 7
                                                    ? ThemeManager.getInstance()
                                                        .getDefautThemeColor()
                                                    : ColorsConfig.gray_40))),
                            TextUtil.isEmpty(folderModel.courseModelId) ==
                                        true &&
                                    (folderModel.isSharing == 0 ||
                                        folderModel.isSharing == null)
                                ? SizedBox.shrink()
                                : Text("1111",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                        color: ThemeManager.getInstance()
                                            .getTextColor(
                                                defaultColor:
                                                    Color(0xffff8800)))),
                          ],
                        ),
                        flex: 3),
                    InkWell(
                      onTap: () {
                        onTapJoin(folderModel);
                      },
                      child: Text(
                        "加入",
                        style: TextStyle(
                            color: ThemeManager.getInstance().getTextColor(),
                            fontSize: 14),
                      ),
                    )
                  ],
                ),
              ))
          .toList(),
    );
  }
}
