import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../common/httpclient/HttpManager.dart';
import '../config/Params.dart';
import '../util/AliyunStoreManager.dart';
import '../util/Utility.dart';

class ImagesWrapperWidget extends StatefulWidget {
  // List? listImages = [];
  List<String>? listBigImages = [];
  // List<String>? listBigImages = [];
  // List<String>? listOriginImages = [];
  Function? onChange;
  bool isEditable;
  ImagesWrapperWidget(
      {
        // this.listImages,
        this.isEditable = true,
      this.listBigImages,
      // this.listBigImages,
      // this.listOriginImages,
      this.onChange});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ImagesWrapperWidgetState(this.onChange,
        // listImages: listImages ?? [],
        listSmallImages: listBigImages ?? [],
        // listBigImages: listBigImages ?? [],
        // listOriginImages: listOriginImages ?? []
    );
  }
}

class ImagesWrapperWidgetState extends State<ImagesWrapperWidget> {
  // List listImages = [];
  List<String> listSmallImages = [];
  // List<String> listBigImages = [];
  // List<String> listOriginImages = [];
  bool isUploading = false;

  ImagesWrapperWidgetState(Function? onChange,
      {
        // required this.listImages,
      required this.listSmallImages,
      // required this.listBigImages,
      // required this.listOriginImages
      });

  @override
  void didUpdateWidget(ImagesWrapperWidget oldWidget) {
    this.listSmallImages = this.widget.listBigImages ?? [];
    // this.listBigImages = this.widget.listBigImages ?? [];
    // this.listOriginImages = this.widget.listOriginImages ?? [];

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 10, // 设置图片之间的间距
        runSpacing: 10, // 设置行之间的间距
        children: List.generate(this.listSmallImages.length + 1, (index) {
          if (index == this.listSmallImages.length) {
            if (this.listSmallImages.length == 0) {
              return Align(alignment: Alignment.topLeft, child: getPlusItem());
            } else {
              return getPlusItem();
            }
          } else {
            return getItem(index, context);
          }
        }),
      ),
    );
  }

  Widget getPlusItem() {
    if(this.widget.isEditable == false) {
      return SizedBox.shrink();
    }
    return GestureDetector(
      onTap: isUploading
          ? null
          : () {
              // 在这里处理点击事件
              this.onClickToUploadPicture(context);
            },
      child: Container(
        width: 80,
        // 设置图片宽度
        height: 120,
        // 设置图片高度
        margin: EdgeInsets.all(2),
        // 设置边距为2px
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), // 设置圆角为6px
          border: Border.all(color: ThemeManager.getInstance().getColor(defaultColor: Color(0xFF999999)), width: 2), // 添加2px厚的边框
          color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white), // 设置颜色值为#999999
        ),
        child: isUploading
            ? CupertinoActivityIndicator()
            : Icon(
                Icons.add, // 设置+号icon
                color: ThemeManager.getInstance().getIconColor(defaultColor: Color(0xFF999999)), // 设置icon颜色为#999999
              ),
      ),
    );
  }

  InkWell getItem(int index, BuildContext context) {
    return InkWell(
      onTap: () {
        // 打开图片浏览器
        MultiImageProvider multiImageProvider = MultiImageProvider(
            Utility.getImageProviderFromList(listSmallImages),
            initialIndex: index);
        showImageViewerPager(context, multiImageProvider,
            swipeDismissible: true, doubleTapZoomable: true);
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: Utility.filterHttpUrl(this.listSmallImages[index], prefix: "oss"),
            width: 80, // 设置图片宽度
            height: 120, // 设置图片高度
            fit: BoxFit.cover,
          ),
          this.widget.isEditable == false ? SizedBox.shrink() : Positioned(
            top: 5,
            right: 5,
            child: InkWell(
              onTap: () {
                // 在这里处理点击删除事件
                // 在这里处理点击删除事件
                setState(() {
                  // listImages.removeAt(index);
                  listSmallImages.removeAt(index);
                  // listBigImages.removeAt(index);
                  // listOriginImages.removeAt(index);
                  if (this.widget.onChange != null) {
                    this.widget.onChange!(
                        listSmallImages, listSmallImages, listSmallImages);
                  }
                });
              },
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * PC端更换头像
   */
  void onClickToUploadPicture(BuildContext context) async {
    //编辑模式
    showLoading();
    List<XFile>? files;
    if(Utility.isMacOS() || Utility.isWindows()) {
     files = await Utility.pickMultiFiles();
    } else {
      files = await Utility.pickImageWithXFileList();
    }
    hideLoading();
    if (files == null) {
      return;
    }
    double fileSize = await Utility.getFilesSizes(files);

    if (fileSize > 5 * 1024) {
      // 显示提示
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(getI18NKey().remind),
            content: Text(getI18NKey().max_5m_files_size),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(getI18NKey().confirm),
              ),
            ],
          );
        },
      );
      return;
    }
    showLoading();
    // 检查文件大小
    // List<Future> list = [];
    for (int i = 0; i < files.length; i++) {
      XFile item = files[i];
      File file = await File(item.path);
      // BaseBean res = await ;
      // list.add(HttpManager.getInstance()
      //     .uploadImage(key: "key", file: file, url: Apis.uploadOss));

      // final file = File(path);
      String fileName = Utility.getUUID();
      XFile xfile = await Utility.compressAndGetFile(file: file);
      // TaskSnapshot res = await FirebaseStoreManager.getInstance().uploadFile(path: xfile.path, fileName: fileName);
      // String downloadUrl = await FirebaseStoreManager.getInstance().getDownloadUrl(fileName: fileName);
      String url = await AliyunStoreManager.getInstance()
          .uploadFileByFilePath(path: xfile.path, fileName: fileName);
      listSmallImages.add(url);
    }

    // await Future.wait(list).then((value) {
      // for (int i = 0; i < value.length; i++) {
      //   Map<String, dynamic> obj = value[i].data;
      //   // listImages.add(obj);
      //
      //   // listBigImages.add(obj['bigImage']!);
      //   // listOriginImages.add(obj['originImage']!);
      // }
      hideLoading();
      setState(() {
        if (this.widget.onChange != null)
          this.widget.onChange!(
              listSmallImages, listSmallImages, listSmallImages);
      });
    // }).catchError((e) {
    //   hideLoading();
    // });
  }

  void hideLoading() {
    setState(() {
      isUploading = false;
    });
  }

  void showLoading() {
    setState(() {
      isUploading = true;
    });
  }
}
