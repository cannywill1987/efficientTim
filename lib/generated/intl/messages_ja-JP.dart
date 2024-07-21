// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja_JP locale. All the
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
  String get localeName => 'ja_JP';

  static String m0(date) => "${date} 이후";

  static String m1(numbers) => "일괄 완료 \'${numbers}\' 작업";

  static String m2(numbers) => "일괄 삭제 \'${numbers}\' 작업";

  static String m3(numbers) => "일괄 미완료 \'${numbers}\' 작업";

  static String m4(numbers) => "일괄 업데이트 \'${numbers}\' 작업";

  static String m5(date) => "${date} 이전";

  static String m6(date1, date2) => "${date1}부터 ${date2}까지";

  static String m7(numTotatoes, duration, time, minute) =>
      "예상 토마토 시간:${numTotatoes} x ${duration} 분 = ${time}시간${minute}분";

  static String m8(times) => "연속 ${times}일 출근";

  static String m9(n) => "총 ${n}일 출근";

  static String m10(title) => "체크인 미션 \'${title}\' 완료";

  static String m11(title, num) => "작업 \'${title}\'에 집중 완료, ${num} 가상 동전을 얻음";

  static String m12(title, time, num) =>
      "작업 \'${title}\'에 한 번 집중 완료, ${time} 동안 집중하고 ${num} 가상 동전을 얻음";

  static String m13(title) => "휴식 \'${title}\' 완료";

  static String m14(title) => "휴식 \'${title}\' 완료";

  static String m15(name) => "${name}";

  static String m16(folderName) => "폴더\"${folderName}\"를 삭제하시겠습니까?";

  static String m17(folderName) =>
      "폴더\"${folderName}\"의 목록과 관련 하위 작업을 삭제하시겠습니까?";

  static String m18(money) => "\'${money}\' 금액 소비 (수동 입력)";

  static String m19(money, present) =>
      "선물 \'${present}\'를 구매하기 위해 \'${money}\'를 소비했습니다";

  static String m20(title, link) => "작업 ${title}의 내용을 보려면 링크를 클릭하세요: ${link}";

  static String m21(code) =>
      "링크를 복사하여 친구와 공유하면, 그룹 코드 ${code}로 그룹 리스트에 가입할 수 있습니다";

  static String m22(title) => "リスト \'${title}\' をコピー";

  static String m23(day, hour, mins, secs) => "${day}일 ${hour}:${mins}:${secs}";

  static String m24(hour, mins, secs) => "${hour}:${mins}:${secs}";

  static String m25(mins, secs) => "${mins}:${secs}";

  static String m26(times, total, title) =>
      "${times}/${total}번 체크인 \'${title}\'";

  static String m27(listing, title) =>
      "목록 \'${listing}\'에 카드 작업 \'${title}\' 생성";

  static String m28(title) => "카드 작업 \'${title}\' 생성";

  static String m29(title) => "목록 \'${title}\' 생성";

  static String m30(listing, title) => "목록 \'${listing}\'에 작업 \'${title}\' 생성";

  static String m31(title) => "작업 \'${title}\' 생성";

  static String m32(title) => "태그 \'${title}\' 생성";

  static String m33(Folder) => "${Folder} 생성";

  static String m34(tone) => "현재 벨소리:${tone}";

  static String m35(date1, date2) => "${date1}부터 ${date2}까지";

  static String m36(month, day) => "${month}월${day}일";

  static String m37(month, day, hour, mins) =>
      "${month}월${day}일,${hour}:${mins}";

  static String m38(money) => "${money}일 전";

  static String m39(money) => "${money}일 후";

  static String m40(title) => "체크인 미션 \'${title}\' 삭제";

  static String m41(note) => "데스크톱 위젯 ${note}";

  static String m42(title) => "제목 편집「${title}」";

  static String m43(n) => "하루에 ${n}번";

  static String m44(title, time, num) =>
      "앱을 떠나서 작업 \'${title}\'에 집중, ${time} 동안 집중하고 ${num} 가상 동전을 얻음";

  static String m45(title) => "작업 \'${title}\' 완료";

  static String m46(value) => "시간: ${value}";

  static String m47(value) => "수량: ${value}";

  static String m48(duraiton) => "완료 시간 ${duraiton}초";

  static String m49(correct, error, percent) =>
      "정답 ${correct}개, 오답 ${error}개, 정확도 ${percent}";

  static String m50(name) => "${name}을(를) 성공적으로 로컬로 가져왔습니다, 훈련을 시작할 수 있습니다";

  static String m51(app_name) => "${app_name}의 시간 관리자 역할";

  static String m52(id) => "그룹 ID: ${id}";

  static String m53(title) => "\"${title}\"에 작업을 추가하고, \'Enter\'키를 눌러 저장하세요";

  static String m54(hour, min) => "${hour}시${min}분";

  static String m55(hour, min, sec) => "${hour}시${min}분${sec}초";

  static String m56(wordCount, charCount) =>
      "(선택된) 단어 수: ${wordCount}, 문자 수: ${charCount}";

  static String m57(num) => "최대 ${num}자 입력 가능";

  static String m58(max) => "${max}자를 초과할 수 없습니다";

  static String m59(time) => "최대 녹음 시간:${time}";

  static String m60(min, sec) => "${min}분${sec}초";

  static String m61(year, month, day, weekday) =>
      "${year}년 ${month}월 ${day}일, ${weekday}";

  static String m62(month, day, year) => "${year}년 ${month}월 ${day}일";

  static String m63(month, year) => "${year}년 ${month}월";

  static String m64(year, month, day, hour, min, weekday) =>
      "${year}년 ${month}월 ${day}일 ${hour}:${min}, ${weekday}";

  static String m65(missionTitle) =>
      "${missionTitle} 임무가 진행 중입니다. 정말로 중지하시겠습니까?";

  static String m66(name) => "\'${name}\' 작업 알림";

  static String m67(name) => "\'${name}\' 체크인 미션 알림";

  static String m68(submission, mission) =>
      "임무 ${mission}의 하위 임무 ${submission}이 시작되었습니다. 준비하세요";

  static String m69(title) => "작업 \"${title}\"";

  static String m70(value) => "먼저 시간당 가치를 설정하십시오 ${value}\$/시간";

  static String m71(title) => "목록 제목을 \'${title}\'로 수정";

  static String m72(title) => "태그를 \'${title}\'로 수정";

  static String m73(month, day, weekday) => "${month}월${day}일 ${weekday}";

  static String m74(month) => "${month}월 출근률";

  static String m75(month) => "${month}월 출근 기록";

  static String m76(course) => "나의 ${course}";

  static String m77(ranking) => "${ranking}위";

  static String m78(ranking) => "이번에 내 순위는 ${ranking}위입니다";

  static String m79(days) => "${days}일 연체";

  static String m80(newline) => "줄 바꿈:${newline}";

  static String m81(title, min, secs) => "${title}(남은 시간: ${min}:${secs})";

  static String m82(value, hour, mins) =>
      "오늘 당신은 ${value}개의 작업을 완료해야 합니다, 예상 소요 시간은 ${hour}시간 ${mins}분입니다";

  static String m83(n, hour, mins) =>
      "${n}개의 작업이 지연되었으며, 예상 소요 시간은 ${hour}시간 ${mins}분입니다";

  static String m84(days) => "${days}일";

  static String m85(num) => "${num}분";

  static String m86(num, total) => "${num} 임무 / ${total} 총 임무";

  static String m87(num, total) => "목록${num}/${total}";

  static String m88(num, total) => "${num}/${total}";

  static String m89(num) => "${num}개의 작업";

  static String m90(num) => "${num}회";

  static String m91(num) => "${num} 토마토";

  static String m92(num) => "${num}개";

  static String m93(number) => "${number}개의 상품";

  static String m94(name) => "리스트「${name}」의 비밀번호를 입력해 주세요";

  static String m95(xxx) => "${xxx} 입력해주세요";

  static String m96(name) => "앱 스토어에서 \"${name}\"을(를) 검색해 주세요";

  static String m97(content) => "${content}을(를) 선택하세요";

  static String m98(present) => "${present}는 얼마의 돈을 사용하나요";

  static String m99(missionFinished, missionToDo, duration) =>
      "${missionFinished} 완료, ${missionToDo} 시작, ${missionToDo} 시간: ${duration}";

  static String m100(total) => "${total}회 반복";

  static String m101(value) => "시간: ${value}";

  static String m102(value) => "수량: ${value}";

  static String m103(role, time, content, timestampFormat1, timestampFormat2,
          timestampFormat3) =>
      "나는 당신이 ${role}을 연기하고, 당신이 다음 내용을 계획해야 한다고 생각합니다. 시간은 ${time}, 내용은 ${content}이며, json objects 배열을 반환해야 합니다. 반환 JSON Objects\njson의 각 필드 키 값과 설명은 다음과 같습니다.\nString? title = \'\'; //필수 제목 \nint? total_tomotoes; //결과를 직접 계산합니다. 완료된 토마토의 수 (daily_end_time - daily_start_time)/tomato_duration \nint? tomato_duration = 1500000;  //결과를 직접 계산합니다. 값은 항상 25 * 60 * 1000 밀리초로, 한 토마토에 25분을 의미합니다. \nString? end_time; //결과를 직접 계산합니다. ${timestampFormat1} 형식의 종료 시간. 필수 \nint? priorityStatus; //3은 우선 순위 없음, 2는 낮은 우선 순위, 1은 중간 우선 순위, 0은 높은 우선 순위. 필수 \nString? daily_start_time; //결과를 직접 계산합니다. ${timestampFormat2} 형식의 작업 시작 시간   \nString? daily_end_time; //결과를 직접 계산합니다. ${timestampFormat3} 형식의 작업 종료 시간 \nString? message; //작업 알림 \n참고: null일 수 없으며, key:value에서 value는 결과를 직접 제공합니다. 각 작업의 daily_start_time과 daily_end_time 시간은 겹치지 않아야 합니다. \ntitle은 제목을 명확하게 설명해야 하며, 다른 설명이 필요하지 않습니다. 각 작업은 최소 5분 간격으로 설정해야 합니다.\n 배열을 루트로 하는 json 문자열만 반환합니다. 예: [object,object,](참고: 정치나 역사에 대해 논의하지 않습니다)";

  static String m104(listing_name, code, app_name) =>
      "${listing_name}의 그룹 리스트 번호는 ${code}입니다. ${app_name}을 다운로드하고 그룹 리스트 번호를 입력하면 파트너와 함께 작업할 수 있습니다.";

  static String m105(title) => "작업 \'${title}\'에 집중 시작";

  static String m106(title) => "휴식 \'${title}\' 시작";

  static String m107(title, time, num) =>
      "작업 \'${title}\'에 집중 중지, ${time} 동안 집중하고 ${num} 가상 동전을 얻음";

  static String m108(title) => "휴식 \'${title}\' 중지";

  static String m109(money) => "${money} 전";

  static String m110(money) => "${money} 후";

  static String m111(date) => "${date} 데이터";

  static String m112(num) => "총 ${num}";

  static String m113(num) => "총 ${num} 토마토";

  static String m114(trainee) =>
      "주의하세요, 실제 상황에 따라 적절하게 행동하세요. ${trainee}의 답변에 만족하지 않는 경우, 더 자세한 명령을 제공하여 ${trainee}에게 시간을 계획하도록 도와줄 수 있습니다.";

  static String m115(trainee) => "${trainee}의 조언";

  static String m116(time) => "마지막 업데이트 시간:${time}";

  static String m117(listing, title) =>
      "목록 \'${listing}\'에 작업 \'${title}\' 업데이트";

  static String m118(title) => "작업 \'${title}\' 업데이트";

  static String m119(value) => "가치:${value}";

  static String m120(value) => "${value}\$/시간";

  static String m121(version) => "현재 버전 ${version}";

  static String m122(appName) => "\"${appName}\"에 오신 것을 환영합니다";

  static String m123(wordCount, charCount) =>
      "단어 수: ${wordCount}, 문자 수: ${charCount}";

  static String m124(diary) => "일기 \'${diary}\'를 작성했습니다";

  static String m125(diary) => "노트 \'${diary}\'를 작성했습니다";

  static String m126(text) => "${text}은(는) 비워 둘 수 없습니다";

  static String m127(month, year) => "${year}년 ${month}월";

  static String m128(name) => "당신이 설정한 체크인 미션 \'${name}\'이 시작되었습니다. 체크인을 해주세요";

  static String m129(name) => "당신의 \'${name}\' 작업 알림이 시작되었습니다. 준비하세요";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("정보"),
        "account": MessageLookupByLibrary.simpleMessage("계정"),
        "account_unregister": MessageLookupByLibrary.simpleMessage("계정 탈퇴"),
        "addBill": MessageLookupByLibrary.simpleMessage("청구서 추가"),
        "addBillReminder": MessageLookupByLibrary.simpleMessage(
            "청구서를 추가하고, 상환을 알리며, 기한 초과를 피하세요"),
        "addMissions2": MessageLookupByLibrary.simpleMessage("작업 추가..."),
        "add_bill": MessageLookupByLibrary.simpleMessage("청구서 추가"),
        "add_content": MessageLookupByLibrary.simpleMessage("노트 작성 시작"),
        "add_credit_card_bill":
            MessageLookupByLibrary.simpleMessage("신용카드 청구서 추가"),
        "add_fail": MessageLookupByLibrary.simpleMessage("추가 실패"),
        "add_group": MessageLookupByLibrary.simpleMessage("그룹 추가"),
        "add_group_cannot_reorder":
            MessageLookupByLibrary.simpleMessage("그룹을 추가하면 그룹을 재정렬할 수 없습니다"),
        "add_group_listing": MessageLookupByLibrary.simpleMessage("그룹 리스트 추가"),
        "add_group_on_the_left":
            MessageLookupByLibrary.simpleMessage("왼쪽에 그룹 추가"),
        "add_group_on_the_right":
            MessageLookupByLibrary.simpleMessage("오른쪽에 그룹 추가"),
        "add_link": MessageLookupByLibrary.simpleMessage("링크 추가"),
        "add_listing": MessageLookupByLibrary.simpleMessage("목록 추가"),
        "add_note": MessageLookupByLibrary.simpleMessage("노트 작성"),
        "add_reminder": MessageLookupByLibrary.simpleMessage("리마인더 추가"),
        "add_subtask": MessageLookupByLibrary.simpleMessage("하위 작업 추가"),
        "add_successfully":
            MessageLookupByLibrary.simpleMessage("성공적으로 추가되었습니다, 타임라인에서 확인하세요"),
        "add_tag": MessageLookupByLibrary.simpleMessage("태그 추가"),
        "add_task": MessageLookupByLibrary.simpleMessage("작업 추가"),
        "add_username": MessageLookupByLibrary.simpleMessage("사용자 이름 추가"),
        "addsuccess": MessageLookupByLibrary.simpleMessage("추가 성공"),
        "administrator": MessageLookupByLibrary.simpleMessage("관리자"),
        "advanced_permissions":
            MessageLookupByLibrary.simpleMessage("고급 권한: 복사, 주석 금지 설정 가능"),
        "after_date": m0,
        "agree": MessageLookupByLibrary.simpleMessage("동의"),
        "ai_create": MessageLookupByLibrary.simpleMessage("AI 생성"),
        "ai_helper": MessageLookupByLibrary.simpleMessage("AI 도우미"),
        "alert": MessageLookupByLibrary.simpleMessage("알림"),
        "alertMessage1":
            MessageLookupByLibrary.simpleMessage("토마토 수는 0이 될 수 없습니다"),
        "alertMessage2":
            MessageLookupByLibrary.simpleMessage("제목은 비워 둘 수 없습니다"),
        "alert_time": MessageLookupByLibrary.simpleMessage("알림 시간"),
        "alipay": MessageLookupByLibrary.simpleMessage("알리페이"),
        "all": MessageLookupByLibrary.simpleMessage("전체"),
        "allUnfinishedMissions":
            MessageLookupByLibrary.simpleMessage("모든 미완료 작업"),
        "all_finished_mission":
            MessageLookupByLibrary.simpleMessage("모든 완료된 미션"),
        "all_maju": MessageLookupByLibrary.simpleMessage("전체"),
        "all_mission": MessageLookupByLibrary.simpleMessage("모든 미션"),
        "all_pending_repayment":
            MessageLookupByLibrary.simpleMessage("모든 보류 중인 상환"),
        "already_delay": MessageLookupByLibrary.simpleMessage("이미 지연되었습니다"),
        "already_exist":
            MessageLookupByLibrary.simpleMessage("훈련 계획이 이미 생성되었습니다"),
        "already_exists_at_this_time":
            MessageLookupByLibrary.simpleMessage("이미 이 시간에 존재합니다"),
        "already_in_course": MessageLookupByLibrary.simpleMessage("이미 참여한 강좌"),
        "already_in_group":
            MessageLookupByLibrary.simpleMessage("이미 그룹에 속해 있습니다"),
        "already_persisted": MessageLookupByLibrary.simpleMessage("이미 지속되었습니다"),
        "amount": MessageLookupByLibrary.simpleMessage("금액"),
        "analyse": MessageLookupByLibrary.simpleMessage("분석"),
        "analytics": MessageLookupByLibrary.simpleMessage("분석"),
        "anki_card_prompt": MessageLookupByLibrary.simpleMessage(
            "{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: What is th, folder_id: null, flomo_object_id: null, type: 2, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 2, wqbWrongQuestionContent: What is the past tense form of the irregular verb \"go\"?\n\n, wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: The past tense of \"go\" is \"went\". Example: He went to the store yesterday.\n\nThis card helps learners memorize and practice the past tense forms of common irregular verbs in English., wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}"),
        "answer": MessageLookupByLibrary.simpleMessage("답변"),
        "appThmeSetting": MessageLookupByLibrary.simpleMessage("테마 색상 패널 설정"),
        "app_name": MessageLookupByLibrary.simpleMessage("시간 관리국 ToDo"),
        "apple_login": MessageLookupByLibrary.simpleMessage("애플 로그인"),
        "apr": MessageLookupByLibrary.simpleMessage("4월"),
        "aprFull": MessageLookupByLibrary.simpleMessage("4월"),
        "archive": MessageLookupByLibrary.simpleMessage("보관"),
        "archived": MessageLookupByLibrary.simpleMessage("보관됨"),
        "arithmetic_error": MessageLookupByLibrary.simpleMessage("산술 오류"),
        "at_least_one_prize":
            MessageLookupByLibrary.simpleMessage("적어도 하나의 상품을 선택하세요"),
        "attachment": MessageLookupByLibrary.simpleMessage("첨부 파일"),
        "aug": MessageLookupByLibrary.simpleMessage("8월"),
        "augFull": MessageLookupByLibrary.simpleMessage("8월"),
        "author_intro": MessageLookupByLibrary.simpleMessage("저자 소개"),
        "author_presentation_content":
            MessageLookupByLibrary.simpleMessage("저자에 대해"),
        "auto": MessageLookupByLibrary.simpleMessage("자동"),
        "auto_next_off": MessageLookupByLibrary.simpleMessage("루프 끄기"),
        "auto_next_on": MessageLookupByLibrary.simpleMessage("루프 켜기"),
        "avatar": MessageLookupByLibrary.simpleMessage("아바타를 선택하세요"),
        "back": MessageLookupByLibrary.simpleMessage("뒤로"),
        "back_card": MessageLookupByLibrary.simpleMessage("뒷면 카드"),
        "background": MessageLookupByLibrary.simpleMessage("배경화면"),
        "background_auto_mode":
            MessageLookupByLibrary.simpleMessage("배경 자동 변경"),
        "background_change_auto_prompt_off":
            MessageLookupByLibrary.simpleMessage("자동 배경 변경이 꺼졌습니다"),
        "background_change_auto_prompt_on":
            MessageLookupByLibrary.simpleMessage("배경이 자동으로 변경되었습니다"),
        "background_setting": MessageLookupByLibrary.simpleMessage("배경 설정"),
        "bank": MessageLookupByLibrary.simpleMessage("은행"),
        "batch_complete_missions": m1,
        "batch_delete_missions": m2,
        "batch_uncomplete_missions": m3,
        "batch_update_missions": m4,
        "bePening": MessageLookupByLibrary.simpleMessage("보류 중"),
        "before_date": m5,
        "between_date": m6,
        "bill_day": MessageLookupByLibrary.simpleMessage("청구일"),
        "bill_detail": MessageLookupByLibrary.simpleMessage("청구서 세부사항"),
        "bill_this_statement":
            MessageLookupByLibrary.simpleMessage("이 기간의 청구서"),
        "billing_day": MessageLookupByLibrary.simpleMessage("청구일"),
        "bold": MessageLookupByLibrary.simpleMessage(""),
        "browse": MessageLookupByLibrary.simpleMessage("클릭하여 브라우징"),
        "browser_not_support_multiline": MessageLookupByLibrary.simpleMessage(
            "브라우저에서는 여러 줄 입력을 지원하지 않습니다. 더 나은 경험을 위해 클라이언트를 다운로드할 수 있습니다."),
        "bulletedList": MessageLookupByLibrary.simpleMessage(""),
        "buy_training_plan": MessageLookupByLibrary.simpleMessage("훈련 계획 구매"),
        "byday": MessageLookupByLibrary.simpleMessage("일"),
        "calculateTomatoesTime": m7,
        "calendar": MessageLookupByLibrary.simpleMessage("일정"),
        "calendar2": MessageLookupByLibrary.simpleMessage("달력"),
        "camera_permission_description": MessageLookupByLibrary.simpleMessage(
            "사진 촬영 기능을 사용하려면 카메라 권한을 부여해야 합니다"),
        "can_edit": MessageLookupByLibrary.simpleMessage("편집 가능"),
        "can_not_be_empty":
            MessageLookupByLibrary.simpleMessage("입력란은 비워둘 수 없습니다"),
        "can_view": MessageLookupByLibrary.simpleMessage("볼 수 있음"),
        "cancel": MessageLookupByLibrary.simpleMessage("취소"),
        "cancel_setting_administrator":
            MessageLookupByLibrary.simpleMessage("관리자 취소"),
        "cannot_handle_myself":
            MessageLookupByLibrary.simpleMessage("자신을 처리할 수 없음"),
        "capture_a_photo": MessageLookupByLibrary.simpleMessage("사진 찍기"),
        "capture_a_video": MessageLookupByLibrary.simpleMessage("비디오 촬영"),
        "card": MessageLookupByLibrary.simpleMessage("카드"),
        "card_number": MessageLookupByLibrary.simpleMessage("카드 번호"),
        "carelessness": MessageLookupByLibrary.simpleMessage("부주의"),
        "cause_analysis": MessageLookupByLibrary.simpleMessage("원인 분석"),
        "change_background": MessageLookupByLibrary.simpleMessage("배경 변경"),
        "change_bg": MessageLookupByLibrary.simpleMessage("배경 선택"),
        "chat": MessageLookupByLibrary.simpleMessage("채팅"),
        "chatgpt": MessageLookupByLibrary.simpleMessage("AI"),
        "chatgpt_ai_username_huawei":
            MessageLookupByLibrary.simpleMessage("선생님"),
        "chatgpt_desc":
            MessageLookupByLibrary.simpleMessage("여기서는 어떤 질문에도 답을 찾을 수 있습니다"),
        "chatgpt_desc_huawei":
            MessageLookupByLibrary.simpleMessage("여기서는 어떤 질문에도 답을 찾을 수 있습니다"),
        "chatgpt_huawei": MessageLookupByLibrary.simpleMessage("AI 도우미"),
        "checkbox": MessageLookupByLibrary.simpleMessage(""),
        "choose_attachment": MessageLookupByLibrary.simpleMessage("첨부 파일 선택"),
        "chronograph": MessageLookupByLibrary.simpleMessage("스톱워치"),
        "click_copy_qq": MessageLookupByLibrary.simpleMessage("QQ 번호 복사"),
        "click_to_view": MessageLookupByLibrary.simpleMessage("보려면 클릭"),
        "clock_in": MessageLookupByLibrary.simpleMessage("출근"),
        "clock_in_calendar": MessageLookupByLibrary.simpleMessage("출근 달력"),
        "clockin_n_days_continuously": m8,
        "clockin_n_days_totally": m9,
        "close": MessageLookupByLibrary.simpleMessage("닫기"),
        "close_all_cycle_mission":
            MessageLookupByLibrary.simpleMessage("모든 순환 작업 닫기"),
        "close_multi": MessageLookupByLibrary.simpleMessage("다중 선택 닫기"),
        "cloud_sync": MessageLookupByLibrary.simpleMessage("클라우드 동기화"),
        "cloud_sync_content":
            MessageLookupByLibrary.simpleMessage("크로스 플랫폼 데이터 동기화를 위해 사용됩니다"),
        "code_dynamic_code_incorrect":
            MessageLookupByLibrary.simpleMessage("코드가 올바르지 않습니다"),
        "code_user_exist":
            MessageLookupByLibrary.simpleMessage("사용자가 이미 존재합니다"),
        "code_user_not_exist":
            MessageLookupByLibrary.simpleMessage("사용자가 존재하지 않습니다"),
        "code_user_password_not_correct":
            MessageLookupByLibrary.simpleMessage("계정 또는 비밀번호가 정확하지 않습니다"),
        "color_optional": MessageLookupByLibrary.simpleMessage("색상(필수)"),
        "comingSoon": MessageLookupByLibrary.simpleMessage("7일 내로"),
        "comment": MessageLookupByLibrary.simpleMessage("댓글"),
        "comment_not_empty":
            MessageLookupByLibrary.simpleMessage("댓글은 비워둘 수 없습니다"),
        "comment_placeholder": MessageLookupByLibrary.simpleMessage(
            "귀하의 모든 합리적인 제안은 가능한 한 빨리 구현하겠습니다"),
        "compare_to_tomorrow": MessageLookupByLibrary.simpleMessage("어제와 비교"),
        "complete": MessageLookupByLibrary.simpleMessage("완료"),
        "complete_flomo_mission": m10,
        "complete_focusing_mission_name": m11,
        "complete_one_time_focusing_mission_name": m12,
        "complete_plan_classification":
            MessageLookupByLibrary.simpleMessage("완료된 계획 분류"),
        "complete_resting_mission_name": m13,
        "complete_resting_name": m14,
        "complete_voice_diary":
            MessageLookupByLibrary.simpleMessage("음성 일기 완료"),
        "complete_voice_diary_with_title": m15,
        "complete_voice_note": MessageLookupByLibrary.simpleMessage("음성 메모 완료"),
        "completed": MessageLookupByLibrary.simpleMessage("완료됨"),
        "completed_days": MessageLookupByLibrary.simpleMessage("완료 일수"),
        "completion_degree": MessageLookupByLibrary.simpleMessage("완성도"),
        "completion_rate": MessageLookupByLibrary.simpleMessage("완료율"),
        "confirm": MessageLookupByLibrary.simpleMessage("확인"),
        "confirmRestDuration": MessageLookupByLibrary.simpleMessage("기본 휴식 시간"),
        "confirmToDelete": MessageLookupByLibrary.simpleMessage(
            "삭제하시겠습니까?\n주의: 삭제된 작업은 복구할 수 없습니다"),
        "confirmToFinishMission":
            MessageLookupByLibrary.simpleMessage("이 임무를 완료하였는지 확인하시겠습니까?"),
        "confirmToFinished": MessageLookupByLibrary.simpleMessage("완료 확인"),
        "confirmToFinishedContent":
            MessageLookupByLibrary.simpleMessage("이 작업을 완료했는지 확인하시겠습니까?"),
        "confirmToSyncCloudData": MessageLookupByLibrary.simpleMessage(
            "클라우드 동기화를 확인하시겠습니까(참고: 일반적으로 한 대의 휴대폰에 두 개의 계정이 로그인되어 있고, 이전 휴대폰 번호의 데이터를 현재 휴대폰 번호로 동기화해야 할 필요가 있습니다)?"),
        "confirm_delete_folder": m16,
        "confirm_delete_folder_desc":
            MessageLookupByLibrary.simpleMessage("삭제 후 복원할 수 없습니다"),
        "confirm_delete_mission_models": m17,
        "confirm_deletion": MessageLookupByLibrary.simpleMessage("삭제 확인"),
        "confirm_unregister": MessageLookupByLibrary.simpleMessage("탈퇴 확인"),
        "confused": MessageLookupByLibrary.simpleMessage("혼란스러운 개념"),
        "consider_it": MessageLookupByLibrary.simpleMessage("고려해보세요"),
        "consume_failure": MessageLookupByLibrary.simpleMessage("소비 실패"),
        "consume_money": m18,
        "consume_money_buy_present": m19,
        "consume_success": MessageLookupByLibrary.simpleMessage("소비 성공"),
        "consump_money": MessageLookupByLibrary.simpleMessage("사용할 돈:"),
        "consump_present": MessageLookupByLibrary.simpleMessage("소비 가능한 상품"),
        "consump_present_description": MessageLookupByLibrary.simpleMessage(
            "집중해서 돈을 벌 때 자신에게 주는 보상을 편집하세요"),
        "content": MessageLookupByLibrary.simpleMessage("내용"),
        "content_cannot_be_empty":
            MessageLookupByLibrary.simpleMessage("내용을 입력해야 합니다"),
        "continously_clockin": MessageLookupByLibrary.simpleMessage("연속 출석"),
        "continue2": MessageLookupByLibrary.simpleMessage("계속 진행"),
        "continueTxt": MessageLookupByLibrary.simpleMessage("계속"),
        "continuous_clock_in": MessageLookupByLibrary.simpleMessage("연속 출근"),
        "continuous_days": MessageLookupByLibrary.simpleMessage("연속 일수"),
        "continuously": MessageLookupByLibrary.simpleMessage("지속적으로"),
        "convert_to_note": MessageLookupByLibrary.simpleMessage("노트로 변환"),
        "copy": MessageLookupByLibrary.simpleMessage("복사"),
        "copy_and_share":
            MessageLookupByLibrary.simpleMessage("링크를 복사하여 다른 사람과 공유하세요"),
        "copy_and_share_with_title": m20,
        "copy_link": MessageLookupByLibrary.simpleMessage("링크 복사"),
        "copy_link_description": m21,
        "copy_mission_model": m22,
        "copy_qq": MessageLookupByLibrary.simpleMessage(
            "QQ 그룹 번호(563144208)를 복사하여 공식 QQ 그룹에 가입하세요"),
        "copy_qq_success": MessageLookupByLibrary.simpleMessage(
            "복사 성공, QQ를 열어 붙여넣기로 공식 QQ 그룹에 가입하세요"),
        "copy_sub_title": MessageLookupByLibrary.simpleMessage(
            "새 버전 정보를 즉시 받고 원하는 새 기능을 피드백할 수 있습니다"),
        "copy_success": MessageLookupByLibrary.simpleMessage("복사 성공"),
        "correct_answer": MessageLookupByLibrary.simpleMessage("정답"),
        "count_down": m23,
        "count_down2": m24,
        "count_down3": m25,
        "count_down_text": MessageLookupByLibrary.simpleMessage("카운트 다운"),
        "counting": MessageLookupByLibrary.simpleMessage("타이밍 중"),
        "course": MessageLookupByLibrary.simpleMessage("강좌"),
        "course_desc": MessageLookupByLibrary.simpleMessage(
            "높은 점수를 원하거나 체중 감량을 원하면 여기에 답이 있습니다"),
        "course_intro": MessageLookupByLibrary.simpleMessage("강좌 소개"),
        "course_introduction": MessageLookupByLibrary.simpleMessage("강좌 소개"),
        "create": MessageLookupByLibrary.simpleMessage("생성"),
        "createMission": MessageLookupByLibrary.simpleMessage("목록 생성"),
        "createSuccess": MessageLookupByLibrary.simpleMessage("생성 성공"),
        "createTag": MessageLookupByLibrary.simpleMessage("태그 생성"),
        "create_chat": MessageLookupByLibrary.simpleMessage("채팅 생성"),
        "create_copy": MessageLookupByLibrary.simpleMessage("복사본 만들기"),
        "create_folder_desc": MessageLookupByLibrary.simpleMessage("폴더 생성"),
        "create_mission": MessageLookupByLibrary.simpleMessage("임무 생성"),
        "create_mission_by_content":
            MessageLookupByLibrary.simpleMessage("임무를 생성해줘:\n임무 제목:\n설명:"),
        "create_mission_by_gpt":
            MessageLookupByLibrary.simpleMessage("임무 또는 목록 생성"),
        "create_mission_by_title":
            MessageLookupByLibrary.simpleMessage("임무 생성"),
        "create_mission_title": MessageLookupByLibrary.simpleMessage("차트를 보여줘"),
        "create_mission_title_content":
            MessageLookupByLibrary.simpleMessage("차트를 보여줘\n시간:"),
        "create_name_flomo_mission": m26,
        "create_name_flomomission": m27,
        "create_name_flomomission2": m28,
        "create_name_listing": m29,
        "create_name_mission": m30,
        "create_name_mission2": m31,
        "create_name_tag": m32,
        "create_present": MessageLookupByLibrary.simpleMessage("보상 생성"),
        "create_success": MessageLookupByLibrary.simpleMessage("생성 성공"),
        "create_time": MessageLookupByLibrary.simpleMessage("생성 시간"),
        "create_xxx": m33,
        "creating_date": MessageLookupByLibrary.simpleMessage("생성 날짜"),
        "credit_bag": MessageLookupByLibrary.simpleMessage("카드 가방"),
        "credit_limit": MessageLookupByLibrary.simpleMessage("신용 한도"),
        "curAnalytics": MessageLookupByLibrary.simpleMessage("실시간 데이터"),
        "curTimeF": MessageLookupByLibrary.simpleMessage("시작 시간"),
        "currentRingTone": m34,
        "current_amount": MessageLookupByLibrary.simpleMessage("현재 금액"),
        "custom": MessageLookupByLibrary.simpleMessage("사용자 정의"),
        "customize": MessageLookupByLibrary.simpleMessage("사용자 정의"),
        "daily_completion_times":
            MessageLookupByLibrary.simpleMessage("일일 완료 횟수"),
        "daily_end_time": MessageLookupByLibrary.simpleMessage("매일 종료 시간"),
        "daily_start_time": MessageLookupByLibrary.simpleMessage("매일 시작 시간"),
        "dark_mode": MessageLookupByLibrary.simpleMessage("다크 모드"),
        "data_analyse": MessageLookupByLibrary.simpleMessage("데이터 분석"),
        "data_analyse_desc": MessageLookupByLibrary.simpleMessage(
            "실시간 데이터 분석으로 자신을 더 잘 이해할 수 있도록 도와줍니다"),
        "date": MessageLookupByLibrary.simpleMessage("날짜"),
        "date1_to_date2": m35,
        "dateFromMonth": m36,
        "dateFromMonthToMins": m37,
        "dateOutOfLimit":
            MessageLookupByLibrary.simpleMessage("선택한 날짜가 범위를 벗어났습니다"),
        "datetime": MessageLookupByLibrary.simpleMessage("날짜시간"),
        "day": MessageLookupByLibrary.simpleMessage("일"),
        "day_hour_minute_second": MessageLookupByLibrary.simpleMessage("일시분초"),
        "daysLater": MessageLookupByLibrary.simpleMessage("일 후"),
        "days_after_bill_day": MessageLookupByLibrary.simpleMessage("청구일 후 일수"),
        "days_after_repayment_day":
            MessageLookupByLibrary.simpleMessage("상환일 후 일수"),
        "days_ago": m38,
        "days_later": m39,
        "de": MessageLookupByLibrary.simpleMessage("의"),
        "deadLine": MessageLookupByLibrary.simpleMessage("마감일"),
        "dec": MessageLookupByLibrary.simpleMessage("12월"),
        "decFull": MessageLookupByLibrary.simpleMessage("12월"),
        "decrypt": MessageLookupByLibrary.simpleMessage("복호화"),
        "defaultFocusDuration":
            MessageLookupByLibrary.simpleMessage("기본 집중 시간"),
        "delay_mission": MessageLookupByLibrary.simpleMessage("미션 연기"),
        "delete": MessageLookupByLibrary.simpleMessage("삭제"),
        "delete_flomo_mission": m40,
        "delete_success": MessageLookupByLibrary.simpleMessage("삭제 성공"),
        "deprecated": MessageLookupByLibrary.simpleMessage("곧 사용 중지"),
        "desc_consume": MessageLookupByLibrary.simpleMessage("소비 설명"),
        "desktop_widget_with_note_n": m41,
        "detailed_training_plan":
            MessageLookupByLibrary.simpleMessage("강좌 상세 훈련 계획"),
        "detailed_training_plan_desc": MessageLookupByLibrary.simpleMessage(
            "공유자에게 더 자세한 훈련 계획을 제공하여, 그들이 자신을 더 세밀하게 향상시키는 데 도움을 줍니다"),
        "detailed_training_plan_desc_2": MessageLookupByLibrary.simpleMessage(
            "이 강좌의 더 자세한 강좌 계획을 보려면 클릭하세요"),
        "detailed_training_plan_optional":
            MessageLookupByLibrary.simpleMessage("강좌 상세 훈련 계획(선택)"),
        "diary": MessageLookupByLibrary.simpleMessage("일기"),
        "digit_password_incorrect":
            MessageLookupByLibrary.simpleMessage("숫자 비밀번호가 틀렸습니다"),
        "discard": MessageLookupByLibrary.simpleMessage("폐기"),
        "dismiss_group": MessageLookupByLibrary.simpleMessage("그룹 해산"),
        "do_it_now": MessageLookupByLibrary.simpleMessage("지금 하기"),
        "do_it_now_desc": MessageLookupByLibrary.simpleMessage(
            "지금 하기란 지금 당장 해야 할 작업을 의미합니다. \'지금 하기\'를 설정하면 카운트다운이 시작됩니다."),
        "dollar": MessageLookupByLibrary.simpleMessage("\$"),
        "dont_remind_again": MessageLookupByLibrary.simpleMessage("다시 알리지 않기"),
        "download_fail": MessageLookupByLibrary.simpleMessage("다운로드 실패"),
        "downloading_please_wait":
            MessageLookupByLibrary.simpleMessage("다운로드 중, 잠시만 기다려 주세요..."),
        "each": MessageLookupByLibrary.simpleMessage("매"),
        "eachSpace": MessageLookupByLibrary.simpleMessage("매"),
        "edit": MessageLookupByLibrary.simpleMessage("편집"),
        "edit_fail": MessageLookupByLibrary.simpleMessage("편집 실패"),
        "edit_sharing": MessageLookupByLibrary.simpleMessage("공유 편집"),
        "edit_successfully":
            MessageLookupByLibrary.simpleMessage("성공적으로 편집되었습니다, 타임라인에서 확인하세요"),
        "edit_title": m42,
        "editing": MessageLookupByLibrary.simpleMessage("편집 중"),
        "email": MessageLookupByLibrary.simpleMessage("メール"),
        "emailCannotBeNull":
            MessageLookupByLibrary.simpleMessage("이메일은 비워둘 수 없습니다"),
        "embedCode": MessageLookupByLibrary.simpleMessage(""),
        "encourage_yourself":
            MessageLookupByLibrary.simpleMessage("자신을 격려하는 말을 적어보세요~"),
        "encrypt": MessageLookupByLibrary.simpleMessage("암호화"),
        "encrypt_desc": MessageLookupByLibrary.simpleMessage(
            "암호화 후에는 설정한 숫자 비밀번호를 사용하여만 복호화할 수 있습니다. 민감한 데이터에 이 기능을 사용하는 것이 좋으며, 그렇지 않으면 사용자 경험에 영향을 줄 수 있습니다"),
        "encrypt_password":
            MessageLookupByLibrary.simpleMessage("숫자 비밀번호를 설정해 주세요"),
        "encrypt_password_confirm":
            MessageLookupByLibrary.simpleMessage("숫자 비밀번호를 다시 입력해 주세요"),
        "encrypt_password_not_match":
            MessageLookupByLibrary.simpleMessage("입력한 비밀번호가 일치하지 않습니다"),
        "encrypt_password_not_set":
            MessageLookupByLibrary.simpleMessage("숫자 비밀번호가 설정되지 않았습니다"),
        "encrypt_store_password":
            MessageLookupByLibrary.simpleMessage("숫자 비밀번호를 로컬에 저장"),
        "end_time": MessageLookupByLibrary.simpleMessage("완료 시간"),
        "end_time_cannot_before_start_time":
            MessageLookupByLibrary.simpleMessage("종료 시간은 시작 시간보다 이전일 수 없습니다"),
        "endtime_cannot_before_starttime":
            MessageLookupByLibrary.simpleMessage("종료 시간은 시작 시간보다 이를 수 없습니다"),
        "enterBankName": MessageLookupByLibrary.simpleMessage("은행 이름을 입력하세요"),
        "enterBillAmount":
            MessageLookupByLibrary.simpleMessage("청구서 금액을 입력하세요"),
        "enterCreditLimit":
            MessageLookupByLibrary.simpleMessage("신용 한도를 입력하세요(선택)"),
        "enterFullCardNumber":
            MessageLookupByLibrary.simpleMessage("전체 카드 번호를 입력하세요"),
        "enterRealName": MessageLookupByLibrary.simpleMessage("실제 이름을 입력하세요"),
        "enter_amount": MessageLookupByLibrary.simpleMessage("금액을 입력하세요"),
        "event": MessageLookupByLibrary.simpleMessage("이벤트"),
        "everyDayOnce": m43,
        "everyone_can_edit":
            MessageLookupByLibrary.simpleMessage("모두 편집할 수 있음"),
        "everyone_can_view": MessageLookupByLibrary.simpleMessage("모두 볼 수 있음"),
        "examination": MessageLookupByLibrary.simpleMessage("검사 오류"),
        "example_demo_hint": MessageLookupByLibrary.simpleMessage(
            "예: \"항상 글머리 기호로 설명하고, unwrap을 사용하지 마세요, 항상 답변을 영어로 출력하세요\""),
        "exist_app_focusing_mission_name": m44,
        "export": MessageLookupByLibrary.simpleMessage("내보내기"),
        "export_data": MessageLookupByLibrary.simpleMessage("데이터 내보내기"),
        "export_excel": MessageLookupByLibrary.simpleMessage("Excel 내보내기"),
        "feb": MessageLookupByLibrary.simpleMessage("2월"),
        "febFull": MessageLookupByLibrary.simpleMessage("2월"),
        "feedback": MessageLookupByLibrary.simpleMessage("사용자 피드백"),
        "filtering_setting": MessageLookupByLibrary.simpleMessage("필터링 설정"),
        "find": MessageLookupByLibrary.simpleMessage("찾기"),
        "find_new_version": MessageLookupByLibrary.simpleMessage("새 버전 발견"),
        "finish": MessageLookupByLibrary.simpleMessage("완료"),
        "finish_level": MessageLookupByLibrary.simpleMessage("완성도:"),
        "finish_mission_name": m45,
        "finish_time": MessageLookupByLibrary.simpleMessage("완료 시간"),
        "finished": MessageLookupByLibrary.simpleMessage("완료"),
        "focus": MessageLookupByLibrary.simpleMessage("집중"),
        "focusFinished": MessageLookupByLibrary.simpleMessage("집중 완료"),
        "focusPausing": MessageLookupByLibrary.simpleMessage("집중 일시 중지 중"),
        "focus_campus": MessageLookupByLibrary.simpleMessage("집중 훈련 캠프"),
        "focus_completed_auto_start_rest":
            MessageLookupByLibrary.simpleMessage("집중 완료 후 자동으로 휴식 시작"),
        "focus_duration": MessageLookupByLibrary.simpleMessage("집중 시간"),
        "focus_duration_distribution":
            MessageLookupByLibrary.simpleMessage("집중 시간 분포"),
        "focus_duration_with_value": m46,
        "focus_finished_ringtone":
            MessageLookupByLibrary.simpleMessage("집중 완료 벨소리"),
        "focus_numbers_with_value": m47,
        "focus_on_time_period_distribution":
            MessageLookupByLibrary.simpleMessage("집중 시간 분포"),
        "focus_setting": MessageLookupByLibrary.simpleMessage("집중 설정"),
        "focus_switch_desc": MessageLookupByLibrary.simpleMessage(
            "집중하는 동안 작업을 전환하면 타이머가 재설정됩니까"),
        "focus_switch_title":
            MessageLookupByLibrary.simpleMessage("새 작업이 타이머를 재설정합니다"),
        "focus_timer": MessageLookupByLibrary.simpleMessage("집중 타이머"),
        "focus_timer_desc":
            MessageLookupByLibrary.simpleMessage("다양한 배경음으로 몰입 상태에 들어갈 수 있습니다"),
        "focusing": MessageLookupByLibrary.simpleMessage("집중 중"),
        "focusing_music": MessageLookupByLibrary.simpleMessage("집중 중 음악"),
        "folder": MessageLookupByLibrary.simpleMessage("폴더"),
        "folder_name": MessageLookupByLibrary.simpleMessage("폴더 이름"),
        "four_pws":
            MessageLookupByLibrary.simpleMessage("4자리 숫자 비밀번호를 입력해 주세요"),
        "four_quadrant": MessageLookupByLibrary.simpleMessage("사분면"),
        "four_quadrant_priority1":
            MessageLookupByLibrary.simpleMessage("긴급 & 중요"),
        "four_quadrant_priority1_abbr":
            MessageLookupByLibrary.simpleMessage("긴급 & 중요"),
        "four_quadrant_priority1_desc":
            MessageLookupByLibrary.simpleMessage("우선 해결"),
        "four_quadrant_priority2":
            MessageLookupByLibrary.simpleMessage("비긴급 & 중요"),
        "four_quadrant_priority2_abbr":
            MessageLookupByLibrary.simpleMessage("비긴급 & 중요"),
        "four_quadrant_priority2_desc":
            MessageLookupByLibrary.simpleMessage("계획을 세우고 해결"),
        "four_quadrant_priority3":
            MessageLookupByLibrary.simpleMessage("긴급 & 비중요"),
        "four_quadrant_priority3_abbr":
            MessageLookupByLibrary.simpleMessage("긴급 & 비중요"),
        "four_quadrant_priority3_desc":
            MessageLookupByLibrary.simpleMessage("다른 사람에게 위임"),
        "four_quadrant_priority4":
            MessageLookupByLibrary.simpleMessage("비긴급 & 비중요"),
        "four_quadrant_priority4_abbr":
            MessageLookupByLibrary.simpleMessage("비긴급 & 비중요"),
        "four_quadrant_priority4_desc":
            MessageLookupByLibrary.simpleMessage("여유가 있을 때 처리"),
        "four_seasons": MessageLookupByLibrary.simpleMessage("1분기부터 4분기까지"),
        "four_seasons_desc":
            MessageLookupByLibrary.simpleMessage("1분기부터 4분기까지의 그룹을 생성합니다"),
        "four_seasons_step1": MessageLookupByLibrary.simpleMessage("제1분기"),
        "four_seasons_step2": MessageLookupByLibrary.simpleMessage("제2분기"),
        "four_seasons_step3": MessageLookupByLibrary.simpleMessage("제3분기"),
        "four_seasons_step4": MessageLookupByLibrary.simpleMessage("제4분기"),
        "fragment_listing": MessageLookupByLibrary.simpleMessage("조각 목록"),
        "free_open": MessageLookupByLibrary.simpleMessage("무료 공개"),
        "frequency": MessageLookupByLibrary.simpleMessage("빈도"),
        "friday": MessageLookupByLibrary.simpleMessage("금요일"),
        "fridayShort": MessageLookupByLibrary.simpleMessage("금"),
        "front_card": MessageLookupByLibrary.simpleMessage("앞면 카드"),
        "gallery": MessageLookupByLibrary.simpleMessage("갤러리"),
        "game1_time_usage": m48,
        "game2_ranking_text": m49,
        "game_input_waiting": MessageLookupByLibrary.simpleMessage("타이머 대기 중"),
        "generate_image": MessageLookupByLibrary.simpleMessage("이미지 생성"),
        "generate_qr_code": MessageLookupByLibrary.simpleMessage("QR 코드 생성"),
        "gently_remind": MessageLookupByLibrary.simpleMessage("친절한 알림"),
        "getVerificationCode":
            MessageLookupByLibrary.simpleMessage("인증 코드 받기 클릭"),
        "get_train_plan_successful": m50,
        "get_training_plan": MessageLookupByLibrary.simpleMessage("훈련 계획 가져오기"),
        "go_to_setting": MessageLookupByLibrary.simpleMessage("설정으로 이동"),
        "google_login": MessageLookupByLibrary.simpleMessage("구글 로그인"),
        "gpt_role": m51,
        "gpt_system_msg_forbidden": MessageLookupByLibrary.simpleMessage(
            "수학, 물리학, 화학, 영어, 대학 과정, 과학, 음식, 주식, 자동차, 시험, 엔터테인먼트, 기술, 경제, 스포츠, 건강, 법률, 패션, 애완 동물, 여행, 건강 보조, 육아, 미디어, 전자 상거래, 교육, 이야기, 긍정적 에너지 등의 주제에 대해서만 토론합니다. 다른 주제는 토론이 허용되지 않습니다. 예를 들어, 중국의 역사, 대만, 티베트, 신장, 포르노, 정치 및 기타 중국 관련 주제, 예를 들어 6월 1일 운동에 대한 토론은 일체 금지됩니다"),
        "gpt_token_expired": MessageLookupByLibrary.simpleMessage(
            "토큰이 만료되었습니다. gpt 접근 권한을 신청하려면 위챗 번호 cannywill을 추가해주세요"),
        "grid": MessageLookupByLibrary.simpleMessage("분류"),
        "group_announcement": MessageLookupByLibrary.simpleMessage("그룹 공지"),
        "group_id": m52,
        "groupview": MessageLookupByLibrary.simpleMessage("그룹 뷰"),
        "gtd": MessageLookupByLibrary.simpleMessage("GTD"),
        "gtd_desc": MessageLookupByLibrary.simpleMessage(
            "GTD의 다섯 단계:；\n (1) 우리의 주의를 끄는 모든 것을 수집하기;\n(2) 수집된 각 항목의 의미와 관련 행동을 명확히 하기;\n(3) 결과를 정리하고, 각 항목에 대한 다음 행동을 나열하기;\n(4) 행동에 옮기기;\n(5) 정기적으로 검토하고 반성하기."),
        "gtd_step1": MessageLookupByLibrary.simpleMessage("정보 수집하기"),
        "gtd_step2": MessageLookupByLibrary.simpleMessage("의미 명확히 하기"),
        "gtd_step3": MessageLookupByLibrary.simpleMessage("정리하기"),
        "gtd_step4": MessageLookupByLibrary.simpleMessage("행동하기"),
        "gtd_step5": MessageLookupByLibrary.simpleMessage("검토 및 요약"),
        "guide1": MessageLookupByLibrary.simpleMessage("집중 시작"),
        "guide2": MessageLookupByLibrary.simpleMessage("상단 입력란을 클릭하여 작업 추가"),
        "guide3_mobile":
            MessageLookupByLibrary.simpleMessage("작업을 편집하거나 삭제하려면 오른쪽으로 스와이프"),
        "guide3_pc":
            MessageLookupByLibrary.simpleMessage("작업을 편집하거나 삭제하려면 마우스를 움직이세요"),
        "guide4": MessageLookupByLibrary.simpleMessage(
            "집중 타이머를 시작하려면 빨간색 재생 버튼을 클릭하세요"),
        "guide_examine_time": MessageLookupByLibrary.simpleMessage("시험 시간"),
        "habit_clockin": MessageLookupByLibrary.simpleMessage("습관 체크인"),
        "habit_clockin_desc": MessageLookupByLibrary.simpleMessage(
            "21일 동안 습관을 형성하고, 에빙하우스가 장기간 학습한 지식을 기억합니다"),
        "hasLogined": MessageLookupByLibrary.simpleMessage("로그인 되었습니다"),
        "header_input_placeholder_with_title": m53,
        "heading1": MessageLookupByLibrary.simpleMessage(""),
        "heading2": MessageLookupByLibrary.simpleMessage(""),
        "heading3": MessageLookupByLibrary.simpleMessage(""),
        "heavy": MessageLookupByLibrary.simpleMessage("무거운"),
        "hello": MessageLookupByLibrary.simpleMessage("안녕하세요"),
        "hidden": MessageLookupByLibrary.simpleMessage("숨기기"),
        "highlight": MessageLookupByLibrary.simpleMessage(""),
        "hint_search_chat": MessageLookupByLibrary.simpleMessage("채팅 기록 검색"),
        "history_event": MessageLookupByLibrary.simpleMessage("역사적 사건"),
        "hour": MessageLookupByLibrary.simpleMessage("시간"),
        "hour3": MessageLookupByLibrary.simpleMessage("시"),
        "hourAndMin": m54,
        "hourAndMinAndSec": m55,
        "i_consume": MessageLookupByLibrary.simpleMessage("나는 사용하다"),
        "i_know": MessageLookupByLibrary.simpleMessage("알겠습니다"),
        "icon": MessageLookupByLibrary.simpleMessage("아이콘"),
        "image": MessageLookupByLibrary.simpleMessage("이미지"),
        "inSevenDays": MessageLookupByLibrary.simpleMessage("7일 후"),
        "in_selection_word_count_and_char_count": m56,
        "inputSmsVerificationCode":
            MessageLookupByLibrary.simpleMessage("SMS 인증 코드 입력"),
        "input_6_digit_password":
            MessageLookupByLibrary.simpleMessage("6자리 숫자 비밀번호를 입력해 주세요"),
        "input_correct_mobile":
            MessageLookupByLibrary.simpleMessage("올바른 휴대폰 번호를 입력해 주세요"),
        "input_correct_password":
            MessageLookupByLibrary.simpleMessage("올바른 비밀번호를 입력하세요"),
        "input_end_time":
            MessageLookupByLibrary.simpleMessage("원하는 종료 시간을 입력하세요"),
        "input_manually": MessageLookupByLibrary.simpleMessage("수동 입력"),
        "input_mission_title_first":
            MessageLookupByLibrary.simpleMessage("미션 제목을 먼저 입력해 주세요"),
        "input_mobile":
            MessageLookupByLibrary.simpleMessage("휴대폰 번호를 입력해 주세요!"),
        "input_your_goal":
            MessageLookupByLibrary.simpleMessage("지속하고 싶은 목표를 입력하세요~"),
        "insert_event": MessageLookupByLibrary.simpleMessage("이벤트 삽입"),
        "insert_success": MessageLookupByLibrary.simpleMessage("삽입 성공"),
        "invalid_mobile_number":
            MessageLookupByLibrary.simpleMessage("잘못된 휴대폰 번호"),
        "isDelayed": MessageLookupByLibrary.simpleMessage("지연 여부"),
        "isEditable": MessageLookupByLibrary.simpleMessage("모든 사용자가 공유 편집 상태"),
        "isFinished": MessageLookupByLibrary.simpleMessage("완료 여부"),
        "is_push_setting": MessageLookupByLibrary.simpleMessage("방향성 푸시 설정"),
        "is_push_setting_detail": MessageLookupByLibrary.simpleMessage(
            "방향성 푸시 설정을 켜면 작업 완료 알림을 받을 수 있습니다"),
        "italic": MessageLookupByLibrary.simpleMessage(""),
        "jan": MessageLookupByLibrary.simpleMessage("1월"),
        "janFull": MessageLookupByLibrary.simpleMessage("1월"),
        "jan_to_dec": MessageLookupByLibrary.simpleMessage("1월부터 12월까지"),
        "jan_to_dec_desc":
            MessageLookupByLibrary.simpleMessage("1월부터 12월까지의 그룹을 생성합니다"),
        "join_days": MessageLookupByLibrary.simpleMessage("참여 일수"),
        "join_group_code": MessageLookupByLibrary.simpleMessage("리스트 번호 입력"),
        "join_group_code_desc":
            MessageLookupByLibrary.simpleMessage("리스트 번호를 입력하여 리스트 검색"),
        "jul": MessageLookupByLibrary.simpleMessage("7월"),
        "julFull": MessageLookupByLibrary.simpleMessage("7월"),
        "jump_next_group": MessageLookupByLibrary.simpleMessage("다음 그룹으로 이동"),
        "jump_previous_group":
            MessageLookupByLibrary.simpleMessage("이전 그룹으로 이동"),
        "jump_to_this_version":
            MessageLookupByLibrary.simpleMessage("이 버전 건너뛰기"),
        "jun": MessageLookupByLibrary.simpleMessage("6월"),
        "junFull": MessageLookupByLibrary.simpleMessage("6월"),
        "label": MessageLookupByLibrary.simpleMessage("라벨"),
        "landscape": MessageLookupByLibrary.simpleMessage("가로"),
        "lastWeek": MessageLookupByLibrary.simpleMessage("지난 주"),
        "last_7_days": MessageLookupByLibrary.simpleMessage("최근 7일"),
        "leave_group": MessageLookupByLibrary.simpleMessage("그룹 나가기"),
        "level1_num_10": MessageLookupByLibrary.simpleMessage("난이도 1: 10개의 단어"),
        "level1_show_words":
            MessageLookupByLibrary.simpleMessage("난이도 1: 듣고 보기"),
        "level2_hide_leftpart_words":
            MessageLookupByLibrary.simpleMessage("난이도 2: 왼쪽 단어 숨기기"),
        "level2_num_20": MessageLookupByLibrary.simpleMessage("난이도 2: 20개의 단어"),
        "level3_hide_rightpart_words":
            MessageLookupByLibrary.simpleMessage("난이도 3: 오른쪽 단어 숨기기"),
        "level3_num_50": MessageLookupByLibrary.simpleMessage("난이도 2: 50개의 단어"),
        "level4_hide_all_parts":
            MessageLookupByLibrary.simpleMessage("난이도 4: 모든 단어 숨기기"),
        "level5_write_words":
            MessageLookupByLibrary.simpleMessage("난이도 5: 쓰기 연습"),
        "light": MessageLookupByLibrary.simpleMessage("가벼운"),
        "light_mode": MessageLookupByLibrary.simpleMessage("라이트 모드"),
        "link": MessageLookupByLibrary.simpleMessage("링크"),
        "list": MessageLookupByLibrary.simpleMessage("목록"),
        "listing": MessageLookupByLibrary.simpleMessage("목록"),
        "listing_icon_optional":
            MessageLookupByLibrary.simpleMessage("목록 아이콘(필수)"),
        "listing_time_optional":
            MessageLookupByLibrary.simpleMessage("목록 시간(선택)"),
        "listview": MessageLookupByLibrary.simpleMessage("리스트 뷰"),
        "loading": MessageLookupByLibrary.simpleMessage("로딩 중"),
        "local_password": MessageLookupByLibrary.simpleMessage("로컬 숫자 비밀번호"),
        "local_password_desc": MessageLookupByLibrary.simpleMessage(
            "로컬 숫자 비밀번호는 암호화된 후에만 휴대폰에 저장되며, 서버로 업로드되거나 다른 기기와 동기화되지 않습니다. 설정에서 로컬 숫자 비밀번호를 설정할 수 있습니다"),
        "localmoney_made_per_minute":
            MessageLookupByLibrary.simpleMessage("1분당 수익"),
        "localmoney_made_per_minute_description":
            MessageLookupByLibrary.simpleMessage("자기 자신을 격려하기 위해 사용됩니다"),
        "lock_app": MessageLookupByLibrary.simpleMessage("앱 잠금"),
        "lock_app_setting": MessageLookupByLibrary.simpleMessage("앱 잠금 설정"),
        "lock_app_setting_description": MessageLookupByLibrary.simpleMessage(
            "앱 잠금은 불필요한 앱에 의해 방해받지 않고 집중하는 데 도움이 됩니다"),
        "lock_screen_auto_password_setting":
            MessageLookupByLibrary.simpleMessage("잠금 화면 자동 비밀번호 설정"),
        "lock_screen_auto_password_setting_for_applock":
            MessageLookupByLibrary.simpleMessage("앱 잠금 화면 자동 비밀번호 설정 지원"),
        "lock_screen_password_setting":
            MessageLookupByLibrary.simpleMessage("잠금 화면 비밀번호 설정"),
        "login": MessageLookupByLibrary.simpleMessage("로그인"),
        "loginContent":
            MessageLookupByLibrary.simpleMessage("새로운 사용자는 자동으로 계정이 생성됩니다"),
        "loginFirst": MessageLookupByLibrary.simpleMessage("먼저 로그인 해주세요"),
        "login_email_to_verifie": MessageLookupByLibrary.simpleMessage(
            "確認メールがあなたのメールアドレスに送信されました。メールを確認してパスワードでログインしてください"),
        "login_or_register": MessageLookupByLibrary.simpleMessage("ログイン/登録"),
        "login_success": MessageLookupByLibrary.simpleMessage("로그인 성공"),
        "logout": MessageLookupByLibrary.simpleMessage("로그아웃"),
        "long_rest_duration": MessageLookupByLibrary.simpleMessage("긴 휴식 시간"),
        "long_rest_interval": MessageLookupByLibrary.simpleMessage("긴 휴식 간격"),
        "loop_setting": MessageLookupByLibrary.simpleMessage("루프 설정"),
        "lottery": MessageLookupByLibrary.simpleMessage("추첨"),
        "lyubichs": MessageLookupByLibrary.simpleMessage("리유비치 기간"),
        "manual": MessageLookupByLibrary.simpleMessage("수동"),
        "manual_create": MessageLookupByLibrary.simpleMessage("수동 생성"),
        "mar": MessageLookupByLibrary.simpleMessage("3월"),
        "marFull": MessageLookupByLibrary.simpleMessage("3월"),
        "mark_repaid_amount": MessageLookupByLibrary.simpleMessage("상환된 금액 표시"),
        "mark_repayment_amount":
            MessageLookupByLibrary.simpleMessage("상환 금액 표시"),
        "mastering_the_situation":
            MessageLookupByLibrary.simpleMessage("상황 마스터"),
        "max_5m_files_size": MessageLookupByLibrary.simpleMessage(
            "파일 크기가 5MB를 초과합니다. 더 작은 파일을 선택해 주세요."),
        "max_input_num": m57,
        "max_words": m58,
        "maximum_recording_time": m59,
        "may": MessageLookupByLibrary.simpleMessage("5월"),
        "mayFull": MessageLookupByLibrary.simpleMessage("5월"),
        "me": MessageLookupByLibrary.simpleMessage("나"),
        "memo_prompt": MessageLookupByLibrary.simpleMessage(
            "{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: 주말 쇼핑 목록 - 11월 5일, folder_id: null, flomo_object_id: null, type: 3, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 0, wqbWrongQuestionContent: , wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: 신선한 과일: 사과(약 2kg), 오렌지(1개의 네트), 드래곤 프룻(2개)\n야채: 시금치(1묶음), 토마토(5개), 오이(3개)\n고기: 닭 가슴살(500g), 스테이크(2조각)\n간식: 감자칩(2팩), 초콜릿(100g)\n생활용품: 핸드 소프(1병), 세제(1병), 화장지(1개)\n음료: 우유(1팩), 녹차(1팩)\n비고:\n\n쿠폰과 멤버십 카드의 유효성을 확인하십시오\n가능한 한 유기농 제품과 친환경 포장을 선택하십시오\n18:00 전에 쇼핑을 완료하십시오, wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}"),
        "memorandum": MessageLookupByLibrary.simpleMessage("메모장"),
        "memorized": MessageLookupByLibrary.simpleMessage("기억됨"),
        "memorizing": MessageLookupByLibrary.simpleMessage("기억 중"),
        "message": MessageLookupByLibrary.simpleMessage("메시지"),
        "method": MessageLookupByLibrary.simpleMessage("방법"),
        "micro_mastery": MessageLookupByLibrary.simpleMessage("마이크로 마스터리"),
        "micro_mastery_desc": MessageLookupByLibrary.simpleMessage(
            "마이크로 마스터리\n\n우리는 종종 어떤 것을 마스터하려면 모든 열정을 쏟아부어 10,000시간 동안 열심히 연습해야 한다고 듣습니다. 그러나 실제로 대부분의 성공한 사람들, 노벨상 수상자를 포함하여, 여가 시간을 이용해 새로운 기술을 배우고 새로운 활동을 시작합니다.\n\n마이크로 마스터리는 4부분으로 나눌 수 있습니다\n1. 입문 기술 찾기 - 이론이 아닌 실습에서 시작하여 업계 전문가의 간단한 시도를 기반으로 합니다\n2. 배경 지원 얻기 - 동기를 얻기 위해 무언가에 참여하고, 장비를 구입하고, 의식감을 만드는 등\n3. 명확한 보상 만들기 - 긍정적이고 부정적인 피드백을 받고, 선순환을 형성하고, 다른 사람에게 가르치는 등, 배운 것을 적용하고 목표가 없는 지연을 피합니다\n4. 재현성 만들기 - 계속해서 반복할 수 있고, 반복할 때마다 개선되며, 진행될 수 있어 자신감이 증가하고 관찰력이 더욱 예리해질 수 있습니다\n\n성공 사례\n스티브 잡스는 대학 수업을 빼먹고 배운 서예 예술을 전 세계적으로 Mac에 적용하여 예술적 관점에서 컴퓨터를 디자인하여 큰 인기를 얻었습니다"),
        "micro_mastery_step1": MessageLookupByLibrary.simpleMessage("입문 기술 찾기"),
        "micro_mastery_step2": MessageLookupByLibrary.simpleMessage("배경 지원 얻기"),
        "micro_mastery_step3":
            MessageLookupByLibrary.simpleMessage("명확한 보상 만들기"),
        "micro_mastery_step4": MessageLookupByLibrary.simpleMessage("재현성 만들기"),
        "microphone_permission_description":
            MessageLookupByLibrary.simpleMessage(
                "노트를 작성할 때 녹음 기능이 필요할 수 있으므로 마이크 권한을 부여해야 합니다"),
        "min3": MessageLookupByLibrary.simpleMessage("분"),
        "minAndSec": m60,
        "min_en": MessageLookupByLibrary.simpleMessage("분"),
        "mine": MessageLookupByLibrary.simpleMessage("나의"),
        "mins": MessageLookupByLibrary.simpleMessage("분"),
        "mins2": MessageLookupByLibrary.simpleMessage("분"),
        "minsSpace": MessageLookupByLibrary.simpleMessage(" 분"),
        "miss_clockin": MessageLookupByLibrary.simpleMessage("출근 누락"),
        "mission": MessageLookupByLibrary.simpleMessage("목록"),
        "missionCompleted": MessageLookupByLibrary.simpleMessage("작업 완료"),
        "missionModelDate": m61,
        "missionModelDate2": m62,
        "missionModelDate3": m63,
        "missionModelDate4": m64,
        "missionNums": MessageLookupByLibrary.simpleMessage("작업 수"),
        "missionPageInputHolder":
            MessageLookupByLibrary.simpleMessage("작업 추가...(Enter 키를 눌러 저장)"),
        "missionRunningAlert": m65,
        "missionToBeComplete": MessageLookupByLibrary.simpleMessage("완료할 작업"),
        "mission_alert_with_name": m66,
        "mission_clocks_in_with_name": m67,
        "mission_evaluation_value":
            MessageLookupByLibrary.simpleMessage("이 임무의 평가 가치(\$)"),
        "mission_setting": MessageLookupByLibrary.simpleMessage("미션 설정"),
        "mission_submission_started": m68,
        "mission_title": m69,
        "mission_value": MessageLookupByLibrary.simpleMessage("임무 가치"),
        "mission_value_toast": m70,
        "missioncompleted": MessageLookupByLibrary.simpleMessage("완료된 작업"),
        "modify_name_listing": m71,
        "modify_name_tag": m72,
        "module_filtering_setting":
            MessageLookupByLibrary.simpleMessage("모듈 필터링 설정"),
        "monday": MessageLookupByLibrary.simpleMessage("월요일"),
        "mondayShort": MessageLookupByLibrary.simpleMessage("월"),
        "money_not_enough_toast": MessageLookupByLibrary.simpleMessage(
            "돈이 부족합니다. 더 많은 집중 작업을 완료하여 돈을 벌어보세요"),
        "money_per_hour": MessageLookupByLibrary.simpleMessage("시간당 수입(\$)"),
        "month": MessageLookupByLibrary.simpleMessage("월"),
        "monthDay": m73,
        "month_clockin_rate": m74,
        "month_clockin_record": m75,
        "month_duration_completed":
            MessageLookupByLibrary.simpleMessage("이번 달의 총 집중 시간(분)"),
        "month_mission_completed":
            MessageLookupByLibrary.simpleMessage("이번 달 완료된 작업 수"),
        "month_tomatoes_completed":
            MessageLookupByLibrary.simpleMessage("이번 달 완료된 토마토 수"),
        "monthsLater": MessageLookupByLibrary.simpleMessage("개월 후"),
        "more": MessageLookupByLibrary.simpleMessage("더"),
        "move_to_next": MessageLookupByLibrary.simpleMessage("오른쪽으로 이동"),
        "move_to_previous": MessageLookupByLibrary.simpleMessage("왼쪽으로 이동"),
        "multi_select": MessageLookupByLibrary.simpleMessage("다중 선택"),
        "multi_view": MessageLookupByLibrary.simpleMessage("다양한 뷰"),
        "multi_view_desc": MessageLookupByLibrary.simpleMessage(
            "사분면, 분류, 목록, 그룹, 타임라인, 일정, 간트 차트, 달력 등 다양한 뷰로 여러분의 모든 요구를 충족시킬 수 있습니다"),
        "music": MessageLookupByLibrary.simpleMessage("음악"),
        "my": m76,
        "my_answer": MessageLookupByLibrary.simpleMessage("나의"),
        "my_money_per_hour": MessageLookupByLibrary.simpleMessage("내 시간당 수입"),
        "my_ranking": m77,
        "my_ranking_this_time": m78,
        "n_days_overdue": m79,
        "name": MessageLookupByLibrary.simpleMessage("이름"),
        "need_notification_permission_content":
            MessageLookupByLibrary.simpleMessage("이 기능을 사용하려면 알림 권한이 필요합니다"),
        "need_update_username":
            MessageLookupByLibrary.simpleMessage("사용자 이름 설정 필요"),
        "network_error": MessageLookupByLibrary.simpleMessage(
            "네트워크 오류 (여러 번 시도가 실패하면 다시 로그인해 주세요)"),
        "new_card": MessageLookupByLibrary.simpleMessage("새 카드"),
        "newline": m80,
        "nextMission": MessageLookupByLibrary.simpleMessage("다음 임무:"),
        "nextStep": MessageLookupByLibrary.simpleMessage("다음 단계"),
        "nextWeek": MessageLookupByLibrary.simpleMessage("다음 주"),
        "next_match": MessageLookupByLibrary.simpleMessage("다음 일치"),
        "next_page": MessageLookupByLibrary.simpleMessage("다음 페이지"),
        "next_time": MessageLookupByLibrary.simpleMessage("다음에"),
        "no": MessageLookupByLibrary.simpleMessage("아니오"),
        "no_auth": MessageLookupByLibrary.simpleMessage("권한이 없습니다"),
        "no_data": MessageLookupByLibrary.simpleMessage("데이터 없음"),
        "no_delayed_task": MessageLookupByLibrary.simpleMessage("지연된 작업 없음"),
        "no_microphone_permission": MessageLookupByLibrary.simpleMessage(
            "마이크 권한이 없습니다, 설정 페이지에서 먼저 열어주세요"),
        "no_mission_desc":
            MessageLookupByLibrary.simpleMessage("작업이 없습니다, 먼저 작업을 생성해야 합니다"),
        "no_notification_permission_title":
            MessageLookupByLibrary.simpleMessage("알림 권한이 없습니다"),
        "no_project_parenthese":
            MessageLookupByLibrary.simpleMessage("(프로젝트 없음)"),
        "no_ranking": MessageLookupByLibrary.simpleMessage("순위 없음"),
        "no_result": MessageLookupByLibrary.simpleMessage("결과 없음"),
        "no_task": MessageLookupByLibrary.simpleMessage("작업 없음"),
        "no_time_limit": MessageLookupByLibrary.simpleMessage("시간 제한 없음"),
        "no_tomotoes_finished":
            MessageLookupByLibrary.simpleMessage("완료된 작업 수(토마토 수)"),
        "none": MessageLookupByLibrary.simpleMessage("없음"),
        "normal": MessageLookupByLibrary.simpleMessage("정상"),
        "normal_solution": MessageLookupByLibrary.simpleMessage("정상 해결"),
        "not_completed": MessageLookupByLibrary.simpleMessage("미완료"),
        "not_handling": MessageLookupByLibrary.simpleMessage("임시 처리 안함"),
        "not_remind_again": MessageLookupByLibrary.simpleMessage("다시 알리지 않기"),
        "not_started": MessageLookupByLibrary.simpleMessage("시작되지 않음"),
        "note": MessageLookupByLibrary.simpleMessage("노트...(선택 사항)"),
        "note2": MessageLookupByLibrary.simpleMessage("메모"),
        "note_1": MessageLookupByLibrary.simpleMessage("메모1"),
        "note_2": MessageLookupByLibrary.simpleMessage("메모2"),
        "note_3": MessageLookupByLibrary.simpleMessage("메모3"),
        "note_4": MessageLookupByLibrary.simpleMessage("메모4"),
        "note_5": MessageLookupByLibrary.simpleMessage("메모5"),
        "note_6": MessageLookupByLibrary.simpleMessage("메모6"),
        "note_7": MessageLookupByLibrary.simpleMessage("메모7"),
        "note_and_multimission":
            MessageLookupByLibrary.simpleMessage("노트와 멀티미션"),
        "note_diary": MessageLookupByLibrary.simpleMessage("음성 메모"),
        "note_n": MessageLookupByLibrary.simpleMessage("메모"),
        "note_plain": MessageLookupByLibrary.simpleMessage("노트"),
        "note_prompt": MessageLookupByLibrary.simpleMessage(
            "{createdAt: null, updatedAt: null, indexSearchingStart: null, state: 0, indexSearchingEnd: null, background_url: null, title: 1.오른쪽 상단을 클릭하여 바탕화면 위젯으로 설정 2. 안드로이드, 아이폰, 맥에서 바탕화면 위젯을 설정할 수 있습니다, folder_id: null, flomo_object_id: null, type: 1, masterScore: 1.0, update_time: 1699019619215, causeAnalysis: [], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 0, wqbWrongQuestionContent: , wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 0, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: , wqbAnswerRichContentUrl: , content: 1.오른쪽 상단을 클릭하여 바탕화면 위젯으로 설정\n2. 안드로이드, 아이폰, 맥에서 바탕화면 위젯을 설정할 수 있습니다\n1111, device_id: B5CC32ED-595A-54B7-A814-7BC911FBD2D4, tagNames: [], tagIds: null, isFinished: null, color: 4291946748, order_index: 4, status: null, priorityStatus: null, uid: 0aa14757-7695-4e52-9b23-45f839a16715}"),
        "note_short": MessageLookupByLibrary.simpleMessage("노트"),
        "notification0":
            MessageLookupByLibrary.simpleMessage("시간이 다 되었습니다, 내일 계획을 세워보세요"),
        "notification1": MessageLookupByLibrary.simpleMessage(
            "우리는 당신이 \'시간 관리국 ToDo\'를 몇 일 동안 사용하지 않았음을 알았습니다. 계획을 포기하지 마세요, 지금 바로 사용해 보세요!"),
        "notification10": MessageLookupByLibrary.simpleMessage(
            "당신이 원한다면, 반드시 할 수 있습니다. \'시간 관리국 ToDo\'를 사용하여 계획을 실현하세요."),
        "notification11": MessageLookupByLibrary.simpleMessage(
            "생명은 멈추지 않고, 투쟁은 계속됩니다. \'시간 관리국 ToDo\'를 열어서 계획을 실현하세요."),
        "notification12": MessageLookupByLibrary.simpleMessage(
            "자신의 소망을 따라 계속 전진하세요. \'시간 관리국 ToDo\'를 사용하여 더 자신감을 가지게 하세요."),
        "notification13": MessageLookupByLibrary.simpleMessage(
            "당신이 상상할 수 있다면, 그것을 실현할 수 있습니다. \'시간 관리국 ToDo\'를 사용하여 계획을 실현하세요."),
        "notification14": MessageLookupByLibrary.simpleMessage(
            "꿈은 멀지 않습니다, 당신이 용감하게 전진하기만 한다면. \'시간 관리국 ToDo\'를 열어서 계획을 실현하세요."),
        "notification15": MessageLookupByLibrary.simpleMessage(
            "성공은 용기와 결단력이 필요합니다. \'시간 관리국 ToDo\'를 사용하여 더 용기를 가지게 하세요."),
        "notification16": MessageLookupByLibrary.simpleMessage(
            "성공은 각각의 작은 단계를 통해 이루어집니다. \'시간 관리국 ToDo\'를 사용하여 더 효율적으로 만드세요."),
        "notification17": MessageLookupByLibrary.simpleMessage(
            "변화는 행동에서 시작됩니다. \'시간 관리국 ToDo\'를 열어서 계획을 실현하세요."),
        "notification18": MessageLookupByLibrary.simpleMessage(
            "매일이 새로운 시작입니다. \'시간 관리국 ToDo\'를 사용하여 더 활기를 가지게 하세요."),
        "notification19": MessageLookupByLibrary.simpleMessage(
            "성공은 우연이 아니라, 노력과 지속성을 통해 이루어집니다. \'시간 관리국 ToDo\'를 열어서 계획을 실현하세요."),
        "notification2": MessageLookupByLibrary.simpleMessage(
            "매일 목표를 가져야 합니다, 오늘의 목표를 잊지 마세요. \'시간 관리국 ToDo\'를 열어서 계획을 실현하세요."),
        "notification20": MessageLookupByLibrary.simpleMessage(
            "오늘 노력하지 않으면, 내일이 아무리 분발해도 소용없습니다. \'시간 관리국 ToDo\'를 사용하여 더 열심히 하세요."),
        "notification3": MessageLookupByLibrary.simpleMessage(
            "지속성이 성공의 열쇠입니다. 목표를 달성하기 위해 \'시간 관리국 ToDo\'를 열어보세요."),
        "notification4": MessageLookupByLibrary.simpleMessage(
            "당신은 강한 의지를 가진 사람입니다, 게으름이 당신을 이기게 하지 마세요. \'시간 관리국 ToDo\'를 사용하여 계획을 실현하세요."),
        "notification5": MessageLookupByLibrary.simpleMessage(
            "좋은 계획은 성공의 반입니다. 아직 계획을 실행하지 않았다면, \'시간 관리국 ToDo\'를 빨리 열어보세요."),
        "notification6": MessageLookupByLibrary.simpleMessage(
            "휴대폰을 내려두고 계획에 집중하세요. \'시간 관리국 ToDo\'를 열어서 더 집중하게 해보세요."),
        "notification7": MessageLookupByLibrary.simpleMessage(
            "당신의 목표에 점점 가까워지고 있습니다, 자신을 물러서게 하지 마세요. \'시간 관리국 ToDo\'를 사용하여 계획을 실현하세요."),
        "notification8": MessageLookupByLibrary.simpleMessage(
            "진보를 추구하고, 오늘부터 시작하세요. \'시간 관리국 ToDo\'를 열어서 계획을 실현하세요."),
        "notification9": MessageLookupByLibrary.simpleMessage(
            "시간은 소중합니다, 모든 분을 소중히 하세요. \'시간 관리국 ToDo\'를 사용하여 시간을 더 가치있게 만드세요."),
        "notificationTxt": m81,
        "notification_more":
            MessageLookupByLibrary.simpleMessage("내일의 작업 내용을 맞춤 설정해 보세요"),
        "notification_num_mission_to_finish": m82,
        "notification_num_mission_to_finish_delay": m83,
        "notification_setting": MessageLookupByLibrary.simpleMessage("푸시 설정"),
        "notification_setting_content": MessageLookupByLibrary.simpleMessage(
            "푸시를 활성화하면 작업의 완료 또는 시작 상태를 알 수 있습니다"),
        "notification_title":
            MessageLookupByLibrary.simpleMessage("당신의 시간 관리자가 알립니다"),
        "nov": MessageLookupByLibrary.simpleMessage("11월"),
        "novFull": MessageLookupByLibrary.simpleMessage("11월"),
        "now": MessageLookupByLibrary.simpleMessage("지금"),
        "num_days": m84,
        "num_lives": MessageLookupByLibrary.simpleMessage("생명 값:"),
        "num_mins": m85,
        "num_mission": MessageLookupByLibrary.simpleMessage("임무 수"),
        "num_mission_percent": m86,
        "num_mission_total": m87,
        "num_of_total": m88,
        "num_tasks": m89,
        "num_tasks_finished": MessageLookupByLibrary.simpleMessage("완료된 계획 수"),
        "num_times": m90,
        "num_tomatoes": m91,
        "num_unit": m92,
        "number_present": m93,
        "numberedList": MessageLookupByLibrary.simpleMessage(""),
        "objective": MessageLookupByLibrary.simpleMessage("목표"),
        "oct": MessageLookupByLibrary.simpleMessage("10월"),
        "octFull": MessageLookupByLibrary.simpleMessage("10월"),
        "off": MessageLookupByLibrary.simpleMessage("끄기"),
        "offer_next_version": MessageLookupByLibrary.simpleMessage("다음 버전 제공"),
        "offline": MessageLookupByLibrary.simpleMessage("오프라인"),
        "on": MessageLookupByLibrary.simpleMessage("켜기"),
        "one_hour": MessageLookupByLibrary.simpleMessage("1시간"),
        "one_key_login": MessageLookupByLibrary.simpleMessage("원 키 로그인"),
        "one_month": MessageLookupByLibrary.simpleMessage("한 달"),
        "one_year": MessageLookupByLibrary.simpleMessage("일년"),
        "ongoing": MessageLookupByLibrary.simpleMessage("진행 중"),
        "online": MessageLookupByLibrary.simpleMessage("온라인"),
        "only_me": MessageLookupByLibrary.simpleMessage("나만"),
        "only_share_with_friends":
            MessageLookupByLibrary.simpleMessage("친구에게만 공유"),
        "open_sticky_note": MessageLookupByLibrary.simpleMessage("메모 열기"),
        "optional": MessageLookupByLibrary.simpleMessage("선택 사항"),
        "optional_with_parenthese":
            MessageLookupByLibrary.simpleMessage("(선택 사항)"),
        "order_by_created_time":
            MessageLookupByLibrary.simpleMessage("생성 시간별 정렬"),
        "order_by_end_time": MessageLookupByLibrary.simpleMessage("완료 시간별 정렬"),
        "order_by_list": MessageLookupByLibrary.simpleMessage("목록별 정렬"),
        "order_by_mission_priority":
            MessageLookupByLibrary.simpleMessage("작업 우선순위별 정렬"),
        "order_by_mission_tag": MessageLookupByLibrary.simpleMessage("태그별로 정렬"),
        "order_by_time": MessageLookupByLibrary.simpleMessage("시간별 정렬"),
        "order_by_update_time": MessageLookupByLibrary.simpleMessage(
            "최신 업데이트 시간 순서(작업 보고서 작성에 적합)"),
        "other_login_mode": MessageLookupByLibrary.simpleMessage("다른 방식으로 전환"),
        "others": MessageLookupByLibrary.simpleMessage("기타"),
        "overdue_buffer": MessageLookupByLibrary.simpleMessage("연체 버퍼:"),
        "password": MessageLookupByLibrary.simpleMessage("비밀번호"),
        "passwordNotEmpty":
            MessageLookupByLibrary.simpleMessage("비밀번호는 비워둘 수 없습니다"),
        "password_at_least_6":
            MessageLookupByLibrary.simpleMessage("비밀번호는 최소 6자리 이상이어야 합니다"),
        "password_correct": MessageLookupByLibrary.simpleMessage("비밀번호가 맞습니다"),
        "password_correct_desc": MessageLookupByLibrary.simpleMessage(
            "로컬 비밀번호가 정확하여 바로 작업을 생성할 수 있습니다"),
        "password_incorrect":
            MessageLookupByLibrary.simpleMessage("비밀번호가 잘못되었습니다"),
        "password_not_empty":
            MessageLookupByLibrary.simpleMessage("비밀번호를 입력해 주세요!"),
        "password_required_for_sharing":
            MessageLookupByLibrary.simpleMessage("파일 공유 시 비밀번호 필요"),
        "password_set_success":
            MessageLookupByLibrary.simpleMessage("비밀번호가 성공적으로 설정되었습니다"),
        "pause": MessageLookupByLibrary.simpleMessage("일시 중지"),
        "pc_not_available": MessageLookupByLibrary.simpleMessage(
            "MAC 또는 PC는 이 기능을 지원하지 않습니다. 휴대폰을 사용해 주세요"),
        "pdpa": MessageLookupByLibrary.simpleMessage("PDCA"),
        "pdpa_desc": MessageLookupByLibrary.simpleMessage(
            "P(계획) - 계획 기능은 세 부분을 포함합니다: 목표(goal), 계획(plan), 예산(budget).\nD(디자인) - 솔루션과 레이아웃 디자인하기.\nC(4C) - 4C 관리: 점검(Check), 소통(Communicate), 청소(Clean), 제어(Control).\nA(2A) - 행동(Act, 요약 검사의 결과 처리하기), 목표 달성(Aim, 목표 요구 사항에 따라 행동하기, 예: 개선, 증진)."),
        "pdpa_step1": MessageLookupByLibrary.simpleMessage("계획"),
        "pdpa_step2": MessageLookupByLibrary.simpleMessage("실행"),
        "pdpa_step3": MessageLookupByLibrary.simpleMessage("확인"),
        "pdpa_step4": MessageLookupByLibrary.simpleMessage("행동"),
        "permission_setting": MessageLookupByLibrary.simpleMessage("권한 설정"),
        "phoneNo": MessageLookupByLibrary.simpleMessage("휴대폰 번호"),
        "pin": MessageLookupByLibrary.simpleMessage("고정"),
        "plain_text": MessageLookupByLibrary.simpleMessage("일반 텍스트"),
        "play": MessageLookupByLibrary.simpleMessage("재생"),
        "pleaseInputTitle": MessageLookupByLibrary.simpleMessage("제목을 입력해주세요"),
        "pleaseSelectColor": MessageLookupByLibrary.simpleMessage("색상을 선택해주세요"),
        "please_confirm_your_password":
            MessageLookupByLibrary.simpleMessage("비밀번호를 확인하세요"),
        "please_create_ur_password":
            MessageLookupByLibrary.simpleMessage("비밀번호를 생성하세요"),
        "please_enter_6_digit_password":
            MessageLookupByLibrary.simpleMessage("6자리 비밀번호를 입력하세요"),
        "please_enter_ur_password":
            MessageLookupByLibrary.simpleMessage("비밀번호를 입력하세요"),
        "please_enter_your_question":
            MessageLookupByLibrary.simpleMessage("질문을 입력하세요"),
        "please_finish_msn":
            MessageLookupByLibrary.simpleMessage("문자 메시지 비밀번호 인증을 완료하세요"),
        "please_input_bill_amount":
            MessageLookupByLibrary.simpleMessage("청구서 금액을 입력하세요"),
        "please_input_content":
            MessageLookupByLibrary.simpleMessage("내용을 입력하세요"),
        "please_input_correct_email":
            MessageLookupByLibrary.simpleMessage("正しいメールアドレスを入力してください"),
        "please_input_correct_password":
            MessageLookupByLibrary.simpleMessage("올바른 비밀번호를 입력해 주세요"),
        "please_input_email":
            MessageLookupByLibrary.simpleMessage("メールアドレスを入力してください"),
        "please_input_first_gpt_sentence":
            MessageLookupByLibrary.simpleMessage("질문을 입력하세요"),
        "please_input_folder_password": m94,
        "please_input_mission_title":
            MessageLookupByLibrary.simpleMessage("미션 제목을 입력해 주세요"),
        "please_input_mobile_no":
            MessageLookupByLibrary.simpleMessage("휴대폰 번호를 먼저 입력하세요"),
        "please_input_password":
            MessageLookupByLibrary.simpleMessage("비밀번호를 먼저 입력하세요"),
        "please_input_the_mission_title":
            MessageLookupByLibrary.simpleMessage("작업 제목을 입력하세요"),
        "please_input_title": MessageLookupByLibrary.simpleMessage("제목을 입력하세요"),
        "please_input_xxx_name": m95,
        "please_input_your_username":
            MessageLookupByLibrary.simpleMessage("사용자 이름을 먼저 설정해 주세요"),
        "please_origin_password":
            MessageLookupByLibrary.simpleMessage("원래 비밀번호를 입력하세요"),
        "please_seaarch_on_app_store": m96,
        "please_select_at_least_one_option_in_repeat_cycle":
            MessageLookupByLibrary.simpleMessage("반복 주기에서 최소한 하나의 옵션을 선택하십시오"),
        "please_select_attachment":
            MessageLookupByLibrary.simpleMessage("첨부 파일을 선택하세요"),
        "please_select_content": m97,
        "please_select_daily_start_time":
            MessageLookupByLibrary.simpleMessage("먼저 시작 시간을 선택해 주세요"),
        "please_select_date":
            MessageLookupByLibrary.simpleMessage("검색할 날짜를 선택하세요"),
        "please_select_daterange":
            MessageLookupByLibrary.simpleMessage("검색할 날짜 범위를 선택하세요"),
        "please_select_month":
            MessageLookupByLibrary.simpleMessage("검색할 월을 선택하세요"),
        "please_select_year_to_search":
            MessageLookupByLibrary.simpleMessage("검색할 연도를 선택하세요"),
        "popup_invisible3": MessageLookupByLibrary.simpleMessage("숨기기"),
        "popup_select1": MessageLookupByLibrary.simpleMessage("내용 보이기"),
        "popup_visible2": MessageLookupByLibrary.simpleMessage("보이기"),
        "postpone": MessageLookupByLibrary.simpleMessage("오늘로 연기"),
        "practice": MessageLookupByLibrary.simpleMessage("연습"),
        "present_value_dialog": m98,
        "preview": MessageLookupByLibrary.simpleMessage("미리보기"),
        "previewTime": MessageLookupByLibrary.simpleMessage("예상 시간"),
        "previewTomatoesNum": MessageLookupByLibrary.simpleMessage("예상 토마토 수"),
        "previous_match": MessageLookupByLibrary.simpleMessage("이전 일치"),
        "previous_page": MessageLookupByLibrary.simpleMessage("이전 페이지"),
        "print": MessageLookupByLibrary.simpleMessage("인쇄"),
        "priority": MessageLookupByLibrary.simpleMessage("우선 순위"),
        "priority1": MessageLookupByLibrary.simpleMessage("긴급 & 중요"),
        "priority2": MessageLookupByLibrary.simpleMessage("긴급하지 않음 & 중요"),
        "priority3": MessageLookupByLibrary.simpleMessage("긴급 & 중요하지 않음"),
        "priority4": MessageLookupByLibrary.simpleMessage("긴급하지 않음 & 중요하지 않음"),
        "priorityStatus": MessageLookupByLibrary.simpleMessage("우선 순위:"),
        "priority_distribution_of_completion_plan":
            MessageLookupByLibrary.simpleMessage("완료된 계획의 우선 순위 분포"),
        "priority_distribution_of_uncompletion_plan":
            MessageLookupByLibrary.simpleMessage("미완료 계획의 우선 순위 분포"),
        "privacy": MessageLookupByLibrary.simpleMessage("개인정보 보호"),
        "privacy_management": MessageLookupByLibrary.simpleMessage("개인정보 관리"),
        "privacy_pattern": MessageLookupByLibrary.simpleMessage("개인정보 보호 정책"),
        "privacy_protocol_content": MessageLookupByLibrary.simpleMessage(
            "본 제품을 신뢰하고 사용해 주셔서 감사합니다. 우리는 귀하의 개인정보 보호와 개인정보 보호를 매우 중요시하며,\n\n《개인정보 보호 정책》의 모든 조항을 주의 깊게 읽어주시기 바랍니다. 우리가 귀하의 정보를 보호하기 위해 취하는\n구체적인 조치와 약속을 이해하고, 모든 조항에 동의하신 후에만 우리의 서비스를 사용하십시오.\n우리는 계정 등록 등의 비즈니스 시나리오에서 수집합니다. 귀하가 본 제품을 점차 사용하면서, 귀하는 위치 정보, 카메라 권한 등과 같은 다양한 비즈니스 시나리오에 따라 해당 장치 권한을 활성화해야 합니다"),
        "privacy_protocol_content2": MessageLookupByLibrary.simpleMessage(
            "우리는 귀하의 개인정보 보호와 개인정보 보호를 매우 중요시하며, 선진적인 보안 보호 조치를 취하여 귀하의 정보를 보호합니다. 귀하가 우리의 서비스를 계속 사용하는 것은 귀하가 《개인정보 보호 정책》에 따라 귀하의 개인정보를 수집, 사용 및 보호하는 것에 동의하는 것을 의미합니다. 만약 귀하가 위의 내용에 동의하지 않는다면, 사용을 중단할 수 있습니다."),
        "privacy_protocol_title":
            MessageLookupByLibrary.simpleMessage("개인정보 보호 정책"),
        "private": MessageLookupByLibrary.simpleMessage("비공개"),
        "projectStatistic": MessageLookupByLibrary.simpleMessage("프로젝트 통계"),
        "public_course": MessageLookupByLibrary.simpleMessage("공개 훈련 계획"),
        "publish": MessageLookupByLibrary.simpleMessage("게시"),
        "pure_mode": MessageLookupByLibrary.simpleMessage("순수 모드"),
        "push_counter_status_notification": m99,
        "qq_friends": MessageLookupByLibrary.simpleMessage("QQ 친구"),
        "qq_share": MessageLookupByLibrary.simpleMessage("QQ 공유"),
        "question_mistake": MessageLookupByLibrary.simpleMessage("질문/오류"),
        "question_wrong_question":
            MessageLookupByLibrary.simpleMessage("질문/잘못된 질문"),
        "quote": MessageLookupByLibrary.simpleMessage(""),
        "random_by_alphabet": MessageLookupByLibrary.simpleMessage("알파벳 도전"),
        "random_by_alphabetAndNumber":
            MessageLookupByLibrary.simpleMessage("알파벳과 숫자 도전"),
        "random_by_alphabetAndNumber_lowercase_capital":
            MessageLookupByLibrary.simpleMessage("알파벳(대소문자 구분 없음)과 숫자 도전"),
        "random_by_alphabet_lowercase_capital":
            MessageLookupByLibrary.simpleMessage("알파벳 도전(대소문자 구분 없음)"),
        "random_by_number": MessageLookupByLibrary.simpleMessage("숫자 도전"),
        "ranking": MessageLookupByLibrary.simpleMessage("순위"),
        "rating_guide":
            MessageLookupByLibrary.simpleMessage("만족하시면 5성급의 좋은 평가를 부탁드립니다.^^"),
        "ready_to_download": MessageLookupByLibrary.simpleMessage("다운로드 준비 중"),
        "readying": MessageLookupByLibrary.simpleMessage("준비 중"),
        "recommended_Target": MessageLookupByLibrary.simpleMessage("추천 목표"),
        "record": MessageLookupByLibrary.simpleMessage("녹음"),
        "refuse": MessageLookupByLibrary.simpleMessage("거부"),
        "register": MessageLookupByLibrary.simpleMessage("등록"),
        "registerStep1": MessageLookupByLibrary.simpleMessage(
            "휴대폰 번호를 입력하여 등록을 완료하면, 효율적인 생활을 즐길 수 있습니다"),
        "registerStep2": MessageLookupByLibrary.simpleMessage(
            "휴대폰 번호를 입력하여 등록을 완료하면, 효율적인 생활을 즐길 수 있습니다"),
        "relaxing": MessageLookupByLibrary.simpleMessage("휴식 중"),
        "remarks_optional": MessageLookupByLibrary.simpleMessage("비고(선택 사항)"),
        "remind": MessageLookupByLibrary.simpleMessage("알림"),
        "reminder": MessageLookupByLibrary.simpleMessage("리마인더"),
        "remove_user": MessageLookupByLibrary.simpleMessage("사용자 제거"),
        "rename": MessageLookupByLibrary.simpleMessage("이름 바꾸기"),
        "repaid": MessageLookupByLibrary.simpleMessage("상환 완료"),
        "repayment_channel": MessageLookupByLibrary.simpleMessage("상환 채널"),
        "repayment_day": MessageLookupByLibrary.simpleMessage("상환일"),
        "repayment_instantly": MessageLookupByLibrary.simpleMessage("즉시 상환"),
        "repayment_record": MessageLookupByLibrary.simpleMessage("상환 기록"),
        "repeat": MessageLookupByLibrary.simpleMessage("반복"),
        "repeat_period": MessageLookupByLibrary.simpleMessage("반복 주기"),
        "repeative1": MessageLookupByLibrary.simpleMessage("일별"),
        "repeative2": MessageLookupByLibrary.simpleMessage("주별"),
        "repeative3": MessageLookupByLibrary.simpleMessage("에빙하우스"),
        "repeative_content": m100,
        "repetive": MessageLookupByLibrary.simpleMessage("반복"),
        "repetiveType": MessageLookupByLibrary.simpleMessage("반복 여부"),
        "repetiveValue": MessageLookupByLibrary.simpleMessage("반복 날짜"),
        "repetiveWeekDay": MessageLookupByLibrary.simpleMessage("반복 요일"),
        "replace": MessageLookupByLibrary.simpleMessage("교체"),
        "replace_all": MessageLookupByLibrary.simpleMessage("모두 교체"),
        "reply": MessageLookupByLibrary.simpleMessage("답장"),
        "report2": MessageLookupByLibrary.simpleMessage("신고"),
        "request_error_try_again":
            MessageLookupByLibrary.simpleMessage("요청 오류, 다시 시도해주세요"),
        "request_fail": MessageLookupByLibrary.simpleMessage("요청 실패"),
        "request_permission": MessageLookupByLibrary.simpleMessage("권한 요청"),
        "requesting_please_wait":
            MessageLookupByLibrary.simpleMessage("요청 중이니 잠시만 기다려주세요"),
        "reset_password_has_been_sent": MessageLookupByLibrary.simpleMessage(
            "パスワードリセットのメールがあなたのメールアドレスに送信されました"),
        "reset_pwd": MessageLookupByLibrary.simpleMessage("비밀번호 재설정"),
        "reset_pwd_successful":
            MessageLookupByLibrary.simpleMessage("비밀번호 재설정 성공"),
        "reset_to_login_page":
            MessageLookupByLibrary.simpleMessage("パスワードが正常に設定されました。ログインへ"),
        "rest": MessageLookupByLibrary.simpleMessage("휴식"),
        "restPausing": MessageLookupByLibrary.simpleMessage("휴식 일시 중지 중"),
        "rest_completed_auto_start_play":
            MessageLookupByLibrary.simpleMessage("휴식 완료 후 자동으로 재생 시작"),
        "rest_duration": MessageLookupByLibrary.simpleMessage("휴식 시간"),
        "rest_focus_duration_with_value": m101,
        "rest_focus_numbers_with_value": m102,
        "resting": MessageLookupByLibrary.simpleMessage("휴식 중"),
        "restingFinished": MessageLookupByLibrary.simpleMessage("휴식 완료"),
        "resting_music": MessageLookupByLibrary.simpleMessage("휴식 중 음악"),
        "resting_stopping_ringtone":
            MessageLookupByLibrary.simpleMessage("휴식 완료 벨소리"),
        "resume": MessageLookupByLibrary.simpleMessage("계속"),
        "retry": MessageLookupByLibrary.simpleMessage("재시도"),
        "rich_text": MessageLookupByLibrary.simpleMessage("리치 텍스트"),
        "rmb": MessageLookupByLibrary.simpleMessage("코인"),
        "role_chatgpt_msg": m103,
        "role_message_placehodler": MessageLookupByLibrary.simpleMessage(
            "작업 계획을 입력하세요(시간, 작업 내용 등을 명확하게 설명해주세요)"),
        "role_prompts_chatgpt_msg": MessageLookupByLibrary.simpleMessage(
            "나는 당신이 지능형 입력 방법을 연기하고, 프롬프트에 따라 사용자가 입력할 수 있는 단어 그룹 배열 List<String>을 반환하도록 하고 싶습니다. 배열은 최대 20개이며, 사용자가 입력한 단어를 반드시 포함해야 합니다(참고: 역사를 전체적으로 논의하지 않습니다)."),
        "role_time_manager": MessageLookupByLibrary.simpleMessage("플래너"),
        "rules_for_ai": MessageLookupByLibrary.simpleMessage("AI 규칙"),
        "rusty": MessageLookupByLibrary.simpleMessage("녹슨"),
        "sales": MessageLookupByLibrary.simpleMessage("판매"),
        "sales_amount": MessageLookupByLibrary.simpleMessage("판매 금액"),
        "same_treatment": MessageLookupByLibrary.simpleMessage("동일한 처리"),
        "saturday": MessageLookupByLibrary.simpleMessage("토요일"),
        "saturdayShort": MessageLookupByLibrary.simpleMessage("토"),
        "save": MessageLookupByLibrary.simpleMessage("저장"),
        "save_as_template": MessageLookupByLibrary.simpleMessage("템플릿으로 저장"),
        "save_fail": MessageLookupByLibrary.simpleMessage("저장 실패"),
        "save_failure": MessageLookupByLibrary.simpleMessage("저장 실패"),
        "save_success": MessageLookupByLibrary.simpleMessage("저장 성공"),
        "saving": MessageLookupByLibrary.simpleMessage("저장 중"),
        "schedule": MessageLookupByLibrary.simpleMessage("일정"),
        "screen_rorate": MessageLookupByLibrary.simpleMessage("화면 회전"),
        "search": MessageLookupByLibrary.simpleMessage("검색"),
        "search_chart_by_gpt": MessageLookupByLibrary.simpleMessage("차트"),
        "search_chart_listing_title_content":
            MessageLookupByLibrary.simpleMessage("차트 목록을 보여줘\n목록:\n시간:"),
        "search_chart_listingtitle":
            MessageLookupByLibrary.simpleMessage("목록 차트를 보여줘"),
        "search_chart_title": MessageLookupByLibrary.simpleMessage("차트를 보여줘"),
        "search_chart_title_content":
            MessageLookupByLibrary.simpleMessage("차트를 보여줘\n시간:"),
        "search_country": MessageLookupByLibrary.simpleMessage("국가 검색"),
        "search_listing_by_gpt":
            MessageLookupByLibrary.simpleMessage("목록&임무 검색"),
        "search_listing_content":
            MessageLookupByLibrary.simpleMessage("목록 데이터를 보여줘:\n목록 제목:\n설명:"),
        "search_listing_title":
            MessageLookupByLibrary.simpleMessage("목록 데이터를 보여줘"),
        "sec": MessageLookupByLibrary.simpleMessage("초"),
        "see": MessageLookupByLibrary.simpleMessage("보기"),
        "selectMission": MessageLookupByLibrary.simpleMessage("목록 선택"),
        "selectTag": MessageLookupByLibrary.simpleMessage("태그 선택"),
        "selectThemeColor": MessageLookupByLibrary.simpleMessage("테마 색상 선택"),
        "selectThemeColorDesc": MessageLookupByLibrary.simpleMessage(
            "테마 색상을 선택하고 앱을 재시작하면 테마 색상이 변경됩니다^^"),
        "select_all": MessageLookupByLibrary.simpleMessage("전체 선택"),
        "select_avatar": MessageLookupByLibrary.simpleMessage("아바타를 선택하세요"),
        "select_contents": MessageLookupByLibrary.simpleMessage("표시 내용 선택"),
        "select_lottery": MessageLookupByLibrary.simpleMessage("추첨"),
        "select_prize": MessageLookupByLibrary.simpleMessage("보상 선택"),
        "select_repeat_option":
            MessageLookupByLibrary.simpleMessage("반복 주기에서 최소한 하나의 옵션을 선택하십시오"),
        "select_ringtone": MessageLookupByLibrary.simpleMessage("벨소리 선택"),
        "send_again": MessageLookupByLibrary.simpleMessage("다시 보내기"),
        "sep": MessageLookupByLibrary.simpleMessage("9월"),
        "sepFull": MessageLookupByLibrary.simpleMessage("9월"),
        "set_6_digit_password":
            MessageLookupByLibrary.simpleMessage("6자리 비밀번호 설정"),
        "set_password_for_group": MessageLookupByLibrary.simpleMessage(
            "그룹 비밀번호 설정. 그룹 리스트에 가입하려면 사용자가 비밀번호를 입력해야 합니다."),
        "set_to_desktop_widget":
            MessageLookupByLibrary.simpleMessage("데스크톱 위젯으로 설정"),
        "setting": MessageLookupByLibrary.simpleMessage("설정"),
        "setting_administrator":
            MessageLookupByLibrary.simpleMessage("관리자로 설정"),
        "setting_fail": MessageLookupByLibrary.simpleMessage("설정 실패"),
        "setting_success": MessageLookupByLibrary.simpleMessage("설정 성공"),
        "share": MessageLookupByLibrary.simpleMessage("공유"),
        "share_the_link": m104,
        "share_to": MessageLookupByLibrary.simpleMessage("공유"),
        "sharing_course": MessageLookupByLibrary.simpleMessage("강좌 공유"),
        "sharing_listing": MessageLookupByLibrary.simpleMessage("리스트 공유"),
        "six_hours": MessageLookupByLibrary.simpleMessage("6시간"),
        "six_months": MessageLookupByLibrary.simpleMessage("여섯 달"),
        "skilled": MessageLookupByLibrary.simpleMessage("숙련된"),
        "slide_left_right":
            MessageLookupByLibrary.simpleMessage("왼쪽 오른쪽으로 슬라이드 가능"),
        "smsVerificationCode":
            MessageLookupByLibrary.simpleMessage("SMS 인증 코드"),
        "sound_recording": MessageLookupByLibrary.simpleMessage("녹음"),
        "startFocusing": MessageLookupByLibrary.simpleMessage("집중 시작"),
        "startResting": MessageLookupByLibrary.simpleMessage("휴식 시작"),
        "start_date": MessageLookupByLibrary.simpleMessage("시작 날짜"),
        "start_focus": MessageLookupByLibrary.simpleMessage("집중 시작"),
        "start_focusing_mission_name": m105,
        "start_resting_name": m106,
        "start_time": MessageLookupByLibrary.simpleMessage("시작 시간"),
        "status_complete": MessageLookupByLibrary.simpleMessage("처리 완료"),
        "status_developping": MessageLookupByLibrary.simpleMessage("개발 중"),
        "status_handling": MessageLookupByLibrary.simpleMessage("처리 중"),
        "status_waiting": MessageLookupByLibrary.simpleMessage("대기 중"),
        "stop": MessageLookupByLibrary.simpleMessage("정지"),
        "stop_focusing_mission_name": m107,
        "stop_resting_mission_name": m108,
        "strikethrough": MessageLookupByLibrary.simpleMessage(""),
        "sub_task_add_newline":
            MessageLookupByLibrary.simpleMessage("하위 작업 - 점을 눌러 새로운 줄 추가 및 저장"),
        "submit": MessageLookupByLibrary.simpleMessage("제출"),
        "successfully_copied_to_clipboard":
            MessageLookupByLibrary.simpleMessage("클립보드에 복사 성공"),
        "summary": MessageLookupByLibrary.simpleMessage("요약"),
        "sunday": MessageLookupByLibrary.simpleMessage("일요일"),
        "sundayShort": MessageLookupByLibrary.simpleMessage("일"),
        "super_notebook": MessageLookupByLibrary.simpleMessage("슈퍼 노트북"),
        "switch_chronograph_mode_success": MessageLookupByLibrary.simpleMessage(
            "스톱워치 모드로 성공적으로 전환되었습니다. 다음에 적용됩니다"),
        "switch_font": MessageLookupByLibrary.simpleMessage("폰트 전환"),
        "switch_timer_mode_success": MessageLookupByLibrary.simpleMessage(
            "타이머 모드로 성공적으로 전환되었습니다. 다음에 적용됩니다"),
        "tag": MessageLookupByLibrary.simpleMessage("태그"),
        "tagNames": MessageLookupByLibrary.simpleMessage("태그 이름"),
        "target_details": MessageLookupByLibrary.simpleMessage("목표 세부사항"),
        "target_duration_period":
            MessageLookupByLibrary.simpleMessage("목표 지속 기간"),
        "target_reward": MessageLookupByLibrary.simpleMessage("목표 보상"),
        "target_time": MessageLookupByLibrary.simpleMessage("목표 시간"),
        "task": MessageLookupByLibrary.simpleMessage("작업"),
        "task_activity": MessageLookupByLibrary.simpleMessage("작업 활동"),
        "tasks_list": MessageLookupByLibrary.simpleMessage("작업 목록"),
        "text": MessageLookupByLibrary.simpleMessage(""),
        "theme": MessageLookupByLibrary.simpleMessage("테마"),
        "thirty_mins": MessageLookupByLibrary.simpleMessage("30분"),
        "thisWeek": MessageLookupByLibrary.simpleMessage("이번 주"),
        "this_mission_is_cycle_mission":
            MessageLookupByLibrary.simpleMessage("이 작업은 순환 작업입니다"),
        "this_month_plan": MessageLookupByLibrary.simpleMessage("이번 달 계획"),
        "thisweek": MessageLookupByLibrary.simpleMessage("이번 주"),
        "three_hours": MessageLookupByLibrary.simpleMessage("3시간"),
        "three_months": MessageLookupByLibrary.simpleMessage("세 달"),
        "thursday": MessageLookupByLibrary.simpleMessage("목요일"),
        "thursdayShort": MessageLookupByLibrary.simpleMessage("목"),
        "time": MessageLookupByLibrary.simpleMessage("시간"),
        "time_ago": m109,
        "time_finished": MessageLookupByLibrary.simpleMessage("집중 시간"),
        "time_later": m110,
        "time_management": MessageLookupByLibrary.simpleMessage("시간 관리"),
        "time_not_arrive_cannot_clcokin":
            MessageLookupByLibrary.simpleMessage("시간이 아직 안 왔으니 출근할 수 없습니다"),
        "time_segment": MessageLookupByLibrary.simpleMessage("시간 구간"),
        "timefocused": MessageLookupByLibrary.simpleMessage("집중한 시간"),
        "timeline": MessageLookupByLibrary.simpleMessage("타임라인"),
        "timelineview": MessageLookupByLibrary.simpleMessage("타임라인 뷰"),
        "timer": MessageLookupByLibrary.simpleMessage("타이머"),
        "times": MessageLookupByLibrary.simpleMessage("번"),
        "tipsAlertTone": MessageLookupByLibrary.simpleMessage("알림 벨소리"),
        "title": MessageLookupByLibrary.simpleMessage("제목"),
        "title_consume": MessageLookupByLibrary.simpleMessage("소비 금액"),
        "title_data": m111,
        "to_login": MessageLookupByLibrary.simpleMessage("ログインページへ"),
        "today": MessageLookupByLibrary.simpleMessage("오늘"),
        "today_data": MessageLookupByLibrary.simpleMessage("오늘의 데이터"),
        "today_duration_completed":
            MessageLookupByLibrary.simpleMessage("오늘의 총 집중 시간(분)"),
        "today_focus_duration":
            MessageLookupByLibrary.simpleMessage("오늘의 집중 시간"),
        "today_focus_record": MessageLookupByLibrary.simpleMessage("오늘의 집중 기록"),
        "today_mission_completed":
            MessageLookupByLibrary.simpleMessage("오늘 완료된 작업 수"),
        "today_tomatoes_completed":
            MessageLookupByLibrary.simpleMessage("오늘 완료된 토마토 수"),
        "todo_list": MessageLookupByLibrary.simpleMessage("할 일 목록"),
        "todo_list_desc":
            MessageLookupByLibrary.simpleMessage("명확하고 간결하며, 항상 상기시켜 줍니다"),
        "todo_listing": MessageLookupByLibrary.simpleMessage("할 일 목록"),
        "tokenExpired":
            MessageLookupByLibrary.simpleMessage("로그인이 만료되었습니다. 다시 로그인 해주세요"),
        "tomato": MessageLookupByLibrary.simpleMessage("토마토"),
        "tomatoClock": MessageLookupByLibrary.simpleMessage("토마토 시계"),
        "tomatoClockSetting": MessageLookupByLibrary.simpleMessage("토마토 시계 설정"),
        "tomatoNums": MessageLookupByLibrary.simpleMessage("집중 횟수"),
        "tomatoNums2": MessageLookupByLibrary.simpleMessage("집중 횟수"),
        "tomatoNums3": MessageLookupByLibrary.simpleMessage("(토마토 수)"),
        "tomato_duration":
            MessageLookupByLibrary.simpleMessage("각 토마토에 대한 집중 시간"),
        "tomatoesDuration": MessageLookupByLibrary.simpleMessage("토마토 시간"),
        "tomorrow": MessageLookupByLibrary.simpleMessage("내일"),
        "totalTime": MessageLookupByLibrary.simpleMessage("총 집중 시간"),
        "totalTimeMinute": MessageLookupByLibrary.simpleMessage("총 시간(분)"),
        "total_focus_duration": MessageLookupByLibrary.simpleMessage("총 집중 시간"),
        "total_focus_time": MessageLookupByLibrary.simpleMessage("집중 시간"),
        "total_maju": m112,
        "total_tasks_count":
            MessageLookupByLibrary.simpleMessage("전체 작업 수(토마토 수)"),
        "total_tomatoes": m113,
        "total_tomotoes": MessageLookupByLibrary.simpleMessage("토마토 총 수"),
        "trainee_advice_notice": m114,
        "trainee_give_your_advice": m115,
        "training_plan_edit": MessageLookupByLibrary.simpleMessage("클릭하여 편집"),
        "transaction": MessageLookupByLibrary.simpleMessage("금융 거래"),
        "try_again":
            MessageLookupByLibrary.simpleMessage("요청 시간 초과 또는 실패, 다시 시도해 주세요"),
        "tuesday": MessageLookupByLibrary.simpleMessage("화요일"),
        "tuesdayShort": MessageLookupByLibrary.simpleMessage("화"),
        "twelve_12hours": MessageLookupByLibrary.simpleMessage("12시간"),
        "twenty_one_days": MessageLookupByLibrary.simpleMessage("21일"),
        "type": MessageLookupByLibrary.simpleMessage("작성"),
        "type_something": MessageLookupByLibrary.simpleMessage("무언가를 입력하세요..."),
        "unarchive": MessageLookupByLibrary.simpleMessage("보관 해제"),
        "uncomplete_plan_classification":
            MessageLookupByLibrary.simpleMessage("미완료 계획 분류"),
        "underline": MessageLookupByLibrary.simpleMessage(""),
        "unfinished": MessageLookupByLibrary.simpleMessage("미완료"),
        "unit": MessageLookupByLibrary.simpleMessage("단위"),
        "unitMissions": MessageLookupByLibrary.simpleMessage("개의 임무"),
        "unitTomatoes": MessageLookupByLibrary.simpleMessage("개의 토마토"),
        "unname_user": MessageLookupByLibrary.simpleMessage("(이름 없는 사용자)"),
        "unorder_folderlist":
            MessageLookupByLibrary.simpleMessage("분류되지 않은 목록"),
        "unorder_group": MessageLookupByLibrary.simpleMessage("미정렬 그룹"),
        "unorder_group_not_order_toast":
            MessageLookupByLibrary.simpleMessage("미정렬 그룹은 정렬할 수 없습니다"),
        "unregister": MessageLookupByLibrary.simpleMessage("탈퇴"),
        "unregister_account": MessageLookupByLibrary.simpleMessage("계정 탈퇴"),
        "unregister_content": MessageLookupByLibrary.simpleMessage(
            "모든 계정 정보를 삭제합니다\n관련된 모든 목록, 작업 데이터\n쿠폰은 삭제되며 복구할 수 없습니다\n탈퇴 후 다시 등록해도 이전 데이터는 복구되지 않습니다"),
        "unregister_success": MessageLookupByLibrary.simpleMessage("등록 해제 성공"),
        "unregister_temp":
            MessageLookupByLibrary.simpleMessage("일시적으로 탈퇴하지 않음"),
        "unregister_title":
            MessageLookupByLibrary.simpleMessage("탈퇴 후 다음 정보가 영향을 받습니다"),
        "unselected": MessageLookupByLibrary.simpleMessage("미선택"),
        "unset": MessageLookupByLibrary.simpleMessage("설정되지 않음"),
        "update": MessageLookupByLibrary.simpleMessage("업데이트"),
        "updateSuccess": MessageLookupByLibrary.simpleMessage("업데이트 성공"),
        "update_bill": MessageLookupByLibrary.simpleMessage("청구서 업데이트"),
        "update_credit_card_bill":
            MessageLookupByLibrary.simpleMessage("신용카드 청구서 업데이트"),
        "update_last_time": m116,
        "update_name_mission": m117,
        "update_name_mission2": m118,
        "update_now": MessageLookupByLibrary.simpleMessage("지금 업데이트"),
        "update_success": MessageLookupByLibrary.simpleMessage("업데이트 성공"),
        "update_time_last_time":
            MessageLookupByLibrary.simpleMessage("최신 업데이트 시간"),
        "upload_attachment": MessageLookupByLibrary.simpleMessage("첨부 파일 업로드"),
        "upload_error": MessageLookupByLibrary.simpleMessage("업로드 실패"),
        "upload_success": MessageLookupByLibrary.simpleMessage("업로드 성공"),
        "uploading_pic": MessageLookupByLibrary.simpleMessage("사진 업로드 중"),
        "url_attachment": MessageLookupByLibrary.simpleMessage("URL 첨부 파일"),
        "user_exist_reset_password":
            MessageLookupByLibrary.simpleMessage("ユーザーが存在します。パスワードをリセットできます"),
        "user_privacy_protocol_title":
            MessageLookupByLibrary.simpleMessage("사용자 개인정보 보호 정책"),
        "username": MessageLookupByLibrary.simpleMessage("사용자 이름"),
        "value": m119,
        "value_per_hour": m120,
        "version_num": m121,
        "vertical": MessageLookupByLibrary.simpleMessage("세로"),
        "view": MessageLookupByLibrary.simpleMessage("보기"),
        "view_only": MessageLookupByLibrary.simpleMessage("보기만 가능"),
        "visible": MessageLookupByLibrary.simpleMessage("보이기"),
        "voice": MessageLookupByLibrary.simpleMessage("음성"),
        "voice_diary": MessageLookupByLibrary.simpleMessage("음성 일기"),
        "voice_guide": MessageLookupByLibrary.simpleMessage(
            "휴대폰에 내장된 음성 입력 방식을 사용하여 입력하십시오"),
        "volume": MessageLookupByLibrary.simpleMessage("볼륨"),
        "waitingToStart": MessageLookupByLibrary.simpleMessage("시작 대기 중"),
        "web_desc": MessageLookupByLibrary.simpleMessage(
            "브라우저에서 https://www.timerbell.com을 열면 어디서나 동일한 기능을 사용할 수 있습니다"),
        "wechat": MessageLookupByLibrary.simpleMessage("위챗"),
        "wechat_friends": MessageLookupByLibrary.simpleMessage("WeChat 친구"),
        "wechat_share": MessageLookupByLibrary.simpleMessage("위챗 공유"),
        "wednesday": MessageLookupByLibrary.simpleMessage("수요일"),
        "wednesdayShort": MessageLookupByLibrary.simpleMessage("수"),
        "week": MessageLookupByLibrary.simpleMessage("주"),
        "week_duration_completed":
            MessageLookupByLibrary.simpleMessage("이번 주의 총 집중 시간(분)"),
        "week_mission_completed":
            MessageLookupByLibrary.simpleMessage("이번 주 완료된 작업 수"),
        "week_tomatoes_completed":
            MessageLookupByLibrary.simpleMessage("이번 주 완료된 토마토 수"),
        "welcome": MessageLookupByLibrary.simpleMessage("환영합니다"),
        "welcome_to_time_department": m122,
        "whether_to_repeat": MessageLookupByLibrary.simpleMessage("반복 여부"),
        "who_can_view_edit_files":
            MessageLookupByLibrary.simpleMessage("누가 파일을 볼/편집할 수 있습니까"),
        "who_can_view_or_edit":
            MessageLookupByLibrary.simpleMessage("누가 파일을 볼/편집할 수 있습니까"),
        "wholeComepleteTime":
            MessageLookupByLibrary.simpleMessage("완료 총 시간(분)"),
        "word_count_and_char_count": m123,
        "write_a_title": MessageLookupByLibrary.simpleMessage("제목을 작성하시겠습니까?"),
        "write_diary": MessageLookupByLibrary.simpleMessage("일기 작성"),
        "write_your_clockin_feedback":
            MessageLookupByLibrary.simpleMessage("당신의 생각을 적어보세요"),
        "wrong_question_book": MessageLookupByLibrary.simpleMessage("잘못된 질문 책"),
        "wrong_question_book_prompt": MessageLookupByLibrary.simpleMessage(
            "{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: 방정식 2*x^2-, folder_id: null, flomo_object_id: null, type: 0, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 2, wqbKnowledgeContent: 일차 이차방정식 풀기, wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 2, wqbWrongQuestionContent: 방정식 2*x^2-4*x-6=0 풀기\n\nx=1 또는 x=-3, wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: x=3 또는 x=-1\n배열 방법이나 근의 공식을 사용하여, 우리는 정답을 찾을 수 있습니다, wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}"),
        "wrong_question_knowledge_point":
            MessageLookupByLibrary.simpleMessage("잘못된 질문 지식 포인트"),
        "wrong_question_knowledge_points":
            MessageLookupByLibrary.simpleMessage("잘못된 질문 지식 포인트"),
        "wrong_thinking": MessageLookupByLibrary.simpleMessage("잘못된 생각"),
        "wrote_a_diary": m124,
        "wrote_a_note": m125,
        "xxx_cannot_be_empty": m126,
        "year": MessageLookupByLibrary.simpleMessage("년"),
        "year_duration_completed":
            MessageLookupByLibrary.simpleMessage("올해의 총 집중 시간(분)"),
        "year_mission_completed":
            MessageLookupByLibrary.simpleMessage("올해 완료된 작업 수"),
        "year_month": m127,
        "year_tomatoes_completed":
            MessageLookupByLibrary.simpleMessage("올해 완료된 토마토 수"),
        "yes": MessageLookupByLibrary.simpleMessage("예"),
        "your_clockin_mission_with_name_has_begun": m128,
        "your_created_class":
            MessageLookupByLibrary.simpleMessage("당신이 만든 수업입니다"),
        "your_mission_with_name_has_begun": m129,
        "your_time_prof": MessageLookupByLibrary.simpleMessage("당신의 개인 시간 관리자"),
        "yuan": MessageLookupByLibrary.simpleMessage("원")
      };
}
