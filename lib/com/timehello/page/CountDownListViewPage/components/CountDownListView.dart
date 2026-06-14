import 'package:flutter/material.dart';

import '../../../models/EndTimeMissionModel.dart';
import 'CountdownItem.dart';

/**
 * 文件类型：组件
 * 文件作用：倒计时列表容器，负责承载倒计时卡片列表和统一页面背景。
 * 主要职责：把列表数据和编辑/删除/完成等事件透传给 CountdownItem。
 */
class CountDownListView extends StatefulWidget {
  final List<EndTimeMissionModel> list;
  final Function onTapFinishListener;
  final Function onTapUnFinishListener;
  final Function onTapEditListener;
  final Function onTapDeleteListener;
  final Function onTapListener;

  CountDownListView(
      {required this.list,
      required this.onTapFinishListener,
      required this.onTapUnFinishListener,
      required this.onTapEditListener,
      required this.onTapDeleteListener,
      required this.onTapListener});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CountDownListViewState();
  }
}

class CountDownListViewState extends State<CountDownListView> {
  // 用于传递给子组件的刷新计数，后续如恢复统一计时器可继续复用这个字段。
  int cpt = 0;

  CountDownListViewState();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff3efe7),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
        itemCount: this.widget.list.length,
        itemBuilder: (context, index) {
          return CountdownItem(
            cpt: cpt,
            missionModel: this.widget.list[index],
            onTapListener: this.widget.onTapListener,
            onTapFinishListener: this.widget.onTapFinishListener,
            onTapUnFinishListener: this.widget.onTapUnFinishListener,
            onTapEditListener: this.widget.onTapEditListener,
            onTapDeleteListener: this.widget.onTapDeleteListener,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
