import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/page/loginPage/components/Guide3Widget.dart';
import 'package:time_hello/com/timehello/page/loginPage/components/Guide4Widget.dart';

import 'Guide1Widget.dart';
import 'Guide2Widget.dart';

class GuideViewPageWidget extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GuideViewPageWidgetState();
  }

}

class GuideViewPageWidgetState extends State<GuideViewPageWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;
  int size = 4;
  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }


  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    const duration = Duration(seconds: 3);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage >= size) {
          // Assuming there are 3 pages
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: size, // Replace with the actual number of items
      itemBuilder: (context, index) {
        // Replace with your actual image widgets
        return Container(
          color: Color(0xffe1e6f6),
          child: index == 0 ? Guide1Widget() : index == 1 ? Guide2Widget() : index == 2 ? Guide3Widget(): index == 3 ? Guide4Widget() : SizedBox.shrink(),
        );
      },
    );
  }
}