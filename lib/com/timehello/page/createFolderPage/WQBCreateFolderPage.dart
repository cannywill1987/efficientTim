import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/AvatarGridViewWidget.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/models/SelectObjectTypeModel.dart';
import 'package:time_hello/com/timehello/page/createFolderPage/components/ColorsGridViewWidget.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../models/PresentModel.dart';
import '../../models/WQBFolderModel.dart';
import 'components/IconsGridViewWidget.dart';

/**
 * 创建文件夹页面
 */
class WQBCreateFolderPage extends BaseWidget {
  PageModeEnum pageEnum; //用于判断创建 或者 更新
  WQBFolderModel folderModel = WQBFolderModel(); //更新用得上
  PageNavShowEnum? pageNavShowEnum;
  Function? okListener;
  WQBCreateFolderPage({this.pageNavShowEnum, this.pageEnum = PageModeEnum.create, folderModel, this.okListener})
  {
    if (folderModel == null) {
      this.folderModel = WQBFolderModel();
    } else {
      this.folderModel = folderModel;
    }
  }

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _WQBCreateFolderPageState();
  }
}

class _WQBCreateFolderPageState<T> extends BaseWidgetState<WQBCreateFolderPage> {
  // FolderModel folderModel;
  // PageEnum pageEnum;
  // SelectObjectTypeModel? selectObjectTypeModel = SelectObjectTypeModel();
  GlobalKey<FormState>? _formKey = new GlobalKey<FormState>();
  TextEditingController? textEditingController;
  GlobalKey<IconsGridViewWidgetState>? IconsGridViewWidgetStateGlobalKey2;
  _WQBCreateFolderPageState() {
    // this.folderModel = folderModel != null ? folderModel : new FolderModel();
    // this.pageEnum = pageEnum;
  }

  @override
  void onCreate() {
    super.onCreate();
    initData();
  }

  void initData() {
      textEditingController = TextEditingController.fromValue(TextEditingValue(
        text: TextUtil.isEmpty(this.widget.folderModel.title)
            ? ''
            : this.widget.folderModel.title ?? ""));
  }


  @override
  componentDidMount() {
    if (PageModeEnum.edit == this.widget.pageEnum && this.widget.folderModel.tag == 1) {
      IconsGridViewWidgetStateGlobalKey2?.currentState?.setCurIndex(this.widget.folderModel.icon ?? 0);
    }
  }

