import 'package:flutter/material.dart';

import '../../../../../r.dart';
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
  List<List<bool>> datas = [];
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
      required List<List<bool>> datas}) {
    this.onInputListener = onInputListener;
    this.gameTableMode = gameTableMode ?? GameTableMode.SingleCharTextWidget;
    this.datas = datas;
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
      List<bool> row = this.datas[i];
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
    return Container(
      decoration: BoxDecoration(borderRadius:BorderRadius.all(Radius.circular(5))),
        clipBehavior:Clip.antiAlias,
      child: Table(
      defaultColumnWidth: FixedColumnWidth(this.widget.itemWidth),
      border: TableBorder.all(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        width: 2.0,
        style: BorderStyle.solid,
      ),
      children: getTableRows(),
    ),);
  }

  List<TableRow> getTableRows() {
    List<TableRow> listTableRows = [];
    for (int i = 0; i < this.widget.datas.length; i++) {
      List<bool> rowsNums = this.widget.datas[i];
      listTableRows.add(TableRow(children: getTableColumn(rowsNums, i)));
    }
    return listTableRows;
  }

  List<Widget> getTableColumn(List<bool> rowsNums, int rowIndex) {
    List<Widget> list = [];
    for (int columnIndex = 0; columnIndex < rowsNums.length; columnIndex++) {
      bool val = rowsNums[columnIndex];
      list.add(getWidget(rowIndex, val));
    }
    return list;
  }


  Widget getWidget(int row, bool val) {
    Widget item = this.getItem(val);
    return item;
  }

  Widget getItem(bool isCkecked) {
    return Container(alignment: Alignment.center,width:this.widget.itemWidth, height:this.widget.itemWidth, color: isCkecked ? Color(0xffff8800):Color(0x00000000), child: isCkecked ? Utility.getSVGPicture(R.assetsImgIcCorrect, size: this.widget.itemWidth * 2 / 3) : SizedBox.shrink(),);
  }

}
