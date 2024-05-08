import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/libs/flutterquill/extensions.dart';
import 'package:time_hello/com/timehello/libs/flutterquill/flutter_quill.dart' hide Text;
import 'package:time_hello/com/timehello/libs/flutterExtension/flutter_quill_extensions.dart';

// /flutterquill/src/models/documents/nodes/embeddable.dart
// import 'package:flutter_quill/extensions.dart';
// import 'package:flutter_quill/flutter_quill.dart' hide Text;
// import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/page/RichEditor/RichEditorPage.dart';

import 'package:time_hello/com/timehello/page/RichEditor/universal_ui/universal_ui.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../components/BaseWidget.dart';
import '../../config/CONSTANTS.dart';
import '../../config/ENUMS.dart';
import '../../models/TimelineMissionModel.dart';
import '../../util/DialogManagement.dart';

enum _SelectionType {
  none,
  word,
  line,
}

class ReadOnlyPage extends BaseWidget {
  RichTextModeEnum richTextModeEnum = RichTextModeEnum.diary;
  TimelineMissionModel? timelineMissionModel = TimelineMissionModel();
  bool? showEditButton = true;
  String? ossUrl;
  ReadOnlyPage({required this.richTextModeEnum,
     this.timelineMissionModel,
    this.ossUrl,
    this.showEditButton
  }); // @override
  // _ReadOnlyPageState createState() => _ReadOnlyPageState();
  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _ReadOnlyPageState();
  }
}

class _ReadOnlyPageState extends BaseWidgetState<ReadOnlyPage> {
  QuillController? _controller;
  final FocusNode _focusNode = FocusNode();
  Timer? _selectAllTimer;
  _SelectionType _selectionType = _SelectionType.none;
  DateTime? dateTimeLastUpdate;
  double padding = 10;


  @override
  void dispose() {
    _selectAllTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if(this.widget.timelineMissionModel?.updatedAt != null) {
      dateTimeLastUpdate = Utility.getDateTimeFromUTCString(
          this.widget.timelineMissionModel?.updatedAt ?? "");
    }
    forceAppBarVisible = true;
    isAppBarVisible = true;
    if (Utility.isHandsetBySize() == false) {
      isNavBackBtnVisible = false;
    }
    if (this.widget.showEditButton == true) {
      this.rightNavChildren = [
        TextButton(
            onPressed: () async {
              if (Utility.isMobile()) {
                // Utility.setScreenOrientationHorizontal();
                Utility.pushReplacement(
                    context,
                    RichEditorPage(
                      richTextModeEnum: this.widget.richTextModeEnum,
                      timelineMissionModel: this.widget.timelineMissionModel,
                    ));
              } else {
                DialogManagement.getInstance().pushAndReplaceDialog(
                    context: context,
                    widget: RichEditorPage(
                      richTextModeEnum: this.widget.richTextModeEnum,
                      timelineMissionModel: this.widget.timelineMissionModel,
                    ));
              }
            },
            child: Text(
              getI18NKey().edit,
              style: TextStyle(color: Colors.red),
            ),
        ),
      ];
    }

      requestData();
    }

  requestData() async {
    BaseBean res = await HttpManager.getInstance()
        .doGetFileContentRequest(this.widget.ossUrl != null ? this.widget.ossUrl : this.widget.timelineMissionModel?.url);
    loadData(res.data);
  }

