import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/util/ChatGptManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../util/ThemeManager.dart';

class DesktopEditor extends StatefulWidget {
  final double? padding;
  const DesktopEditor({
    super.key,
    this.padding=20,
    this.headerWidget,
    required this.editorState,
    this.textDirection = TextDirection.ltr,
  });

  final Widget? headerWidget;
  final EditorState editorState;
  final TextDirection textDirection;

  @override
  State<DesktopEditor> createState() => _DesktopEditorState();
}

class _DesktopEditorState extends State<DesktopEditor> {
  EditorState get editorState => widget.editorState;

  late final EditorScrollController editorScrollController;

  late EditorStyle editorStyle;
  late Map<String, BlockComponentBuilder> blockComponentBuilders;
  late List<CommandShortcutEvent> commandShortcuts;

  @override
  void initState() {
    super.initState();

    editorScrollController = EditorScrollController(
      editorState: editorState,
      shrinkWrap: false,
    );

    editorStyle = _buildDesktopEditorStyle(this.widget.padding ?? 10);
    blockComponentBuilders = _buildBlockComponentBuilders();
    commandShortcuts = _buildCommandShortcuts();
  }

  @override
  void dispose() {
    editorScrollController.dispose();
    editorState.dispose();

    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();

    editorStyle = _buildDesktopEditorStyle(this.widget.padding ?? 10);
    blockComponentBuilders = _buildBlockComponentBuilders();
    commandShortcuts = _buildCommandShortcuts();
  }

  @override
  Widget build(BuildContext context) {
    assert(PlatformExtension.isDesktopOrWeb);
    return FloatingToolbar(
      items: [
        // aiItem,
        ToolbarItem(
          id: 'editor.ai',
          group: 0, // 位置
          isActive: onlyShowInSingleSelectionAndTextType,
          builder: (context, editorState, highlightColor, iconColor) {
            final selection = editorState.selection!;
            final node = editorState.getNodeAtPath(selection.start.path)!;
            final isHighlight = node.type == 'paragraph';
            final delta = (node.delta ?? Delta()).toJson();
            return SVGIconItemWidget(
                iconName: 'toolbar/ai',
                name: i18nInstanceLocal.ai,
                isHighlight: isHighlight,
                highlightColor: highlightColor,
                iconColor: iconColor,
                tooltip: i18nInstanceLocal.ai,
                onPressed: () {
                  showAIMenu(context, editorState, selection, isHighlight, (aiText, textSelected) async {
await ChatGptManager.getInstance().sendMessage(     showForbiddenMsg: false,
    // conversationIdParams: getLastParentMessageId()['conversationId'],
    newChatGptObject: true,
    systemMessage: aiText,
    textParam: textSelected,
    parentMessageIdParam: null);
                  });
                });
          },
        ),
        paragraphItem,
        ...headingItems,
        ...markdownFormatItems,
        quoteItem,
        bulletedListItem,
        numberedListItem,
        linkItem,
        buildTextColorItem(),
        buildHighlightColorItem(),
        ...textDirectionItems,
        ...alignmentItems,
      ],
      editorState: editorState,
      textDirection: widget.textDirection,
      editorScrollController: editorScrollController,
      child: Directionality(
        textDirection: widget.textDirection,
        child: AppFlowyEditor(
          editorState: editorState,
          editorScrollController: editorScrollController,
          blockComponentBuilders: blockComponentBuilders,
          commandShortcutEvents: commandShortcuts,
          editorStyle: editorStyle,
          enableAutoComplete: true,
          autoCompleteTextProvider: _buildAutoCompleteTextProvider,
          header: this.widget.headerWidget,
          footer: const SizedBox(
            height: 100,
          ),
        ),
      ),
    );
  }

