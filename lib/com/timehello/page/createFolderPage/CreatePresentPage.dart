import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/AvatarGridViewWidget.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/SelectObjectTypeModel.dart';
import 'package:time_hello/com/timehello/page/createFolderPage/components/ColorsGridViewWidget.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../components/SelectMoneySettingDialogUtil.dart';
import '../../models/PresentModel.dart';
import '../../util/SharePreferenceUtil.dart';
import 'components/IconsGridViewWidget.dart';

/**
 * 创建文件夹页面
 */
class CreatePresentPage extends BaseWidget {
  PageModeEnum pageEnum; //用于判断创建 或者 更新
  PresentModel presentModel = PresentModel();
  Function? callback;
  CreatePresentPage({this.callback, this.pageEnum = PageModeEnum.create, presentModel}) {
    if (presentModel == null) {
      this.presentModel = PresentModel();
    } else {
      this.presentModel = presentModel;
    }
  }

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _CreatePresentPageState();
  }
}

class _CreatePresentPageState<T> extends BaseWidgetState<CreatePresentPage> {
  // FolderModel folderModel;
  // PageEnum pageEnum;
  SelectObjectTypeModel? selectObjectTypeModel = SelectObjectTypeModel();
  GlobalKey<FormState>? _formKey = new GlobalKey<FormState>();
  TextEditingController? textEditingController;
  int value = 1;
  GlobalKey<IconsGridViewWidgetState> IconsGridViewWidgetStateGlobalKey = GlobalKey();

