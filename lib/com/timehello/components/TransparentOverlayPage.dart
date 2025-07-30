import 'dart:ui';

import 'package:flutter/material.dart';

import 'MembershipBanner.dart';

class TransparentOverlayPage extends StatelessWidget {
  Function? onTapCallback;

  TransparentOverlayPage({this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          // 背景的模糊效果
          Container(
            // color: Colors.red,
            color: Colors.black.withOpacity(0.5), // 半透明背景
          ),
          // 中间的组件
          Align(
            alignment: Alignment(0, 0.8),
            child: MembershipBanner(onTapCallback: () {
              this.onTapCallback?.call();
            },),
          ),
        ],
    );
  }
}
