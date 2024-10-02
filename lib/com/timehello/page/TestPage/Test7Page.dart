// // import 'package:appflowy_editor/appflowy_editor.dart';
// import 'package:flip_card/flip_card.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:time_hello/com/timehello/components/CustomBackgroundWidget.dart';
// import 'package:time_hello/com/timehello/models/TimelineMissionModel.dart';
// import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';
// import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
// import 'package:time_hello/com/timehello/util/Utility.dart';
// /// DataGrid import
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// /// Core import
// import 'package:syncfusion_flutter_core/theme.dart';
// import '../../components/CustomLgLeftChatWidget.dart';
// import '../TimeLinePage/components/FileMessageWidget.dart';
// import '../WrongQuestionBookPage/components/WQBNoteWidget.dart';
// import '../missionPage/componnents/MissionGridView.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
//
// import 'MissionTableDataGridSource.dart';
//
// class Test7Page extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return Test7PageState();
//   }
// }
//
// class Test7PageState extends State<Test7Page> {
//   /// DataGridSource required for SfDataGrid to obtain the row data.
//   final MissionTableDataGridSource _teamDataGridSource = MissionTableDataGridSource();
//
//   /// DataGridSource required for SfDataGrid to obtain the row data.
//   late EmployeeDataGridSource _employeeDataGridSource;
//   late GridLinesVisibility _gridLineVisibility = GridLinesVisibility.both;
//   ColumnResizeMode columnResizeMode = ColumnResizeMode.onResize;
//   // late bool _isWebOrDesktop;
//
//   SfDataGrid _buildDataGridForMobile() {
//     return SfDataGrid(
//       allowSorting: true,
//       allowFiltering: true,
//       allowColumnsResizing: true,
//       source: _teamDataGridSource,
//       gridLinesVisibility: GridLinesVisibility.both,
//       // 设置线
//
//       columnWidthMode: ColumnWidthMode.fill,
//       rowHeight: 50,
//       columns: <GridColumn>[
//         GridColumn(
//           columnName: 'image',
//           minimumWidth: 15.0,
//           label: const SizedBox.shrink(),
//         ),
//         GridColumn(
//           columnName: 'team',
//           minimumWidth: 15.0,
//           // width: !_isWebOrDesktop ? 90 : double.nan,
//           label: Container(
//             alignment: Alignment.centerLeft,
//             child: const Text('Team'),
//           ),
//         ),
//         GridColumn(
//           columnName: 'wins',
//           minimumWidth: 15.0,
//           label: const Center(
//             child: Text('W'),
//           ),
//         ),
//         GridColumn(
//             columnName: 'losses',
//             minimumWidth: 15.0,
//             label: const Center(
//               child: Text('L'),
//             )),
//         GridColumn(minimumWidth: 15.0,columnName: 'pct', label: const Center(child: Text('WPCT'))),
//         GridColumn(
//           columnName: 'gb',
//           minimumWidth: 15.0,
//           label: const Center(child: Text('GB')),
//         ),
//       ],
//     );
//   }
//
//   Widget buildLocationWidget(String location) {
//     return Row(
//       children: <Widget>[
//         Image.asset('images/location.png'),
//         Text(
//           ' ' + location,
//         )
//       ],
//     );
//   }
//
//   Widget buildTrustWidget(String trust) {
//     return Row(children: <Widget>[
//       Row(
//         children: <Widget>[Image.asset('images/Perfect.png'), Text(trust)],
//       )
//     ]);
//   }
//
//   SfDataGrid _buildDataGridForWeb() {
//     return SfDataGrid(
//       allowColumnsResizing: true,
//       allowSorting: true,
//       allowFiltering: true,
//       columnResizeMode: columnResizeMode,
//       source: _employeeDataGridSource,
//         onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
//           setState(() {
//             //宽度要动态设置
//             if (args.column.columnName == 'orderId') {
//               // _orderIdColumnWidth = args.width;
//             } else if (args.column.columnName == 'productId') {
//               // _productIdColumnWidth = args.width;
//             } else if (args.column.columnName == 'customerName') {
//               // _customerNameColumnWidth = args.width;
//             } else if (args.column.columnName == 'product') {
//               // _productColumnWidth = args.width;
//             } else if (args.column.columnName == 'orderDate') {
//               // _orderDateColumnWidth = args.width;
//             } else if (args.column.columnName == 'quantity') {
//               // _quantityColumnWidth = args.width;
//             } else if (args.column.columnName == 'city') {
//               // _cityColumnWidth = args.width;
//             } else if (args.column.columnName == 'unitPrice') {
//               // _unitPriceColumnWidth = args.width;
//             }
//           });
//           return true;
//         },
//           gridLinesVisibility: GridLinesVisibility.both, // 设置线
//       columns: <GridColumn>[
//         GridColumn(
//             minimumWidth: 15.0,
//             columnName: 'employeeName',
//             label: Container(
//               alignment: Alignment.center,
//               padding: const EdgeInsets.all(8.0),
//               child: const Text(
//                 'Employee Name',
//                 overflow: TextOverflow.ellipsis,
//               ),
//             )),
//         GridColumn(
//           columnName: 'designation',
//           minimumWidth: 15.0,
//           width: DeviceInfoManagement.isWEB() ? 150 : 130,
//           label: Container(
//             alignment: Alignment.centerLeft,
//             padding: const EdgeInsets.all(8.0),
//             child: const Text(
//               'Designation',
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ),
//         GridColumn(
//           columnName: 'mail',
//           width: 180.0,
//           minimumWidth: 15.0,
//           label: Container(
//             padding: const EdgeInsets.all(8.0),
//             alignment: Alignment.centerLeft,
//             child: const Text(
//               'Mail',
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ),
//         GridColumn(
//           columnName: 'location',
//           width: 105.0,
//           minimumWidth: 15.0,
//           label: Container(
//             alignment: Alignment.center,
//             padding: const EdgeInsets.all(8.0),
//             child: const Text(
//               'Location',
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ),
//         GridColumn(
//           minimumWidth: 15.0,
//           columnName: 'status',
//           label: Container(
//               padding: const EdgeInsets.all(8.0),
//               alignment: Alignment.center,
//               child: const Text(
//                 'Status',
//                 overflow: TextOverflow.ellipsis,
//               )),
//         ),
//         GridColumn(
//             columnName: 'trustworthiness',
//             width: 130,
//             label: Container(
//                 alignment: Alignment.centerLeft,
//                 padding: const EdgeInsets.all(8.0),
//                 child: const Text(
//                   'Trustworthiness',
//                   overflow: TextOverflow.ellipsis,
//                 ))),
//         GridColumn(
//             columnName: 'softwareProficiency',
//             width: 165,
//             label: Container(
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.all(8.0),
//                 child: const Text(
//                   'Software Proficiency',
//                   overflow: TextOverflow.ellipsis,
//                 ))),
//         GridColumn(
//           columnName: 'salary',
//           label: Container(
//               padding: const EdgeInsets.all(8.0),
//               alignment: Alignment.centerRight,
//               child: const Text(
//                 'Salary',
//                 overflow: TextOverflow.ellipsis,
//               )),
//         ),
//         GridColumn(
//           columnName: 'address',
//           width: 400,
//           label: Container(
//             alignment: Alignment.centerLeft,
//             padding: const EdgeInsets.all(8.0),
//             child: const Text(
//               'Address',
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // _isWebOrDesktop = model.isWeb || model.isDesktop;
//     _employeeDataGridSource = EmployeeDataGridSource();
//   }
//
//   BoxDecoration _drawBorder() {
//     final BorderSide borderSide = BorderSide(
//         color: const Color.fromRGBO(0, 0, 0, 0.26)
//     );
//
//     // Restricts the right side border when Datagrid has gridlinesVisibility
//     // to both and vertical to maintains the border thickness.
//     switch (_gridLineVisibility) {
//       case GridLinesVisibility.none:
//       case GridLinesVisibility.horizontal:
//         return BoxDecoration(
//             border: Border(
//                 left: borderSide, right: borderSide, bottom: borderSide));
//       case GridLinesVisibility.both:
//       case GridLinesVisibility.vertical:
//         return BoxDecoration(
//             border: Border(left: borderSide, bottom: borderSide));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: const Color(0xFFFAFAFA),
//         child: Card(
//             margin: const EdgeInsets.all(16.0),
//             clipBehavior: Clip.antiAlias,
//             elevation: 1.0,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: DecoratedBox(
//                   decoration: _drawBorder(),
//                   child: buildDataGrid()),
//             )));
//   }
//
//   Widget buildDataGrid() {
//     return SfDataGridTheme(
//       data: SfDataGridThemeData(
//           headerHoverColor: Colors.white.withOpacity(0.3),
//           headerColor: Colors.yellow),
//       child: !Utility.isHandsetBySize()
//           ? _buildDataGridForWeb()
//           : _buildDataGridForMobile(),
//     );
//   }
//
// }