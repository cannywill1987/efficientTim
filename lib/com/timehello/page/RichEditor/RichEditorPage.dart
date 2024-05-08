import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/libs/flutterquill/extensions.dart';
import 'package:time_hello/com/timehello/libs/flutterquill/flutter_quill.dart'
    hide Text;
import 'package:time_hello/com/timehello/libs/flutterExtension/flutter_quill_extensions.dart';

// import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/models/TimelineMissionModel.dart';
import 'package:time_hello/com/timehello/page/RichEditor/universal_ui/universal_ui.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../../beans/BaseBean.dart';
import '../../common/database/apis/MongoApisManager.dart';
import '../../components/BaseWidget.dart';
import '../../config/CONSTANTS.dart';
import '../../config/Params.dart';
import '../../libs/mongodb/response/MongoDbSaved.dart';
import '../../libs/mongodb/response/MongoDbUpdated.dart';
import '../../models/EventFn.dart';
import '../../util/EasyLoadingManager.dart';
import '../TimeLinePage/TimeLinePage.dart';
import 'ReadOnlyPage.dart';
import 'components/CustomInputWidget.dart';

// import '../universal_ui/universal_ui.dart';
// import 'read_only_page.dart';

enum _SelectionType {
  none,
  word,
  line,
}

class RichEditorPage extends BaseWidget {
  RichTextModeEnum richTextModeEnum = RichTextModeEnum.diary;
  TimelineMissionModel? timelineMissionModel = TimelineMissionModel();
  TextEditingController inputController = TextEditingController();
  Function? onOkListener;
  PageModeEnum? pageModeEnum = PageModeEnum.create;

  // bool isAdd = true;

  RichEditorPage(
      {required this.richTextModeEnum,
      // PageModeEnum? pageModeEnum,
      this.onOkListener,
      TimelineMissionModel? timelineMissionModel}) {
    this.timelineMissionModel = timelineMissionModel;
    if (this.timelineMissionModel == null ||
        this.timelineMissionModel?.objectId == null) {
      //新增
      this.pageModeEnum = PageModeEnum.create;
      //为空就是新增状态
      if (this.timelineMissionModel == null) {
        if (this.richTextModeEnum == RichTextModeEnum.note) {
          this.timelineMissionModel =
              Utility.getTimelineMissionModelFromMissionModel(
            sceneType: 'note',
            eventType: 'note',
            icon: Icons.note.codePoint,
            color: 0xffccbb00,
          );
          // timelineMessage: getI18NKey().wrote_a_note("")
        } else {
          this.timelineMissionModel =
              Utility.getTimelineMissionModelFromMissionModel(
            // url: response.data,
            sceneType: 'diary',
            eventType: 'diary',
            icon: Icons.history_edu.codePoint,
            color: 0xffffaa00,
          );
          // timelineMessage: getI18NKey().wrote_a_diary("")
        }
      } else {
        if (this.richTextModeEnum == RichTextModeEnum.note) {
          this.timelineMissionModel?.sceneType = "note";
          this.timelineMissionModel?.eventType = "note";
          // timelineMessage: getI18NKey().wrote_a_note("")
        } else if (this.richTextModeEnum == RichTextModeEnum.diary) {
          this.timelineMissionModel?.sceneType = "diary";
          this.timelineMissionModel?.eventType = "diary";
        }
      }
    } else {
      //编辑
      this.pageModeEnum = PageModeEnum.edit;
      // this.isAdd = false;
      if (timelineMissionModel?.sceneType == 'diary') {
        inputController.text = timelineMissionModel?.title ?? "";
      }
    }
    // if(pageModeEnum != null) {
    //   if(this.timelineMissionModel?.objectId == null) {
    //     this.pageModeEnum = PageModeEnum.edit;
    //   } else {
    //     this.pageModeEnum = PageModeEnum.create;
    //   }
    // }
  }

  // _RichEditorPageState createState() => _RichEditorPageState();
  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _RichEditorPageState();
  }
}

