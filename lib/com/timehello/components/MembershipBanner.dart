import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';

class MembershipBanner extends StatelessWidget {
  Function? onTapCallback;

  MembershipBanner({this.onTapCallback});

  @override
  Widget build(BuildContext context) {
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
              '会员专享功能，示例数据仅供参考',
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
              '立即升级',
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