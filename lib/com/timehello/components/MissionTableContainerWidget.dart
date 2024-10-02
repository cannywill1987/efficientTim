// import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CustomBackgroundWidget.dart';
import 'package:time_hello/com/timehello/models/TimelineMissionModel.dart';
import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

/// DataGrid import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Core import
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../config/Params.dart';
import '../models/MissionModel.dart';
import '../page/TestPage/MissionTableDataGridSource.dart';
import '../util/SharePreferenceUtil.dart';

class MissionTableContainerWidget extends StatefulWidget {
  List<MissionModel> listMissionModels;

  MissionTableContainerWidget({Key? key, required this.listMissionModels})
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

  /// DataGridSource required for SfDataGrid to obtain the row data.
  // late EmployeeDataGridSource _employeeDataGridSource;
  late GridLinesVisibility _gridLineVisibility = GridLinesVisibility.both;
  ColumnResizeMode columnResizeMode = ColumnResizeMode.onResize;
  EditingGestureType _editingGestureType = EditingGestureType.tap;
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

  MissionTableContainerWidgetState(
      {required List<MissionModel> listMissionModels}) {
    initDataSource(listMissionModels ?? []);
  }

  void initDataSource(List<MissionModel> listMissionModels) {
    _loadColumnVisibility();
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
        isRepeativeDateVisible: _isRepeativeDateVisible);
  }

  Future<void> _loadColumnVisibility() async {
      _isTitleVisible = SharePreferenceUtil.getSyncInstance().getBool(
          key: ShareprefrenceKeys.missionColumnVisible + "title",
          defaultVal: true);
      _isStartTimeVisible = SharePreferenceUtil.getSyncInstance().getBool(
          key: ShareprefrenceKeys.missionColumnVisible + "start_time",
          defaultVal: true);
      _isEndTimeVisible = SharePreferenceUtil.getSyncInstance().getBool(
          key: ShareprefrenceKeys.missionColumnVisible + "end_time",
          defaultVal: true);
      _isTagNamesVisible = SharePreferenceUtil.getSyncInstance().getBool(
          key: ShareprefrenceKeys.missionColumnVisible + "tagNames",
          defaultVal: true);
      _isNoTomotoesFinishedVisible = SharePreferenceUtil.getSyncInstance()
          .getBool(
              key: ShareprefrenceKeys.missionColumnVisible +
                  "no_tomotoes_finished",
              defaultVal: true);
      _isTotalTomotoesVisible = SharePreferenceUtil.getSyncInstance().getBool(
          key: ShareprefrenceKeys.missionColumnVisible + "total_tomotoes",
          defaultVal: true);
      _isPriorityStatusVisible = SharePreferenceUtil.getSyncInstance().getBool(
          key: ShareprefrenceKeys.missionColumnVisible + "priorityStatus",
          defaultVal: true);
      _isTomatoDurationVisible = SharePreferenceUtil.getSyncInstance().getBool(
          key: ShareprefrenceKeys.missionColumnVisible + "tomato_duration",
          defaultVal: true);
      _isFolderIdVisible = SharePreferenceUtil.getSyncInstance().getBool(
          key: ShareprefrenceKeys.missionColumnVisible + "folder_id",
          defaultVal: true);
      _isIsDelayedVisible = SharePreferenceUtil.getSyncInstance().getBool(
          key: ShareprefrenceKeys.missionColumnVisible + "isDelayed",
          defaultVal: true);
      _isTimeModeVisible = SharePreferenceUtil.getSyncInstance().getBool(
          key: ShareprefrenceKeys.missionColumnVisible + "time_mode",
          defaultVal: true);
      _isSubmissionVisible = SharePreferenceUtil.getSyncInstance().getBool(
          key: ShareprefrenceKeys.missionColumnVisible + "submission",
          defaultVal: true);
      _isRepetiveTypeVisible = SharePreferenceUtil.getSyncInstance().getBool(
          key: ShareprefrenceKeys.missionColumnVisible + "repetiveType",
          defaultVal: true);
      _isRepeativeDateVisible = SharePreferenceUtil.getSyncInstance().getBool(
          key: ShareprefrenceKeys.missionColumnVisible + "repeativeDate",
          defaultVal: true);
      // initDataSource(this.widget.listMissionModels);
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

  SfDataGrid _buildDataGridForWeb() {
    return SfDataGrid(
      allowEditing: true,
      navigationMode: GridNavigationMode.cell,
      selectionMode: SelectionMode.single,
      editingGestureType: EditingGestureType.tap,

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
    List<GridColumn> list = <GridColumn>[
      if (_isTitleVisible)
        GridColumn(
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
            )),
      if (_isStartTimeVisible)
        GridColumn(
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
        ),
      if (_isEndTimeVisible)
        GridColumn(
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
        ),
      if (_isTagNamesVisible)
        GridColumn(
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
        ),
      if (_isNoTomotoesFinishedVisible)
        GridColumn(
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
        ),
      if (_isTotalTomotoesVisible)
        GridColumn(
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
        ),
      if (_isPriorityStatusVisible)
        GridColumn(
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
        ),
      if (_isTomatoDurationVisible)
        GridColumn(
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
        ),
      if (_isFolderIdVisible)
        GridColumn(
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
        ),
      if (_isIsDelayedVisible)
        GridColumn(
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
        ),
      if (_isTimeModeVisible)
        GridColumn(
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
        ),
      if (_isSubmissionVisible)
        GridColumn(
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
        ),
      if (_isRepetiveTypeVisible)
        GridColumn(
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
        ),
      if (_isRepeativeDateVisible)
        GridColumn(
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
        ),

    ];
    print("111111111111111111111111111111111113");
    print("length MissionDataSource:" + list.length.toString());
    print("111111111111111111111111111111111113");
    return list;
  }

  @override
  void initState() {
    super.initState();
    _loadColumnWidths(); // 动态获取保存的宽度并初始化
    _loadColumnVisibility(); // 动态获取保存的列显示状态并初始化
    // _isWebOrDesktop = model.isWeb || model.isDesktop;
    // _teamDataGridSource = EmployeeDataGridSource();
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

  Future<void> _saveColumnVisibility(String columnName, bool isVisible) async {
    SharePreferenceUtil.getSyncInstance().setBool(
        key: ShareprefrenceKeys.missionColumnVisible + columnName,
        val: isVisible);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PopupMenuButton<String>(
          onSelected: (String result) {
            setState(() {
              switch (result) {
                case 'title':
                  _isTitleVisible = !_isTitleVisible;
                  _saveColumnVisibility('title', _isTitleVisible);
                  break;
                case 'start_time':
                  _isStartTimeVisible = !_isStartTimeVisible;
                  _saveColumnVisibility('start_time', _isStartTimeVisible);
                  break;
                case 'end_time':
                  _isEndTimeVisible = !_isEndTimeVisible;
                  _saveColumnVisibility('end_time', _isEndTimeVisible);
                  break;
                case 'tagNames':
                  _isTagNamesVisible = !_isTagNamesVisible;
                  _saveColumnVisibility('tagNames', _isTagNamesVisible);
                  break;
              }
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            CheckedPopupMenuItem<String>(
              value: 'title',
              checked: _isTitleVisible,
              child: Text('Title'),
            ),
            CheckedPopupMenuItem<String>(
              value: 'start_time',
              checked: _isStartTimeVisible,
              child: Text('Start Time'),
            ),
            CheckedPopupMenuItem<String>(
              value: 'end_time',
              checked: _isEndTimeVisible,
              child: Text('End Time'),
            ),
            CheckedPopupMenuItem<String>(
              value: 'tagNames',
              checked: _isTagNamesVisible,
              child: Text('Tag Names'),
            ),
          ],
        ),
        DecoratedBox(decoration: _drawBorder(), child: buildDataGrid()),
      ],
    );
  }

  Widget buildDataGrid() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          headerHoverColor: Colors.white.withOpacity(0.3),
          headerColor: ThemeManager.getInstance().getDefautThemeColor()),
      child: _buildDataGridForWeb(),
      // child: !Utility.isHandsetBySize()
      //     ? _buildDataGridForWeb()
      // : _buildDataGridForMobile(),
    );
  }
}
