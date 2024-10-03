import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/CONSTANTS.dart';
import '../config/Params.dart';
import '../models/MissionModel.dart';
import '../util/SharePreferenceUtil.dart';
import 'BlackCheckButtonListWidget.dart';

class MissionTabbleOrderPopupListWidget extends StatefulWidget {
  final List<MissionModel> listMissionModels;
  final Function(String, bool) onClickMissionSetting;
  final Function(List<String>) onClickMissionReorder;
  final List<Map<String, dynamic>>  columnsOrders;
  MissionTabbleOrderPopupListWidget({Key? key,required this.columnsOrders, required this.listMissionModels, required this.onClickMissionSetting, required this.onClickMissionReorder});

  @override
  State<StatefulWidget> createState() {
    return MissionTabbleOrderPopupListWidgetState(columnsOrders: columnsOrders);
  }
}

class MissionTabbleOrderPopupListWidgetState extends State<MissionTabbleOrderPopupListWidget> {
  List<Map<String, dynamic>>  columnsOrders;

  MissionTabbleOrderPopupListWidgetState({required this.columnsOrders});


  @override
  void initState() {
    super.initState();
    loadColumnOrder();
  }

  

  // Future<void> _saveColumnVisibility(String columnName, bool isVisible) async {
  //   SharePreferenceUtil.getSyncInstance().setBool(
  //       key: ShareprefrenceKeys.missionColumnVisible + columnName,
  //       val: isVisible);
  // }

  // 构建列排序和可见性控制
  Widget _buildColumnReorderList() {
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final column = columnsOrders.removeAt(oldIndex);
          columnsOrders.insert(newIndex, column);
          _saveColumnOrder(); // 保存列顺序
        });
      },
      children: List.generate(columnsOrders.length, (index) {
        final column = columnsOrders[index];
        return ListTile(
          key: ValueKey(column['key']),
          title: Text(column['name']),
          trailing:
          Container(

            margin: const EdgeInsets.only(right: 18.0),
            child: BlackCheckButtonListWidget(
              initIndex: column['visible']
                  ? 1
                  : 0,
              list: CONSTANTS.getOnAndOffButtonList(),
              onTapListener: (obj) {
                this.widget.onClickMissionSetting(column['key'], obj == 1);
                setState(() {

                });
              },
            ),
          )

        );
      }),
    );
  }

  // 保存列顺序
  Future<void> _saveColumnOrder() async {
    List<String> columnOrder = columnsOrders.map<String>((column) => column['key'] as String).toList();
    SharePreferenceUtil.getSyncInstance().setStringList(
        key: ShareprefrenceKeys.missionColumnOrder, content: columnOrder);
    this.widget.onClickMissionReorder(columnOrder);
    // _loadColumnOrder();
  }

  setUpOrder(List<Map<String, dynamic>>  columnsOrders) {
    this.columnsOrders = columnsOrders;
    List<String> columnOrder = this.columnsOrders.map<String>((column) => column['key'] as String).toList();
    loadColumnOrder();
  }

  // 加载列顺序
  loadColumnOrder()  {
    List<String> savedOrder = SharePreferenceUtil.getSyncInstance().getStringList(
        key: ShareprefrenceKeys.missionColumnOrder, defaultVal: []);

    if (savedOrder.isNotEmpty) {
      setState(() {
        columnsOrders.sort((a, b) {
          // 根据保存的顺序进行列的排序
          return savedOrder.indexOf(a['key']).compareTo(savedOrder.indexOf(b['key']));
        });
      });
    }
    print("object");
  }

  @override
  Widget build(BuildContext context) {
    return _buildColumnReorderList();
  }
}