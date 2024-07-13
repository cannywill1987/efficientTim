import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/page/AppFlowyPage/pages/editor.dart';
import 'package:time_hello/com/timehello/util/AliyunStoreManager.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';

// import 'package:time_hello/com/timehello/util/FirebaseStoreManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:universal_html/html.dart' as html;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../config/ENUMS.dart';
import 'AppFlowyPage2.dart';
import 'pages/auto_complete_editor.dart';
import 'pages/collab_editor.dart';
import 'pages/collab_selection_editor.dart';
import 'pages/customize_theme_for_editor.dart';
import 'pages/editor_list.dart';
import 'pages/fixed_toolbar_editor.dart';
import 'pages/focus_example_for_editor.dart';

enum ExportFileType {
  documentJson,
  markdown,
  html,
  delta,
}

extension on ExportFileType {
  String get extension {
    switch (this) {
      case ExportFileType.documentJson:
      case ExportFileType.delta:
        return 'json';
      case ExportFileType.markdown:
        return 'md';
      case ExportFileType.html:
        return 'html';
    }
  }
}

class AppflowyPage extends BaseWidget {
  final String fileName;
  final bool isDebug;
  const AppflowyPage({super.key, this.isDebug = false, this.fileName = 'example1111123'});

  // @override
  // State<HomePage> createState() => _HomePageState();

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return AppflowyPageState();
  }
}

