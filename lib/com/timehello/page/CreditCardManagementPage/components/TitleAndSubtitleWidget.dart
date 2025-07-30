// 竖着排列 标题 999999 ,标题右边可以添加一个widget
// 子标题 333333

import 'package:flutter/cupertino.dart';

class TitleAndSubtitleWidget extends StatelessWidget {
  String title;
  String subtitle;
  Widget? rightWidget;

  TitleAndSubtitleWidget(
      {Key? key, required this.title, required this.subtitle, this.rightWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Text(
                    title,
          textAlign: TextAlign.center,
                    style:
                        const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xff404040)),
                  ),
                  if (rightWidget != null) rightWidget!,
                ],
              ),
              Wrap(
                children: [
                  Container(
                    width: 300,
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 16, color: Color(0xff999999)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
