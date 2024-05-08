import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/CustomPopupWidget.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../components/ColorsWidget.dart';
import '../../../components/CustomFolderModelSelectPopupWidget.dart';
import '../../../components/CustomTagFolderModelSelectPopupWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../config/ENUMS.dart';
import '../../../libs/methodChannel/CounterMethodChannelManager.dart';
import '../../../libs/mongodb/response/MongoDbUpdated.dart';
import '../../../models/ColorsModel.dart';
import '../../../models/MissionModel.dart';
import '../../../models/WQBFolderModel.dart';
import '../../missionPage/componnents/BottomBar.dart';

class NoteWidget extends StatefulWidget {
  MissionModel missionModel;
  // Color circleColor = ColorsConfig.gray_cc_cancel;
  Color tagColor = ColorsConfig.gray_cc_cancel;
  OnTapBottomBarCircleListener? onTapCircleListener;
  OnTapBottomBarTagListener? onTapTagListener;
  // OnTapPriorityListener? onTapPriorityListener;
  Icon? iconCircle;

  // String? text;
  String circleTitle = "";
  int priority = 0;
  String? tagName = "";

  NoteWidget(
      {Key? key,
      this.iconCircle,
      this.tagName,
      required this.priority,
      required this.circleTitle,
      // required this.circleColor,
      // required this.tagColor,
      required this.missionModel,
      this.onTapCircleListener,
      this.onTapTagListener,
      // this.onTapPriorityListener
      })
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteWidgetState();
  }
}

class NoteWidgetState extends State<NoteWidget> {
  late TextEditingController _controller;
  FocusNode _contentFocusNode = FocusNode();
  EditorEditModeEnum editModeEnum = EditorEditModeEnum.normal;
  double marginRight = 10;
  double iconSize = 20;

  Function func = Utility.debounceWithWQB((NoteWidgetState state,
      MissionModel missionModel, String val) async {
    print("result: $val");
    missionModel.message = val;
    String valTrim = val.trim();
    state.updateEditMode(EditorEditModeEnum.saving);
    MongoDbUpdated? update = await MongoApisManager.getInstance()
        .update_MissionModel(missionModel: missionModel, shouldQueryMissionModel: false);
    // CounterMethodChannelManager.getInstance()
    //     .storeWQBNoteMissionData(missionModel);
    if (update != null) {
      state.updateEditMode(EditorEditModeEnum.saved_success);
    } else {
      state.updateEditMode(EditorEditModeEnum.saved_fail);
    }
  }, Duration(milliseconds: 3000));

  String getEditMode() {
    switch (this.editModeEnum) {
      case EditorEditModeEnum.normal:
        return "";
      case EditorEditModeEnum.editing:
        return getI18NKey().editing;
      case EditorEditModeEnum.saving:
        return getI18NKey().saving;
      case EditorEditModeEnum.saved_success:
        return getI18NKey().save_success;
      case EditorEditModeEnum.saved_fail:
        return getI18NKey().save_failure;
      default:
        return "";
    }
  }

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.text = this.widget.missionModel.message ?? "";
  }

  @override
  void didUpdateWidget(covariant NoteWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.missionModel.objectId != this.widget.missionModel.objectId) {
      _controller.text = this.widget.missionModel.message ?? "";
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        _contentFocusNode.requestFocus();
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeManager.getInstance().getInputDecorationColor(defaultColor: Color(
              CONSTANTS.getColors()[0].color)),
          borderRadius: BorderRadius.circular(4),
          // border: Border(
          //   bottom: BorderSide(
          //     color: Color(CONSTANTS.getColors()[0].color),
          //     width: 0.5,
          //   ),
          // ),
        ),
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: TextField(
                          // focusNode: _contentFocusNode,
                          maxLines: 3000,
                          controller: _controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 40), // Added line spacing of 3
                          ),
                          style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              //You can set your custom height here
                              color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)),
                              letterSpacing: 0,
                              wordSpacing: 0),
                        //   // hintText: getI18NKey().please_input_content),
                          onChanged: (val) {
                            // print(func);
                            updateEditMode(EditorEditModeEnum.editing);
                            func(this, this.widget.missionModel, val);
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Wrap(children: [
                    Text(
                      getEditMode(),
                      style: TextStyle(fontSize: 12, color: Color(0xff909090)),
                    ),
                    SizedBox(width: 5,),
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateUI() {
    if(mounted) {
      setState(() {});
    }
  }


  CustomTagFolderModelSelectPopupWidget getTagNameWidget() {
    return CustomTagFolderModelSelectPopupWidget(
      onSelected: (v) {
        if (this.widget.onTapTagListener != null) {
          this.widget.onTapTagListener!(v);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_offer,
            size: iconSize,
            color: this.widget?.tagColor,
          ),
          SizedBox(
            width: 5,
          ),
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 65),
              child: Text(
                this.widget.tagName ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ))
        ],
      ),
    );

    // return InkWell(
    //   onTap: () {
    //     if (this.widget.onTapTagListener != null) {
    //       this.widget.onTapTagListener!();
    //     }
    //   },
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       //
    //       // SizedBox(
    //       //   width: 5,
    //       // ),
    //       // Icon(
    //       //   Icons.local_offer,
    //       //   size: iconSize,
    //       //   color: this.widget.tagColor,
    //       // ),
    //       SizedBox(
    //         width: 5,
    //       ),
    //       ConstrainedBox(
    //           constraints: BoxConstraints(maxWidth: 300),
    //           child: Text(
    //             this.widget.tagName ?? "",
    //             maxLines: 1,
    //             overflow: TextOverflow.ellipsis,
    //             style: TextStyle(fontSize: 12),
    //           ))
    //     ],
    //   ),
    // );
  }

  Widget getCircleFolderModelWidget() {
    return CustomFolderModelSelectPopupWidget(
      onSelected: (v) {
        if (this.widget.onTapCircleListener != null) {
          this.widget.onTapCircleListener?.call(v);
        }
      },
      child: Wrap(
        children: [
          // this.widget.iconCircle ??
          //     Icon(Icons.fiber_manual_record,
          //         size: iconSize, color: this.widget.circleColor),
          // SizedBox(
          //   width: 5,
          // ),
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text(
                this.widget.circleTitle ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ))
        ],
        crossAxisAlignment: WrapCrossAlignment.center,
      ),
    );

    // return InkWell(
    //     onTap: () {
    //       if (this.widget.onTapCircleListener != null) {
    //         this.widget.onTapCircleListener!(null);
    //       }
    //     },
    //     child: Wrap(
    //       children: [
    //         // this.widget.iconCircle ??
    //         //     Icon(Icons.fiber_manual_record,
    //         //         size: iconSize, color: this.widget.circleColor),
    //         // SizedBox(
    //         //   width: 5,
    //         // ),
    //         ConstrainedBox(
    //             constraints: BoxConstraints(maxWidth: 100),
    //             child: Text(
    //               this.widget.circleTitle ?? "",
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,
    //               style: TextStyle(fontSize: 12),
    //             ))
    //       ],
    //       crossAxisAlignment: WrapCrossAlignment.center,
    //     ));
  }

  void updateEditMode(EditorEditModeEnum editModeEnum) {
    if (this.editModeEnum != editModeEnum) {
      this.editModeEnum = editModeEnum;
      updateUI();
    }
  }
}