  _CreatePresentPageState() {
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
        text: TextUtil.isEmpty(this.widget.presentModel.title)
            ? ''
            : this.widget.presentModel.title));
  }

  @override
  componentDidMount() {
    if (PageModeEnum.edit == this.widget.pageEnum) {
      IconsGridViewWidgetStateGlobalKey.currentState!
          .setCurIndex((this.widget.presentModel.icon  ?? 0xffff8800));
    }
  }

  @override
  void didUpdateWidget(CreatePresentPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    initData();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickCreatePresentModel': //创建folder
        onClickPresentModel();
        break;
      case 'onClickUpdatePresentModel': //更新folder
        onClickUpdatePresentModel();
        break;
    }
  }

  void onClickUpdatePresentModel() {
    MongoApisManager.getInstance().update_PresentModel(
        currentObjectId: this.widget.presentModel.objectId,
        title: this.widget.presentModel.title,
        color: this.widget.presentModel.color ?? 0xffff8800,
        value: this.widget.presentModel.value,
        imageUrl: this.widget.presentModel.imageUrl,
        icon: this.selectObjectTypeModel?.icon != null
            ? (this.selectObjectTypeModel?.icon?.codePoint ?? 0)
            : 0,
        callback: (res) {
          // if (Utility.isHandsetBySize()) {
          //   Utility.popNavigator(context, res);
          // }
          resetForm();
          eventBus.fire(EventFn(Params.ACTION_UPDATE_FOLDER_PAGE, {}));
          Utility.showToastMsg(msg: getI18NKey().updateSuccess);
          Utility.popupPagePCAndMobile(context);
          this.widget.callback?.call();
        });
  }

  void onClickPresentModel() {
    MongoApisManager.getInstance().insertPresentModel(
        title: this.widget.presentModel.title,
        color: this.widget.presentModel.color ?? CONSTANTS.getColors()[0].color,
        value: this.widget.presentModel.value,
        imageUrl: this.widget.presentModel.imageUrl,
        icon: this.selectObjectTypeModel?.icon != null
            ? (this.selectObjectTypeModel?.icon?.codePoint ?? CONSTANTS.getSelectIcons()[0].icon?.codePoint ?? 0)
            : (CONSTANTS.getSelectIcons()[0].icon?.codePoint ?? 0),
        callback: (res) {
          // if (Utility.isHandsetBySize()) {
          //   Utility.popNavigator(context, res);
          // }
          resetForm();
          eventBus.fire(EventFn(Params.ACTION_UPDATE_FOLDER_PAGE, {}));
          Utility.showToastMsg(msg: getI18NKey().createSuccess);
          Utility.popupPagePCAndMobile(context);
          this.widget.callback?.call();
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void resetForm() {
    textEditingController?.text = '';
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    //return super.baseBuild(context);
    return Container(
      padding: new EdgeInsets.fromLTRB(10, 10, 10, 0),
      constraints: BoxConstraints.expand(width: double.infinity),
      child: Column(
        children: [
          TextField(
            key: _formKey,
            controller: textEditingController,
            onChanged: (text) {
              this.widget.presentModel.title = text;
            },
            onSubmitted: (value) {
              print(value);
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(0.0),
                prefixIcon: Icon(
                    (selectObjectTypeModel?.icon ?? Icons.fiber_manual_record),
                    color: this.widget.presentModel.color != null
                        ? Color((this.widget.presentModel.color  ?? 0xffff8800) > 0
                            ? (this.widget.presentModel.color  ?? 0xffff8800)
                            : CONSTANTS.getColors()[0].color)
                        : Color(CONSTANTS.getColors()[0].color)),
                //创建清单的默认颜色
                labelText: '',
                helperText: ''),
          ),
          ColorsGridViewWidget(onTapListener: (data) {
            setState(() {
              this.widget.presentModel.color = data.color;
            });
          }),
          SizedBox(height: 10),
          Expanded(
              child: IconsGridViewWidget(
            onTapListener: (model) {
              selectObjectTypeModel = model;
              updateUI();
            },
            color: Color((this.widget.presentModel.color ?? 0) == 0
                ? (CONSTANTS.getColors()[0].color  ?? 0xffff8800)
                : (this.widget.presentModel.color  ?? 0xffff8800)),
            key: IconsGridViewWidgetStateGlobalKey,
          )),
          new ButtonBar(alignment: MainAxisAlignment.center,children: <Widget>[
            DeviceInfoManagement.isMoible() == false ? Container(
                margin: EdgeInsets.only(top: 20),
                decoration: StylesConfig.getBackButtonDecoration(),
                width: 260,
                height: 45,
                child: TextButton(
                    child: Text(
                      getI18NKey().back,
                      style: TextStyle(color: ColorsConfig.red, fontSize: 14),
                    ),
                    onPressed: () {
                      Utility.popNavigator(context);
                    })) : SizedBox.shrink(),
            Container(
                margin: EdgeInsets.only(top: 20),
                decoration: StylesConfig.getConfirmButtonDecoration(),
                width: 260,
                height: 45,
                child: TextButton(
                    child: Text(
                      this.widget.pageEnum == PageModeEnum.create
                          ? getI18NKey().create
                          : getI18NKey().update,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    onPressed: () {
                      if (TextUtil.isEmpty(this.widget.presentModel.title)) {
                        Utility.showToastMsg(msg: getI18NKey().pleaseInputTitle);
                        return;
                      }
                      // if (this.widget.presentModel.color <= 0) {
                      //   this.widget.presentModel.color = ;
                      // }
                      if ((this.widget.presentModel.color  ?? 0) <= 0) {
                        this.widget.presentModel.color = CONSTANTS.getColors()[0].color;
                        // Utility.showToast(msg: getI18NKey().pleaseSelectColor);
                        // return;
                      }
                      //选择产品金额
                      SelectMoneySettingDialogUtil.show(context,
                          title: getI18NKey().present_value_dialog(
                              this.widget.presentModel.title),
                          initVal: this.widget.presentModel.value ??
                              SharePreferenceUtil.getSyncInstance()
                                  .getPresentValue(), okCallBack: (val) {
                        if (this.widget.pageEnum == PageModeEnum.create) {
                          SharePreferenceUtil.getSyncInstance()
                              .setPresentValue(val);
                          this.widget.presentModel.value = val;
                          this.onClick('onClickCreatePresentModel',
                              this.widget.presentModel);
                        } else {
                          this.widget.presentModel.value = val;
                          this.onClick('onClickUpdatePresentModel',
                              this.widget.presentModel);
                        }
                      });
                    }))
          ]),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
