// import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

import '../config/CONSTANTS.dart';
import '../config/Params.dart';
import '../models/CheckButtonStateModel.dart';
import '../models/EventFn.dart';
import '../models/SessionMissionModel.dart';
import '../page/SettingItemDetailPage/SettingItemDetailPage.dart';
import '../page/missionPage/componnents/GridMissionSilverList.dart';
import '../page/missionPage/componnents/MultiSelectHandleWidget.dart';
import '../util/ChatGroupManager.dart';
import '../util/CounterManagement.dart';
import '../util/DialogManagement.dart';
import '../util/OverlayManagement.dart';
import '../util/SharePreferenceUtil.dart';
import '../util/ThemeManager.dart';
import '../util/Utility.dart';
import 'ExportMissionListDialogUtil.dart';
import 'SectionTitleWidget.dart';

class MissionSearchBar extends StatefulWidget {
  Function? onSubmit;
  String? title;
  String? prompt;
  String? placeholder;

  MissionSearchBar({this.onSubmit, this.prompt, this.title, this.placeholder});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MissionSearchBarState();
  }
}

class MissionSearchBarState extends State<MissionSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Color color = Colors.purple;
  Color fontColor = Colors.black;
  double iconSize = 18;
  double fontSize = 14;
  String curSearchWords = "";
  List<MissionModel> datas = [];
  List<SessionMissionModel>? listSessionMissionModel;
  MultiSelectModeEnum multiSelectModeEnum = MultiSelectModeEnum.normal;
  List<MissionModel>? curListMissionModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void resetMultiSelectModeEnum() {
    // this.curListMissionModels?.forEach((element) {
    //   element.isSelected = false;
    // });
    this.curListMissionModels = [];
    this.multiSelectModeEnum = MultiSelectModeEnum.normal;
    updateUI();
  }


  requestList(String searchWord) {
    // 请求列表
    listSessionMissionModel = [];
    List<MissionModel> list = MongoApisManager.getInstance().listMissionModels;
    // if (!TextUtil.isEmpty(curSearchWords)) {
      datas = Utility.filterMissionModel(curSearchWords ?? "", list);
      List<SessionMissionModel>? listSessionMissionModelTmp = Utility.getListAfterOrder(
          MissionOrderEnum.orderByWords,
          this.datas ?? []);
      for (int i = 0; i < (listSessionMissionModelTmp?.length ?? 0); i++) {
        SessionMissionModel? sessionMissionModel = listSessionMissionModelTmp?[i];
        if(sessionMissionModel != null) {
          if ((sessionMissionModel?.datas?.length ?? 0) > 0)
            listSessionMissionModel?.add(sessionMissionModel!);
        }
      }
      updateUI();
      // listSessionMissionModel = listSessionMissionModelTmp;
      print("object");
    // }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 200;
    return Container(
      height: height,
      child: Column(
        children: <Widget>[
          this.multiSelectModeEnum == MultiSelectModeEnum.normal
              ? SizedBox.shrink()
              : Positioned(
              bottom: 0,
              child: MultiSelectHandleWidget(
                missionModelList: this.curListMissionModels ?? [],
                onClickUpdateTimeDoItNow: (datas) async {
                  Utility.onClickUpdateTimeDoItNow(context, datas);
                },
                onClickDelete: (datas) async {
                  await MongoApisManager.getInstance()
                      .batchDelete_MissionModel(listParam: curListMissionModels);
                  requestList(curSearchWords);
                },
                onClickExport: (datas) {
                  TextEditingController textEditingController =
                  TextEditingController();
                  String s = Utility.getContentFromMissionList(
                      datas: datas ?? [],
                      listCheckButtonModel:
                      CONSTANTS.getExportButtonsList());
                  textEditingController.text = s;
                  ExportMissionListDialogUtil.show(context,
                      textEditingController: textEditingController,
                      onTapListener: (res) {
                        List<CheckButtonStateModel> data = res['data'];
                        MissionOrderEnum missionOrderEnum = res['enum'];
                        String s = Utility.getContentFromMissionList(
                            datas: Utility.getMissionModelListAfterOrder(
                                missionOrderEnum, curListMissionModels ?? []),
                            listCheckButtonModel: data);
                        textEditingController.text = s;
                        updateUI();
                      }, export: (data) {
                        Utility.showToastMsg(
                            context: context,
                            msg: getI18NKey().offer_next_version);
                      });
                },
                onClickFinish: (datas) async {
                  await MongoApisManager.getInstance()
                      ?.batchUpdate_MissionModelWithParams(
                      listMissionModel: curListMissionModels ?? []);
                  requestList(curSearchWords);

                },
                onClickUnFinish: (datas) async {
                  await MongoApisManager.getInstance()
                      ?.batchUpdate_MissionModelWithParams(
                      listMissionModel: curListMissionModels ?? []);
                  requestList(curSearchWords);

                },
                onClickClose: (datas) async {
                  resetMultiSelectModeEnum();
                },
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (text) {
                      this
                          .widget
                          .onSubmit
                          ?.call(this.widget.prompt!, _controller.text);
                    },
                    style: TextStyle(color: ThemeManager.getInstance().getTextColor()),

                    decoration: InputDecoration(

                      // hoverColor: ThemeManager.getInstance().getCardBackgroundColor(
                      //   defaultColor: Colors.purple,
                      // ),
                      // focusColor: Colors.purple,
                      // labelText: "134",
                      label: Text(getI18NKey().please_input_search_mission),
                      floatingLabelStyle: TextStyle(
                        color: Colors.purple,
                      ),
                      labelStyle:
                      TextStyle(color: Color(0xffa0a0a0), fontSize: 14),
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.search,
                            color: color,
                            size: 20,
                          ),
                          if (this.widget.title != null)
                            Container(
                              margin: EdgeInsets.only(left: 2),
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(Colors.purple.value - 0xc0000000),
                              ),
                              child: Text(
                                this.widget.title!,
                                style:
                                TextStyle(color: Colors.purple, fontSize: 12),
                              ),
                            ),
                          if (this.widget.title != null)
                            SizedBox(
                              width: 5,
                            ),
                        ],
                      ),
                      // suffixIcon: Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     Text(
                      //       '${_controller.text.length}/1000',
                      //       style: TextStyle(color: color),
                      //     ),
                      //     // SizedBox(width: 8),
                      //     // //圆形
                      //     // ElevatedButton(
                      //     //   clipBehavior: Clip.antiAlias,
                      //     //   style: ElevatedButton.styleFrom(
                      //     //     backgroundColor: _controller.text.isEmpty
                      //     //         ? Colors.purple[100]
                      //     //         : color,
                      //     //     // 按钮颜色
                      //     //     disabledBackgroundColor: _controller.text.isEmpty
                      //     //         ? Colors.purple[100]
                      //     //         : color,
                      //     //     // 按钮颜色
                      //     //     // foregroundColor: _controller.text.isEmpty ? Colors.purple[100] : color, // 文字颜色
                      //     //     shape: RoundedRectangleBorder(
                      //     //       borderRadius: BorderRadius.circular(18.0),
                      //     //     ),
                      //     //   ),
                      //     //   onPressed: _controller.text.isEmpty
                      //     //       ? null
                      //     //       : () {
                      //     //     // Handle button press
                      //     //     // this.widget.onSubmit?.call(_controller.text);
                      //     //     this.widget.onSubmit?.call(
                      //     //         this.widget.prompt!, _controller.text);
                      //     //   },
                      //     //   child: Icon(Icons.arrow_forward),
                      //     // ),
                      //     SizedBox(width: 8)
                      //   ],
                      // ),
                      focusedBorder: StylesConfig.buildOutlineInputBorder(),
                      enabledBorder: StylesConfig.buildOutlineInputBorder(),
                      border: StylesConfig.buildOutlineInputBorder(),
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(
                      //     color: Colors.red, // hover时的边框颜色
                      //   ),
                      // ),
                      // labelText: i18nInstanceLocal.select_scenario,
                    ),
                    onChanged: (text) {
                      this.curSearchWords = text;
                      requestList(text);
                      setState(() {}); // 重新渲染以更新按钮颜色
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              constraints: BoxConstraints(maxHeight: 100),
              child: CustomScrollView(
                slivers: [
                  ...getSliverList()
                ],
              ),
            ),
          )
        ],
      ),
    );

  }



  Future onTapDoItNow(MissionModel data) async {
    if (ChatGroupManager.isFolderModelEnabled(folderId: data.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }
    Utility.onClickUpdateTimeDoItNow(Utility.getGlobalContext(), [data]);
  }

  Future onClickUnFinishListener(MissionModel data) async {
    if (ChatGroupManager.isFolderModelEnabled(folderId: data.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }
    // await onClickFinishMission(data);
    data.isFinished = false;
    await MongoApisManager.getInstance()
        .update_MissionModel(missionModel: data);
  }

  Future onClickEditTitle(MissionModel data) async {
    if (ChatGroupManager.isFolderModelEnabled(folderId: data.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }

    DialogManagement.getInstance().showEditTitleDialog(
        Utility.getGlobalContext(),
        title: getI18NKey().edit_title(data.title ?? ""),
        initVal: data.title, okCallBack: (String value) async {
      if (ChatGroupManager.isFolderModelEnabled(folderId: data.folder_id) ==
          false) {
        Utility.showToastMsg(
            context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
        return;
      }
      data.title = value;
      await MongoApisManager.getInstance()
          .update_MissionModel(missionModel: data);
      // requestDatas();
      Utility.showToastMsg(context: context, msg: getI18NKey().update_success);
      DialogManagement.getInstance().hideDialog(context);
    }, cancelCallBack: () {
      DialogManagement.getInstance().hideDialog(context);
    });
  }

  /**
   * 跳转到设置叶敏
   */
  void onClickMissionSetting(data) {
    DialogManagement.getInstance().hideDialog(context);
    Utility.popupDesktopRightNavigator(context);
    if (Utility.isHandsetBySize()) {
      Utility.pushNavigator(
          context,
          new SettingItemDetailPage(
            key: ValueKey("ejzifjfze43"),
            missionModel: data,
          ));
    } else {
      Utility.openRightSideDesktopNavigator(
          context, 'SettingItemDetailPage', {'missionModel': data});
    }
  }

  /**
   * 侧滑点击删除
   */
  Future onClickDeleteItem(data) async {
    if (ChatGroupManager.isFolderModelEnabled(folderId: data.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }

    OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: getI18NKey().delete,
        message: getI18NKey().confirmToDelete,
        okLabel: getI18NKey().confirm,
        cancelLabel: getI18NKey().cancel,
        onWillPop: () async {
          //点击对话框外围黑色区域才会走这里
          return true;
        });
    if (result == OkCancelResult.ok) {
      await MongoApisManager.getInstance()
          .delete_MissionModel(currentObjectId: data.objectId);
      // this.requestDatas();
      eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    }
  }

  /**
   * 点击完成任务
   */
  Future onClickFinishItem(MissionModel data) async {
    await onClickFinishMission(data);
  }

  Future<void> onClickFinishMission(MissionModel data) async {
    List<FolderModel> folderModel = await MongoApisManager.getInstance().queryWhereEqual_folderModelWithFolderId(data.folder_id);
    FolderModel? folderModel1 = folderModel.isNotEmpty ? folderModel.first : null;
    bool didFinish =
        await MongoApisManager.getInstance().handleFinishMissionModel(
      missionModel: data,
      context: context,
      folderModel: folderModel1,
    );
    if (!didFinish) {
      return;
    }
    // this.requestDatas();
    // CounterManagement counterManagement = CounterManagement.getInstance();
    //不是同一个就重置重新开始计数
    eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    //关闭的是同一个任务那就停止计时器
    // if (counterManagement?.missionModel?.objectId == data.objectId) {
    //   // counterManagement.reset();
    //   CounterManagement.getInstance().reset();
    // }
  }

  /**
   * 跳转到任务详情页MissionPage开始任务
   */
  static void onClickMissionStart(
      BuildContext context, MissionModel data, FolderModel? folderModel) async {
    // 有任务进行中给出提示
    if (CounterManagement.getInstance().counterStatus ==
        CounterStatus.focusing &&
        !TextUtil.isEmpty(
            CounterManagement.getInstance().missionModel?.title) &&
        data?.title != CounterManagement.getInstance().missionModel?.title) {
      if (SharePreferenceUtil.getSyncInstance().getSwitchMissionTitle()) {
        Utility.showAlertDialog(
            context: context,
            content: getI18NKey().missionRunningAlert(
                CounterManagement.getInstance().missionModel?.title ?? ""),
            onConfirm: () {
              OverlayManagement.getInstance().openMissionDetailPageOverlay(
                  context: context,
                  missionModel: data,
                  folderModel: folderModel);
            });
      } else {
        OverlayManagement.getInstance().openMissionDetailPageOverlay(
            context: context, missionModel: data, folderModel: folderModel);
      }
    } else {
      OverlayManagement.getInstance().openMissionDetailPageOverlay(
          context: context, missionModel: data, folderModel: folderModel);
      // Utility.pushNavigator(
      //     context,
      //     new MissionDetailPage(
      //       missionModel: data,
      //       folderModel: this.widget.folderModel,
      //     ));
    }
  }

  onTapMultiSelectListener(MissionModel? data) async {
    if(data?.isSelected == true) {
      if(data != null) {
        curListMissionModels?.add(data!);
      }
    } else {
      if(data != null) {
        curListMissionModels?.remove(data);
      }
    }
    if (data == null) {
      if (this.multiSelectModeEnum == MultiSelectModeEnum.normal) {
        this.multiSelectModeEnum = MultiSelectModeEnum.multiSelect;
      } else {
        this.multiSelectModeEnum = MultiSelectModeEnum.normal;
      }
    }
    updateUI();
  }

  updateUI() {
    setState(() {});
  }

  List<Widget> getSliverList() {
    List<Widget> list = [];
    for (int i = 0; i < (listSessionMissionModel?.length ?? 0); i++) {
      SessionMissionModel sessionMissionModel = listSessionMissionModel![i];
      // list.add(SectionTitleWidget(title: sessionMissionModel.title ?? "",));
      list.add(SliverToBoxAdapter(child: SectionTitleWidget(title: sessionMissionModel.title ?? "",),));
      list.add(SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return GridMissionSilverListItem(
            multiSelectModeEnum: this.multiSelectModeEnum,
            isSlideEnable: Utility.isHandsetBySize(),
            onTapListener: (data) {
              onClickMissionSetting(data);
            },
            index: index,
            missionModel: sessionMissionModel.datas?[index],
            onTapDoItNow: onTapDoItNow,
            onTapUnFinishListener: (data) {onClickUnFinishListener(data);},
            onTapEditTitleListener: (txt) {
              onClickEditTitle(txt);
            },
            onTapEditListener: (data) {
              onClickMissionSetting(data);
            },
            onTapDeleteListener: (data) {
              onClickDeleteItem(data);
            },
            onTapFinishListener: (data) {
              onClickFinishItem(data);
            },
            onTapMultiSelectListener: (MissionModel? missionModel) {
              // this.onClick('onTapMultiSelectListener', list);
              // if(list == null) {
              onTapMultiSelectListener(missionModel);
              // }
            },
            onTapPlayListener: (data) {
              FolderModel? folderModel = Utility.getFolderModelByObjId(data.folder_id);
              onClickMissionStart(context, data, folderModel);
            },
          );
        }, childCount: sessionMissionModel.datas?.length ?? 0),
      ));
    }
    return list;
  }
}
