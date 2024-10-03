// import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/CustomBackgroundWidget.dart';
import 'package:time_hello/com/timehello/models/TimelineMissionModel.dart';
import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
/// DataGrid import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
/// Core import
import 'package:syncfusion_flutter_core/theme.dart';
import '../../components/CustomLgLeftChatWidget.dart';
import '../../components/MissionTableContainerWidget.dart';
import '../TimeLinePage/components/FileMessageWidget.dart';
import '../WrongQuestionBookPage/components/WQBNoteWidget.dart';
import '../missionPage/componnents/MissionGridView.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'MissionTableDataGridSource.dart';

class Test8Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Test8PageState();
  }
}

class Test8PageState extends State<Test8Page> {
  /// DataGridSource required for SfDataGrid to obtain the row data.

  @override
  Widget build(BuildContext context) {
    return MissionTableContainerWidget(listMissionModels: MongoApisManager.getInstance().listMissionModels ?? [], onClickMissionSetting: (MissionModel ) {  },);
  }

}