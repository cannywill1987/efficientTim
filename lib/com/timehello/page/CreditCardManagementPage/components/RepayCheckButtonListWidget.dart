import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';


class RepayCheckButtonListWidget extends StatefulWidget {
  List<CheckButtonStateModel> list;
  OnTapListener onTapListener;
  // String unit = getI18NKey().min_en;
  bool isMultiSelected = false;
  RepayCheckButtonListWidget({required this.list, required this.onTapListener, unit, this.isMultiSelected: false}) {
    // this.unit = unit ?? getI18NKey().min_en;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RepayCheckButtonListWidgetState(list: list);
  }
}

class RepayCheckButtonListWidgetState extends State<RepayCheckButtonListWidget> {
  List<CheckButtonStateModel> list = [];

  RepayCheckButtonListWidgetState({required this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: getList(this.list));
  }

  List<Widget> getList(List<CheckButtonStateModel> list) {
    List<Widget> listTmp = [];
    list.forEach((element) {
      listTmp.add(getCheckButton(element, list.indexOf(element)));
    });
    return listTmp;
  }

  Widget getCheckButton(CheckButtonStateModel model, int index) {
      return InkWell(
          // style: StylesConfig.transparentTextButtonStyle,
          onTap: () {
            if (this.widget.isMultiSelected == false) {
              this.initModelListState();
              setState(() {
                model.isCheck = true;
                this.widget.onTapListener({"data": model, "index": index});
              });
            } else {
              setState(() {
                model.isCheck = !(model.isCheck??false);
                this.widget.onTapListener({"data": getCheckModelList()});
              });
            }

            // if (this.widget.isMultiSelected == false) {
            // } else {
            //   setState(() {
            //     model.isCheck = !(model.isCheck ?? false);
            //     this.widget.onTapListener({"data": getCheckModelList()});
            //   });
            // }

          }, child:Container(

          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: model.isCheck == true ? Color(0xff7171ed) : Color(0xffe5e5e5)),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if(model.checkIcon != null)
                model.checkIcon!,
              if(model.checkIcon != null)
                SizedBox(width: 5,),
              new Text(
                model.title ?? '',
                maxLines: 1,
                softWrap: false,
                style: TextStyle(color: model.isCheck == true ? Color(0xff373737) : Color(0xff878787), fontSize: 15),
              ),
            ],
          )));
  }

  List<CheckButtonStateModel> getCheckModelList() {
    List<CheckButtonStateModel> list = [];
    this.list.forEach((element) {
      if(element.isCheck == true) {
        list.add(element);
      }
    });
    return list;
  }

  void initModelListState() {
    this.list.forEach((element) {
      element.isCheck = false;
    });
  }
}
