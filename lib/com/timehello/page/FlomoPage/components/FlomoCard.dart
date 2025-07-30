// 圆角卡片 包含一个child Widget 用于显示内容 一个decoration 用于设置圆角卡片的样式 一个BoxShadow 用于设置阴影 两行 第一行左侧是text标题 右侧是一个rightChild容器，左右边距10，上下边距5， 第二行放childWidget hild widget 内边距 10
import 'package:flutter/material.dart';

class FlomoCard extends StatelessWidget {
  final Widget child;
  final Widget? rightChild;
  final String title;

  const FlomoCard({required this.child,  this.rightChild, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title),
                Spacer(),
                this.rightChild == null ? SizedBox.shrink() : Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: rightChild,
                ),
              ],
            ),
            SizedBox(height: 10,),
            child,
          ],
        ),
      ),
    );
  }
}
