import 'package:time_hello/com/timehello/util/TextUtil.dart';

class EditFormat {
   static String getNoblanKString(String ed) {
    if (TextUtil.isEmpty(ed)) {
      return "";
    }
    return ed.replaceAll(' ', '');
  }
}