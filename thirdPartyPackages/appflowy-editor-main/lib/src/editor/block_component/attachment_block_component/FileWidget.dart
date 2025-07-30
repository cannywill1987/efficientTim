//根据file现实标题 下面时间 右边 size

import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FileWidget extends StatelessWidget {
  final PlatformFile file;
  final int createTime;
  const FileWidget({required this.file, this.createTime = 0});

  build(BuildContext context) {
    // 黑色边框
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 1,
          color: Colors.black,

        ),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(file.name),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //
          //     // Text(file.xFile.toString()),
          //   ],
          // ),
          Spacer(),
          Text(formatBytes(file.size), style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  static String formatBytes(int size, [int fractionDigits = 2]) {
    if (size <= 0) return '0 B';
    final multiple = (log(size) / log(1024)).floor();
    return '${(size / pow(1024, multiple)).toStringAsFixed(fractionDigits)} ${[
      'B',
      'kB',
      'MB',
      'GB',
      'TB',
      'PB',
      'EB',
      'ZB',
      'YB',
    ][multiple]}';
  }

}