class _RichEditorPageState extends BaseWidgetState<RichEditorPage> {
  QuillController? _controller;
  final FocusNode _focusNode = FocusNode();
  Timer? _selectAllTimer;
  _SelectionType _selectionType = _SelectionType.none;
  String? picUrl;
  DateTime dateTimeNow = DateTime.now();
  int titleMaxLength = 15;
  String remindTxt = "";
  late BuildContext context;
  @override
  void dispose() {
    _selectAllTimer?.cancel();
    super.dispose();
  }

  componentDidMount() {
    DialogManagement.getInstance().showRequestCameraPermissiondialog(this.context, okCallback: () {
    });
  }

  @override
  void initState() {
    super.initState();
    forceAppBarVisible = true;
    isAppBarVisible = true;
    if (Utility.isHandsetBySize() == false) {
      isNavBackBtnVisible = false;
    }
    this.rightNavChildren = [
      IconButton(
        onPressed: () => _addEditNote(Utility.getGlobalContext()),
        icon: const Icon(Icons.note_add),
      ),
      TextButton(
        onPressed: () async {
          String res = jsonEncode(_controller?.document.toDelta().toJson());
          String plainText = _controller?.document.toPlainText() ?? "";
          if (plainText.isEmpty) {
            Utility.showToast(
                context: Utility.getGlobalContext(),
                msg: getI18NKey().content_cannot_be_empty);
            return;
          }
          EasyLoadingManager.getInstance().showLoading();
          HttpManager.getInstance().doPostRequest(Apis.uploadOssJSON,
              params: {
                'schema': res,
                "title": DateTime.now().toUtc().toString() //文件标题
              },
              context: Utility.getGlobalContext(), callback:
                  (BaseBean response, String scene, bool isFromCache) async {
            EasyLoadingManager.getInstance().dismiss();
            if (this.widget.richTextModeEnum == RichTextModeEnum.note) {
              String timelineTitle = plainText
                  .substring(
                      0,
                      plainText.length > this.titleMaxLength
                          ? this.titleMaxLength
                          : plainText.length)
                  .trim();
              //做笔记
              this.widget.timelineMissionModel?.timelineMessage = timelineTitle;
            } else if (this.widget.richTextModeEnum == RichTextModeEnum.diary) {
              String timelineTitle = plainText
                  .substring(
                      0,
                      plainText.length > this.titleMaxLength
                          ? this.titleMaxLength
                          : plainText.length)
                  .trim();
              //写日记 可以加标题
              this.widget.timelineMissionModel?.title =
                  this.widget.inputController.text;
              this.widget.timelineMissionModel?.timelineMessage =
                  TextUtil.isEmpty(this.widget.timelineMissionModel?.title)
                      ? timelineTitle
                      : this.widget.timelineMissionModel?.title;
            }
            String? timelineMissionModelObjectId;

            this.widget.timelineMissionModel?.url = response.data;
            if (this.widget.pageModeEnum == PageModeEnum.create) {
              //添加
              EasyLoadingManager.getInstance().showLoading();
              MongoDbSaved? res = await MongoApisManager.getInstance()
                  .insertTimelineMissionModel(
                      missionModel: this.widget.timelineMissionModel ??
                          TimelineMissionModel());
              timelineMissionModelObjectId = res?.objectId ?? "";
              EasyLoadingManager.getInstance().dismiss();
              if (res != null) {
                eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
                Utility.showToast(
                    context: Utility.getGlobalContext(),
                    msg: getI18NKey().add_successfully);
              } else {
                Utility.showToast(
                    context: Utility.getGlobalContext(),
                    msg: getI18NKey().add_fail);
              }
            } else {
              //编辑
              EasyLoadingManager.getInstance().showLoading();
              MongoDbUpdated res = await MongoApisManager.getInstance()
                  .update_TimelineMissionModel(
                      currentObjectId:
                          this.widget.timelineMissionModel?.objectId,
                      missionModel: this.widget.timelineMissionModel ??
                          TimelineMissionModel());
              EasyLoadingManager.getInstance().dismiss();
              if (res.success == true) {
                eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
                Utility.showToast(
                    context: Utility.getGlobalContext(),
                    msg: getI18NKey().edit_successfully);
              } else {
                Utility.showToast(
                    context: Utility.getGlobalContext(),
                    msg: getI18NKey().edit_fail);
              }
            }

            if (this.widget.richTextModeEnum == RichTextModeEnum.getUrl) {
              if (this.widget.onOkListener != null) {
                this.widget.onOkListener!(
                    response.data,
                    timelineMissionModelObjectId,
                    (_controller?.document?.root?.length ?? 0 - 1) > 0
                        ? (_controller?.document?.root?.length ?? 1) - 1
                        : 0);
              }
            }
            Utility.popupPagePCAndMobile(mContext ?? Utility.getGlobalContext());
            // if (Utility.isHandsetBySize()) {
            //   Utility.popNavigator(this.context);
            // } else {
            //   DialogManagement.getInstance().hideDialog(this.context);
            // }
          });
        },
        child: Text(
          this.widget.pageModeEnum == PageModeEnum.create
              ? getI18NKey().publish
              : getI18NKey().save,
          style: TextStyle(color: Colors.red),
        ),
      ),
    ];
    if (this.widget.pageModeEnum != PageModeEnum.create) {
      //编辑状态
      requestData();
    } else {
      loadData(null);
    }
  }

