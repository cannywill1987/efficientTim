import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../../models/EndTimeMissionModel.dart';
import '../../../util/TickTimeManager.dart';
import '../models/Countdown.dart';
import 'CountdownItem.dart';

class CountDownListView extends StatefulWidget {
  List<EndTimeMissionModel> list;
  Function onTapFinishListener;
  Function onTapUnFinishListener;
  Function onTapEditListener;
  Function onTapDeleteListener;
  Function onTapListener;

  CountDownListView({required this.list, required this.onTapFinishListener, required this.onTapUnFinishListener,
    required this.onTapEditListener, required this.onTapDeleteListener, required this.onTapListener});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CountDownListViewState();
  }

}

class CountDownListViewState extends State<CountDownListView> {
  // Timer? _timer;
  //用于高速子计时器用于更新
  int cpt = 0;

  Function? cb;

  CountDownListViewState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: this.widget.list.length,
      itemBuilder: (context, index) {
        return CountdownItem(cpt: cpt, missionModel: this.widget.list[index], onTapListener: this.widget.onTapListener, onTapFinishListener: this.widget.onTapFinishListener, onTapUnFinishListener: this.widget.onTapUnFinishListener, onTapEditListener: this.widget.onTapEditListener, onTapDeleteListener: this.widget.onTapDeleteListener,);
      },
    );
  }

  void _startTimer() {
    // if(cb == null)
    // TickTimeManager.getInstance().addCallback(callback: cb = (){
    //   if(mounted)
    //   setState(() {
    //     cpt++;
    //     // _remainingTime = widget.countdown.targetTime.difference(DateTime.now());
    //   });
    // });
    // _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    // });
  }

  @override
  void initState() {
    // _startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // if(cb != null) {
    //   TickTimeManager.getInstance().removeCallback(callback: cb!);
    //   cb= null;
    // }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}