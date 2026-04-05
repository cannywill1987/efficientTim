import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';

import '../config/CONSTANTS.dart';
import '../util/ThemeManager.dart';
import '../util/Utility.dart';

class PriorityButtonListWidget extends StatefulWidget {
  List<CheckButtonStateModel> list;
  OnTapListener onTapListener;
  double? width;
  int? initIndex; //初始化默认值
  bool useUnifiedStyle;

  PriorityButtonListWidget(
      {this.initIndex: 0,
      required this.list,
      required this.onTapListener,
      this.width: 80,
      this.useUnifiedStyle = false}) {}

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PriorityButtonListWidgetState(curIndex: this.initIndex, list: this.list);
  }
}

class PriorityButtonListWidgetState extends State<PriorityButtonListWidget> {
  String title = "";
  List<CheckButtonStateModel> list;
  int? curIndex;

  PriorityButtonListWidgetState({this.curIndex, required this.list});

  @override
  Widget build(BuildContext context) {
    if (widget.useUnifiedStyle) {
      return Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1000),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.1,
            maxCrossAxisExtent: 220,
          ),
          itemCount: this.list.length,
          itemBuilder: (context, index) {
            return getCheckButton(
                this.list[index], this.list.indexOf(this.list[index]));
          },
        ),
      );
    }
    return Container(
        height: 100,
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 1000),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //设置横向间距
            crossAxisSpacing: 10,
            //设置主轴间距
            mainAxisSpacing: 10,
            childAspectRatio: 5,
            maxCrossAxisExtent: 250,
          ),
          scrollDirection: Axis.vertical,
          itemCount: this.list.length,
          itemBuilder: (context, index) {
            return getCheckButton(this.list[index],
                this.list.indexOf(this.list[index]));
          },
        ));
  }

  @override
  void initState() {
    updateCheckButtonStateModel();

  }

  void didUpdateWidget(PriorityButtonListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(this.widget.initIndex != this.curIndex) {
      this.curIndex = this.widget.initIndex;
      updateCheckButtonStateModel();
    }
  }

  // @override
  // void didUp() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //
  // }

  void updateCheckButtonStateModel() {
     if (this.curIndex != null) {
      for (int i = 0; i < this.list.length; i++) {
        CheckButtonStateModel model = this.list[i];
        if (this.curIndex == i) {
          model.isCheck = true;
          this.widget.onTapListener({"data": model, "index": i});
        } else {
          model.isCheck = false;
        }
      }
    }
  }

  Widget getCheckButton(CheckButtonStateModel model, int index) {
    if (widget.useUnifiedStyle) {
      final PriorityEnum priority =
          PriorityEnum.values[int.parse(model.code ?? "0")];
      final bool isChecked = model.isCheck == true;
      return Container(
        width: this.widget.width,
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(
            width: isChecked ? 1.5 : 1,
            color: isChecked
                ? Utility.getTextColorByPriority(priority)
                : const Color(0xFFE5D7C7),
          ),
          color: isChecked
              ? Utility.getBGColorByPrioritySelected(priority)[0]
              : ThemeManager.getInstance().getCardBackgroundColor(
                  defaultColor: const Color(0xFFFFF7EE)),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: TextButton(
            style: StylesConfig.transparentTextButtonStyle,
            onPressed: () {
              this.initModelListState();
              setState(() {
                model.isCheck = true;
                this.widget.onTapListener({"data": model, "index": index});
              });
            },
            child: Text(
              model.title ?? '',
              maxLines: 2,
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isChecked
                    ? Utility.getTextColorByPriority(priority)
                    : ThemeManager.getInstance().getTextColor(
                        defaultColor: const Color(0xFF4B3A2E)),
                fontSize: isChecked ? 15 : 14,
                fontWeight: FontWeight.w600,
              ),
            )),
      );
    }
    if (model.isCheck == true) {
      return Container(
          width: this.widget.width,
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Utility.getTextColorByPriority(
                    PriorityEnum.values[int.parse(model?.code ?? "0")]),
              ),
              gradient: LinearGradient(
                  colors: Utility.getBGColorByPrioritySelected(
                      PriorityEnum.values[int.parse(model?.code ?? "0")])),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              new Text(
                model.title ?? '',
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Utility.getTextColorByPriority(
                        PriorityEnum.values[int.parse(model?.code ?? "0")]),
                    fontSize: 15),
              )
            ],
          ));
    } else {
      return Container(
          width: this.widget.width,
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: ThemeManager.getInstance().getColor(defaultColor: Color(0xffe0e0e0))),
              gradient: LinearGradient(
                  colors: Utility.getBGColorByPriority(
                      PriorityEnum.values[int.parse(model?.code  ?? "0")])),
              borderRadius: BorderRadius.all(Radius.circular(40))),
          child: TextButton(
              style: StylesConfig.transparentTextButtonStyle,
              onPressed: () {
                this.initModelListState();
                setState(() {
                  model.isCheck = true;
                  this.widget.onTapListener({"data": model, "index": index});
                });
              },
              child: Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    new Text(
                      model.title ?? '',
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)), fontSize: 12),
                    )
                  ])));
    }
  }

  void initModelListState() {
    this.list.forEach((element) {
      element.isCheck = false;
    });
  }
}
