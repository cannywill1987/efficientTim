import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/beans/SuggestionBean.dart';

/**
 * CheckButtonStateModel
 * pc端右上角日历button
 */
class CheckButtonStateModel {
  String? code;
  String? title;
  String? content;
  dynamic? value;
  int? color;
  bool isCheck = false;
  Widget? checkIcon;
  Widget? uncheckIcon;
  String? checkIconUrl;
  String? uncheckIconUrl;
  List<SuggestionBean>? list;
  CheckButtonStateModel({this.code, this.value, this.title, this.list, this.content, this.isCheck = false, this.color, this.checkIconUrl, this.uncheckIconUrl, this.checkIcon, this.uncheckIcon});
}

