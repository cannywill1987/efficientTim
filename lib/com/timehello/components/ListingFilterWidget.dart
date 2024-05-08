import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';

import '../common/database/apis/MongoApisManager.dart';
import '../common/provider/GlobalStateEnv.dart';
import '../models/FolderModel.dart';
import '../models/SheetDataModel.dart';
import '../util/Utility.dart';
import 'MissionIcon.dart';

/**
 * 清单过滤组件
 */
class ListingFilterWidget extends StatefulWidget {
  OnTapListener onTapListener;

  ListingFilterWidget({required this.onTapListener});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListingFilterWidgetState();
  }
}

class ListingFilterWidgetState extends State<ListingFilterWidget> {
  List<SheetDataModel> listSheetDataModel = [];
  List<FolderModel> listFolderModels = [];
  FolderModel? curFolderModel;

  @override
  void initState() {
    requestData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Selector<GlobalStateEnv, List<FolderModel>>(
        selector: (_, globalStateEnv) => globalStateEnv.listFolderModels,
        builder: (_, listFlomoMissionModel, __) {
          return Container(
              margin: EdgeInsets.only(right: 0, left: 5),
              child: PopupMenuButton<String>(
                tooltip: '',
                padding: EdgeInsets.all(0.0),
                child: Container(
                    // decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    curFolderModel == null
                        ? Icon(Icons.done_all,
                            size: 20, color: Colors.lightGreenAccent)
                        : MissionIcon(
                            folderModel: curFolderModel!,
                            iconSize: 10,
                          ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                        constraints: BoxConstraints(
                            maxWidth: Utility.isHandsetBySize()
                                ? 110
                                : double.infinity),
                        child: Text(
                          curFolderModel?.title ?? getI18NKey().select_all,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: Utility.isHandsetBySize() ? 12 : 14),
                        )),
                    Icon(
                      Icons.navigate_next,
                      color: Color(0xff9a9a9a),
                    )
                  ],
                )),
                onSelected: (String indexParam) {
                  int index = int.parse(indexParam);
                  if (index == -1) {
                    this.curFolderModel = null;
                  } else {
                    this.curFolderModel = listFolderModels[index];
                  }
                  this.widget.onTapListener(this.curFolderModel);
                  setState(() {});
                },
                itemBuilder: (context) {
                  // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
                  return getPopupMenuList();
                },
              ));
        });
  }

  void requestData()  {
    List<FolderModel> list =  MongoApisManager.getInstance()
        .queryWhereEqual_folderModelWithCircle();
    List<SheetDataModel> listSheetDataModel =
        Utility.getSheetDataModelFromFolderModel(
            list, Icons.fiber_manual_record);
    if (mounted == true) {
        this.listFolderModels = list;
        this.listSheetDataModel = listSheetDataModel;
      // setState(() {
      // });
    }
  }

  List<PopupMenuEntry<String>> getPopupMenuList() {
    List<PopupMenuEntry<String>> list = [];
    int index = 0;
    list.add(PopupMenuItem<String>(
      value: (-1).toString(),
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 5,
          ),
          Icon(Icons.done_all, size: 15, color: Colors.lightGreenAccent),
          SizedBox(
            width: 5,
          ),
          Text(
            getI18NKey().select_all,
            style: TextStyle(
                fontSize: 15,  fontWeight: FontWeight.w500),
          )
        ],
      ),
    ));

    for (SheetDataModel sheetDataModel in listSheetDataModel) {
      list.add(PopupMenuItem<String>(
        value: sheetDataModel.index.toString(),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 5,
            ),
            sheetDataModel.icon ?? SizedBox.shrink(),
            SizedBox(
              width: 5,
            ),
            Text(
              sheetDataModel.title ?? '',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ));
      index++;
    }
    return list;
  }
}
