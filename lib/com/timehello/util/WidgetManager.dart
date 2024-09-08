import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/provider/CalendarMssionEnv.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/CustomAppointWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/appointment_engine/appointment.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/common/calendar_controller.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/common/enums.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/common/event_args.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';
import '../components/LoadingWidget.dart';
import '../config/ColorsConfig.dart';
import '../config/StylesConfig.dart';
import '../models/FolderModel.dart';
import '../models/WQBFolderModel.dart';
/**
 * 公共组件的管理
 */
class WidgetManager {
  static List<TextSpan> getTagsWidgetSpan(MissionModel missionModel, {double fontSize = 12}) {
    // List<TextSpan> listTextSpan = [];
    List<FolderModel> list = CONSTANTS
        .getFolderModelListFromStringList(missionModel.tagNames?.split(','));
    List<TextSpan> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      FolderModel folderModel = list[i];
      // listWidget.add(SizedBox(
      // width: 5,
      // ));
      listWidget.add(TextSpan(
          text: "#" + (folderModel.title ?? ""),
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
              color: Color(folderModel.color))));
    }
    return listWidget;
  }

  static CalendarAppointmentBuilder getDayAppointmentUIWidget(
      CalendarController _calendarController) {
    if (_calendarController.view == CalendarView.month || _calendarController.view == CalendarView.timelineMonth || _calendarController.view == CalendarView.day) {
      return getDayAppointmentUIMonth;
    }
    return getDayAppointmentUI;
  }

  static CalendarAppointmentBuilder getAppointmentUIWidget(
      CalendarController _calendarController) {
    if (_calendarController.view == CalendarView.month || _calendarController.view == CalendarView.timelineMonth) {
      return getAppointmentUIMonth;
    }
    return getAppointmentUI;
  }

  static Widget getDayAppointmentUIMonth(
      BuildContext context, CalendarAppointmentDetails details) {
    return getCustomAppointWidget(details, context, calendarView: CalendarView.month, shouldShowCheckBox: false);
  }

  static Widget getDayAppointmentUI(
      BuildContext context, CalendarAppointmentDetails details) {
    return getCustomAppointWidget(details, context, calendarView: CalendarView.month, shouldShowCheckBox: false);
  }

  static Widget getAppointmentUIMonth(
      BuildContext context, CalendarAppointmentDetails details) {
    return getCustomAppointWidget(details, context, calendarView: CalendarView.month);
  }

  static Widget getAppointmentUI(
      BuildContext context, CalendarAppointmentDetails details) {
    return getCustomAppointWidget(details, context);
    // }
  }

  static Widget getCustomAppointWidget(
      CalendarAppointmentDetails details, BuildContext context,
      {CalendarView? calendarView, bool shouldShowCheckBox = true}) {
    Appointment appointment = details.appointments.first;
    // MissionModel? missionModelCurSelected = context.read<CalendarMssionEnv>().curSelectedMissionModel;
    MissionModel? missionModel = MongoApisManager.getInstance()
        .queryWhereEqual_missionDataByObjectId(
        objectId: appointment.id.toString());
    FolderModel? folderModel;
    int priorityColor = CONSTANTS.getPriorityColor(missionModel?.priorityStatus ?? 3);
    if (missionModel?.folder_id != null) {
      folderModel = MongoApisManager.getInstance()
          .queryfolderModelWithFolderId(missionModel?.folder_id ?? "");
    }

    return CustomAppointmentWidget(
      details: details,
      calendarView: calendarView,
      shouldShowCheckBox: shouldShowCheckBox,
    );

    // return Container(
    //   constraints: BoxConstraints(minHeight: 100),
    //   decoration: BoxDecoration(
    //     color: folderModel?.color != null
    //         ? Color(folderModel!.color - (ThemeManager.getInstance().isDark() ? 0x10000000 : 0xa0000000))
    //         : Color(0xffff8800 - (ThemeManager.getInstance().isDark() ? 0x10000000 : 0xa0000000)),
    //     borderRadius: BorderRadius.circular(4),
    //     border: missionModelCurSelected == missionModel ? Border.all(
    //         color: folderModel?.color != null
    //             ? Color(priorityColor ?? folderModel!.color)
    //             : Color(priorityColor ?? 0xffff8800),
    //         width: 3) : Border(
    //         left: BorderSide(
    //             color: folderModel?.color != null
    //                 ? Color(priorityColor ?? folderModel!.color)
    //                 : Color(priorityColor ?? 0xffff8800),
    //             width: 3)),
    //   ),
    //   padding: EdgeInsets.only(left: 4),
    //   alignment: calendarView == CalendarView.month
    //       ? Alignment.centerLeft
    //       : Alignment.topLeft,
    //   child: Text.rich(
    //     maxLines: calendarView == CalendarView.month ? 1 : null,
    //     overflow: calendarView == CalendarView.month ? TextOverflow.ellipsis : null,
    //     TextSpan(
    //       // text: 'Hello', // default text style
    //       children: [
    //         if(shouldShowCheckBox)
    //           WidgetSpan(
    //               child: Container(
    //                 width: 15,
    //                 height: 15,
    //                 padding: calendarView == CalendarView.month ? null:EdgeInsets.only(top: 1),
    //                 child: CheckImage(
    //                   width: 15,
    //                   height: 15,
    //                   isSizeConfigured: true,
    //                   onTapListener: (res) {
    //                     Utility.onClickFinishItem(
    //                         missionModel: missionModel ?? MissionModel(),
    //                         folderModel: folderModel ?? null,
    //                         timestampCurrent: details.date.millisecondsSinceEpoch,
    //                         context: context,
    //                         finishCallback: () {
    //                           // requestDatas();
    //                         });
    //                   },
    //                   checked: Utility.getIsFinishOfMissionModel(
    //                     missionModel: missionModel ?? MissionModel(),
    //                     curMonthTimeStamp: details.date.millisecondsSinceEpoch,
    //                   ),
    //                   checkIcon: Icon(Icons.check_circle,
    //                       size: 15, color: ColorsConfig.calendar_green),
    //                   uncheckIcon: Icon(Icons.radio_button_unchecked_outlined,
    //                       color: ColorsConfig.gray_a7, size: 15),
    //                 ),
    //               )),
    //         TextSpan(
    //             text: missionModel?.title ?? "",
    //             style: const TextStyle(
    //               color: Color(0xff404040),
    //               fontSize: 12,
    //               fontWeight: FontWeight.w500,
    //             )),
    //         TextSpan(text:!TextUtil.isEmpty(missionModel?.localDurationString) ? "("+(missionModel?.localDurationString ?? "") + ")" : "(1h 00m)",
    //             style: TextStyle(
    //               color: Color(0xff404040),
    //               fontSize: 12,
    //               fontWeight: FontWeight.w500,
    //             )),
    //         ...getTagsWidgetSpan(missionModel ?? MissionModel()),
    //         // TextSpan(text: 'world', style: TextStyle(fontWeight: FontWeight.bold)),
    //       ],
    //     ),
    //   ),
    //
    // );
  }

  static double getWidgetWidth(GlobalKey globalKey) {
    return globalKey.currentContext?.size?.width ?? 0;
  }

  static double getWidgetHeight(GlobalKey globalKey) {
    return globalKey.currentContext?.size?.height ?? 0;
  }

  static List<WidgetSpan> getIsNoteWidget(MissionModel missionModel) {
    List<WidgetSpan> listWidget = [];
    final double space = 5;
    listWidget.add(WidgetSpan(child: SizedBox(width: space)));
    if (TextUtil.isEmpty(missionModel.newRichEditorUrl) &&
        (missionModel.noteRecordUrls?.length ?? 0) == 0 &&
        (missionModel.noteRecordUrls?.length ?? 0) == 0) {
      return listWidget;
    }
    if (!TextUtil.isEmpty(missionModel.newRichEditorUrl)) {
      listWidget.add(WidgetSpan(child: Icon(Icons.note_alt, color: Color(0xffa0a0a0), size: 15)));
      listWidget.add(WidgetSpan(child: SizedBox(width: space)));
    }
    if ((missionModel.noteRecordUrls?.length ?? 0) > 0) {
      listWidget.add(WidgetSpan(child: Icon(Icons.record_voice_over, color: Color(0xffa0a0a0), size: 15)));
      listWidget.add(WidgetSpan(child: SizedBox(width: space)));
    }
    if ((missionModel.noteRecordUrls?.length ?? 0) > 0) {
      listWidget.add(WidgetSpan(child: Icon(Icons.attach_file, color: Color(0xffa0a0a0), size: 15)));
      listWidget.add(WidgetSpan(child: SizedBox(width: space)));
    }
    return listWidget;
  }

  static Widget getLoadingWidget() {
    return new Center(
      ///弹框大小
      child: new SizedBox(
        width: Utility.isHandsetBySize() ? 70.0 : 80.0,
        height: Utility.isHandsetBySize() ? 70.0 : 80.0,
        child: new Container(
          ///弹框背景和圆角
          decoration: ShapeDecoration(
            color: Color(0xa0202020),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LoadingWidget(
                size: Utility.isHandsetBySize() ? 30 : 30,
              ),
              new Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                ),
                child: new Text(
                  getI18NKey().loading,
                  style: new TextStyle(
                    fontSize: Utility.isHandsetBySize() ? 12.0 : 12.0,
                    decoration: TextDecoration.none,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget getCachedNetworkImage(
      {double radius: 20,
        required double width,
        required double height,
        required String url,
        bool isLoading = true}) {
    return CachedNetworkImage(
      width: width,
      height: height,
      fit: BoxFit.cover,
      imageUrl: Utility.filterHttpUrl(url ?? '', prefix: "oss"),
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
          ),
        ),
      ),
      placeholder: (context, url) =>
      isLoading == true ? CircularProgressIndicator() : SizedBox.shrink(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  static Widget getMiniInputWidget(
      {TextEditingController? inputController,
        Function? onChangeListener,
        Function? onSubmitListener}) {
    FocusNode _contentFocusNode = FocusNode();
    OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
      gapPadding: 0,
      borderSide: BorderSide(
        color: ThemeManager.getInstance()
            .getInputBorderColor(defaultColor: Colors.white),
      ),
    );
    return TextField(
      // focusNode: _contentFocusNode,
      // controller: inputController,
      onChanged: (text) {
        // inputController.clear();
        // _value = text;
        if (onChangeListener != null) {
          onChangeListener(text);
        }
        print(text);
      },
      onSubmitted: (value) {
        if (onSubmitListener != null) {
          onSubmitListener(value);
        }
        print(value);
      },
      style: TextStyle(
          fontFamily: 'Montserrat',
          decorationColor: Color(0xffd5d5d5),
          color: Color(0xff404040),
          fontWeight: FontWeight.w500),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          fillColor: Colors.white,
          //背景颜色，必须结合filled: true,才有效
          hoverColor: Colors.white,
          focusColor: Colors.white,
          filled: true,
          //重点，必须设置为true，fillColor才有效
          // border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(0.0),
          prefixIcon: Icon(
            Icons.edit,
            color: Color(0xffd5d5d5),
          ),
          prefixIconColor: Color(0xffd5d5d5),
          floatingLabelStyle: TextStyle(color: Color(0xffff0000), fontSize: 14),
          labelStyle: TextStyle(color: Color(0xffd5d5d5), fontSize: 14),
          border: _outlineInputBorder,
          //边框，一般下面的几个边框一起设置
          //keyboardType: TextInputType.number, //键盘类型
          //obscureText: true,//密码模式
          focusedBorder: _outlineInputBorder,
          enabledBorder: _outlineInputBorder,
          disabledBorder: _outlineInputBorder,
          focusedErrorBorder: _outlineInputBorder,
          errorBorder: _outlineInputBorder,
          labelText: Utility.isHandsetBySize()
              ? getI18NKey().addMissions2
              : getI18NKey().missionPageInputHolder,
          helperText: ''),
    );
  }

  static Widget getInputWidget(
      {bool readOnly = false,
        required Function onSubmit,
        required Function onChange}) {
    // OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    //   gapPadding: 0,
    //   borderSide: BorderSide(
    //     color: Colors.white,
    //   ),
    // );
    return Container(
        constraints: BoxConstraints(maxHeight: 30, minHeight: 30),
        child: TextField(
            readOnly: readOnly,
            style:
            TextStyle(letterSpacing: 15, fontSize: 16, color: Colors.blue),
            textAlign: TextAlign.center,
            onChanged: (text) {
              onChange(text);
            },
            onSubmitted: (value) {
              onSubmit(value);
            },
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: readOnly == true
                    ? getI18NKey().game_input_waiting
                    : getI18NKey().edit,
                labelStyle: TextStyle(fontSize: 14))));
  }

  /**
   * 获取活动框的textfield
   */
  static Widget getSliderDialogTitleWidget(
      {FocusNode? focusNode,
        int maxLength: 100,
        TextEditingController? textEditingController,
        Function? onChange}) {
    if ((textEditingController?.text?.length ?? maxLength) >= maxLength) {
      textEditingController?.text =
          textEditingController.text.substring(0, maxLength) + "...";
    }
    return TextField(
      style: TextStyle(
          fontSize: 14,
          color: ThemeManager.getInstance()
              .getTextColor(defaultColor: Color(0xff404040))),
      readOnly: true,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      focusNode: focusNode,
      controller: textEditingController,
      cursorColor: ThemeManager.getInstance()
          .getTextColor(defaultColor: ColorsConfig.gray_40),
      onChanged: (text) {
        // inputController.clear();
        // this.username = text;
        if (onChange != null) {
          onChange(text);
        }
        // print(text);
      },
      onSubmitted: (value) {
        // if (this.widget.onSubmitListener != null) {
        //   this.widget.onSubmitListener(value);
        // }
        print(value);
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        counterStyle: TextStyle(color: Colors.transparent),
        // fillColor: Colors.red,//背景颜色，必须结合filled: true,才有效
        // focusColor: Colors.red,
        // hoverColor: Colors.red,
        contentPadding: EdgeInsets.only(top: 20.0, bottom: 15.0),
        filled: true,
        //重点，必须设置为true，fillColor才有效
        isCollapsed: true,
        //重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
        focusedBorder: StylesConfig.buildOutlineInputBorder(),
        enabledBorder: StylesConfig.buildOutlineInputBorder(),
        border: StylesConfig.buildOutlineInputBorder(),
      ),
    );
  }

  static Widget getDialogInputWidget(
      {FocusNode? focusNode,
        TextEditingController? textEditingController,
        enabled: true,
        String? hintText,
        Function? onChange}) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          style: TextStyle(
              fontSize: 12,
              color: ThemeManager.getInstance()
                  .getTextColor(defaultColor: Color(0xff404040))),
          enabled: enabled,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          // keyboardType: TextInputType.numberWithOptions(signed: false),
          focusNode: focusNode,
          controller: textEditingController,
          cursorColor: ThemeManager.getInstance()
              .getTextColor(defaultColor: ColorsConfig.gray_40),
          onChanged: (String text) {
            if (onChange != null) {
              onChange(text);
            }
          },
          onSubmitted: (value) {
            print(value);
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.singleLineFormatter
          ],
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: hintText ?? getI18NKey().please_input_title,
            // fillColor: Colors.red,//背景颜色，必须结合filled: true,才有效
            // focusColor: Colors.red,
            // hoverColor: Colors.red,
            contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            filled: true,
            //重点，必须设置为true，fillColor才有效
            isCollapsed: true,
            //重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
            focusedBorder: StylesConfig.buildOutlineInputBorder(),
            enabledBorder: StylesConfig.buildOutlineInputBorder(),
            border: StylesConfig.buildOutlineInputBorder(),
          ),
        ));
  }

  static Widget getSliderDialogInputNumberWidget(
      {FocusNode? focusNode,
        TextEditingController? textEditingController,
        Function? onChange}) {
    return Container(
        width: 60,
        child: TextField(
          style: TextStyle(
              fontSize: 12,
              color: ThemeManager.getInstance()
                  .getTextColor(defaultColor: ColorsConfig.gray_40)),
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.numberWithOptions(signed: false),
          focusNode: focusNode,
          controller: textEditingController,
          cursorColor: ThemeManager.getInstance()
              .getTextColor(defaultColor: ColorsConfig.gray_40),
          onChanged: (String text) {
            if (onChange != null) {
              onChange(text);
            }
          },
          onSubmitted: (value) {
            print(value);
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: getI18NKey().custom,
            // fillColor: Colors.red,//背景颜色，必须结合filled: true,才有效
            // focusColor: Colors.red,
            // hoverColor: Colors.red,
            contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            filled: true,
            fillColor: ThemeManager.getInstance().getInputDecorationColor(),
            //重点，必须设置为true，fillColor才有效
            isCollapsed: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
          ),
        ));
  }

  // static Widget getDialogTitleText({required Widget child, required double width, required double height}) {
  //   return TextButton(
  //       style: StylesConfig.transparentTextButtonStyleWithSize(Size(width, height)),
  //   onPressed: () {
  //
  //   },
  //   child: child);
  // }

  static Text getDialogTitleText({required String title}) {
    return Text(title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600));
  }

  static Widget? getFolderModelIcon(FolderModel _folderModel, double iconSize) {
    int iconType = _folderModel.iconType ?? 0;
    if (iconType != null) {
      switch (iconType) {
        case 0:
          return Icon(
              (_folderModel.tag == 0 ||
                  _folderModel.tag == false ||
                  _folderModel.tag == null)
                  ? Icons.calendar_today //今天
                  : _folderModel.tag == 1
                  ? IconData(_folderModel.icon ?? 0,
                  fontFamily: 'MaterialIcons') //任务folder
                  : Icons.local_offer, //标签
              color: (_folderModel.tag == 0 ||
                  _folderModel.tag == false ||
                  _folderModel.tag == null)
                  ? Colors.pink //todo 这个是干啥 应该是默认颜色吧
                  : Color(_folderModel.color),
              size: iconSize); //颜色
          break;
        case 1:
          return Utility.getSVGPicture(R.assetsImgIcToday, size: iconSize);
      // return Icon(Icons.wb_sunny, size: iconSize, color: Colors.green);
      // break;
        case 2:
          return Utility.getSVGPicture(R.assetsImgIcTomorrow, size: iconSize);
      // return Icon(Icons.brightness_6,
      //     size: iconSize, color: Colors.deepOrange);
        case 3:
          return Utility.getSVGPicture(R.assetsImgIcThisWeek, size: 16);
      // return Icon(Icons.system_update_alt,
      //     size: iconSize, color: Colors.blue);
        case 4:
          return Utility.getSVGPicture(R.assetsImgIcUnfinishMissions, size: 16);

        case 5:
          return Utility.getSVGPicture(R.assetsImgIcCalendar, size: 16);
      // return Icon(Icons.calendar_today,
      //     size: iconSize, color: ColorsConfig.calendar_green);
        case 6:
          return Utility.getSVGPicture(R.assetsImgIcFinished, size: 18);
        case 7:
          return Utility.getSVGPicture(R.assetsImgIcCreateFolder, size: 18);
        case 12:
          return Utility.getSVGPicture(R.assetsImgIcTodo, size: 16);
        case 13:
          return Utility.getSVGPicture(R.assetsImgIcFragment, size: 16);
      // return Icon(Icons.add,
      //     size: iconSize, color: ColorsConfig.create_folder);
      // break;
      }
    } else {}
  }

  static Widget? getWQBFolderModelIcon(
      WQBFolderModel _folderModel, double iconSize) {
    int iconType = _folderModel.iconType ?? 0;
    if (iconType != null) {
      switch (iconType) {
        case 0:
          return Icon(
              (_folderModel.tag == 0 ||
                  _folderModel.tag == false ||
                  _folderModel.tag == null)
                  ? Icons.calendar_today //今天
                  : _folderModel.tag == 1
                  ? IconData(_folderModel.icon ?? 0,
                  fontFamily: 'MaterialIcons') //任务folder
                  : Icons.local_offer, //标签
              color: (_folderModel.tag == 0 ||
                  _folderModel.tag == false ||
                  _folderModel.tag == null)
                  ? Colors.pink //todo 这个是干啥 应该是默认颜色吧
                  : Color(_folderModel.color),
              size: iconSize); //颜色
          break;
        case 1:
          return Utility.getSVGPicture(R.assetsImgIcToday, size: iconSize);
      // return Icon(Icons.wb_sunny, size: iconSize, color: Colors.green);
      // break;
        case 2:
          return Utility.getSVGPicture(R.assetsImgIcTomorrow, size: iconSize);
      // return Icon(Icons.brightness_6,
      //     size: iconSize, color: Colors.deepOrange);
        case 3:
          return Utility.getSVGPicture(R.assetsImgIcThisWeek, size: 16);
      // return Icon(Icons.system_update_alt,
      //     size: iconSize, color: Colors.blue);
        case 4:
          return Utility.getSVGPicture(R.assetsImgIcUnfinishMissions, size: 16);

        case 5:
          return Utility.getSVGPicture(R.assetsImgIcCalendar, size: 16);
      // return Icon(Icons.calendar_today,
      //     size: iconSize, color: ColorsConfig.calendar_green);
        case 6:
          return Utility.getSVGPicture(R.assetsImgIcFinished, size: 18);
        case 7:
          return Utility.getSVGPicture(R.assetsImgIcCreateFolder, size: 18);
        case 9:
          return Utility.getSVGPicture(R.assetsImgIcAll, size: 18);
        case 12:
          return Utility.getSVGPicture(R.assetsImgIcTodo, size: 16);
        case 13:
          return Utility.getSVGPicture(R.assetsImgIcFragment, size: 16);
      // return Icon(Icons.add,
      //     size: iconSize, color: ColorsConfig.create_folder);
      // break;
      }
    } else {}
  }
}
