import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';

class EmptyWidget extends StatelessWidget{
  String? text;
  EmptyWidget({this.text});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // ic_no_data.svg
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Utility.getSVGPicture(R.assetsImgIcNoData, size: 100),
        SizedBox(height: 10,),
        Text(this.text ?? getI18NKey().no_data, style: TextStyle(fontSize: 16, color: Color(0xff999999)),)
      ],
    );
  }

}