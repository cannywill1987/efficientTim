//白色容器 带有圆角 可以放一个child widget

import 'package:flutter/material.dart';

class CreditCardContainer extends StatelessWidget {
  final Widget child;
  double minHeight;
  double padding;
   CreditCardContainer({Key? key, this.padding = 5,this.minHeight = 20, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding:  EdgeInsets.only(left: padding, right: padding, top: padding, bottom: padding),
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }

}