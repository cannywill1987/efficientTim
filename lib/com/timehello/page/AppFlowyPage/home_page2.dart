import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/page/AppFlowyPage/pages/editor.dart';
import 'package:time_hello/com/timehello/util/FirebaseStoreManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:universal_html/html.dart' as html;

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

class HomePage extends BaseWidget {
  final String fileName;

  const HomePage({super.key, this.fileName = 'example11123'});

  // @override
  // State<HomePage> createState() => _HomePageState();

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _HomePageState();
  }
}

class _HomePageState extends BaseWidgetState<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  EditorEditModeEnum editModeEnum = EditorEditModeEnum.normal;
  late WidgetBuilder _widgetBuilder;
  late EditorState _editorState;
  late Future<String> _jsonString;

  @override
  void initState() {
    super.initState();
    this.initData();
    // _jsonString = PlatformExtension.isDesktopOrWeb
    //     ? rootBundle.loadString('assets/appFlowyDemo/example.json')
    //     : rootBundle.loadString('assets/appFlowyDemo/mobile_example.json');

    // _widgetBuilder = (context) => Editor(
    //   jsonString: _jsonString,
    //   editorStyle: EditorStyle(
    //       padding: EdgeInsets.all(16),
    //       cursorColor: Colors.red,
    //       dragHandleColor: Colors.red,
    //       selectionColor: const Color.fromARGB(53, 111, 201, 231),
    //       textStyleConfiguration: const TextStyleConfiguration(
    //         text: TextStyle(fontSize: 16, color: Colors.black),
    //       ),
    //       textSpanDecorator: (BuildContext context, Node node, int index,
    //           TextInsert text, TextSpan before, TextSpan after) {
    //         return TextSpan(
    //             text: text.text,
    //             style: const TextStyle(fontSize: 16, color: Colors.black));
    //       },
    //       defaultTextDirection: 'ltr',
    //       magnifierSize: const Size(72, 48),
    //       mobileDragHandleBallSize: const Size(8, 8),
    //       mobileDragHandleWidth: 2.0,
    //       cursorWidth: 2.0,
    //       enableHapticFeedbackOnAndroid: true,
    //       textScaleFactor: 1.0),
    //   onEditorStateChange: (editorState) {
    //     _editorState = editorState;
    //   },
    // );
  }

  void updateEditMode(EditorEditModeEnum editModeEnum) {
    if (this.editModeEnum != editModeEnum) {
      this.editModeEnum = editModeEnum;
      if (mounted)
      setState(() {});
    }
  }

  Function func = Utility.debounceWith((_HomePageState state) async {
    String s = await state._exportFile(state._editorState, ExportFileType.documentJson);
    await FirebaseStoreManager.getInstance().setString(data: s, fileName: state.widget.fileName);
    print("result");
    // missionModel.message = val;
    // String valTrim = val.trim();
    // state.updateEditMode(EditorEditModeEnum.saving);
    // MongoDbUpdated? update = await MongoApisManager.getInstance()
    //     .update_MissionModel(missionModel: missionModel, shouldQueryMissionModel: false);
    // // CounterMethodChannelManager.getInstance()
    // //     .storeWQBNoteMissionData(missionModel);
    // if (update != null) {
    state.updateEditMode(EditorEditModeEnum.saved_success);
    // } else {
    //   state.updateEditMode(EditorEditModeEnum.saved_fail);
    // }

  }, Duration(milliseconds: 3000));

  initData() {
    _jsonString = FirebaseStoreManager.getInstance().getString(
        fileName: this.widget.fileName,
        defaultVal: jsonEncode(
          EditorState.blank(withInitialText: true).document.toJson(),
        ).toString());
    _loadEditor(context, _jsonString);
    //默认进来的页面
    // _widgetBuilder = (context) => Editor(
    //   jsonString: _jsonString,
    //   onEditorStateChange: (editorState) {
    //     _editorState = editorState;
    //     _exportFile(_editorState, ExportFileType.markdown);
    //   },
    // );
  }

  @override
  void reassemble() {
    super.reassemble();

    _widgetBuilder = (context) => Editor(
          jsonString: _jsonString,
          onEditorStateChange: (editorState) {
            _editorState = editorState;
            _jsonString = Future.value(
              jsonEncode(_editorState.document.toJson()),
            );
          },
        );
  }

  Widget baseBuild(BuildContext context) {
    return _widgetBuilder(context);
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     key: _scaffoldKey,
  //     extendBodyBehindAppBar: PlatformExtension.isDesktopOrWeb,
  //     drawer: _buildDrawer(context),
  //     appBar: AppBar(
  //       backgroundColor: const Color.fromARGB(255, 134, 46, 247),
  //       foregroundColor: Colors.white,
  //       surfaceTintColor: Colors.transparent,
  //       title: const Text('AppFlowy Editor'),
  //     ),
  //     body: SafeArea(
  //       maintainBottomViewPadding: true,
  //       child: _widgetBuilder(context),
  //     ),
  //   );
  // }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: Image.asset(
              'assets/appFlowyDemo/images/icon.jpeg',
              fit: BoxFit.fill,
            ),
          ),

          // AppFlowy Editor Demo
          _buildSeparator(context, 'AppFlowy Editor Demo'),
          _buildListTile(context, 'With Example.json', () {
            final jsonString = PlatformExtension.isDesktopOrWeb
                ? rootBundle.loadString('assets/appFlowyDemo/example.json')
                : rootBundle
                    .loadString('assets/appFlowyDemo/mobile_example.json');
            _loadEditor(context, jsonString);
          }),
          _buildListTile(context, 'With Large Document (10000+ lines)', () {
            final nodes = List.generate(
              10000,
              (index) =>
                  paragraphNode(text: '$index ${generateRandomString(50)}'),
            );
            final editorState = EditorState(
              document: Document(root: pageNode(children: nodes)),
            );
            final jsonString = Future.value(
              jsonEncode(editorState.document.toJson()),
            );
            _loadEditor(context, jsonString);
          }),
          _buildListTile(context, 'With Example.html', () async {
            final htmlString =
                await rootBundle.loadString('assets/appFlowyDemo/example.html');
            final html = htmlToDocument(htmlString);
            // final html = HTMLToNodesConverter(htmlString).toDocument();
            final jsonString = Future<String>.value(
              jsonEncode(
                html.toJson(),
              ).toString(),
            );
            if (context.mounted) {
              _loadEditor(context, jsonString);
            }
          }),
          _buildListTile(context, 'With Empty Document', () {
            final jsonString = Future<String>.value(
              jsonEncode(
                EditorState.blank(withInitialText: true).document.toJson(),
              ).toString(),
            );
            _loadEditor(context, jsonString);
          }),

          // Theme Demo
          _buildSeparator(context, 'Showcases'),
          _buildListTile(context, 'Auto complete Editor', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AutoCompleteEditor(),
              ),
            );
          }),
          _buildListTile(context, 'Collab Editor', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CollabEditor(),
              ),
            );
          }),
          _buildListTile(context, 'Collab Selection', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CollabSelectionEditor(),
              ),
            );
          }),
          _buildListTile(context, 'Custom Theme', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomizeThemeForEditor(),
              ),
            );
          }),
          _buildListTile(context, 'RTL', () {
            final jsonString = rootBundle.loadString(
              'assets/appFlowyDemo/arabic_example.json',
            );
            _loadEditor(
              context,
              jsonString,
              textDirection: TextDirection.rtl,
            );
          }),
          _buildListTile(context, 'Focus Example', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FocusExampleForEditor(),
              ),
            );
          }),
          _buildListTile(context, 'Editor List', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditorList(),
              ),
            );
          }),
          _buildListTile(context, 'Fixed Toolbar', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FixedToolbarExample(),
              ),
            );
          }),

          // Encoder Demo
          _buildSeparator(context, 'Export To X Demo'),
          _buildListTile(context, 'Export To JSON', () {
            _exportFile(_editorState, ExportFileType.documentJson);
          }),
          _buildListTile(context, 'Export to Markdown', () {
            _exportFile(_editorState, ExportFileType.markdown);
          }),

          // Decoder Demo
          _buildSeparator(context, 'Import From X Demo'),
          _buildListTile(context, 'Import From Document JSON', () {
            _importFile(ExportFileType.documentJson);
          }),
          _buildListTile(context, 'Import From Markdown', () {
            _importFile(ExportFileType.markdown);
          }),
          _buildListTile(context, 'Import From Quill Delta', () {
            _importFile(ExportFileType.delta);
          }),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String text,
    VoidCallback? onTap,
  ) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 16),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 14,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
    );
  }

  Widget _buildSeparator(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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

    // FirebaseStoreManager.getInstance().setString(data: result, fileName: this.widget.fileName);
    // if (kIsWeb) {
    //   final blob = html.Blob([result], 'text/plain', 'native');
    //   html.AnchorElement(
    //     href: html.Url.createObjectUrlFromBlob(blob).toString(),
    //   )
    //     ..setAttribute('download', 'document.${fileType.extension}')
    //     ..click();
    // } else if (PlatformExtension.isMobile) {
    //   final appStorageDirectory = await getApplicationDocumentsDirectory();
    //
    //   final path = File(
    //     '${appStorageDirectory.path}/${DateTime.now()}.${fileType.extension}',
    //   );
    //   await path.writeAsString(result);
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(
    //           'This document is saved to the ${appStorageDirectory.path}',
    //         ),
    //       ),
    //     );
    //   }
    // } else {
    //   // for desktop
    //   final path = await FilePicker.platform.saveFile(
    //     fileName: 'document.${fileType.extension}',
    //   );
    //   FirebaseStoreManager.getInstance().uploadString(data: result, path: "/document/"+this.widget.fileName);
    //   if (path != null) {
    //     await File(path).writeAsString(result);
    //     if (mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text('This document is saved to the $path'),
    //         ),
    //       );
    //     }
    //   }
    // }
  }

  /**
   * 导入文件
   */
  void _importFile(ExportFileType fileType) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: [fileType.extension],
      type: FileType.custom,
    );
    var plainText = '';
    if (!kIsWeb) {
      final path = result?.files.single.path;
      if (path == null) {
        return;
      }
      plainText = await File(path).readAsString();
    } else {
      final bytes = result?.files.first.bytes;
      if (bytes == null) {
        return;
      }
      plainText = const Utf8Decoder().convert(bytes);
    }

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

    if (mounted) {
      _loadEditor(context, Future<String>.value(jsonString));
    }
  }
}

String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
    List.generate(len, (index) => r.nextInt(33) + 89),
  );
}
