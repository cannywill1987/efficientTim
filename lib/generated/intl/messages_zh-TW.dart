// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_TW locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_TW';

  static String m20(existing_text) =>
      "請根據以下內容繼續寫作：\n\n${existing_text}\n\n接下來：";

  static String m21(title, link) => "關於任務${title}的內容請點擊鏈接查看: ${link}";

  static String m57(wordCount, charCount) =>
      "(選中的) 字數: ${wordCount}, 字符數: ${charCount}";

  static String m112(appname) => "${appname} AI";

  static String m125(wordCount, charCount) =>
      "字數: ${wordCount}, 字符數: ${charCount}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addYourLink": MessageLookupByLibrary.simpleMessage("添加連結"),
        "advertising_copy": MessageLookupByLibrary.simpleMessage("廣告文案"),
        "advertising_copy_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入廣告文案的產品或服務..."),
        "advertising_copy_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我寫一份廣告文案，產品是..."),
        "ai": MessageLookupByLibrary.simpleMessage("AI"),
        "ai_placeholder": MessageLookupByLibrary.simpleMessage("AI幫我寫什麼"),
        "ai_scenario": MessageLookupByLibrary.simpleMessage("AI寫作場景"),
        "ai_scenario_prompt":
            MessageLookupByLibrary.simpleMessage("請選擇一個寫作場景。"),
        "ai_title": MessageLookupByLibrary.simpleMessage("時間管理AI"),
        "ai_write_for_me": MessageLookupByLibrary.simpleMessage("AI 幫我寫"),
        "ai_write_for_me_prompt":
            MessageLookupByLibrary.simpleMessage("請告訴我AI可以幫我寫些什麼。"),
        "ai_write_what": MessageLookupByLibrary.simpleMessage("AI幫我寫什麼"),
        "ai_write_what_prompt":
            MessageLookupByLibrary.simpleMessage("請告訴我AI可以幫我寫些什麼。"),
        "announcement": MessageLookupByLibrary.simpleMessage("通知公告"),
        "announcement_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入通知公告的具體內容..."),
        "announcement_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我寫一則通知公告，內容是..."),
        "attachment": MessageLookupByLibrary.simpleMessage("附件"),
        "auto": MessageLookupByLibrary.simpleMessage("自動"),
        "backgroundColor": MessageLookupByLibrary.simpleMessage("背景顏色"),
        "backgroundColorBlue": MessageLookupByLibrary.simpleMessage("藍色背景"),
        "backgroundColorBrown": MessageLookupByLibrary.simpleMessage("棕色背景"),
        "backgroundColorDefault": MessageLookupByLibrary.simpleMessage("預設背景色"),
        "backgroundColorGray": MessageLookupByLibrary.simpleMessage("灰色背景"),
        "backgroundColorGreen": MessageLookupByLibrary.simpleMessage("綠色背景"),
        "backgroundColorOrange": MessageLookupByLibrary.simpleMessage("橙色背景"),
        "backgroundColorPink": MessageLookupByLibrary.simpleMessage("粉色背景"),
        "backgroundColorPurple": MessageLookupByLibrary.simpleMessage("紫色背景"),
        "backgroundColorRed": MessageLookupByLibrary.simpleMessage("紅色背景"),
        "backgroundColorYellow": MessageLookupByLibrary.simpleMessage("黃色背景"),
        "bold": MessageLookupByLibrary.simpleMessage("粗體"),
        "brainstorm": MessageLookupByLibrary.simpleMessage("頭腦風暴"),
        "brainstorm_placeholder":
            MessageLookupByLibrary.simpleMessage("(例)請為全球氣候變暖提供至少5個方案"),
        "brainstorm_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我進行頭腦風暴，主題是..."),
        "bulletedList": MessageLookupByLibrary.simpleMessage("無序列表"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "caseSensitive": MessageLookupByLibrary.simpleMessage("區分大小寫"),
        "character_limit": MessageLookupByLibrary.simpleMessage("0/1000"),
        "character_limit_prompt":
            MessageLookupByLibrary.simpleMessage("字符限制：0/1000"),
        "checkbox": MessageLookupByLibrary.simpleMessage("核取方塊"),
        "chooseImage": MessageLookupByLibrary.simpleMessage("選取圖像檔案"),
        "choose_attachment": MessageLookupByLibrary.simpleMessage("選擇附件"),
        "clearHighlightColor": MessageLookupByLibrary.simpleMessage("清除高亮顏色"),
        "closeFind": MessageLookupByLibrary.simpleMessage("關閉"),
        "colAddAfter": MessageLookupByLibrary.simpleMessage("右側插入行"),
        "colAddBefore": MessageLookupByLibrary.simpleMessage("左側插入行"),
        "colClear": MessageLookupByLibrary.simpleMessage("清空整行"),
        "colDuplicate": MessageLookupByLibrary.simpleMessage("複製整行"),
        "colRemove": MessageLookupByLibrary.simpleMessage("刪除整行"),
        "color": MessageLookupByLibrary.simpleMessage("顏色"),
        "continue_writing": MessageLookupByLibrary.simpleMessage("繼續寫作"),
        "continue_writing_prompt":
            MessageLookupByLibrary.simpleMessage("請根據所選段落繼續寫作，擴展內容。"),
        "continue_writing_prompt_with_text": m20,
        "copy": MessageLookupByLibrary.simpleMessage("複製"),
        "copyLink": MessageLookupByLibrary.simpleMessage("複製連結"),
        "copy_and_share": MessageLookupByLibrary.simpleMessage("複製鏈接分享給其他小夥伴"),
        "copy_and_share_with_title": m21,
        "creative_story": MessageLookupByLibrary.simpleMessage("創意故事"),
        "creative_story_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入創意故事的情節或主題..."),
        "creative_story_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我寫一個創意故事，故事情節是..."),
        "customColor": MessageLookupByLibrary.simpleMessage("自定義顏色"),
        "cut": MessageLookupByLibrary.simpleMessage("剪下"),
        "datetime": MessageLookupByLibrary.simpleMessage("日期時間"),
        "deprecated": MessageLookupByLibrary.simpleMessage("即將作廢"),
        "divider": MessageLookupByLibrary.simpleMessage("分割線"),
        "done": MessageLookupByLibrary.simpleMessage("完成"),
        "download_fail": MessageLookupByLibrary.simpleMessage("下載失敗"),
        "editLink": MessageLookupByLibrary.simpleMessage("修改連結"),
        "edit_options": MessageLookupByLibrary.simpleMessage("編輯選項"),
        "embedCode": MessageLookupByLibrary.simpleMessage("代碼塊"),
        "emoji_conversion": MessageLookupByLibrary.simpleMessage("表情符號轉換"),
        "emoji_conversion_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入需要轉換為表情符號的文字..."),
        "emoji_conversion_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我將以下文字轉換為表情符號：..."),
        "emptySearchBoxHint": MessageLookupByLibrary.simpleMessage("鍵入尋找内容"),
        "enrich": MessageLookupByLibrary.simpleMessage("更豐富"),
        "enrich_prompt": MessageLookupByLibrary.simpleMessage("請使所選段落更加豐富和詳細。"),
        "explain": MessageLookupByLibrary.simpleMessage("解釋一下"),
        "explain_prompt":
            MessageLookupByLibrary.simpleMessage("請解釋所選段落的主要內容和意義。"),
        "find": MessageLookupByLibrary.simpleMessage("尋找"),
        "fix_spelling_grammar": MessageLookupByLibrary.simpleMessage("修復拼寫和語法"),
        "fix_spelling_grammar_prompt":
            MessageLookupByLibrary.simpleMessage("請檢查所選段落的拼寫和語法，並修復任何錯誤。"),
        "fontColorBlue": MessageLookupByLibrary.simpleMessage("藍色"),
        "fontColorBrown": MessageLookupByLibrary.simpleMessage("棕色"),
        "fontColorDefault": MessageLookupByLibrary.simpleMessage("預設"),
        "fontColorGray": MessageLookupByLibrary.simpleMessage("灰色"),
        "fontColorGreen": MessageLookupByLibrary.simpleMessage("綠色"),
        "fontColorOrange": MessageLookupByLibrary.simpleMessage("橙色"),
        "fontColorPink": MessageLookupByLibrary.simpleMessage("粉紅色"),
        "fontColorPurple": MessageLookupByLibrary.simpleMessage("紫色"),
        "fontColorRed": MessageLookupByLibrary.simpleMessage("紅色"),
        "fontColorYellow": MessageLookupByLibrary.simpleMessage("黃色"),
        "food_reviews": MessageLookupByLibrary.simpleMessage("美食點評"),
        "food_reviews_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入美食點評的餐館和菜品..."),
        "food_reviews_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我寫一篇美食點評，餐館是..."),
        "give_up": MessageLookupByLibrary.simpleMessage("放棄"),
        "heading1": MessageLookupByLibrary.simpleMessage("一級標題"),
        "heading2": MessageLookupByLibrary.simpleMessage("二級標題"),
        "heading3": MessageLookupByLibrary.simpleMessage("三級標題"),
        "hexValue": MessageLookupByLibrary.simpleMessage("十六進位值"),
        "highlight": MessageLookupByLibrary.simpleMessage("高亮"),
        "highlightColor": MessageLookupByLibrary.simpleMessage("高亮顏色"),
        "history_record": MessageLookupByLibrary.simpleMessage("歷史記錄"),
        "history_record_prompt":
            MessageLookupByLibrary.simpleMessage("查看歷史記錄。"),
        "image": MessageLookupByLibrary.simpleMessage("圖片"),
        "imageLoadFailed": MessageLookupByLibrary.simpleMessage("無法載入圖像"),
        "improve_writing": MessageLookupByLibrary.simpleMessage("改進寫作"),
        "improve_writing_prompt":
            MessageLookupByLibrary.simpleMessage("請改進所選段落的寫作，使其更加清晰和富有表達力。"),
        "in_selection_word_count_and_char_count": m57,
        "incorrectLink": MessageLookupByLibrary.simpleMessage("連結錯誤"),
        "input": MessageLookupByLibrary.simpleMessage("輸入"),
        "insert": MessageLookupByLibrary.simpleMessage("插入"),
        "interview_questions": MessageLookupByLibrary.simpleMessage("採訪問題"),
        "interview_questions_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入採訪對象及其相關問題..."),
        "interview_questions_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我列出採訪問題，採訪對象是..."),
        "italic": MessageLookupByLibrary.simpleMessage("斜體"),
        "job_description": MessageLookupByLibrary.simpleMessage("職位描述"),
        "job_description_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入職位描述的職位名稱和職責..."),
        "job_description_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我寫一份職位描述，職位名稱是..."),
        "leave_reason": MessageLookupByLibrary.simpleMessage("請假理由"),
        "leave_reason_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入請假的原因..."),
        "leave_reason_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我寫一份請假理由，原因是..."),
        "lightLightTint1": MessageLookupByLibrary.simpleMessage("紫色"),
        "lightLightTint2": MessageLookupByLibrary.simpleMessage("粉紅色"),
        "lightLightTint3": MessageLookupByLibrary.simpleMessage("淺粉紅色"),
        "lightLightTint4": MessageLookupByLibrary.simpleMessage("橙色"),
        "lightLightTint5": MessageLookupByLibrary.simpleMessage("黃色"),
        "lightLightTint6": MessageLookupByLibrary.simpleMessage("草綠色"),
        "lightLightTint7": MessageLookupByLibrary.simpleMessage("綠色"),
        "lightLightTint8": MessageLookupByLibrary.simpleMessage("水藍色"),
        "lightLightTint9": MessageLookupByLibrary.simpleMessage("藍色"),
        "link": MessageLookupByLibrary.simpleMessage("連結"),
        "linkAddressHint": MessageLookupByLibrary.simpleMessage("請輸入URL"),
        "linkText": MessageLookupByLibrary.simpleMessage("文字"),
        "linkTextHint": MessageLookupByLibrary.simpleMessage("請輸入文字"),
        "loading": MessageLookupByLibrary.simpleMessage("正在載入"),
        "ltr": MessageLookupByLibrary.simpleMessage("自左至右"),
        "manage": MessageLookupByLibrary.simpleMessage("管理"),
        "manage_prompt": MessageLookupByLibrary.simpleMessage("請打開管理選項。"),
        "meeting_agenda": MessageLookupByLibrary.simpleMessage("會議議程"),
        "meeting_agenda_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入會議議程的主題或內容..."),
        "meeting_agenda_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我列出一個會議議程，會議主題是..."),
        "mobileHeading1": MessageLookupByLibrary.simpleMessage("一級標題"),
        "mobileHeading2": MessageLookupByLibrary.simpleMessage("二級標題"),
        "mobileHeading3": MessageLookupByLibrary.simpleMessage("三級標題"),
        "modern_poetry": MessageLookupByLibrary.simpleMessage("現代詩"),
        "modern_poetry_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入現代詩的主題..."),
        "modern_poetry_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我寫一首現代詩，主題是..."),
        "more": MessageLookupByLibrary.simpleMessage("更多"),
        "more_prompt": MessageLookupByLibrary.simpleMessage("請提供更多的寫作選項。"),
        "nextMatch": MessageLookupByLibrary.simpleMessage("下一相符項"),
        "noFindResult": MessageLookupByLibrary.simpleMessage("無相符項"),
        "numberedList": MessageLookupByLibrary.simpleMessage("有序列表"),
        "opacity": MessageLookupByLibrary.simpleMessage("透明度"),
        "openLink": MessageLookupByLibrary.simpleMessage("打開連結"),
        "original_text": MessageLookupByLibrary.simpleMessage(
            "原文：政府正在積極採取措施，以應對日益嚴重的環境問題，包括加強環保法規的執行力度，提高公眾環保意識，並推動綠色能源的發展。"),
        "outline": MessageLookupByLibrary.simpleMessage("提綱"),
        "outline_placeholder":
            MessageLookupByLibrary.simpleMessage("(例)請以環保為主題列出提綱"),
        "outline_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我列出一個關於...的提綱。"),
        "paste": MessageLookupByLibrary.simpleMessage("貼上"),
        "please_select_attachment":
            MessageLookupByLibrary.simpleMessage("請選擇附件"),
        "press_release": MessageLookupByLibrary.simpleMessage("新聞稿"),
        "press_release_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入新聞稿的內容或主題..."),
        "press_release_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我寫一篇新聞稿，內容是..."),
        "previousMatch": MessageLookupByLibrary.simpleMessage("上一相符項"),
        "pros_and_cons": MessageLookupByLibrary.simpleMessage("優缺點列表"),
        "pros_and_cons_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入需要分析優缺點的主題..."),
        "pros_and_cons_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我列出某個主題的優缺點，主題是..."),
        "quote": MessageLookupByLibrary.simpleMessage("引文"),
        "regex": MessageLookupByLibrary.simpleMessage("正規表示式"),
        "regexError": MessageLookupByLibrary.simpleMessage("正規錯誤"),
        "removeLink": MessageLookupByLibrary.simpleMessage("移除連結"),
        "replace": MessageLookupByLibrary.simpleMessage("取代"),
        "replaceAll": MessageLookupByLibrary.simpleMessage("取代全部"),
        "resetToDefaultColor": MessageLookupByLibrary.simpleMessage("重設為預設顏色"),
        "revised_text": MessageLookupByLibrary.simpleMessage(
            "改寫：政府正在加強環保法規，提高公眾意識，並推動綠色能源，以應對環境問題。"),
        "rowAddAfter": MessageLookupByLibrary.simpleMessage("下方插入列"),
        "rowAddBefore": MessageLookupByLibrary.simpleMessage("上方插入列"),
        "rowClear": MessageLookupByLibrary.simpleMessage("清空整列"),
        "rowDuplicate": MessageLookupByLibrary.simpleMessage("複製整列"),
        "rowRemove": MessageLookupByLibrary.simpleMessage("刪除整列"),
        "rtl": MessageLookupByLibrary.simpleMessage("自右至左"),
        "save_fail": MessageLookupByLibrary.simpleMessage("儲存失敗"),
        "save_success": MessageLookupByLibrary.simpleMessage("儲存成功"),
        "select_scenario":
            MessageLookupByLibrary.simpleMessage("選擇下列場景或告訴AI如何編輯"),
        "shorten": MessageLookupByLibrary.simpleMessage("更簡短"),
        "shorten_prompt":
            MessageLookupByLibrary.simpleMessage("請將所選段落改寫得更加簡短，同時保持原意。"),
        "simplify_language": MessageLookupByLibrary.simpleMessage("簡化語言"),
        "simplify_language_prompt":
            MessageLookupByLibrary.simpleMessage("請簡化所選段落的語言，使其更易於理解。"),
        "slashPlaceHolder":
            MessageLookupByLibrary.simpleMessage("輸入 / 以插入内容，或開始鍵入"),
        "speech": MessageLookupByLibrary.simpleMessage("演講稿"),
        "speech_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入演講稿的主題或內容..."),
        "speech_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我寫一篇關於...的演講稿。"),
        "strikethrough": MessageLookupByLibrary.simpleMessage("刪除線"),
        "summarize": MessageLookupByLibrary.simpleMessage("總結"),
        "summarize_prompt":
            MessageLookupByLibrary.simpleMessage("請總結所選段落的主要內容。"),
        "switch_style": MessageLookupByLibrary.simpleMessage("切換風格"),
        "switch_style_prompt": MessageLookupByLibrary.simpleMessage(
            "請將所選段落轉換為另一種寫作風格，例如正式、非正式、學術或幽默。"),
        "table": MessageLookupByLibrary.simpleMessage("表格"),
        "text": MessageLookupByLibrary.simpleMessage("文本"),
        "textAlignCenter": MessageLookupByLibrary.simpleMessage("置中對齊"),
        "textAlignLeft": MessageLookupByLibrary.simpleMessage("靠左對齊"),
        "textAlignRight": MessageLookupByLibrary.simpleMessage("靠右對齊"),
        "textColor": MessageLookupByLibrary.simpleMessage("文字顏色"),
        "timehello": m112,
        "tint1": MessageLookupByLibrary.simpleMessage("色調1"),
        "tint2": MessageLookupByLibrary.simpleMessage("色調2"),
        "tint3": MessageLookupByLibrary.simpleMessage("色調3"),
        "tint4": MessageLookupByLibrary.simpleMessage("色調4"),
        "tint5": MessageLookupByLibrary.simpleMessage("色調5"),
        "tint6": MessageLookupByLibrary.simpleMessage("色調6"),
        "tint7": MessageLookupByLibrary.simpleMessage("色調7"),
        "tint8": MessageLookupByLibrary.simpleMessage("色調8"),
        "tint9": MessageLookupByLibrary.simpleMessage("色調9"),
        "todo_list": MessageLookupByLibrary.simpleMessage("待辦事項列表"),
        "todo_list_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入今天的待辦事項..."),
        "todo_list_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我列出今天的待辦事項列表..."),
        "translate": MessageLookupByLibrary.simpleMessage("翻譯"),
        "translate_prompt":
            MessageLookupByLibrary.simpleMessage("請將所選段落翻譯成英文。"),
        "type_something": MessageLookupByLibrary.simpleMessage("請輸入內容..."),
        "underline": MessageLookupByLibrary.simpleMessage("下劃線"),
        "unregister_success": MessageLookupByLibrary.simpleMessage("註銷成功"),
        "upload": MessageLookupByLibrary.simpleMessage("上載"),
        "uploadImage": MessageLookupByLibrary.simpleMessage("上載圖片"),
        "upload_attachment": MessageLookupByLibrary.simpleMessage("上傳附件"),
        "upload_error": MessageLookupByLibrary.simpleMessage("上傳失敗"),
        "upload_success": MessageLookupByLibrary.simpleMessage("上傳成功"),
        "urlHint": MessageLookupByLibrary.simpleMessage("URL"),
        "urlImage": MessageLookupByLibrary.simpleMessage("網路圖片"),
        "url_attachment": MessageLookupByLibrary.simpleMessage("URL附件"),
        "word_count_and_char_count": m125,
        "write_article": MessageLookupByLibrary.simpleMessage("寫文章"),
        "write_article_history":
            MessageLookupByLibrary.simpleMessage("寫文章 時間的文章"),
        "write_article_history_prompt":
            MessageLookupByLibrary.simpleMessage("請查看並編輯之前寫的文章：時間的文章。"),
        "write_article_placeholder": MessageLookupByLibrary.simpleMessage(
            "(例)請以環保為主題，字數1000字左右，寫作風格積極樂觀，並取一個標題"),
        "write_article_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我寫一篇關於...的文章。"),
        "write_essay": MessageLookupByLibrary.simpleMessage("寫作文"),
        "write_essay_placeholder":
            MessageLookupByLibrary.simpleMessage("請輸入作文的題目或主題..."),
        "write_essay_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我寫一篇作文，題目是..."),
        "xiaohongshu": MessageLookupByLibrary.simpleMessage("小紅書"),
        "xiaohongshu_history":
            MessageLookupByLibrary.simpleMessage("小紅書 幫我寫小紅書文案"),
        "xiaohongshu_history_prompt":
            MessageLookupByLibrary.simpleMessage("請查看並編輯之前寫的小紅書文案：幫我寫小紅書文案。"),
        "xiaohongshu_placeholder":
            MessageLookupByLibrary.simpleMessage("AI幫我寫什麼"),
        "xiaohongshu_prompt":
            MessageLookupByLibrary.simpleMessage("請幫我寫一篇小紅書文案，內容是...")
      };
}