  /**
   * 编辑需要拉取数据
   */
  requestData() async {
    BaseBean res = await HttpManager.getInstance()
        .doGetFileContentRequest(this.widget.timelineMissionModel?.url ?? "");
    loadData(res.data);
  }

  Future<void> loadData(String? jsonContent) async {
    try {
      // final result = await rootBundle.loadString(isDesktop()
      //     ? 'assets/sample_data_nomedia.json'
      //     : 'assets/sample_data.json');
      // final doc = Document.fromJson(jsonDecode(result));
      final doc =
          Document.fromJson(jsonContent != null ? jsonDecode(jsonContent) : []);
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
    this.context = context;
    if (_controller == null) {
      return Scaffold(body: Center(child: Text(getI18NKey().loading)));
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Color(0xffefefef)),
          child: Column(
            children: [
              this.widget.richTextModeEnum == RichTextModeEnum.diary
                  ? SizedBox(
                      height: 2,
                    )
                  : SizedBox.shrink(),
              this.widget.richTextModeEnum == RichTextModeEnum.diary
                  ? CustomDiaryInputWidget(
                      onSubmitListener: (val) {},
                      inputController: this.widget.inputController,
                    )
                  : SizedBox.shrink(),
              this.widget.richTextModeEnum == RichTextModeEnum.diary
                  ? SizedBox.shrink()
                  : SizedBox(
                      height: 2,
                    ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getI18NKey().missionModelDate(
                          dateTimeNow.year,
                          dateTimeNow.month,
                          dateTimeNow.day,
                          CONSTANTS.getTextFromDayOfWeek(dateTimeNow.weekday)),
                      style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff808080)), fontSize: 12),
                    ),
                    Text(
                      remindTxt,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    )
                  ],
                ),
              ),
              Container(
                height: 10,
              ),
            ],
          ),
        ),
        Expanded(child: _buildEditor(context))
      ],
    );
  }

  bool _onTripleClickSelection() {
    final controller = _controller!;
    _selectAllTimer?.cancel();
    _selectAllTimer = null;

    // If you want to select all text after paragraph, uncomment this line
    if (_selectionType == _SelectionType.line) {
      final selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.document.length,
      );
      controller.updateSelection(selection, ChangeSource.REMOTE);
      _selectionType = _SelectionType.none;
      return true;
    }

    if (controller.selection.isCollapsed) {
      _selectionType = _SelectionType.none;
    }

    if (_selectionType == _SelectionType.none) {
      _selectionType = _SelectionType.word;
      _startTripleClickTimer();
      return false;
    }

    if (_selectionType == _SelectionType.word) {
      final child = controller.document.queryChild(
        controller.selection.baseOffset,
      );
      final offset = child.node?.documentOffset ?? 0;
      final length = child.node?.length ?? 0;

      final selection = TextSelection(
        baseOffset: offset,
        extentOffset: offset + length,
      );

      controller.updateSelection(selection, ChangeSource.REMOTE);

      // _selectionType = _SelectionType.line;

      _selectionType = _SelectionType.none;

      _startTripleClickTimer();

      return true;
    }

    return false;
  }

  void _startTripleClickTimer() {
    _selectAllTimer = Timer(const Duration(milliseconds: 900), () {
      _selectionType = _SelectionType.none;
    });
  }

  Widget _buildEditor(BuildContext context) {
    Widget quillEditor = MouseRegion(
      cursor: SystemMouseCursors.text,
      child: QuillEditor(
        controller: _controller!,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _focusNode,
        autoFocus: false,
        readOnly: false,
        placeholder: getI18NKey().add_content,
        enableSelectionToolbar: isMobile(),
        expands: false,
        padding: EdgeInsets.zero,
        onImagePaste: _onImagePaste,
        onTapUp: (details, p1) {
          return _onTripleClickSelection();
        },
        customStyles: DefaultStyles(
          h1: DefaultTextBlockStyle(
               TextStyle(
                fontSize: 32,
                color: ThemeManager.getInstance().getTextColor(defaultColor: Colors.black),
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
    //       onTapUp: (details, p1) {
    //         return _onTripleClickSelection();
    //       },
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
    var toolbar = QuillToolbar.basic(
      controller: _controller!,
      embedButtons: FlutterQuillEmbeds.buttons(
        // provide a callback to enable picking images from device.
        // if omit, "image" button only allows adding images from url.
        // same goes for videos.
        onImagePickCallback: _onImagePickCallback,
        onVideoPickCallback: _onVideoPickCallback,
        // uncomment to provide a custom "pick from" dialog.
        // mediaPickSettingSelector: _selectMediaPickSetting,
        // uncomment to provide a custom "pick from" dialog.
        cameraPickSettingSelector: _selectCameraPickSetting,
      ),
      showAlignmentButtons: true,
      afterButtonPressed: _focusNode.requestFocus,
    );
    if (kIsWeb) {
      toolbar = QuillToolbar.basic(
        controller: _controller!,
        embedButtons: FlutterQuillEmbeds.buttons(
          onImagePickCallback: _onImagePickCallback,
          webImagePickImpl: _webImagePickImpl,
        ),
        showAlignmentButtons: true,
        afterButtonPressed: _focusNode.requestFocus,
      );
    }
    if (_isDesktop()) {
      toolbar = QuillToolbar.basic(
        controller: _controller!,
        embedButtons: FlutterQuillEmbeds.buttons(
          onImagePickCallback: _onImagePickCallback,
          filePickImpl: openFileSystemPickerForDesktop,
        ),
        showAlignmentButtons: true,
        afterButtonPressed: _focusNode.requestFocus,
      );
    }

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 15,
            child: Container(
              color: ThemeManager.getInstance().getInputThemeColor(defaultColor: Colors.white),
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: quillEditor,
            ),
          ),
          kIsWeb
              ? Expanded(
                  child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: toolbar,
                ))
              : Container(child: toolbar)
        ],
      ),
    );
  }

  bool _isDesktop() => !kIsWeb && !Utility.isAndroid() && !Utility.isIOS();

  Future<String?> openFileSystemPickerForDesktop(BuildContext context) async {
    return await FilesystemPicker.open(
      context: context,
      rootDirectory: await getApplicationDocumentsDirectory(),
      fsType: FilesystemType.file,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
  }

  Future<String?> _webImagePickImpl(
      OnImagePickCallback onImagePickCallback) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return null;
    }

    // Take first, because we don't allow picking multiple files.
    final fileName = result.files.first.name;
    final file = File(fileName);

    return onImagePickCallback(file);
  }

  // Renders the video picked by imagePicker from local file storage
  // You can also upload the picked video to any server (eg : AWS s3
  // or Firebase) and then return the uploaded video URL.
  Future<String> _onVideoPickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }

  // ignore: unused_element
  Future<MediaPickSetting?> _selectMediaPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.collections),
                label: Text(getI18NKey().gallery),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Gallery),
              ),
              TextButton.icon(
                icon: const Icon(Icons.link),
                label: Text(getI18NKey().link),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Link),
              )
            ],
          ),
        ),
      );

  // ignore: unused_element
  Future<MediaPickSetting?> _selectCameraPickSetting(BuildContext context) async {
    MediaPickSetting? setting = await showCameraDialog(context);
    return setting;
  }

  Future<MediaPickSetting?> showCameraDialog(BuildContext context) {

    return showDialog<MediaPickSetting>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.camera),
                label: Text(getI18NKey().capture_a_photo),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Camera),
              ),
              TextButton.icon(
                icon: const Icon(Icons.video_call),
                label: Text(getI18NKey().capture_a_video),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Video),
              )
            ],
          ),
        );
      }
    );
  }
  // Widget _buildMenuBar(BuildContext context) {
  //   final size = MediaQuery.of(context).size;
  //   const itemStyle = TextStyle(
  //     color: Colors.white,
  //     fontSize: 18,
  //     fontWeight: FontWeight.bold,
  //   );
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Divider(
  //         thickness: 2,
  //         color: Colors.white,
  //         indent: size.width * 0.1,
  //         endIndent: size.width * 0.1,
  //       ),
  //       ListTile(
  //         title: const Center(child: Text('Read only demo', style: itemStyle)),
  //         dense: true,
  //         visualDensity: VisualDensity.compact,
  //         onTap: _readOnly,
  //       ),
  //       Divider(
  //         thickness: 2,
  //         color: Colors.white,
  //         indent: size.width * 0.1,
  //         endIndent: size.width * 0.1,
  //       ),
  //     ],
  //   );
  // }

  // void _readOnly() {
  //   Navigator.pop(super.context);
  //   Navigator.push(
  //     super.context,
  //     MaterialPageRoute(
  //       builder: (context) => ReadOnlyPage(),
  //     ),
  //   );
  // }

  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3
  // or Firebase) and then return the uploaded image URL.
  Future<String> _onImagePickCallback(File file) async {
    // setState(() {
    //   remindTxt = getI18NKey().uploading_pic;
    // });
    // final appDocDir = await getApplicationDocumentsDirectory();
    // final copiedFile =
    // await file.copy('${appDocDir.path}/${basename(file.path)}');
    //
    // BaseBean res = await HttpManager.getInstance()
    //     .uploadImage(key: "key", file: file, url: Apis.uploadOss);
    // picUrl = res.data['smallImage'];
    // this.widget.timelineMissionModel?.picUrl = picUrl;
    // setState(() {
    //   remindTxt = "";
    // });
    // return res.data['bigImage'];
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');

    XFile xfile = await Utility.compressAndGetFile(file: file);

    //上传图片
    uploadPic(xfile);

    return xfile.path.toString();

    // return copiedFile.path.toString();
  }

  Future<String> _onImagePaste(List<int> imageBytes) async {
    // setState(() {
    //   remindTxt = getI18NKey().uploading_pic;
    // });

    // setState(() {
    //   remindTxt = "";
    // });
    // return res.data['bigImage'];
    final appDocDir = await getApplicationDocumentsDirectory();
    File file = await File(
            '${appDocDir.path}/${basename('${DateTime.now().millisecondsSinceEpoch}.png')}')
        .writeAsBytes(imageBytes, flush: true);
    XFile xfile = await Utility.compressAndGetFile(file: file);

    //上传图片
    uploadPic(xfile);

    return xfile.path.toString();
  }

  Future<void> uploadPic(XFile file) async {
    BaseBean res = await HttpManager.getInstance().uploadImage(
        key: "key", file: new File(file.path), url: Apis.uploadOss);
    // if (picUrl == null) {
    picUrl = res.data['smallImage'];
    this.widget.timelineMissionModel?.picUrl = picUrl;
  }

  Future<void> _addEditNote(BuildContext context, {Document? document}) async {
    final isEditing = document != null;
    final quillEditorController = QuillController(
      document: document ?? Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
      final offset = getEmbedNode(controller, controller.selection.start);
      controller.replaceText(offset.offset, 1, block,
          TextSelection.collapsed(offset: offset.offset));
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
  Widget build(BuildContext context, QuillController controller, Embed node,
      bool readOnly, bool a, TextStyle textStyle) {
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
  bool get expanded => true;
  // @override
  // // TODO: implement expanded
  // bool get expanded => throw UnimplementedError();
}

class NotesBlockEmbed extends CustomBlockEmbed {
  const NotesBlockEmbed(String value) : super(noteType, value);

  static const String noteType = 'notes';

  static NotesBlockEmbed fromDocument(Document document) =>
      NotesBlockEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}
