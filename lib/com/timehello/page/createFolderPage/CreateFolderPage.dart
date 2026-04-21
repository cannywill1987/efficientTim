import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/AvatarGridViewWidget.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/CustomFolderModelSelectForFoldersPopupWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/models/SelectObjectTypeModel.dart';
import 'package:time_hello/com/timehello/page/createFolderPage/components/ColorsGridViewWidget.dart';
import 'package:time_hello/com/timehello/util/CryptoManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../r.dart';
import '../../components/DescriptionWidget.dart';
import '../../components/IconButtonListWidget.dart';
import '../../components/PasswordWidget.dart';
import '../../components/TwoPasswordWidget.dart';
import '../../config/ColorsConfig.dart';
import '../../libs/mongodb/response/MongoDbSaved.dart';
import '../../models/DateTimeModel.dart';
import '../../models/GroupModel.dart';
import '../../models/PresentModel.dart';
import 'components/IconsGridViewWidget.dart';

/**
 * 创建文件夹页面
 */
class CreateFolderPage extends BaseWidget {
  PageModeEnum pageEnum; //用于判断创建 或者 更新
  FolderModel folderModel = FolderModel(); //更新用得上
  PageNavShowEnum? pageNavShowEnum;
  FolderModel? folderModelForFolder = null; //用于文件夹选择

  CreateFolderPage(
      {this.pageNavShowEnum,
        this.folderModelForFolder,
      this.pageEnum = PageModeEnum.create,
      folderModel}) {
    if (folderModel == null) {
      this.folderModel = FolderModel();
    } else {
      this.folderModel = folderModel;
    }
  }

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _CreateFolderPageState();
  }
}

