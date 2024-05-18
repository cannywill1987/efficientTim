// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  static String m0(numbers) => "「${numbers}」個のタスクを一括完了しました";

  static String m1(numbers) => "「${numbers}」個のタスクを一括削除しました";

  static String m2(numbers) => "「${numbers}」個のタスクを一括未完了にしました";

  static String m3(numbers) => "「${numbers}」個のタスクを一括更新しました";

  static String m4(numTotatoes, duration, time, minute) =>
      "予想トマト時間:${numTotatoes} x ${duration} 分 = ${time}時間${minute}分";

  static String m5(times) => "連続打刻${times}日";

  static String m6(n) => "累計打刻${n}日";

  static String m7(title) => "タスク \'${title}\'を完了";

  static String m8(title, num) =>
      "タスク「${title}」の集中を完了しました、${num}のバーチャルコインを獲得しました";

  static String m9(title, time, num) =>
      "タスク「${title}」の一回の集中を完了しました、集中時間は${time}、${num}のバーチャルコインを獲得しました";

  static String m10(title) => "休憩「${title}」を完了しました";

  static String m11(title) => "休憩「${title}」を完了しました";

  static String m12(name) => "${name}";

  static String m13(folderName) => "フォルダ\"${folderName}\"を削除してもよろしいですか？";

  static String m14(folderName) =>
      "フォルダ\"${folderName}\"のリストと関連するサブタスクを削除しますか？";

  static String m15(money) => "「${money}」の金額を消費しました（手動入力）";

  static String m16(money, present) => "「${money}」の金額で「${present}」を購入しました";

  static String m17(day, hour, mins, secs) => "${day}日 ${hour}:${mins}:${secs}";

  static String m18(hour, mins, secs) => "${hour}:${mins}:${secs}";

  static String m19(mins, secs) => "${mins}:${secs}";

  static String m20(times, total, title) =>
      "タスク${times}/${total}回 \'${title}\'を打つ";

  static String m21(listing, title) => "リスト「${listing}」に打刻タスク「${title}」を作成しました";

  static String m22(title) => "打刻タスク「${title}」を作成しました";

  static String m23(title) => "リスト「${title}」を作成しました";

  static String m24(listing, title) => "リスト「${listing}」にタスク「${title}」を作成しました";

  static String m25(title) => "タスク「${title}」を作成しました";

  static String m26(title) => "タグ「${title}」を作成しました";

  static String m27(Folder) => "${Folder}を作成する";

  static String m28(tone) => "現在の着信音:${tone}";

  static String m29(date1, date2) => "${date1}から${date2}まで";

  static String m30(month, day) => "${month}月${day}日";

  static String m31(month, day, hour, mins) =>
      "${month}月${day}日,${hour}:${mins}";

  static String m32(money) => "${money}日前";

  static String m33(money) => "${money}日後";

  static String m34(title) => "タスク \'${title}\'を削除";

  static String m35(note) => "デスクトップウィジェット${note}";

  static String m36(title) => "タイトル「${title}」を編集";

  static String m37(n) => "毎日${n}回";

  static String m38(title, time, num) =>
      "集中中にアプリを退出しました、タスク「${title}」、集中時間は${time}、${num}のバーチャルコインを獲得しました";

  static String m39(title) => "タスク「${title}」を完了しました";

  static String m40(value) => "期間：${value}";

  static String m41(value) => "数量：${value}";

  static String m42(duraiton) => "完成までの時間${duraiton}秒";

  static String m43(correct, error, percent) =>
      "${correct}個正解、${error}個不正解、正確率${percent}";

  static String m44(name) => "${name}をローカルに成功裏に取得しました、トレーニングを開始することができます";

  static String m45(app_name) => "${app_name} の時間管理者として";

  static String m46(title) => "\"${title}\"にタスクを追加し、「エンター」キーを押して保存します";

  static String m47(hour, min) => "${hour}時${min}分";

  static String m48(hour, min, sec) => "${hour}時${min}分${sec}秒";

  static String m49(num) => "最大${num}文字まで入力可能";

  static String m50(max) => "${max}文字を超えることはできません";

  static String m51(time) => "最大録音時間:${time}";

  static String m52(min, sec) => "${min}分${sec}秒";

  static String m53(year, month, day, weekday) =>
      "${year}年${month}月${day}日,${weekday}";

  static String m54(month, day, year) => "${year}年${month}月${day}日";

  static String m55(month, year) => "${year}年${month}月";

  static String m56(year, month, day, hour, min, weekday) =>
      "${year}年${month}月${day}日 ${hour}:${min},${weekday}";

  static String m57(missionTitle) => "${missionTitle}タスクが進行中です、停止しますか";

  static String m58(name) => "「${name}」タスクのリマインダー";

  static String m59(name) => "「${name}」打刻タスクリマインダー";

  static String m60(submission, mission) =>
      "タスク${mission}のサブタスク${submission}が始まりました、準備をしてください";

  static String m61(title) => "タスク\"${title}\"";

  static String m62(value) => "まず、あなたの時間あたりの価値を設定してください${value}\$/時間";

  static String m63(title) => "リストのタイトルを「${title}」に変更しました";

  static String m64(title) => "タグを「${title}」に変更しました";

  static String m65(month, day, weekday) => "${month}月${day}日 ${weekday}";

  static String m66(month) => "${month}月の打刻率";

  static String m67(month) => "${month}月の打刻ログ";

  static String m68(course) => "私の${course}";

  static String m69(ranking) => "${ranking}位";

  static String m70(ranking) => "今回のランキングは${ranking}位です";

  static String m71(days) => "${days}日遅れ";

  static String m72(newline) => "改行:${newline}";

  static String m73(title, min, secs) => "${title}(残り時間:${min}:${secs}）";

  static String m74(value, hour, mins) =>
      "今日は${value}個のタスクを完了する必要があります、予想時間は${hour}時間${mins}分です";

  static String m75(n, hour, mins) =>
      "${n}個のタスクが遅延しています、予想時間は${hour}時間${mins}分です";

  static String m76(days) => "${days}日";

  static String m77(num) => "${num}分";

  static String m78(num, total) => "リスト${num}/${total}";

  static String m79(num, total) => "${num}/${total}";

  static String m80(num) => "${num}個のタスク";

  static String m81(num) => "${num}回";

  static String m82(num) => "${num}個";

  static String m83(number) => "${number}個の賞品";

  static String m84(name) => "リスト「${name}」のパスワードを入力してください";

  static String m85(xxx) => "${xxx}を入力してください";

  static String m86(name) => "アプリストアで\"${name}\"を検索してください";

  static String m87(content) => "${content}を選択してください";

  static String m88(present) => "${present}は何コイン必要ですか";

  static String m89(missionFinished, missionToDo, duration) =>
      "${missionFinished}完了、${missionToDo}を開始してください、${missionToDo}の時間：${duration}";

  static String m90(total) => "${total}回の繰り返し";

  static String m91(value) => "期間：${value}";

  static String m92(value) => "数量：${value}";

  static String m93(role, time, content, timestampFormat1, timestampFormat2,
          timestampFormat3) =>
      "あなたに${role}の役割を果たしてもらいたい、以下の内容を計画してください、時間は${time}、${content}、そしてjson objects配列を返します、JSON Objectsを返します\njsonの各フィールドのkey値と説明は以下の通りです\nString? title = \'\'; //タイトル 必須 \nint? total_tomotoes; //結果を直接計算します 完成したトマトの数 (daily_end_time - daily_start_time)/tomato_duration \nint? tomato_duration = 1500000;  //結果を直接計算します 値は常に25 * 60 * 1000ミリ秒で、1つのトマトが25分間集中することを示します \nString? end_time; //結果を直接計算します ${timestampFormat1}形式の終了時間 必須 \nint? priorityStatus; //3 なし 2 低 1 中 0 高 必須 \nString? daily_start_time; //結果を直接計算します ${timestampFormat2}形式のタスク開始時間   \nString? daily_end_time; //結果を直接計算します ${timestampFormat3}形式のタスク終了時間 \nString? message; //タスクリマインダー \n注意: nullであってはならない、key:valueのvalueは直接結果を与え、各タスクのdaily_start_timeとdaily_end_timeの時間は重複してはならない \ntitleはタイトルを明確に記述する必要があり、他の説明は必要ありません、各タスクは少なくとも5分間隔である必要があります\n 配列をルートとするjson文字列のみを返します 例[object,object,](注意:政治的な歴史については議論しない)";

  static String m94(title) => "タスク「${title}」の集中を開始しました";

  static String m95(title) => "休憩「${title}」を開始しました";

  static String m96(title, time, num) =>
      "タスク「${title}」の集中を停止しました、集中時間は${time}、${num}のバーチャルコインを獲得しました";

  static String m97(title) => "休憩「${title}」を停止しました";

  static String m98(money) => "${money}前";

  static String m99(money) => "${money}後";

  static String m100(date) => "${date}のデータ";

  static String m101(trainee) =>
      "注意してください、実際の状況に応じて行動してください。${trainee}の回答に満足していない場合は、${trainee}と詳細な命令を通じて時間を計画するように依頼することができます。";

  static String m102(trainee) => "${trainee}のアドバイス";

  static String m103(time) => "最後の更新時間:${time}";

  static String m104(listing, title) => "リスト「${listing}」のタスク「${title}」を更新しました";

  static String m105(title) => "タスク「${title}」を更新しました";

  static String m106(value) => "価値:${value}";

  static String m107(value) => "${value}\$/時間";

  static String m108(version) => "現在のバージョン${version}";

  static String m109(appName) => "\"${appName}\"へようこそ";

  static String m110(diary) => "日記「${diary}」を書きました";

  static String m111(diary) => "ノート「${diary}」を書きました";

  static String m112(text) => "${text}は空にできません";

  static String m113(month, year) => "${year}年${month}月";

  static String m114(name) => "あなたの設定した打刻タスク「${name}」が始まりました。打刻しましょう";

  static String m115(name) => "あなたのタスク「${name}」の通知が始まりました。準備してください";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("約"),
        "account": MessageLookupByLibrary.simpleMessage("アカウント"),
        "account_unregister": MessageLookupByLibrary.simpleMessage("アカウント登録解除"),
        "addBill": MessageLookupByLibrary.simpleMessage("請求書を追加する"),
        "addBillReminder":
            MessageLookupByLibrary.simpleMessage("請求書を追加し、返済をリマインドし、期限を避ける"),
        "addMissions2": MessageLookupByLibrary.simpleMessage("ミッションを追加..."),
        "add_bill": MessageLookupByLibrary.simpleMessage("請求書を追加する"),
        "add_content": MessageLookupByLibrary.simpleMessage("ノートを始める"),
        "add_credit_card_bill":
            MessageLookupByLibrary.simpleMessage("クレジットカードの請求書を追加する"),
        "add_fail": MessageLookupByLibrary.simpleMessage("追加失敗"),
        "add_group": MessageLookupByLibrary.simpleMessage("グループを追加"),
        "add_group_cannot_reorder":
            MessageLookupByLibrary.simpleMessage("グループを追加すると並べ替えできません"),
        "add_group_on_the_left":
            MessageLookupByLibrary.simpleMessage("左側にグループを追加"),
        "add_group_on_the_right":
            MessageLookupByLibrary.simpleMessage("右側にグループを追加"),
        "add_link": MessageLookupByLibrary.simpleMessage("リンクを追加"),
        "add_listing": MessageLookupByLibrary.simpleMessage("リストを追加"),
        "add_note": MessageLookupByLibrary.simpleMessage("ノートを書く"),
        "add_reminder": MessageLookupByLibrary.simpleMessage("リマインダーを追加"),
        "add_successfully":
            MessageLookupByLibrary.simpleMessage("追加成功、タイムラインで確認してください"),
        "add_tag": MessageLookupByLibrary.simpleMessage("タグを追加"),
        "add_task": MessageLookupByLibrary.simpleMessage("タスクを追加"),
        "add_username": MessageLookupByLibrary.simpleMessage("ユーザー名を追加"),
        "addsuccess": MessageLookupByLibrary.simpleMessage("追加成功"),
        "agree": MessageLookupByLibrary.simpleMessage("同意"),
        "ai_create": MessageLookupByLibrary.simpleMessage("AI作成"),
        "ai_helper": MessageLookupByLibrary.simpleMessage("AIアシスタント"),
        "alert": MessageLookupByLibrary.simpleMessage("アラート"),
        "alertMessage1": MessageLookupByLibrary.simpleMessage("トマトの数は0にできません"),
        "alertMessage2": MessageLookupByLibrary.simpleMessage("タイトルは空にできません"),
        "alert_time": MessageLookupByLibrary.simpleMessage("通知時間"),
        "alipay": MessageLookupByLibrary.simpleMessage("アリペイ"),
        "all": MessageLookupByLibrary.simpleMessage("全て"),
        "allUnfinishedMissions":
            MessageLookupByLibrary.simpleMessage("すべての未完了ミッション"),
        "all_finished_mission":
            MessageLookupByLibrary.simpleMessage("すべての完了したミッション"),
        "all_mission": MessageLookupByLibrary.simpleMessage("すべてのミッション"),
        "all_pending_repayment": MessageLookupByLibrary.simpleMessage("すべて未返済"),
        "already_delay": MessageLookupByLibrary.simpleMessage("遅延しました"),
        "already_exist":
            MessageLookupByLibrary.simpleMessage("トレーニングプランはすでに作成されています"),
        "already_exists_at_this_time":
            MessageLookupByLibrary.simpleMessage("この時間はすでに存在します"),
        "already_in_course":
            MessageLookupByLibrary.simpleMessage("すでにコースに参加しています"),
        "already_persisted": MessageLookupByLibrary.simpleMessage("すでに続けています"),
        "amount": MessageLookupByLibrary.simpleMessage("金額"),
        "analyse": MessageLookupByLibrary.simpleMessage("分析"),
        "analytics": MessageLookupByLibrary.simpleMessage("分析"),
        "anki_card_prompt": MessageLookupByLibrary.simpleMessage(
            "{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: What is th, folder_id: null, flomo_object_id: null, type: 2, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 2, wqbWrongQuestionContent: 不規則動詞「go」の過去形は何ですか？\n\n, wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: 「go」の過去形は「went」です。例：彼は昨日店に行きました。\n\nこのカードは、英語の一般的な不規則動詞の過去形を覚えて練習するのに役立ちます。, wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}"),
        "answer": MessageLookupByLibrary.simpleMessage("答え"),
        "appThmeSetting": MessageLookupByLibrary.simpleMessage("テーマカラーパネル設定"),
        "app_name": MessageLookupByLibrary.simpleMessage("時間管理局ToDo"),
        "apple_login": MessageLookupByLibrary.simpleMessage("Appleでログイン"),
        "apr": MessageLookupByLibrary.simpleMessage("4月"),
        "aprFull": MessageLookupByLibrary.simpleMessage("4月"),
        "archive": MessageLookupByLibrary.simpleMessage("アーカイブ"),
        "archived": MessageLookupByLibrary.simpleMessage("アーカイブ済み"),
        "arithmetic_error": MessageLookupByLibrary.simpleMessage("計算エラー"),
        "at_least_one_prize":
            MessageLookupByLibrary.simpleMessage("少なくとも1つの賞を選択してください"),
        "aug": MessageLookupByLibrary.simpleMessage("8月"),
        "augFull": MessageLookupByLibrary.simpleMessage("8月"),
        "author_intro": MessageLookupByLibrary.simpleMessage("著者紹介"),
        "author_presentation_content":
            MessageLookupByLibrary.simpleMessage("著者について"),
        "auto": MessageLookupByLibrary.simpleMessage("自動"),
        "auto_next_off": MessageLookupByLibrary.simpleMessage("ループを閉じる"),
        "auto_next_on": MessageLookupByLibrary.simpleMessage("ループを開く"),
        "avatar": MessageLookupByLibrary.simpleMessage("アバターを選択してください"),
        "back": MessageLookupByLibrary.simpleMessage("戻る"),
        "back_card": MessageLookupByLibrary.simpleMessage("バックカード"),
        "background": MessageLookupByLibrary.simpleMessage("壁紙"),
        "background_auto_mode":
            MessageLookupByLibrary.simpleMessage("壁紙自動切り替え"),
        "background_change_auto_prompt_off":
            MessageLookupByLibrary.simpleMessage("自動壁紙切り替えがオフになりました"),
        "background_change_auto_prompt_on":
            MessageLookupByLibrary.simpleMessage("壁紙は自動的にオンになりました"),
        "background_setting": MessageLookupByLibrary.simpleMessage("背景設定"),
        "bank": MessageLookupByLibrary.simpleMessage("銀行"),
        "batch_complete_missions": m0,
        "batch_delete_missions": m1,
        "batch_uncomplete_missions": m2,
        "batch_update_missions": m3,
        "bePening": MessageLookupByLibrary.simpleMessage("保留中"),
        "bill_cleared": MessageLookupByLibrary.simpleMessage("この期間はすでに返済済み"),
        "bill_day": MessageLookupByLibrary.simpleMessage("請求日"),
        "bill_detail": MessageLookupByLibrary.simpleMessage("請求明細"),
        "bill_this_statement": MessageLookupByLibrary.simpleMessage("本期账单"),
        "billing_day": MessageLookupByLibrary.simpleMessage("請求日"),
        "browse": MessageLookupByLibrary.simpleMessage("クリックして閲覧"),
        "browser_not_support_multiline": MessageLookupByLibrary.simpleMessage(
            "ブラウザは複数行の入力をサポートしていません。より良い体験のために、クライアントをダウンロードすることができます。"),
        "buy_training_plan":
            MessageLookupByLibrary.simpleMessage("トレーニングプランを購入"),
        "byday": MessageLookupByLibrary.simpleMessage("日"),
        "calculateTomatoesTime": m4,
        "calendar": MessageLookupByLibrary.simpleMessage("スケジュール"),
        "calendar2": MessageLookupByLibrary.simpleMessage("カレンダー"),
        "camera_permission_description": MessageLookupByLibrary.simpleMessage(
            "写真機能を使用するためには、カメラの権限を許可する必要があります"),
        "can_not_be_empty": MessageLookupByLibrary.simpleMessage("入力欄は空にできません"),
        "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "capture_a_photo": MessageLookupByLibrary.simpleMessage("写真を撮る"),
        "capture_a_video": MessageLookupByLibrary.simpleMessage("ビデオを録画"),
        "card": MessageLookupByLibrary.simpleMessage("カード"),
        "card_number": MessageLookupByLibrary.simpleMessage("カード番号"),
        "carelessness": MessageLookupByLibrary.simpleMessage("不注意"),
        "cause_analysis": MessageLookupByLibrary.simpleMessage("原因分析"),
        "change_background": MessageLookupByLibrary.simpleMessage("背景を切り替える"),
        "change_bg": MessageLookupByLibrary.simpleMessage("壁紙を選択"),
        "chat": MessageLookupByLibrary.simpleMessage("チャット"),
        "chatgpt": MessageLookupByLibrary.simpleMessage("AI"),
        "chatgpt_ai_username_huawei":
            MessageLookupByLibrary.simpleMessage("先生"),
        "chatgpt_desc":
            MessageLookupByLibrary.simpleMessage("あなたの質問はここで答えを見つけることができます"),
        "chatgpt_desc_huawei":
            MessageLookupByLibrary.simpleMessage("あなたの質問はここで答えを見つけることができます"),
        "chatgpt_huawei": MessageLookupByLibrary.simpleMessage("AIアシスタント"),
        "chronograph": MessageLookupByLibrary.simpleMessage("ストップウォッチ"),
        "click_copy_qq": MessageLookupByLibrary.simpleMessage("QQ番号をコピー"),
        "click_to_view": MessageLookupByLibrary.simpleMessage("クリックして表示"),
        "clock_in": MessageLookupByLibrary.simpleMessage("打刻"),
        "clock_in_calendar": MessageLookupByLibrary.simpleMessage("打刻カレンダー"),
        "clockin_n_days_continuously": m5,
        "clockin_n_days_totally": m6,
        "close": MessageLookupByLibrary.simpleMessage("閉じる"),
        "close_all_cycle_mission":
            MessageLookupByLibrary.simpleMessage("すべてのサイクルミッションを閉じる"),
        "close_multi": MessageLookupByLibrary.simpleMessage("複数選択を閉じる"),
        "cloud_sync": MessageLookupByLibrary.simpleMessage("クラウド同期"),
        "cloud_sync_content":
            MessageLookupByLibrary.simpleMessage("クロスエンドデータ同期用"),
        "code_dynamic_code_incorrect":
            MessageLookupByLibrary.simpleMessage("動的コードが正しくありません"),
        "code_user_exist": MessageLookupByLibrary.simpleMessage("ユーザーは既に存在します"),
        "code_user_not_exist":
            MessageLookupByLibrary.simpleMessage("ユーザーが存在しません"),
        "code_user_password_not_correct":
            MessageLookupByLibrary.simpleMessage("アカウントまたはパスワードが正しくありません"),
        "color_optional": MessageLookupByLibrary.simpleMessage("色(必須)"),
        "comingSoon": MessageLookupByLibrary.simpleMessage("7日以内"),
        "comment": MessageLookupByLibrary.simpleMessage("コメント"),
        "comment_not_empty":
            MessageLookupByLibrary.simpleMessage("コメントは空にできません"),
        "comment_placeholder": MessageLookupByLibrary.simpleMessage(
            "あなたの合理的な提案は、私たちが可能な限り1週間以内に実装します"),
        "compare_to_tomorrow": MessageLookupByLibrary.simpleMessage("昨日と比較"),
        "complete": MessageLookupByLibrary.simpleMessage("完了"),
        "complete_flomo_mission": m7,
        "complete_focusing_mission_name": m8,
        "complete_one_time_focusing_mission_name": m9,
        "complete_plan_classification":
            MessageLookupByLibrary.simpleMessage("完了した計画の分類"),
        "complete_resting_mission_name": m10,
        "complete_resting_name": m11,
        "complete_voice_diary": MessageLookupByLibrary.simpleMessage("音声日記を完成"),
        "complete_voice_diary_with_title": m12,
        "complete_voice_note": MessageLookupByLibrary.simpleMessage("音声メモを完成"),
        "completed": MessageLookupByLibrary.simpleMessage("完了"),
        "completed_days": MessageLookupByLibrary.simpleMessage("完了日数"),
        "completion_degree": MessageLookupByLibrary.simpleMessage("完成度"),
        "completion_rate": MessageLookupByLibrary.simpleMessage("完了率"),
        "confirm": MessageLookupByLibrary.simpleMessage("確認"),
        "confirmRestDuration":
            MessageLookupByLibrary.simpleMessage("デフォルトの休憩時間"),
        "confirmToDelete": MessageLookupByLibrary.simpleMessage(
            "削除してもよろしいですか?\n注意:削除したミッションは復元できません"),
        "confirmToFinishMission":
            MessageLookupByLibrary.simpleMessage("このミッションを完了したことを確認しますか?"),
        "confirmToFinished": MessageLookupByLibrary.simpleMessage("完了を確認"),
        "confirmToFinishedContent":
            MessageLookupByLibrary.simpleMessage("このミッションを完了したことを確認しますか?"),
        "confirmToSyncCloudData": MessageLookupByLibrary.simpleMessage(
            "クラウド同期を確認しますか（注意：通常、1つの携帯電話に2つのアカウントがログインしており、以前の携帯電話番号のデータを現在の携帯電話番号に同期する必要がある場合にのみ使用する必要があります）？"),
        "confirm_delete_folder": m13,
        "confirm_delete_folder_desc":
            MessageLookupByLibrary.simpleMessage("削除後、復元することはできません"),
        "confirm_delete_mission_models": m14,
        "confirm_deletion": MessageLookupByLibrary.simpleMessage("削除を確認"),
        "confirm_unregister": MessageLookupByLibrary.simpleMessage("登録解除を確認"),
        "confused": MessageLookupByLibrary.simpleMessage("概念がぼやけている"),
        "consider_it": MessageLookupByLibrary.simpleMessage("考えてみてください"),
        "consume_failure": MessageLookupByLibrary.simpleMessage("消費失敗"),
        "consume_money": m15,
        "consume_money_buy_present": m16,
        "consume_success": MessageLookupByLibrary.simpleMessage("消費成功"),
        "consump_money": MessageLookupByLibrary.simpleMessage("コインを消費する:"),
        "consump_present": MessageLookupByLibrary.simpleMessage("消費可能な賞品"),
        "consump_present_description":
            MessageLookupByLibrary.simpleMessage("集中してお金を稼いだときに自分に報酬を与える"),
        "content": MessageLookupByLibrary.simpleMessage("内容"),
        "content_cannot_be_empty":
            MessageLookupByLibrary.simpleMessage("内容は空にできません"),
        "continously_clockin": MessageLookupByLibrary.simpleMessage("連続クロックイン"),
        "continue2": MessageLookupByLibrary.simpleMessage("続ける"),
        "continueTxt": MessageLookupByLibrary.simpleMessage("続ける"),
        "continuous_clock_in": MessageLookupByLibrary.simpleMessage("連続打刻"),
        "continuous_days": MessageLookupByLibrary.simpleMessage("連続日数"),
        "continuously": MessageLookupByLibrary.simpleMessage("継続中"),
        "copy": MessageLookupByLibrary.simpleMessage("コピー"),
        "copy_qq": MessageLookupByLibrary.simpleMessage(
            "QQグループ番号（563144208）をコピーしてクリックし、公式QQグループに参加してください"),
        "copy_qq_success": MessageLookupByLibrary.simpleMessage(
            "コピー成功、QQを開いてペーストして公式QQグループに参加してください"),
        "copy_sub_title": MessageLookupByLibrary.simpleMessage(
            "新しいバージョンの情報をすぐに取得し、新しい機能のフィードバックを提供することができます"),
        "copy_success": MessageLookupByLibrary.simpleMessage("コピー成功"),
        "correct_answer": MessageLookupByLibrary.simpleMessage("正解"),
        "count_down": m17,
        "count_down2": m18,
        "count_down3": m19,
        "count_down_text": MessageLookupByLibrary.simpleMessage("カウントダウン"),
        "counting": MessageLookupByLibrary.simpleMessage("計時中"),
        "course": MessageLookupByLibrary.simpleMessage("コース"),
        "course_desc": MessageLookupByLibrary.simpleMessage(
            "高得点を取りたい、ダイエットしたい、ここに答えがあります"),
        "course_intro": MessageLookupByLibrary.simpleMessage("コース紹介"),
        "course_introduction": MessageLookupByLibrary.simpleMessage("コース紹介"),
        "create": MessageLookupByLibrary.simpleMessage("作成"),
        "createMission": MessageLookupByLibrary.simpleMessage("リストを作成"),
        "createSuccess": MessageLookupByLibrary.simpleMessage("作成成功"),
        "createTag": MessageLookupByLibrary.simpleMessage("タグを作成"),
        "create_chat": MessageLookupByLibrary.simpleMessage("チャットを作成"),
        "create_folder_desc": MessageLookupByLibrary.simpleMessage("フォルダを作成する"),
        "create_mission": MessageLookupByLibrary.simpleMessage("タスクを作成する"),
        "create_mission_by_content": MessageLookupByLibrary.simpleMessage(
            "タスクを作成してください:\nタスクタイトル:\n説明:"),
        "create_mission_by_gpt":
            MessageLookupByLibrary.simpleMessage("タスクまたはリストを作成する"),
        "create_mission_by_title":
            MessageLookupByLibrary.simpleMessage("タスクを作成する"),
        "create_mission_title": MessageLookupByLibrary.simpleMessage("チャートを表示"),
        "create_mission_title_content":
            MessageLookupByLibrary.simpleMessage("チャートを表示\n時間:"),
        "create_name_flomo_mission": m20,
        "create_name_flomomission": m21,
        "create_name_flomomission2": m22,
        "create_name_listing": m23,
        "create_name_mission": m24,
        "create_name_mission2": m25,
        "create_name_tag": m26,
        "create_present": MessageLookupByLibrary.simpleMessage("報酬を作成"),
        "create_success": MessageLookupByLibrary.simpleMessage("作成成功"),
        "create_time": MessageLookupByLibrary.simpleMessage("作成時間"),
        "create_xxx": m27,
        "creating_date": MessageLookupByLibrary.simpleMessage("作成日"),
        "credit_bag": MessageLookupByLibrary.simpleMessage("カードバッグ"),
        "credit_limit": MessageLookupByLibrary.simpleMessage("信用限度"),
        "curAnalytics": MessageLookupByLibrary.simpleMessage("リアルタイムデータ"),
        "curTimeF": MessageLookupByLibrary.simpleMessage("開始時間"),
        "currentRingTone": m28,
        "current_amount": MessageLookupByLibrary.simpleMessage("現在の金額"),
        "custom": MessageLookupByLibrary.simpleMessage("カスタム"),
        "customize": MessageLookupByLibrary.simpleMessage("カスタマイズ"),
        "daily_completion_times":
            MessageLookupByLibrary.simpleMessage("毎日の完成回数"),
        "daily_end_time": MessageLookupByLibrary.simpleMessage("毎日の終了時間"),
        "daily_start_time": MessageLookupByLibrary.simpleMessage("毎日の開始時間"),
        "dark_mode": MessageLookupByLibrary.simpleMessage("暗黑模式"),
        "data_analyse": MessageLookupByLibrary.simpleMessage("データ分析"),
        "data_analyse_desc": MessageLookupByLibrary.simpleMessage(
            "リアルタイムデータ分析により、自分自身をよりよく理解するのに役立ちます"),
        "date": MessageLookupByLibrary.simpleMessage("日付"),
        "date1_to_date2": m29,
        "dateFromMonth": m30,
        "dateFromMonthToMins": m31,
        "dateOutOfLimit":
            MessageLookupByLibrary.simpleMessage("選択した日付が範囲を超えています"),
        "day": MessageLookupByLibrary.simpleMessage("日"),
        "day_hour_minute_second": MessageLookupByLibrary.simpleMessage("日時分秒"),
        "daysLater": MessageLookupByLibrary.simpleMessage("日後"),
        "days_after_bill_day": MessageLookupByLibrary.simpleMessage("請求日後の日数"),
        "days_after_repayment_day":
            MessageLookupByLibrary.simpleMessage("返済日後の日数"),
        "days_ago": m32,
        "days_later": m33,
        "de": MessageLookupByLibrary.simpleMessage("の"),
        "deadLine": MessageLookupByLibrary.simpleMessage("締め切り"),
        "dec": MessageLookupByLibrary.simpleMessage("12月"),
        "decFull": MessageLookupByLibrary.simpleMessage("12月"),
        "decrypt": MessageLookupByLibrary.simpleMessage("復号化"),
        "defaultFocusDuration":
            MessageLookupByLibrary.simpleMessage("デフォルトの集中時間"),
        "delay_mission": MessageLookupByLibrary.simpleMessage("ミッションを遅らせる"),
        "delete": MessageLookupByLibrary.simpleMessage("削除"),
        "delete_flomo_mission": m34,
        "delete_success": MessageLookupByLibrary.simpleMessage("削除成功"),
        "desc_consume": MessageLookupByLibrary.simpleMessage("消費の説明"),
        "desktop_widget_with_note_n": m35,
        "detailed_training_plan":
            MessageLookupByLibrary.simpleMessage("詳細なトレーニングプラン"),
        "detailed_training_plan_desc": MessageLookupByLibrary.simpleMessage(
            "共有者により詳しいトレーニングプランを提供し、彼らが自分自身をより詳細に向上させるのを助けます"),
        "detailed_training_plan_desc_2": MessageLookupByLibrary.simpleMessage(
            "このコースのより詳細なコースプランを見るにはクリックしてください"),
        "detailed_training_plan_optional":
            MessageLookupByLibrary.simpleMessage("詳細なトレーニングプラン（任意）"),
        "diary": MessageLookupByLibrary.simpleMessage("日記"),
        "digit_password_incorrect":
            MessageLookupByLibrary.simpleMessage("数字のパスワードが間違っています"),
        "do_it_now": MessageLookupByLibrary.simpleMessage("今すぐやる"),
        "dollar": MessageLookupByLibrary.simpleMessage("\$"),
        "dont_remind_again": MessageLookupByLibrary.simpleMessage("再度表示しない"),
        "downloading_please_wait":
            MessageLookupByLibrary.simpleMessage("ダウンロード中、お待ちください…"),
        "each": MessageLookupByLibrary.simpleMessage("毎"),
        "eachSpace": MessageLookupByLibrary.simpleMessage("毎"),
        "edit": MessageLookupByLibrary.simpleMessage("編集"),
        "edit_fail": MessageLookupByLibrary.simpleMessage("編集失敗"),
        "edit_sharing": MessageLookupByLibrary.simpleMessage("共有を編集"),
        "edit_successfully":
            MessageLookupByLibrary.simpleMessage("編集成功、タイムラインで確認してください"),
        "edit_title": m36,
        "editing": MessageLookupByLibrary.simpleMessage("編集中"),
        "emailCannotBeNull":
            MessageLookupByLibrary.simpleMessage("メールアドレスは空にできません"),
        "encourage_yourself":
            MessageLookupByLibrary.simpleMessage("自分自身を励ましの言葉を書きましょう~"),
        "encrypt": MessageLookupByLibrary.simpleMessage("暗号化"),
        "encrypt_desc": MessageLookupByLibrary.simpleMessage(
            "暗号化後は、設定した数字パスワードを使用してのみ復号化できます。機密データにこの機能を使用することをお勧めします。そうでない場合、ユーザーエクスペリエンスに影響を与える可能性があります"),
        "encrypt_password":
            MessageLookupByLibrary.simpleMessage("数字パスワードを設定してください"),
        "encrypt_password_confirm":
            MessageLookupByLibrary.simpleMessage("数字パスワードを再度入力してください"),
        "encrypt_password_not_match":
            MessageLookupByLibrary.simpleMessage("入力されたパスワードが一致しません"),
        "encrypt_password_not_set":
            MessageLookupByLibrary.simpleMessage("数字パスワードが設定されていません"),
        "encrypt_store_password":
            MessageLookupByLibrary.simpleMessage("数字パスワードをローカルに保存する"),
        "end_time": MessageLookupByLibrary.simpleMessage("完了時間"),
        "end_time_cannot_before_start_time":
            MessageLookupByLibrary.simpleMessage("終了時間は開始時間より早くすることはできません"),
        "endtime_cannot_before_starttime":
            MessageLookupByLibrary.simpleMessage("終了時間は開始時間より早くすることはできません"),
        "enterBankName": MessageLookupByLibrary.simpleMessage("銀行名を入力してください"),
        "enterBillAmount":
            MessageLookupByLibrary.simpleMessage("請求書の金額を入力してください"),
        "enterCreditLimit":
            MessageLookupByLibrary.simpleMessage("信用限度を入力してください（任意）"),
        "enterFullCardNumber":
            MessageLookupByLibrary.simpleMessage("完全なカード番号を入力してください"),
        "enterRealName": MessageLookupByLibrary.simpleMessage("本名を入力してください"),
        "enter_amount": MessageLookupByLibrary.simpleMessage("金額を入力してください"),
        "event": MessageLookupByLibrary.simpleMessage("イベント"),
        "everyDayOnce": m37,
        "examination": MessageLookupByLibrary.simpleMessage("問題の誤解"),
        "example_demo_hint": MessageLookupByLibrary.simpleMessage(
            "例：「常に箇条書きで説明し、unwrapを使用しない、常に英語で回答を出力する」"),
        "exist_app_focusing_mission_name": m38,
        "export": MessageLookupByLibrary.simpleMessage("エクスポート"),
        "export_data": MessageLookupByLibrary.simpleMessage("データをエクスポート"),
        "export_excel": MessageLookupByLibrary.simpleMessage("Excelをエクスポート"),
        "feb": MessageLookupByLibrary.simpleMessage("2月"),
        "febFull": MessageLookupByLibrary.simpleMessage("2月"),
        "feedback": MessageLookupByLibrary.simpleMessage("ユーザーフィードバック"),
        "filtering_setting": MessageLookupByLibrary.simpleMessage("フィルタリング設定"),
        "find_new_version":
            MessageLookupByLibrary.simpleMessage("新しいバージョンを見つけました"),
        "finish": MessageLookupByLibrary.simpleMessage("完了"),
        "finish_level": MessageLookupByLibrary.simpleMessage("完成度:"),
        "finish_mission_name": m39,
        "finish_time": MessageLookupByLibrary.simpleMessage("完成時間"),
        "finished": MessageLookupByLibrary.simpleMessage("完了"),
        "focus": MessageLookupByLibrary.simpleMessage("集中"),
        "focusFinished": MessageLookupByLibrary.simpleMessage("集中完了"),
        "focusPausing": MessageLookupByLibrary.simpleMessage("集中中断中"),
        "focus_campus": MessageLookupByLibrary.simpleMessage("集中トレーニングキャンプ"),
        "focus_completed_auto_start_rest":
            MessageLookupByLibrary.simpleMessage("集中が完了すると自動的に休憩が始まります"),
        "focus_duration": MessageLookupByLibrary.simpleMessage("集中時間"),
        "focus_duration_distribution":
            MessageLookupByLibrary.simpleMessage("集中時間の分布"),
        "focus_duration_with_value": m40,
        "focus_finished_ringtone":
            MessageLookupByLibrary.simpleMessage("集中終了の着信音"),
        "focus_numbers_with_value": m41,
        "focus_on_time_period_distribution":
            MessageLookupByLibrary.simpleMessage("集中時間帯の分布"),
        "focus_setting": MessageLookupByLibrary.simpleMessage("集中設定"),
        "focus_timer": MessageLookupByLibrary.simpleMessage("集中タイマー"),
        "focus_timer_desc":
            MessageLookupByLibrary.simpleMessage("複数のバックグラウンドミュージックで没我の境地に入る"),
        "focusing": MessageLookupByLibrary.simpleMessage("集中中"),
        "focusing_music": MessageLookupByLibrary.simpleMessage("集中中の音楽"),
        "folder": MessageLookupByLibrary.simpleMessage("フォルダ"),
        "folder_name": MessageLookupByLibrary.simpleMessage("フォルダ名"),
        "four_pws": MessageLookupByLibrary.simpleMessage("4桁の数字パスワードを入力してください"),
        "four_quadrant": MessageLookupByLibrary.simpleMessage("四象限"),
        "four_quadrant_priority1":
            MessageLookupByLibrary.simpleMessage("緊急 & 重要"),
        "four_quadrant_priority1_abbr":
            MessageLookupByLibrary.simpleMessage("緊急 & 重要"),
        "four_quadrant_priority1_desc":
            MessageLookupByLibrary.simpleMessage("優先的に解決"),
        "four_quadrant_priority2":
            MessageLookupByLibrary.simpleMessage("非緊急 & 重要"),
        "four_quadrant_priority2_abbr":
            MessageLookupByLibrary.simpleMessage("非緊急 & 重要"),
        "four_quadrant_priority2_desc":
            MessageLookupByLibrary.simpleMessage("計画を立てて行う"),
        "four_quadrant_priority3":
            MessageLookupByLibrary.simpleMessage("緊急 & 非重要"),
        "four_quadrant_priority3_abbr":
            MessageLookupByLibrary.simpleMessage("緊急 & 非重要"),
        "four_quadrant_priority3_desc":
            MessageLookupByLibrary.simpleMessage("他人に任せる"),
        "four_quadrant_priority4":
            MessageLookupByLibrary.simpleMessage("非重要 & 非緊急"),
        "four_quadrant_priority4_abbr":
            MessageLookupByLibrary.simpleMessage("非緊急 & 非重要"),
        "four_quadrant_priority4_desc":
            MessageLookupByLibrary.simpleMessage("時間があるときに行う"),
        "four_seasons": MessageLookupByLibrary.simpleMessage("第1四半期から第4四半期まで"),
        "four_seasons_desc":
            MessageLookupByLibrary.simpleMessage("第1四半期から第4四半期までのグループを作成します"),
        "four_seasons_step1": MessageLookupByLibrary.simpleMessage("第1四半期"),
        "four_seasons_step2": MessageLookupByLibrary.simpleMessage("第2四半期"),
        "four_seasons_step3": MessageLookupByLibrary.simpleMessage("第3四半期"),
        "four_seasons_step4": MessageLookupByLibrary.simpleMessage("第4四半期"),
        "fragment_listing": MessageLookupByLibrary.simpleMessage("フラグメントリスト"),
        "free_open": MessageLookupByLibrary.simpleMessage("無料公開"),
        "frequency": MessageLookupByLibrary.simpleMessage("頻度"),
        "friday": MessageLookupByLibrary.simpleMessage("金曜日"),
        "fridayShort": MessageLookupByLibrary.simpleMessage("金"),
        "front_card": MessageLookupByLibrary.simpleMessage("フロントカード"),
        "gallery": MessageLookupByLibrary.simpleMessage("ギャラリー"),
        "game1_time_usage": m42,
        "game2_ranking_text": m43,
        "game_input_waiting": MessageLookupByLibrary.simpleMessage("タイマー待ち"),
        "gently_remind": MessageLookupByLibrary.simpleMessage("優しいリマインダー"),
        "getVerificationCode": MessageLookupByLibrary.simpleMessage("認証コードを取得"),
        "get_train_plan_successful": m44,
        "get_training_plan":
            MessageLookupByLibrary.simpleMessage("トレーニングプランを取得"),
        "go_to_setting": MessageLookupByLibrary.simpleMessage("設定へ"),
        "google_login": MessageLookupByLibrary.simpleMessage("Googleログイン"),
        "gpt_role": m45,
        "gpt_system_msg_forbidden": MessageLookupByLibrary.simpleMessage(
            "数学、理学、英語、大学のコース、料理、株式、自動車、試験、エンターテイメント、科学技術、金融、スポーツ、健康、法律、ファッション、ペット、旅行、健康養生、育児、メディア、電子商取引、教育、物語、ポジティブエネルギーなどのトピックについてのみ議論します。他のトピックは許可されていません。中国の歴史、台湾、チベット、新疆、ポルノ、政治、その他の中国に関連するトピック、例えば六四事件などのトピックは一切回答できません。"),
        "gpt_token_expired": MessageLookupByLibrary.simpleMessage(
            "あなたのトークンは期限切れです、cannywillのWeChatを追加してgptアクセス権を申請してください"),
        "grid": MessageLookupByLibrary.simpleMessage("カテゴリ"),
        "groupview": MessageLookupByLibrary.simpleMessage("グループビュー"),
        "gtd": MessageLookupByLibrary.simpleMessage("GTD"),
        "gtd_desc": MessageLookupByLibrary.simpleMessage(
            "GTDの5つのステップ：；\n（1）私たちの注意を引くすべての事柄と情報を収集する；\n（2）収集した各項目の意味と関連するアクションを明確にする；\n（3）結果を整理し、各項目について次のアクションをリストアップする；\n（4）行動に移す；\n（5）定期的に振り返りとレビューを行う。"),
        "gtd_step1": MessageLookupByLibrary.simpleMessage("情報を収集する"),
        "gtd_step2": MessageLookupByLibrary.simpleMessage("意味を明確にする"),
        "gtd_step3": MessageLookupByLibrary.simpleMessage("整理する"),
        "gtd_step4": MessageLookupByLibrary.simpleMessage("行動する"),
        "gtd_step5": MessageLookupByLibrary.simpleMessage("レビューとまとめ"),
        "guide1": MessageLookupByLibrary.simpleMessage("集中を開始"),
        "guide2":
            MessageLookupByLibrary.simpleMessage("ヘッダーの入力ボックスをクリックしてタスクを追加"),
        "guide3_mobile":
            MessageLookupByLibrary.simpleMessage("タスクを右にスワイプして編集または削除"),
        "guide3_pc":
            MessageLookupByLibrary.simpleMessage("マウスをタスクに移動して編集または削除"),
        "guide4": MessageLookupByLibrary.simpleMessage("赤い再生ボタンをクリックして集中時間を計測"),
        "guide_examine_time": MessageLookupByLibrary.simpleMessage("試験時間"),
        "habit_clockin": MessageLookupByLibrary.simpleMessage("習慣チェックイン"),
        "habit_clockin_desc": MessageLookupByLibrary.simpleMessage(
            "21日で習慣を形成し、エビングハウスが長期間にわたって学んだ知識を覚えています"),
        "hasLogined": MessageLookupByLibrary.simpleMessage("ログイン済み"),
        "header_input_placeholder_with_title": m46,
        "heavy": MessageLookupByLibrary.simpleMessage("重い"),
        "hello": MessageLookupByLibrary.simpleMessage("こんにちは"),
        "hidden": MessageLookupByLibrary.simpleMessage("非表示"),
        "hint_search_chat": MessageLookupByLibrary.simpleMessage("チャット履歴を検索"),
        "history_event": MessageLookupByLibrary.simpleMessage("歴史的な出来事"),
        "hour": MessageLookupByLibrary.simpleMessage("時間"),
        "hour3": MessageLookupByLibrary.simpleMessage("時間"),
        "hourAndMin": m47,
        "hourAndMinAndSec": m48,
        "i_consume": MessageLookupByLibrary.simpleMessage("私は使う"),
        "i_know": MessageLookupByLibrary.simpleMessage("了解しました"),
        "icon": MessageLookupByLibrary.simpleMessage("アイコン"),
        "image": MessageLookupByLibrary.simpleMessage("画像"),
        "inSevenDays": MessageLookupByLibrary.simpleMessage("7日後"),
        "inputSmsVerificationCode":
            MessageLookupByLibrary.simpleMessage("SMS認証コードを入力"),
        "input_6_digit_password":
            MessageLookupByLibrary.simpleMessage("6桁の数字パスワードを入力してください"),
        "input_correct_mobile":
            MessageLookupByLibrary.simpleMessage("正しい携帯番号を入力してください"),
        "input_correct_password":
            MessageLookupByLibrary.simpleMessage("正しいパスワードを入力してください"),
        "input_end_time":
            MessageLookupByLibrary.simpleMessage("希望の終了時間を入力してください"),
        "input_manually": MessageLookupByLibrary.simpleMessage("手動で入力"),
        "input_mission_title_first":
            MessageLookupByLibrary.simpleMessage("タスクのタイトルを先に入力してください"),
        "input_mobile": MessageLookupByLibrary.simpleMessage("携帯番号を入力してください！"),
        "input_your_goal":
            MessageLookupByLibrary.simpleMessage("あなたが続けたい目標を入力してください~"),
        "insert_event": MessageLookupByLibrary.simpleMessage("イベントを挿入"),
        "insert_success": MessageLookupByLibrary.simpleMessage("挿入成功"),
        "invalid_mobile_number":
            MessageLookupByLibrary.simpleMessage("無効な携帯電話番号"),
        "isDelayed": MessageLookupByLibrary.simpleMessage("遅延したか"),
        "isEditable": MessageLookupByLibrary.simpleMessage("すべてのユーザーが共有編集状態"),
        "isFinished": MessageLookupByLibrary.simpleMessage("完了したか"),
        "is_push_setting": MessageLookupByLibrary.simpleMessage("指向性プッシュ設定"),
        "is_push_setting_detail": MessageLookupByLibrary.simpleMessage(
            "指向性プッシュ設定を開くと、タスクの完了通知の状況を通知するのに役立ちます"),
        "jan": MessageLookupByLibrary.simpleMessage("1月"),
        "janFull": MessageLookupByLibrary.simpleMessage("1月"),
        "jan_to_dec": MessageLookupByLibrary.simpleMessage("1月から12月まで"),
        "jan_to_dec_desc":
            MessageLookupByLibrary.simpleMessage("1月から12月までのグループを作成します"),
        "join_days": MessageLookupByLibrary.simpleMessage("参加日数"),
        "jul": MessageLookupByLibrary.simpleMessage("7月"),
        "julFull": MessageLookupByLibrary.simpleMessage("7月"),
        "jump_next_group": MessageLookupByLibrary.simpleMessage("次のグループにジャンプ"),
        "jump_previous_group":
            MessageLookupByLibrary.simpleMessage("前のグループにジャンプ"),
        "jump_to_this_version":
            MessageLookupByLibrary.simpleMessage("このバージョンをスキップ"),
        "jun": MessageLookupByLibrary.simpleMessage("6月"),
        "junFull": MessageLookupByLibrary.simpleMessage("6月"),
        "landscape": MessageLookupByLibrary.simpleMessage("横画面"),
        "lastWeek": MessageLookupByLibrary.simpleMessage("先週"),
        "last_7_days": MessageLookupByLibrary.simpleMessage("過去7日間"),
        "level1_num_10": MessageLookupByLibrary.simpleMessage("レベル1：10単語"),
        "level1_show_words":
            MessageLookupByLibrary.simpleMessage("レベル1：聞きながら見る"),
        "level2_hide_leftpart_words":
            MessageLookupByLibrary.simpleMessage("レベル2：左側の単語を隠す"),
        "level2_num_20": MessageLookupByLibrary.simpleMessage("レベル2：20単語"),
        "level3_hide_rightpart_words":
            MessageLookupByLibrary.simpleMessage("レベル3：右側の単語を隠す"),
        "level3_num_50": MessageLookupByLibrary.simpleMessage("レベル2：50単語"),
        "level4_hide_all_parts":
            MessageLookupByLibrary.simpleMessage("レベル4：すべての単語を隠す"),
        "level5_write_words": MessageLookupByLibrary.simpleMessage("レベル5：書き取り"),
        "light": MessageLookupByLibrary.simpleMessage("軽い"),
        "light_mode": MessageLookupByLibrary.simpleMessage("明亮模式"),
        "link": MessageLookupByLibrary.simpleMessage("リンク"),
        "list": MessageLookupByLibrary.simpleMessage("リスト"),
        "listing": MessageLookupByLibrary.simpleMessage("リスト"),
        "listing_icon_optional":
            MessageLookupByLibrary.simpleMessage("リストアイコン(必須)"),
        "listing_time_optional":
            MessageLookupByLibrary.simpleMessage("リスト時間(任意)"),
        "listview": MessageLookupByLibrary.simpleMessage("リストビュー"),
        "loading": MessageLookupByLibrary.simpleMessage("読み込み中"),
        "local_password": MessageLookupByLibrary.simpleMessage("ローカル数値パスワード"),
        "local_password_desc": MessageLookupByLibrary.simpleMessage(
            "ローカル数値パスワードは暗号化された後にのみ携帯電話に保存され、サーバーにアップロードされたり他のデバイスと同期されたりすることはありません。設定でローカル数値パスワードを設定できます"),
        "localmoney_made_per_minute":
            MessageLookupByLibrary.simpleMessage("1分あたりの収益"),
        "localmoney_made_per_minute_description":
            MessageLookupByLibrary.simpleMessage("自己激励のため"),
        "lock_app": MessageLookupByLibrary.simpleMessage("アプリをロック"),
        "lock_app_setting": MessageLookupByLibrary.simpleMessage("アプリのロック設定"),
        "lock_app_setting_description": MessageLookupByLibrary.simpleMessage(
            "アプリをロックすると、不必要なアプリの邪魔を受けずに集中するのに役立ちます"),
        "lock_screen_auto_password_setting":
            MessageLookupByLibrary.simpleMessage("ロック画面の自動パスワード設定"),
        "lock_screen_auto_password_setting_for_applock":
            MessageLookupByLibrary.simpleMessage("アプリロックのためのロック画面自動パスワード設定"),
        "lock_screen_password_setting":
            MessageLookupByLibrary.simpleMessage("ロック画面のパスワード設定"),
        "login": MessageLookupByLibrary.simpleMessage("ログイン"),
        "loginContent":
            MessageLookupByLibrary.simpleMessage("新規ユーザーは自動的にアカウントが作成されます"),
        "loginFirst": MessageLookupByLibrary.simpleMessage("先にログインしてください"),
        "login_success": MessageLookupByLibrary.simpleMessage("ログイン成功"),
        "logout": MessageLookupByLibrary.simpleMessage("ログアウト"),
        "loop_setting": MessageLookupByLibrary.simpleMessage("ループ設定"),
        "lottery": MessageLookupByLibrary.simpleMessage("抽選"),
        "manual": MessageLookupByLibrary.simpleMessage("手動"),
        "manual_create": MessageLookupByLibrary.simpleMessage("手動作成"),
        "mar": MessageLookupByLibrary.simpleMessage("3月"),
        "marFull": MessageLookupByLibrary.simpleMessage("3月"),
        "mark_repaid_amount":
            MessageLookupByLibrary.simpleMessage("返済済みの金額をマークする"),
        "mark_repayment_amount":
            MessageLookupByLibrary.simpleMessage("返済額をマークする"),
        "mastering_the_situation":
            MessageLookupByLibrary.simpleMessage("状況を把握する"),
        "max_5m_files_size": MessageLookupByLibrary.simpleMessage(
            "ファイルサイズが5MBを超えています。もっと小さいファイルを選んでください。"),
        "max_input_num": m49,
        "max_words": m50,
        "maximum_recording_time": m51,
        "may": MessageLookupByLibrary.simpleMessage("5月"),
        "mayFull": MessageLookupByLibrary.simpleMessage("5月"),
        "me": MessageLookupByLibrary.simpleMessage("私"),
        "memo_prompt": MessageLookupByLibrary.simpleMessage(
            "{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: 週末の買い物リスト - 11月5日, folder_id: null, flomo_object_id: null, type: 3, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 0, wqbWrongQuestionContent: , wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: 新鮮な果物：リンゴ（約2キロ）、オレンジ（1袋）、ドラゴンフルーツ（2個）\n野菜：ほうれん草（1束）、トマト（5個）、きゅうり（3本）\n肉類：鶏の胸肉（500グラム）、ステーキ（2枚）\nスナック：ポテトチップス（2袋）、チョコレート（100グラム）\n日用品：ハンドソープ（1本）、食器用洗剤（1本）、トイレットペーパー（1パック）\n飲み物：牛乳（1パック）、緑茶（1パック）\n備考：\n\nクーポンとメンバーカードの有効性を確認する\nできるだけオーガニック製品と環境に優しいパッケージを選ぶ\n18:00までに買い物を終える, wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}"),
        "memorandum": MessageLookupByLibrary.simpleMessage("メモ"),
        "memorized": MessageLookupByLibrary.simpleMessage("覚えた"),
        "memorizing": MessageLookupByLibrary.simpleMessage("記憶中"),
        "message": MessageLookupByLibrary.simpleMessage("メッセージ"),
        "method": MessageLookupByLibrary.simpleMessage("方法"),
        "micro_mastery": MessageLookupByLibrary.simpleMessage("マイクロマスタリー"),
        "micro_mastery_desc": MessageLookupByLibrary.simpleMessage(
            "マイクロマスタリー\n\n私たちはよく、何かをマスターするには、全ての情熱を注ぎ込み、10,000時間の厳しい練習を積む必要があると言われます。しかし実際には、ノーベル賞受賞者を含むほとんどの成功した人々は、新しいスキルを学び、新しい活動を始めるために余暇を利用しています。\n\nマイクロマスタリーは4つの部分に分けることができます\n1.入門スキルを見つける - 理論ではなく、実践から始め、業界の専門家による簡単な試みに基づく\n2.背景サポートを得る - 何かに取り組むための動機を得るために、装備を購入し、儀式感を作り出すなど\n3.明確な報酬を作る - 肯定的および否定的なフィードバックを受け取り、良い循環を形成し、他人に教えるなど、学んだことを応用し、目標のない先延ばしを避ける\n4.再現性を作る - 継続的に繰り返すことができ、各繰り返しで改善し、進歩を遂げることができる。これにより自信が増し、観察力が鋭くなる\n\n成功例\nスティーブ・ジョブズは、大学をサボって学んだ書道の芸術を世界中のMacに応用し、芸術的な視点からコンピュータを設計し、非常に人気を博しました"),
        "micro_mastery_step1":
            MessageLookupByLibrary.simpleMessage("入門スキルを見つける"),
        "micro_mastery_step2":
            MessageLookupByLibrary.simpleMessage("背景サポートを得る"),
        "micro_mastery_step3": MessageLookupByLibrary.simpleMessage("明確な報酬を作る"),
        "micro_mastery_step4": MessageLookupByLibrary.simpleMessage("再現性を作る"),
        "microphone_permission_description":
            MessageLookupByLibrary.simpleMessage(
                "メモを取る際に録音機能が必要な場合があります。その際は、マイクの権限を許可する必要があります"),
        "min3": MessageLookupByLibrary.simpleMessage("分"),
        "minAndSec": m52,
        "min_en": MessageLookupByLibrary.simpleMessage("min"),
        "mine": MessageLookupByLibrary.simpleMessage("私の"),
        "mins": MessageLookupByLibrary.simpleMessage("分"),
        "mins2": MessageLookupByLibrary.simpleMessage("分"),
        "minsSpace": MessageLookupByLibrary.simpleMessage(" 分"),
        "miss_clockin": MessageLookupByLibrary.simpleMessage("打刻漏れ"),
        "mission": MessageLookupByLibrary.simpleMessage("リスト"),
        "missionCompleted": MessageLookupByLibrary.simpleMessage("ミッション完了"),
        "missionModelDate": m53,
        "missionModelDate2": m54,
        "missionModelDate3": m55,
        "missionModelDate4": m56,
        "missionNums": MessageLookupByLibrary.simpleMessage("タスク数"),
        "missionPageInputHolder":
            MessageLookupByLibrary.simpleMessage("タスクを追加...(「エンター」キーで保存)"),
        "missionRunningAlert": m57,
        "missionToBeComplete":
            MessageLookupByLibrary.simpleMessage("未完了のミッション"),
        "mission_alert_with_name": m58,
        "mission_clocks_in_with_name": m59,
        "mission_evaluation_value":
            MessageLookupByLibrary.simpleMessage("このミッションの評価価値(\$)"),
        "mission_setting": MessageLookupByLibrary.simpleMessage("ミッション設定"),
        "mission_submission_started": m60,
        "mission_title": m61,
        "mission_value": MessageLookupByLibrary.simpleMessage("ミッションの価値"),
        "mission_value_toast": m62,
        "missioncompleted": MessageLookupByLibrary.simpleMessage("完了したミッション"),
        "modify_name_listing": m63,
        "modify_name_tag": m64,
        "module_filtering_setting":
            MessageLookupByLibrary.simpleMessage("モジュールフィルタリング設定"),
        "monday": MessageLookupByLibrary.simpleMessage("月曜日"),
        "mondayShort": MessageLookupByLibrary.simpleMessage("月"),
        "money_not_enough_toast": MessageLookupByLibrary.simpleMessage(
            "お金が足りません、もっと集中してタスクを完了してお金を稼ぎましょう"),
        "money_per_hour": MessageLookupByLibrary.simpleMessage("時間当たりの収入(\$)"),
        "month": MessageLookupByLibrary.simpleMessage("月"),
        "monthDay": m65,
        "month_clockin_rate": m66,
        "month_clockin_record": m67,
        "month_duration_completed":
            MessageLookupByLibrary.simpleMessage("今月の集中時間（分）"),
        "month_mission_completed":
            MessageLookupByLibrary.simpleMessage("今月完了したタスク数"),
        "month_tomatoes_completed":
            MessageLookupByLibrary.simpleMessage("今月完了したトマト数"),
        "monthsLater": MessageLookupByLibrary.simpleMessage("ヶ月後"),
        "more": MessageLookupByLibrary.simpleMessage("もっと"),
        "move_to_next": MessageLookupByLibrary.simpleMessage("右に移動"),
        "move_to_previous": MessageLookupByLibrary.simpleMessage("左に移動"),
        "multi_select": MessageLookupByLibrary.simpleMessage("複数選択"),
        "multi_view": MessageLookupByLibrary.simpleMessage("複数ビュー"),
        "multi_view_desc": MessageLookupByLibrary.simpleMessage(
            "四象限、カテゴリ、リスト、グループ、タイムライン、スケジュール、ガントチャート、カレンダーなど、さまざまなビューであらゆるニーズに対応します"),
        "music": MessageLookupByLibrary.simpleMessage("音楽"),
        "my": m68,
        "my_answer": MessageLookupByLibrary.simpleMessage("私の"),
        "my_money_per_hour": MessageLookupByLibrary.simpleMessage("私の時間当たりの収入"),
        "my_ranking": m69,
        "my_ranking_this_time": m70,
        "n_days_overdue": m71,
        "name": MessageLookupByLibrary.simpleMessage("名前"),
        "need_notification_permission_content":
            MessageLookupByLibrary.simpleMessage("この機能を使用するには通知権限が必要です"),
        "need_update_username":
            MessageLookupByLibrary.simpleMessage("ユーザー名の設定が必要です"),
        "network_error": MessageLookupByLibrary.simpleMessage(
            "ネットワークエラー（複数回の試行が失敗した場合は、再度ログインしてください）"),
        "new_card": MessageLookupByLibrary.simpleMessage("新しいカード"),
        "newline": m72,
        "nextMission": MessageLookupByLibrary.simpleMessage("次のミッション:"),
        "nextStep": MessageLookupByLibrary.simpleMessage("次へ"),
        "nextWeek": MessageLookupByLibrary.simpleMessage("来週"),
        "next_page": MessageLookupByLibrary.simpleMessage("次のページ"),
        "next_time": MessageLookupByLibrary.simpleMessage("次回"),
        "no": MessageLookupByLibrary.simpleMessage("いいえ"),
        "no_auth": MessageLookupByLibrary.simpleMessage("権限がありません"),
        "no_data": MessageLookupByLibrary.simpleMessage("データなし"),
        "no_delayed_task": MessageLookupByLibrary.simpleMessage("遅延タスクなし"),
        "no_microphone_permission":
            MessageLookupByLibrary.simpleMessage("マイクの権限がありません、設定ページで開いてください"),
        "no_mission_desc": MessageLookupByLibrary.simpleMessage(
            "タスクがありません。最初にタスクを作成する必要があります"),
        "no_notification_permission_title":
            MessageLookupByLibrary.simpleMessage("通知権限がありません"),
        "no_ranking": MessageLookupByLibrary.simpleMessage("ランキングなし"),
        "no_task": MessageLookupByLibrary.simpleMessage("タスクなし"),
        "no_time_limit": MessageLookupByLibrary.simpleMessage("不限时"),
        "no_tomotoes_finished":
            MessageLookupByLibrary.simpleMessage("完了したタスク数（トマト数）"),
        "none": MessageLookupByLibrary.simpleMessage("なし"),
        "normal": MessageLookupByLibrary.simpleMessage("通常"),
        "normal_solution": MessageLookupByLibrary.simpleMessage("正解"),
        "not_completed": MessageLookupByLibrary.simpleMessage("未完了"),
        "not_handling": MessageLookupByLibrary.simpleMessage("現在は処理しない"),
        "not_remind_again": MessageLookupByLibrary.simpleMessage("再度通知しない"),
        "not_started": MessageLookupByLibrary.simpleMessage("未開始"),
        "note": MessageLookupByLibrary.simpleMessage("メモ...(オプション)"),
        "note2": MessageLookupByLibrary.simpleMessage("ノート"),
        "note_1": MessageLookupByLibrary.simpleMessage("ノート1"),
        "note_2": MessageLookupByLibrary.simpleMessage("ノート2"),
        "note_3": MessageLookupByLibrary.simpleMessage("ノート3"),
        "note_4": MessageLookupByLibrary.simpleMessage("ノート4"),
        "note_5": MessageLookupByLibrary.simpleMessage("ノート5"),
        "note_6": MessageLookupByLibrary.simpleMessage("ノート6"),
        "note_7": MessageLookupByLibrary.simpleMessage("ノート7"),
        "note_and_multimission":
            MessageLookupByLibrary.simpleMessage("ノートとマルチミッション"),
        "note_diary": MessageLookupByLibrary.simpleMessage("音声メモ"),
        "note_n": MessageLookupByLibrary.simpleMessage("ノート"),
        "note_plain": MessageLookupByLibrary.simpleMessage("ノート"),
        "note_prompt": MessageLookupByLibrary.simpleMessage(
            "{createdAt: null, updatedAt: null, indexSearchingStart: null, state: 0, indexSearchingEnd: null, background_url: null, title: 1.右上の[デスクトップウィジェットに設定]をクリックします 2. Android、iPhone、Macでデスクトップウィジェットを設定できます, folder_id: null, flomo_object_id: null, type: 1, masterScore: 1.0, update_time: 1699019619215, causeAnalysis: [], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 0, wqbWrongQuestionContent: , wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 0, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: , wqbAnswerRichContentUrl: , content: 1.右上の[デスクトップウィジェットに設定]をクリックします\n2. Android、iPhone、Macでデスクトップウィジェットを設定できます\n1111, device_id: B5CC32ED-595A-54B7-A814-7BC911FBD2D4, tagNames: [], tagIds: null, isFinished: null, color: 4291946748, order_index: 4, status: null, priorityStatus: null, uid: 0aa14757-7695-4e52-9b23-45f839a16715}"),
        "note_short": MessageLookupByLibrary.simpleMessage("ノート"),
        "notification0":
            MessageLookupByLibrary.simpleMessage("時間が来ました、明日の計画を立てましょう"),
        "notification1": MessageLookupByLibrary.simpleMessage(
            "「時間管理局ToDo」を数日間使用していないことに気づきました。計画を放棄しないで、今すぐ使用しましょう！"),
        "notification10": MessageLookupByLibrary.simpleMessage(
            "あなたが望むなら、必ずできます。「時間管理局ToDo」を使用して、計画を実行しましょう。"),
        "notification11": MessageLookupByLibrary.simpleMessage(
            "生命は止まらず、闘争は止まらない。「時間管理局ToDo」を開いて、計画を実行しましょう。"),
        "notification12": MessageLookupByLibrary.simpleMessage(
            "自分の心の願いに従って、前進し続けましょう。「時間管理局ToDo」を使用して、自信を持つことができます。"),
        "notification13": MessageLookupByLibrary.simpleMessage(
            "あなたが想像できることは、必ず実現できます。「時間管理局ToDo」を使用して、計画を実行しましょう。"),
        "notification14": MessageLookupByLibrary.simpleMessage(
            "夢は遠くない、あなたが勇敢に進む限り。「時間管理局ToDo」を開いて、計画を実行しましょう。"),
        "notification15": MessageLookupByLibrary.simpleMessage(
            "成功には勇気と決断が必要です。「時間管理局ToDo」を使用して、より勇敢になりましょう。"),
        "notification16": MessageLookupByLibrary.simpleMessage(
            "成功は一歩一歩達成されます。「時間管理局ToDo」を使用して、より効率的になりましょう。"),
        "notification17": MessageLookupByLibrary.simpleMessage(
            "変化は行動から始まります。「時間管理局ToDo」を開いて、計画を実行しましょう。"),
        "notification18": MessageLookupByLibrary.simpleMessage(
            "毎日が新しい始まりです。「時間管理局ToDo」を使用して、より活力を持つことができます。"),
        "notification19": MessageLookupByLibrary.simpleMessage(
            "成功は偶然ではなく、努力と持続によって達成されます。「時間管理局ToDo」を開いて、計画を実行しましょう。"),
        "notification2": MessageLookupByLibrary.simpleMessage(
            "毎日目標を持つことが重要です、今日の目標を忘れないでください。「時間管理局ToDo」を開いて、計画を実行しましょう。"),
        "notification20": MessageLookupByLibrary.simpleMessage(
            "今日努力しなければ、明日は無駄になります。「時間管理局ToDo」を使用して、より努力しましょう。"),
        "notification3": MessageLookupByLibrary.simpleMessage(
            "継続は力なり。目標を達成するために、「時間管理局ToDo」を開きましょう。"),
        "notification4": MessageLookupByLibrary.simpleMessage(
            "あなたは強い意志を持つ人です、怠惰に負けないでください。「時間管理局ToDo」を使用して、計画を実行しましょう。"),
        "notification5": MessageLookupByLibrary.simpleMessage(
            "良い計画は成功の半分です。まだ計画を実行していないなら、「時間管理局ToDo」をすぐに開きましょう。"),
        "notification6": MessageLookupByLibrary.simpleMessage(
            "スマホを置いて、集中して計画を立てましょう。「時間管理局ToDo」を開いて、より集中力を高めましょう。"),
        "notification7": MessageLookupByLibrary.simpleMessage(
            "あなたの目標に近づいています、自分自身を後退させないでください。「時間管理局ToDo」を使用して、計画を実行しましょう。"),
        "notification8": MessageLookupByLibrary.simpleMessage(
            "進歩を追求し、今日から始めましょう。「時間管理局ToDo」を開いて、計画を実行しましょう。"),
        "notification9": MessageLookupByLibrary.simpleMessage(
            "時間は貴重です、一分一秒を大切にしましょう。「時間管理局ToDo」を使用して、時間をより価値あるものにしましょう。"),
        "notificationTxt": m73,
        "notification_more":
            MessageLookupByLibrary.simpleMessage("明日の作業内容をカスタマイズしましょう"),
        "notification_num_mission_to_finish": m74,
        "notification_num_mission_to_finish_delay": m75,
        "notification_setting": MessageLookupByLibrary.simpleMessage("プッシュ設定"),
        "notification_setting_content": MessageLookupByLibrary.simpleMessage(
            "プッシュを開くと、タスクの完了または開始状況を知るのに役立ちます"),
        "notification_title":
            MessageLookupByLibrary.simpleMessage("あなたのタイムマネージャーからのリマインダー"),
        "nov": MessageLookupByLibrary.simpleMessage("11月"),
        "novFull": MessageLookupByLibrary.simpleMessage("11月"),
        "now": MessageLookupByLibrary.simpleMessage("現在"),
        "num_days": m76,
        "num_lives": MessageLookupByLibrary.simpleMessage("ライフ:"),
        "num_mins": m77,
        "num_mission_total": m78,
        "num_of_total": m79,
        "num_tasks": m80,
        "num_tasks_finished": MessageLookupByLibrary.simpleMessage("完了した計画数"),
        "num_times": m81,
        "num_unit": m82,
        "number_present": m83,
        "objective": MessageLookupByLibrary.simpleMessage("目的"),
        "oct": MessageLookupByLibrary.simpleMessage("10月"),
        "octFull": MessageLookupByLibrary.simpleMessage("10月"),
        "off": MessageLookupByLibrary.simpleMessage("オフ"),
        "offer_next_version":
            MessageLookupByLibrary.simpleMessage("次のバージョンで提供"),
        "on": MessageLookupByLibrary.simpleMessage("オン"),
        "one_hour": MessageLookupByLibrary.simpleMessage("1時間"),
        "one_key_login": MessageLookupByLibrary.simpleMessage("ワンクリックログイン"),
        "one_month": MessageLookupByLibrary.simpleMessage("1ヶ月"),
        "one_year": MessageLookupByLibrary.simpleMessage("1年"),
        "ongoing": MessageLookupByLibrary.simpleMessage("進行中"),
        "optional": MessageLookupByLibrary.simpleMessage("任意"),
        "optional_with_parenthese":
            MessageLookupByLibrary.simpleMessage("（任意）"),
        "order_by_created_time":
            MessageLookupByLibrary.simpleMessage("作成時間順に並べ替え"),
        "order_by_end_time": MessageLookupByLibrary.simpleMessage("完了時間順に並べ替え"),
        "order_by_list": MessageLookupByLibrary.simpleMessage("リスト順に並べ替え"),
        "order_by_mission_priority":
            MessageLookupByLibrary.simpleMessage("タスクの優先度順に並べ替え"),
        "order_by_mission_tag":
            MessageLookupByLibrary.simpleMessage("タグ順に並べ替え"),
        "order_by_time": MessageLookupByLibrary.simpleMessage("時間順に並べ替え"),
        "order_by_update_time":
            MessageLookupByLibrary.simpleMessage("最新の更新時間順（作業報告に適しています）"),
        "other_login_mode": MessageLookupByLibrary.simpleMessage("他の方法に切り替え"),
        "others": MessageLookupByLibrary.simpleMessage("その他"),
        "overdue_buffer": MessageLookupByLibrary.simpleMessage("超過:"),
        "password": MessageLookupByLibrary.simpleMessage("パスワード"),
        "passwordNotEmpty":
            MessageLookupByLibrary.simpleMessage("パスワードは空にできません"),
        "password_at_least_6":
            MessageLookupByLibrary.simpleMessage("パスワードは少なくとも6文字でなければなりません"),
        "password_correct_desc": MessageLookupByLibrary.simpleMessage(
            "ローカルパスワードが正しいので、直接タスクを作成できます"),
        "password_not_empty":
            MessageLookupByLibrary.simpleMessage("パスワードを入力してください！"),
        "pause": MessageLookupByLibrary.simpleMessage("一時停止"),
        "pc_not_available": MessageLookupByLibrary.simpleMessage(
            "この機能はMACまたはPCでは利用できません、スマートフォンで操作してください"),
        "pdpa": MessageLookupByLibrary.simpleMessage("PDCA"),
        "pdpa_desc": MessageLookupByLibrary.simpleMessage(
            "P（計画）- 計画機能には3つの部分が含まれます：目標、計画、予算。\nD（デザイン）- ソリューションとレイアウトを設計する。\nC（4C）- 4C管理：チェック、コミュニケーション、クリーン、コントロール。\nA（2A）- 行動（実行、サマリーチェックの結果を処理する）、目標（目標要件に従って行動する、例えば改善、向上）。"),
        "pdpa_step1": MessageLookupByLibrary.simpleMessage("計画"),
        "pdpa_step2": MessageLookupByLibrary.simpleMessage("実行"),
        "pdpa_step3": MessageLookupByLibrary.simpleMessage("確認"),
        "pdpa_step4": MessageLookupByLibrary.simpleMessage("行動"),
        "permission_setting": MessageLookupByLibrary.simpleMessage("権限設定"),
        "phoneNo": MessageLookupByLibrary.simpleMessage("電話番号"),
        "plain_text": MessageLookupByLibrary.simpleMessage("プレーンテキスト"),
        "play": MessageLookupByLibrary.simpleMessage("再生"),
        "pleaseInputTitle":
            MessageLookupByLibrary.simpleMessage("タイトルを入力してください"),
        "pleaseSelectColor": MessageLookupByLibrary.simpleMessage("色を選択してください"),
        "please_confirm_your_password":
            MessageLookupByLibrary.simpleMessage("パスワードを確認してください"),
        "please_create_ur_password":
            MessageLookupByLibrary.simpleMessage("パスワードを作成してください"),
        "please_enter_ur_password":
            MessageLookupByLibrary.simpleMessage("パスワードを入力してください"),
        "please_enter_your_question":
            MessageLookupByLibrary.simpleMessage("質問を入力してください"),
        "please_finish_msn":
            MessageLookupByLibrary.simpleMessage("メッセージパスワードの確認を完了してください"),
        "please_input_bill_amount":
            MessageLookupByLibrary.simpleMessage("請求書の金額を入力してください"),
        "please_input_content":
            MessageLookupByLibrary.simpleMessage("内容を入力してください"),
        "please_input_correct_password":
            MessageLookupByLibrary.simpleMessage("正しいパスワードを入力してください"),
        "please_input_first_gpt_sentence":
            MessageLookupByLibrary.simpleMessage("質問を入力してください"),
        "please_input_folder_password": m84,
        "please_input_mission_title":
            MessageLookupByLibrary.simpleMessage("タスクのタイトルを入力してください"),
        "please_input_mobile_no":
            MessageLookupByLibrary.simpleMessage("まず携帯番号を入力してください"),
        "please_input_password":
            MessageLookupByLibrary.simpleMessage("まずパスワードを入力してください"),
        "please_input_the_mission_title":
            MessageLookupByLibrary.simpleMessage("タスクのタイトルを入力してください"),
        "please_input_title":
            MessageLookupByLibrary.simpleMessage("タイトルを入力してください"),
        "please_input_xxx_name": m85,
        "please_input_your_username":
            MessageLookupByLibrary.simpleMessage("ユーザー名を設定してください"),
        "please_origin_password":
            MessageLookupByLibrary.simpleMessage("元のパスワードを入力してください"),
        "please_seaarch_on_app_store": m86,
        "please_select_at_least_one_option_in_repeat_cycle":
            MessageLookupByLibrary.simpleMessage(
                "リピートサイクルで少なくとも一つのオプションを選択してください"),
        "please_select_content": m87,
        "please_select_daily_start_time":
            MessageLookupByLibrary.simpleMessage("開始時間を選択してください"),
        "please_select_date":
            MessageLookupByLibrary.simpleMessage("検索する日を選択してください"),
        "please_select_daterange":
            MessageLookupByLibrary.simpleMessage("検索する日付範囲を選択してください"),
        "please_select_month":
            MessageLookupByLibrary.simpleMessage("検索する月を選択してください"),
        "please_select_year_to_search":
            MessageLookupByLibrary.simpleMessage("検索する年を選択してください"),
        "popup_invisible3": MessageLookupByLibrary.simpleMessage("非表示"),
        "popup_select1": MessageLookupByLibrary.simpleMessage("内容を表示"),
        "popup_visible2": MessageLookupByLibrary.simpleMessage("表示"),
        "postpone": MessageLookupByLibrary.simpleMessage("今日まで延期"),
        "practice": MessageLookupByLibrary.simpleMessage("トレーニング"),
        "present_value_dialog": m88,
        "preview": MessageLookupByLibrary.simpleMessage("プレビュー"),
        "previewTime": MessageLookupByLibrary.simpleMessage("予想時間"),
        "previewTomatoesNum": MessageLookupByLibrary.simpleMessage("予想トマト数"),
        "previous_page": MessageLookupByLibrary.simpleMessage("前のページ"),
        "priority": MessageLookupByLibrary.simpleMessage("優先度"),
        "priority1": MessageLookupByLibrary.simpleMessage("緊急 & 重要"),
        "priority2": MessageLookupByLibrary.simpleMessage("非緊急 & 重要"),
        "priority3": MessageLookupByLibrary.simpleMessage("緊急 & 非重要"),
        "priority4": MessageLookupByLibrary.simpleMessage("非緊急 & 非重要"),
        "priorityStatus": MessageLookupByLibrary.simpleMessage("優先度:"),
        "priority_distribution_of_completion_plan":
            MessageLookupByLibrary.simpleMessage("完了した計画の優先度分布"),
        "priority_distribution_of_uncompletion_plan":
            MessageLookupByLibrary.simpleMessage("未完了の計画の優先度分布"),
        "privacy": MessageLookupByLibrary.simpleMessage("プライバシー"),
        "privacy_management": MessageLookupByLibrary.simpleMessage("プライバシー管理"),
        "privacy_pattern": MessageLookupByLibrary.simpleMessage("プライバシーポリシー"),
        "privacy_protocol_content": MessageLookupByLibrary.simpleMessage(
            "私たちはあなたのプライバシーと個人情報の保護を非常に重視しています。私たちは、あなたの情報を保護するための先進的なセキュリティ対策を採用しています。\n\n「プライバシーポリシー」のすべての条項を注意深く読んでください。私たちがあなたの情報をどのように収集、使用、保護するか、そして私たちが提供する具体的な措置と約束を理解してください。すべての条項に同意し、私たちのサービスを使用することを承認してください。\n私たちは、アカウントの登録などのビジネスシーンで情報を収集します。あなたがこの製品を深く使用するにつれて、あなたは位置情報、カメラの権限など、異なるビジネスシーンに応じて適切なデバイスの権限を開く必要があります。"),
        "privacy_protocol_content2": MessageLookupByLibrary.simpleMessage(
            "私たちはあなたのプライバシーと個人情報の保護を非常に重視し、あなたの情報の安全を保護するための先進的な保護措置を採用しています。私たちのサービスを続けて使用することで、あなたは「プライバシーポリシー」に従ってあなたの個人情報を収集、使用、保護することに同意したことになります。あなたが上記の内容に同意しない場合、使用を停止することができます。"),
        "privacy_protocol_title":
            MessageLookupByLibrary.simpleMessage("プライバシーポリシー"),
        "private": MessageLookupByLibrary.simpleMessage("プライベート"),
        "projectStatistic": MessageLookupByLibrary.simpleMessage("プロジェクト統計"),
        "public_course": MessageLookupByLibrary.simpleMessage("公開トレーニングプラン"),
        "publish": MessageLookupByLibrary.simpleMessage("公開"),
        "pure_mode": MessageLookupByLibrary.simpleMessage("ピュアモード"),
        "push_counter_status_notification": m89,
        "qq_share": MessageLookupByLibrary.simpleMessage("QQで共有"),
        "question_mistake": MessageLookupByLibrary.simpleMessage("問題/間違い"),
        "question_wrong_question":
            MessageLookupByLibrary.simpleMessage("問題/間違った問題"),
        "random_by_alphabet":
            MessageLookupByLibrary.simpleMessage("アルファベットチャレンジ"),
        "random_by_alphabetAndNumber":
            MessageLookupByLibrary.simpleMessage("アルファベットと数字のチャレンジ"),
        "random_by_alphabetAndNumber_lowercase_capital":
            MessageLookupByLibrary.simpleMessage(
                "アルファベット（大文字小文字を区別しない）と数字のチャレンジ"),
        "random_by_alphabet_lowercase_capital":
            MessageLookupByLibrary.simpleMessage("アルファベットチャレンジ（大文字小文字を区別しない）"),
        "random_by_number": MessageLookupByLibrary.simpleMessage("数字チャレンジ"),
        "ranking": MessageLookupByLibrary.simpleMessage("ランキング"),
        "rating_guide":
            MessageLookupByLibrary.simpleMessage("もし良ければ、5つ星の評価をお願いします。^^"),
        "ready_to_download": MessageLookupByLibrary.simpleMessage("ダウンロード準備完了"),
        "readying": MessageLookupByLibrary.simpleMessage("準備中"),
        "recommended_Target": MessageLookupByLibrary.simpleMessage("推奨目標"),
        "record": MessageLookupByLibrary.simpleMessage("録音"),
        "refuse": MessageLookupByLibrary.simpleMessage("拒否"),
        "register": MessageLookupByLibrary.simpleMessage("登録"),
        "registerStep1":
            MessageLookupByLibrary.simpleMessage("電話番号を入力して登録を完了し、効率的な生活を楽しむ"),
        "registerStep2":
            MessageLookupByLibrary.simpleMessage("電話番号を入力して登録を完了し、効率的な生活を楽しむ"),
        "remarks_optional": MessageLookupByLibrary.simpleMessage("備考（任意）"),
        "remind": MessageLookupByLibrary.simpleMessage("リマインダー"),
        "reminder": MessageLookupByLibrary.simpleMessage("リマインダー"),
        "rename": MessageLookupByLibrary.simpleMessage("名前を変更する"),
        "repaid": MessageLookupByLibrary.simpleMessage("返済済み"),
        "repayment": MessageLookupByLibrary.simpleMessage("返済"),
        "repayment_channel": MessageLookupByLibrary.simpleMessage("返済チャネル"),
        "repayment_day": MessageLookupByLibrary.simpleMessage("返済日"),
        "repayment_instantly": MessageLookupByLibrary.simpleMessage("即時返済"),
        "repayment_record": MessageLookupByLibrary.simpleMessage("返済記録"),
        "repeat": MessageLookupByLibrary.simpleMessage("繰り返す"),
        "repeat_period": MessageLookupByLibrary.simpleMessage("リピート周期"),
        "repeative1": MessageLookupByLibrary.simpleMessage("日ごと"),
        "repeative2": MessageLookupByLibrary.simpleMessage("週ごと"),
        "repeative3": MessageLookupByLibrary.simpleMessage("エビングハウス"),
        "repeative_content": m90,
        "repetive": MessageLookupByLibrary.simpleMessage("繰り返し"),
        "repetiveType": MessageLookupByLibrary.simpleMessage("繰り返しの有無"),
        "repetiveValue": MessageLookupByLibrary.simpleMessage("繰り返しの日付"),
        "repetiveWeekDay": MessageLookupByLibrary.simpleMessage("繰り返しの曜日"),
        "reply": MessageLookupByLibrary.simpleMessage("返信"),
        "report2": MessageLookupByLibrary.simpleMessage("報告する"),
        "request_error_try_again":
            MessageLookupByLibrary.simpleMessage("リクエストエラー、再試行してください"),
        "request_fail": MessageLookupByLibrary.simpleMessage("リクエスト失敗"),
        "request_permission": MessageLookupByLibrary.simpleMessage("権限を申請する"),
        "requesting_please_wait":
            MessageLookupByLibrary.simpleMessage("リクエスト中、お待ちください"),
        "reset_pwd": MessageLookupByLibrary.simpleMessage("パスワードをリセット"),
        "reset_pwd_successful":
            MessageLookupByLibrary.simpleMessage("パスワードのリセットに成功しました"),
        "rest": MessageLookupByLibrary.simpleMessage("休憩"),
        "restPausing": MessageLookupByLibrary.simpleMessage("休憩中断中"),
        "rest_completed_auto_start_play":
            MessageLookupByLibrary.simpleMessage("休憩が完了すると自動的に再生が始まります"),
        "rest_duration": MessageLookupByLibrary.simpleMessage("休憩時間"),
        "rest_focus_duration_with_value": m91,
        "rest_focus_numbers_with_value": m92,
        "resting": MessageLookupByLibrary.simpleMessage("休憩中"),
        "restingFinished": MessageLookupByLibrary.simpleMessage("休憩完了"),
        "resting_music": MessageLookupByLibrary.simpleMessage("休憩中の音楽"),
        "resting_stopping_ringtone":
            MessageLookupByLibrary.simpleMessage("休憩終了の着信音"),
        "resume": MessageLookupByLibrary.simpleMessage("続ける"),
        "retry": MessageLookupByLibrary.simpleMessage("再試行"),
        "rich_text": MessageLookupByLibrary.simpleMessage("リッチテキスト"),
        "rmb": MessageLookupByLibrary.simpleMessage("コイン"),
        "role_chatgpt_msg": m93,
        "role_message_placehodler": MessageLookupByLibrary.simpleMessage(
            "作業計画を入力してください（時間、作業内容などを明確に記述してください）"),
        "role_prompts_chatgpt_msg": MessageLookupByLibrary.simpleMessage(
            "あなたにスマート入力法の役割を果たしてもらいたい、プロンプトに基づいてユーザーが入力する可能性のあるフレーズの配列List<String>を返します、配列は最大20個、ユーザーの入力した単語を必ず含む必要があります(注意:政治的な歴史については議論しない)"),
        "role_time_manager": MessageLookupByLibrary.simpleMessage("プランナー"),
        "rules_for_ai": MessageLookupByLibrary.simpleMessage("AIのルール"),
        "rusty": MessageLookupByLibrary.simpleMessage("錆びた"),
        "sales": MessageLookupByLibrary.simpleMessage("販売"),
        "sales_amount": MessageLookupByLibrary.simpleMessage("販売額"),
        "same_treatment": MessageLookupByLibrary.simpleMessage("同じ処理"),
        "saturday": MessageLookupByLibrary.simpleMessage("土曜日"),
        "saturdayShort": MessageLookupByLibrary.simpleMessage("土"),
        "save": MessageLookupByLibrary.simpleMessage("保存"),
        "save_failure": MessageLookupByLibrary.simpleMessage("保存に失敗しました"),
        "save_success": MessageLookupByLibrary.simpleMessage("保存成功"),
        "saving": MessageLookupByLibrary.simpleMessage("保存中"),
        "schedule": MessageLookupByLibrary.simpleMessage("スケジュール"),
        "screen_rorate": MessageLookupByLibrary.simpleMessage("画面を回転"),
        "search": MessageLookupByLibrary.simpleMessage("検索"),
        "search_chart_by_gpt": MessageLookupByLibrary.simpleMessage("チャート"),
        "search_chart_listing_title_content":
            MessageLookupByLibrary.simpleMessage("チャートリストを表示\nリスト:\n時間:"),
        "search_chart_listingtitle":
            MessageLookupByLibrary.simpleMessage("リストチャートを表示"),
        "search_chart_title": MessageLookupByLibrary.simpleMessage("チャートを表示"),
        "search_chart_title_content":
            MessageLookupByLibrary.simpleMessage("チャートを表示\n時間:"),
        "search_country": MessageLookupByLibrary.simpleMessage("国を検索"),
        "search_listing_by_gpt":
            MessageLookupByLibrary.simpleMessage("リスト&タスクを検索"),
        "search_listing_content":
            MessageLookupByLibrary.simpleMessage("リストデータを表示:\nリストタイトル:\n説明:"),
        "search_listing_title":
            MessageLookupByLibrary.simpleMessage("リストデータを表示"),
        "sec": MessageLookupByLibrary.simpleMessage("秒"),
        "see": MessageLookupByLibrary.simpleMessage("見る"),
        "selectMission": MessageLookupByLibrary.simpleMessage("ミッションを選択"),
        "selectTag": MessageLookupByLibrary.simpleMessage("タグを選択"),
        "selectThemeColor": MessageLookupByLibrary.simpleMessage("テーマカラーを選択"),
        "selectThemeColorDesc": MessageLookupByLibrary.simpleMessage(
            "テーマカラーを選択し、アプリを再起動するとテーマカラーが変更されます^^"),
        "select_all": MessageLookupByLibrary.simpleMessage("全選択"),
        "select_avatar": MessageLookupByLibrary.simpleMessage("アバターを選択してください"),
        "select_contents": MessageLookupByLibrary.simpleMessage("表示内容を選択"),
        "select_lottery": MessageLookupByLibrary.simpleMessage("抽選"),
        "select_prize": MessageLookupByLibrary.simpleMessage("報酬を選択"),
        "select_repeat_option": MessageLookupByLibrary.simpleMessage(
            "リピートサイクルで少なくとも一つのオプションを選択してください"),
        "select_ringtone": MessageLookupByLibrary.simpleMessage("着信音を選択"),
        "send_again": MessageLookupByLibrary.simpleMessage("再送信"),
        "sep": MessageLookupByLibrary.simpleMessage("9月"),
        "sepFull": MessageLookupByLibrary.simpleMessage("9月"),
        "set_to_desktop_widget":
            MessageLookupByLibrary.simpleMessage("デスクトップウィジェットに設定"),
        "setting": MessageLookupByLibrary.simpleMessage("設定"),
        "setting_fail": MessageLookupByLibrary.simpleMessage("設定失敗"),
        "setting_success": MessageLookupByLibrary.simpleMessage("設定成功"),
        "share": MessageLookupByLibrary.simpleMessage("共有"),
        "sharing_course": MessageLookupByLibrary.simpleMessage("コースを共有"),
        "six_hours": MessageLookupByLibrary.simpleMessage("6時間"),
        "six_months": MessageLookupByLibrary.simpleMessage("6ヶ月"),
        "skilled": MessageLookupByLibrary.simpleMessage("熟練"),
        "slide_left_right": MessageLookupByLibrary.simpleMessage("左右にスライド可能"),
        "smsVerificationCode": MessageLookupByLibrary.simpleMessage("SMS認証コード"),
        "sound_recording": MessageLookupByLibrary.simpleMessage("録音"),
        "startFocusing": MessageLookupByLibrary.simpleMessage("集中を開始"),
        "startResting": MessageLookupByLibrary.simpleMessage("休憩を開始"),
        "start_date": MessageLookupByLibrary.simpleMessage("開始日"),
        "start_focus": MessageLookupByLibrary.simpleMessage("集中を開始する"),
        "start_focusing_mission_name": m94,
        "start_resting_name": m95,
        "start_time": MessageLookupByLibrary.simpleMessage("開始時間"),
        "status_complete": MessageLookupByLibrary.simpleMessage("処理完了"),
        "status_developping": MessageLookupByLibrary.simpleMessage("開発中"),
        "status_handling": MessageLookupByLibrary.simpleMessage("処理中"),
        "status_waiting": MessageLookupByLibrary.simpleMessage("処理待ち"),
        "stop": MessageLookupByLibrary.simpleMessage("停止"),
        "stop_focusing_mission_name": m96,
        "stop_resting_mission_name": m97,
        "sub_task_add_newline":
            MessageLookupByLibrary.simpleMessage("サブタスク-ポイントで改行して追加&保存"),
        "submit": MessageLookupByLibrary.simpleMessage("提出"),
        "successfully_copied_to_clipboard":
            MessageLookupByLibrary.simpleMessage("クリップボードにコピーしました"),
        "summary": MessageLookupByLibrary.simpleMessage("概要"),
        "sunday": MessageLookupByLibrary.simpleMessage("日曜日"),
        "sundayShort": MessageLookupByLibrary.simpleMessage("日"),
        "super_notebook": MessageLookupByLibrary.simpleMessage("スーパーノートブック"),
        "switch_chronograph_mode_success":
            MessageLookupByLibrary.simpleMessage("ストップウォッチモードに切り替え成功、次回から有効"),
        "switch_font": MessageLookupByLibrary.simpleMessage("フォントを切り替え"),
        "switch_timer_mode_success":
            MessageLookupByLibrary.simpleMessage("タイマーモードに切り替え成功、次回から有効"),
        "tag": MessageLookupByLibrary.simpleMessage("タグ"),
        "tagNames": MessageLookupByLibrary.simpleMessage("タグ名"),
        "target_details": MessageLookupByLibrary.simpleMessage("目標詳細"),
        "target_duration_period":
            MessageLookupByLibrary.simpleMessage("目標持続期間"),
        "target_reward": MessageLookupByLibrary.simpleMessage("目標報酬一直"),
        "target_time": MessageLookupByLibrary.simpleMessage("目標時間"),
        "task": MessageLookupByLibrary.simpleMessage("タスク"),
        "tasks_list": MessageLookupByLibrary.simpleMessage("タスクリスト"),
        "theme": MessageLookupByLibrary.simpleMessage("テーマ"),
        "thirty_mins": MessageLookupByLibrary.simpleMessage("30分"),
        "thisWeek": MessageLookupByLibrary.simpleMessage("今週"),
        "this_mission_is_cycle_mission":
            MessageLookupByLibrary.simpleMessage("このミッションはサイクルミッションです"),
        "this_month_plan": MessageLookupByLibrary.simpleMessage("今月の計画"),
        "thisweek": MessageLookupByLibrary.simpleMessage("今週"),
        "three_hours": MessageLookupByLibrary.simpleMessage("3時間"),
        "three_months": MessageLookupByLibrary.simpleMessage("3ヶ月"),
        "thursday": MessageLookupByLibrary.simpleMessage("木曜日"),
        "thursdayShort": MessageLookupByLibrary.simpleMessage("木"),
        "time": MessageLookupByLibrary.simpleMessage("時間"),
        "time_ago": m98,
        "time_finished": MessageLookupByLibrary.simpleMessage("集中時間"),
        "time_later": m99,
        "time_management": MessageLookupByLibrary.simpleMessage("時間管理"),
        "time_not_arrive_cannot_clcokin":
            MessageLookupByLibrary.simpleMessage("時間が来ていない、打刻できません"),
        "time_segment": MessageLookupByLibrary.simpleMessage("時間帯"),
        "timefocused": MessageLookupByLibrary.simpleMessage("集中時間"),
        "timeline": MessageLookupByLibrary.simpleMessage("タイムライン"),
        "timelineview": MessageLookupByLibrary.simpleMessage("タイムラインビュー"),
        "timer": MessageLookupByLibrary.simpleMessage("タイマー"),
        "times": MessageLookupByLibrary.simpleMessage("回"),
        "tipsAlertTone": MessageLookupByLibrary.simpleMessage("アラート音"),
        "title": MessageLookupByLibrary.simpleMessage("タイトル"),
        "title_consume": MessageLookupByLibrary.simpleMessage("消費金額"),
        "title_data": m100,
        "today": MessageLookupByLibrary.simpleMessage("今日"),
        "today_data": MessageLookupByLibrary.simpleMessage("今日のデータ"),
        "today_duration_completed":
            MessageLookupByLibrary.simpleMessage("今日の集中時間（分）"),
        "today_focus_duration": MessageLookupByLibrary.simpleMessage("今日の集中時間"),
        "today_focus_record": MessageLookupByLibrary.simpleMessage("今日の集中記録"),
        "today_mission_completed":
            MessageLookupByLibrary.simpleMessage("今日完了したタスク数"),
        "today_tomatoes_completed":
            MessageLookupByLibrary.simpleMessage("今日完了したトマト数"),
        "todo_list": MessageLookupByLibrary.simpleMessage("ToDoリスト"),
        "todo_list_desc":
            MessageLookupByLibrary.simpleMessage("明確で、常にリマインドします"),
        "todo_listing": MessageLookupByLibrary.simpleMessage("ToDoリスト"),
        "tokenExpired":
            MessageLookupByLibrary.simpleMessage("ログインが失効しました、再度ログインしてください"),
        "tomato": MessageLookupByLibrary.simpleMessage("トマト"),
        "tomatoClock": MessageLookupByLibrary.simpleMessage("トマトクロック"),
        "tomatoClockSetting": MessageLookupByLibrary.simpleMessage("トマトクロック設定"),
        "tomatoNums": MessageLookupByLibrary.simpleMessage("集中回数"),
        "tomatoNums2": MessageLookupByLibrary.simpleMessage("集中回数"),
        "tomatoNums3": MessageLookupByLibrary.simpleMessage("(トマト数)"),
        "tomato_duration": MessageLookupByLibrary.simpleMessage("各トマトの集中時間"),
        "tomatoesDuration": MessageLookupByLibrary.simpleMessage("トマトの時間"),
        "tomorrow": MessageLookupByLibrary.simpleMessage("明日"),
        "totalTime": MessageLookupByLibrary.simpleMessage("集中時間"),
        "totalTimeMinute": MessageLookupByLibrary.simpleMessage("合計時間（分）"),
        "total_focus_duration": MessageLookupByLibrary.simpleMessage("総集中時間"),
        "total_focus_time": MessageLookupByLibrary.simpleMessage("集中時間"),
        "total_tasks_count":
            MessageLookupByLibrary.simpleMessage("タスクの総数（トマト数）"),
        "total_tomotoes": MessageLookupByLibrary.simpleMessage("トマトの総数"),
        "trainee_advice_notice": m101,
        "trainee_give_your_advice": m102,
        "training_plan_edit": MessageLookupByLibrary.simpleMessage("クリックして編集"),
        "transaction": MessageLookupByLibrary.simpleMessage("財務"),
        "try_again": MessageLookupByLibrary.simpleMessage(
            "リクエストがタイムアウトまたは失敗しました、再試行してください"),
        "tuesday": MessageLookupByLibrary.simpleMessage("火曜日"),
        "tuesdayShort": MessageLookupByLibrary.simpleMessage("火"),
        "twelve_12hours": MessageLookupByLibrary.simpleMessage("12時間"),
        "twenty_one_days": MessageLookupByLibrary.simpleMessage("21日"),
        "type": MessageLookupByLibrary.simpleMessage("書き込み"),
        "unarchive": MessageLookupByLibrary.simpleMessage("アーカイブを解除"),
        "uncomplete_plan_classification":
            MessageLookupByLibrary.simpleMessage("未完了の計画の分類"),
        "unfinished": MessageLookupByLibrary.simpleMessage("未完了"),
        "unit": MessageLookupByLibrary.simpleMessage("単位"),
        "unitMissions": MessageLookupByLibrary.simpleMessage("ミッション単位"),
        "unitTomatoes": MessageLookupByLibrary.simpleMessage("トマト単位"),
        "unname_user": MessageLookupByLibrary.simpleMessage("(名前未設定のユーザー)"),
        "unorder_folderlist": MessageLookupByLibrary.simpleMessage("未分類リスト"),
        "unorder_group": MessageLookupByLibrary.simpleMessage("未分類のグループ"),
        "unorder_group_not_order_toast":
            MessageLookupByLibrary.simpleMessage("未分類のグループは並べ替えできません"),
        "unregister": MessageLookupByLibrary.simpleMessage("登録解除"),
        "unregister_account":
            MessageLookupByLibrary.simpleMessage("アカウントを登録解除"),
        "unregister_content": MessageLookupByLibrary.simpleMessage(
            "すべてのアカウント情報を削除します\nあなたに関連するすべてのリスト、タスクデータ\nクーポンはすべてクリアされ、復元できません\n登録解除後に再登録しても、過去のデータは復元されません"),
        "unregister_temp": MessageLookupByLibrary.simpleMessage("一時的に登録解除しない"),
        "unregister_title":
            MessageLookupByLibrary.simpleMessage("登録解除後、以下の情報が影響を受けます"),
        "unselected": MessageLookupByLibrary.simpleMessage("未選択"),
        "unset": MessageLookupByLibrary.simpleMessage("設定されていない"),
        "update": MessageLookupByLibrary.simpleMessage("更新"),
        "updateSuccess": MessageLookupByLibrary.simpleMessage("更新成功"),
        "update_bill": MessageLookupByLibrary.simpleMessage("請求書を更新する"),
        "update_credit_card_bill":
            MessageLookupByLibrary.simpleMessage("クレジットカードの請求書を更新する"),
        "update_last_time": m103,
        "update_name_mission": m104,
        "update_name_mission2": m105,
        "update_now": MessageLookupByLibrary.simpleMessage("すぐに更新"),
        "update_success": MessageLookupByLibrary.simpleMessage("更新成功"),
        "update_time_last_time":
            MessageLookupByLibrary.simpleMessage("最新の更新時間"),
        "uploading_pic": MessageLookupByLibrary.simpleMessage("画像をアップロード中"),
        "user_privacy_protocol_title":
            MessageLookupByLibrary.simpleMessage("ユーザープライバシーポリシー"),
        "username": MessageLookupByLibrary.simpleMessage("ユーザー名"),
        "value": m106,
        "value_per_hour": m107,
        "version_num": m108,
        "vertical": MessageLookupByLibrary.simpleMessage("縦画面"),
        "view": MessageLookupByLibrary.simpleMessage("ビュー"),
        "visible": MessageLookupByLibrary.simpleMessage("表示"),
        "voice": MessageLookupByLibrary.simpleMessage("音声"),
        "voice_diary": MessageLookupByLibrary.simpleMessage("音声日記"),
        "voice_guide": MessageLookupByLibrary.simpleMessage(
            "携帯電話に内蔵されている音声入力法を使用して入力してください"),
        "volume": MessageLookupByLibrary.simpleMessage("音量"),
        "waitingToStart": MessageLookupByLibrary.simpleMessage("未開始"),
        "web_desc": MessageLookupByLibrary.simpleMessage(
            "ブラウザでhttps://www.timerbell.comを開くと、どこでも同じ機能を使用できます"),
        "wechat": MessageLookupByLibrary.simpleMessage("ウィーチャット"),
        "wechat_share": MessageLookupByLibrary.simpleMessage("WeChatで共有"),
        "wednesday": MessageLookupByLibrary.simpleMessage("水曜日"),
        "wednesdayShort": MessageLookupByLibrary.simpleMessage("水"),
        "week": MessageLookupByLibrary.simpleMessage("週"),
        "week_duration_completed":
            MessageLookupByLibrary.simpleMessage("今週の集中時間（分）"),
        "week_mission_completed":
            MessageLookupByLibrary.simpleMessage("今週完了したタスク数"),
        "week_tomatoes_completed":
            MessageLookupByLibrary.simpleMessage("今週完了したトマト数"),
        "welcome": MessageLookupByLibrary.simpleMessage("ようこそ"),
        "welcome_to_time_department": m109,
        "whether_to_repeat": MessageLookupByLibrary.simpleMessage("繰り返すかどうか"),
        "wholeComepleteTime": MessageLookupByLibrary.simpleMessage("完了時間（分）"),
        "write_a_title": MessageLookupByLibrary.simpleMessage("タイトルを書く?"),
        "write_diary": MessageLookupByLibrary.simpleMessage("日記を書く"),
        "write_your_clockin_feedback":
            MessageLookupByLibrary.simpleMessage("あなたの考えを書き下さい"),
        "wrong_question_book": MessageLookupByLibrary.simpleMessage("間違った問題の本"),
        "wrong_question_book_prompt": MessageLookupByLibrary.simpleMessage(
            "{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: 方程式 2*x^2-を解く, folder_id: null, flomo_object_id: null, type: 0, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 2, wqbKnowledgeContent: 一次二次方程式を解く, wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 2, wqbWrongQuestionContent: 方程式 2*x^2-4*x-6=0を解く\n\nx=1またはx=-3, wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: x=3またはx=-1\n完全平方公式や根の公式を使って、正しい答えを見つけることができます, wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}"),
        "wrong_question_knowledge_point":
            MessageLookupByLibrary.simpleMessage("間違った問題の知識点"),
        "wrong_question_knowledge_points":
            MessageLookupByLibrary.simpleMessage("間違った問題の知識点"),
        "wrong_thinking": MessageLookupByLibrary.simpleMessage("思考の誤り"),
        "wrote_a_diary": m110,
        "wrote_a_note": m111,
        "xxx_cannot_be_empty": m112,
        "year": MessageLookupByLibrary.simpleMessage("年"),
        "year_duration_completed":
            MessageLookupByLibrary.simpleMessage("今年の集中時間（分）"),
        "year_mission_completed":
            MessageLookupByLibrary.simpleMessage("今年完了したタスク数"),
        "year_month": m113,
        "year_tomatoes_completed":
            MessageLookupByLibrary.simpleMessage("今年完了したトマト数"),
        "yes": MessageLookupByLibrary.simpleMessage("はい"),
        "your_clockin_mission_with_name_has_begun": m114,
        "your_created_class":
            MessageLookupByLibrary.simpleMessage("これはあなたが作成したクラスです"),
        "your_mission_with_name_has_begun": m115,
        "your_time_prof":
            MessageLookupByLibrary.simpleMessage("あなたのパーソナルタイムマネージャー"),
        "yuan": MessageLookupByLibrary.simpleMessage("元")
      };
}