  // showcase 1: customize the editor style.
  EditorStyle _buildDesktopEditorStyle(double padding) {
    bool isMiddleMissionPageVisible = Utility.getGlobalContext().read<Env>().isMiddleMissionPageVisible;
    if(ThemeManager.getInstance().isDark()) {
      return EditorStyle(
        padding: PlatformExtension.isDesktopOrWeb
            ?  EdgeInsets.only(left: padding, right: padding)
            :  EdgeInsets.symmetric(horizontal: padding),
        cursorColor: Colors.green,
        dragHandleColor: Colors.green,
        selectionColor: Colors.green.withOpacity(0.5),
        textStyleConfiguration: TextStyleConfiguration(
          text: GoogleFonts.poppins(
            fontSize: 14.0,
            color: Colors.white,
          ),
          bold: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
          href: TextStyle(
            color: Colors.amber,
            decoration: TextDecoration.combine(
              [
                TextDecoration.overline,
                TextDecoration.underline,
              ],
            ),
          ),
          code: const TextStyle(
            fontSize: 14.0,
            fontStyle: FontStyle.italic,
            color: Colors.blue,
            backgroundColor: Colors.black12,
          ),
        ),
        textSpanDecorator: (context, node, index, text, before, _) {
          final attributes = text.attributes;
          final href = attributes?[AppFlowyRichTextKeys.href];
          if (href != null) {
            return TextSpan(
              text: text.text,
              style: before.style,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  debugPrint('onTap: $href');
                },
            );
          }
          return before;
        },
      );
      ;
    } else {
      return EditorStyle.desktop(
        cursorWidth: 2.0,
        cursorColor: Colors.blue,
        selectionColor: Colors.grey.shade300,
        textStyleConfiguration: TextStyleConfiguration(
          text: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black,
          ),
          code: GoogleFonts.architectsDaughter(),
          bold: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
        padding:  EdgeInsets.symmetric(horizontal: padding),
      );
    }
  }

  // showcase 2: customize the block style
  Map<String, BlockComponentBuilder> _buildBlockComponentBuilders() {
    final map = {
      ...standardBlockComponentBuilderMap,
    };
    // customize the image block component to show a menu
    //可以给image增加一个图片组件 gpt以后也可以加这个功能
    // map[ImageBlockKeys.type] = ImageBlockComponentBuilder(
    //   showMenu: true,
    //   menuBuilder: (node, _) {
    //     return const Positioned(
    //       right: 10,
    //       child: Text('⭐️ Here is a menu!'),
    //     );
    //   },
    // );
    // customize the heading block component
    final levelToFontSize = [
      30.0,
      26.0,
      22.0,
      18.0,
      16.0,
      14.0,
    ];
    map[HeadingBlockKeys.type] = HeadingBlockComponentBuilder(
      textStyleBuilder: (level) => GoogleFonts.poppins(
        fontSize: levelToFontSize.elementAtOrNull(level - 1) ?? 14.0,
        fontWeight: FontWeight.w600,
      ),
    );
    // customize the padding
    map.forEach((key, value) {
      value.configuration = value.configuration.copyWith(
        padding: (_) => const EdgeInsets.symmetric(vertical: 8.0),
      );
    });
    return map;
  }

  // showcase 3: customize the command shortcuts
  List<CommandShortcutEvent> _buildCommandShortcuts() {
    return [
//      高亮指令
      // customize the highlight color
      customToggleHighlightCommand(
        style: ToggleColorsStyle(
          highlightColor: Colors.orange.shade700,
        ),
      ),
      ...[
        ...standardCommandShortcutEvents
          ..removeWhere(
            (el) => el == toggleHighlightCommand,
          ),
      ],
      //替换指令
      ...findAndReplaceCommands(
        context: context,
        localizations: FindReplaceLocalizations(
          find: 'Find',
          previousMatch: 'Previous match',
          nextMatch: 'Next match',
          close: 'Close',
          replace: 'Replace',
          replaceAll: 'Replace all',
          noResult: 'No result',
        ),
      ),
    ];
  }

  //自动提示provider
  String? _buildAutoCompleteTextProvider(
    BuildContext context,
    Node node,
    TextSpan? textSpan,
  ) {
    final editorState = context.read<EditorState>();
    final selection = editorState.selection;
    final delta = node.delta;
    if (selection == null ||
        delta == null ||
        !selection.isCollapsed ||
        selection.endIndex != delta.length ||
        !node.path.equals(selection.start.path)) {
      return null;
    }
    final text = delta.toPlainText();
    // An example, if the text ends with 'hello', then show the autocomplete.

    if (text.endsWith('hello')) {
      return ' world';
    }
    return null;
  }
}