class _CreateFolderPageState<T> extends BaseWidgetState<CreateFolderPage> {
  // FolderModel folderModel;
  // PageEnum pageEnum;
  // SelectObjectTypeModel? selectObjectTypeModel = SelectObjectTypeModel();
  FolderModel? folderModelForFolder = null; //用于文件夹选择
  GlobalKey<FormState>? _formKey = new GlobalKey<FormState>();
  TextEditingController? textEditingController;
  GlobalKey<IconsGridViewWidgetState>? IconsGridViewWidgetStateGlobalKey;
  List<GroupModel> listGroupModel = [];
  String method = "customized";
  ScrollController scrollController = ScrollController();
  GlobalKey<TwoPasswordWidgetState>? passwordWidgetStateGlobalKey = GlobalKey();
  String oldPasswordForUpdate = "";
  int oldCryptoVersion = -1; // -1代表没有设置加密 0代表设置了加密版本
  double fontSize = 13;
  OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    gapPadding: 0,
    borderSide:
        BorderSide(color: ThemeManager.getInstance().getInputBorderColor()),
  );

  Color get _pageCanvasColor {
    final bool isDark = ThemeManager.getInstance().getThemeMode().isDark;
    if (isDark || Utility.isHandsetBySize()) {
      return ThemeManager.getInstance().getBackgroundColor();
    }
    return ColorsConfig.missionDesktopEditorCanvas;
  }

  _CreateFolderPageState() {
    // this.folderModel = folderModel != null ? folderModel : new FolderModel();
    // this.pageEnum = pageEnum;
  }

  @override
  void onCreate() {
    super.onCreate();
    initData();
  }

  void initData() {
    if(this.folderModelForFolder == null) {
      this.folderModelForFolder = this.widget.folderModelForFolder;
    }
    if(this.widget.folderModel.objectId != null){
      this.folderModelForFolder = MongoApisManager.getInstance().queryFolderModelForForFolderObjectId(objectId: this.widget.folderModel.objectId ?? "");
    }
    if (this.widget.folderModel.tag == 1) {
      this.oldPasswordForUpdate = CryptoManager.getInstance()
          .getDigitPassword(folderId: this.widget.folderModel.objectId);
      this.oldCryptoVersion = this.widget.folderModel.cryptoVersion ?? -1;
    }
    // this.oldPasswordForUpdate = CryptoManager.getInstance()
    //     .getDigitPassword(folderId: this.widget.folderModel.objectId);
    textEditingController = TextEditingController.fromValue(TextEditingValue(
        text: TextUtil.isEmpty(this.widget.folderModel.title)
            ? ''
            : this.widget.folderModel.title ?? ""));
  }

  @override
  componentDidMount() {
    if (PageModeEnum.edit == this.widget.pageEnum &&
        this.widget.folderModel.tag == 1) {
      IconsGridViewWidgetStateGlobalKey?.currentState
          ?.setCurIndex(this.widget.folderModel.icon ?? 0);
    }
    if ((this.widget.folderModel.cryptoVersion ?? -1) >= 0) {
      String password = CryptoManager.getInstance()
          .getDigitPassword(folderId: this.widget.folderModel.objectId);
      passwordWidgetStateGlobalKey?.currentState?.setPassword1(password);
      passwordWidgetStateGlobalKey?.currentState?.setPassword2(password);
    }
  }

  @override
  void didUpdateWidget(CreateFolderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.folderModelForFolder = null;
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
    // oldCryptoVersion > -1 用于校验是否需要校验原始密码
    if ((this.widget.folderModel.cryptoVersion ?? -1) > -1 ||
        oldCryptoVersion > -1) {
      String objectId = this.widget.folderModel.objectId ?? "";

      //需要加密 就需要校验
      bool res =
          passwordWidgetStateGlobalKey?.currentState?.checkPassword() ?? false;
      if (!res) {
        return;
      }
      //判断是否需要原始密码 如果需要原始密码  就需要校验原始密码
      bool? isOriginPasswordVisible =
          passwordWidgetStateGlobalKey?.currentState?.isOriginPasswordVisible();
      //没有原始密码 则走正常逻辑判断foldermodel的密码是否正确
      if (isOriginPasswordVisible == false || isOriginPasswordVisible == null) {
        int isPasswordCorrect = CryptoManager.getInstance()
            .isPasswordCorrectForFolderModel(folderId: objectId);
        //不正确就显示原始密码让用户重新输入 相仿两个输入框是新密码 需要重新更新
        if (isPasswordCorrect == 0) {
          passwordWidgetStateGlobalKey?.currentState
              ?.setIsVisibleForOriginPassword(true);
          Utility.showToastMsg(msg: getI18NKey().digit_password_incorrect);
          return;
        }
      } else {
        //密码正确就更新
        String originPassword =
            passwordWidgetStateGlobalKey?.currentState?.getOriginPassword() ??
                "";
        CryptoManager.getInstance()
            .setDigitPassword(folderId: objectId, password: originPassword);
        bool isPasswordCorrect = CryptoManager.getInstance()
            .isPasswordCorrectForPassword(
                folderId: objectId, password: originPassword);
        if (isPasswordCorrect == false) {
          Utility.showToastMsg(msg: getI18NKey().digit_password_incorrect);
          return;
        }
      }
    }
    MongoApisManager.getInstance().update_FolderModelWithFM(
        folderModel: this.widget.folderModel,
        callback: (res) async {
          String objectId = this.widget.folderModel.objectId ?? "";
          MongoApisManager.getInstance().updateFolderModelsForFolderObjectId(objectId: objectId, folderModelForFolder: this.folderModelForFolder);
          if(folderModelForFolder?.folderModelObjectIdOrderList?.contains(objectId ?? "") == false) {
            folderModelForFolder?.folderModelObjectIdOrderList!
                .add(objectId ?? "");
            await MongoApisManager.getInstance().update_FolderModelWithFM(
                folderModel: folderModelForFolder!, callback: (res) {});
          }
          // -1 代表不加密 0 代表加密
          if ((this.widget.folderModel.cryptoVersion ?? -1) > -1 ||
              (this.widget.folderModel.tag == 1 &&
                  (this.oldCryptoVersion ?? -1) >= 0)) {
            //加密情况下
            //需要加密 就需要校验

            String password =
                passwordWidgetStateGlobalKey?.currentState?.getPassword1() ??
                    "";
            //密码不同需要更新密码 或者切换到不加密版本需要
            if (password != oldPasswordForUpdate) {
              //批量用新密码加密
              CryptoManager.getInstance().batchEncryptMissionModelsForFolderId(
                  folderId: objectId, password: password);
              //更新密码
              CryptoManager.getInstance().setDigitPassword(
                  folderId: objectId, password: password ?? "");
            } else if (this.widget.folderModel.tag == 1 &&
                (this.oldCryptoVersion ?? -1) >= 0) {
              //从加密模式切换到不加密moshi
              CryptoManager.getInstance()
                  .batchAndUpdateDecryptMissionModels(folderId: objectId);
              //更新密码
              CryptoManager.getInstance()
                  .clearDigitPassword(folderId: objectId);
              // List<MissionModel> listMissionModel = MongoApisManager.getInstance()
              //     .queryEncryptMissioinModelsByFolderId(folderId: this.widget.folderModel.objectId ?? "");
              // CryptoManager.getInstance()
              //     .batchDecryptMissionModels(
              //     listMissionModel);
            }
            if (this.oldCryptoVersion == -1 &&
                (this.widget.folderModel.cryptoVersion ?? -1) >= 0) {
              //从不加密模式切换到加密模式
              CryptoManager.getInstance().batchEncryptMissionModelsForFolderId(
                  folderId: objectId, password: password);
              //更新密码
              CryptoManager.getInstance().setDigitPassword(
                  folderId: objectId, password: password ?? "");
            }

            String passwordDecrypted = CryptoManager.getInstance()
                .getDigitPassword(folderId: objectId);
            print("passwordDecrypted: $passwordDecrypted");
          }
          if (Utility.isHandsetBySize()) {
            Utility.popNavigator(context, res);
          }
          resetForm();
          // eventBus.fire(EventFn(Params.ACTION_UPDATE_FOLDER_PAGE, {}));
          Utility.showToastMsg(msg: getI18NKey().updateSuccess);
        });
  }

  void onClickCreateFolder() async {
    //加密需要校验
    if ((this.widget.folderModel.cryptoVersion ?? -1) > -1) {
      //需要加密 就需要校验
      bool res =
          passwordWidgetStateGlobalKey?.currentState?.checkPassword() ?? false;
      if (!res) {
        return;
      }
      String? password =
          passwordWidgetStateGlobalKey?.currentState?.getPassword1();
      // CryptoManager.getInstance().getDigitPassword(folderId: )
      // this.widget.folderModel = await CryptoManager.getInstance().encryptFolderModelTitle(this.widget.folderModel, password ?? "");
      // folderModel.title = await CryptoManager.getInstance().encryptFolderModelTitle(folderModel, "123").title ?? "";
    }
    MongoDbSaved? res = await MongoApisManager.getInstance().insertFolderData(
        shouldQuery: this.widget.folderModel.layoutType == 1 &&
                method != "customized" //分组 非自定义模式不需要更新
            ? false
            : true,
        cryptoVersion: this.widget.folderModel.cryptoVersion,
        layoutType: this.widget.folderModel.layoutType,
        title: this.widget.folderModel.title,
        color: this.widget.folderModel.color,
        start_time: this.widget.folderModel.start_time,
        end_time: this.widget.folderModel.end_time,
        icon: this.widget.folderModel.icon,
        tag: this.widget.folderModel.tag,
        tagName: this.widget.folderModel.tag == 2
            ? this.widget.folderModel.title
            : '',
        callback: (res) {});
    // -1 代表不加密 0 代表加密
    if ((this.widget.folderModel.cryptoVersion ?? -1) > -1) {
      //需要加密 就需要校验
      String objectId = res?.objectId ?? "";
      String password =
          passwordWidgetStateGlobalKey?.currentState?.getPassword1() ?? "";
      CryptoManager.getInstance()
          .setDigitPassword(folderId: objectId, password: password ?? "");
      String passwordDecrypted =
          CryptoManager.getInstance().getDigitPassword(folderId: objectId);
      print("passwordDecrypted: $passwordDecrypted");
    }
    // this.widget.folderModel.objectId = res?.objectId;
    //
    // //如果选择了文件夹 需要更新文件夹的排序
    // if (folderModelForFolder != null &&
    //     folderModelForFolder?.objectId != null) {
    //   if (folderModelForFolder?.folderModelObjectIdOrderList == null) {
    //     folderModelForFolder?.folderModelObjectIdOrderList = [];
    //   }
    //   if(folderModelForFolder?.folderModelObjectIdOrderList?.contains(res?.objectId ?? "") == false) {
    //     folderModelForFolder?.folderModelObjectIdOrderList!
    //         .add(res?.objectId ?? "");
    //     await MongoApisManager.getInstance().update_FolderModelWithFM(
    //         folderModel: folderModelForFolder!, callback: (res) {});
    //   }
    //   // folderModelForFolder!.objectId = res?.objectId;
    // }

    MongoApisManager.getInstance().updateFolderModelsForFolderObjectId(objectId: res?.objectId ?? "", folderModelForFolder: this.folderModelForFolder);

    await this.insertGroupModel(folderId: res?.objectId ?? "");
    if (Utility.isHandsetBySize() ||
        (this.widget.pageNavShowEnum != null &&
            this.widget.pageNavShowEnum == PageNavShowEnum.show)) {
      Utility.popNavigator(context, res);
    }
    resetForm();
    eventBus.fire(EventFn(Params.ACTION_UPDATE_FOLDER_PAGE, {}));
    Utility.showToastMsg(msg: getI18NKey().createSuccess);
  }

  //customized, pdpa, gtd, four_season, jan_to_dec, micro_mastery
  Future insertGroupModel({required String folderId}) async {
    listGroupModel = [];
    switch (this.method) {
      case "customized":
        break;
      case "pdpa":
        List<GroupModel> list = CONSTANTS.getPDPAList(folderId: folderId);
        listGroupModel.addAll(list);
        break;
      case "gtd":
        List<GroupModel> list = CONSTANTS.getGTDList(folderId: folderId);
        listGroupModel.addAll(list);
        break;
      case "four_season":
        List<GroupModel> list =
            CONSTANTS.getFourSeasonsList(folderId: folderId);
        listGroupModel.addAll(list);
        break;
      case "jan_to_dec":
        List<GroupModel> list = CONSTANTS.getJanToDec(folderId: folderId);
        listGroupModel.addAll(list);
        break;
      case 'micro_mastery':
        List<GroupModel> list =
            CONSTANTS.getMicroMasteryList(folderId: folderId);
        listGroupModel.addAll(list);
        break;
    }
    if (listGroupModel.length > 0) {
      List listGroupModel2 = await MongoApisManager.getInstance()
          .batchInsert_GroupModels(
              listParam: listGroupModel, callback: (res) {});
      // listGroupModel = Utility.orderGroupModelByTitle(listGroupModel1: listGroupModel, listGroupModel2: listGroupModel2);
      List<String> lisObjectId = [];
      listGroupModel2.forEach((element) {
        lisObjectId.add(element['data']['_id'] ?? "");
      });
      // List<String> lisObjectId = listGroupModel.map((e) => e.objectId ?? "").toList();
      this.widget.folderModel.groupModelObjectIdOrderList = lisObjectId;
      await MongoApisManager.getInstance().update_FolderModelWithFM(
          folderModel: this.widget.folderModel, shouldQueryMissionModel: true);
    }
    return;
  }

  void initState() {
    super.initState();
    //如果外部传入了导航栏是否设置 则根据外部的pageNavShowEnum来显示 否则按照默认得来
    //这里用的场景主要是Pc端透传过来
    if (this.widget.pageNavShowEnum != null &&
        this.widget.pageNavShowEnum == PageNavShowEnum.show) {
      super.forceAppBarVisible = true;
    } else if (this.widget.pageNavShowEnum != null &&
        this.widget.pageNavShowEnum == PageNavShowEnum.none) {
      super.forceAppBarVisible = false;
    }
    // selectObjectTypeModel?.icon =  IconData(this.widget.folderModel.icon ?? Icons.fiber_manual_record.codePoint, fontFamily: 'MaterialIcons');
  }

  @override
  void dispose() {
    super.dispose();
    IconsGridViewWidgetStateGlobalKey = GlobalKey();
  }

  void resetForm() {
    textEditingController?.text = '';
    this.widget.folderModel = FolderModel();
    updateUI();
  }

  InkWell getDailyStartTimeWidget(BuildContext context) {
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().start_time,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
              this.widget.folderModel.start_time != null
                  ? Utility.formatHourAndMin2(
                      this.widget.folderModel.start_time ?? 0)
                  : getI18NKey().none,
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black87),
                  fontSize: 12)),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        DateTimeModel? model = await Utility.showDateTimePickerDialog(context);
        int? startTime = model?.timestamp;
        int? endTime = this.widget.folderModel.end_time;
        if (startTime != null && endTime != null) {
          bool isBefore = (startTime > endTime);
          if (isBefore) {
            Utility.showToastMsg(
                msg: getI18NKey().end_time_cannot_before_start_time);
            return;
          }
        }

        this.widget.folderModel.start_time = model?.timestamp;
        // this.widget.folderModel?.end_time =;
        int daysDifferent = Utility.getDayDiffByDayFromTimeStamp(
            this.widget.folderModel?.end_time ?? 0,
            this.widget.folderModel?.start_time ?? 0);
        setState(() {});
      },
    );
  }

  Row getDailyEndTimeWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          child: Wrap(
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                getI18NKey().deadLine,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              SizedBox(
                width: 5,
              ),
              new Text(
                  this.widget.folderModel.end_time != null
                      ? Utility.formatHourAndMin2(
                          this.widget.folderModel.end_time ?? 0)
                      : getI18NKey().none,
                  style: TextStyle(
                      color: ThemeManager.getInstance()
                          .getTextColor(defaultColor: Colors.black87),
                      fontSize: 12)),
              Icon(
                Icons.arrow_right_sharp,
                color: ThemeManager.getInstance()
                    .getIconColor(defaultColor: Colors.black87),
              )
            ],
          ),
          onTap: () async {
            if(this.widget.folderModel?.start_time == null) {
              Utility.showToastMsg(msg: getI18NKey().please_select_daily_start_time);
              return;
            }
            DateTimeModel? model =
                await Utility.showDateTimePickerDialog(context);

            int? startTime = this.widget.folderModel.end_time;
            int? endTime = model?.timestamp;
            if (startTime != null && endTime != null) {
              bool isBefore = (startTime > endTime);
              if (isBefore) {
                Utility.showToastMsg(
                    msg: getI18NKey().end_time_cannot_before_start_time);
                return;
              }
            }

            // if((model?.timestamp ?? 0) < (this.widget.folderModel?.start_time ?? 100000000)) {
            //   Utility.showToast(msg: getI18NKey().end_time_cannot_before_start_time);
            //   return;
            // }
            // if(this.widget.folderModel.start_time != null && this.widget.folderModel.end_time != null) {
            // bool isBefore = (this.widget.folderModel.start_time! > model!.timestamp!);
            //   if(isBefore) {
            //     Utility.showToast(msg: getI18NKey().end_time_cannot_before_start_time);
            //     return;
            // }
            // }

            this.widget.folderModel.end_time = model?.timestamp;
            // this.widget.folderModel?.end_time =;
            int daysDifferent = Utility.getDayDiffByDayFromTimeStamp(
                this.widget.folderModel?.end_time ?? 0,
                this.widget.folderModel?.start_time ?? 0);
            setState(() {});
          },
        ),
        this.widget.folderModel.start_time != null &&
                this.widget.folderModel.end_time != null
            ? Text(
                getI18NKey().num_days(Utility.getDayDiffByDayFromTimeStamp(
                    this.widget.folderModel?.end_time ?? 0,
                    this.widget.folderModel?.start_time ?? 0)),
                style: TextStyle(fontSize: 13, color: Color(0xff999999)),
              )
            : SizedBox.shrink()
      ],
    );
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    //默认值
    if (this.widget.folderModel != null) {
      if (this.widget.folderModel.icon == 0) {
        this.widget.folderModel.icon =
            CONSTANTS.getSelectIcons()[0].icon!.codePoint;
      }
      if (this.widget.folderModel.color == 0) {
        this.widget.folderModel.color = CONSTANTS.getColors()[0].color;
      }
    }
    return Container(
      color: _pageCanvasColor,
      padding: new EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: SingleChildScrollView(
                  controller: scrollController,
                  // primary: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            // border: OutlineInputBorder(),
                            hoverColor: ThemeManager.getInstance()
                                .getCardBackgroundColor(
                              defaultColor: Colors.white,
                            ),
                            focusColor: ThemeManager.getInstance()
                                .getInputThemeColor(
                                    defaultColor: Colors.white,
                                    defaultDarkColor: ThemeManager.getInstance()
                                        .getBackgroundColor()),
                            //右边距是为了放置番茄计数器
                            fillColor: ThemeManager.getInstance()
                                .getInputThemeColor(defaultColor: Colors.white),
                            filled: true,
                            focusedBorder: _outlineInputBorder,
                            enabledBorder: _outlineInputBorder,
                            disabledBorder: _outlineInputBorder,
                            focusedErrorBorder: _outlineInputBorder,
                            errorBorder: _outlineInputBorder,
                            border: _outlineInputBorder,
                            contentPadding: EdgeInsets.all(0.0),
                            prefixIcon: Icon(
                                (this.widget.folderModel.tag == 0 ||
                                        this.widget.folderModel.tag == false ||
                                        this.widget.folderModel.tag == null)
                                    ? Icons.calendar_today
                                    : this.widget.folderModel.tag == 1
                                        ? (IconData(
                                                this.widget.folderModel?.icon ??
                                                    Icons.local_offer.codePoint,
                                                fontFamily: 'MaterialIcons') ??
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
                      //
                      if (this.widget.folderModel.tag == 1)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 10),
                          child: Text(
                            getI18NKey().folder,
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff999999)),
                          ),
                        ),
                      // 只有mission才显示
                      if (this.widget.folderModel.tag == 1)
                        CustomFolderModelSelectForFoldersPopupWidget(
                          onSelected: (v) {
                            this.folderModelForFolder = v;
                            updateUI();
                            print(v);
                          },
                          child: Container(
                              margin: EdgeInsets.only(left: 20),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: fontSize + 10,
                              decoration: BoxDecoration(
                                  color: ThemeManager.getInstance()
                                      .getDefautThemeColor(),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                runAlignment: WrapAlignment.center,
                                alignment: WrapAlignment.center,
                                children: [
                                  Utility.getSVGPicture(R.assetsImgIcFolder,
                                      size: 12),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  new Text(
                                    folderModelForFolder?.title ??
                                        getI18NKey().unselected,
                                    maxLines: 1,
                                    softWrap: false,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: TextUtil.isEmpty(
                                                folderModelForFolder?.objectId)
                                            ? Color(0xffa0a0a0)
                                            : Colors.white,
                                        fontSize: fontSize),
                                  ),
                                  //半透明圆形 里面有个inkwell x关闭按钮 点击会清空folderModelForFolder
                                  if (folderModelForFolder != null)
                                    InkWell(
                                      onTap: () {
                                        folderModelForFolder = null;
                                        updateUI();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: 5),
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: Color(0x33ffffff),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Icon(
                                          Icons.close,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  // 向右的白色三角箭头
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                ],
                              )),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      // 只有mission才显示
                      if (this.widget.folderModel.tag == 1)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 3),
                          child: Text(
                            getI18NKey().encrypt,
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff999999)),
                          ),
                        ),
                      // 只有mission才显示
                      if (this.widget.folderModel.tag == 1)
                        IconButtonListWidget(
                          initIndex:
                              (this.widget.folderModel.cryptoVersion ?? -1) >= 0
                                  ? 1
                                  : 0,
                          list: CONSTANTS.getEncrypteButtonList(
                              defaultVal:
                                  this.widget.folderModel.layoutType ?? 0),
                          onTapListener: (obj) {
                            switch (obj['data'].code) {
                              case 'normal':
                                this.widget.folderModel.cryptoVersion = -1;
                                break;
                              case 'encrypted':
                                this.widget.folderModel.cryptoVersion = 0;
                                break;
                            }
                            updateUI();
                          },
                        ),
                      if (this.widget.folderModel.tag == 1 &&
                          (this.widget.folderModel.cryptoVersion ?? -1) >= 0)
                        DescriptionWidget(
                          text: getI18NKey().encrypt_desc,
                        ),
                      if (this.widget.folderModel.tag == 1 &&
                          (this.widget.folderModel.cryptoVersion ?? -1) >= 0)
                        SizedBox(
                          height: 10,
                        ),
                      if (this.widget.folderModel.tag == 1 &&
                          (this.widget.folderModel.cryptoVersion ?? -1) >= 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 3),
                          child: Text(
                            getI18NKey().local_password,
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff999999)),
                          ),
                        ),
                      if (this.widget.folderModel.tag == 1 &&
                          (this.widget.folderModel.cryptoVersion ?? -1) >= 0)
                        DescriptionWidget(
                          text: getI18NKey().local_password_desc,
                        ),
                      if (this.widget.folderModel.tag == 1 &&
                          (this.widget.folderModel.cryptoVersion ?? -1) >= 0)
                        SizedBox(
                          height: 10,
                        ),
                      Offstage(
                        // oldCryptoVersion == 0 如果有密码 就需要显示密码 保证解密没问题 有正确的密码
                        offstage: !(this.oldCryptoVersion == 0 ||
                            (this.widget.folderModel.tag == 1 && //1-表示各种图案circle mission;2-表示的是 tag; 3-代表文件夹;null-今天 明天 即将到来 4-过滤器
                                (this.widget.folderModel.cryptoVersion ?? -1) >=
                                    0)),
                        child: TwoPasswordWidget(
                          key: passwordWidgetStateGlobalKey,
                        ),
                      ),

                      // 只有mission才显示
                      if (this.widget.folderModel.tag == 1)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 3),
                          child: Text(
                            getI18NKey().view,
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff999999)),
                          ),
                        ),
                      // 只有mission才显示
                      if (this.widget.folderModel.tag == 1)
                        IconButtonListWidget(
                          initIndex: this.widget.folderModel.layoutType ?? 0,
                          list: CONSTANTS.getViewsButtonList(
                              defaultVal:
                                  this.widget.folderModel.layoutType ?? 0),
                          onTapListener: (obj) {
                            switch (obj['data'].code) {
                              case 'listview':
                                this.widget.folderModel.layoutType = 0;
                                break;
                              case 'group':
                                this.widget.folderModel.layoutType = 1;
                                break;
                              case 'timeline':
                                this.widget.folderModel.layoutType = 2;
                                break;
                            }
                            updateUI();
                          },
                        ),
                      if (TextUtil.isEmpty(this.widget.folderModel.objectId) &&
                          this.widget.folderModel.layoutType == 1) //创建才生效
                        SizedBox(
                          height: 10,
                        ),
                      if (TextUtil.isEmpty(this.widget.folderModel.objectId) &&
                          this.widget.folderModel.layoutType == 1) //创建才生效
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 3),
                          child: Text(
                            getI18NKey().method,
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff999999)),
                          ),
                        ),
                      if (TextUtil.isEmpty(this.widget.folderModel.objectId) &&
                          this.widget.folderModel.layoutType == 1) //创建才生效
                        IconButtonListWidget(
                          initIndex: 0,
                          list: CONSTANTS.getCreateFolderButtonList(
                              defaultVal: 0),
                          onTapListener: (obj) {
                            // if(TextUtil.isEmpty(this.widget.folderModel.objectId)) {
                            //   Utility.showToast(msg: getI18NKey().only_change_when_create);
                            // }
                            // customized, pdpa, gtd, four_season, jan_to_dec
                            switch (obj['data'].code) {
                              case 'customized':
                                // this.widget.folderModel.method = 0;
                                this.method = '';
                                break;
                              case 'pdpa':
                                this.method = 'pdpa';
                                // this.listGroupModel = CONSTANTS.getPDPAList();
                                break;
                              case 'gtd':
                                this.method = 'gtd';
                                // this.widget.folderModel.method = 2;
                                break;
                              case 'four_season':
                                this.method = 'four_season';
                                // this.widget.folderModel.method = 3;
                                break;
                              case 'jan_to_dec':
                                this.method = 'jan_to_dec';
                                // this.widget.folderModel.method = 4;
                                break;
                              case 'micro_mastery':
                                this.method = 'micro_mastery';
                            }
                            updateUI();
                          },
                        ),
                      if (this.widget.folderModel.layoutType == 1)
                        SizedBox(
                          height: 10,
                        ),
                      if (this.widget.folderModel.layoutType == 1)
                        DescriptionWidget(
                            text: this.method == 'pdpa'
                                ? getI18NKey().pdpa_desc
                                : this.method == 'gtd'
                                    ? getI18NKey().gtd_desc
                                    : this.method == 'four_season'
                                        ? getI18NKey().four_seasons_desc
                                        : this.method == 'jan_to_dec'
                                            ? getI18NKey().jan_to_dec_desc
                                            : this.method == 'micro_mastery'
                                                ? getI18NKey()
                                                    .micro_mastery_desc
                                                : ''),
                      SizedBox(
                        height: 10,
                      ),
                      this.widget.folderModel.tag == 1
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, bottom: 3),
                              child: Text(
                                getI18NKey().listing_time_optional,
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xff999999)),
                              ),
                            )
                          : SizedBox.shrink(),
                      this.widget.folderModel.tag == 1
                          ? Container(
                              padding: EdgeInsets.only(left: 8, bottom: 15),
                              child: Row(
                                children: [
                                  getDailyStartTimeWidget(context),
                                  SizedBox(
                                    width: 0,
                                  ),
                                  getDailyEndTimeWidget(context),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 8),
                        child: Text(
                          getI18NKey().color_optional,
                          style:
                              TextStyle(fontSize: 13, color: Color(0xff999999)),
                        ),
                      ),
                      ColorsGridViewWidget(
                          defaultIndexColor: this.widget.folderModel.color,
                          onTapListener: (data) {
                            setState(() {
                              this.widget.folderModel.color = data.color;
                            });
                          }),
                      this.widget.folderModel.tag == 1
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, bottom: 10, top: 15),
                              child: Text(
                                getI18NKey().listing_icon_optional,
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xff999999)),
                              ),
                            )
                          : SizedBox.shrink(),
                      this.widget.folderModel.tag == 1
                          ? Align(
                              alignment: Alignment.center,
                              child: IconsGridViewWidget(
                                  // height: height - 300,
                                  // defaultIndex: this.widget.folderModel.icon ?? 0,
                                  key: IconsGridViewWidgetStateGlobalKey,
                                  defaultIndex:
                                      this.widget.folderModel?.icon ?? -1,
                                  onTapListener: (model) {
                                    SelectObjectTypeModel modelTmp = model;
                                    this.widget.folderModel?.icon =
                                        modelTmp.icon?.codePoint ?? 0;
                                    // selectObjectTypeModel = model;
                                    updateUI();
                                  },
                                  color: Color(
                                      this.widget.folderModel.color == 0
                                          ? CONSTANTS.getColors()[0].color
                                          : this.widget.folderModel.color)),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ))),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                if (TextUtil.isEmpty(this.widget.folderModel.title)) {
                  Utility.showToastMsg(msg: getI18NKey().pleaseInputTitle);
                  return;
                }
                if (this.widget.folderModel.color <= 0) {
                  Utility.showToastMsg(msg: getI18NKey().pleaseSelectColor);
                  return;
                }
                if (this.widget.pageEnum == PageModeEnum.create) {
                  this.onClick('onClickCreateFolder', this.widget.folderModel);
                } else {
                  this.onClick('onClickUpdateFolder', this.widget.folderModel);
                }
              },
              child: Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 260,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        ThemeManager.getInstance().getButtonBackgroundColor(),
                    // gradient: LinearGradient(
                    //     colors:
                    //         ThemeManager.getInstance().getButtonLinearGradientBackgroundColor()),
                  ),
                  child: Text(
                    this.widget.pageEnum == PageModeEnum.create
                        ? getI18NKey().create
                        : getI18NKey().update,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )),
            ),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
    // return LayoutBuilder(builder: (context, constraints) {
    //   double height = constraints.maxHeight;
    //
    // });
  }
}
