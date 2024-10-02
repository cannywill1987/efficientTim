/// Dart import
import 'dart:math' as math;

import 'package:collection/collection.dart';

/// Packages import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:time_hello/com/timehello/page/TestPage/team.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../common/database/apis/MongoApisManager.dart';
import '../../models/FolderModel.dart';
import '../../models/MissionModel.dart';
import '../../util/TextUtil.dart';

/// Set team's data collection to data grid source.
class MissionTableDataGridSource extends DataGridSource {
  /// Creates the team data source class with required details.
  TextStyle _textStyle = const TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Colors.black87);
  bool isDatePickerVisible = false;

  /// Help to control the editable text in [TextField] widget.
  final TextEditingController _editingController = TextEditingController();

  // State variables to store column visibility
  bool isTitleVisible = true;
  bool isStartTimeVisible = true;
  bool isEndTimeVisible = true;
  bool isTagNamesVisible = true;
  bool isNoTomotoesFinishedVisible = true;
  bool isTotalTomotoesVisible = true;
  bool isPriorityStatusVisible = true;
  bool isTomatoDurationVisible = true;
  bool isFolderIdVisible = true;
  bool isIsDelayedVisible = true;
  bool isTimeModeVisible = true;
  bool isSubmissionVisible = true;
  bool isRepetiveTypeVisible = true;
  bool isRepeativeDateVisible = true;
  int length = 0;
  dynamic _newCellValue;

  MissionTableDataGridSource(
      {required this.listMissionModel,
      required this.isTitleVisible,
      required this.isStartTimeVisible,
      required this.isEndTimeVisible,
      required this.isTagNamesVisible,
      required this.isNoTomotoesFinishedVisible,
      required this.isTotalTomotoesVisible,
      required this.isPriorityStatusVisible,
      required this.isTomatoDurationVisible,
      required this.isFolderIdVisible,
      required this.isIsDelayedVisible,
      required this.isTimeModeVisible,
      required this.isSubmissionVisible,
      required this.isRepetiveTypeVisible,
      required this.isRepeativeDateVisible}) {
    _buildDataGridRows();
  }

  List<MissionModel> listMissionModel = <MissionModel>[];

  List<DataGridRow> _dataGridRows = <DataGridRow>[];

  FolderModel? getFolderModel(MissionModel? missionModel) {
    if (!TextUtil.isEmpty(missionModel?.folder_id)) {
      List<FolderModel> wqbFolderModelList = MongoApisManager.getInstance()
          .queryWhereEqual_folderModelWithFolderId(missionModel?.folder_id);
      if (wqbFolderModelList.length > 0) {
        return wqbFolderModelList[0];
      }
    }
    return null;
  }

  /// Building DataGridRows
  void _buildDataGridRows() {
    List<DataGridCell> dataGridCells = <DataGridCell>[];
    _dataGridRows =
        listMissionModel.map<DataGridRow>((MissionModel missionModel) {
      FolderModel? folderModel;
      if (folderModel != null) {
        folderModel = getFolderModel(missionModel!);
      }
      if (isTitleVisible) {
        length++;
        dataGridCells.add(DataGridCell<String>(
            columnName: 'title', value: missionModel?.title ?? ''));
      }
      if (isStartTimeVisible) {
        length++;
        dataGridCells.add(DataGridCell<String>(
            columnName: 'start_time',
            value: missionModel?.start_time.toString() ?? ''));
      }
      if (isEndTimeVisible) {
        length++;
        dataGridCells.add(DataGridCell<String>(
            columnName: 'end_time',
            value: missionModel?.end_time.toString() ?? ''));
      }
      if (isTagNamesVisible) {
        length++;
        dataGridCells.add(DataGridCell<String>(
            columnName: 'tagNames', value: missionModel?.tagNames ?? ''));
      }
      if (isNoTomotoesFinishedVisible) {
        length++;
        dataGridCells.add(DataGridCell<String>(
            columnName: 'no_tomotoes_finished',
            value: missionModel?.no_tomotoes_finished.toString() ?? ''));
      }
      if (isTotalTomotoesVisible) {
        length++;
        dataGridCells.add(DataGridCell<String>(
            columnName: 'total_tomotoes',
            value: missionModel?.total_tomotoes.toString() ?? ''));
      }
      if (isPriorityStatusVisible) {
        length++;
        dataGridCells.add(DataGridCell<String>(
            columnName: 'priorityStatus',
            value: missionModel?.priorityStatus.toString() ?? ''));
      }
      if (isTomatoDurationVisible) {
        length++;
        dataGridCells.add(DataGridCell<String>(
            columnName: 'tomato_duration',
            value: missionModel?.tomato_duration.toString() ?? ''));
      }
      if (isFolderIdVisible) {
        length++;
        dataGridCells.add(DataGridCell<String>(
            columnName: 'folder_id',
            value: folderModel?.title.toString() ?? ''));
      }
      if (isIsDelayedVisible) {
        length++;
        dataGridCells.add(DataGridCell<String>(
            columnName: 'isDelayed',
            value: missionModel?.isDelayed == false
                ? getI18NKey().no
                : getI18NKey().yes));
      }
      if (isTimeModeVisible) {
        length++;
        dataGridCells.add(DataGridCell<String>(
            columnName: 'time_mode',
            value: missionModel?.time_mode == 1
                ? getI18NKey().time_segment
                : getI18NKey().date));
      }
      if (isSubmissionVisible) {
        length++;
        dataGridCells
            .add(DataGridCell<String>(columnName: 'submission', value: "子任务"));
      }
      if (isRepetiveTypeVisible) {
        length++;
        dataGridCells.add(DataGridCell<String>(
            columnName: 'repetiveType', value: "repetiveType"));
      }
      if (isRepeativeDateVisible) {
        length++;
        dataGridCells.add(DataGridCell<String>(
            columnName: 'repeativeDate', value: "repeativeDate"));
      }
      print("111111111111111111111111111111111112");
      print("length MissionDataSource:" + dataGridCells.length.toString());
      print("111111111111111111111111111111111112");

      return DataGridRow(cells: dataGridCells);
      // return DataGridRow(cells: <DataGridCell>[
      //
      //   DataGridCell<String>(
      //       columnName: 'title', value: missionModel?.title ?? ''),
      //   DataGridCell<String>(
      //       columnName: 'start_time',
      //       value: missionModel?.start_time.toString() ?? ''),
      //   DataGridCell<String>(
      //       columnName: 'end_time',
      //       value: missionModel?.end_time.toString() ?? ''),
      //   DataGridCell<String>(
      //       columnName: 'tagNames', value: missionModel?.tagNames ?? ''),
      //   DataGridCell<String>(
      //       columnName: 'no_tomotoes_finished',
      //       value: missionModel?.no_tomotoes_finished.toString() ?? ''),
      //   DataGridCell<String>(
      //       columnName: 'total_tomotoes',
      //       value: missionModel?.total_tomotoes.toString() ?? ''),
      //   DataGridCell<String>(
      //       columnName: 'priorityStatus',
      //       value: missionModel?.priorityStatus.toString() ?? ''),
      //   DataGridCell<String>(
      //       columnName: 'tomato_duration',
      //       value: missionModel?.tomato_duration.toString() ?? ''),
      //   DataGridCell<String>(
      //       columnName: 'folder_id',
      //       value: folderModel?.title.toString() ?? ''),
      //   DataGridCell<String>(
      //       columnName: 'isDelayed',
      //       value: missionModel?.isDelayed == false ? getI18NKey().no : getI18NKey().yes),
      //   DataGridCell<String>(
      //       columnName: 'time_mode',
      //       value: missionModel?.time_mode == 1 ? getI18NKey().time_segment : getI18NKey().date),
      //   DataGridCell<String>(
      //       columnName: 'submission',
      //       value: "子任务"),
      //   DataGridCell<String>(
      //       columnName: 'repetiveType',
      //       value: "repetiveType"),
      //   DataGridCell<String>(
      //       columnName: 'repeativeDate',
      //       value: "repeativeDate"),
      //
      //   // DataGridCell<Image>(columnName: 'title', value: missionModel?.title ?? ''),
      //   // DataGridCell<int>(columnName: 'wins', value: missionModel.wins),
      //   // DataGridCell<int>(columnName: 'losses', value: missionModel.losses),
      //   // DataGridCell<double>(columnName: 'pct', value: missionModel.winPercentage),
      //   // DataGridCell<double>(columnName: 'gb', value: missionModel.gamesBehind),
      // ]);
    }).toList();
  }

  // Overrides
  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    _newCellValue = null;

    if (column.columnName == 'Shipped Date') {
      return _buildDateTimePicker(displayText, submitCell);
    } else if (column.columnName == 'Ship Country') {
      // return _buildDropDownWidget(displayText, submitCell, _shipCountry);
    }
    // else if (column.columnName == 'Ship City') {
    //   final String shipCountry = dataGridRow
    //       .getCells()
    //       .firstWhereOrNull((DataGridCell dataGridCell) =>
    //   dataGridCell.columnName == 'Ship Country')
    //       ?.value
    //       ?.toString() ??
    //       '';
    //
    //   return _buildDropDownWidget(displayText == '' ? null : displayText,
    //       submitCell, _shipCity[shipCountry]!);
    // } else {
    //   return _buildTextFieldWidget(displayText, column, submitCell);
    // }
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
      // Container(
      //   padding: const EdgeInsets.all(8.0),
      //   child: row.getCells()[0].value,
      // ),
      if (length > 0)
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[0].value.toString(),
            softWrap: true,
          ),
        ),
      if (length > 1)
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[1].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      if (length > 2)
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[2].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      if (length > 3)
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[3].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      if (length > 4)
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[4].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      if (length > 5)
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[5].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      if (length > 6)
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[6].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      if (length > 7)
        Container(
          // tomato_duration
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[7].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      if (length > 8)
        Container(
          // tomato_duration
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[8].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      if (length > 9)
        Container(
          // tomato_duration
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[9].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      if (length > 10)
        Container(
          // tomato_duration
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[10].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      if (length > 11)
        Container(
          // tomato_duration
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[11].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      if (length > 12)
        Container(
          // tomato_duration
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[12].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      if (length > 13)
        Container(
          // tomato_duration
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[13].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),

      // Container(
      //   padding: const EdgeInsets.all(8.0),
      //   alignment: Alignment.center,
      //   child: Text(
      //     row.getCells()[5].value.toString(),
      //     overflow: TextOverflow.ellipsis,
      //   ),
      // ),
    ]);
  }

  /// Building a [DatePicker] for datetime column.
  Widget _buildDateTimePicker(String displayText, CellSubmit submitCell) {
    final DateTime selectedDate = DateTime.parse(displayText);
    final DateTime firstDate = DateTime.parse('1999-01-01');
    final DateTime lastDate = DateTime.parse('2016-12-31');

    // To restrict the multiple time calls for the datepicker.
    isDatePickerVisible = false;
    displayText = DateFormat('MM/dd/yyyy').format(DateTime.parse(displayText));
    return Builder(
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: Focus(
            autofocus: true,
            focusNode: FocusNode()
              ..addListener(() async {
                if (!isDatePickerVisible) {
                  isDatePickerVisible = true;
                  await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: firstDate,
                      lastDate: lastDate,
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                  primary: ThemeManager.getInstance()
                                      .getDefautThemeColor())),
                          //     : ColorScheme.dark(
                          //   primary: ThemeManager.getInstance().getDefautThemeColor(),
                          // ),
                          child: child!,
                        );
                      }).then((DateTime? value) {
                    _newCellValue = value;

                    /// Call [CellSubmit] callback to fire the canSubmitCell and
                    /// onCellSubmit to commit the new value in single place.
                    submitCell();
                  });
                }
              }),
            child: Text(
              displayText,
              textAlign: TextAlign.right,
              style: _textStyle,
            ),
          ),
        );
      },
    );
  }

  //// Drop down color of items
  Color _dropDownColor() {
    return _textStyle.color == Colors.black
        ? const Color.fromRGBO(255, 255, 255, 1)
        : const Color.fromRGBO(33, 33, 33, 1);
  }

  /// Building a [DropDown] for combo box column.
  Widget _buildDropDownWidget(String? displayText, CellSubmit submitCell,
      List<String> dropDownMenuItems) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      child: DropdownButton<String>(
          dropdownColor: _dropDownColor(),
          value: displayText,
          autofocus: true,
          focusColor: Colors.transparent,
          underline: const SizedBox.shrink(),
          icon: const Icon(Icons.arrow_drop_down_sharp),
          isExpanded: true,
          style: _textStyle,
          onChanged: (String? value) {
            _newCellValue = value;

            /// Call [CellSubmit] callback to fire the canSubmitCell and
            /// onCellSubmit to commit the new value in single place.
            submitCell();
          },
          items:
              dropDownMenuItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList()),
    );
  }

// ------------- Populating the dealer info collection's. ----------------
// ------------------------------------------------------------------------
}
