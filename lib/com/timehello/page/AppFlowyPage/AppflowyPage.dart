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
// import 'package:time_hello/com/timehello/util/FirebaseStoreManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:universal_html/html.dart' as html;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../config/ENUMS.dart';
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

  const AppflowyPage({super.key, this.fileName = 'example1111123'});

  // @override
  // State<HomePage> createState() => _HomePageState();

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _HomePageState();
  }
}

class _HomePageState extends BaseWidgetState<AppflowyPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  EditorEditModeEnum editModeEnum = EditorEditModeEnum.normal;
  WidgetBuilder? _widgetBuilder;
  late EditorState _editorState;
  late Future<String> _jsonString;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    this.initData();
  }

  // void updateEditMode(EditorEditModeEnum editModeEnum) {
  //   if (this.editModeEnum != editModeEnum) {
  //     this.editModeEnum = editModeEnum;
  //     if (mounted) setState(() {});
  //   }
  // }

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

  Function func = Utility.debounceWith((_HomePageState state) async {
    state.isLoading = true;
    state.updateUI();
    String s =
        await state._exportFile(state._editorState, ExportFileType.markdown);
    await AliyunStoreManager.getInstance()
        .setString(data: s, fileName: state.widget.fileName);
    // String mkString = await FirebaseStoreManager.getInstance()
    //     .getString(fileName: state.widget.fileName, defaultVal: "");
    state.isLoading = false;
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
    String mkString = await AliyunStoreManager.getInstance()
        .getString(fileName: this.widget.fileName, defaultVal: "");

    if (TextUtil.isEmpty(mkString.trim())) {
      _loadEditor(
          context,
          Future<String>.value(jsonEncode(
            EditorState.blank(withInitialText: true).document.toJson(),
          ).toString()));
    } else {
      _jsonString = getFileJsonString(ExportFileType.markdown, mkString);
      _loadEditor(context, _jsonString);
    }
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
          if(isLoading)
          Positioned(
            right: 10,
            top: 10,
            child: LoadingAnimationWidget.twistingDots(
              // leftDotColor: const Color(0xFF1A1A3F),
              // rightDotColor: const Color(0xFFEA3799),
              size: 15, leftDotColor: Colors.blue, rightDotColor: Colors.red,
            ),
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
              onUploadCallback: (path) async {
                try {
                  // final appDocDir = await getApplicationDocumentsDirectory();
                  isLoading = true;
                  updateUI();
                  final file = File(path);
                  String fileName = Utility.getUUID();
                  XFile xfile = await Utility.compressAndGetFile(file: file);
                  // TaskSnapshot res = await FirebaseStoreManager.getInstance().uploadFile(path: xfile.path, fileName: fileName);
                  // String downloadUrl = await FirebaseStoreManager.getInstance().getDownloadUrl(fileName: fileName);
                  String url = await AliyunStoreManager.getInstance().uploadFile(path: xfile.path, fileName: fileName);
                  // await AliyunStoreManager.getInstance().getDownloadUrl(fileName: fileName);
                  // BaseBean res = await HttpManager.getInstance().uploadImage(
                  //     key: "key",
                  //     file: new File(xfile.path),
                  //     url: Apis.uploadOss);
                  //上传图片
                  // uploadPic(xfile);
                  isLoading = false;
                  updateUI();
                  // return res.data['bigImage'];
                  return url;
                } catch (e) {
                  print(e);
                  isLoading = false;
                  updateUI();
                  return "";
                }
              },
              onEditorStateChange: (editorState) {
                _editorState = editorState;
                // updateEditMode(EditorEditModeEnum.editing);
                func(this);
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
