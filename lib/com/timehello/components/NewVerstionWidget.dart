//做一个NewVerstionWidget组件
// 1.组件的作用：显示404040的当前版本号，检测是否有新版本，如果有新版本，右上角显示一个 圆角红色背景 白色底的neww文字
// 2.组件的属性：当前版本号，新版本号 版本号格式是 xx.xx.xx，前后版本进行比较

import 'package:flutter/material.dart';

class NewVerstionWidget extends StatelessWidget {
  final String currentVersion;
  final String newVersion;
  final Widget child;
  final bool shouldShowRedDotParam;
  NewVerstionWidget({Key? key, required this.shouldShowRedDotParam, required this.child, required this.currentVersion, required this.newVersion}) : super(key: key);

  bool shouldShowRedDot() {
    if(shouldShowRedDotParam == true) {
      try {
        List<String> currentVersionList = currentVersion.split('.');
        List<String> newVersionList = newVersion.split('.');
        if (currentVersionList.length != 3 || newVersionList.length != 3) {
          return false;
        }
        for (int i = 0; i < 3; i++) {
          int currentVersionNum = int.parse(currentVersionList[i]);
          int newVersionNum = int.parse(newVersionList[i]);
          if (newVersionNum > currentVersionNum) {
            return true;
          }
        }
        return false;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Padding(padding: EdgeInsets.all(4),
        child: child),
        if(shouldShowRedDot() == true)
        Positioned(
          top: 3,
          right: 0,
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4)
            ),
          ),
        )
      ],
    );

// return Container(
//       child: Text('$currentVersion', style: TextStyle(color: Colors.white, fontSize: 12),
//     )
// );
  }

}