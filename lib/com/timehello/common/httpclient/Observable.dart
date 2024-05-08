import 'package:dio/dio.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';

import 'Oberver.dart';
import 'package:time_hello/com/timehello/common/httpclient/Observable.dart';


class Observable {
  bool change = false;
  List<dynamic> obs;

  Observable(): obs = [];

   void addObserver(Observer? o) {
     if (o == null) {
       throw FormatException('NullPointerException');
     }
     if (!obs.contains(o)) {
       obs.add(o);
     }
   }

   deleteObserver(Observer o) {
     obs.remove(o);
   }

  notifyObservers(Observer observer, BaseBean data, String scene) {
    notifyAllObservers(null, scene);
  }

   notifyObserver(Observer? observer, BaseBean data, String scene) {
      if(obs.contains(observer)) {
        observer?.update(this, data, scene);
      }
   }


   notifyAllObservers(BaseBean? arg, String scene) {
     List<dynamic> arrLocal;
     if (!this.change) {
       return;
     }
     arrLocal = obs;
     this.clearChanged();
     for (var i = arrLocal.length - 1; i>= 0; i--) {
       (arrLocal[i] as Observer).update(this, arg ?? BaseBean(success: false), scene);
     }
   }

   deleteObservers() {
     obs.removeRange(0, obs.length);
   }

   clearChanged() {
     this.change = false;
   }

   setChanged() {
     this.change = true;
   }

   bool hasChanged() {
     return this.change;
   }

   int countObservers() {
     return obs.length;
   }


}