import 'package:dio/dio.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/Observable.dart';

abstract class Observer {
  void update(Observable o, BaseBean response, String scene);
}