// import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/components/CustomBackgroundWidget.dart';
import 'package:time_hello/com/timehello/models/TimelineMissionModel.dart';
import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;

///Pdf import

///Local imports

/// DataGrid import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Core import
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../r.dart';
import '../config/Params.dart';
import '../models/MissionModel.dart';
import '../page/TestPage/MissionTableDataGridSource.dart';
import '../util/SharePreferenceUtil.dart';
import '../util/helper/save_file_mobile.dart';
import 'MissionTabbleOrderPopupListWidget.dart';

class MissionTableContainerWidget extends StatefulWidget {
  List<MissionModel> listMissionModels;
  Function(MissionModel) onClickMissionSetting;

  MissionTableContainerWidget(
      {Key? key,
      required this.listMissionModels,
      required this.onClickMissionSetting})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MissionTableContainerWidgetState(
        listMissionModels: listMissionModels);
  }
}

class MissionTableContainerWidgetState
    extends State<MissionTableContainerWidget> {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late MissionTableDataGridSource missionTableDataGridSource;
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  final GlobalKey<MissionTabbleOrderPopupListWidgetState>
      _missionTabbleOrderPopupListWidgetStateGlobalkey =
      GlobalKey<MissionTabbleOrderPopupListWidgetState>();

  /// DataGridSource required for SfDataGrid to obtain the row data.
  // late EmployeeDataGridSource _employeeDataGridSource;
  late GridLinesVisibility _gridLineVisibility = GridLinesVisibility.both;
  ColumnResizeMode columnResizeMode = ColumnResizeMode.onResize;
  EditingGestureType _editingGestureType = EditingGestureType.tap;
  List<Map<String, dynamic>> columnsOrders = [
    {'name': getI18NKey().title, 'key': 'title', 'visible': true},
    {'name': getI18NKey().isFinished, 'key': 'isFinished', 'visible': true},
    {'name': getI18NKey().start_time, 'key': 'start_time', 'visible': true},
    {'name': getI18NKey().end_time, 'key': 'end_time', 'visible': true},
    {'name': getI18NKey().tagNames, 'key': 'tagNames', 'visible': true},
    {
      'name': getI18NKey().no_tomotoes_finished,
      'key': 'no_tomotoes_finished',
      'visible': true
    },
    {
      'name': getI18NKey().total_tomotoes,
      'key': 'total_tomotoes',
      'visible': true
    },
    {
      'name': getI18NKey().priorityStatus,
      'key': 'priorityStatus',
      'visible': true
    },
    {
      'name': getI18NKey().tomato_duration,
      'key': 'tomato_duration',
      'visible': true
    },
    {'name': getI18NKey().folder_name, 'key': 'folder_id', 'visible': true},
    {'name': getI18NKey().isDelayed, 'key': 'isDelayed', 'visible': true},
    {'name': getI18NKey().time_mode, 'key': 'time_mode', 'visible': true},
    {'name': getI18NKey().submisssion, 'key': 'submission', 'visible': true},
    {'name': getI18NKey().repetiveType, 'key': 'repetiveType', 'visible': true},
    {
      'name': getI18NKey().repeat_period,
      'key': 'repeativeDate',
      'visible': true
    },
  ];
  bool _isTitleVisible = true;
  bool _isStartTimeVisible = true;
  bool _isEndTimeVisible = true;
  bool _isTagNamesVisible = true;
  bool _isNoTomotoesFinishedVisible = true;
  bool _isTotalTomotoesVisible = true;
  bool _isPriorityStatusVisible = true;
  bool _isTomatoDurationVisible = true;
  bool _isFolderIdVisible = true;
  bool _isIsDelayedVisible = true;
  bool _isTimeModeVisible = true;
  bool _isSubmissionVisible = true;
  bool _isRepetiveTypeVisible = true;
  bool _isRepeativeDateVisible = true;
  bool _isFinishedDateVisible = true;

  // State variables to store the dynamic width of each column
  double _titleColumnWidth = 150.0;
  double _startTimeColumnWidth = 150.0;
  double _endTimeColumnWidth = 150.0;
  double _tagNamesColumnWidth = 150.0;
  double _noTomatoesColumnWidth = 150.0;
  double _totalTomatoesColumnWidth = 150.0;
  double _priorityStatusColumnWidth = 150.0;
  double _tomatoDurationColumnWidth = 150.0;
  double _folderIdColumnWidth = 150.0;
  double _isDelayedColumnWidth = 150.0;
  double _timeModeColumnWidth = 150.0;
  double _submissionColumnWidth = 150.0;
  double _repetiveTypeColumnWidth = 150.0;
  double _repeativeDateColumnWidth = 150.0;
  double _isFinishedColumnWidth = 150.0;
  final DataGridController _dataGridController = DataGridController();

  MissionTableContainerWidgetState(
      {required List<MissionModel> listMissionModels}) {
    // initDataSource(listMissionModels ?? []);
  }

  void initDataSource(List<MissionModel> listMissionModels) {
    missionTableDataGridSource = MissionTableDataGridSource(
        listMissionModel: listMissionModels,
        isTitleVisible: _isTitleVisible,
        isStartTimeVisible: _isStartTimeVisible,
        isEndTimeVisible: _isEndTimeVisible,
        isTagNamesVisible: _isTagNamesVisible,
        isNoTomotoesFinishedVisible: _isNoTomotoesFinishedVisible,
        isTotalTomotoesVisible: _isTotalTomotoesVisible,
        isPriorityStatusVisible: _isPriorityStatusVisible,
        isTomatoDurationVisible: _isTomatoDurationVisible,
        isFolderIdVisible: _isFolderIdVisible,
        isIsDelayedVisible: _isIsDelayedVisible,
        isTimeModeVisible: _isTimeModeVisible,
        isSubmissionVisible: _isSubmissionVisible,
        isRepetiveTypeVisible: _isRepetiveTypeVisible,
        isRepeativeDateVisible: _isRepeativeDateVisible,
        isFinishedDateVisible: _isFinishedDateVisible,
        columnsOrders: columnsOrders);
  }

  setUpColumnOrderVisibility(String key, bool isVisible) {
    columnsOrders.forEach((element) {
      if (element['key'] == key) {
        element['visible'] = isVisible;
      }
    });
  }

  Future<void> _loadColumnVisibility() async {
    _isTitleVisible = SharePreferenceUtil.getSyncInstance().getBool(
        key: ShareprefrenceKeys.missionColumnVisible + "title",
        defaultVal: true);
    setUpColumnOrderVisibility('title', _isTitleVisible);
    _isStartTimeVisible = SharePreferenceUtil.getSyncInstance().getBool(
        key: ShareprefrenceKeys.missionColumnVisible + "start_time",
        defaultVal: true);
    setUpColumnOrderVisibility('start_time', _isStartTimeVisible);
    _isEndTimeVisible = SharePreferenceUtil.getSyncInstance().getBool(
        key: ShareprefrenceKeys.missionColumnVisible + "end_time",
        defaultVal: true);
    setUpColumnOrderVisibility('end_time', _isEndTimeVisible);
    _isTagNamesVisible = SharePreferenceUtil.getSyncInstance().getBool(
        key: ShareprefrenceKeys.missionColumnVisible + "tagNames",
        defaultVal: true);
    setUpColumnOrderVisibility('tagNames', _isTagNamesVisible);
    _isNoTomotoesFinishedVisible = SharePreferenceUtil.getSyncInstance()
        .getBool(
            key: ShareprefrenceKeys.missionColumnVisible +
                "no_tomotoes_finished",
            defaultVal: true);
    setUpColumnOrderVisibility(
        'no_tomotoes_finished', _isNoTomotoesFinishedVisible);
    _isTotalTomotoesVisible = SharePreferenceUtil.getSyncInstance().getBool(
        key: ShareprefrenceKeys.missionColumnVisible + "total_tomotoes",
        defaultVal: true);
    setUpColumnOrderVisibility('total_tomotoes', _isTotalTomotoesVisible);
    _isPriorityStatusVisible = SharePreferenceUtil.getSyncInstance().getBool(
        key: ShareprefrenceKeys.missionColumnVisible + "priorityStatus",
        defaultVal: true);
    setUpColumnOrderVisibility('priorityStatus', _isPriorityStatusVisible);
    _isTomatoDurationVisible = SharePreferenceUtil.getSyncInstance().getBool(
        key: ShareprefrenceKeys.missionColumnVisible + "tomato_duration",
        defaultVal: true);
    setUpColumnOrderVisibility('tomato_duration', _isTomatoDurationVisible);
    _isFolderIdVisible = SharePreferenceUtil.getSyncInstance().getBool(
        key: ShareprefrenceKeys.missionColumnVisible + "folder_id",
        defaultVal: true);
    setUpColumnOrderVisibility('folder_id', _isFolderIdVisible);
    _isIsDelayedVisible = SharePreferenceUtil.getSyncInstance().getBool(
        key: ShareprefrenceKeys.missionColumnVisible + "isDelayed",
        defaultVal: true);
    setUpColumnOrderVisibility('isDelayed', _isIsDelayedVisible);
    _isTimeModeVisible = SharePreferenceUtil.getSyncInstance().getBool(
        key: ShareprefrenceKeys.missionColumnVisible + "time_mode",
        defaultVal: true);
    setUpColumnOrderVisibility('time_mode', _isTimeModeVisible);
    _isSubmissionVisible = SharePreferenceUtil.getSyncInstance().getBool(
        key: ShareprefrenceKeys.missionColumnVisible + "submission",
        defaultVal: true);
    setUpColumnOrderVisibility('submission', _isSubmissionVisible);
    _isRepetiveTypeVisible = SharePreferenceUtil.getSyncInstance().getBool(
        key: ShareprefrenceKeys.missionColumnVisible + "repetiveType",
        defaultVal: true);
    setUpColumnOrderVisibility('repetiveType', _isRepetiveTypeVisible);
    _isRepeativeDateVisible = SharePreferenceUtil.getSyncInstance().getBool(
        key: ShareprefrenceKeys.missionColumnVisible + "repeativeDate",
        defaultVal: true);
    setUpColumnOrderVisibility('repeativeDate', _isRepeativeDateVisible);
    _isFinishedDateVisible = SharePreferenceUtil.getSyncInstance().getBool(
        key: ShareprefrenceKeys.missionColumnVisible + "isFinished",
        defaultVal: true);
    setUpColumnOrderVisibility('isFinished', _isFinishedDateVisible);
  }

  _loadColumnWidths() {
    setState(() {
      _titleColumnWidth = SharePreferenceUtil.getSyncInstance().getDouble(
          key: ShareprefrenceKeys.missionColumnWidth + "title",
          defaultVal: 150);
      print('saveColumnWidth: title, $_titleColumnWidth');
      _startTimeColumnWidth = SharePreferenceUtil.getSyncInstance().getDouble(
          key: ShareprefrenceKeys.missionColumnWidth + "start_time",
          defaultVal: 150);
      _endTimeColumnWidth = SharePreferenceUtil.getSyncInstance().getDouble(
          key: ShareprefrenceKeys.missionColumnWidth + "end_time",
          defaultVal: 150);
      _tagNamesColumnWidth = SharePreferenceUtil.getSyncInstance().getDouble(
          key: ShareprefrenceKeys.missionColumnWidth + "tagNames",
          defaultVal: 150);
      _noTomatoesColumnWidth = SharePreferenceUtil.getSyncInstance().getDouble(
          key: ShareprefrenceKeys.missionColumnWidth + "no_tomotoes_finished",
          defaultVal: 150);
      _totalTomatoesColumnWidth = SharePreferenceUtil.getSyncInstance()
          .getDouble(
              key: ShareprefrenceKeys.missionColumnWidth + "total_tomotoes",
              defaultVal: 150);
      _priorityStatusColumnWidth = SharePreferenceUtil.getSyncInstance()
          .getDouble(
              key: ShareprefrenceKeys.missionColumnWidth + "priorityStatus",
              defaultVal: 150);
      _tomatoDurationColumnWidth = SharePreferenceUtil.getSyncInstance()
          .getDouble(
              key: ShareprefrenceKeys.missionColumnWidth + "tomato_duration",
              defaultVal: 150);
      _folderIdColumnWidth = SharePreferenceUtil.getSyncInstance().getDouble(
          key: ShareprefrenceKeys.missionColumnWidth + "folder_id",
          defaultVal: 150);
      _isDelayedColumnWidth = SharePreferenceUtil.getSyncInstance().getDouble(
          key: ShareprefrenceKeys.missionColumnWidth + "isDelayed",
          defaultVal: 150);
      _timeModeColumnWidth = SharePreferenceUtil.getSyncInstance().getDouble(
          key: ShareprefrenceKeys.missionColumnWidth + "time_mode",
          defaultVal: 150);
      _submissionColumnWidth = SharePreferenceUtil.getSyncInstance().getDouble(
          key: ShareprefrenceKeys.missionColumnWidth + "submission",
          defaultVal: 150);
      _repetiveTypeColumnWidth = SharePreferenceUtil.getSyncInstance()
          .getDouble(
              key: ShareprefrenceKeys.missionColumnWidth + "repetiveType",
              defaultVal: 150);
      _repeativeDateColumnWidth = SharePreferenceUtil.getSyncInstance()
          .getDouble(
              key: ShareprefrenceKeys.missionColumnWidth + "repeativeDate",
              defaultVal: 150);
      _isFinishedColumnWidth = SharePreferenceUtil.getSyncInstance().getDouble(
          key: ShareprefrenceKeys.missionColumnWidth + "isFinished",
          defaultVal: 150);
    });
  }

  // late bool _isWebOrDesktop;

  // SfDataGrid _buildDataGridForMobile() {
  //   return SfDataGrid(
  //     allowSorting: true,
  //     allowFiltering: true,
  //     allowColumnsResizing: true,
  //     source: missionTableDataGridSource,
  //     gridLinesVisibility: GridLinesVisibility.both,
  //     // 设置线
  //     columnWidthMode: ColumnWidthMode.fill,
  //     rowHeight: 50,
  //     columns: <GridColumn>[
  //       // GridColumn(
  //       //   columnName: 'image',
  //       //   minimumWidth: 15.0,
  //       //   label:  SizedBox.shrink(),
  //       // ),
  //       GridColumn(
  //         columnName: 'title',
  //         minimumWidth: 15.0,
  //         // width: !_isWebOrDesktop ? 90 : double.nan,
  //         label: Container(
  //           alignment: Alignment.centerLeft,
  //           child:  Text('title'),
  //         ),
  //       ),
  //       GridColumn(
  //         columnName: 'start_time',
  //         minimumWidth: 15.0,
  //         label:  Center(
  //           child: Text('start_time'),
  //         ),
  //       ),
  //       GridColumn(
  //           columnName: 'end_time',
  //           minimumWidth: 15.0,
  //           label:  Center(
  //             child: Text('end_time'),
  //           )),
  //       GridColumn(
  //           minimumWidth: 15.0,
  //           columnName: 'tagNames',
  //           label:  Center(child: Text('tagNames'))),
  //       GridColumn(
  //           minimumWidth: 15.0,
  //           columnName: 'no_tomotoes_finished',
  //           label:  Center(child: Text('no_tomotoes_finished'))),
  //
  //       // GridColumn(
  //       //   columnName: 'gb',
  //       //   minimumWidth: 15.0,
  //       //   label:  Center(child: Text('GB')),
  //       // ),
  //     ],
  //   );
  // }

  // Widget buildLocationWidget(String location) {
  //   return Row(
  //     children: <Widget>[
  //       Image.asset('images/location.png'),
  //       Text(
  //         ' ' + location,
  //       )
  //     ],
  //   );
  // }

  // Widget buildTrustWidget(String trust) {
  //   return Row(children: <Widget>[
  //     Row(
  //       children: <Widget>[Image.asset('images/Perfect.png'), Text(trust)],
  //     )
  //   ]);
  // }
  Future<void> _saveColumnWidth(String columnName, double width) async {
    print('saveColumnWidth: $columnName, $width');
    SharePreferenceUtil.getSyncInstance().setDouble(
        key: ShareprefrenceKeys.missionColumnWidth + columnName, value: width);
  }

  /// DataGridController to do the programmatical selection.
  DataGridController _buildDataGridController() {
    // _dataGridController.selectedRows
    //     .add(_checkboxDataGridSource.dataGridRows[2]);
    // _dataGridController.selectedRows
    //     .add(_checkboxDataGridSource.dataGridRows[4]);
    // _dataGridController.selectedRows
    //     .add(_checkboxDataGridSource.dataGridRows[6]);
    return _dataGridController;
  }

  SfDataGrid _buildDataGridForWeb() {
    return SfDataGrid(
      key: _key,
      onCellTap: (args) {
        print("onCellTap");
        print(args.rowColumnIndex.rowIndex);
        MissionModel missionModel =
            this.widget.listMissionModels[args.rowColumnIndex.rowIndex - 1];
        this.widget.onClickMissionSetting(missionModel);
      },
      controller: _buildDataGridController(),
      allowEditing: true,
      // selectionMode: SelectionMode.multiple,
      navigationMode: GridNavigationMode.cell,
      selectionMode: SelectionMode.single,
      editingGestureType: EditingGestureType.tap,
      // frozenRowsCount: 1,
      frozenColumnsCount: 1,
      // allowEditing: true,
      // editingGestureType: _editingGestureType,
      // navigationMode: GridNavigationMode.cell,

      columnWidthMode: Utility.isHandsetBySize()
          ? ColumnWidthMode.fill
          : ColumnWidthMode.none,

      allowColumnsResizing: true,
      allowSorting: true,
      allowFiltering: true,
      columnResizeMode: columnResizeMode,
      source: missionTableDataGridSource,
      onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
        setState(() {
          // Dynamically set the width for each column and save to shared preferences
          switch (args.column.columnName) {
            case 'title':
              _titleColumnWidth = args.width;
              _saveColumnWidth('title', args.width);
              break;
            case 'start_time':
              _startTimeColumnWidth = args.width;
              _saveColumnWidth('start_time', args.width);
              break;
            case 'end_time':
              _endTimeColumnWidth = args.width;
              _saveColumnWidth('end_time', args.width);
              break;
            case 'tagNames':
              _tagNamesColumnWidth = args.width;
              _saveColumnWidth('tagNames', args.width);
              break;
            case 'no_tomotoes_finished':
              _noTomatoesColumnWidth = args.width;
              _saveColumnWidth('no_tomotoes_finished', args.width);
              break;
            case 'total_tomotoes':
              _totalTomatoesColumnWidth = args.width;
              _saveColumnWidth('total_tomotoes', args.width);
              break;
            case 'priorityStatus':
              _priorityStatusColumnWidth = args.width;
              _saveColumnWidth('priorityStatus', args.width);
              break;
            case 'tomato_duration':
              _tomatoDurationColumnWidth = args.width;
              _saveColumnWidth('tomato_duration', args.width);
              break;
            case 'folder_id':
              _folderIdColumnWidth = args.width;
              _saveColumnWidth('folder_id', args.width);
              break;
            case 'isDelayed':
              _isDelayedColumnWidth = args.width;
              _saveColumnWidth('isDelayed', args.width);
              break;
            case 'time_mode':
              _timeModeColumnWidth = args.width;
              _saveColumnWidth('time_mode', args.width);
              break;
            case 'submission':
              _submissionColumnWidth = args.width;
              _saveColumnWidth('submission', args.width);
              break;
            case 'repetiveType':
              _repetiveTypeColumnWidth = args.width;
              _saveColumnWidth('repetiveType', args.width);
              break;
            case 'repeativeDate':
              _repeativeDateColumnWidth = args.width;
              _saveColumnWidth('repeativeDate', args.width);
              break;
            case 'isFinished':
              _isFinishedColumnWidth = args.width;
              _saveColumnWidth('isFinished', args.width);
              break;
          }
        });
        return true;
      },
      gridLinesVisibility: GridLinesVisibility.both,
      // 设置线
      columns: getColumns(),
    );
  }

  List<GridColumn> getColumns() {
    List<GridColumn> list = <GridColumn>[];
    columnsOrders.forEach((elem) {
      if (elem['key'] == 'title' && _isTitleVisible) {
        list.add(GridColumn(
            minimumWidth: 15.0,
            width: _titleColumnWidth,
            columnName: 'title',
            label: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8.0),
              child: Text(
                getI18NKey().title,
                overflow: TextOverflow.ellipsis,
              ),
            )));
      } else if (elem['key'] == 'isFinished' && _isFinishedDateVisible) {
        list.add(GridColumn(
            minimumWidth: 15.0,
            width: _isFinishedColumnWidth,
            columnName: 'isFinished',
            label: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8.0),
              child: Text(
                getI18NKey().isFinished,
                overflow: TextOverflow.ellipsis,
              ),
            )));
      } else if (elem['key'] == 'start_time' && _isStartTimeVisible) {
        list.add(GridColumn(
          columnName: 'start_time',
          width: _startTimeColumnWidth,
          minimumWidth: 15.0,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(8.0),
            child: Text(
              getI18NKey().start_time,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
      } else if (elem['key'] == 'end_time' && _isEndTimeVisible) {
        list.add(GridColumn(
          columnName: 'end_time',
          width: _endTimeColumnWidth,
          minimumWidth: 15.0,
          label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              getI18NKey().end_time,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
      } else if (elem['key'] == 'tagNames' && _isTagNamesVisible) {
        list.add(GridColumn(
          columnName: 'tagNames',
          width: _tagNamesColumnWidth,
          minimumWidth: 15.0,
          label: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(
              getI18NKey().tagNames,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
      } else if (elem['key'] == 'no_tomotoes_finished' &&
          _isNoTomotoesFinishedVisible) {
        list.add(GridColumn(
          columnName: 'no_tomotoes_finished',
          width: _noTomatoesColumnWidth,
          minimumWidth: 15.0,
          label: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(
              getI18NKey().no_tomotoes_finished,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
      } else if (elem['key'] == 'total_tomotoes' && _isTotalTomotoesVisible) {
        list.add(GridColumn(
          columnName: 'total_tomotoes',
          width: _totalTomatoesColumnWidth,
          minimumWidth: 15.0,
          label: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(
              getI18NKey().total_tomotoes,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
      } else if (elem['key'] == 'priorityStatus' && _isPriorityStatusVisible) {
        list.add(GridColumn(
          columnName: 'priorityStatus',
          width: _priorityStatusColumnWidth,
          minimumWidth: 15.0,
          label: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(
              getI18NKey().priorityStatus,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
      } else if (elem['key'] == 'tomato_duration' && _isTomatoDurationVisible) {
        list.add(GridColumn(
          columnName: 'tomato_duration',
          width: _tomatoDurationColumnWidth,
          minimumWidth: 15.0,
          label: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(
              getI18NKey().tomato_duration,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
      } else if (elem['key'] == 'folder_id' && _isFolderIdVisible) {
        list.add(GridColumn(
          columnName: 'folder_id',
          width: _folderIdColumnWidth,
          minimumWidth: 15.0,
          label: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(
              getI18NKey().folder_name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
      } else if (elem['key'] == 'isDelayed' && _isIsDelayedVisible) {
        list.add(GridColumn(
          columnName: 'isDelayed',
          width: _isDelayedColumnWidth,
          minimumWidth: 15.0,
          label: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(
              getI18NKey().isDelayed,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
      } else if (elem['key'] == 'time_mode' && _isTimeModeVisible) {
        list.add(GridColumn(
          columnName: 'time_mode',
          width: _timeModeColumnWidth,
          minimumWidth: 15.0,
          label: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(
              getI18NKey().time_mode,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
      } else if (elem['key'] == 'submission' && _isSubmissionVisible) {
        list.add(GridColumn(
          columnName: 'submission',
          width: _submissionColumnWidth,
          minimumWidth: 15.0,
          label: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(
              getI18NKey().submisssion,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
      } else if (elem['key'] == 'repetiveType' && _isRepetiveTypeVisible) {
        list.add(GridColumn(
          columnName: 'repetiveType',
          width: _repetiveTypeColumnWidth,
          minimumWidth: 15.0,
          label: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(
              getI18NKey().repetiveType,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
      } else if (elem['key'] == 'repeativeDate' && _isRepeativeDateVisible) {
        list.add(GridColumn(
          columnName: 'repeativeDate',
          width: _repeativeDateColumnWidth,
          minimumWidth: 15.0,
          label: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(
              getI18NKey().repetiveWeekDay,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
      }
    });
    // List<GridColumn> list = <GridColumn>[
    //   if (_isTitleVisible)
    //     GridColumn(
    //         minimumWidth: 15.0,
    //         width: _titleColumnWidth,
    //         columnName: 'title',
    //         label: Container(
    //           alignment: Alignment.center,
    //           padding: EdgeInsets.all(8.0),
    //           child: Text(
    //             getI18NKey().title,
    //             overflow: TextOverflow.ellipsis,
    //           ),
    //         )),
    //   if (_isFinishedDateVisible)
    //     GridColumn(
    //         minimumWidth: 15.0,
    //         width: _isFinishedColumnWidth,
    //         columnName: 'isFinished',
    //         label: Container(
    //           alignment: Alignment.center,
    //           padding: EdgeInsets.all(8.0),
    //           child: Text(
    //             getI18NKey().isFinished,
    //             overflow: TextOverflow.ellipsis,
    //           ),
    //         )),
    //   if (_isStartTimeVisible)
    //     GridColumn(
    //       columnName: 'start_time',
    //       width: _startTimeColumnWidth,
    //       minimumWidth: 15.0,
    //       label: Container(
    //         alignment: Alignment.centerLeft,
    //         padding: EdgeInsets.all(8.0),
    //         child: Text(
    //           getI18NKey().start_time,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ),
    //   if (_isEndTimeVisible)
    //     GridColumn(
    //       columnName: 'end_time',
    //       width: _endTimeColumnWidth,
    //       minimumWidth: 15.0,
    //       label: Container(
    //         padding: EdgeInsets.all(8.0),
    //         alignment: Alignment.centerLeft,
    //         child: Text(
    //           getI18NKey().end_time,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ),
    //   if (_isTagNamesVisible)
    //     GridColumn(
    //       columnName: 'tagNames',
    //       width: _tagNamesColumnWidth,
    //       minimumWidth: 15.0,
    //       label: Container(
    //         alignment: Alignment.center,
    //         padding: EdgeInsets.all(8.0),
    //         child: Text(
    //           getI18NKey().tagNames,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ),
    //   if (_isNoTomotoesFinishedVisible)
    //     GridColumn(
    //       columnName: 'no_tomotoes_finished',
    //       width: _noTomatoesColumnWidth,
    //       minimumWidth: 15.0,
    //       label: Container(
    //         alignment: Alignment.center,
    //         padding: EdgeInsets.all(8.0),
    //         child: Text(
    //           getI18NKey().no_tomotoes_finished,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ),
    //   if (_isTotalTomotoesVisible)
    //     GridColumn(
    //       columnName: 'total_tomotoes',
    //       width: _totalTomatoesColumnWidth,
    //       minimumWidth: 15.0,
    //       label: Container(
    //         alignment: Alignment.center,
    //         padding: EdgeInsets.all(8.0),
    //         child: Text(
    //           getI18NKey().total_tomotoes,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ),
    //   if (_isPriorityStatusVisible)
    //     GridColumn(
    //       columnName: 'priorityStatus',
    //       width: _priorityStatusColumnWidth,
    //       minimumWidth: 15.0,
    //       label: Container(
    //         alignment: Alignment.center,
    //         padding: EdgeInsets.all(8.0),
    //         child: Text(
    //           getI18NKey().priorityStatus,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ),
    //   if (_isTomatoDurationVisible)
    //     GridColumn(
    //       columnName: 'tomato_duration',
    //       width: _tomatoDurationColumnWidth,
    //       minimumWidth: 15.0,
    //       label: Container(
    //         alignment: Alignment.center,
    //         padding: EdgeInsets.all(8.0),
    //         child: Text(
    //           getI18NKey().tomato_duration,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ),
    //   if (_isFolderIdVisible)
    //     GridColumn(
    //       columnName: 'folder_id',
    //       width: _folderIdColumnWidth,
    //       minimumWidth: 15.0,
    //       label: Container(
    //         alignment: Alignment.center,
    //         padding: EdgeInsets.all(8.0),
    //         child: Text(
    //           getI18NKey().folder_name,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ),
    //   if (_isIsDelayedVisible)
    //     GridColumn(
    //       columnName: 'isDelayed',
    //       width: _isDelayedColumnWidth,
    //       minimumWidth: 15.0,
    //       label: Container(
    //         alignment: Alignment.center,
    //         padding: EdgeInsets.all(8.0),
    //         child: Text(
    //           getI18NKey().isDelayed,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ),
    //   if (_isTimeModeVisible)
    //     GridColumn(
    //       columnName: 'time_mode',
    //       width: _timeModeColumnWidth,
    //       minimumWidth: 15.0,
    //       label: Container(
    //         alignment: Alignment.center,
    //         padding: EdgeInsets.all(8.0),
    //         child: Text(
    //           getI18NKey().time_mode,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ),
    //   if (_isSubmissionVisible)
    //     GridColumn(
    //       columnName: 'submission',
    //       width: _submissionColumnWidth,
    //       minimumWidth: 15.0,
    //       label: Container(
    //         alignment: Alignment.center,
    //         padding: EdgeInsets.all(8.0),
    //         child: Text(
    //           getI18NKey().submisssion,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ),
    //   if (_isRepetiveTypeVisible)
    //     GridColumn(
    //       columnName: 'repetiveType',
    //       width: _repetiveTypeColumnWidth,
    //       minimumWidth: 15.0,
    //       label: Container(
    //         alignment: Alignment.center,
    //         padding: EdgeInsets.all(8.0),
    //         child: Text(
    //           getI18NKey().repetiveType,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ),
    //   if (_isRepeativeDateVisible)
    //     GridColumn(
    //       columnName: 'repeativeDate',
    //       width: _repeativeDateColumnWidth,
    //       minimumWidth: 15.0,
    //       label: Container(
    //         alignment: Alignment.center,
    //         padding: EdgeInsets.all(8.0),
    //         child: Text(
    //           getI18NKey().repetiveWeekDay,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ),
    // ];
    // print("111111111111111111111111111111111113");
    // print("length MissionDataSource:" + list.length.toString());
    // print("111111111111111111111111111111111113");
    return list;
  }

  @override
  void initState() {
    super.initState();
    // _loadColumnVisibility();

    _loadColumnWidths(); // 动态获取保存的宽度并初始化
    setUpDatasAndVisibility();

    // _isWebOrDesktop = model.isWeb || model.isDesktop;
    // _teamDataGridSource = EmployeeDataGridSource();
  }

  // 加载列顺序
  Future<void> _loadColumnOrder() async {
    List<String> savedOrder = SharePreferenceUtil.getSyncInstance()
        .getStringList(
            key: ShareprefrenceKeys.missionColumnOrder, defaultVal: []);

    if (savedOrder.isNotEmpty) {
      setState(() {
        columnsOrders.sort((a, b) {
          // 根据保存的顺序进行列的排序
          return savedOrder
              .indexOf(a['key'])
              .compareTo(savedOrder.indexOf(b['key']));
        });
      });
    }
    print("object");
  }

  void setUpDatasAndVisibility() {
    _loadColumnOrder(); // 动态获取保存的列顺序并初始化
    _loadColumnVisibility(); // 动态获取保存的列显示状态并初始化
    initDataSource(this.widget.listMissionModels);
    setState(() {});
  }

  Widget _buildExportingButton(String buttonName, String imagePath,
      {required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 35.0,
        decoration: BoxDecoration(
            color: ThemeManager.getInstance().isDark()
                ? ThemeManager.getInstance().getCardBackgroundColor()
                : ThemeManager.getInstance().getDefautThemeColor(),
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
                color: ThemeManager.getInstance().getDefautThemeColor(), width: 1)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Row(
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            //   child: ImageIcon(
            //     AssetImage(imagePath),
            //     size: 30,
            //     color: Colors.white,
            //   ),
            // ),
            Text(buttonName, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Future<void> _saveColumnVisibility(String columnName, bool isVisible) async {
    SharePreferenceUtil.getSyncInstance().setBool(
        key: ShareprefrenceKeys.missionColumnVisible + columnName,
        val: isVisible);
  }

  BoxDecoration _drawBorder() {
    final BorderSide borderSide =
        BorderSide(color: Color.fromRGBO(0, 0, 0, 0.26));

    // Restricts the right side border when Datagrid has gridlinesVisibility
    // to both and vertical to maintains the border thickness.
    switch (_gridLineVisibility) {
      case GridLinesVisibility.none:
      case GridLinesVisibility.horizontal:
        return BoxDecoration(
            border: Border(
                left: borderSide, right: borderSide, bottom: borderSide));
      case GridLinesVisibility.both:
      case GridLinesVisibility.vertical:
        return BoxDecoration(
            border: Border(left: borderSide, bottom: borderSide));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildExportingButtons(),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return MissionTabbleOrderPopupListWidget(
                        key: _missionTabbleOrderPopupListWidgetStateGlobalkey,
                        listMissionModels: this.widget.listMissionModels,
                        // onClickMissionSetting: (MissionModel) {},
                        onClickMissionReorder: (List<String> listNames) {
                          setUpDatasAndVisibility();
                          // initDataSource(this.widget.listMissionModels);
                        },
                        columnsOrders: this.columnsOrders,
                        onClickMissionSetting: (result, isVisible) {
                          setState(() {
                            switch (result) {
                              case 'title':
                                _isTitleVisible = isVisible;
                                _saveColumnVisibility('title', _isTitleVisible);
                                break;
                              case 'isFinished':
                                _isFinishedDateVisible = isVisible;
                                _saveColumnVisibility(
                                    'isFinished', _isFinishedDateVisible);
                                break;
                              case 'start_time':
                                _isStartTimeVisible = isVisible;
                                _saveColumnVisibility(
                                    'start_time', _isStartTimeVisible);
                                break;
                              case 'end_time':
                                _isEndTimeVisible = isVisible;
                                _saveColumnVisibility(
                                    'end_time', _isEndTimeVisible);
                                break;
                              case 'tagNames':
                                _isTagNamesVisible = isVisible;
                                _saveColumnVisibility(
                                    'tagNames', _isTagNamesVisible);
                                break;
                              case 'no_tomotoes_finished':
                                _isNoTomotoesFinishedVisible = isVisible;
                                _saveColumnVisibility('no_tomotoes_finished',
                                    _isNoTomotoesFinishedVisible);
                                break;
                              case 'total_tomotoes':
                                _isTotalTomotoesVisible = isVisible;
                                _saveColumnVisibility(
                                    'total_tomotoes', _isTotalTomotoesVisible);
                                break;
                              case 'priorityStatus':
                                _isPriorityStatusVisible = isVisible;
                                _saveColumnVisibility(
                                    'priorityStatus', _isPriorityStatusVisible);
                                break;
                              case 'tomato_duration':
                                _isTomatoDurationVisible = isVisible;
                                _saveColumnVisibility('tomato_duration',
                                    _isTomatoDurationVisible);
                                break;
                              case 'folder_id':
                                _isFolderIdVisible = isVisible;
                                _saveColumnVisibility(
                                    'folder_id', _isFolderIdVisible);
                                break;
                              case 'isDelayed':
                                _isIsDelayedVisible = isVisible;
                                _saveColumnVisibility(
                                    'isDelayed', _isIsDelayedVisible);
                                break;
                              case 'time_mode':
                                _isTimeModeVisible = isVisible;
                                _saveColumnVisibility(
                                    'time_mode', _isTimeModeVisible);
                                break;
                              case 'submission':
                                _isSubmissionVisible = isVisible;
                                _saveColumnVisibility(
                                    'submission', _isSubmissionVisible);
                                break;
                              case 'repetiveType':
                                _isRepetiveTypeVisible = isVisible;
                                _saveColumnVisibility(
                                    'repetiveType', _isRepetiveTypeVisible);
                                break;
                              case 'repeativeDate':
                                _isRepeativeDateVisible = isVisible;
                                _saveColumnVisibility(
                                    'repeativeDate', _isRepeativeDateVisible);
                                break;
                            }
                            _missionTabbleOrderPopupListWidgetStateGlobalkey
                                .currentState
                                ?.setUpOrder(this.columnsOrders);

                            setUpDatasAndVisibility();
                          });
                        },
                      );
                    });
              },
            )
            // PopupMenuButton<String>(
            //   onSelected: (String result) {
            //     setState(() {
            //       switch (result) {
            //         case 'title':
            //           _isTitleVisible = !_isTitleVisible;
            //           _saveColumnVisibility('title', _isTitleVisible);
            //           break;
            //         case 'isFinished':
            //           _isFinishedDateVisible = !_isFinishedDateVisible;
            //           _saveColumnVisibility(
            //               'isFinished', _isFinishedDateVisible);
            //           break;
            //         case 'start_time':
            //           _isStartTimeVisible = !_isStartTimeVisible;
            //           _saveColumnVisibility('start_time', _isStartTimeVisible);
            //           break;
            //         case 'end_time':
            //           _isEndTimeVisible = !_isEndTimeVisible;
            //           _saveColumnVisibility('end_time', _isEndTimeVisible);
            //           break;
            //         case 'tagNames':
            //           _isTagNamesVisible = !_isTagNamesVisible;
            //           _saveColumnVisibility('tagNames', _isTagNamesVisible);
            //           break;
            //         case 'no_tomotoes_finished':
            //           _isNoTomotoesFinishedVisible =
            //               !_isNoTomotoesFinishedVisible;
            //           _saveColumnVisibility(
            //               'no_tomotoes_finished', _isNoTomotoesFinishedVisible);
            //           break;
            //         case 'total_tomotoes':
            //           _isTotalTomotoesVisible = !_isTotalTomotoesVisible;
            //           _saveColumnVisibility(
            //               'total_tomotoes', _isTotalTomotoesVisible);
            //           break;
            //         case 'priorityStatus':
            //           _isPriorityStatusVisible = !_isPriorityStatusVisible;
            //           _saveColumnVisibility(
            //               'priorityStatus', _isPriorityStatusVisible);
            //           break;
            //         case 'tomato_duration':
            //           _isTomatoDurationVisible = !_isTomatoDurationVisible;
            //           _saveColumnVisibility(
            //               'tomato_duration', _isTomatoDurationVisible);
            //           break;
            //         case 'folder_id':
            //           _isFolderIdVisible = !_isFolderIdVisible;
            //           _saveColumnVisibility('folder_id', _isFolderIdVisible);
            //           break;
            //         case 'isDelayed':
            //           _isIsDelayedVisible = !_isIsDelayedVisible;
            //           _saveColumnVisibility('isDelayed', _isIsDelayedVisible);
            //           break;
            //         case 'time_mode':
            //           _isTimeModeVisible = !_isTimeModeVisible;
            //           _saveColumnVisibility('time_mode', _isTimeModeVisible);
            //           break;
            //         case 'submission':
            //           _isSubmissionVisible = !_isSubmissionVisible;
            //           _saveColumnVisibility('submission', _isSubmissionVisible);
            //           break;
            //         case 'repetiveType':
            //           _isRepetiveTypeVisible = !_isRepetiveTypeVisible;
            //           _saveColumnVisibility(
            //               'repetiveType', _isRepetiveTypeVisible);
            //           break;
            //         case 'repeativeDate':
            //           _isRepeativeDateVisible = !_isRepeativeDateVisible;
            //           _saveColumnVisibility(
            //               'repeativeDate', _isRepeativeDateVisible);
            //           break;
            //       }
            //       setUpDatasAndVisibility();
            //     });
            //   },
            //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            //     CheckedPopupMenuItem<String>(
            //       value: 'title',
            //       checked: _isTitleVisible,
            //       child: Text(getI18NKey().title),
            //     ),
            //     CheckedPopupMenuItem<String>(
            //       value: 'start_time',
            //       checked: _isStartTimeVisible,
            //       child: Text(getI18NKey().start_time),
            //     ),
            //     CheckedPopupMenuItem<String>(
            //       value: 'end_time',
            //       checked: _isEndTimeVisible,
            //       child: Text(getI18NKey().end_time),
            //     ),
            //     CheckedPopupMenuItem<String>(
            //       value: 'tagNames',
            //       checked: _isTagNamesVisible,
            //       child: Text(getI18NKey().tagNames),
            //     ),
            //     CheckedPopupMenuItem(
            //       value: 'no_tomotoes_finished',
            //       checked: _isNoTomotoesFinishedVisible,
            //       child: Text(getI18NKey().no_tomotoes_finished),
            //     ),
            //     CheckedPopupMenuItem(
            //       value: 'total_tomotoes',
            //       checked: _isTotalTomotoesVisible,
            //       child: Text(getI18NKey().total_tomotoes),
            //     ),
            //     CheckedPopupMenuItem(
            //       value: 'priorityStatus',
            //       checked: _isPriorityStatusVisible,
            //       child: Text(getI18NKey().priorityStatus),
            //     ),
            //     CheckedPopupMenuItem(
            //       value: 'tomato_duration',
            //       checked: _isTomatoDurationVisible,
            //       child: Text(getI18NKey().tomato_duration),
            //     ),
            //     CheckedPopupMenuItem(
            //       value: 'folder_id',
            //       checked: _isFolderIdVisible,
            //       child: Text(getI18NKey().folder_name),
            //     ),
            //     CheckedPopupMenuItem(
            //       value: 'isDelayed',
            //       checked: _isIsDelayedVisible,
            //       child: Text(getI18NKey().isDelayed),
            //     ),
            //     CheckedPopupMenuItem(
            //       value: 'time_mode',
            //       checked: _isTimeModeVisible,
            //       child: Text(getI18NKey().time_mode),
            //     ),
            //     CheckedPopupMenuItem(
            //       value: 'submission',
            //       checked: _isSubmissionVisible,
            //       child: Text(getI18NKey().submisssion),
            //     ),
            //     CheckedPopupMenuItem(
            //       value: 'repetiveType',
            //       checked: _isRepetiveTypeVisible,
            //       child: Text(getI18NKey().repetiveType),
            //     ),
            //     CheckedPopupMenuItem(
            //       value: 'repeativeDate',
            //       checked: _isRepeativeDateVisible,
            //       child: Text(getI18NKey().repetiveWeekDay),
            //     ),
            //   ],
            // ),
          ],
        ),
        Expanded(
            child: DecoratedBox(
                decoration: _drawBorder(), child: buildDataGrid())),
      ],
    );
  }

  Widget _buildExportingButtons() {
    Future<void> exportDataGridToExcel() async {
      final Workbook workbook = _key.currentState!.exportToExcelWorkbook(
          cellExport: (DataGridCellExcelExportDetails details) {
        if (details.cellType == DataGridExportCellType.columnHeader) {
          final bool isRightAlign = details.columnName == 'Product No' ||
              details.columnName == 'Shipped Date' ||
              details.columnName == 'Price';
          details.excelRange.cellStyle.hAlign =
              isRightAlign ? HAlignType.right : HAlignType.left;
        }
      });
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      await FileSaveHelper.saveAndLaunchFile(
          bytes, 'DataGrid-${Utility.getYMDToday()}.xlsx');
    }

    return _buildExportingButton(
        getI18NKey().export_excel, R.assetsImgPdfExport,
        onPressed: exportDataGridToExcel);
  }

  Widget buildDataGrid() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          headerHoverColor: Colors.white.withOpacity(0.3),
          headerColor: ThemeManager.getInstance().isDark()
              ? ThemeManager.getInstance().getCardBackgroundColor()
              : ThemeManager.getInstance().getDefautThemeColor()),
      child: _buildDataGridForWeb(),
      // child: !Utility.isHandsetBySize()
      //     ? _buildDataGridForWeb()
      // : _buildDataGridForMobile(),
    );
  }
}
