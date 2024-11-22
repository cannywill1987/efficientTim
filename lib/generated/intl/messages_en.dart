// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(date) => "After ${date}";

  static String m1(numbers) => "Batch complete \'${numbers}\' tasks";

  static String m2(numbers) => "Batch delete \'${numbers}\' tasks";

  static String m3(numbers) => "Batch uncomplete \'${numbers}\' tasks";

  static String m4(numbers) => "Batch update \'${numbers}\' tasks";

  static String m5(date) => "Before ${date}";

  static String m6(date1, date2) => "From ${date1} to ${date2}";

  static String m7(numTotatoes, duration, time, minute) =>
      "Estimated Pomodoros: ${numTotatoes} x ${duration} minutes = ${time} hours ${minute} minutes";

  static String m8(times) => "Clock in continuously for ${times} days";

  static String m9(n) => "Total clock in for ${n} days";

  static String m10(title) => "Finish clock-in mission \'${title}\'";

  static String m11(title, num) =>
      "Complete focusing task \'${title}\', and get ${num} coins ";

  static String m12(title, time, num) =>
      "Complete one-time focusing task \'${title}\', focused for ${time}, and get ${num} coins ";

  static String m13(title) => "complete resting mission 「${title}」";

  static String m14(title) => "complete resting mission 「${title}」";

  static String m15(name) => "${name}";

  static String m16(folderName) => "Confirm delete folder \"${folderName}\"";

  static String m17(folderName) =>
      "Are you sure you want to delete the list and related sub-tasks under the folder \"${folderName}\"?";

  static String m18(money) => "Consume「${money}」coins（entered manually）";

  static String m19(money, present) =>
      "Consume ${money} coins to buy a ${present}";

  static String m20(existing_text) =>
      "Please continue writing based on the following content:\n\n${existing_text}\n\nNext:";

  static String m21(title, link) =>
      "For the content of the task ${title}, please click the link to view: ${link}";

  static String m22(code) =>
      "Copy the link and share it with your friends, so they can join the group list by the group code ${code}";

  static String m23(title) => "Copy list \'${title}\'";

  static String m24(day, hour, mins, secs) =>
      "${day} days ${hour}:${mins}:${secs}";

  static String m25(hour, mins, secs) => "${hour}:${mins}:${secs}";

  static String m26(mins, secs) => "${mins}:${secs}";

  static String m27(times, total, title) =>
      "Clock-in for the ${times}/${total} time for \'${title}\'";

  static String m28(listing, title) =>
      "In the list \'${listing}\', created a ClockIn task \'${title}\'";

  static String m29(title) => "Created a ClockIn task \'${title}\'";

  static String m30(title) => "Create listing \'${title}\'";

  static String m31(listing, title) =>
      "in the listing \'${listing}\' create a mission \'${title}\'";

  static String m32(title) => "Create mission \'${title}\'";

  static String m33(title) => "create  tag \'${title}\'";

  static String m34(Folder) => "Create ${Folder}";

  static String m35(tone) => "Current ringtone: ${tone}";

  static String m36(date1, date2) => "${date1} to ${date2}";

  static String m37(month, day) => "${month}/${day}";

  static String m38(month, day, hour, mins) =>
      "${month}/${day},${hour}:${mins}";

  static String m39(money) => "${money} ago";

  static String m40(money) => "${money} days later";

  static String m41(title) => "Delete clock-in mission \'${title}\'";

  static String m42(note) => "Desktop Widget${note}";

  static String m43(title) => "Edit title \"${title}\"";

  static String m44(n) => "${n} times every day";

  static String m45(title, time, num) =>
      "Leave app,Mission「${title}」,Focus duration ${time},made ${num} coins";

  static String m46(title) => "Finish mission 「${title}」";

  static String m47(value) => "Duration:${value}";

  static String m48(value) => "No.:${value}";

  static String m49(duraiton) => "${duraiton} seconds to complete";

  static String m50(correct, error, percent) =>
      "${correct} correct answers, ${error} incorrect answers, accuracy rate ${percent}";

  static String m51(name) =>
      "Successfully obtained ${name} locally, you can start your training.";

  static String m52(app_name) => "Acting as ${app_name}\'s timekeeper";

  static String m53(id) => "Group ID: ${id}";

  static String m54(title) =>
      "Add a task in \"${title}\", press \"Enter\" to save";

  static String m55(hour, min) => "${hour} hour ${min} mins";

  static String m56(hour, min, sec) => "${hour} hour ${min} min ${sec} sec";

  static String m57(wordCount, charCount) =>
      "In selection word count: ${wordCount}, character count: ${charCount}";

  static String m58(num) => "Enter up to ${num} characters";

  static String m59(max) => "Cannot exceed ${max} characters";

  static String m60(time) => "Maximum recording time:${time}";

  static String m61(min, sec) => "${min} min ${sec} sec";

  static String m62(year, month, day, weekday) =>
      "${year}/${month}/${day},${weekday}";

  static String m63(month, day, year) => "${month}/${day}/${year}";

  static String m64(month, year) => "${month}, ${year}";

  static String m65(year, month, day, hour, min, weekday) =>
      "${year}-${month}-${day} ${hour}:${min},${weekday}";

  static String m66(missionTitle) =>
      "The ${missionTitle} mission is in progress, are you sure to stop?";

  static String m67(name) => "Mission Alert: ${name}";

  static String m68(name) => "\'${name}\' clock-in task reminder";

  static String m69(submission, mission) =>
      "The subtask ${submission} under the mission ${mission} has started, please be prepared";

  static String m70(title) => "Task \"${title}\"";

  static String m71(value) =>
      "Please set your hourly value first ${value}\$/hour";

  static String m72(title) => "Modify listing title to ${title}";

  static String m73(title) => "Modify tag title to \'${title}\'";

  static String m74(month, day, weekday) => "${month}/${day},${weekday}";

  static String m75(month) => "${month} month clock-in rate";

  static String m76(month) => "${month} month clock-in record";

  static String m77(course) => "My ${course}";

  static String m78(ranking) => "ranking:${ranking}";

  static String m79(ranking) => "My current ranking is ${ranking}";

  static String m80(days) => "Overdue ${days} days";

  static String m81(newline) => "Newline:${newline}";

  static String m82(title, min, secs) =>
      "${title}(remaining time:${min}:${secs}）";

  static String m83(value, hour, mins) =>
      "Today you have ${value} missions to do，preview duration:${hour} hour ${mins} mins";

  static String m84(n, hour, mins) =>
      "there are ${n} delayed tasks，preview duration:${hour} hour ${mins} mins ";

  static String m85(days) => "${days} days";

  static String m86(num) => "${num} mins";

  static String m87(num, total) => "${num} missions / ${total} total missions";

  static String m88(num, total) => "Listing ${num}/${total}";

  static String m89(num, total) => "${num}/${total}";

  static String m90(num) => "${num} tasks";

  static String m91(num) => "${num} times";

  static String m92(num) => "${num} tomatoes";

  static String m93(num) => "${num}";

  static String m94(number) => "${number} prizes";

  static String m95(name) =>
      "Please input the password for the list \'${name}\'";

  static String m96(xxx) => "Please input ${xxx}";

  static String m97(name) => "Please search \"${name}\" in the app store";

  static String m98(content) => "Please select ${content}";

  static String m99(present) => "How much coins does ${present} cost";

  static String m100(missionFinished, missionToDo, duration) =>
      "${missionFinished} finished, please start ${missionToDo}, ${missionToDo} duration: ${duration}";

  static String m101(total) => "${total} Recurring Task";

  static String m102(value) => "Duration:${value}";

  static String m103(value) => "No.:${value}";

  static String m104(role, time, content, timestampFormat1, timestampFormat2,
          timestampFormat3) =>
      "I want you to play a ${role}, you need to plan the following content, the time is ${time}, ${content}, and return an array of JSON objects. The key values and explanations of each field in the JSON are as follows: \nString? title = \'\'; //Title is required \nint? total_tomatoes; //Directly calculate the result, the number of completed tomatoes (daily_end_time - daily_start_time)/tomato_duration \nint? tomato_duration = 1500000;  //Directly calculate the result, the value is always 25 * 60 * 1000 milliseconds, representing a tomato focus of 25 minutes \nString? end_time; //Directly calculate the result, the end time in ${timestampFormat1} format is required \nint? priorityStatus; //3 No priority  2 Low priority 1 Medium priority 0 High priority is required \nString? daily_start_time; //Directly calculate the result, the task start time in ${timestampFormat2} format \nString? daily_end_time; //Directly calculate the result, the task end time in ${timestampFormat3} format \nString? message; //Task reminder \nNote: Cannot be null, the value in key:value directly gives the result, the daily_start_time and daily_end_time of each task cannot overlap \nThe title needs to be clearly described, no other explanation is needed, each task must be at least 5 minutes apart \nOnly return a JSON string with an array as the root, such as [object, object,]";

  static String m105(listing_name, code, app_name) =>
      "The group list number for ${listing_name} is ${code}. Download ${app_name}, enter the group list number, and you can work with your partners.";

  static String m106(title) => "Start focusing on task \'${title}\'";

  static String m107(title) => "start resting mission 「${title}」";

  static String m108(title, time, num) =>
      "Stop focusing on mission \'${title}\',focused for ${time}, and get ${num} coins ";

  static String m109(title) => "Stop resting mission 「${title}」";

  static String m110(money) => "${money} ago";

  static String m111(money) => "${money} later";

  static String m112(appname) => "${appname} AI";

  static String m113(date) => "${date}\'s data";

  static String m114(num) => "Total ${num}";

  static String m115(num) => "Total ${num} tomatoes";

  static String m116(trainee) =>
      "Please note, act according to your actual situation. If you are not satisfied with ${trainee}\'s response, you can communicate with ${trainee} to give more detailed commands to help you plan your time.";

  static String m117(trainee) => "${trainee}\'s advice";

  static String m132(title) => "Unfinish clock-in mission \'${title}\'";

  static String m118(time) => "Last update time:${time}";

  static String m119(listing, title) =>
      "in the listing \'${listing}\' update a mission \'${title}\'";

  static String m120(title) => "Update mission \'${title}\'";

  static String m121(value) => "value:${value}";

  static String m122(value) => "${value}\$/hour";

  static String m123(version) => "Current version ${version}";

  static String m124(appName) => "Welcome to \"${appName}\"";

  static String m125(wordCount, charCount) =>
      "Word count: ${wordCount}, character count: ${charCount}";

  static String m126(diary) => "wrote a diary:${diary}";

  static String m127(diary) => "wrote a not:${diary}";

  static String m128(text) => "${text} cannot be empty";

  static String m129(month, year) => "${month},${year}";

  static String m130(name) =>
      "Your clock-in task \'${name}\' has started. Please come and clock in.";

  static String m131(name) => "The mission ${name} has begun, please prepare";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("about"),
        "account": MessageLookupByLibrary.simpleMessage("account"),
        "account_unregister": MessageLookupByLibrary.simpleMessage(
            "Unregister Account And Delete Related Data"),
        "addBill": MessageLookupByLibrary.simpleMessage("Add bill"),
        "addBillReminder": MessageLookupByLibrary.simpleMessage(
            "Add bill, remind repayment, avoid expectation"),
        "addMissions2": MessageLookupByLibrary.simpleMessage("Add task..."),
        "addYourLink": MessageLookupByLibrary.simpleMessage("Add your link"),
        "add_bill": MessageLookupByLibrary.simpleMessage("Add bill"),
        "add_content": MessageLookupByLibrary.simpleMessage("Add content"),
        "add_credit_card_bill":
            MessageLookupByLibrary.simpleMessage("Add credit card bill"),
        "add_fail": MessageLookupByLibrary.simpleMessage("add failed"),
        "add_filterer": MessageLookupByLibrary.simpleMessage("Add Filter"),
        "add_group": MessageLookupByLibrary.simpleMessage("Add group"),
        "add_group_cannot_reorder": MessageLookupByLibrary.simpleMessage(
            "Cannot reorder when adding a group"),
        "add_group_listing":
            MessageLookupByLibrary.simpleMessage("Add group listing"),
        "add_group_on_the_left":
            MessageLookupByLibrary.simpleMessage("Add Group on the Left"),
        "add_group_on_the_right":
            MessageLookupByLibrary.simpleMessage("Add Group on the Right"),
        "add_link": MessageLookupByLibrary.simpleMessage("add link"),
        "add_listing": MessageLookupByLibrary.simpleMessage("add listing"),
        "add_note": MessageLookupByLibrary.simpleMessage("add note"),
        "add_reminder": MessageLookupByLibrary.simpleMessage("Add Reminder"),
        "add_subtask": MessageLookupByLibrary.simpleMessage("add subtask"),
        "add_successfully": MessageLookupByLibrary.simpleMessage(
            "add successfully, you can be viewed it in TimeLine page"),
        "add_tag": MessageLookupByLibrary.simpleMessage("add tag"),
        "add_task": MessageLookupByLibrary.simpleMessage("Create Task"),
        "add_username": MessageLookupByLibrary.simpleMessage("add username"),
        "addsuccess":
            MessageLookupByLibrary.simpleMessage("Added successfully"),
        "administrator": MessageLookupByLibrary.simpleMessage("Administrator"),
        "advanced_permissions": MessageLookupByLibrary.simpleMessage(
            "Advanced permissions: can set restrictions on copying, commenting, etc."),
        "advertising_copy":
            MessageLookupByLibrary.simpleMessage("Advertising Copy"),
        "advertising_copy_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter the product or service for the advertising copy..."),
        "advertising_copy_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me write an advertising copy, the product is..."),
        "after_date": m0,
        "after_n_days": MessageLookupByLibrary.simpleMessage("After n Days"),
        "agree": MessageLookupByLibrary.simpleMessage("agree"),
        "ai": MessageLookupByLibrary.simpleMessage("AI"),
        "ai_create": MessageLookupByLibrary.simpleMessage("AI Create"),
        "ai_helper": MessageLookupByLibrary.simpleMessage("AI Helper"),
        "ai_placeholder": MessageLookupByLibrary.simpleMessage(
            "What should I write with AI?"),
        "ai_scenario":
            MessageLookupByLibrary.simpleMessage("AI Writing Scenario"),
        "ai_scenario_prompt": MessageLookupByLibrary.simpleMessage(
            "Please select a writing scenario."),
        "ai_title": MessageLookupByLibrary.simpleMessage("Timerbell todo AI"),
        "ai_write_for_me":
            MessageLookupByLibrary.simpleMessage("AI Write for Me"),
        "ai_write_for_me_prompt": MessageLookupByLibrary.simpleMessage(
            "Please tell me what AI can help me write."),
        "ai_write_what": MessageLookupByLibrary.simpleMessage(
            "What should I write with AI?"),
        "ai_write_what_prompt": MessageLookupByLibrary.simpleMessage(
            "Please tell me what AI can help me write."),
        "alert": MessageLookupByLibrary.simpleMessage("Remind"),
        "alertMessage1": MessageLookupByLibrary.simpleMessage(
            "The number of tomatoes cannot be 0"),
        "alertMessage2":
            MessageLookupByLibrary.simpleMessage("The title can not be blank"),
        "alert_time": MessageLookupByLibrary.simpleMessage("Alert Time"),
        "alipay": MessageLookupByLibrary.simpleMessage("Alipay"),
        "all": MessageLookupByLibrary.simpleMessage("All"),
        "allUnfinishedMissions":
            MessageLookupByLibrary.simpleMessage("All Unfinished Tasks"),
        "all_finished_mission":
            MessageLookupByLibrary.simpleMessage("All finished tasks"),
        "all_maju": MessageLookupByLibrary.simpleMessage("ALL"),
        "all_mission": MessageLookupByLibrary.simpleMessage("All tasks"),
        "all_pending_repayment":
            MessageLookupByLibrary.simpleMessage("All pending repayment"),
        "already_delay":
            MessageLookupByLibrary.simpleMessage("Already delayed"),
        "already_exist":
            MessageLookupByLibrary.simpleMessage("training plan already exist"),
        "already_exists_at_this_time":
            MessageLookupByLibrary.simpleMessage("already exists at this time"),
        "already_in_course":
            MessageLookupByLibrary.simpleMessage("Participated in the course"),
        "already_in_group":
            MessageLookupByLibrary.simpleMessage("Already in the group"),
        "already_persisted":
            MessageLookupByLibrary.simpleMessage("Already Persisted"),
        "amount": MessageLookupByLibrary.simpleMessage("Amount"),
        "analyse": MessageLookupByLibrary.simpleMessage("analyse"),
        "analytics": MessageLookupByLibrary.simpleMessage("analyze"),
        "anki_card_prompt": MessageLookupByLibrary.simpleMessage(
            "{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: What is th, folder_id: null, flomo_object_id: null, type: 2, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 2, wqbWrongQuestionContent: What is the past tense form of the irregular verb \"go\"?\n\n, wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: The past tense of \"go\" is \"went\". Example: He went to the store yesterday.\n\nThis card helps learners memorize and practice the past tense forms of common irregular verbs in English.\n\n, wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}"),
        "announcement": MessageLookupByLibrary.simpleMessage("Announcement"),
        "announcement_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter the specific content of the announcement..."),
        "announcement_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me write an announcement, the content is..."),
        "answer": MessageLookupByLibrary.simpleMessage("Answer"),
        "appThmeSetting":
            MessageLookupByLibrary.simpleMessage("Theme color panel matching"),
        "app_name": MessageLookupByLibrary.simpleMessage("Poromoro ToDo"),
        "apple_login": MessageLookupByLibrary.simpleMessage("Apple Login"),
        "apr": MessageLookupByLibrary.simpleMessage("Apr"),
        "aprFull": MessageLookupByLibrary.simpleMessage("April"),
        "archive": MessageLookupByLibrary.simpleMessage("Archive"),
        "archived": MessageLookupByLibrary.simpleMessage("Archived"),
        "arithmetic_error":
            MessageLookupByLibrary.simpleMessage("Arithmetic error"),
        "at_least_one_prize": MessageLookupByLibrary.simpleMessage(
            "Please select at least one prize"),
        "attachment": MessageLookupByLibrary.simpleMessage("Attachment"),
        "aug": MessageLookupByLibrary.simpleMessage("Aug"),
        "augFull": MessageLookupByLibrary.simpleMessage("August"),
        "author_intro":
            MessageLookupByLibrary.simpleMessage("Author introduction"),
        "author_presentation_content":
            MessageLookupByLibrary.simpleMessage("Author presentation content"),
        "auto": MessageLookupByLibrary.simpleMessage("Automatic"),
        "auto_next_off": MessageLookupByLibrary.simpleMessage("Turn off loop"),
        "auto_next_on": MessageLookupByLibrary.simpleMessage("Turn on loop"),
        "avatar":
            MessageLookupByLibrary.simpleMessage("Please select an avatar"),
        "back": MessageLookupByLibrary.simpleMessage("return"),
        "back_card": MessageLookupByLibrary.simpleMessage("Back Card"),
        "background": MessageLookupByLibrary.simpleMessage("Wallpaper"),
        "backgroundColor":
            MessageLookupByLibrary.simpleMessage("Background Color"),
        "backgroundColorBlue":
            MessageLookupByLibrary.simpleMessage("Blue background"),
        "backgroundColorBrown":
            MessageLookupByLibrary.simpleMessage("Brown background"),
        "backgroundColorDefault":
            MessageLookupByLibrary.simpleMessage("Default background"),
        "backgroundColorGray":
            MessageLookupByLibrary.simpleMessage("Gray background"),
        "backgroundColorGreen":
            MessageLookupByLibrary.simpleMessage("Green background"),
        "backgroundColorOrange":
            MessageLookupByLibrary.simpleMessage("Orange background"),
        "backgroundColorPink":
            MessageLookupByLibrary.simpleMessage("Pink background"),
        "backgroundColorPurple":
            MessageLookupByLibrary.simpleMessage("Purple background"),
        "backgroundColorRed":
            MessageLookupByLibrary.simpleMessage("Red background"),
        "backgroundColorYellow":
            MessageLookupByLibrary.simpleMessage("Yellow background"),
        "background_auto_mode": MessageLookupByLibrary.simpleMessage("bg auto"),
        "background_change_auto_prompt_off":
            MessageLookupByLibrary.simpleMessage("background auto change off"),
        "background_change_auto_prompt_on":
            MessageLookupByLibrary.simpleMessage("background auto change on"),
        "background_setting":
            MessageLookupByLibrary.simpleMessage("Background Setting"),
        "bank": MessageLookupByLibrary.simpleMessage("Bank"),
        "batch_complete_missions": m1,
        "batch_delete_missions": m2,
        "batch_uncomplete_missions": m3,
        "batch_update_missions": m4,
        "bePening": MessageLookupByLibrary.simpleMessage("to be determined"),
        "before_date": m5,
        "before_n_days": MessageLookupByLibrary.simpleMessage("Before n Days"),
        "between_date": m6,
        "bill_cleared": MessageLookupByLibrary.simpleMessage("Bill cleared"),
        "bill_day": MessageLookupByLibrary.simpleMessage("Bill day"),
        "bill_detail": MessageLookupByLibrary.simpleMessage("Bill detail"),
        "bill_this_statement":
            MessageLookupByLibrary.simpleMessage("Bill this statement"),
        "billing_day": MessageLookupByLibrary.simpleMessage("Billing day"),
        "bold": MessageLookupByLibrary.simpleMessage("Bold"),
        "brainstorm": MessageLookupByLibrary.simpleMessage("Brainstorm"),
        "brainstorm_placeholder": MessageLookupByLibrary.simpleMessage(
            "(Example) Please provide at least 5 solutions for global warming."),
        "brainstorm_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me brainstorm on the topic of..."),
        "browse": MessageLookupByLibrary.simpleMessage("Browse"),
        "browser_not_support_multiline": MessageLookupByLibrary.simpleMessage(
            "The browser does not support multiline input. For a better experience, you can download the client."),
        "bulletedList": MessageLookupByLibrary.simpleMessage("Bulleted List"),
        "buy_training_plan":
            MessageLookupByLibrary.simpleMessage("buy training plan"),
        "byday": MessageLookupByLibrary.simpleMessage("Day"),
        "calculateTomatoesTime": m7,
        "calendar": MessageLookupByLibrary.simpleMessage("Calendar"),
        "calendar2": MessageLookupByLibrary.simpleMessage("Calendar"),
        "calendar_view_shortcuts":
            MessageLookupByLibrary.simpleMessage("Calendar View Shortcuts"),
        "camera_permission_description": MessageLookupByLibrary.simpleMessage(
            "In order to use the camera function, you need to authorize the camera permission"),
        "can_edit": MessageLookupByLibrary.simpleMessage("Can edit"),
        "can_not_be_empty": MessageLookupByLibrary.simpleMessage(
            "The input box cannot be empty"),
        "can_view": MessageLookupByLibrary.simpleMessage("Can view"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancel_finish": MessageLookupByLibrary.simpleMessage("Cancel Finish"),
        "cancel_latest_clockin":
            MessageLookupByLibrary.simpleMessage("Cancel the latest clock-in"),
        "cancel_setting_administrator":
            MessageLookupByLibrary.simpleMessage("Cancel administrator"),
        "cannot_handle_myself":
            MessageLookupByLibrary.simpleMessage("Cannot handle myself"),
        "cannot_reorder_for_group": MessageLookupByLibrary.simpleMessage(
            "Cannot Reorder for Ungrouped"),
        "capture_a_photo":
            MessageLookupByLibrary.simpleMessage("Capture a photo"),
        "capture_a_video":
            MessageLookupByLibrary.simpleMessage("Capture a video"),
        "card": MessageLookupByLibrary.simpleMessage("card"),
        "card_number": MessageLookupByLibrary.simpleMessage("Card number"),
        "carelessness": MessageLookupByLibrary.simpleMessage("Carelessness"),
        "caseSensitive": MessageLookupByLibrary.simpleMessage("Case sensitive"),
        "cause_analysis":
            MessageLookupByLibrary.simpleMessage("cause analysis"),
        "change_background":
            MessageLookupByLibrary.simpleMessage("Change background"),
        "change_bg": MessageLookupByLibrary.simpleMessage("Background"),
        "character_limit": MessageLookupByLibrary.simpleMessage("0/1000"),
        "character_limit_prompt":
            MessageLookupByLibrary.simpleMessage("Character limit: 0/1000"),
        "chat": MessageLookupByLibrary.simpleMessage("Chat"),
        "chatgpt": MessageLookupByLibrary.simpleMessage("GPT"),
        "chatgpt_ai_username_huawei":
            MessageLookupByLibrary.simpleMessage("老师"),
        "chatgpt_desc": MessageLookupByLibrary.simpleMessage(
            "Any question you have will find an answer"),
        "chatgpt_desc_huawei": MessageLookupByLibrary.simpleMessage(
            "Any question you have will be answered here"),
        "chatgpt_huawei": MessageLookupByLibrary.simpleMessage("AI Helper"),
        "checkbox": MessageLookupByLibrary.simpleMessage("Checkbox"),
        "chooseImage": MessageLookupByLibrary.simpleMessage("Choose an image"),
        "choose_attachment":
            MessageLookupByLibrary.simpleMessage("Choose attachment"),
        "chronograph": MessageLookupByLibrary.simpleMessage("chronograph"),
        "clearHighlightColor":
            MessageLookupByLibrary.simpleMessage("Clear highlight color"),
        "click_copy_qq": MessageLookupByLibrary.simpleMessage(""),
        "click_to_view": MessageLookupByLibrary.simpleMessage("Click to view"),
        "clock_in": MessageLookupByLibrary.simpleMessage("Clock In"),
        "clock_in_calendar":
            MessageLookupByLibrary.simpleMessage("Clock-in Calendar"),
        "clockin_n_days_continuously": m8,
        "clockin_n_days_totally": m9,
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "closeFind": MessageLookupByLibrary.simpleMessage("Close"),
        "close_all_cycle_mission":
            MessageLookupByLibrary.simpleMessage("Close all cycle missions"),
        "close_multi":
            MessageLookupByLibrary.simpleMessage("Close Multiple Selection"),
        "cloud_sync": MessageLookupByLibrary.simpleMessage("cloud sync"),
        "cloud_sync_content": MessageLookupByLibrary.simpleMessage(
            "Used for cross terminal data synchronization"),
        "cmdConvertToLink":
            MessageLookupByLibrary.simpleMessage("Convert to link"),
        "cmdConvertToParagraph":
            MessageLookupByLibrary.simpleMessage("convert to paragraph"),
        "cmdCopySelection":
            MessageLookupByLibrary.simpleMessage("Copy selection"),
        "cmdCutSelection":
            MessageLookupByLibrary.simpleMessage("Cut selection"),
        "cmdDeleteLeft": MessageLookupByLibrary.simpleMessage(
            "Delete character to the left"),
        "cmdDeleteLineLeft":
            MessageLookupByLibrary.simpleMessage("Delete to beginning of line"),
        "cmdDeleteRight": MessageLookupByLibrary.simpleMessage(
            "Delete character to the right"),
        "cmdDeleteWordLeft":
            MessageLookupByLibrary.simpleMessage("delete word at left"),
        "cmdDeleteWordRight":
            MessageLookupByLibrary.simpleMessage("delete word at right"),
        "cmdExitEditing":
            MessageLookupByLibrary.simpleMessage("exit editing mode"),
        "cmdIndent": MessageLookupByLibrary.simpleMessage("indent"),
        "cmdMoveCursorBottom":
            MessageLookupByLibrary.simpleMessage("move cursor to the bottom"),
        "cmdMoveCursorBottomSelect": MessageLookupByLibrary.simpleMessage(
            "Select all until end of file"),
        "cmdMoveCursorDown":
            MessageLookupByLibrary.simpleMessage("move cursor down"),
        "cmdMoveCursorDownSelect":
            MessageLookupByLibrary.simpleMessage("Select downward"),
        "cmdMoveCursorLeft":
            MessageLookupByLibrary.simpleMessage("move cursor left"),
        "cmdMoveCursorLeftSelect":
            MessageLookupByLibrary.simpleMessage("Select left"),
        "cmdMoveCursorLineEnd": MessageLookupByLibrary.simpleMessage(
            "move cursor to the end of line"),
        "cmdMoveCursorLineEndSelect":
            MessageLookupByLibrary.simpleMessage("Select to end of line"),
        "cmdMoveCursorLineStart": MessageLookupByLibrary.simpleMessage(
            "move cursor to start of line"),
        "cmdMoveCursorLineStartSelect":
            MessageLookupByLibrary.simpleMessage("Select to start of line"),
        "cmdMoveCursorRight":
            MessageLookupByLibrary.simpleMessage("move cursor right"),
        "cmdMoveCursorRightSelect":
            MessageLookupByLibrary.simpleMessage("Select right"),
        "cmdMoveCursorTop":
            MessageLookupByLibrary.simpleMessage("move cursor to the top"),
        "cmdMoveCursorTopSelect": MessageLookupByLibrary.simpleMessage(
            "Select all until start of file"),
        "cmdMoveCursorUp":
            MessageLookupByLibrary.simpleMessage("move cursor up"),
        "cmdMoveCursorUpSelect":
            MessageLookupByLibrary.simpleMessage("Select upward"),
        "cmdMoveCursorWordLeft": MessageLookupByLibrary.simpleMessage(
            "move cursor to word on the left"),
        "cmdMoveCursorWordLeftSelect":
            MessageLookupByLibrary.simpleMessage("Select word to the left"),
        "cmdMoveCursorWordRight": MessageLookupByLibrary.simpleMessage(
            "move cursor to word on the right"),
        "cmdMoveCursorWordRightSelect":
            MessageLookupByLibrary.simpleMessage("Select word to the right"),
        "cmdOpenFind": MessageLookupByLibrary.simpleMessage("Open Find"),
        "cmdOpenFindAndReplace":
            MessageLookupByLibrary.simpleMessage("Open Find and Replace"),
        "cmdOpenLink": MessageLookupByLibrary.simpleMessage("open link"),
        "cmdOpenLinks": MessageLookupByLibrary.simpleMessage("open links"),
        "cmdOutdent": MessageLookupByLibrary.simpleMessage("outdent"),
        "cmdPasteContent":
            MessageLookupByLibrary.simpleMessage("paste content"),
        "cmdPasteContentAsPlainText":
            MessageLookupByLibrary.simpleMessage("paste content as plain text"),
        "cmdRedo": MessageLookupByLibrary.simpleMessage("redo"),
        "cmdScrollPageDown":
            MessageLookupByLibrary.simpleMessage("scroll page down"),
        "cmdScrollPageUp":
            MessageLookupByLibrary.simpleMessage("scroll page up"),
        "cmdScrollToBottom":
            MessageLookupByLibrary.simpleMessage("scroll to bottom"),
        "cmdScrollToTop": MessageLookupByLibrary.simpleMessage("scroll to top"),
        "cmdSelectAll": MessageLookupByLibrary.simpleMessage("select all"),
        "cmdTableLineBreak":
            MessageLookupByLibrary.simpleMessage("Table: add line break"),
        "cmdTableMoveToDownCellAtSameOffset":
            MessageLookupByLibrary.simpleMessage(
                "Move to down cell at same offset"),
        "cmdTableMoveToLeftCellIfItsAtStartOfCurrentCell":
            MessageLookupByLibrary.simpleMessage(
                "Move to left cell if its at start of current cell"),
        "cmdTableMoveToRightCellIfItsAtTheEndOfCurrentCell":
            MessageLookupByLibrary.simpleMessage(
                "Move to right cell if its at the end of current cell"),
        "cmdTableMoveToUpCellAtSameOffset":
            MessageLookupByLibrary.simpleMessage(
                "Move to up cell at same offset"),
        "cmdTableNavigateCells": MessageLookupByLibrary.simpleMessage(
            "Navigate around the cells at same offset"),
        "cmdTableNavigateCellsReverse": MessageLookupByLibrary.simpleMessage(
            "Navigate around the cells at same offset in reverse"),
        "cmdTableStopAtTheBeginningOfTheCell":
            MessageLookupByLibrary.simpleMessage(
                "Stop at the beginning of the cell"),
        "cmdToggleBold": MessageLookupByLibrary.simpleMessage("toggle bold"),
        "cmdToggleCode": MessageLookupByLibrary.simpleMessage("toggle code"),
        "cmdToggleHighlight":
            MessageLookupByLibrary.simpleMessage("toggle highlight"),
        "cmdToggleItalic":
            MessageLookupByLibrary.simpleMessage("toggle italic"),
        "cmdToggleStrikethrough":
            MessageLookupByLibrary.simpleMessage("toggle strikethrough"),
        "cmdToggleTodoList":
            MessageLookupByLibrary.simpleMessage("toggle the todo list"),
        "cmdToggleUnderline":
            MessageLookupByLibrary.simpleMessage("toggle underline"),
        "cmdUndo": MessageLookupByLibrary.simpleMessage("undo"),
        "code_dynamic_code_incorrect": MessageLookupByLibrary.simpleMessage(
            "The dynamic code is incorrect"),
        "code_user_exist":
            MessageLookupByLibrary.simpleMessage("User already exists"),
        "code_user_not_exist":
            MessageLookupByLibrary.simpleMessage("User does not exist"),
        "code_user_password_not_correct": MessageLookupByLibrary.simpleMessage(
            "Account or password is incorrect"),
        "colAddAfter": MessageLookupByLibrary.simpleMessage("Add after"),
        "colAddBefore": MessageLookupByLibrary.simpleMessage("Add before"),
        "colClear": MessageLookupByLibrary.simpleMessage("Clear Content"),
        "colDuplicate": MessageLookupByLibrary.simpleMessage("Duplicate"),
        "colRemove": MessageLookupByLibrary.simpleMessage("Remove"),
        "color": MessageLookupByLibrary.simpleMessage("Color"),
        "color_optional": MessageLookupByLibrary.simpleMessage("Color"),
        "comingSoon": MessageLookupByLibrary.simpleMessage("Latest 7 days"),
        "comment": MessageLookupByLibrary.simpleMessage("Comment"),
        "comment_not_empty":
            MessageLookupByLibrary.simpleMessage("Comment cannot be empty"),
        "comment_placeholder": MessageLookupByLibrary.simpleMessage(
            "We will try our best to realize any reasonable suggestion from you within one week"),
        "compare_to_tomorrow":
            MessageLookupByLibrary.simpleMessage("Compared with yesterday"),
        "complete": MessageLookupByLibrary.simpleMessage("Finish"),
        "complete_flomo_mission": m10,
        "complete_focusing_mission_name": m11,
        "complete_one_time_focusing_mission_name": m12,
        "complete_plan_classification": MessageLookupByLibrary.simpleMessage(
            "Finished plan classification"),
        "complete_resting_mission_name": m13,
        "complete_resting_name": m14,
        "complete_voice_diary":
            MessageLookupByLibrary.simpleMessage("Finish voice diary"),
        "complete_voice_diary_with_title": m15,
        "complete_voice_note":
            MessageLookupByLibrary.simpleMessage("Finish voice note"),
        "completed": MessageLookupByLibrary.simpleMessage("Completed"),
        "completed_days":
            MessageLookupByLibrary.simpleMessage("Completed Days"),
        "completion_degree":
            MessageLookupByLibrary.simpleMessage("Completion Degree"),
        "completion_rate":
            MessageLookupByLibrary.simpleMessage("Completion Rate"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmRestDuration":
            MessageLookupByLibrary.simpleMessage("default break time"),
        "confirmToDelete": MessageLookupByLibrary.simpleMessage(
            "Are you sure to delete?\nNote: Deleted tasks cannot be recovered"),
        "confirmToFinishMission": MessageLookupByLibrary.simpleMessage(
            "Are you sure you have completed this task?"),
        "confirmToFinished":
            MessageLookupByLibrary.simpleMessage("confirm complete"),
        "confirmToFinishedContent": MessageLookupByLibrary.simpleMessage(
            "Are you sure you have completed this task?"),
        "confirmToSyncCloudData": MessageLookupByLibrary.simpleMessage(
            "Do you confirm the need for cloud synchronization (Note: It is only necessary to use this when you have logged in two accounts on one phone, and you need to synchronize the data from the previous phone number to the current one)?"),
        "confirm_delete_folder": m16,
        "confirm_delete_folder_desc": MessageLookupByLibrary.simpleMessage(
            "It cannot be restored after deletion"),
        "confirm_delete_mission_models": m17,
        "confirm_deletion":
            MessageLookupByLibrary.simpleMessage("Confirm Deletion"),
        "confirm_unregister":
            MessageLookupByLibrary.simpleMessage("Confirm unregister"),
        "confused": MessageLookupByLibrary.simpleMessage("some confused ideas"),
        "consider_it": MessageLookupByLibrary.simpleMessage("think about it"),
        "consume_failure":
            MessageLookupByLibrary.simpleMessage("Consumption failed"),
        "consume_money": m18,
        "consume_money_buy_present": m19,
        "consume_success":
            MessageLookupByLibrary.simpleMessage("successful consumption"),
        "consump_money":
            MessageLookupByLibrary.simpleMessage("To spend coins:"),
        "consump_present":
            MessageLookupByLibrary.simpleMessage("consumable prizes"),
        "consump_present_description": MessageLookupByLibrary.simpleMessage(
            "Create present you like to reward yourself by coins"),
        "content": MessageLookupByLibrary.simpleMessage("Content"),
        "content_cannot_be_empty":
            MessageLookupByLibrary.simpleMessage("Content cannot be empty"),
        "continously_clockin":
            MessageLookupByLibrary.simpleMessage("Continuous Clock-in"),
        "continue2": MessageLookupByLibrary.simpleMessage("Continue"),
        "continueTxt": MessageLookupByLibrary.simpleMessage("continue"),
        "continue_writing":
            MessageLookupByLibrary.simpleMessage("Continue Writing"),
        "continue_writing_prompt": MessageLookupByLibrary.simpleMessage(
            "Please continue writing based on the selected paragraph, expanding the content."),
        "continue_writing_prompt_with_text": m20,
        "continuous_clock_in":
            MessageLookupByLibrary.simpleMessage("Continuous Clock-in"),
        "continuous_days":
            MessageLookupByLibrary.simpleMessage("Continuous Days"),
        "continuously": MessageLookupByLibrary.simpleMessage("Continuing"),
        "convert_to_note":
            MessageLookupByLibrary.simpleMessage("Convert to Note"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "copyLink": MessageLookupByLibrary.simpleMessage("Copy link"),
        "copy_and_share":
            MessageLookupByLibrary.simpleMessage("Copy link and share"),
        "copy_and_share_with_title": m21,
        "copy_link": MessageLookupByLibrary.simpleMessage("Copy link"),
        "copy_link_description": m22,
        "copy_mission_model": m23,
        "copy_qq": MessageLookupByLibrary.simpleMessage("Join facebook"),
        "copy_qq_success": MessageLookupByLibrary.simpleMessage(""),
        "copy_sub_title": MessageLookupByLibrary.simpleMessage(
            "Join our facebook and give us opinion^^"),
        "copy_success": MessageLookupByLibrary.simpleMessage("Copy successful"),
        "correct_answer":
            MessageLookupByLibrary.simpleMessage("Correct Answer"),
        "count_down": m24,
        "count_down2": m25,
        "count_down3": m26,
        "count_down_text": MessageLookupByLibrary.simpleMessage("Countdown"),
        "counting": MessageLookupByLibrary.simpleMessage("counting"),
        "course": MessageLookupByLibrary.simpleMessage("course"),
        "course_desc":
            MessageLookupByLibrary.simpleMessage("Good score, loss weight"),
        "course_intro": MessageLookupByLibrary.simpleMessage("course intro"),
        "course_introduction":
            MessageLookupByLibrary.simpleMessage("Course Introduction"),
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "createMission": MessageLookupByLibrary.simpleMessage("Create List"),
        "createSuccess":
            MessageLookupByLibrary.simpleMessage("created successfully"),
        "createTag": MessageLookupByLibrary.simpleMessage("create tags"),
        "create_chat": MessageLookupByLibrary.simpleMessage("Create Chat"),
        "create_copy": MessageLookupByLibrary.simpleMessage("Create Copy"),
        "create_folder_desc":
            MessageLookupByLibrary.simpleMessage("Create Folder"),
        "create_mission":
            MessageLookupByLibrary.simpleMessage("Create Mission"),
        "create_mission_by_content": MessageLookupByLibrary.simpleMessage(
            "Help me create a mission:\nMission Title:\nDescription:"),
        "create_mission_by_gpt":
            MessageLookupByLibrary.simpleMessage("Create Mission or Listing"),
        "create_mission_by_title":
            MessageLookupByLibrary.simpleMessage("Create Mission"),
        "create_mission_title":
            MessageLookupByLibrary.simpleMessage("Give me chart"),
        "create_mission_title_content":
            MessageLookupByLibrary.simpleMessage("Give me chart\nTime:"),
        "create_name_flomo_mission": m27,
        "create_name_flomomission": m28,
        "create_name_flomomission2": m29,
        "create_name_listing": m30,
        "create_name_mission": m31,
        "create_name_mission2": m32,
        "create_name_tag": m33,
        "create_present":
            MessageLookupByLibrary.simpleMessage("create rewards"),
        "create_success":
            MessageLookupByLibrary.simpleMessage("Create success"),
        "create_time": MessageLookupByLibrary.simpleMessage("Create Time"),
        "create_xxx": m34,
        "creating_date": MessageLookupByLibrary.simpleMessage("create date"),
        "creative_story":
            MessageLookupByLibrary.simpleMessage("Creative Story"),
        "creative_story_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter the plot or theme of the creative story..."),
        "creative_story_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me write a creative story, the plot is..."),
        "credit_bag": MessageLookupByLibrary.simpleMessage("Card bag"),
        "credit_limit": MessageLookupByLibrary.simpleMessage("Credit limit"),
        "curAnalytics": MessageLookupByLibrary.simpleMessage("Charts"),
        "curTimeF": MessageLookupByLibrary.simpleMessage("Starting time"),
        "currentRingTone": m35,
        "current_amount":
            MessageLookupByLibrary.simpleMessage("Current amount"),
        "custom": MessageLookupByLibrary.simpleMessage("Custom"),
        "customColor": MessageLookupByLibrary.simpleMessage("Custom color"),
        "customize": MessageLookupByLibrary.simpleMessage("Customize"),
        "cut": MessageLookupByLibrary.simpleMessage("Cut"),
        "daily_completion_times":
            MessageLookupByLibrary.simpleMessage("Daily Completion Times"),
        "daily_end_time":
            MessageLookupByLibrary.simpleMessage("daily end time"),
        "daily_start_time":
            MessageLookupByLibrary.simpleMessage("daily start time"),
        "dark_mode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
        "data_analyse": MessageLookupByLibrary.simpleMessage("Data Analysis"),
        "data_analyse_desc": MessageLookupByLibrary.simpleMessage(
            "Real-time data analysis to help you better understand yourself"),
        "date": MessageLookupByLibrary.simpleMessage("Date"),
        "date1_to_date2": m36,
        "dateFromMonth": m37,
        "dateFromMonthToMins": m38,
        "dateOutOfLimit": MessageLookupByLibrary.simpleMessage(
            "The date you selected is out of range"),
        "datetime": MessageLookupByLibrary.simpleMessage("DateTime"),
        "day": MessageLookupByLibrary.simpleMessage("day"),
        "day_hour_minute_second":
            MessageLookupByLibrary.simpleMessage("Day, Hour, Minute, Second"),
        "daysLater": MessageLookupByLibrary.simpleMessage("diva"),
        "days_after_bill_day":
            MessageLookupByLibrary.simpleMessage("Days after bill day"),
        "days_after_repayment_day":
            MessageLookupByLibrary.simpleMessage("Days after repayment day"),
        "days_ago": m39,
        "days_later": m40,
        "de": MessageLookupByLibrary.simpleMessage(" of "),
        "deadLine": MessageLookupByLibrary.simpleMessage("Expiry date"),
        "dec": MessageLookupByLibrary.simpleMessage("Dec"),
        "decFull": MessageLookupByLibrary.simpleMessage("December"),
        "decrypt": MessageLookupByLibrary.simpleMessage("Decrypt"),
        "defaultFocusDuration":
            MessageLookupByLibrary.simpleMessage("Default focus time"),
        "delay_mission": MessageLookupByLibrary.simpleMessage("Delay mission"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "delete_flomo_mission": m41,
        "delete_success":
            MessageLookupByLibrary.simpleMessage("Delete Successfully"),
        "deprecated": MessageLookupByLibrary.simpleMessage("Deprecated"),
        "desc_consume":
            MessageLookupByLibrary.simpleMessage("consumption description"),
        "desktop_widget_with_note_n": m42,
        "detailed_training_plan":
            MessageLookupByLibrary.simpleMessage("Detailed Training Plan"),
        "detailed_training_plan_desc": MessageLookupByLibrary.simpleMessage(
            "Provide your sharers with a more detailed training plan to help them improve themselves in more detail"),
        "detailed_training_plan_desc_2": MessageLookupByLibrary.simpleMessage(
            "Click to view the detailed training plan for the course"),
        "detailed_training_plan_optional": MessageLookupByLibrary.simpleMessage(
            "Detailed Training Plan（Optional）"),
        "diary": MessageLookupByLibrary.simpleMessage("diary"),
        "digit_password_incorrect":
            MessageLookupByLibrary.simpleMessage("Numeric password incorrect"),
        "discard": MessageLookupByLibrary.simpleMessage("Discard"),
        "dismiss_group":
            MessageLookupByLibrary.simpleMessage("Dismiss the group"),
        "divider": MessageLookupByLibrary.simpleMessage("Divider"),
        "do_it_now": MessageLookupByLibrary.simpleMessage("Do it now"),
        "do_it_now_desc": MessageLookupByLibrary.simpleMessage(
            "Do it now represents tasks that need to be done immediately. Setting \'Do it now\' will initiate a countdown."),
        "dollar": MessageLookupByLibrary.simpleMessage("\$"),
        "done": MessageLookupByLibrary.simpleMessage("Done"),
        "dont_remind_again":
            MessageLookupByLibrary.simpleMessage("Don\'t remind again"),
        "download_fail":
            MessageLookupByLibrary.simpleMessage("Download failed"),
        "downloading_please_wait":
            MessageLookupByLibrary.simpleMessage("Downloading, please wait..."),
        "each": MessageLookupByLibrary.simpleMessage("Every"),
        "eachSpace": MessageLookupByLibrary.simpleMessage("Every"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "editLink": MessageLookupByLibrary.simpleMessage("Edit link"),
        "edit_fail": MessageLookupByLibrary.simpleMessage("edit failed"),
        "edit_options": MessageLookupByLibrary.simpleMessage("Edit Options"),
        "edit_sharing": MessageLookupByLibrary.simpleMessage("edit sharing"),
        "edit_successfully": MessageLookupByLibrary.simpleMessage(
            "edit successfully, it can be viewed it in TimeLine page"),
        "edit_title": m43,
        "editing": MessageLookupByLibrary.simpleMessage("Editing"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emailCannotBeNull":
            MessageLookupByLibrary.simpleMessage("E-mail can not be empty"),
        "email_not_supportable": MessageLookupByLibrary.simpleMessage(
            "Email registration is not supported in China currently"),
        "embedCode": MessageLookupByLibrary.simpleMessage("Embed Code"),
        "emoji_conversion":
            MessageLookupByLibrary.simpleMessage("Emoji Conversion"),
        "emoji_conversion_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter the text to be converted to emojis..."),
        "emoji_conversion_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me convert the following text to emojis:..."),
        "emptySearchBoxHint":
            MessageLookupByLibrary.simpleMessage("Enter a pattern"),
        "en": MessageLookupByLibrary.simpleMessage("English"),
        "encourage_yourself": MessageLookupByLibrary.simpleMessage(
            "Write a sentence to encourage yourself~"),
        "encrypt": MessageLookupByLibrary.simpleMessage("Encrypt"),
        "encrypt_desc": MessageLookupByLibrary.simpleMessage(
            "After encryption, it can only be decrypted using your numeric password. It is recommended to use this feature for sensitive data, otherwise, it may affect the user experience"),
        "encrypt_password": MessageLookupByLibrary.simpleMessage(
            "Please set your numeric password"),
        "encrypt_password_confirm": MessageLookupByLibrary.simpleMessage(
            "Please re-enter your numeric password"),
        "encrypt_password_not_match": MessageLookupByLibrary.simpleMessage(
            "The two passwords entered do not match"),
        "encrypt_password_not_set": MessageLookupByLibrary.simpleMessage(
            "You have not set a numeric password"),
        "encrypt_store_password": MessageLookupByLibrary.simpleMessage(
            "Store numeric password locally"),
        "end_time": MessageLookupByLibrary.simpleMessage("Finished Time"),
        "end_time_cannot_before_start_time":
            MessageLookupByLibrary.simpleMessage(
                "End time cannot be earlier than start time"),
        "endtime_cannot_before_starttime": MessageLookupByLibrary.simpleMessage(
            "End time cannot be earlier than start time"),
        "enrich": MessageLookupByLibrary.simpleMessage("Enrich"),
        "enrich_prompt": MessageLookupByLibrary.simpleMessage(
            "Please enrich the selected paragraph, making it more detailed and comprehensive."),
        "enterBankName":
            MessageLookupByLibrary.simpleMessage("Please enter bank name"),
        "enterBillAmount":
            MessageLookupByLibrary.simpleMessage("Please enter bill amount"),
        "enterCreditLimit": MessageLookupByLibrary.simpleMessage(
            "Please enter credit limit (optional)"),
        "enterFullCardNumber": MessageLookupByLibrary.simpleMessage(
            "Please enter full card number"),
        "enterRealName":
            MessageLookupByLibrary.simpleMessage("Please enter real name"),
        "enter_amount":
            MessageLookupByLibrary.simpleMessage("Please enter the amount"),
        "es": MessageLookupByLibrary.simpleMessage("Español"),
        "event": MessageLookupByLibrary.simpleMessage("event"),
        "everyDayOnce": m44,
        "everyone_can_edit":
            MessageLookupByLibrary.simpleMessage("Everyone can edit"),
        "everyone_can_view":
            MessageLookupByLibrary.simpleMessage("Everyone can view"),
        "examination":
            MessageLookupByLibrary.simpleMessage("Examination error"),
        "example_demo_hint": MessageLookupByLibrary.simpleMessage(
            "e.g..\"always describe in bullet points, never use unwrap, always output your answers in English\""),
        "exist_app_focusing_mission_name": m45,
        "explain": MessageLookupByLibrary.simpleMessage("Explain"),
        "explain_prompt": MessageLookupByLibrary.simpleMessage(
            "Please explain the main content and significance of the selected paragraph."),
        "export": MessageLookupByLibrary.simpleMessage("export"),
        "export_data": MessageLookupByLibrary.simpleMessage("export data"),
        "export_excel":
            MessageLookupByLibrary.simpleMessage("export to Excel File"),
        "feb": MessageLookupByLibrary.simpleMessage("Feb"),
        "febFull": MessageLookupByLibrary.simpleMessage("February"),
        "feedback": MessageLookupByLibrary.simpleMessage("feedback"),
        "filter_name": MessageLookupByLibrary.simpleMessage("Filter Name"),
        "filterer": MessageLookupByLibrary.simpleMessage("Filter"),
        "filtering_setting":
            MessageLookupByLibrary.simpleMessage("Filtering Setting"),
        "find": MessageLookupByLibrary.simpleMessage("Find"),
        "find_new_version":
            MessageLookupByLibrary.simpleMessage("new version found"),
        "finish": MessageLookupByLibrary.simpleMessage("Finish"),
        "finish_level": MessageLookupByLibrary.simpleMessage("Completeness:"),
        "finish_mission_name": m46,
        "finish_time": MessageLookupByLibrary.simpleMessage("Complete time"),
        "finished": MessageLookupByLibrary.simpleMessage("Finished"),
        "fix_spelling_grammar":
            MessageLookupByLibrary.simpleMessage("Fix Spelling and Grammar"),
        "fix_spelling_grammar_prompt": MessageLookupByLibrary.simpleMessage(
            "Please check the selected paragraph for spelling and grammar errors and fix any issues."),
        "focus": MessageLookupByLibrary.simpleMessage("concentrate on"),
        "focusFinished":
            MessageLookupByLibrary.simpleMessage("focus on completion"),
        "focusPausing": MessageLookupByLibrary.simpleMessage("focus on pause"),
        "focus_campus":
            MessageLookupByLibrary.simpleMessage("Focus on training camp"),
        "focus_completed_auto_start_rest": MessageLookupByLibrary.simpleMessage(
            "Automatically start resting after focus is completed"),
        "focus_duration":
            MessageLookupByLibrary.simpleMessage("Focus Duration"),
        "focus_duration_distribution":
            MessageLookupByLibrary.simpleMessage("Focus duration distribution"),
        "focus_duration_with_value": m47,
        "focus_finished_ringtone":
            MessageLookupByLibrary.simpleMessage("focus end ringtone"),
        "focus_numbers_with_value": m48,
        "focus_on_time_period_distribution":
            MessageLookupByLibrary.simpleMessage(
                "Focus on time period distribution"),
        "focus_pause": MessageLookupByLibrary.simpleMessage("Pause Focus"),
        "focus_setting": MessageLookupByLibrary.simpleMessage("Focus Setting"),
        "focus_start": MessageLookupByLibrary.simpleMessage("Start Focus"),
        "focus_stop": MessageLookupByLibrary.simpleMessage("Stop Focus"),
        "focus_switch_desc": MessageLookupByLibrary.simpleMessage(
            "Does switching tasks during focus reset the timer?"),
        "focus_switch_title":
            MessageLookupByLibrary.simpleMessage("New Task Resets Timer"),
        "focus_timer": MessageLookupByLibrary.simpleMessage("Focus Timer"),
        "focus_timer_desc": MessageLookupByLibrary.simpleMessage(
            "Multiple background sounds to enter a state of deep focus"),
        "focusing": MessageLookupByLibrary.simpleMessage("in focus"),
        "focusing_music":
            MessageLookupByLibrary.simpleMessage("Focus on music"),
        "folder": MessageLookupByLibrary.simpleMessage("Folder"),
        "folder_name": MessageLookupByLibrary.simpleMessage("Folder Name"),
        "fontColorBlue": MessageLookupByLibrary.simpleMessage("Blue"),
        "fontColorBrown": MessageLookupByLibrary.simpleMessage("Brown"),
        "fontColorDefault": MessageLookupByLibrary.simpleMessage("Default"),
        "fontColorGray": MessageLookupByLibrary.simpleMessage("Gray"),
        "fontColorGreen": MessageLookupByLibrary.simpleMessage("Green"),
        "fontColorOrange": MessageLookupByLibrary.simpleMessage("Orange"),
        "fontColorPink": MessageLookupByLibrary.simpleMessage("Pink"),
        "fontColorPurple": MessageLookupByLibrary.simpleMessage("Purple"),
        "fontColorRed": MessageLookupByLibrary.simpleMessage("Red"),
        "fontColorYellow": MessageLookupByLibrary.simpleMessage("Yellow"),
        "food_reviews": MessageLookupByLibrary.simpleMessage("Food Reviews"),
        "food_reviews_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter the restaurant and dishes for the review..."),
        "food_reviews_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me write a food review, the restaurant is..."),
        "four_pws": MessageLookupByLibrary.simpleMessage(
            "Please enter a 4-digit digital password"),
        "four_quadrant": MessageLookupByLibrary.simpleMessage("Quadrant"),
        "four_quadrant_priority1":
            MessageLookupByLibrary.simpleMessage("important and urgent"),
        "four_quadrant_priority1_abbr":
            MessageLookupByLibrary.simpleMessage("imp. & urg."),
        "four_quadrant_priority1_desc":
            MessageLookupByLibrary.simpleMessage("highest priority to do"),
        "four_quadrant_priority2":
            MessageLookupByLibrary.simpleMessage("imp.&not urg."),
        "four_quadrant_priority2_abbr":
            MessageLookupByLibrary.simpleMessage("not imp. & urg."),
        "four_quadrant_priority2_desc":
            MessageLookupByLibrary.simpleMessage("make a plan to do it"),
        "four_quadrant_priority3":
            MessageLookupByLibrary.simpleMessage("not imp.&urgent"),
        "four_quadrant_priority3_abbr":
            MessageLookupByLibrary.simpleMessage("imp. & not urg."),
        "four_quadrant_priority3_desc":
            MessageLookupByLibrary.simpleMessage("make others to do"),
        "four_quadrant_priority4":
            MessageLookupByLibrary.simpleMessage("not imp.&not urg."),
        "four_quadrant_priority4_abbr":
            MessageLookupByLibrary.simpleMessage("not imp. & not urg."),
        "four_quadrant_priority4_desc":
            MessageLookupByLibrary.simpleMessage("do it when free"),
        "four_seasons":
            MessageLookupByLibrary.simpleMessage("First to Fourth Quarter"),
        "four_seasons_desc": MessageLookupByLibrary.simpleMessage(
            "Create a group from the first to the fourth quarter"),
        "four_seasons_step1":
            MessageLookupByLibrary.simpleMessage("First Quarter"),
        "four_seasons_step2":
            MessageLookupByLibrary.simpleMessage("Second Quarter"),
        "four_seasons_step3":
            MessageLookupByLibrary.simpleMessage("Third Quarter"),
        "four_seasons_step4":
            MessageLookupByLibrary.simpleMessage("Fourth Quarter"),
        "fr": MessageLookupByLibrary.simpleMessage("Français"),
        "fragment_listing":
            MessageLookupByLibrary.simpleMessage("Fragment List"),
        "free_open": MessageLookupByLibrary.simpleMessage("free_open"),
        "frequency": MessageLookupByLibrary.simpleMessage("Frequency"),
        "friday": MessageLookupByLibrary.simpleMessage("Fri"),
        "fridayShort": MessageLookupByLibrary.simpleMessage("Fri"),
        "front_card": MessageLookupByLibrary.simpleMessage("Front Card"),
        "fullscreen": MessageLookupByLibrary.simpleMessage("Fullscreen"),
        "gallery": MessageLookupByLibrary.simpleMessage("Gallery"),
        "game1_time_usage": m49,
        "game2_ranking_text": m50,
        "game_input_waiting":
            MessageLookupByLibrary.simpleMessage("Waiting for timing"),
        "generate_image":
            MessageLookupByLibrary.simpleMessage("Generate image"),
        "generate_qr_code":
            MessageLookupByLibrary.simpleMessage("Generate QR code"),
        "gently_remind": MessageLookupByLibrary.simpleMessage("Kind tips"),
        "german": MessageLookupByLibrary.simpleMessage("Deutsch"),
        "getVerificationCode": MessageLookupByLibrary.simpleMessage(
            "Click for authentication code"),
        "get_train_plan_successful": m51,
        "get_training_plan":
            MessageLookupByLibrary.simpleMessage("get training plan"),
        "give_up": MessageLookupByLibrary.simpleMessage("Give Up"),
        "go_to_setting":
            MessageLookupByLibrary.simpleMessage("Open to setting"),
        "google_login": MessageLookupByLibrary.simpleMessage("Google Login"),
        "gpt_role": m52,
        "gpt_system_msg_forbidden": MessageLookupByLibrary.simpleMessage(
            "Do not discuss any pornographic or politically sensitive topics"),
        "gpt_token_expired": MessageLookupByLibrary.simpleMessage(
            "Your token has expired, please add WeChat ID cannywill to apply for GPT access permission."),
        "grid": MessageLookupByLibrary.simpleMessage("Grid"),
        "group_announcement":
            MessageLookupByLibrary.simpleMessage("Group announcement"),
        "group_id": m53,
        "groupview": MessageLookupByLibrary.simpleMessage("Group view"),
        "gtd": MessageLookupByLibrary.simpleMessage("GTD"),
        "gtd_desc": MessageLookupByLibrary.simpleMessage(
            "The five steps of GTD:；\n (1) Collect everything that has our attention;\n(2) Clarify the meaning and actions associated with each collection;\n(3) Organize the outcomes, listing the next actions for each item;\n(4) Take action;\n(5) Regularly review and reflect."),
        "gtd_step1":
            MessageLookupByLibrary.simpleMessage("Collect Information"),
        "gtd_step2": MessageLookupByLibrary.simpleMessage("Clarify Meaning"),
        "gtd_step3": MessageLookupByLibrary.simpleMessage("Organize"),
        "gtd_step4": MessageLookupByLibrary.simpleMessage("Take Action"),
        "gtd_step5": MessageLookupByLibrary.simpleMessage("Review and Summary"),
        "guide1": MessageLookupByLibrary.simpleMessage("Begin Focusing"),
        "guide2": MessageLookupByLibrary.simpleMessage(
            "Click the header input box to add tasks"),
        "guide3_mobile": MessageLookupByLibrary.simpleMessage(
            "Swipe right to edit or delete tasks"),
        "guide3_pc": MessageLookupByLibrary.simpleMessage(
            "Swipe the mouse to edit or delete tasks"),
        "guide4": MessageLookupByLibrary.simpleMessage(
            "Click the red play button to focus on timing"),
        "guide_examine_time":
            MessageLookupByLibrary.simpleMessage("examine time"),
        "habit_clockin": MessageLookupByLibrary.simpleMessage("Habit Clock-in"),
        "habit_clockin_desc": MessageLookupByLibrary.simpleMessage(
            "Develop a habit in 21 days, Ebbinghaus\' long-term memory of what\'s learned"),
        "hasLogined": MessageLookupByLibrary.simpleMessage("already logged in"),
        "header_input_placeholder_with_title": m54,
        "heading1": MessageLookupByLibrary.simpleMessage("H1"),
        "heading2": MessageLookupByLibrary.simpleMessage("H2"),
        "heading3": MessageLookupByLibrary.simpleMessage("H3"),
        "heavy": MessageLookupByLibrary.simpleMessage("heavy"),
        "hello": MessageLookupByLibrary.simpleMessage("Hello"),
        "hexValue": MessageLookupByLibrary.simpleMessage("Hex value"),
        "hidden": MessageLookupByLibrary.simpleMessage("hidden"),
        "highlight": MessageLookupByLibrary.simpleMessage("Highlight"),
        "highlightColor":
            MessageLookupByLibrary.simpleMessage("Highlight Color"),
        "hint_search_chat":
            MessageLookupByLibrary.simpleMessage("Search chat history"),
        "history_event":
            MessageLookupByLibrary.simpleMessage("Historical event"),
        "history_record":
            MessageLookupByLibrary.simpleMessage("History Record"),
        "history_record_prompt":
            MessageLookupByLibrary.simpleMessage("View history records."),
        "hour": MessageLookupByLibrary.simpleMessage("Hour"),
        "hour3": MessageLookupByLibrary.simpleMessage("Time"),
        "hourAndMin": m55,
        "hourAndMinAndSec": m56,
        "i_consume": MessageLookupByLibrary.simpleMessage("SPEND"),
        "i_know": MessageLookupByLibrary.simpleMessage("I know"),
        "icon": MessageLookupByLibrary.simpleMessage("Icon"),
        "image": MessageLookupByLibrary.simpleMessage("image"),
        "imageLoadFailed":
            MessageLookupByLibrary.simpleMessage("Could not load the image"),
        "improve_writing":
            MessageLookupByLibrary.simpleMessage("Improve Writing"),
        "improve_writing_prompt": MessageLookupByLibrary.simpleMessage(
            "Please improve the selected paragraph to make it clearer and more expressive."),
        "inSevenDays": MessageLookupByLibrary.simpleMessage("7 days later"),
        "in_selection_word_count_and_char_count": m57,
        "incorrectLink": MessageLookupByLibrary.simpleMessage("Incorrect Link"),
        "input": MessageLookupByLibrary.simpleMessage("Input"),
        "inputSmsVerificationCode": MessageLookupByLibrary.simpleMessage(
            "Please input sms dynamic code"),
        "input_6_digit_password": MessageLookupByLibrary.simpleMessage(
            "Please input a 6-digit numeric password"),
        "input_correct_mobile": MessageLookupByLibrary.simpleMessage(
            "Please enter the correct mobile number"),
        "input_correct_password": MessageLookupByLibrary.simpleMessage(
            "Please input the correct password first"),
        "input_end_time": MessageLookupByLibrary.simpleMessage(
            "Please enter your desired end time"),
        "input_manually": MessageLookupByLibrary.simpleMessage("manual input"),
        "input_mission_title_first": MessageLookupByLibrary.simpleMessage(
            "Please input the mission title first"),
        "input_mobile": MessageLookupByLibrary.simpleMessage(
            "Mobile number cannot be empty, please enter the mobile number!"),
        "input_your_goal": MessageLookupByLibrary.simpleMessage(
            "Enter the goal you want to stick to~"),
        "insert": MessageLookupByLibrary.simpleMessage("Insert"),
        "insert_event": MessageLookupByLibrary.simpleMessage("insert event"),
        "insert_success":
            MessageLookupByLibrary.simpleMessage("insert successfully"),
        "interview_questions":
            MessageLookupByLibrary.simpleMessage("Interview Questions"),
        "interview_questions_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter the interviewee and relevant questions..."),
        "interview_questions_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me list interview questions, the interviewee is..."),
        "invalid_mobile_number":
            MessageLookupByLibrary.simpleMessage("Invalid Mobile Number"),
        "isDelayed": MessageLookupByLibrary.simpleMessage("Is Delayed"),
        "isEditable": MessageLookupByLibrary.simpleMessage(
            "All user share editing status"),
        "isFinished": MessageLookupByLibrary.simpleMessage("Finished Status"),
        "is_push_setting":
            MessageLookupByLibrary.simpleMessage("Targeted push settings"),
        "is_push_setting_detail": MessageLookupByLibrary.simpleMessage(
            "Turn on targeted push settings, which will help you to be notified of the completion of your tasks"),
        "italic": MessageLookupByLibrary.simpleMessage("Italic"),
        "ja": MessageLookupByLibrary.simpleMessage("日本語"),
        "jan": MessageLookupByLibrary.simpleMessage("Jan"),
        "janFull": MessageLookupByLibrary.simpleMessage("January"),
        "jan_to_dec":
            MessageLookupByLibrary.simpleMessage("January to December"),
        "jan_to_dec_desc": MessageLookupByLibrary.simpleMessage(
            "Create a group from January to December"),
        "job_description":
            MessageLookupByLibrary.simpleMessage("Job Description"),
        "job_description_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter the job title and responsibilities..."),
        "job_description_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me write a job description, the title is..."),
        "join_days": MessageLookupByLibrary.simpleMessage("Join Days"),
        "join_group_code":
            MessageLookupByLibrary.simpleMessage("Enter the list number"),
        "join_group_code_desc": MessageLookupByLibrary.simpleMessage(
            "Enter the list number to search the list"),
        "jul": MessageLookupByLibrary.simpleMessage("Jul"),
        "julFull": MessageLookupByLibrary.simpleMessage("July"),
        "jump_next_group":
            MessageLookupByLibrary.simpleMessage("Jump to Next Group"),
        "jump_previous_group":
            MessageLookupByLibrary.simpleMessage("Jump to Previous Group"),
        "jump_to_this_version":
            MessageLookupByLibrary.simpleMessage("skip this version"),
        "jun": MessageLookupByLibrary.simpleMessage("Jun"),
        "junFull": MessageLookupByLibrary.simpleMessage("June"),
        "keyword": MessageLookupByLibrary.simpleMessage("Keyword"),
        "ko": MessageLookupByLibrary.simpleMessage("한국어"),
        "label": MessageLookupByLibrary.simpleMessage("Label"),
        "landscape": MessageLookupByLibrary.simpleMessage("Landscape"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "language_setting":
            MessageLookupByLibrary.simpleMessage("Language Setting"),
        "lastWeek": MessageLookupByLibrary.simpleMessage("last week"),
        "last_7_days": MessageLookupByLibrary.simpleMessage("last 7 days"),
        "lastest_n_days": MessageLookupByLibrary.simpleMessage("Latest n Days"),
        "leave_group": MessageLookupByLibrary.simpleMessage("Leave the group"),
        "leave_reason": MessageLookupByLibrary.simpleMessage("Leave Reason"),
        "leave_reason_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter the reason for leave..."),
        "leave_reason_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me write a leave reason, the reason is..."),
        "level1_num_10":
            MessageLookupByLibrary.simpleMessage("Difficulty 1: 10 words"),
        "level1_show_words": MessageLookupByLibrary.simpleMessage(
            "Difficulty 1: Listen and watch"),
        "level2_hide_leftpart_words": MessageLookupByLibrary.simpleMessage(
            "Difficulty 2: Hide the vocabulary on the left"),
        "level2_num_20":
            MessageLookupByLibrary.simpleMessage("Difficulty 2: 20 words"),
        "level3_hide_rightpart_words": MessageLookupByLibrary.simpleMessage(
            "Difficulty 3: Hide the vocabulary on the right"),
        "level3_num_50":
            MessageLookupByLibrary.simpleMessage("Difficulty 2: 50 words"),
        "level4_hide_all_parts": MessageLookupByLibrary.simpleMessage(
            "Difficulty 4: Hide all vocabulary"),
        "level5_write_words": MessageLookupByLibrary.simpleMessage(
            "Difficulty 5: silent writing"),
        "light": MessageLookupByLibrary.simpleMessage("light"),
        "lightLightTint1": MessageLookupByLibrary.simpleMessage("Purple"),
        "lightLightTint2": MessageLookupByLibrary.simpleMessage("Pink"),
        "lightLightTint3": MessageLookupByLibrary.simpleMessage("Light Pink"),
        "lightLightTint4": MessageLookupByLibrary.simpleMessage("Orange"),
        "lightLightTint5": MessageLookupByLibrary.simpleMessage("Yellow"),
        "lightLightTint6": MessageLookupByLibrary.simpleMessage("Lime"),
        "lightLightTint7": MessageLookupByLibrary.simpleMessage("Green"),
        "lightLightTint8": MessageLookupByLibrary.simpleMessage("Aqua"),
        "lightLightTint9": MessageLookupByLibrary.simpleMessage("Blue"),
        "light_mode": MessageLookupByLibrary.simpleMessage("Light Mode"),
        "link": MessageLookupByLibrary.simpleMessage("Link"),
        "linkAddressHint":
            MessageLookupByLibrary.simpleMessage("Please enter URL"),
        "linkText": MessageLookupByLibrary.simpleMessage("Text"),
        "linkTextHint":
            MessageLookupByLibrary.simpleMessage("Please enter text"),
        "list": MessageLookupByLibrary.simpleMessage("List"),
        "listItemPlaceholder":
            MessageLookupByLibrary.simpleMessage("List item"),
        "listing": MessageLookupByLibrary.simpleMessage("Listing"),
        "listing_icon_optional":
            MessageLookupByLibrary.simpleMessage("Listing icon"),
        "listing_time_optional":
            MessageLookupByLibrary.simpleMessage("List time (optional)"),
        "listview": MessageLookupByLibrary.simpleMessage("List view"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading"),
        "local_password":
            MessageLookupByLibrary.simpleMessage("Local numeric password"),
        "local_password_desc": MessageLookupByLibrary.simpleMessage(
            "The local numeric password is only stored on the phone after encryption, and will not be uploaded to the server or synchronized with other devices. You can set the local numeric password in settings"),
        "localmoney_made_per_minute":
            MessageLookupByLibrary.simpleMessage("Gain per minute of focus"),
        "localmoney_made_per_minute_description":
            MessageLookupByLibrary.simpleMessage("for self motivation"),
        "lock_app": MessageLookupByLibrary.simpleMessage("lock Apps"),
        "lock_app_setting":
            MessageLookupByLibrary.simpleMessage("Lock Apps Setting"),
        "lock_app_setting_description": MessageLookupByLibrary.simpleMessage(
            "Locking apps can help you focus better by not being disturbed by unnecessary applications."),
        "lock_screen_auto_password_setting":
            MessageLookupByLibrary.simpleMessage(
                "Lock Screen Auto-Password Setting"),
        "lock_screen_auto_password_setting_for_applock":
            MessageLookupByLibrary.simpleMessage(
                "App lock supports lock screen password settings"),
        "lock_screen_password_setting": MessageLookupByLibrary.simpleMessage(
            "Lock Screen Password Setting"),
        "login": MessageLookupByLibrary.simpleMessage("Log in"),
        "loginContent": MessageLookupByLibrary.simpleMessage(
            "Accounts will be automatically created for new users"),
        "loginFirst":
            MessageLookupByLibrary.simpleMessage("please log in first"),
        "login_email_to_verifie": MessageLookupByLibrary.simpleMessage(
            "Confirmation email has been sent to your email, please check your email to verify and login with your password"),
        "login_or_register":
            MessageLookupByLibrary.simpleMessage("Login/Register"),
        "login_success":
            MessageLookupByLibrary.simpleMessage("login successful"),
        "logout": MessageLookupByLibrary.simpleMessage("sign out"),
        "long_rest_duration":
            MessageLookupByLibrary.simpleMessage("Long rest duration"),
        "long_rest_interval":
            MessageLookupByLibrary.simpleMessage("Long rest interval"),
        "loop_setting": MessageLookupByLibrary.simpleMessage("Loop Setting"),
        "lottery": MessageLookupByLibrary.simpleMessage("lottery"),
        "ltr": MessageLookupByLibrary.simpleMessage("LTR"),
        "lyubichs": MessageLookupByLibrary.simpleMessage("Lyubichs duration"),
        "manage": MessageLookupByLibrary.simpleMessage("Manage"),
        "manage_prompt": MessageLookupByLibrary.simpleMessage(
            "Please open the management options."),
        "manual": MessageLookupByLibrary.simpleMessage("Manual"),
        "manual_create": MessageLookupByLibrary.simpleMessage("Manual Create"),
        "mar": MessageLookupByLibrary.simpleMessage("Mar"),
        "marFull": MessageLookupByLibrary.simpleMessage("March"),
        "mark_repaid_amount":
            MessageLookupByLibrary.simpleMessage("Mark repaid amount"),
        "mark_repayment_amount":
            MessageLookupByLibrary.simpleMessage("Mark repayment amount"),
        "mastering_the_situation":
            MessageLookupByLibrary.simpleMessage("Mastering the situation"),
        "max_5m_files_size": MessageLookupByLibrary.simpleMessage(
            "File size exceeds 5MB, please select a smaller file."),
        "max_input_num": m58,
        "max_words": m59,
        "maximum_recording_time": m60,
        "may": MessageLookupByLibrary.simpleMessage("May"),
        "mayFull": MessageLookupByLibrary.simpleMessage("May"),
        "me": MessageLookupByLibrary.simpleMessage("Me"),
        "meeting_agenda":
            MessageLookupByLibrary.simpleMessage("Meeting Agenda"),
        "meeting_agenda_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter the theme or content of the meeting agenda..."),
        "meeting_agenda_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me list a meeting agenda, the meeting topic is..."),
        "memo_prompt": MessageLookupByLibrary.simpleMessage(
            "{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: Weekend Shopping List - November 5, folder_id: null, flomo_object_id: null, type: 3, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 0, wqbWrongQuestionContent: , wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: Content:\n\nFresh Fruits: Apples (around 2 kg), Oranges (1 net), Dragon Fruit (2 pcs)\nVegetables: Spinach (1 bunch), Tomatoes (5 pcs), Cucumbers (3 pcs)\nMeats: Chicken breast (500g), Beef steaks (2 pcs)\nSnacks: Potato Chips (2 bags), Chocolate (100g)\nHousehold Items: Hand soap (1 bottle), Dishwashing liquid (1 bottle), Toilet paper (1 pack)\nBeverages: Milk (1 carton), Green tea (1 pack)\n\nNotes:\n\nCheck for valid coupons and membership discounts\nPrefer organic products and eco-friendly packaging\nComplete shopping by 6:00 PM, wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}"),
        "memorandum": MessageLookupByLibrary.simpleMessage("memorandum"),
        "memorized": MessageLookupByLibrary.simpleMessage("Memorized"),
        "memorizing": MessageLookupByLibrary.simpleMessage("Memorizing"),
        "message": MessageLookupByLibrary.simpleMessage("message"),
        "method": MessageLookupByLibrary.simpleMessage("method"),
        "micro_mastery": MessageLookupByLibrary.simpleMessage("Micro Mastery"),
        "micro_mastery_desc": MessageLookupByLibrary.simpleMessage(
            "Micro Mastery\n\nWe are often told that to master something, we must pour all our passion into it and spend 10,000 hours in rigorous practice. However, in reality, most successful people, including Nobel Prize winners, use their spare time to learn new skills and start new activities.\n\nMicro Mastery can be divided into 4 parts\n1. Find Entry-Level Skills - Start with practice, not theory, based on simple attempts by industry experts\n2. Gain Background Support - Engage in something to gain motivation, buy equipment, create a sense of ceremony, etc.\n3. Create Clear Rewards - Receive positive and negative feedback, form a virtuous cycle, teach others, etc., apply what is learned, and avoid aimlessness and procrastination\n4. Create Reproducibility - Be able to repeat continuously, improve with each repetition, and make progress, which can lead to increasing confidence and a sharper observation ability\n\nSuccess Case\nSteve Jobs, who applied the calligraphy art he learned from skipping college classes globally to Mac, designing computers from an artistic perspective, which became very popular"),
        "micro_mastery_step1":
            MessageLookupByLibrary.simpleMessage("Find Entry-Level Skills"),
        "micro_mastery_step2":
            MessageLookupByLibrary.simpleMessage("Gain Background Support"),
        "micro_mastery_step3":
            MessageLookupByLibrary.simpleMessage("Create Clear Rewards"),
        "micro_mastery_step4":
            MessageLookupByLibrary.simpleMessage("Create Reproducibility"),
        "microphone_permission_description": MessageLookupByLibrary.simpleMessage(
            "You may need the recording function when taking notes, and you need to authorize the microphone permission at this time"),
        "min3": MessageLookupByLibrary.simpleMessage("Minute"),
        "minAndSec": m61,
        "min_en": MessageLookupByLibrary.simpleMessage("min"),
        "mine": MessageLookupByLibrary.simpleMessage("Mine"),
        "mins": MessageLookupByLibrary.simpleMessage("Minute"),
        "mins2": MessageLookupByLibrary.simpleMessage("Min"),
        "minsSpace": MessageLookupByLibrary.simpleMessage(" mins"),
        "miss_clockin": MessageLookupByLibrary.simpleMessage("miss"),
        "mission": MessageLookupByLibrary.simpleMessage("List"),
        "missionCompleted":
            MessageLookupByLibrary.simpleMessage("mission accomplished"),
        "missionModelDate": m62,
        "missionModelDate2": m63,
        "missionModelDate3": m64,
        "missionModelDate4": m65,
        "missionNums": MessageLookupByLibrary.simpleMessage("Number Of Tasks"),
        "missionPageInputHolder": MessageLookupByLibrary.simpleMessage(
            "Add task... (press \"Enter\" to save)"),
        "missionRunningAlert": m66,
        "missionToBeComplete":
            MessageLookupByLibrary.simpleMessage("Unfinished Tasks"),
        "mission_alert_with_name": m67,
        "mission_clocks_in_with_name": m68,
        "mission_evaluation_value": MessageLookupByLibrary.simpleMessage(
            "The mission\'s evaluation value(\$)"),
        "mission_setting":
            MessageLookupByLibrary.simpleMessage("Mission setting"),
        "mission_submission_started": m69,
        "mission_title": m70,
        "mission_value": MessageLookupByLibrary.simpleMessage("Mission value"),
        "mission_value_toast": m71,
        "missioncompleted":
            MessageLookupByLibrary.simpleMessage("Finished Tasks"),
        "mobileHeading1": MessageLookupByLibrary.simpleMessage("Heading 1"),
        "mobileHeading2": MessageLookupByLibrary.simpleMessage("Heading 2"),
        "mobileHeading3": MessageLookupByLibrary.simpleMessage("Heading 3"),
        "modern_poetry": MessageLookupByLibrary.simpleMessage("Modern Poetry"),
        "modern_poetry_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter the theme of the modern poem..."),
        "modern_poetry_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me write a modern poem, the theme is..."),
        "modify_name_listing": m72,
        "modify_name_tag": m73,
        "module_filtering_setting":
            MessageLookupByLibrary.simpleMessage("Module Filtering Setting"),
        "monday": MessageLookupByLibrary.simpleMessage("Mon"),
        "mondayShort": MessageLookupByLibrary.simpleMessage("Mon"),
        "money_not_enough_toast": MessageLookupByLibrary.simpleMessage(
            "Not enough money, please complete more focused tasks to make money"),
        "money_per_hour":
            MessageLookupByLibrary.simpleMessage("Work value per hour(\$)"),
        "month": MessageLookupByLibrary.simpleMessage("Month"),
        "monthDay": m74,
        "month_clockin_rate": m75,
        "month_clockin_record": m76,
        "month_duration_completed": MessageLookupByLibrary.simpleMessage(
            "Duration this month (minutes)"),
        "month_mission_completed": MessageLookupByLibrary.simpleMessage(
            "Number of tasks completed this month"),
        "month_tomatoes_completed": MessageLookupByLibrary.simpleMessage(
            "The number of tomatoes completed this month"),
        "monthsLater": MessageLookupByLibrary.simpleMessage("months later"),
        "more": MessageLookupByLibrary.simpleMessage("More"),
        "more_prompt": MessageLookupByLibrary.simpleMessage(
            "Please provide more writing options."),
        "move_to_next": MessageLookupByLibrary.simpleMessage("Move Right"),
        "move_to_previous": MessageLookupByLibrary.simpleMessage("Move Left"),
        "multi_select": MessageLookupByLibrary.simpleMessage("Multi select"),
        "multi_subtask": MessageLookupByLibrary.simpleMessage("Subtask"),
        "multi_view": MessageLookupByLibrary.simpleMessage("Multiple Views"),
        "multi_view_desc": MessageLookupByLibrary.simpleMessage(
            "Quadrants, categories, lists, groups, timelines, schedules, Gantt charts, calendars - various views to meet all your needs"),
        "music": MessageLookupByLibrary.simpleMessage("Music"),
        "my": m77,
        "my_answer": MessageLookupByLibrary.simpleMessage("mine"),
        "my_money_per_hour":
            MessageLookupByLibrary.simpleMessage("My work value per hour"),
        "my_ranking": m78,
        "my_ranking_this_time": m79,
        "n_days_ago": MessageLookupByLibrary.simpleMessage("n Days Ago"),
        "n_days_overdue": m80,
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "need_notification_permission_content":
            MessageLookupByLibrary.simpleMessage(
                "Need to open notification permission to use this function"),
        "need_update_username":
            MessageLookupByLibrary.simpleMessage("Username needs to be set"),
        "network_error": MessageLookupByLibrary.simpleMessage("Network error"),
        "new_card": MessageLookupByLibrary.simpleMessage("New Card"),
        "new_rich_editor":
            MessageLookupByLibrary.simpleMessage("New Rich Editor"),
        "newline": m81,
        "nextMatch": MessageLookupByLibrary.simpleMessage("Next match"),
        "nextMission": MessageLookupByLibrary.simpleMessage("Next task:"),
        "nextStep": MessageLookupByLibrary.simpleMessage("Next step"),
        "nextWeek": MessageLookupByLibrary.simpleMessage("next week"),
        "next_match": MessageLookupByLibrary.simpleMessage("Next match"),
        "next_page": MessageLookupByLibrary.simpleMessage("next page"),
        "next_time": MessageLookupByLibrary.simpleMessage("next time"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noFindResult": MessageLookupByLibrary.simpleMessage("No result"),
        "no_auth": MessageLookupByLibrary.simpleMessage("no auth"),
        "no_data": MessageLookupByLibrary.simpleMessage("No data"),
        "no_delayed_task":
            MessageLookupByLibrary.simpleMessage("no delayed task"),
        "no_microphone_permission": MessageLookupByLibrary.simpleMessage(
            "No permission of microphone, please turn on first"),
        "no_mission_desc": MessageLookupByLibrary.simpleMessage(
            "No tasks available, you need to create tasks first"),
        "no_notification_permission_title":
            MessageLookupByLibrary.simpleMessage("No Notification Permission"),
        "no_project_parenthese":
            MessageLookupByLibrary.simpleMessage("(No project)"),
        "no_ranking": MessageLookupByLibrary.simpleMessage("no ranking"),
        "no_result": MessageLookupByLibrary.simpleMessage("No result"),
        "no_task": MessageLookupByLibrary.simpleMessage("no task"),
        "no_time_limit": MessageLookupByLibrary.simpleMessage("unlimited"),
        "no_tomotoes_finished":
            MessageLookupByLibrary.simpleMessage("Total Finished Tasks"),
        "none": MessageLookupByLibrary.simpleMessage("none"),
        "normal": MessageLookupByLibrary.simpleMessage("Normal"),
        "normal_solution":
            MessageLookupByLibrary.simpleMessage("normal solution"),
        "not_completed": MessageLookupByLibrary.simpleMessage("Not Completed"),
        "not_handling":
            MessageLookupByLibrary.simpleMessage("Temporarily not processed"),
        "not_remind_again":
            MessageLookupByLibrary.simpleMessage("Don\'t remind"),
        "not_started": MessageLookupByLibrary.simpleMessage("Not started"),
        "note": MessageLookupByLibrary.simpleMessage("notes...(optional)"),
        "note2": MessageLookupByLibrary.simpleMessage("Note"),
        "note_1": MessageLookupByLibrary.simpleMessage("Note 1"),
        "note_2": MessageLookupByLibrary.simpleMessage("Note 2"),
        "note_3": MessageLookupByLibrary.simpleMessage("Note 3"),
        "note_4": MessageLookupByLibrary.simpleMessage("Note 4"),
        "note_5": MessageLookupByLibrary.simpleMessage("Note 5"),
        "note_6": MessageLookupByLibrary.simpleMessage("Note 6"),
        "note_7": MessageLookupByLibrary.simpleMessage("Note 7"),
        "note_and_multimission":
            MessageLookupByLibrary.simpleMessage("Note and multi-mission"),
        "note_diary": MessageLookupByLibrary.simpleMessage("note diary"),
        "note_n": MessageLookupByLibrary.simpleMessage("Note "),
        "note_plain": MessageLookupByLibrary.simpleMessage("note"),
        "note_prompt": MessageLookupByLibrary.simpleMessage(
            "{createdAt: null, updatedAt: null, indexSearchingStart: null, state: 0, indexSearchingEnd: null, background_url: null, title: 1. Click on the upper rig, folder_id: null, flomo_object_id: null, type: 1, masterScore: 1.0, update_time: 1699019897598, causeAnalysis: [], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 0, wqbWrongQuestionContent: , wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 0, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: , wqbAnswerRichContentUrl: , content: 1. Click on the upper right corner and select Set to Desktop Components\n2. Desktop widgets can be set up on Android, iPhone, and Mac, device_id: B5CC32ED-595A-54B7-A814-7BC911FBD2D4, tagNames: [], tagIds: null, isFinished: null, color: 4291946748, order_index: 4, status: null, priorityStatus: null, uid: 0aa14757-7695-4e52-9b23-45f839a16715}"),
        "note_short": MessageLookupByLibrary.simpleMessage("note"),
        "note_text": MessageLookupByLibrary.simpleMessage("note"),
        "notification0": MessageLookupByLibrary.simpleMessage(
            "It\'s time to make plans for tomorrow"),
        "notification1": MessageLookupByLibrary.simpleMessage(
            "Don\'t wait for opportunities, create them. Use the Pomodoro Focus app to make the most of your time."),
        "notification10": MessageLookupByLibrary.simpleMessage(
            "Believe in yourself and all that you are. Use the Pomodoro Focus app to unlock your full potential."),
        "notification11": MessageLookupByLibrary.simpleMessage(
            "Believe in yourself and all that you are. Use the Pomodoro Focus app to unlock your full potential."),
        "notification12": MessageLookupByLibrary.simpleMessage(
            "Don\'t let the fear of striking out hold you back. Use the Pomodoro Focus app to take calculated risks."),
        "notification13": MessageLookupByLibrary.simpleMessage(
            "Success is not easy, but it\'s worth it. Use the Pomodoro Focus app to keep pushing forward."),
        "notification14": MessageLookupByLibrary.simpleMessage(
            "You don\'t have to be great to start, but you have to start to be great. Use the Pomodoro Focus app to take that first step."),
        "notification15": MessageLookupByLibrary.simpleMessage(
            "The greatest glory in living lies not in never falling, but in rising every time we fall. Use the Pomodoro Focus app to persevere through failure."),
        "notification16": MessageLookupByLibrary.simpleMessage(
            "our only limit is the amount of willingness to take action. Use the Pomodoro Focus app to take action towards your goals."),
        "notification17": MessageLookupByLibrary.simpleMessage(
            "Don\'t watch the clock, do what it does: keep going. Use the Pomodoro Focus app to make the most of your time."),
        "notification18": MessageLookupByLibrary.simpleMessage(
            "What you get by achieving your goals is not as important as what you become by achieving your goals. Use the Pomodoro Focus app to become your best self."),
        "notification19": MessageLookupByLibrary.simpleMessage(
            "The greatest wealth is to live content with little. Use the Pomodoro Focus app to appreciate the simple things in life."),
        "notification2": MessageLookupByLibrary.simpleMessage(
            "Success is not final, failure is not fatal. It\'s the courage to continue that counts. Use the Pomodoro Focus app to keep going."),
        "notification20": MessageLookupByLibrary.simpleMessage(
            "Your future is created by what you do today, not tomorrow. Use the Pomodoro Focus app to take action towards your future."),
        "notification3": MessageLookupByLibrary.simpleMessage(
            "The journey of a thousand miles begins with one step. Use the Pomodoro Focus app to take that first step."),
        "notification4": MessageLookupByLibrary.simpleMessage(
            "The future belongs to those who believe in the beauty of their dreams. Use the Pomodoro Focus app to work towards your dreams."),
        "notification5": MessageLookupByLibrary.simpleMessage(
            "It\'s not about the destination, it\'s about the journey. Use the Pomodoro Focus app to make the most of every moment."),
        "notification6": MessageLookupByLibrary.simpleMessage(
            "Don\'t let yesterday take up too much of today. Use the Pomodoro Focus app to focus on the present moment."),
        "notification7": MessageLookupByLibrary.simpleMessage(
            "If you want to achieve greatness, stop asking for permission. Use the Pomodoro Focus app to take charge of your life."),
        "notification8": MessageLookupByLibrary.simpleMessage(
            "Believe you can and you\'re halfway there. Use the Pomodoro Focus app to believe in yourself."),
        "notification9": MessageLookupByLibrary.simpleMessage(
            "The only way to do great work is to love what you do. Use the Pomodoro Focus app to enjoy the journey."),
        "notificationTxt": m82,
        "notification_more": MessageLookupByLibrary.simpleMessage(
            "Customize your work content for tomorrow"),
        "notification_num_mission_to_finish": m83,
        "notification_num_mission_to_finish_delay": m84,
        "notification_setting":
            MessageLookupByLibrary.simpleMessage("Push Settings"),
        "notification_setting_content": MessageLookupByLibrary.simpleMessage(
            "Turning on notifications will help you know when tasks are completed or started"),
        "notification_title":
            MessageLookupByLibrary.simpleMessage("Come back and make plans"),
        "nov": MessageLookupByLibrary.simpleMessage("Nov"),
        "novFull": MessageLookupByLibrary.simpleMessage("November"),
        "now": MessageLookupByLibrary.simpleMessage("now"),
        "num_days": m85,
        "num_lives": MessageLookupByLibrary.simpleMessage("life value:"),
        "num_mins": m86,
        "num_mission":
            MessageLookupByLibrary.simpleMessage("Number of missions"),
        "num_mission_percent": m87,
        "num_mission_total": m88,
        "num_of_total": m89,
        "num_tasks": m90,
        "num_tasks_finished":
            MessageLookupByLibrary.simpleMessage("Total Finishing Tasks"),
        "num_times": m91,
        "num_tomatoes": m92,
        "num_unit": m93,
        "number_present": m94,
        "numberedList": MessageLookupByLibrary.simpleMessage("Numbered List"),
        "objective": MessageLookupByLibrary.simpleMessage("Purpose"),
        "oct": MessageLookupByLibrary.simpleMessage("Oct"),
        "octFull": MessageLookupByLibrary.simpleMessage("October"),
        "off": MessageLookupByLibrary.simpleMessage("OFF"),
        "offer_next_version":
            MessageLookupByLibrary.simpleMessage("offer next version"),
        "offline": MessageLookupByLibrary.simpleMessage("Offline"),
        "on": MessageLookupByLibrary.simpleMessage("ON"),
        "one_hour": MessageLookupByLibrary.simpleMessage("One hour"),
        "one_key_login": MessageLookupByLibrary.simpleMessage("Login"),
        "one_month": MessageLookupByLibrary.simpleMessage("One month"),
        "one_year": MessageLookupByLibrary.simpleMessage("One year"),
        "ongoing": MessageLookupByLibrary.simpleMessage("processing"),
        "online": MessageLookupByLibrary.simpleMessage("Online"),
        "only_me": MessageLookupByLibrary.simpleMessage("Only me"),
        "only_share_with_friends":
            MessageLookupByLibrary.simpleMessage("Only share with friends"),
        "opacity": MessageLookupByLibrary.simpleMessage("Opacity"),
        "openLink": MessageLookupByLibrary.simpleMessage("Open link"),
        "open_search_taskbar": MessageLookupByLibrary.simpleMessage(
            "Open Search Bar and Create Task Toolbar"),
        "open_sticky_note":
            MessageLookupByLibrary.simpleMessage("Open Sticky Note"),
        "optional": MessageLookupByLibrary.simpleMessage("optional"),
        "optional_with_parenthese":
            MessageLookupByLibrary.simpleMessage("(optional)"),
        "order_by_created_time":
            MessageLookupByLibrary.simpleMessage("Sort by created time"),
        "order_by_end_time":
            MessageLookupByLibrary.simpleMessage("Sort by end time"),
        "order_by_list": MessageLookupByLibrary.simpleMessage("Sort by list"),
        "order_by_mission_priority":
            MessageLookupByLibrary.simpleMessage("Sort by task priority"),
        "order_by_mission_tag":
            MessageLookupByLibrary.simpleMessage("order by mission tag"),
        "order_by_time": MessageLookupByLibrary.simpleMessage("Sort by time"),
        "order_by_update_time": MessageLookupByLibrary.simpleMessage(
            "order by update time(Suitable for work report)"),
        "original_text": MessageLookupByLibrary.simpleMessage(
            "Original Text: The government is actively taking measures to address the increasingly serious environmental issues, including strengthening the enforcement of environmental regulations, raising public environmental awareness, and promoting the development of green energy."),
        "other_login_mode":
            MessageLookupByLibrary.simpleMessage("Other login model"),
        "others": MessageLookupByLibrary.simpleMessage("others"),
        "outline": MessageLookupByLibrary.simpleMessage("Outline"),
        "outline_placeholder": MessageLookupByLibrary.simpleMessage(
            "(Example) Please list an outline on the theme of environmental protection."),
        "outline_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me list an outline about..."),
        "overdue_buffer": MessageLookupByLibrary.simpleMessage("overdue"),
        "password": MessageLookupByLibrary.simpleMessage("password"),
        "passwordNotEmpty":
            MessageLookupByLibrary.simpleMessage("password can not be blank"),
        "password_at_least_6": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters"),
        "password_correct":
            MessageLookupByLibrary.simpleMessage("Password is correct"),
        "password_correct_desc": MessageLookupByLibrary.simpleMessage(
            "The local password is correct, you can directly create tasks"),
        "password_incorrect":
            MessageLookupByLibrary.simpleMessage("Password is incorrect"),
        "password_not_empty": MessageLookupByLibrary.simpleMessage(
            "Password cannot be empty, please enter the password!"),
        "password_required_for_sharing": MessageLookupByLibrary.simpleMessage(
            "Password required for sharing files"),
        "password_set_success":
            MessageLookupByLibrary.simpleMessage("Password set successfully"),
        "paste": MessageLookupByLibrary.simpleMessage("Paste"),
        "pause": MessageLookupByLibrary.simpleMessage("pause"),
        "pc_not_available": MessageLookupByLibrary.simpleMessage(
            "MAC or PC cannot support this function temporarily, please use mobile phone to operate"),
        "pdpa": MessageLookupByLibrary.simpleMessage("PDCA"),
        "pdpa_desc": MessageLookupByLibrary.simpleMessage(
            "P (Planning) - Planning function includes three parts: goal, plan, and budget.\nD (Design) - Design solutions and layouts.\nC (4C) - 4C management: Check, Communicate, Clean, Control.\nA (2A) - Act (execute, deal with the results of the summary check), Aim (act according to the goal requirements, such as improvement, enhancement)."),
        "pdpa_step1": MessageLookupByLibrary.simpleMessage("Plan"),
        "pdpa_step2": MessageLookupByLibrary.simpleMessage("Do"),
        "pdpa_step3": MessageLookupByLibrary.simpleMessage("Check"),
        "pdpa_step4": MessageLookupByLibrary.simpleMessage("Action"),
        "permission_setting":
            MessageLookupByLibrary.simpleMessage("Permission settings"),
        "phoneNo": MessageLookupByLibrary.simpleMessage("phone number"),
        "pin": MessageLookupByLibrary.simpleMessage("Pin"),
        "plain_text": MessageLookupByLibrary.simpleMessage("plain text"),
        "play": MessageLookupByLibrary.simpleMessage("play"),
        "pleaseInputTitle":
            MessageLookupByLibrary.simpleMessage("Please enter a title"),
        "pleaseSelectColor":
            MessageLookupByLibrary.simpleMessage("please choose a color"),
        "please_confirm_your_password": MessageLookupByLibrary.simpleMessage(
            "Please confirm your password"),
        "please_create_ur_password":
            MessageLookupByLibrary.simpleMessage("please create your password"),
        "please_enter_6_digit_password": MessageLookupByLibrary.simpleMessage(
            "Please enter a 6-digit password"),
        "please_enter_ur_password":
            MessageLookupByLibrary.simpleMessage("please enter your password"),
        "please_enter_your_question":
            MessageLookupByLibrary.simpleMessage("please enter your questing"),
        "please_finish_msn": MessageLookupByLibrary.simpleMessage(
            "Please complete SMS password verification"),
        "please_input_bill_amount": MessageLookupByLibrary.simpleMessage(
            "Please enter the bill amount"),
        "please_input_content":
            MessageLookupByLibrary.simpleMessage("please input content"),
        "please_input_correct_email":
            MessageLookupByLibrary.simpleMessage("Please enter a valid email"),
        "please_input_correct_password": MessageLookupByLibrary.simpleMessage(
            "please input correct password"),
        "please_input_email":
            MessageLookupByLibrary.simpleMessage("Please enter your email"),
        "please_input_first_gpt_sentence":
            MessageLookupByLibrary.simpleMessage("Please input your question"),
        "please_input_folder_password": m95,
        "please_input_keyword":
            MessageLookupByLibrary.simpleMessage("Please input task keyword"),
        "please_input_mission_title": MessageLookupByLibrary.simpleMessage(
            "Please input the mission title"),
        "please_input_mobile_no":
            MessageLookupByLibrary.simpleMessage("please input mobile"),
        "please_input_password":
            MessageLookupByLibrary.simpleMessage("please input password"),
        "please_input_question": MessageLookupByLibrary.simpleMessage(
            "Please enter the question you want to ask"),
        "please_input_search_mission": MessageLookupByLibrary.simpleMessage(
            "Please enter the mission title you want to search"),
        "please_input_the_mission_title":
            MessageLookupByLibrary.simpleMessage("please input the task title"),
        "please_input_title":
            MessageLookupByLibrary.simpleMessage("Please enter a title"),
        "please_input_xxx_name": m96,
        "please_input_your_username": MessageLookupByLibrary.simpleMessage(
            "Please set the username first"),
        "please_origin_password": MessageLookupByLibrary.simpleMessage(
            "Please input the original password"),
        "please_seaarch_on_app_store": m97,
        "please_select_at_least_one_option_in_repeat_cycle":
            MessageLookupByLibrary.simpleMessage(
                "Please select at least one option in the repeat cycle"),
        "please_select_attachment":
            MessageLookupByLibrary.simpleMessage("Please select attachment"),
        "please_select_content": m98,
        "please_select_daily_start_time":
            MessageLookupByLibrary.simpleMessage("please select start time"),
        "please_select_date": MessageLookupByLibrary.simpleMessage(
            "Please select the search date"),
        "please_select_daterange": MessageLookupByLibrary.simpleMessage(
            "Please select the search date range"),
        "please_select_month": MessageLookupByLibrary.simpleMessage(
            "Please select the search month"),
        "please_select_year_to_search": MessageLookupByLibrary.simpleMessage(
            "Please select the search year"),
        "pomodoro_shortcuts":
            MessageLookupByLibrary.simpleMessage("Pomodoro Shortcuts"),
        "popup_invisible3": MessageLookupByLibrary.simpleMessage("Hide"),
        "popup_select1":
            MessageLookupByLibrary.simpleMessage("Display Content"),
        "popup_visible2": MessageLookupByLibrary.simpleMessage("Show"),
        "postpone": MessageLookupByLibrary.simpleMessage("Postpone to today"),
        "practice": MessageLookupByLibrary.simpleMessage("Train"),
        "present_value_dialog": m99,
        "press_release": MessageLookupByLibrary.simpleMessage("Press Release"),
        "press_release_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter the content or theme of the press release..."),
        "press_release_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me write a press release, the content is..."),
        "preview": MessageLookupByLibrary.simpleMessage("Preview"),
        "previewTime": MessageLookupByLibrary.simpleMessage("Estimated Time"),
        "previewTomatoesNum": MessageLookupByLibrary.simpleMessage(
            "Estimated number of tomatoes"),
        "previousMatch": MessageLookupByLibrary.simpleMessage("Previous match"),
        "previous_match":
            MessageLookupByLibrary.simpleMessage("Previous match"),
        "previous_page": MessageLookupByLibrary.simpleMessage("previous page"),
        "print": MessageLookupByLibrary.simpleMessage("Print"),
        "priority": MessageLookupByLibrary.simpleMessage("priority"),
        "priority1": MessageLookupByLibrary.simpleMessage("imp. & urg."),
        "priority2": MessageLookupByLibrary.simpleMessage("not imp. & urg."),
        "priority3": MessageLookupByLibrary.simpleMessage("imp. & not urg."),
        "priority4":
            MessageLookupByLibrary.simpleMessage("not imp. & not urg."),
        "priorityStatus": MessageLookupByLibrary.simpleMessage("Priority:"),
        "priority_distribution_of_completion_plan":
            MessageLookupByLibrary.simpleMessage("Completion plan priority"),
        "priority_distribution_of_uncompletion_plan":
            MessageLookupByLibrary.simpleMessage("Unfinished plan priority"),
        "privacy": MessageLookupByLibrary.simpleMessage("privacy"),
        "privacy_management":
            MessageLookupByLibrary.simpleMessage("privacy management"),
        "privacy_pattern":
            MessageLookupByLibrary.simpleMessage("Privacy Policy"),
        "privacy_protocol_content": MessageLookupByLibrary.simpleMessage(
            "Thank you for trusting and using this product. We attach great importance to your privacy protection and personal information protection,\\n\\nPlease read all the terms of the \"Privacy Policy\" carefully. Learn about what we do to protect your information\\nSpecific measures and commitments, agree and accept all the terms before starting to use our services.\\nWe will collect it in business scenarios such as account registration. In the process of using this product step by step, you will need to enable corresponding device permissions according to different business scenarios, such as location information, camera permissions, etc."),
        "privacy_protocol_content2": MessageLookupByLibrary.simpleMessage(
            "We attach great importance to your privacy protection and personal information protection, and will adopt leading security measures to protect your information security. If you continue to use our services, you agree to collect, use and protect your personal information in accordance with the \"Privacy Policy\". If you do not agree to the above content, you can choose to stop using it."),
        "privacy_protocol_title":
            MessageLookupByLibrary.simpleMessage("Privacy Agreement"),
        "private": MessageLookupByLibrary.simpleMessage("private"),
        "projectStatistic":
            MessageLookupByLibrary.simpleMessage("Project Statistics"),
        "pros_and_cons": MessageLookupByLibrary.simpleMessage("Pros and Cons"),
        "pros_and_cons_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter the topic for which the pros and cons need to be analyzed..."),
        "pros_and_cons_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me list the pros and cons of a topic, the topic is..."),
        "public_course":
            MessageLookupByLibrary.simpleMessage("Training Program"),
        "publish": MessageLookupByLibrary.simpleMessage("Publish"),
        "pure_mode": MessageLookupByLibrary.simpleMessage("Pure mode"),
        "push_counter_status_notification": m100,
        "qq_friends": MessageLookupByLibrary.simpleMessage("QQ friends"),
        "qq_share": MessageLookupByLibrary.simpleMessage("QQ share"),
        "question_mistake":
            MessageLookupByLibrary.simpleMessage("Question/Mistake"),
        "question_wrong_question":
            MessageLookupByLibrary.simpleMessage("Question/Wrong Question"),
        "quote": MessageLookupByLibrary.simpleMessage("Quote"),
        "random_by_alphabet":
            MessageLookupByLibrary.simpleMessage("alphabet challenge"),
        "random_by_alphabetAndNumber": MessageLookupByLibrary.simpleMessage(
            "Alphabet and Number Challenge"),
        "random_by_alphabetAndNumber_lowercase_capital":
            MessageLookupByLibrary.simpleMessage(
                "Alphabet (case insensitive) and number challenge"),
        "random_by_alphabet_lowercase_capital":
            MessageLookupByLibrary.simpleMessage(
                "Alphabet challenge (case insensitive)"),
        "random_by_number":
            MessageLookupByLibrary.simpleMessage("digital challenge"),
        "ranking": MessageLookupByLibrary.simpleMessage("ranking"),
        "rating_guide": MessageLookupByLibrary.simpleMessage(
            "If you think it\'s good, give us a 5-star review or suggestion 😄"),
        "ready_to_download":
            MessageLookupByLibrary.simpleMessage("ready to download"),
        "readying": MessageLookupByLibrary.simpleMessage("preparing"),
        "recommended_Target":
            MessageLookupByLibrary.simpleMessage("Recommended Target"),
        "record": MessageLookupByLibrary.simpleMessage("record"),
        "refuse": MessageLookupByLibrary.simpleMessage("reject"),
        "regex": MessageLookupByLibrary.simpleMessage("Regex"),
        "regexError": MessageLookupByLibrary.simpleMessage("Regex Error"),
        "register": MessageLookupByLibrary.simpleMessage("register"),
        "registerStep1": MessageLookupByLibrary.simpleMessage(
            "Please enter your mobile phone number to complete the registration, and you can enjoy an efficient life"),
        "registerStep2": MessageLookupByLibrary.simpleMessage(
            "Please enter your mobile phone number to complete the registration, and you can enjoy an efficient life"),
        "relaxing": MessageLookupByLibrary.simpleMessage("Relaxing"),
        "remarks_optional":
            MessageLookupByLibrary.simpleMessage("Remarks (optional)"),
        "remind": MessageLookupByLibrary.simpleMessage("hint"),
        "reminder": MessageLookupByLibrary.simpleMessage("Reminder"),
        "removeLink": MessageLookupByLibrary.simpleMessage("Remove link"),
        "remove_user": MessageLookupByLibrary.simpleMessage("Remove user"),
        "rename": MessageLookupByLibrary.simpleMessage("Rename"),
        "repaid": MessageLookupByLibrary.simpleMessage("Repaid"),
        "repayment": MessageLookupByLibrary.simpleMessage("Repayment"),
        "repayment_channel":
            MessageLookupByLibrary.simpleMessage("Repayment channel"),
        "repayment_day": MessageLookupByLibrary.simpleMessage("Repayment day"),
        "repayment_instantly":
            MessageLookupByLibrary.simpleMessage("Repayment instantly"),
        "repayment_record":
            MessageLookupByLibrary.simpleMessage("Repayment record"),
        "repeat": MessageLookupByLibrary.simpleMessage("repeat"),
        "repeat_period": MessageLookupByLibrary.simpleMessage("Repeat Period"),
        "repeative1": MessageLookupByLibrary.simpleMessage("Daily"),
        "repeative2": MessageLookupByLibrary.simpleMessage("Weekly"),
        "repeative3": MessageLookupByLibrary.simpleMessage("Ebbinghaus"),
        "repeative_by_day":
            MessageLookupByLibrary.simpleMessage("repeat by day"),
        "repeative_by_month":
            MessageLookupByLibrary.simpleMessage("repeat by month"),
        "repeative_by_week":
            MessageLookupByLibrary.simpleMessage("repeat by week"),
        "repeative_by_year":
            MessageLookupByLibrary.simpleMessage("repeat by year"),
        "repeative_content": m101,
        "repetive": MessageLookupByLibrary.simpleMessage("Repeat"),
        "repetiveType": MessageLookupByLibrary.simpleMessage("Repeative Type"),
        "repetiveValue":
            MessageLookupByLibrary.simpleMessage("Repeative Value"),
        "repetiveWeekDay":
            MessageLookupByLibrary.simpleMessage("Repeative Days"),
        "replace": MessageLookupByLibrary.simpleMessage("Replace"),
        "replaceAll": MessageLookupByLibrary.simpleMessage("Replace all"),
        "replace_all": MessageLookupByLibrary.simpleMessage("Replace all"),
        "reply": MessageLookupByLibrary.simpleMessage("reply"),
        "report2": MessageLookupByLibrary.simpleMessage("Report"),
        "request_error_try_again": MessageLookupByLibrary.simpleMessage(
            "request error, please try again"),
        "request_fail": MessageLookupByLibrary.simpleMessage("request fail"),
        "request_permission":
            MessageLookupByLibrary.simpleMessage("Request permission"),
        "requesting_please_wait":
            MessageLookupByLibrary.simpleMessage("requesting, please wait"),
        "resetToDefaultColor":
            MessageLookupByLibrary.simpleMessage("Reset to default color"),
        "reset_password_has_been_sent": MessageLookupByLibrary.simpleMessage(
            "Password reset email has been sent to your email"),
        "reset_pwd": MessageLookupByLibrary.simpleMessage("reset password"),
        "reset_pwd_successful":
            MessageLookupByLibrary.simpleMessage("reset password successfully"),
        "reset_to_login_page": MessageLookupByLibrary.simpleMessage(
            "Password set successfully, go to login"),
        "rest": MessageLookupByLibrary.simpleMessage("rest"),
        "restPausing": MessageLookupByLibrary.simpleMessage("Pause"),
        "rest_completed_auto_start_play": MessageLookupByLibrary.simpleMessage(
            "Automatically start playing after rest is completed"),
        "rest_duration": MessageLookupByLibrary.simpleMessage("Rest time"),
        "rest_focus_duration_with_value": m102,
        "rest_focus_numbers_with_value": m103,
        "resting": MessageLookupByLibrary.simpleMessage("resting"),
        "restingFinished":
            MessageLookupByLibrary.simpleMessage("break complete"),
        "resting_music":
            MessageLookupByLibrary.simpleMessage("music during break"),
        "resting_stopping_ringtone":
            MessageLookupByLibrary.simpleMessage("end of break bell"),
        "resume": MessageLookupByLibrary.simpleMessage("resume"),
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "revised_text": MessageLookupByLibrary.simpleMessage(
            "Revised Text: The government is strengthening environmental regulations, raising public awareness, and promoting green energy to address environmental issues."),
        "rich_text": MessageLookupByLibrary.simpleMessage("rich text"),
        "rmb": MessageLookupByLibrary.simpleMessage("currency"),
        "role_chatgpt_msg": m104,
        "role_message_placehodler": MessageLookupByLibrary.simpleMessage(
            "Please input the work plan (please describe the approximate time, work content, etc.)"),
        "role_prompts_chatgpt_msg": MessageLookupByLibrary.simpleMessage(
            "I want you to act as an intelligent input method, returning an array of phrases List<String> that the user might input based on the prompt. The array should contain no more than 20 items and must cover the words input by the user (Note: We are not discussing the entire history)."),
        "role_time_manager":
            MessageLookupByLibrary.simpleMessage("Time Manager"),
        "rowAddAfter": MessageLookupByLibrary.simpleMessage("Add after"),
        "rowAddBefore": MessageLookupByLibrary.simpleMessage("Add before"),
        "rowClear": MessageLookupByLibrary.simpleMessage("Clear Content"),
        "rowDuplicate": MessageLookupByLibrary.simpleMessage("Duplicate"),
        "rowRemove": MessageLookupByLibrary.simpleMessage("Remove"),
        "rtl": MessageLookupByLibrary.simpleMessage("RTL"),
        "rules_for_ai": MessageLookupByLibrary.simpleMessage("RULES FOR AI"),
        "rusty": MessageLookupByLibrary.simpleMessage("rusty"),
        "sales": MessageLookupByLibrary.simpleMessage("sales"),
        "sales_amount": MessageLookupByLibrary.simpleMessage("sales amount"),
        "same_treatment":
            MessageLookupByLibrary.simpleMessage("Same Treatment"),
        "saturday": MessageLookupByLibrary.simpleMessage("Sat"),
        "saturdayShort": MessageLookupByLibrary.simpleMessage("Sat"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "save_as_template":
            MessageLookupByLibrary.simpleMessage("Save as Template"),
        "save_fail": MessageLookupByLibrary.simpleMessage("Save failed"),
        "save_failure": MessageLookupByLibrary.simpleMessage("Save Failed"),
        "save_img_success":
            MessageLookupByLibrary.simpleMessage("Image saved successfully"),
        "save_success": MessageLookupByLibrary.simpleMessage("Save Successful"),
        "saving": MessageLookupByLibrary.simpleMessage("Saving"),
        "saving_img": MessageLookupByLibrary.simpleMessage("Saving image"),
        "schedule": MessageLookupByLibrary.simpleMessage("Calendar"),
        "screen_rorate": MessageLookupByLibrary.simpleMessage("Rotate screen"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "search_chart_by_gpt": MessageLookupByLibrary.simpleMessage("Chart"),
        "search_chart_listing_title_content":
            MessageLookupByLibrary.simpleMessage(
                "Give me chart\nListing:\nTime:"),
        "search_chart_listingtitle":
            MessageLookupByLibrary.simpleMessage("Give me listing chart"),
        "search_chart_title":
            MessageLookupByLibrary.simpleMessage("Give me chart"),
        "search_chart_title_content":
            MessageLookupByLibrary.simpleMessage("Give me chart\nTime:"),
        "search_country":
            MessageLookupByLibrary.simpleMessage("Search Country"),
        "search_listing_by_gpt":
            MessageLookupByLibrary.simpleMessage("Search Listings & Missions"),
        "search_listing_content": MessageLookupByLibrary.simpleMessage(
            "Give me listing data:\nListing Title:\nDescription:"),
        "search_listing_title":
            MessageLookupByLibrary.simpleMessage("Give me listing data"),
        "sec": MessageLookupByLibrary.simpleMessage("Second"),
        "see": MessageLookupByLibrary.simpleMessage("detail"),
        "selectMission": MessageLookupByLibrary.simpleMessage("pick list"),
        "selectTag": MessageLookupByLibrary.simpleMessage("select tab"),
        "selectThemeColor":
            MessageLookupByLibrary.simpleMessage("Choose theme color"),
        "selectThemeColorDesc": MessageLookupByLibrary.simpleMessage(
            "After selecting the theme color, restart the app to change the theme color ^^"),
        "select_all": MessageLookupByLibrary.simpleMessage("Select All"),
        "select_avatar":
            MessageLookupByLibrary.simpleMessage("Please select an avatar"),
        "select_background_color":
            MessageLookupByLibrary.simpleMessage("Select Background Color"),
        "select_contents":
            MessageLookupByLibrary.simpleMessage("Select content"),
        "select_lottery": MessageLookupByLibrary.simpleMessage("lottery"),
        "select_prize": MessageLookupByLibrary.simpleMessage("select rewards"),
        "select_repeat_option": MessageLookupByLibrary.simpleMessage(
            "Please select at least one option in the repeat cycle"),
        "select_ringtone": MessageLookupByLibrary.simpleMessage("select sound"),
        "select_scenario": MessageLookupByLibrary.simpleMessage(
            "Select from the following scenarios or tell AI how to edit"),
        "send_again": MessageLookupByLibrary.simpleMessage("send again"),
        "sep": MessageLookupByLibrary.simpleMessage("Sep"),
        "sepFull": MessageLookupByLibrary.simpleMessage("September"),
        "set_6_digit_password":
            MessageLookupByLibrary.simpleMessage("Set a 6-digit password"),
        "set_password_for_group": MessageLookupByLibrary.simpleMessage(
            "Set a password for the group. Users need to enter the password to join the group list."),
        "set_to_desktop_widget":
            MessageLookupByLibrary.simpleMessage("Set to desktop widget"),
        "setting": MessageLookupByLibrary.simpleMessage("Setting"),
        "setting_administrator":
            MessageLookupByLibrary.simpleMessage("Set as administrator"),
        "setting_fail": MessageLookupByLibrary.simpleMessage("Setup failed"),
        "setting_success":
            MessageLookupByLibrary.simpleMessage("successfully set"),
        "share": MessageLookupByLibrary.simpleMessage("share"),
        "share_the_link": m105,
        "share_to": MessageLookupByLibrary.simpleMessage("Share to"),
        "sharing_course":
            MessageLookupByLibrary.simpleMessage("sharing course"),
        "sharing_listing":
            MessageLookupByLibrary.simpleMessage("Sharing listing"),
        "shortcut_setting":
            MessageLookupByLibrary.simpleMessage("Shortcut Settings"),
        "shorten": MessageLookupByLibrary.simpleMessage("Shorten"),
        "shorten_prompt": MessageLookupByLibrary.simpleMessage(
            "Please rewrite the selected paragraph to make it more concise while retaining its original meaning."),
        "simplify_language":
            MessageLookupByLibrary.simpleMessage("Simplify Language"),
        "simplify_language_prompt": MessageLookupByLibrary.simpleMessage(
            "Please simplify the language of the selected paragraph to make it easier to understand."),
        "six_hours": MessageLookupByLibrary.simpleMessage("Six hours"),
        "six_months": MessageLookupByLibrary.simpleMessage("Six months"),
        "skilled": MessageLookupByLibrary.simpleMessage("skilled"),
        "slashPlaceHolder": MessageLookupByLibrary.simpleMessage(
            "Enter a / to insert a block, or start typing"),
        "slide_left_right":
            MessageLookupByLibrary.simpleMessage("Sliding left and right"),
        "smsVerificationCode":
            MessageLookupByLibrary.simpleMessage("SMS verification code"),
        "sort": MessageLookupByLibrary.simpleMessage("Sort"),
        "sound_recording":
            MessageLookupByLibrary.simpleMessage("sound recording"),
        "speech": MessageLookupByLibrary.simpleMessage("Speech"),
        "speech_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter the theme or content of the speech..."),
        "speech_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me write a speech about..."),
        "startFocusing": MessageLookupByLibrary.simpleMessage("start to focus"),
        "startResting": MessageLookupByLibrary.simpleMessage("start to rest"),
        "start_date": MessageLookupByLibrary.simpleMessage("Start Date"),
        "start_focus": MessageLookupByLibrary.simpleMessage("Start Focusing"),
        "start_focusing_mission_name": m106,
        "start_resting_name": m107,
        "start_time": MessageLookupByLibrary.simpleMessage("Start time"),
        "status_complete": MessageLookupByLibrary.simpleMessage("processed"),
        "status_developping":
            MessageLookupByLibrary.simpleMessage("In development"),
        "status_handling": MessageLookupByLibrary.simpleMessage("Processing"),
        "status_waiting":
            MessageLookupByLibrary.simpleMessage("waiting for processing"),
        "stop": MessageLookupByLibrary.simpleMessage("stop"),
        "stop_focusing_mission_name": m108,
        "stop_resting_mission_name": m109,
        "strikethrough": MessageLookupByLibrary.simpleMessage("Strikethrough"),
        "sub_task_add_newline": MessageLookupByLibrary.simpleMessage(
            "Subtask - Add&update By Clicking Enter"),
        "submisssion": MessageLookupByLibrary.simpleMessage("subtask"),
        "submit": MessageLookupByLibrary.simpleMessage("submit"),
        "successfully_copied_to_clipboard":
            MessageLookupByLibrary.simpleMessage(
                "Successfully copied to clipboard"),
        "summarize": MessageLookupByLibrary.simpleMessage("Summarize"),
        "summarize_prompt": MessageLookupByLibrary.simpleMessage(
            "Please summarize the main points of the selected paragraph."),
        "summary": MessageLookupByLibrary.simpleMessage("summary"),
        "sunday": MessageLookupByLibrary.simpleMessage("sun"),
        "sundayShort": MessageLookupByLibrary.simpleMessage("Sun"),
        "super_notebook": MessageLookupByLibrary.simpleMessage("S-Note"),
        "super_tool": MessageLookupByLibrary.simpleMessage("Super Toolbar"),
        "super_tool_shortcuts":
            MessageLookupByLibrary.simpleMessage("Super Tool Shortcuts"),
        "switch_chronograph_mode_success": MessageLookupByLibrary.simpleMessage(
            "Switch to chronograph mode, will work next time"),
        "switch_font": MessageLookupByLibrary.simpleMessage("Switch font"),
        "switch_mode": MessageLookupByLibrary.simpleMessage("Switch Mode"),
        "switch_style": MessageLookupByLibrary.simpleMessage("Switch Style"),
        "switch_style_prompt": MessageLookupByLibrary.simpleMessage(
            "Please change the writing style of the selected paragraph, such as formal, informal, academic, or humorous."),
        "switch_timer_mode_success": MessageLookupByLibrary.simpleMessage(
            "Switch to timer mode, will work next time"),
        "sync_desktop_widget":
            MessageLookupByLibrary.simpleMessage("Sync desktop widget"),
        "sync_desktop_widget_success": MessageLookupByLibrary.simpleMessage(
            "Desktop widget synced successfully, please confirm adding the desktop widget"),
        "table": MessageLookupByLibrary.simpleMessage("Table"),
        "tag": MessageLookupByLibrary.simpleMessage("Tag"),
        "tagNames": MessageLookupByLibrary.simpleMessage("Tags"),
        "target_details":
            MessageLookupByLibrary.simpleMessage("Target Details"),
        "target_duration_period":
            MessageLookupByLibrary.simpleMessage("Target Duration Period"),
        "target_reward": MessageLookupByLibrary.simpleMessage("Target Reward"),
        "target_time": MessageLookupByLibrary.simpleMessage("Target Time"),
        "task": MessageLookupByLibrary.simpleMessage("Task"),
        "task_activity": MessageLookupByLibrary.simpleMessage("Task Activity"),
        "tasks_list": MessageLookupByLibrary.simpleMessage("Task List"),
        "text": MessageLookupByLibrary.simpleMessage("Text"),
        "textAlignCenter": MessageLookupByLibrary.simpleMessage("Align Center"),
        "textAlignLeft": MessageLookupByLibrary.simpleMessage("Align Left"),
        "textAlignRight": MessageLookupByLibrary.simpleMessage("Align Right"),
        "textColor": MessageLookupByLibrary.simpleMessage("Text Color"),
        "theme": MessageLookupByLibrary.simpleMessage("Theme"),
        "thirty_mins": MessageLookupByLibrary.simpleMessage("Thirty minutes"),
        "thisWeek": MessageLookupByLibrary.simpleMessage("this week"),
        "this_mission_is_cycle_mission": MessageLookupByLibrary.simpleMessage(
            "This mission is a cycle mission"),
        "this_month_plan":
            MessageLookupByLibrary.simpleMessage("This Month\'s Plan"),
        "this_week": MessageLookupByLibrary.simpleMessage("This Week"),
        "thisweek": MessageLookupByLibrary.simpleMessage("this week"),
        "three_hours": MessageLookupByLibrary.simpleMessage("Three hours"),
        "three_months": MessageLookupByLibrary.simpleMessage("Three months"),
        "thursday": MessageLookupByLibrary.simpleMessage("Thu"),
        "thursdayShort": MessageLookupByLibrary.simpleMessage("Thu"),
        "time": MessageLookupByLibrary.simpleMessage("time"),
        "time_ago": m110,
        "time_finished": MessageLookupByLibrary.simpleMessage("Finished Time "),
        "time_later": m111,
        "time_management": MessageLookupByLibrary.simpleMessage("time"),
        "time_mode": MessageLookupByLibrary.simpleMessage("mode"),
        "time_not_arrive_cannot_clcokin": MessageLookupByLibrary.simpleMessage(
            "The time has not arrived, you cannot clock in"),
        "time_segment": MessageLookupByLibrary.simpleMessage("Time segment"),
        "timefocused": MessageLookupByLibrary.simpleMessage("Focus Duration"),
        "timehello": m112,
        "timeline": MessageLookupByLibrary.simpleMessage("Timeline"),
        "timelineview": MessageLookupByLibrary.simpleMessage("Timeline view"),
        "timer": MessageLookupByLibrary.simpleMessage("timer"),
        "times": MessageLookupByLibrary.simpleMessage("times"),
        "tint1": MessageLookupByLibrary.simpleMessage("Tint 1"),
        "tint2": MessageLookupByLibrary.simpleMessage("Tint 2"),
        "tint3": MessageLookupByLibrary.simpleMessage("Tint 3"),
        "tint4": MessageLookupByLibrary.simpleMessage("Tint 4"),
        "tint5": MessageLookupByLibrary.simpleMessage("Tint 5"),
        "tint6": MessageLookupByLibrary.simpleMessage("Tint 6"),
        "tint7": MessageLookupByLibrary.simpleMessage("Tint 7"),
        "tint8": MessageLookupByLibrary.simpleMessage("Tint 8"),
        "tint9": MessageLookupByLibrary.simpleMessage("Tint 9"),
        "tipsAlertTone":
            MessageLookupByLibrary.simpleMessage("Reminder ringtone"),
        "title": MessageLookupByLibrary.simpleMessage("Title"),
        "title_consume":
            MessageLookupByLibrary.simpleMessage("Amount of consumption"),
        "title_data": m113,
        "toDoPlaceholder": MessageLookupByLibrary.simpleMessage("To-do"),
        "to_login": MessageLookupByLibrary.simpleMessage("Go to Login Page"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "today_data": MessageLookupByLibrary.simpleMessage("Today\'s data"),
        "today_duration_completed":
            MessageLookupByLibrary.simpleMessage("Duration today (minutes)"),
        "today_focus_duration":
            MessageLookupByLibrary.simpleMessage("Today\'s Focus Duration"),
        "today_focus_record":
            MessageLookupByLibrary.simpleMessage("Today\'s Focus Record"),
        "today_mission_completed": MessageLookupByLibrary.simpleMessage(
            "The number of tasks completed today"),
        "today_tomatoes_completed": MessageLookupByLibrary.simpleMessage(
            "Complete the tomato count today"),
        "todo_list": MessageLookupByLibrary.simpleMessage("To-Do List"),
        "todo_list_desc": MessageLookupByLibrary.simpleMessage(
            "Clear and concise, constantly reminding"),
        "todo_list_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter today\'s to-do items..."),
        "todo_list_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me list today\'s to-do list..."),
        "todo_list_shortcuts":
            MessageLookupByLibrary.simpleMessage("Todo List Shortcuts"),
        "todo_listing": MessageLookupByLibrary.simpleMessage("To-Do List"),
        "tokenExpired": MessageLookupByLibrary.simpleMessage(
            "Login invalid, please log in again"),
        "tomato": MessageLookupByLibrary.simpleMessage("tomato"),
        "tomatoClock": MessageLookupByLibrary.simpleMessage("Pomodoro"),
        "tomatoClockSetting":
            MessageLookupByLibrary.simpleMessage("pomodoro setting"),
        "tomatoNums": MessageLookupByLibrary.simpleMessage("Focus Times"),
        "tomatoNums2": MessageLookupByLibrary.simpleMessage("Focus Times"),
        "tomatoNums3": MessageLookupByLibrary.simpleMessage("(Tomato Count)"),
        "tomato_duration":
            MessageLookupByLibrary.simpleMessage("Focused Duration"),
        "tomatoesDuration":
            MessageLookupByLibrary.simpleMessage("Pomodoro Duration"),
        "tomorrow": MessageLookupByLibrary.simpleMessage("Tomorrow"),
        "totalTime": MessageLookupByLibrary.simpleMessage("Focus Duration"),
        "totalTimeMinute":
            MessageLookupByLibrary.simpleMessage("Total duration (minutes)"),
        "total_focus_duration":
            MessageLookupByLibrary.simpleMessage("Total focus time"),
        "total_focus_time":
            MessageLookupByLibrary.simpleMessage("focus duration"),
        "total_maju": m114,
        "total_tasks_count":
            MessageLookupByLibrary.simpleMessage("total tasks(Total Tomatoes)"),
        "total_tomatoes": m115,
        "total_tomotoes":
            MessageLookupByLibrary.simpleMessage("Total Tomatoes"),
        "trainee_advice_notice": m116,
        "trainee_give_your_advice": m117,
        "training_plan_edit":
            MessageLookupByLibrary.simpleMessage("Training Plan Edit"),
        "transaction": MessageLookupByLibrary.simpleMessage("trans."),
        "translate": MessageLookupByLibrary.simpleMessage("Translate"),
        "translate_prompt": MessageLookupByLibrary.simpleMessage(
            "Please translate the selected paragraph into English."),
        "try_again": MessageLookupByLibrary.simpleMessage(
            "Request error, please try again"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Tue"),
        "tuesdayShort": MessageLookupByLibrary.simpleMessage("Tue"),
        "twelve_12hours": MessageLookupByLibrary.simpleMessage("Twelve hours"),
        "twenty_one_days":
            MessageLookupByLibrary.simpleMessage("Twenty one days"),
        "type": MessageLookupByLibrary.simpleMessage("type"),
        "type_something":
            MessageLookupByLibrary.simpleMessage("Type something..."),
        "unarchive": MessageLookupByLibrary.simpleMessage("Unarchive"),
        "uncomplete_flomo_mission": m132,
        "uncomplete_plan_classification": MessageLookupByLibrary.simpleMessage(
            "Unfinished plan classification"),
        "underline": MessageLookupByLibrary.simpleMessage("Underline"),
        "unfinished": MessageLookupByLibrary.simpleMessage("Unfinished"),
        "unit": MessageLookupByLibrary.simpleMessage("Unit"),
        "unitMissions": MessageLookupByLibrary.simpleMessage("Tasks"),
        "unitTomatoes": MessageLookupByLibrary.simpleMessage("Tomatoes"),
        "unname_user": MessageLookupByLibrary.simpleMessage("(unnamed user)"),
        "unorder_folderlist":
            MessageLookupByLibrary.simpleMessage("Uncategorized list"),
        "unorder_group":
            MessageLookupByLibrary.simpleMessage("Unordered group"),
        "unorder_group_not_order_toast": MessageLookupByLibrary.simpleMessage(
            "Unordered group cannot be sorted"),
        "unregister":
            MessageLookupByLibrary.simpleMessage("Unregister Account"),
        "unregister_account":
            MessageLookupByLibrary.simpleMessage("Unregister account"),
        "unregister_content": MessageLookupByLibrary.simpleMessage(
            "All account information will be deleted\\nAll your related list, task data\\nPackage coupons will be emptied and cannot be restored\\nRegister again after logout, but historical data will not be restored"),
        "unregister_success":
            MessageLookupByLibrary.simpleMessage("Unregister successful"),
        "unregister_temp": MessageLookupByLibrary.simpleMessage("Cancel"),
        "unregister_title": MessageLookupByLibrary.simpleMessage(
            "After logging out, the following information will be affected"),
        "unselected": MessageLookupByLibrary.simpleMessage("Unselected"),
        "unset": MessageLookupByLibrary.simpleMessage("Unset"),
        "update": MessageLookupByLibrary.simpleMessage("update"),
        "updateSuccess":
            MessageLookupByLibrary.simpleMessage("update completed"),
        "update_bill": MessageLookupByLibrary.simpleMessage("Update bill"),
        "update_credit_card_bill":
            MessageLookupByLibrary.simpleMessage("Update credit card bill"),
        "update_last_time": m118,
        "update_name_mission": m119,
        "update_name_mission2": m120,
        "update_now":
            MessageLookupByLibrary.simpleMessage("update immediately"),
        "update_success":
            MessageLookupByLibrary.simpleMessage("update completed"),
        "update_success_restart": MessageLookupByLibrary.simpleMessage(
            "Settings updated successfully, please restart"),
        "update_time_last_time":
            MessageLookupByLibrary.simpleMessage("Latest Update Time"),
        "upload": MessageLookupByLibrary.simpleMessage("Upload"),
        "uploadImage": MessageLookupByLibrary.simpleMessage("Upload"),
        "upload_attachment":
            MessageLookupByLibrary.simpleMessage("Upload Attachment"),
        "upload_error": MessageLookupByLibrary.simpleMessage("Upload failed"),
        "upload_success":
            MessageLookupByLibrary.simpleMessage("Upload successful"),
        "uploading_pic":
            MessageLookupByLibrary.simpleMessage("Uploading Image"),
        "urlHint": MessageLookupByLibrary.simpleMessage("URL"),
        "urlImage": MessageLookupByLibrary.simpleMessage("URL"),
        "url_attachment":
            MessageLookupByLibrary.simpleMessage("url attachment"),
        "user_exist_reset_password": MessageLookupByLibrary.simpleMessage(
            "User exists, you can reset your password"),
        "user_privacy_protocol_title":
            MessageLookupByLibrary.simpleMessage("User Privacy Agreement"),
        "username": MessageLookupByLibrary.simpleMessage("username"),
        "value": m121,
        "value_per_hour": m122,
        "version_num": m123,
        "vertical": MessageLookupByLibrary.simpleMessage("Portrait"),
        "view": MessageLookupByLibrary.simpleMessage("View"),
        "view_only": MessageLookupByLibrary.simpleMessage("View only"),
        "visible": MessageLookupByLibrary.simpleMessage("visible"),
        "voice": MessageLookupByLibrary.simpleMessage("voice"),
        "voice_diary": MessageLookupByLibrary.simpleMessage("voice diary"),
        "voice_guide": MessageLookupByLibrary.simpleMessage(
            "Please input using the built-in voice input method of your phone"),
        "volume": MessageLookupByLibrary.simpleMessage("Volume"),
        "waitingToStart": MessageLookupByLibrary.simpleMessage("not started"),
        "web_desc": MessageLookupByLibrary.simpleMessage(
            "Open https://www.timerbell.com in a browser to use the same function anywhere"),
        "wechat": MessageLookupByLibrary.simpleMessage("WeChat"),
        "wechat_friends":
            MessageLookupByLibrary.simpleMessage("WeChat friends"),
        "wechat_share": MessageLookupByLibrary.simpleMessage("Wechat share"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Wed"),
        "wednesdayShort": MessageLookupByLibrary.simpleMessage("Wed"),
        "week": MessageLookupByLibrary.simpleMessage("Week"),
        "week_duration_completed": MessageLookupByLibrary.simpleMessage(
            "Duration this week (minutes)"),
        "week_mission_completed": MessageLookupByLibrary.simpleMessage(
            "Number of tasks completed this week"),
        "week_tomatoes_completed": MessageLookupByLibrary.simpleMessage(
            "Completed Pomodoros this week"),
        "welcome": MessageLookupByLibrary.simpleMessage("welcome"),
        "welcome_to_time_department": m124,
        "whether_to_repeat":
            MessageLookupByLibrary.simpleMessage("Whether to repeat or not"),
        "who_can_view_edit_files":
            MessageLookupByLibrary.simpleMessage("Who can view/edit files"),
        "who_can_view_or_edit":
            MessageLookupByLibrary.simpleMessage("Who can view/edit files"),
        "wholeComepleteTime": MessageLookupByLibrary.simpleMessage(
            "Total time to complete (minutes)"),
        "word_count_and_char_count": m125,
        "write_a_title": MessageLookupByLibrary.simpleMessage("Write a title?"),
        "write_article": MessageLookupByLibrary.simpleMessage("Write Article"),
        "write_article_history": MessageLookupByLibrary.simpleMessage(
            "Write Article Time\'s Article"),
        "write_article_history_prompt": MessageLookupByLibrary.simpleMessage(
            "Please view and edit the previously written article: Time\'s Article."),
        "write_article_placeholder": MessageLookupByLibrary.simpleMessage(
            "(Example) Please write a 1000-word, positive article on the theme of environmental protection and give it a title."),
        "write_article_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me write an article about..."),
        "write_diary": MessageLookupByLibrary.simpleMessage("write diary"),
        "write_essay": MessageLookupByLibrary.simpleMessage("Write Essay"),
        "write_essay_placeholder": MessageLookupByLibrary.simpleMessage(
            "Please enter the title or theme of the essay..."),
        "write_essay_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me write an essay, the topic is..."),
        "write_your_clockin_feedback":
            MessageLookupByLibrary.simpleMessage("Write down your thoughts"),
        "wrong_question_book":
            MessageLookupByLibrary.simpleMessage("wrong question book"),
        "wrong_question_book_prompt": MessageLookupByLibrary.simpleMessage(
            "{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: Solving Quadratic Equations, folder_id: null, flomo_object_id: null, type: 0, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 2, wqbKnowledgeContent: Solving Quadratic Equations, wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 2, wqbWrongQuestionContent: Solve the equation \\(2x^2 - 4x - 6 = 0\\).\n\n\\(x = 1\\) or \\(x = -3\\)\n, wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: \\(x = 3\\) or \\(x = -1\\).\n, wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}"),
        "wrong_question_knowledge_point": MessageLookupByLibrary.simpleMessage(
            "Knowledge Point of Wrong Question"),
        "wrong_question_knowledge_points": MessageLookupByLibrary.simpleMessage(
            "Wrong question knowledge points"),
        "wrong_thinking":
            MessageLookupByLibrary.simpleMessage("Wrong thinking"),
        "wrote_a_diary": m126,
        "wrote_a_note": m127,
        "xiaohongshu": MessageLookupByLibrary.simpleMessage("Xiaohongshu"),
        "xiaohongshu_history": MessageLookupByLibrary.simpleMessage(
            "Xiaohongshu Help me write Xiaohongshu post"),
        "xiaohongshu_history_prompt": MessageLookupByLibrary.simpleMessage(
            "Please view and edit the previously written Xiaohongshu post: Help me write Xiaohongshu post."),
        "xiaohongshu_placeholder": MessageLookupByLibrary.simpleMessage(
            "What should I write with AI?"),
        "xiaohongshu_prompt": MessageLookupByLibrary.simpleMessage(
            "Please help me write a Xiaohongshu post, the content is..."),
        "xxx_cannot_be_empty": m128,
        "year": MessageLookupByLibrary.simpleMessage("Year"),
        "year_duration_completed": MessageLookupByLibrary.simpleMessage(
            "Duration this year (minutes)"),
        "year_mission_completed": MessageLookupByLibrary.simpleMessage(
            "Number of tasks completed this year"),
        "year_month": m129,
        "year_tomatoes_completed": MessageLookupByLibrary.simpleMessage(
            "The number of tomatoes completed this year"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "your_clockin_mission_with_name_has_begun": m130,
        "your_created_class": MessageLookupByLibrary.simpleMessage(
            "This is a class you created yourself"),
        "your_mission_with_name_has_begun": m131,
        "your_time_prof": MessageLookupByLibrary.simpleMessage(
            "Your personal time management expert"),
        "yuan": MessageLookupByLibrary.simpleMessage("RMB"),
        "zh_cn": MessageLookupByLibrary.simpleMessage("简体中文"),
        "zh_tw": MessageLookupByLibrary.simpleMessage("繁體中文")
      };
}
