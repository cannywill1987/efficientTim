import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  bool? isChecked;
  Function? onChanged;
  CustomCheckBox({this.isChecked = false, this.onChanged});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomCheckBoxState(isChecked: this.isChecked);
  }

}

class CustomCheckBoxState extends State<CustomCheckBox> {
  bool? isChecked;

  CustomCheckBoxState({this.isChecked = false});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Checkbox(value: isChecked, onChanged: (bool? value) {
      setState(() {
        isChecked = value;
      });
      this.widget.onChanged?.call(value);
    },);
  }

}