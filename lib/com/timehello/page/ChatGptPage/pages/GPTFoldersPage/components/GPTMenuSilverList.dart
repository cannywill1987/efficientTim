import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/ChatGptFolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderModelWithExtraData.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/com/timehello/util/WidgetManager.dart';

import '../../../../../../../r.dart';
import '../../../../../models/CalendarModel.dart';
import '../../../../../models/WQBFolderModel.dart';
import '../../../../../models/WQBFolderModelWithExtraData.dart';


typedef OnTapFinishListener = void Function(dynamic obj);
typedef OnTapEditListener = void Function(dynamic obj);
typedef OnTapDeleteListener = void Function(dynamic obj);
typedef OnTapShareListener = void Function(dynamic obj);
typedef OnTapCreateFolderListener = void Function(dynamic obj);
typedef OnTapCreateTagListener = void Function(dynamic obj);

class GPTMenuSilverList extends StatefulWidget {
  List<ChatGptFolderModel> _datas = [];
  OnTapListener? onTapListener;
  Function? onTapMoreListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapShareListener? onTapShareListener;
  GPTMenuSilverListState? menuSilverListState;
  OnTapCreateTagListener? onTapCreateTagListener;
  OnTapCreateFolderListener? onTapCreateFolderListener;
  CalendarModel calendarModel;

  // String curSelectedTitle;
  GPTMenuSilverList(
      {Key? key,
      required List<ChatGptFolderModel> datas,
      // required this.curSelectedTitle,
      OnTapListener? onTapListener,
      required this.calendarModel,
      this.onTapMoreListener,
      this.onTapFinishListener,
      this.onTapDeleteListener,
      this.onTapShareListener,
      this.onTapCreateTagListener,
      this.onTapCreateFolderListener,
      this.onTapEditListener})
      : super(key: key) {
    this.onTapListener = onTapListener;
    this.datas = datas;


  }

  set datas(List<ChatGptFolderModel> datas) {
    _datas = datas;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return menuSilverListState = new GPTMenuSilverListState();
  }
}

class GPTMenuSilverListState extends State<GPTMenuSilverList> {
  double iconSize = 18;
  String curSelectedObjectId = "";

  @override
  void initState() {
    if(this.widget._datas.length > 0) {
      this.curSelectedObjectId = this.widget._datas?[0].title ?? "";
    }
  } // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单





  @override
  Widget build(BuildContext context) {
    // if(screenType == ScreenType.Handset) {
    return getSliverList();
    // } else {
    return Container();
    // }
  }

  getSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if(this.widget._datas?.length == 0) {
          return SizedBox.shrink();
        } else {
          return getItem(index);
        }
      }, childCount: this.widget._datas?.length == 0 ? 1 : this.widget._datas?.length, addAutomaticKeepAlives: false),
    );
  }

  Widget getItem(int index) {
    bool isItemHover = false;
    ChatGptFolderModel _chatGptFolderModel =
        this.widget._datas![index];
    List<Widget> children = <Widget>[
      // Container(
      //     margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
      //     child: WidgetManager.getWQBFolderModelIcon(_folderModelWithExtraData.folderModel, iconSize)),
      SizedBox(
        width: 10,
      ),
      //标题
      Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_chatGptFolderModel.title ?? "",
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: ThemeManager.getInstance().isDark()
                          ? ColorsConfig.white
                          : ColorsConfig.gray_40)),
            ],
          ),
          flex: 3),
    ];
    //用于展示 不用于存储 2-今天 明天 即将到来等 3-创建清单
    if ((DeviceInfoManagement.isMoible() == true || DeviceInfoManagement.isWebMobileBySize())) {
      return Slidable(
        key: ValueKey(_chatGptFolderModel),
        enabled: true,
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.15,
          children: getSlideActions(_chatGptFolderModel),
        ),
        child: getInnerItemWithoutContainer(_chatGptFolderModel, children),
      );
    } else {

      children.addAll([
        Wrap(
          children: [
            // _chatGptFolderModel.isHover == false
            //     ? Wrap(
            //   children: [
            //     SizedBox(
            //       width: 10,
            //     ),
            //         // Container(
            //         // padding: EdgeInsets.symmetric(
            //         //     horizontal: 8, vertical: 4),
            //         // decoration: BoxDecoration(
            //         //     color: ThemeManager.getInstance().getDefautThemeColor(),
            //         //     borderRadius: BorderRadius.only(
            //         //         topLeft: Radius.circular(20),
            //         //         topRight: Radius.circular(20),
            //         //         bottomRight: Radius.circular(20),
            //         //         bottomLeft: Radius.circular(2))),
            //         // child: Text(
            //         //     "11111111111111", //右侧分钟
            //         //     textAlign: TextAlign.right,
            //         //     style: TextStyle(
            //         //         fontSize: 12, color: ColorsConfig.white)))
            //   ],
            // )
            //     : SizedBox.shrink(),
            Offstage(
                offstage: _chatGptFolderModel.isHover == false,
                child: InkWell(
                    child: PopupMenuButton<String>(
                      tooltip: '',
                      offset: Offset(-70, 10), //弹出的popup便宜位置
                      onSelected: (String val) {
                        if (val == 'edit') {
                          this.widget.onTapEditListener!(_chatGptFolderModel);
                        } else if (val == 'delete') {
                          this
                              .widget
                              .onTapDeleteListener!(_chatGptFolderModel);
                        } else if (val == 'share') {
                          this
                              .widget
                              .onTapShareListener!(_chatGptFolderModel);
                        }
                      },
                      itemBuilder: (context) {
                        // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
                        // !TextUtil.isEmpty(_folderModelWithExtraData
                        //     .folderModel.courseModelId) &&
                          return get2PopupList();
                      },
                    )
                  // IconButton(
                  //   onPressed: () {
                  //     this.widget?.onTapMoreListener(_folderModelWithExtraData);
                  //   },
                  //   icon: Icon(
                  //     Icons.more_horiz,
                  //     size: 20,
                  //   ),
                  // ),
                )),
            SizedBox(
              width: 10,
            ),
          ],
          crossAxisAlignment: WrapCrossAlignment.center,
        )
      ]);
      //PC
      return MouseRegion(
          onEnter: (_) {
            setState(() {
              _chatGptFolderModel.isHover = true;
            });
          },
          onHover: (_) {},
          onExit: (_) {
            setState(() {
              _chatGptFolderModel.isHover = false;
            });
          },
          child: getInnerItemWithoutContainer(
              _chatGptFolderModel, children, isItemHover));
    }
  }


  List<Widget> getSlideActions(
      ChatGptFolderModel _folderModelWithExtraData) {
    //只有自己可以对课程编辑删除
    // !TextUtil.isEmpty(_folderModelWithExtraData.folderModel.courseModelId) &&
      return <Widget>[
        // IconSlideAction(
        //   caption: getI18NKey().edit,
        //   foregroundColor: Colors.white,
        //   color: Colors.blue,
        //   icon: Icons.edit,
        //   onTap: () {
        //     if (this.widget.onTapEditListener != null)
        //       this.widget.onTapEditListener!(_folderModelWithExtraData); //侧边栏编辑
        //   },
        // ),
        SlidableAction(
          label: getI18NKey().delete,
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          icon: Icons.delete,
          onPressed: (e) {
            if (this.widget.onTapDeleteListener != null)
              this
                  .widget
                  .onTapDeleteListener!(_folderModelWithExtraData); //侧边栏删除
          },
        ),
      ];
  }

  List<PopupMenuEntry<String>> get2PopupList() {
    return <PopupMenuEntry<String>>[
      // PopupMenuItem<String>(
      //   value: 'edit',
      //   child: Text(getI18NKey().edit, style: TextStyle(fontSize: 15)),
      // ),
      PopupMenuItem<String>(
        value: 'delete',
        child: Text(
          getI18NKey().delete,
          style: TextStyle(color: ColorsConfig.red, fontSize: 15),
        ),
      ),
    ];
  }

  List<PopupMenuEntry<String>> get3PopupList(
      WQBFolderModelWithExtraData folderModelWithExtraData) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'edit',
        child: Text(getI18NKey().edit, style: TextStyle(fontSize: 15)),
      ),
      // PopupMenuItem<String>(
      //   value: 'share',
      //   child: Text(
      //       folderModelWithExtraData.folderModel.isSharing != 0 &&
      //               !TextUtil.isEmpty(
      //                   folderModelWithExtraData.folderModel.courseModelId)
      //           ? getI18NKey().edit_sharing
      //           : getI18NKey().share,
      //       style: TextStyle(color: Color(0xffff8800), fontSize: 15)),
      // ),
      PopupMenuItem<String>(
        value: 'delete',
        child: Text(
          getI18NKey().delete,
          style: TextStyle(color: ColorsConfig.red, fontSize: 15),
        ),
      ),
    ];
  }

  InkWell getInnerItemWithoutContainer(
      ChatGptFolderModel _folderModel, List<Widget> children,
      [bool isItemHover = false]) {
    return InkWell(
        onTap: () {
          if (this.widget.onTapListener != null) {
            this.curSelectedObjectId =
                _folderModel.objectId ?? "";
            this
                .widget
                .onTapListener!(_folderModel); //点击item
            setState(() {

            });
          }
        },
        child: Container(
          height: 46,
          decoration: (Utility.isHandsetBySize() == false &&
                  this.curSelectedObjectId ==
                      _folderModel.objectId)
              ? BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 5, color: ThemeManager.getInstance().getDefautThemeColor())))
              : BoxDecoration(
                  border: Border(
                      right: BorderSide(
                          width: Utility.isHandsetBySize() == false ? 5 : 0,
                          color: Colors.transparent))),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ));
  }

  /**
   * 创建清单的Item
   */
  Wrap getCreateWidget(WQBFolderModelWithExtraData _folderModelWithExtraData) {
    return Wrap(
      children: [
        IconButton(
            icon: Utility.getSVGPicture(R.assetsImgIcTags, size: iconSize),
            onPressed: () {
              if (this.widget.onTapCreateTagListener != null) {
                this.widget.onTapCreateTagListener!(_folderModelWithExtraData);
              }
            }),
        IconButton(
            icon: Icon(
              Icons.create_new_folder,
              color: ColorsConfig.create_folder,
              size: iconSize,
            ),
            onPressed: () {
              if (this.widget.onTapCreateTagListener != null) {
                this
                    .widget
                    .onTapCreateFolderListener!(_folderModelWithExtraData);
              }
            }),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