  @override
  void didUpdateWidget(WQBCreateFolderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    initData();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickCreateFolder': //创建folder
        onClickCreateFolder();
        break;
      case 'onClickUpdateFolder': //更新folder
        onClickUpdateFolder();
        break;
    }
  }

  void onClickUpdateFolder() {
    // this.widget.folderModel.icon = this.selectObjectTypeModel?.icon != null
    //     ? this.selectObjectTypeModel?.icon?.codePoint
    //     : null;
       MongoApisManager.getInstance().update_WQBFolderModelWithFM(
         folderModel: this.widget.folderModel,
        callback: (res) {
          this.widget.okListener?.call(res);
          // if(Utility.isHandsetBySize()) {
          //   Utility.popNavigator(context, res);
          // }
          resetForm();
          eventBus.fire(EventFn(Params.ACTION_UPDATE_WQB_FOLDER_PAGE, {}));
          Utility.showToastMsg(msg: getI18NKey().updateSuccess);
          Utility.popupPagePCAndMobile(context);
        });
  }

  void onClickCreateFolder() {
    MongoApisManager.getInstance().insertWQBFolderData(
        title: this.widget.folderModel.title,
        color: this.widget.folderModel.color,
        icon: this.widget.folderModel.icon,
        tag: this.widget.folderModel.tag,
        tagName: this.widget.folderModel.tag == 2
            ? this.widget.folderModel.title
            : '',
        callback: (res) {
          this.widget.okListener?.call(res);
            if(Utility.isHandsetBySize() || (this.widget.pageNavShowEnum != null && this.widget.pageNavShowEnum == PageNavShowEnum.show)) {
              Utility.popNavigator(context, res);
              return;
            }
            resetForm();
            eventBus.fire(EventFn(Params.ACTION_UPDATE_WQB_FOLDER_PAGE, {}));
            Utility.showToastMsg(msg: getI18NKey().createSuccess);
            Utility.popupPagePCAndMobile(context);
        });
  }

  void initState() {
    super.initState();
    //如果外部传入了导航栏是否设置 则根据外部的pageNavShowEnum来显示 否则按照默认得来
    //这里用的场景主要是Pc端透传过来
    if (this.widget.pageNavShowEnum != null && this.widget.pageNavShowEnum == PageNavShowEnum.show) {
      super.forceAppBarVisible = true;
    } else if (this.widget.pageNavShowEnum != null && this.widget.pageNavShowEnum == PageNavShowEnum.none) {
      super.forceAppBarVisible = false;
    }
    // selectObjectTypeModel?.icon =  IconData(this.widget.folderModel.icon ?? Icons.fiber_manual_record.codePoint, fontFamily: 'MaterialIcons');
  }

  @override
  void dispose() {
    super.dispose();
    IconsGridViewWidgetStateGlobalKey2 = GlobalKey();
  }


  void resetForm() {
    textEditingController?.text = '';
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    // selectObjectTypeModel?.icon =  IconData(this.widget.folderModel.icon ?? Icons.fiber_manual_record.codePoint, fontFamily: 'MaterialIcons');
    // selectObjectTypeModel?.color = this.widget.folderModel.color;
    //return super.baseBuild(context);
    //默认值
    if(this.widget.folderModel != null) {
      if(this.widget.folderModel.icon == 0) {
        this.widget.folderModel.icon =
            CONSTANTS.getSelectIcons()[0].icon!.codePoint;
      }
      if(this.widget.folderModel.color == 0) {
        this.widget.folderModel.color = CONSTANTS.getColors()[0].color;
      }
    }
    return Container(
      padding: new EdgeInsets.fromLTRB(10, 10, 10, 0),
      constraints: BoxConstraints.expand(width: double.infinity),
      child: Column(
        children: [
          TextField(
            key: _formKey,
            controller: textEditingController,
            onChanged: (text) {
              this.widget.folderModel.title = text;
            },
            onSubmitted: (value) {
              print(value);
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(0.0),
                prefixIcon: Icon(
                    (this.widget.folderModel.tag == 0 ||
                            this.widget.folderModel.tag == false ||
                            this.widget.folderModel.tag == null)
                        ? Icons.calendar_today
                        : this.widget.folderModel.tag == 1
                            ? (IconData(this.widget.folderModel?.icon ?? Icons.local_offer.codePoint, fontFamily: 'MaterialIcons') ??
                                Icons.fiber_manual_record)
                            : Icons.local_offer,
                    color: this.widget.folderModel.color != null
                        ? Color(this.widget.folderModel.color > 0
                            ? this.widget.folderModel.color
                            : CONSTANTS.getColors()[0].color)
                        : Color(CONSTANTS.getColors()[0].color)),
                //创建清单的默认颜色
                labelText: '',
                helperText: ''),
          ),
          ColorsGridViewWidget(
              defaultIndexColor: this.widget.folderModel.color,
              onTapListener: (data) {
            setState(() {
              this.widget.folderModel.color = data.color;
            });
          }),
          SizedBox(height: 10),

          this.widget.folderModel.tag == 1
              ? Expanded(
                  child: IconsGridViewWidget(
                      // defaultIndex: this.widget.folderModel.icon ?? 0,
                    key: IconsGridViewWidgetStateGlobalKey2,
                      defaultIndex: this.widget.folderModel?.icon ?? -1,
                  onTapListener: ( model) {
                    SelectObjectTypeModel modelTmp = model;
                    this.widget.folderModel?.icon = modelTmp.icon?.codePoint ?? 0;
                    // selectObjectTypeModel = model;
                    updateUI();
                  },
                  color: Color(this.widget.folderModel.color == 0
                      ? CONSTANTS.getColors()[0].color
                      : this.widget.folderModel.color)
                ))
              : SizedBox(),
          Container(
              margin: EdgeInsets.only(top: 20),
              width: 260,
              height: 45,
              child: ElevatedButton(
                  child: Text(
                    this.widget.pageEnum == PageModeEnum.create ? getI18NKey().create : getI18NKey().update,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onPressed: () {
                    if (TextUtil.isEmpty(this.widget.folderModel.title)) {
                      Utility.showToastMsg(msg: getI18NKey().pleaseInputTitle);
                      return;
                    }
                    if (this.widget.folderModel.color <= 0) {
                      Utility.showToastMsg(msg: getI18NKey().pleaseSelectColor);
                      return;
                    }
                    if (this.widget.pageEnum == PageModeEnum.create) {
                      this.onClick(
                          'onClickCreateFolder', this.widget.folderModel);
                    } else {
                      this.onClick(
                          'onClickUpdateFolder', this.widget.folderModel);
                    }
                  })),
          SizedBox(height:20)
        ],
      ),
    );
  }
}
