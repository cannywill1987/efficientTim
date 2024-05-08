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
import '../../../components/CustomTagFolderModelSelectPopupWidget.dart';
import '../../../components/CustomWQBTagFolderModelSelectPopupWidget.dart';
import '../../../components/WQBCustomFolderModelSelectPopupWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../config/ENUMS.dart';
import '../../../libs/methodChannel/CounterMethodChannelManager.dart';
import '../../../libs/mongodb/response/MongoDbUpdated.dart';
import '../../../models/ColorsModel.dart';
import '../../../models/WQBFolderModel.dart';
import '../../missionPage/componnents/BottomBar.dart';

class WQBNoteWidget extends StatefulWidget {
  WQBMissionModel missionModel;
  Color circleColor = ColorsConfig.gray_cc_cancel;
  Color tagColor = ColorsConfig.gray_cc_cancel;
  OnTapBottomBarCircleListener? onTapCircleListener;
  OnTapBottomBarTagListener? onTapTagListener;
  OnTapBottomBarPriorityListener? onTapPriorityListener;
  Icon? iconCircle;

  // String? text;
  String circleTitle = "";
  int priority = 0;
  String? tagName = "";

  WQBNoteWidget(
      {Key? key,
      this.iconCircle,
      this.tagName,
      required this.priority,
      required this.circleTitle,
      required this.circleColor,
      required this.tagColor,
      required this.missionModel,
      this.onTapCircleListener,
      this.onTapTagListener,
      this.onTapPriorityListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WQBNoteWidgetState();
  }
}

class WQBNoteWidgetState extends State<WQBNoteWidget> {
  late TextEditingController _controller;
  FocusNode _contentFocusNode = FocusNode();
  EditorEditModeEnum editModeEnum = EditorEditModeEnum.normal;
  double marginRight = 10;
  double iconSize = 20;

