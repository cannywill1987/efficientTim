//根据file现实标题 下面时间 右边 size

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class FileWidget extends StatelessWidget {
  final File file;
  final int createTime;
  const FileWidget({required this.file, this.createTime = 0});

  build(BuildContext context) {
    // 黑色边框
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ThemeManager.getInstance().isDark() ? Colors.white : CupertinoColors.systemGrey4,
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(file.path),
              Text(file.lastModifiedSync().toString()),
            ],
          ),
          Spacer(),
          Text(file.lengthSync().toString())
        ],
      ),
    );
  }

}