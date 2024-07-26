import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../config/ColorsConfig.dart';
import '../config/ENUMS.dart';
import '../interface/OnTapListener.dart';
import '../util/DialogManagement.dart';
import '../util/ThemeManager.dart';

class CommonCalendarHeaderWidgetController extends ChangeNotifier {
  PickerDateRange? dateTimePicker;

// PickerDateRange get dateTimePicker => dateTimePicker;
// set dateTimePicker(PickerDateRange newText) {
//   value = value.copyWith(
//     text: newText,
//     selection: const TextSelection.collapsed(offset: -1),
//     composing: TextRange.empty,
//   );
// }
}

/// 所有激活日期的集合  List<CalendarCellModel> active = [];  /// range模式下选中的集合  List<List<CalendarCellModel>> range = [];  goPreviousMonth() {    currentDate = DateUtil.addMonthsToMonthDate(currentDate, -1);    notifyListeners();  }  goNextMonth() {    currentDate = DateUtil.addMonthsToMonthDate(currentDate, 1);    notifyListeners();  }  @override  void dispose() {    range = [];    active = [];  }}

class CommonCalendarHeaderWidget extends StatefulWidget {
  static const double padding = 0;
  Function onChange;
  CalendarTypeEnum calendarTypeEnum;
  CommonCalendarHeaderWidgetController? controller;

  PickerDateRange? dateTimePickerDateRangeYear;
  PickerDateRange? dateTimePickerDateRangeMonth;
  PickerDateRange? dateTimePickerDateRangeDay;
  PickerDateRange? dateTimePickerDateRangeCustom;
  PickerDateRange? dateTimePickerDateRangeLast7Days;

  CommonCalendarHeaderWidget(
      {Key? key,
      required this.onChange,
      required this.calendarTypeEnum,
      this.controller,
      this.dateTimePickerDateRangeYear,
      this.dateTimePickerDateRangeMonth,
      this.dateTimePickerDateRangeDay,
      this.dateTimePickerDateRangeCustom,
      this.dateTimePickerDateRangeLast7Days
      // required this.title,
      // required this.subtitle,
      })
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommonCalendarHeaderWidgetState(
        dateTimePickerDateRangeYear: dateTimePickerDateRangeYear,
        dateTimePickerDateRangeMonth: dateTimePickerDateRangeMonth,
        dateTimePickerDateRangeDay: dateTimePickerDateRangeDay,
        dateTimePickerDateRangeCustom: dateTimePickerDateRangeCustom,
        dateTimePickerDateRangeLast7Days: dateTimePickerDateRangeLast7Days);
  }
}

