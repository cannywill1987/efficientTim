import 'package:flutter/material.dart';

import '../../../config/ENUMS.dart';
import '../../../util/Utility.dart';
import '../../../util/WidgetManager.dart';
import 'SingleCharTextWidget.dart';

class CustomTableWidget extends StatefulWidget {
  int? numRows = 3;
  int? numColums = 3;
  double? width;
  late double itemWidth;
  late double itemHeight;
  double? height;
  List<List<String>> datas = [];
  GameTableMode? gameTableMode;
  Function? onInputListener;

  CustomTableWidget(
      {double? itemWidth,
      double? width,
      double? height,
      int? numRows,
      int? numColums,
      Function? onInputListener,
      GameTableMode? gameTableMode,
      required List<List<String>> datas}) {
    this.onInputListener = onInputListener;
    this.gameTableMode = gameTableMode ?? GameTableMode.SingleCharTextWidget;
    this.datas = Utility.deepCloneList(datas);
    this.width = width;
    this.height = height;
    this.numRows = numRows ?? datas.length;
    this.numColums = numColums ?? getNumColumns();
    if (this.width != null) {
      this.itemWidth = this.width! / this.numColums!;
    } else if (itemWidth != null) {
      this.itemWidth = itemWidth;
    }
    // this.itemHeight = this.width/this.numRows!;
    this.itemHeight = this.itemWidth;
  }

  int getNumColumns() {
    int maxColumns = 0;
    for (int i = 0; i < this.datas.length; i++) {
      List<String> row = this.datas[i];
      if (row.length > maxColumns) {
        maxColumns = row.length;
      }
    }
    return maxColumns;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomTableWidgetState();
  }
}

class CustomTableWidgetState extends State<CustomTableWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Table(
      defaultColumnWidth: FixedColumnWidth(this.widget.itemWidth),
      border: TableBorder.all(
        color: Colors.green,
        width: 2.0,
        style: BorderStyle.solid,
      ),
      children: getTableRows(),
    );
  }

  List<TableRow> getTableRows() {
    List<TableRow> listTableRows = [];
    for (int i = 0; i < this.widget.datas.length; i++) {
      List<String> rowsNums = this.widget.datas[i];
      listTableRows.add(TableRow(children: getTableColumn(rowsNums, i)));
    }
    return listTableRows;
  }

  List<Widget> getTableColumn(List<String> rowsNums, int rowIndex) {
    List<Widget> list = [];
    for (int columnIndex = 0; columnIndex < rowsNums.length; columnIndex++) {
      String val = rowsNums[columnIndex];
      list.add(getWidget(rowIndex, val));
    }
    return list;
  }

  List<List<String>> setValOfDataList(int index, String val) {
    List<List<String>> datas = this.widget.datas;
    datas[index][0] = val;
    return datas;
  }

  Widget getWidget(int row, String val) {
    Widget item;
    if (val == "EL_INPUT" || val == "EL_INPUT_DISABLE") {
      item = WidgetManager.getInputWidget(
          readOnly: val == "EL_INPUT" ? false : true,
          onSubmit: (val) => {},
          onChange: (param) {
            // val = param;
            if (this.widget.onInputListener != null) {
              this.widget.onInputListener!(setValOfDataList(row, param));
            }
          });
    } else {
      switch (this.widget.gameTableMode) {
        case GameTableMode.Text:
          item = this.getText(val);
          break;
        default:
          item = this.getSingleCharTextWidget(val);
          break;
      }
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(padding: EdgeInsets.only(top: 3, bottom: 3), child: item)
        ]);
  }

  Widget getInput(String val) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            val,
            style: TextStyle(letterSpacing: 15, fontSize: 14),
          )
        ]);
  }

  Widget getText(String val) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            val,
            style: TextStyle(letterSpacing: 15, fontSize: 14),
          )
        ]);
  }

  SingleCharTextWidget getSingleCharTextWidget(String val) {
    return SingleCharTextWidget(
      itemWidth: this.widget.itemWidth,
      itemHeight: this.widget.itemHeight,
      width: 15,
      text: val,
      dotSize: 6,
      fontSize: 16,
      gameDotPositionEnum: GameDotPositionEnum.random.index,
    );
  }
}
