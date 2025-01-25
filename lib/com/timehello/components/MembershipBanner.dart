import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';

class MembershipBanner extends StatelessWidget {
  Function? onTapCallback;
  SizeEnum sizeEnum = SizeEnum.large;

  MembershipBanner({this.onTapCallback, this.sizeEnum = SizeEnum.large});

  @override
  Widget build(BuildContext context) {
    if (this.sizeEnum == SizeEnum.small) {
      return Container(
          width: 300,
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border.all(color: ColorsConfig.colorGold, width: 1.0),
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(children: [
            Utility.getSVGPicture(R.assetsImgIcVipCrown, size: 24),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                getI18NKey().vip_exclusive_small,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                this.onTapCallback?.call();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  getI18NKey().upgrade_now,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ]));
    } else {
      return Container(
        width: 600,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: ColorsConfig.colorGold, width: 1.0),
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Utility.getSVGPicture(R.assetsImgIcVipCrown, size: 24),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                getI18NKey().vip_exclusive,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onPressed: () {
                // TODO: 添加跳转到升级页面的逻辑
                this.onTapCallback?.call();
              },
              child: Text(
                getI18NKey().upgrade_now,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