class CommonCalendarHeaderWidgetState
    extends State<CommonCalendarHeaderWidget> {
  String? title; //年
  String? subtitle; //月份
  PickerDateRange? dateTimePickerDateRangeYear;
  PickerDateRange? dateTimePickerDateRangeMonth;
  PickerDateRange? dateTimePickerDateRangeDay;
  PickerDateRange? dateTimePickerDateRangeCustom;
  PickerDateRange? dateTimePickerDateRangeLast7Days;

  CommonCalendarHeaderWidgetState(
      {this.dateTimePickerDateRangeYear,
      this.dateTimePickerDateRangeMonth,
      this.dateTimePickerDateRangeDay,
      this.dateTimePickerDateRangeCustom,
      this.dateTimePickerDateRangeLast7Days});

  PickerDateRange? getCurrentPickerDateRange() {
    if (this.widget.calendarTypeEnum == CalendarTypeEnum.year) {
      return dateTimePickerDateRangeYear;
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.month) {
      return dateTimePickerDateRangeMonth;
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.day) {
      return dateTimePickerDateRangeDay;
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.custom) {
      return dateTimePickerDateRangeCustom;
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.last7Days) {
      return dateTimePickerDateRangeLast7Days;
    }
  }

  // @override
  // void didUpdateWidget(FourQuadrantPage oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   //todo 这里可以优化 否则会请求几遍 但是通过 this._folderModelObjId == this.widget.folderModel?.objectId有点问题
  //   if (this.widget.calendarTypeEnum == CalendarTypeEnum.day) {
  //
  //   }
  //   this?.controller.dateTimePicker
  //   // this.requestDatas();
  //   // context.watch();
  // }

  @override
  void didUpdateWidget(CommonCalendarHeaderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.calendarTypeEnum != this.widget.calendarTypeEnum) {
      if (this.widget.calendarTypeEnum == CalendarTypeEnum.day) {
        this.widget.controller?.dateTimePicker = dateTimePickerDateRangeDay;
      } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.month) {
        this.widget.controller?.dateTimePicker = dateTimePickerDateRangeMonth;
      } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.year) {
        this.widget.controller?.dateTimePicker = dateTimePickerDateRangeYear;
      } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.custom) {
        this.widget.controller?.dateTimePicker = dateTimePickerDateRangeCustom;
      } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.all) {
        this.widget.controller?.dateTimePicker = PickerDateRange(null, null);
      } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.last7Days) {
        this.widget.controller?.dateTimePicker =
            dateTimePickerDateRangeLast7Days;
      }

      this.widget.onChange(this.widget.controller?.dateTimePicker);
    }
  }

  @override
  void initState() {
    super.initState();
    if (dateTimePickerDateRangeYear == null)
      dateTimePickerDateRangeYear = PickerDateRange(
          DateTime(DateTime.now().year, 1, 1),
          DateTime(DateTime.now().year + 1, 1, 1));
    if (dateTimePickerDateRangeMonth == null)
      dateTimePickerDateRangeMonth = PickerDateRange(
          DateTime(DateTime.now().year, DateTime.now().month, 1),
          DateTime(
              DateTime.now().month == 12
                  ? DateTime.now().year + 1
                  : DateTime.now().year,
              DateTime.now().month == 12 ? 1 : DateTime.now().month + 1,
              1));
    if (dateTimePickerDateRangeDay == null)
      dateTimePickerDateRangeDay = PickerDateRange(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .add(Duration(days: 1)));
    if (dateTimePickerDateRangeCustom == null)
      dateTimePickerDateRangeCustom = PickerDateRange(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 23, 59, 59));
    if (dateTimePickerDateRangeLast7Days == null)
      dateTimePickerDateRangeLast7Days = PickerDateRange(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 6)),
          DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 23, 59, 59));

    if (this.widget.calendarTypeEnum == CalendarTypeEnum.year) {
      this.widget.controller?.dateTimePicker = dateTimePickerDateRangeYear;
      this.widget.onChange(dateTimePickerDateRangeYear);
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.month) {
      this.widget.controller?.dateTimePicker = dateTimePickerDateRangeMonth;
      this.widget.onChange(dateTimePickerDateRangeMonth);
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.day) {
      this.widget.controller?.dateTimePicker = dateTimePickerDateRangeDay;
      this.widget.onChange(dateTimePickerDateRangeDay);
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.custom) {
      this.widget.controller?.dateTimePicker = dateTimePickerDateRangeCustom;
      this.widget.onChange(dateTimePickerDateRangeCustom);
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.last7Days) {
      this.widget.controller?.dateTimePicker = dateTimePickerDateRangeLast7Days;
      this.widget.onChange(dateTimePickerDateRangeLast7Days);
    }
  }

  String getYearTitle() {
    StringBuffer s = StringBuffer();
    if (this.widget.calendarTypeEnum == CalendarTypeEnum.year) {
      s.write(
          dateTimePickerDateRangeYear?.startDate?.year ?? DateTime.now().year);
      // s.write('-');
      // s.write(
      //     dateTimePickerDateRangeYear?.endDate?.year ?? DateTime.now().year);
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.month) {
      s.write(
          dateTimePickerDateRangeMonth?.startDate?.year ?? DateTime.now().year);
      // s.write('-');
      // s.write(
      //     dateTimePickerDateRangeMonth?.endDate?.year ?? DateTime.now().year);
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.day) {
      s.write(
          dateTimePickerDateRangeDay?.startDate?.year ?? DateTime.now().year);
      // s.write('-');
      // s.write(dateTimePickerDateRangeDay?.endDate?.year ?? DateTime.now().year);
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.custom) {
      s.write(dateTimePickerDateRangeCustom?.startDate?.year ??
          DateTime.now().year);
      s.write('-');
      s.write(
          dateTimePickerDateRangeCustom?.endDate?.year ?? DateTime.now().year);
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.last7Days) {
      s.write(getI18NKey().last_7_days);
    }
    return s.toString();
  }

  String getMonthSubtitle() {
    StringBuffer s = StringBuffer();
    if (this.widget.calendarTypeEnum == CalendarTypeEnum.year) {
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.month) {
      s.write(Utility.getMonthName(
          dateTimePickerDateRangeMonth?.startDate?.month ??
              DateTime.now().month));
      // s.write('-');
      // s.write(
      //     Utility.getMonthName(dateTimePickerDateRangeMonth?.endDate?.month ?? DateTime.now().month));
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.day) {
      s.write(
          dateTimePickerDateRangeDay?.startDate?.month ?? DateTime.now().month);
      s.write('/');
      s.write(dateTimePickerDateRangeDay?.startDate?.day ?? DateTime.now().day);
      // s.write('-');
      // s.write(
      //     dateTimePickerDateRangeDay?.endDate?.month ?? DateTime.now().month);
      // s.write('/');
      // s.write(dateTimePickerDateRangeDay?.endDate?.day ?? DateTime.now().day);
    } else if (this.widget.calendarTypeEnum == CalendarTypeEnum.custom) {
      s.write(dateTimePickerDateRangeCustom?.startDate?.month ??
          DateTime.now().month);
      s.write('/');
      s.write(
          dateTimePickerDateRangeCustom?.startDate?.day ?? DateTime.now().day);
      s.write('-');
      s.write(dateTimePickerDateRangeCustom?.endDate?.month ??
          DateTime.now().month);
      s.write('/');
      s.write(
          dateTimePickerDateRangeCustom?.endDate?.day ?? DateTime.now().day);
    }
    return s.toString();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return !Utility.isHandsetBySize() && getMonthSubtitle().isEmpty == true && getYearTitle().isEmpty == true
        ? SizedBox.shrink()
        : Container(
            // padding: EdgeInsets.only(left: 10,bottom: 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color(0xff666666), width: 2))),
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    getI18NKey().creating_date,
                    style: TextStyle(
                        fontSize: Utility.isHandsetBySize() ? 12 : 14,
                        color: ThemeManager.getInstance().getTextColor(
                            defaultColor: ColorsConfig.gray_40)),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(left: 0),
                          child: Text(
                            getYearTitle(),
                            style: TextStyle(
                                fontSize:
                                    Utility.isHandsetBySize() ? 12 : 16,
                                color: ThemeManager.getInstance()
                                    .getTextColor(
                                        defaultColor:
                                            ColorsConfig.gray_40)),
                          )),
                      getMonthSubtitle().isEmpty == true
                          ? SizedBox.shrink()
                          : Container(
                              padding: EdgeInsets.only(left: 0, bottom: 0),
                              child: Text(
                                getMonthSubtitle(),
                                style: TextStyle(
                                    fontSize:
                                        Utility.isHandsetBySize() ? 10 : 14,
                                    color: ThemeManager.getInstance()
                                        .getTextColor(
                                            defaultColor: Colors.black),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Icon(Icons.arrow_drop_down,
                          size: 30,
                          color: ThemeManager.getInstance()
                              .getIconColor(defaultColor: Colors.black)))
                ],
              ),
              onTap: () {
                if (this.widget.calendarTypeEnum ==
                    CalendarTypeEnum.month) {
                  DialogManagement.getInstance().showMonthDialog(context,
                      title: getI18NKey().please_select_month, okCallback:
                          (PickerDateRange dateTimePickerDateRange) {
                    this.dateTimePickerDateRangeMonth =
                        dateTimePickerDateRange;
                    if (dateTimePickerDateRange != null) {}
                    this.widget.controller?.dateTimePicker =
                        dateTimePickerDateRange;
                    this.widget.onChange(dateTimePickerDateRange);
                    setState(() {});
                    DialogManagement.getInstance().hideDialog(context);
                  }, cancelCallback: () {
                    DialogManagement.getInstance().hideDialog(context);
                  });
                } else if (this.widget.calendarTypeEnum ==
                    CalendarTypeEnum.year) {
                  DialogManagement.getInstance()
                      .showYearDialog(context, title: "", okCallback:
                          (PickerDateRange dateTimePickerDateRange) {
                    this.widget.controller?.dateTimePicker =
                        dateTimePickerDateRange;
                    this.dateTimePickerDateRangeYear =
                        dateTimePickerDateRange;
                    if (dateTimePickerDateRange != null) {
                      dateTimePickerDateRangeYear = dateTimePickerDateRange;
                    }
                    this.widget.onChange(dateTimePickerDateRange);
                    setState(() {});
                    DialogManagement.getInstance().hideDialog(context);
                  }, cancelCallback: () {
                    DialogManagement.getInstance().hideDialog(context);
                  });
                } else if (this.widget.calendarTypeEnum ==
                    CalendarTypeEnum.day) {
                  DialogManagement.getInstance().showDayDialog(context,
                      title: getI18NKey().please_select_date, okCallback:
                          (PickerDateRange dateTimePickerDateRange) {
                    this.widget.controller?.dateTimePicker =
                        dateTimePickerDateRange;
                    if (dateTimePickerDateRange != null) {
                      dateTimePickerDateRangeDay = dateTimePickerDateRange;
                    }
                    this.widget.onChange(dateTimePickerDateRange);
                    setState(() {});
                    DialogManagement.getInstance().hideDialog(context);
                  }, cancelCallback: () {
                    DialogManagement.getInstance().hideDialog(context);
                  });
                } else if (this.widget.calendarTypeEnum ==
                    CalendarTypeEnum.custom) {
                  DialogManagement.getInstance().showDateRangePickerDialog(
                      context,
                      title: getI18NKey().please_select_daterange,
                      okCallback:
                          (PickerDateRange dateTimePickerDateRange) {
                    this.widget.controller?.dateTimePicker =
                        dateTimePickerDateRange;
                    if (dateTimePickerDateRange != null) {
                      dateTimePickerDateRangeCustom =
                          dateTimePickerDateRange;
                    }
                    this.widget.onChange(dateTimePickerDateRange);
                    setState(() {});
                    DialogManagement.getInstance().hideDialog(context);
                  }, cancelCallback: () {
                    DialogManagement.getInstance().hideDialog(context);
                  });
                }
                this.widget.onChange(null);
              },
            ));
  }
}
