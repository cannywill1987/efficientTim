import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/AIAppflowyEditorWidget.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/page/AppFlowyPage/pages/desktop_editor.dart';
import 'package:time_hello/com/timehello/page/AppFlowyPage/pages/mobile_editor.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../models/ChatGptMessageModel.dart';
import '../../../util/ChatGptManager.dart';
import '../../../util/Utility.dart';

class Editor extends StatefulWidget {
  const Editor({
    super.key,
    this.onAttachmentUploadCallback,
    this.onUploadCallback,
    required this.jsonString,
    required this.onEditorStateChange,
    this.focusNode,
    this.editorStyle,
    this.textDirection = TextDirection.ltr,
  });
  final FocusNode? focusNode;
  final Function? onAttachmentUploadCallback;
  final Function? onUploadCallback;
  final Future<String> jsonString;
  final EditorStyle? editorStyle;
  final void Function(EditorState editorState) onEditorStateChange;

  final TextDirection textDirection;

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  bool isInitialized = false;

  EditorState? editorState;
  WordCountService? wordCountService;

  @override
  void didUpdateWidget(covariant Editor oldWidget) {

    if (oldWidget.jsonString != widget.jsonString) {
      editorState = null;
      isInitialized = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  int wordCount = 1;
  int charCount = 0;

  int selectedWordCount = 0;
  int selectedCharCount = 0;

  void registerWordCounter() {
    wordCountService?.removeListener(onWordCountUpdate);
    wordCountService?.dispose();

    wordCountService = WordCountService(editorState: editorState!)..register();
    wordCountService!.addListener(onWordCountUpdate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      onWordCountUpdate();
    });
  }

  void onWordCountUpdate() {
    setState(() {
      wordCount = wordCountService!.documentCounters.wordCount;
      charCount = wordCountService!.documentCounters.charCount;
      selectedWordCount = wordCountService!.selectionCounters.wordCount;
      selectedCharCount = wordCountService!.selectionCounters.charCount;
    });
  }

  @override
  void dispose() {
    try {
      editorState?.dispose();
    } catch(e) {
      print(e);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~charCount:" + (wordCountService?.selectionCounters.charCount ?? 0).toString());
    return Stack(
      children: [
        ColoredBox(
          color: ThemeManager.getInstance().isDark() ? Colors.black : Colors.white,
          child: FutureBuilder<String>(
            //加载外部传进来的json数据
            future: widget.jsonString,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                if (!isInitialized || editorState == null) {
                  isInitialized = true;
                  EditorState editorState = EditorState(
                    i18nInstance: getI18NKey(context),
                    onAttachmentUploadCallback: widget.onAttachmentUploadCallback,
                    onUploadCallback: widget.onUploadCallback,
                    document: Document.fromJson(
                      Map<String, Object>.from(
                        json.decode(snapshot.data!),
                      ),
                    ),
                  );

                  editorState.logConfiguration
                    ..handler = debugPrint
                    ..level = LogLevel.off;

                  editorState.transactionStream.listen((event) {
                    if (event.$1 == TransactionTime.after) {
                      widget.onEditorStateChange(editorState);
                    }
                  });

                  widget.onEditorStateChange(editorState);

                  this.editorState = editorState;
                  registerWordCounter();
                }

                if (PlatformExtension.isDesktopOrWeb) {
                  return DesktopEditor(
                    editorState: editorState!,
                    textDirection: widget.textDirection, focusNode: this.widget.focusNode,
                  );
                } else if (PlatformExtension.isMobile) {
                  return MobileEditor(editorState: editorState!, focusNode: this.widget.focusNode,);
                }
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(8),
                bottomLeft: PlatformExtension.isMobile
                    ? const Radius.circular(8)
                    : Radius.zero,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  getI18NKey().word_count_and_char_count(wordCount, charCount),
                  style: const TextStyle(fontSize: 11),
                ),
                if (!(editorState?.selection?.isCollapsed ?? true))
                  Text(
                    getI18NKey().in_selection_word_count_and_char_count(
                        selectedWordCount, selectedCharCount),
                    style: const TextStyle(fontSize: 11),
                  ),
              ],
            ),
          ),
        ),
        if((wordCount ?? 0) == 0)
        Container(margin: EdgeInsets.only(top: 120), child: AIAppflowyEditorWidget(onTap: (CheckButtonStateModel model) {
          if(model.code == 'more') {
            onClickSearchBarMenuWithMoreText(context, model);
            return;
          } else {
            onClickSearchBarMenuWithoutText(context, model);
          }
          // print('Button clicked: $model');
          // editorState?.insertText(model);
        },))
      ],
    );
  }

  void onClickSearchBarMenuWithMoreText(BuildContext context, CheckButtonStateModel model) {
    showMoreAISearchBarMenuWithoutText(context: context,
        editorState: this.editorState!,
        prompt: (model.value ?? "") + "",
        title: "",
        onSubmit: (text, prompt) async {
          List<Map<String, String>> list = [
            {"role": "user", "content": text}
          ];
          ChatGptMessageModel chatGptMessageModelGpt =
          await ChatGptManager.getInstance().sendMessages(
              scene: "chat",
              // chatGptFolderModel: _curChatGptFolderModel,
              // systemMessage: CONSTANTS.getSystemMessage(aiText),
              systemMessage: prompt,
              messages: list);
          print("chatGptMessageModelGpt:${chatGptMessageModelGpt
              .toJson()}");
          if (chatGptMessageModelGpt?.text != null) {
            return chatGptMessageModelGpt?.text;
          }
          return null;
        },
        onContinue: (String aiText, String originText) async {
          ChatGptMessageModel chatGptMessageModelGpt =
          await ChatGptManager.getInstance().sendMessages(
              scene: "chat",
              // chatGptFolderModel: _curChatGptFolderModel,
              // systemMessage: CONSTANTS.getSystemMessage(aiText),
              systemMessage: aiText,
              messages: [
                {"role": "user", "content": originText}
              ]);
          print(
              "chatGptMessageModelGpt:${chatGptMessageModelGpt
                  .toJson()}");
          if (chatGptMessageModelGpt?.text != null) {
            return originText + "\n" +
                (chatGptMessageModelGpt?.text ?? "");
          }
          return null;
        },
        onCopy: (text) {
          Utility.copyToClipboard(text);
        },
        placeholder: model.content ?? "");
  }

  void onClickSearchBarMenuWithoutText(BuildContext context, CheckButtonStateModel model) {
    showAISearchBarMenuWithoutText(context: context,
        editorState: this.editorState!,
        prompt: model.value + "",
        title: model.title ?? "",
        onSubmit: (text, prompt) async {
          List<Map<String, String>> list = [
            {"role": "user", "content": text}
          ];
          ChatGptMessageModel chatGptMessageModelGpt =
          await ChatGptManager.getInstance().sendMessages(
              scene: "chat",
              // chatGptFolderModel: _curChatGptFolderModel,
              // systemMessage: CONSTANTS.getSystemMessage(aiText),
              systemMessage: prompt,
              messages: list);
          print("chatGptMessageModelGpt:${chatGptMessageModelGpt
              .toJson()}");
          if (chatGptMessageModelGpt?.text != null) {
            return chatGptMessageModelGpt?.text;
          }
          return null;
        },
        onContinue: (String aiText, String originText) async {
          ChatGptMessageModel chatGptMessageModelGpt =
          await ChatGptManager.getInstance().sendMessages(
              scene: "chat",
              // chatGptFolderModel: _curChatGptFolderModel,
              // systemMessage: CONSTANTS.getSystemMessage(aiText),
              systemMessage: aiText,
              messages: [
                {"role": "user", "content": originText}
              ]);
          print(
              "chatGptMessageModelGpt:${chatGptMessageModelGpt
                  .toJson()}");
          if (chatGptMessageModelGpt?.text != null) {
            return originText + "\n" +
                (chatGptMessageModelGpt?.text ?? "");
          }
          return null;
        },
        onCopy: (text) {
          Utility.copyToClipboard(text);
        },
        placeholder: model.content ?? "");
  }
}