  Future<void> loadData(String jsonContent) async {
    try {
      // final result = await rootBundle.loadString(jsonContent);
      final doc = Document.fromJson(jsonDecode(jsonContent));
      setState(() {
        _controller = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    } catch (error) {
      final doc = Document();
      // final doc = Document()..insert(0, 'Empty asset');
      setState(() {
        _controller = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    }
  }

  @override
  Widget baseBuild(BuildContext context) {
    if (_controller == null) {
      return Scaffold(body: Center(child: (this.widget.ossUrl ?? this.widget.timelineMissionModel?.url) == null ? Text(getI18NKey().no_data) : Text(getI18NKey().loading)));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        this.widget.richTextModeEnum == RichTextModeEnum.note ? SizedBox
            .shrink() : SizedBox(height: 10,),
        this.widget.richTextModeEnum == RichTextModeEnum.note ? SizedBox
            .shrink() : Container(
          padding: EdgeInsets.only(left: padding, top: padding / 2),
          child: Text(
            this.widget.timelineMissionModel?.title ?? '',
            style: TextStyle(
              color: Color(0xff6a696f),
              fontSize: 19,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xffe2e2e2),
              decorationThickness: 3,
            ),
          ),
        ),
        dateTimeLastUpdate?.year == null ? SizedBox.shrink() : Container(
          padding: EdgeInsets.only(left: 10, top: 5, bottom: 2),
          child: Row(
            children: [
              Text(
                getI18NKey().update_last_time(getI18NKey().missionModelDate(
                    dateTimeLastUpdate!.year,
                    dateTimeLastUpdate!.month,
                    dateTimeLastUpdate!.day,
                    CONSTANTS
                        .getTextFromDayOfWeek(dateTimeLastUpdate!.weekday))),
                style: TextStyle(color: Color(0xff808080), fontSize: 12),
              )
            ],
          ),
        ),
        SizedBox(height: 5,),
        Expanded(child: _buildWelcomeEditor(context))
      ],
    );
  }

  Widget _buildWelcomeEditor(BuildContext context) {
    Widget quillEditor = MouseRegion(
      cursor: SystemMouseCursors.text,
      child: QuillEditor(
        controller: _controller!,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _focusNode,
        autoFocus: false,
        readOnly: true,
        placeholder: getI18NKey().add_content,
        enableSelectionToolbar: isMobile(),
        expands: false,
        padding: EdgeInsets.zero,
        // onImagePaste: _onImagePaste,
        // onTapUp: (details, p1) {
        //   return _onTripleClickSelection();
        // },
        customStyles: DefaultStyles(
          h1: DefaultTextBlockStyle(
              const TextStyle(
                fontSize: 32,
                color: Colors.black,
                height: 1.15,
                fontWeight: FontWeight.w300,
              ),
              VerticalSpacing(16, 0),
              VerticalSpacing(0, 0),
              null),
          sizeSmall: const TextStyle(fontSize: 9),
        ),
        embedBuilders: [
          ...FlutterQuillEmbeds.builders(),
          NotesEmbedBuilder(addEditNote: _addEditNote)
        ],
      ),
    );
    // if (kIsWeb) {
    //   quillEditor = MouseRegion(
    //     cursor: SystemMouseCursors.text,
    //     child: QuillEditor(
    //       controller: _controller!,
    //       scrollController: ScrollController(),
    //       scrollable: true,
    //       focusNode: _focusNode,
    //       autoFocus: false,
    //       readOnly: false,
    //       placeholder: getI18NKey().add_content,
    //       expands: false,
    //       padding: EdgeInsets.zero,
    //       // onTapUp: (details, p1) {
    //       //   return _onTripleClickSelection();
    //       // },
    //       customStyles: DefaultStyles(
    //         h1: DefaultTextBlockStyle(
    //             const TextStyle(
    //               fontSize: 32,
    //               color: Colors.black,
    //               height: 1.15,
    //               fontWeight: FontWeight.w300,
    //             ),
    //             VerticalSpacing(16, 0),
    //             VerticalSpacing(0, 0),
    //             null),
    //         sizeSmall: const TextStyle(fontSize: 9),
    //       ),
    //       embedBuilders: defaultEmbedBuildersWeb,
    //     ),
    //   );
    // }

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 15,
            child: Container(
              color: ThemeManager.getInstance().getInputThemeColor(),
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: quillEditor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addEditNote(BuildContext context, {Document? document}) async {
    final isEditing = document != null;
    final quillEditorController = QuillController(
      document: document ?? Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            titlePadding: const EdgeInsets.only(left: 16, top: 8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${isEditing ? 'Edit' : 'Add'} note'),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            content: QuillEditor.basic(
              controller: quillEditorController,
              readOnly: false,
            ),
          ),
    );

    if (quillEditorController.document.isEmpty()) return;

    final block = BlockEmbed.custom(
      NotesBlockEmbed.fromDocument(quillEditorController.document),
    );
    final controller = _controller!;
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;

    if (isEditing) {
      // final offset = getEmbedNode(controller, controller.selection.start).item1;
      OffsetValue<Embed> offset = getEmbedNode(controller, controller.selection.start);
      controller.replaceText(
          offset.offset, 1, block, TextSelection.collapsed(offset: offset.offset));
    } else {
      controller.replaceText(index, length, block, null);
    }
  }
}

class NotesEmbedBuilder implements EmbedBuilder {
  NotesEmbedBuilder({required this.addEditNote});

  Future<void> Function(BuildContext context, {Document? document}) addEditNote;

  @override
  String get key => 'notes';

  @override
  Widget build(BuildContext context,
      QuillController controller,
      Embed node,
      bool readOnly, bool a, TextStyle t) {
    final notes = NotesBlockEmbed(node.value.data).document;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(
          notes.toPlainText().replaceAll('\n', ' '),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        leading: const Icon(Icons.notes),
        onTap: () => addEditNote(context, document: notes),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    // TODO: implement buildWidgetSpan
    return WidgetSpan(child: widget);
  }

  @override
  // TODO: implement expanded
  bool get expanded => throw UnimplementedError();
}

class NotesBlockEmbed extends CustomBlockEmbed {
  const NotesBlockEmbed(String value) : super(noteType, value);

  static const String noteType = 'notes';

  static NotesBlockEmbed fromDocument(Document document) =>
      NotesBlockEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}