  Function func = Utility.debounceWithWQB((WQBNoteWidgetState state,
      WQBMissionModel missionModel, String val) async {
    print("result: $val");
    missionModel.content = val;
    String valTrim = val.trim();
    state.updateEditMode(EditorEditModeEnum.saving);
    missionModel.title = val
        .trim()
        .substring(0, valTrim.length > 25 ? 25 : valTrim.length)
        .replaceAll("\n", " ");
    MongoDbUpdated? update = await MongoApisManager.getInstance()
        .update_WQBMissionModel(missionModel: missionModel);
    CounterMethodChannelManager.getInstance()
        .storeWQBNoteMissionData(missionModel);
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
    _controller.text = this.widget.missionModel.content;
  }

  @override
  void didUpdateWidget(covariant WQBNoteWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.missionModel.objectId != this.widget.missionModel.objectId) {
      _controller.text = this.widget.missionModel.content;
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
          color: ThemeManager.getInstance().getInputThemeColor(defaultColor: Color(
              this.widget.missionModel.color ?? CONSTANTS.getColors()[0].color)),
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
                          focusNode: _contentFocusNode,
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
                              color: ThemeManager.getInstance().getTextColor(
                                  defaultColor: Color(0xff404040)),
                              letterSpacing: 0,
                              wordSpacing: 0),
                          // hintText: getI18NKey().please_input_content),
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
                  Wrap(
                    children: [
                      getPriorityWidget(),
                      SizedBox(
                        width: marginRight,
                      ),
                      getCircleFolderModelWidget(),
                      SizedBox(
                        width: marginRight,
                      ),
                      getTagNameWidget(),
                    ],
                  ),
                  Spacer(),
                  Wrap(children: [
                    Text(
                      getEditMode(),
                      style: TextStyle(fontSize: 12, color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff909090))),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextUtil.isEmpty(this.widget.missionModel.order_index)
                        ? SizedBox.shrink()
                        : Text(
                      getI18NKey().desktop_widget_with_note_n(
                          this.widget.missionModel.order_index ?? ""),
                      style: TextStyle(fontSize: 12, color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff909090))),
                    ),
                    SizedBox(width: 6,),
                    // 衣服的可点击icon
                    ColorsWidget(
                      onColorSelected: (int color) async {
                        this.widget.missionModel.color = color;
                        await MongoApisManager.getInstance()
                            .update_WQBMissionModel(
                                missionModel: this.widget.missionModel);
                        CounterMethodChannelManager.getInstance()
                            .storeWQBNoteMissionData(this.widget.missionModel);
                        updateUI();
                      },
                      child: Utility.getSVGPicture(R.assetsImgIcPaintPaint,
                          size: 16, color: ThemeManager.getInstance().getIconColor(defaultColor: Color(0xff404040))),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomPopupWidget(
                      onSelected: (val) async {
                        switch (val.code) {
                          case 'note1':
                            await MongoApisManager.getInstance()
                                .update_WQBMissionModelByOrderIndex(
                                    missionModelParam: this.widget.missionModel,
                                    order_index: 1);
                            CounterMethodChannelManager.getInstance()
                                .storeWQBNoteMissionData(
                                    this.widget.missionModel);
                            break;
                          case 'note2':
                            await MongoApisManager.getInstance()
                                .update_WQBMissionModelByOrderIndex(
                                    missionModelParam: this.widget.missionModel,
                                    order_index: 2);
                            CounterMethodChannelManager.getInstance()
                                .storeWQBNoteMissionData(
                                    this.widget.missionModel);
                            break;
                          case 'note3':
                            await MongoApisManager.getInstance()
                                .update_WQBMissionModelByOrderIndex(
                                    missionModelParam: this.widget.missionModel,
                                    order_index: 3);
                            CounterMethodChannelManager.getInstance()
                                .storeWQBNoteMissionData(
                                    this.widget.missionModel);
                            break;
                          case 'note4':
                            await MongoApisManager.getInstance()
                                .update_WQBMissionModelByOrderIndex(
                                    missionModelParam: this.widget.missionModel,
                                    order_index: 4);
                            CounterMethodChannelManager.getInstance()
                                .storeWQBNoteMissionData(
                                    this.widget.missionModel);
                            break;
                          case 'note5':
                            await MongoApisManager.getInstance()
                                .update_WQBMissionModelByOrderIndex(
                                    missionModelParam: this.widget.missionModel,
                                    order_index: 5);
                            CounterMethodChannelManager.getInstance()
                                .storeWQBNoteMissionData(
                                    this.widget.missionModel);
                            break;
                          case 'note6':
                            await MongoApisManager.getInstance()
                                .update_WQBMissionModelByOrderIndex(
                                    missionModelParam: this.widget.missionModel,
                                    order_index: 6);
                            CounterMethodChannelManager.getInstance()
                                .storeWQBNoteMissionData(
                                    this.widget.missionModel);
                            break;
                          case 'note7':
                            await MongoApisManager.getInstance()
                                .update_WQBMissionModelByOrderIndex(
                                    missionModelParam: this.widget.missionModel,
                                    order_index: 7);
                            CounterMethodChannelManager.getInstance()
                                .storeWQBNoteMissionData(
                                    this.widget.missionModel);
                            break;
                          case 'delete':
                            await MongoApisManager.getInstance()
                                .delete_WQBMissionModel(
                                    currentObjectId:
                                        this.widget.missionModel.objectId);
                            WQBMissionModel missionModel = WQBMissionModel();
                            missionModel.type = -1;
                            if(Utility.isHandsetBySize()) {
                              Utility.popNavigator(context);
                            } else {
                              //让页面展示为空状态的UI
                              Utility.pushWQBDesktopMissionDetailNavigator(
                                  context, 'WrongQuestionBookPage', {
                                'data': missionModel,
                                'folderdata': WQBFolderModel()
                              });
                            }
                            return;
                        }
                        updateUI();
                      },
                      list: CONSTANTS.getWQBNoteButtonList(),
                      child: Utility.getSVGPicture(R.assetsImgIcMorePaint,
                          size: 16, color: ThemeManager.getInstance().getIconColor(defaultColor: Color(0xff404040))),
                      // onPop: (int index) {
                      //   print('衣服的可点击icon');
                      // },
                    ),
                    // InkWell(
                    //   child: Utility.getSVGPicture(R.assetsImgIcMorePaint,
                    //       size: 16),
                    //   onTap: () {
                    //     print('衣服的可点击icon');
                    //   },
                    // ),
                    SizedBox(
                      width: 10,
                    ),
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

  Widget getPriorityWidget() {
     return CustomPopupWidget(
      onSelected: (v) {
        if (this.widget.onTapPriorityListener != null) {
          this.widget.onTapPriorityListener?.call(v.value);
        }
      },
      list: CONSTANTS.getPriorityList(),
      child: CONSTANTS.getPriorityIcon(this.widget.priority ?? 3, size: iconSize),
    );
    // return InkWell(
    //     onTap: () {
    //       if (this.widget.onTapPriorityListener != null) {
    //         this.widget.onTapPriorityListener!();
    //       }
    //     },
    //     child: CONSTANTS.getPriorityIcon(this.widget.priority ?? 3,
    //         size: iconSize));
  }

  Widget getTagNameWidget() {
    return CustomWQBTagFolderModelSelectPopupWidget(
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
            color: this.widget.tagColor,
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
    //       Icon(
    //         Icons.local_offer,
    //         size: iconSize,
    //         color: this.widget.tagColor,
    //       ),
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

  WQBCustomFolderModelSelectPopupWidget getCircleFolderModelWidget() {
    return WQBCustomFolderModelSelectPopupWidget(
      onSelected: (v) {
        if (this.widget.onTapCircleListener != null) {
          this.widget.onTapCircleListener?.call(v);
        }
      },
      child: Wrap(
        children: [
          this.widget.iconCircle ??
              Icon(Icons.fiber_manual_record,
                  size: iconSize, color: this.widget.circleColor),
          SizedBox(
            width: 5,
          ),
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
  }

  void updateEditMode(EditorEditModeEnum editModeEnum) {
    if (this.editModeEnum != editModeEnum) {
      this.editModeEnum = editModeEnum;
      updateUI();
    }
  }
}