class AppflowyPageState extends BaseWidgetState<AppflowyPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  EditorEditModeEnum editModeEnum = EditorEditModeEnum.normal;
  WidgetBuilder? _widgetBuilder;
  late EditorState _editorState;
  late Future<String> _jsonString;
  String? topText;
  // bool isLoading = false;
  bool isEnable = false;
  LoadingStatusEnum loadingStatusEnum = LoadingStatusEnum.normal;
  @override
  void initState() {
    super.initState();
    this.initData();
    this.forceAppBarVisible = false;
    this.isAppBarVisible = false;
  }

  // void updateEditMode(EditorEditModeEnum editModeEnum) {
  //   if (this.editModeEnum != editModeEnum) {
  //     this.editModeEnum = editModeEnum;
  //     if (mounted) setState(() {});
  //   }
  // }

  setEnable() {
    Future.delayed(Duration(milliseconds: 1000), () {
      this.isEnable = true;
      updateUI();
    });
  }

  resetTip() {
    Future.delayed(Duration(milliseconds: 3000), () {
      this.loadingStatusEnum = LoadingStatusEnum.normal;
      updateUI();
    });
  }

  @override
  void didUpdateWidget(AppflowyPage oldWidget) {
    //如果有新数据会走这里 加了页面刷新数据会被清空
    if (this.widget.fileName != oldWidget.fileName) {
      this.isEnable = false;
      // setEnable();
      initData();
    }
    // blackButtonListForReading = this.getWQBEditTypeModelList();
  }

  Future<String> getFileJsonString(
      ExportFileType fileType, String plainText) async {
    var jsonString = '';
    switch (fileType) {
      case ExportFileType.documentJson:
        jsonString = plainText;
        break;
      case ExportFileType.markdown:
        jsonString = jsonEncode(markdownToDocument(plainText).toJson());
        break;
      case ExportFileType.delta:
        final delta = Delta.fromJson(jsonDecode(plainText));
        final document = quillDeltaEncoder.convert(delta);
        jsonString = jsonEncode(document.toJson());
        break;
      case ExportFileType.html:
        throw UnimplementedError();
    }
    return jsonString;
  }

  setLoadingStatusEnum(LoadingStatusEnum loadingStatusEnum, [String? text]) {
    if(loadingStatusEnum == LoadingStatusEnum.success) {
      resetTip();
    }
    if (this.loadingStatusEnum != loadingStatusEnum) {
      this.loadingStatusEnum = loadingStatusEnum;
      this.topText = text;
      updateUI();
    }
  }

  Function funcDebounce = Utility.debounceWith((AppflowyPageState state) async {
    // state.isLoading = true;
    state.setLoadingStatusEnum(LoadingStatusEnum.loading);
    state.updateUI();
    try {
      await AliyunStoreManager.getInstance()
          .setString(docType: DocType.document, fileExtensionEnum: FileExtension.json, data: await state._exportFile(state._editorState, ExportFileType.documentJson), fileName: state.widget.fileName);
       AliyunStoreManager.getInstance()
          .setString(data: await state._exportFile(state._editorState, ExportFileType.markdown), fileName: state.widget.fileName);
      // String mkString = await FirebaseStoreManager.getInstance()
      //     .getString(fileName: state.widget.fileName, defaultVal: "");
      // state.setLoadingStatusEnum(LoadingStatusEnum.normal);
      state.setLoadingStatusEnum(LoadingStatusEnum.success, getI18NKey().save_success);
    } catch(e) {
      state.setLoadingStatusEnum(LoadingStatusEnum.error, getI18NKey().save_fail);
    }
    print("upload success");
    // missionModel.message = val;
    // String valTrim = val.trim();
    // state.updateEditMode(EditorEditModeEnum.saving);
    // MongoDbUpdated? update = await MongoApisManager.getInstance()
    //     .update_MissionModel(missionModel: missionModel, shouldQueryMissionModel: false);
    // // CounterMethodChannelManager.getInstance()
    // //     .storeWQBNoteMissionData(missionModel);
    // if (update != null) {
    state.updateUI();
    // } else {
    //   state.updateEditMode(EditorEditModeEnum.saved_fail);
    // }
  }, Duration(milliseconds: 3000));

  initData() async {
    this.isEnable = false;
    if(this.widget.isDebug) {
      _jsonString = PlatformExtension.isDesktopOrWeb
          ? rootBundle.loadString('assets/appFlowyDemo/example.json')
          : rootBundle.loadString('assets/appFlowyDemo/mobile_example.json');
      _widgetBuilder = (context) => Editor(
        jsonString: _jsonString,
        onEditorStateChange: (editorState) {
          _editorState = editorState;
        },
      );
    } else {
      Map? json;
      try {
        json = await AliyunStoreManager.getInstance()
            .getJSON(docType: DocType.document, fileExtensionEnum: FileExtension.json, fileName: this.widget.fileName, defaultVal: "");

      } catch (e) {
        json = null;
        // setLoadingStatusEnum(
        //     LoadingStatusEnum.error, getI18NKey().download_fail);
        print(e);
      }
      if (json == null) {
        _loadEditor(
            context,
            Future<String>.value(jsonEncode(
              EditorState
                  .blank(withInitialText: true)
                  .document
                  .toJson(),
            ).toString()));
      } else {
        // _jsonString = getFileJsonString(ExportFileType.documentJson, mkString);
        _loadEditor(context, Future<String>.value(jsonEncode(json!)));
      }
    }
      setEnable();
  }

  @override
  void reassemble() {
    super.reassemble();
    print("reassemble");
    // _widgetBuilder = (context) => Editor(
    //       jsonString: _jsonString,
    //       onEditorStateChange: (editorState) {
    //         _editorState = editorState;
    //         _jsonString = Future.value(
    //           jsonEncode(_editorState.document.toJson()),
    //         );
    //       },
    //     );
  }

  Widget baseBuild(BuildContext context) {
    if (_widgetBuilder != null) {
      return Stack(
        children: [
          _widgetBuilder!(context),
          if (this.loadingStatusEnum != LoadingStatusEnum.normal)
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0x88000000),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: getTipWidget()),
            ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoadingAnimationWidget.twistingDots(
                // leftDotColor: const Color(0xFF1A1A3F),
                // rightDotColor: const Color(0xFFEA3799),
                size: 40, leftDotColor: Colors.blue, rightDotColor: Colors.red,
              )
            ],
          ),
        ],
      );
    }
  }

  Widget getTipWidget() {
    if(this.loadingStatusEnum == LoadingStatusEnum.loading) {
      return LoadingAnimationWidget.twistingDots(
        size: 15, leftDotColor: Colors.blue, rightDotColor: Colors.red,
      );
    } else if (this.loadingStatusEnum == LoadingStatusEnum.error) {
      return InkWell(
        onTap: () {
          funcDebounce(this);
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.refresh, color: Colors.red, size: 15),
            SizedBox(width: 2,),
            Text(this.topText ?? "error", style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      );
    } else if (this.loadingStatusEnum == LoadingStatusEnum.success) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(Icons.check, color: Colors.green, size: 15),
          SizedBox(width: 2,),
          Text(this.topText ?? "success", style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      );
    }
    return SizedBox.shrink();
  }

  /**
   * 侧边栏选择后更新的editor
   */
  Future<void> _loadEditor(
    BuildContext context,
    Future<String> jsonString, {
    TextDirection textDirection = TextDirection.ltr,
  }) async {
    final completer = Completer<void>();
    _jsonString = jsonString;
    setState(
      () {
        _widgetBuilder = (context) => Editor(
              jsonString: _jsonString,
            onAttachmentUploadCallback: (path) async {
              try {
                // final appDocDir = await getApplicationDocumentsDirectory();
                // isLoading = true;
                setLoadingStatusEnum(LoadingStatusEnum.loading);
                updateUI();
                final file = File(path);
                // String fileName = Utility.getUUID();
                // XFile xfile = await Utility.compressAndGetFile(file: file);
                // TaskSnapshot res = await FirebaseStoreManager.getInstance().uploadFile(path: xfile.path, fileName: fileName);
                // String downloadUrl = await FirebaseStoreManager.getInstance().getDownloadUrl(fileName: fileName);
                String url = await AliyunStoreManager.getInstance()
                    .uploadFile(file: file);
                // await AliyunStoreManager.getInstance().getDownloadUrl(fileName: fileName);
                // BaseBean res = await HttpManager.getInstance().uploadImage(
                //     key: "key",
                //     file: new File(xfile.path),
                //     url: Apis.uploadOss);
                //上传图片
                // uploadPic(xfile);
                // isLoading = false;
                setLoadingStatusEnum(LoadingStatusEnum.normal);
                updateUI();
                // return res.data['bigImage'];
                return url;
              } catch (e) {
                print(e);
                // isLoading = false;
                setLoadingStatusEnum(LoadingStatusEnum.normal);
                updateUI();
                return "";
              }
            },
              onUploadCallback: (path) async {
                try {
                  // final appDocDir = await getApplicationDocumentsDirectory();
                  // isLoading = true;
                  setLoadingStatusEnum(LoadingStatusEnum.loading);
                  updateUI();
                  final file = File(path);
                  String fileName = Utility.getUUID();
                  XFile xfile = await Utility.compressAndGetFile(file: file);
                  // TaskSnapshot res = await FirebaseStoreManager.getInstance().uploadFile(path: xfile.path, fileName: fileName);
                  // String downloadUrl = await FirebaseStoreManager.getInstance().getDownloadUrl(fileName: fileName);
                  String url = await AliyunStoreManager.getInstance()
                      .uploadFileByFilePath(path: xfile.path, fileName: fileName);
                  // await AliyunStoreManager.getInstance().getDownloadUrl(fileName: fileName);
                  // BaseBean res = await HttpManager.getInstance().uploadImage(
                  //     key: "key",
                  //     file: new File(xfile.path),
                  //     url: Apis.uploadOss);
                  //上传图片
                  // uploadPic(xfile);
                  // isLoading = false;
                  setLoadingStatusEnum(LoadingStatusEnum.normal);
                  updateUI();
                  // return res.data['bigImage'];
                  return url;
                } catch (e) {
                  print(e);
                  // isLoading = false;
                  setLoadingStatusEnum(LoadingStatusEnum.normal);
                  updateUI();
                  return "";
                }
              },
              onEditorStateChange: (editorState) {
                _editorState = editorState;
                // updateEditMode(EditorEditModeEnum.editing);
                if (this.isEnable == false) {
                  return;
                }
                if (
                    LoginManager.isLogin() == false) {
                  LoginManager.getInstance()
                      .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
                  return;
                }
                funcDebounce(this);
              },
              textDirection: textDirection,
            );
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      completer.complete();
    });
    return completer.future;
  }

  Future<String> _exportFile(
    EditorState editorState,
    ExportFileType fileType,
  ) async {
    var result = '';

    switch (fileType) {
      case ExportFileType.documentJson:
        result = jsonEncode(editorState.document.toJson());
        break;
      case ExportFileType.markdown:
        result = documentToMarkdown(editorState.document);
        break;
      case ExportFileType.html:
      case ExportFileType.delta:
        throw UnimplementedError();
    }
    return result;
  }
}
