// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `repeat by year`
  String get repeative_by_year {
    return Intl.message(
      'repeat by year',
      name: 'repeative_by_year',
      desc: '',
      args: [],
    );
  }

  /// `repeat by month`
  String get repeative_by_month {
    return Intl.message(
      'repeat by month',
      name: 'repeative_by_month',
      desc: '',
      args: [],
    );
  }

  /// `repeat by week`
  String get repeative_by_week {
    return Intl.message(
      'repeat by week',
      name: 'repeative_by_week',
      desc: '',
      args: [],
    );
  }

  /// `repeat by day`
  String get repeative_by_day {
    return Intl.message(
      'repeat by day',
      name: 'repeative_by_day',
      desc: '',
      args: [],
    );
  }

  /// `none`
  String get none {
    return Intl.message(
      'none',
      name: 'none',
      desc: '',
      args: [],
    );
  }

  /// `mode`
  String get time_mode {
    return Intl.message(
      'mode',
      name: 'time_mode',
      desc: '',
      args: [],
    );
  }

  /// `subtask`
  String get submisssion {
    return Intl.message(
      'subtask',
      name: 'submisssion',
      desc: '',
      args: [],
    );
  }

  /// `Table`
  String get table {
    return Intl.message(
      'Table',
      name: 'table',
      desc: '',
      args: [],
    );
  }

  /// `Super Toolbar`
  String get super_tool {
    return Intl.message(
      'Super Toolbar',
      name: 'super_tool',
      desc: '',
      args: [],
    );
  }

  /// `Add Filter`
  String get add_filterer {
    return Intl.message(
      'Add Filter',
      name: 'add_filterer',
      desc: '',
      args: [],
    );
  }

  /// `Filter Name`
  String get filter_name {
    return Intl.message(
      'Filter Name',
      name: 'filter_name',
      desc: '',
      args: [],
    );
  }

  /// `Please input task keyword`
  String get please_input_keyword {
    return Intl.message(
      'Please input task keyword',
      name: 'please_input_keyword',
      desc: '',
      args: [],
    );
  }

  /// `Keyword`
  String get keyword {
    return Intl.message(
      'Keyword',
      name: 'keyword',
      desc: '',
      args: [],
    );
  }

  /// `This Week`
  String get this_week {
    return Intl.message(
      'This Week',
      name: 'this_week',
      desc: '',
      args: [],
    );
  }

  /// `After n Days`
  String get after_n_days {
    return Intl.message(
      'After n Days',
      name: 'after_n_days',
      desc: '',
      args: [],
    );
  }

  /// `Before n Days`
  String get before_n_days {
    return Intl.message(
      'Before n Days',
      name: 'before_n_days',
      desc: '',
      args: [],
    );
  }

  /// `Latest n Days`
  String get lastest_n_days {
    return Intl.message(
      'Latest n Days',
      name: 'lastest_n_days',
      desc: '',
      args: [],
    );
  }

  /// `n Days Ago`
  String get n_days_ago {
    return Intl.message(
      'n Days Ago',
      name: 'n_days_ago',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filterer {
    return Intl.message(
      'Filter',
      name: 'filterer',
      desc: '',
      args: [],
    );
  }

  /// `Shortcut Settings`
  String get shortcut_setting {
    return Intl.message(
      'Shortcut Settings',
      name: 'shortcut_setting',
      desc: '',
      args: [],
    );
  }

  /// `Cannot Reorder for Ungrouped`
  String get cannot_reorder_for_group {
    return Intl.message(
      'Cannot Reorder for Ungrouped',
      name: 'cannot_reorder_for_group',
      desc: '',
      args: [],
    );
  }

  /// `Super Tool Shortcuts`
  String get super_tool_shortcuts {
    return Intl.message(
      'Super Tool Shortcuts',
      name: 'super_tool_shortcuts',
      desc: '',
      args: [],
    );
  }

  /// `Open Search Bar and Create Task Toolbar`
  String get open_search_taskbar {
    return Intl.message(
      'Open Search Bar and Create Task Toolbar',
      name: 'open_search_taskbar',
      desc: '',
      args: [],
    );
  }

  /// `Todo List Shortcuts`
  String get todo_list_shortcuts {
    return Intl.message(
      'Todo List Shortcuts',
      name: 'todo_list_shortcuts',
      desc: '',
      args: [],
    );
  }

  /// `Fullscreen`
  String get fullscreen {
    return Intl.message(
      'Fullscreen',
      name: 'fullscreen',
      desc: '',
      args: [],
    );
  }

  /// `Calendar View Shortcuts`
  String get calendar_view_shortcuts {
    return Intl.message(
      'Calendar View Shortcuts',
      name: 'calendar_view_shortcuts',
      desc: '',
      args: [],
    );
  }

  /// `Switch Mode`
  String get switch_mode {
    return Intl.message(
      'Switch Mode',
      name: 'switch_mode',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `previous page`
  String get previous_page {
    return Intl.message(
      'previous page',
      name: 'previous_page',
      desc: '',
      args: [],
    );
  }

  /// `next page`
  String get next_page {
    return Intl.message(
      'next page',
      name: 'next_page',
      desc: '',
      args: [],
    );
  }

  /// `Pomodoro Shortcuts`
  String get pomodoro_shortcuts {
    return Intl.message(
      'Pomodoro Shortcuts',
      name: 'pomodoro_shortcuts',
      desc: '',
      args: [],
    );
  }

  /// `Start Focus`
  String get focus_start {
    return Intl.message(
      'Start Focus',
      name: 'focus_start',
      desc: '',
      args: [],
    );
  }

  /// `Stop Focus`
  String get focus_stop {
    return Intl.message(
      'Stop Focus',
      name: 'focus_stop',
      desc: '',
      args: [],
    );
  }

  /// `Pause Focus`
  String get focus_pause {
    return Intl.message(
      'Pause Focus',
      name: 'focus_pause',
      desc: '',
      args: [],
    );
  }

  /// `Settings updated successfully, please restart`
  String get update_success_restart {
    return Intl.message(
      'Settings updated successfully, please restart',
      name: 'update_success_restart',
      desc: '',
      args: [],
    );
  }

  /// `Language Setting`
  String get language_setting {
    return Intl.message(
      'Language Setting',
      name: 'language_setting',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Chinese Simplified`
  String get zh_cn {
    return Intl.message(
      'Chinese Simplified',
      name: 'zh_cn',
      desc: '',
      args: [],
    );
  }

  /// `Chinese Traditional`
  String get zh_tw {
    return Intl.message(
      'Chinese Traditional',
      name: 'zh_tw',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get en {
    return Intl.message(
      'English',
      name: 'en',
      desc: '',
      args: [],
    );
  }

  /// `German`
  String get german {
    return Intl.message(
      'German',
      name: 'german',
      desc: '',
      args: [],
    );
  }

  /// `Japanese`
  String get ja {
    return Intl.message(
      'Japanese',
      name: 'ja',
      desc: '',
      args: [],
    );
  }

  /// `Korean`
  String get ko {
    return Intl.message(
      'Korean',
      name: 'ko',
      desc: '',
      args: [],
    );
  }

  /// `French`
  String get fr {
    return Intl.message(
      'French',
      name: 'fr',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get es {
    return Intl.message(
      'Spanish',
      name: 'es',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the question you want to ask`
  String get please_input_question {
    return Intl.message(
      'Please enter the question you want to ask',
      name: 'please_input_question',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the mission title you want to search`
  String get please_input_search_mission {
    return Intl.message(
      'Please enter the mission title you want to search',
      name: 'please_input_search_mission',
      desc: '',
      args: [],
    );
  }

  /// `Subtask`
  String get multi_subtask {
    return Intl.message(
      'Subtask',
      name: 'multi_subtask',
      desc: '',
      args: [],
    );
  }

  /// `Image saved successfully`
  String get save_img_success {
    return Intl.message(
      'Image saved successfully',
      name: 'save_img_success',
      desc: '',
      args: [],
    );
  }

  /// `Saving image`
  String get saving_img {
    return Intl.message(
      'Saving image',
      name: 'saving_img',
      desc: '',
      args: [],
    );
  }

  /// `New Rich Editor`
  String get new_rich_editor {
    return Intl.message(
      'New Rich Editor',
      name: 'new_rich_editor',
      desc: '',
      args: [],
    );
  }

  /// `Timerbell todo AI`
  String get ai_title {
    return Intl.message(
      'Timerbell todo AI',
      name: 'ai_title',
      desc: '',
      args: [],
    );
  }

  /// `Speech`
  String get speech {
    return Intl.message(
      'Speech',
      name: 'speech',
      desc: '',
      args: [],
    );
  }

  /// `Please help me write a speech about...`
  String get speech_prompt {
    return Intl.message(
      'Please help me write a speech about...',
      name: 'speech_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the theme or content of the speech...`
  String get speech_placeholder {
    return Intl.message(
      'Please enter the theme or content of the speech...',
      name: 'speech_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the title or theme of the essay...`
  String get write_essay_placeholder {
    return Intl.message(
      'Please enter the title or theme of the essay...',
      name: 'write_essay_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Announcement`
  String get announcement {
    return Intl.message(
      'Announcement',
      name: 'announcement',
      desc: '',
      args: [],
    );
  }

  /// `Please help me write an announcement, the content is...`
  String get announcement_prompt {
    return Intl.message(
      'Please help me write an announcement, the content is...',
      name: 'announcement_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the specific content of the announcement...`
  String get announcement_placeholder {
    return Intl.message(
      'Please enter the specific content of the announcement...',
      name: 'announcement_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Modern Poetry`
  String get modern_poetry {
    return Intl.message(
      'Modern Poetry',
      name: 'modern_poetry',
      desc: '',
      args: [],
    );
  }

  /// `Please help me write a modern poem, the theme is...`
  String get modern_poetry_prompt {
    return Intl.message(
      'Please help me write a modern poem, the theme is...',
      name: 'modern_poetry_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the theme of the modern poem...`
  String get modern_poetry_placeholder {
    return Intl.message(
      'Please enter the theme of the modern poem...',
      name: 'modern_poetry_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Creative Story`
  String get creative_story {
    return Intl.message(
      'Creative Story',
      name: 'creative_story',
      desc: '',
      args: [],
    );
  }

  /// `Please help me write a creative story, the plot is...`
  String get creative_story_prompt {
    return Intl.message(
      'Please help me write a creative story, the plot is...',
      name: 'creative_story_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the plot or theme of the creative story...`
  String get creative_story_placeholder {
    return Intl.message(
      'Please enter the plot or theme of the creative story...',
      name: 'creative_story_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Meeting Agenda`
  String get meeting_agenda {
    return Intl.message(
      'Meeting Agenda',
      name: 'meeting_agenda',
      desc: '',
      args: [],
    );
  }

  /// `Please help me list a meeting agenda, the meeting topic is...`
  String get meeting_agenda_prompt {
    return Intl.message(
      'Please help me list a meeting agenda, the meeting topic is...',
      name: 'meeting_agenda_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the theme or content of the meeting agenda...`
  String get meeting_agenda_placeholder {
    return Intl.message(
      'Please enter the theme or content of the meeting agenda...',
      name: 'meeting_agenda_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `To-Do List`
  String get todo_list {
    return Intl.message(
      'To-Do List',
      name: 'todo_list',
      desc: '',
      args: [],
    );
  }

  /// `Please help me list today's to-do list...`
  String get todo_list_prompt {
    return Intl.message(
      'Please help me list today\'s to-do list...',
      name: 'todo_list_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enter today's to-do items...`
  String get todo_list_placeholder {
    return Intl.message(
      'Please enter today\'s to-do items...',
      name: 'todo_list_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Emoji Conversion`
  String get emoji_conversion {
    return Intl.message(
      'Emoji Conversion',
      name: 'emoji_conversion',
      desc: '',
      args: [],
    );
  }

  /// `Please help me convert the following text to emojis:...`
  String get emoji_conversion_prompt {
    return Intl.message(
      'Please help me convert the following text to emojis:...',
      name: 'emoji_conversion_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the text to be converted to emojis...`
  String get emoji_conversion_placeholder {
    return Intl.message(
      'Please enter the text to be converted to emojis...',
      name: 'emoji_conversion_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Leave Reason`
  String get leave_reason {
    return Intl.message(
      'Leave Reason',
      name: 'leave_reason',
      desc: '',
      args: [],
    );
  }

  /// `Please help me write a leave reason, the reason is...`
  String get leave_reason_prompt {
    return Intl.message(
      'Please help me write a leave reason, the reason is...',
      name: 'leave_reason_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the reason for leave...`
  String get leave_reason_placeholder {
    return Intl.message(
      'Please enter the reason for leave...',
      name: 'leave_reason_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Pros and Cons`
  String get pros_and_cons {
    return Intl.message(
      'Pros and Cons',
      name: 'pros_and_cons',
      desc: '',
      args: [],
    );
  }

  /// `Please help me list the pros and cons of a topic, the topic is...`
  String get pros_and_cons_prompt {
    return Intl.message(
      'Please help me list the pros and cons of a topic, the topic is...',
      name: 'pros_and_cons_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the topic for which the pros and cons need to be analyzed...`
  String get pros_and_cons_placeholder {
    return Intl.message(
      'Please enter the topic for which the pros and cons need to be analyzed...',
      name: 'pros_and_cons_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Press Release`
  String get press_release {
    return Intl.message(
      'Press Release',
      name: 'press_release',
      desc: '',
      args: [],
    );
  }

  /// `Please help me write a press release, the content is...`
  String get press_release_prompt {
    return Intl.message(
      'Please help me write a press release, the content is...',
      name: 'press_release_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the content or theme of the press release...`
  String get press_release_placeholder {
    return Intl.message(
      'Please enter the content or theme of the press release...',
      name: 'press_release_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Advertising Copy`
  String get advertising_copy {
    return Intl.message(
      'Advertising Copy',
      name: 'advertising_copy',
      desc: '',
      args: [],
    );
  }

  /// `Please help me write an advertising copy, the product is...`
  String get advertising_copy_prompt {
    return Intl.message(
      'Please help me write an advertising copy, the product is...',
      name: 'advertising_copy_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the product or service for the advertising copy...`
  String get advertising_copy_placeholder {
    return Intl.message(
      'Please enter the product or service for the advertising copy...',
      name: 'advertising_copy_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Job Description`
  String get job_description {
    return Intl.message(
      'Job Description',
      name: 'job_description',
      desc: '',
      args: [],
    );
  }

  /// `Please help me write a job description, the title is...`
  String get job_description_prompt {
    return Intl.message(
      'Please help me write a job description, the title is...',
      name: 'job_description_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the job title and responsibilities...`
  String get job_description_placeholder {
    return Intl.message(
      'Please enter the job title and responsibilities...',
      name: 'job_description_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Interview Questions`
  String get interview_questions {
    return Intl.message(
      'Interview Questions',
      name: 'interview_questions',
      desc: '',
      args: [],
    );
  }

  /// `Please help me list interview questions, the interviewee is...`
  String get interview_questions_prompt {
    return Intl.message(
      'Please help me list interview questions, the interviewee is...',
      name: 'interview_questions_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the interviewee and relevant questions...`
  String get interview_questions_placeholder {
    return Intl.message(
      'Please enter the interviewee and relevant questions...',
      name: 'interview_questions_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Food Reviews`
  String get food_reviews {
    return Intl.message(
      'Food Reviews',
      name: 'food_reviews',
      desc: '',
      args: [],
    );
  }

  /// `Please help me write a food review, the restaurant is...`
  String get food_reviews_prompt {
    return Intl.message(
      'Please help me write a food review, the restaurant is...',
      name: 'food_reviews_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the restaurant and dishes for the review...`
  String get food_reviews_placeholder {
    return Intl.message(
      'Please enter the restaurant and dishes for the review...',
      name: 'food_reviews_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `AI Write for Me`
  String get ai_write_for_me {
    return Intl.message(
      'AI Write for Me',
      name: 'ai_write_for_me',
      desc: '',
      args: [],
    );
  }

  /// `Please tell me what AI can help me write.`
  String get ai_write_for_me_prompt {
    return Intl.message(
      'Please tell me what AI can help me write.',
      name: 'ai_write_for_me_prompt',
      desc: '',
      args: [],
    );
  }

  /// `What should I write with AI?`
  String get ai_placeholder {
    return Intl.message(
      'What should I write with AI?',
      name: 'ai_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Brainstorm`
  String get brainstorm {
    return Intl.message(
      'Brainstorm',
      name: 'brainstorm',
      desc: '',
      args: [],
    );
  }

  /// `Please help me brainstorm on the topic of...`
  String get brainstorm_prompt {
    return Intl.message(
      'Please help me brainstorm on the topic of...',
      name: 'brainstorm_prompt',
      desc: '',
      args: [],
    );
  }

  /// `(Example) Please provide at least 5 solutions for global warming.`
  String get brainstorm_placeholder {
    return Intl.message(
      '(Example) Please provide at least 5 solutions for global warming.',
      name: 'brainstorm_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Write Article`
  String get write_article {
    return Intl.message(
      'Write Article',
      name: 'write_article',
      desc: '',
      args: [],
    );
  }

  /// `Please help me write an article about...`
  String get write_article_prompt {
    return Intl.message(
      'Please help me write an article about...',
      name: 'write_article_prompt',
      desc: '',
      args: [],
    );
  }

  /// `(Example) Please write a 1000-word, positive article on the theme of environmental protection and give it a title.`
  String get write_article_placeholder {
    return Intl.message(
      '(Example) Please write a 1000-word, positive article on the theme of environmental protection and give it a title.',
      name: 'write_article_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Outline`
  String get outline {
    return Intl.message(
      'Outline',
      name: 'outline',
      desc: '',
      args: [],
    );
  }

  /// `Please help me list an outline about...`
  String get outline_prompt {
    return Intl.message(
      'Please help me list an outline about...',
      name: 'outline_prompt',
      desc: '',
      args: [],
    );
  }

  /// `(Example) Please list an outline on the theme of environmental protection.`
  String get outline_placeholder {
    return Intl.message(
      '(Example) Please list an outline on the theme of environmental protection.',
      name: 'outline_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Xiaohongshu`
  String get xiaohongshu {
    return Intl.message(
      'Xiaohongshu',
      name: 'xiaohongshu',
      desc: '',
      args: [],
    );
  }

  /// `Please help me write a Xiaohongshu post, the content is...`
  String get xiaohongshu_prompt {
    return Intl.message(
      'Please help me write a Xiaohongshu post, the content is...',
      name: 'xiaohongshu_prompt',
      desc: '',
      args: [],
    );
  }

  /// `What should I write with AI?`
  String get xiaohongshu_placeholder {
    return Intl.message(
      'What should I write with AI?',
      name: 'xiaohongshu_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Please provide more writing options.`
  String get more_prompt {
    return Intl.message(
      'Please provide more writing options.',
      name: 'more_prompt',
      desc: '',
      args: [],
    );
  }

  /// `{appname} AI`
  String timehello(Object appname) {
    return Intl.message(
      '$appname AI',
      name: 'timehello',
      desc: '',
      args: [appname],
    );
  }

  /// `What should I write with AI?`
  String get ai_write_what {
    return Intl.message(
      'What should I write with AI?',
      name: 'ai_write_what',
      desc: '',
      args: [],
    );
  }

  /// `Please tell me what AI can help me write.`
  String get ai_write_what_prompt {
    return Intl.message(
      'Please tell me what AI can help me write.',
      name: 'ai_write_what_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Manage`
  String get manage {
    return Intl.message(
      'Manage',
      name: 'manage',
      desc: '',
      args: [],
    );
  }

  /// `Please open the management options.`
  String get manage_prompt {
    return Intl.message(
      'Please open the management options.',
      name: 'manage_prompt',
      desc: '',
      args: [],
    );
  }

  /// `AI Writing Scenario`
  String get ai_scenario {
    return Intl.message(
      'AI Writing Scenario',
      name: 'ai_scenario',
      desc: '',
      args: [],
    );
  }

  /// `Please select a writing scenario.`
  String get ai_scenario_prompt {
    return Intl.message(
      'Please select a writing scenario.',
      name: 'ai_scenario_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Write Essay`
  String get write_essay {
    return Intl.message(
      'Write Essay',
      name: 'write_essay',
      desc: '',
      args: [],
    );
  }

  /// `Please help me write an essay, the topic is...`
  String get write_essay_prompt {
    return Intl.message(
      'Please help me write an essay, the topic is...',
      name: 'write_essay_prompt',
      desc: '',
      args: [],
    );
  }

  /// `History Record`
  String get history_record {
    return Intl.message(
      'History Record',
      name: 'history_record',
      desc: '',
      args: [],
    );
  }

  /// `View history records.`
  String get history_record_prompt {
    return Intl.message(
      'View history records.',
      name: 'history_record_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Write Article Time's Article`
  String get write_article_history {
    return Intl.message(
      'Write Article Time\'s Article',
      name: 'write_article_history',
      desc: '',
      args: [],
    );
  }

  /// `Please view and edit the previously written article: Time's Article.`
  String get write_article_history_prompt {
    return Intl.message(
      'Please view and edit the previously written article: Time\'s Article.',
      name: 'write_article_history_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Xiaohongshu Help me write Xiaohongshu post`
  String get xiaohongshu_history {
    return Intl.message(
      'Xiaohongshu Help me write Xiaohongshu post',
      name: 'xiaohongshu_history',
      desc: '',
      args: [],
    );
  }

  /// `Please view and edit the previously written Xiaohongshu post: Help me write Xiaohongshu post.`
  String get xiaohongshu_history_prompt {
    return Intl.message(
      'Please view and edit the previously written Xiaohongshu post: Help me write Xiaohongshu post.',
      name: 'xiaohongshu_history_prompt',
      desc: '',
      args: [],
    );
  }

  /// `0/1000`
  String get character_limit {
    return Intl.message(
      '0/1000',
      name: 'character_limit',
      desc: '',
      args: [],
    );
  }

  /// `Character limit: 0/1000`
  String get character_limit_prompt {
    return Intl.message(
      'Character limit: 0/1000',
      name: 'character_limit_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please continue writing based on the following content:\n\n{existing_text}\n\nNext:`
  String continue_writing_prompt_with_text(Object existing_text) {
    return Intl.message(
      'Please continue writing based on the following content:\n\n$existing_text\n\nNext:',
      name: 'continue_writing_prompt_with_text',
      desc: '',
      args: [existing_text],
    );
  }

  /// `Replace`
  String get replace {
    return Intl.message(
      'Replace',
      name: 'replace',
      desc: '',
      args: [],
    );
  }

  /// `Insert`
  String get insert {
    return Intl.message(
      'Insert',
      name: 'insert',
      desc: '',
      args: [],
    );
  }

  /// `Continue Writing`
  String get continue_writing {
    return Intl.message(
      'Continue Writing',
      name: 'continue_writing',
      desc: '',
      args: [],
    );
  }

  /// `Give Up`
  String get give_up {
    return Intl.message(
      'Give Up',
      name: 'give_up',
      desc: '',
      args: [],
    );
  }

  /// `Input`
  String get input {
    return Intl.message(
      'Input',
      name: 'input',
      desc: '',
      args: [],
    );
  }

  /// `Original Text: The government is actively taking measures to address the increasingly serious environmental issues, including strengthening the enforcement of environmental regulations, raising public environmental awareness, and promoting the development of green energy.`
  String get original_text {
    return Intl.message(
      'Original Text: The government is actively taking measures to address the increasingly serious environmental issues, including strengthening the enforcement of environmental regulations, raising public environmental awareness, and promoting the development of green energy.',
      name: 'original_text',
      desc: '',
      args: [],
    );
  }

  /// `Revised Text: The government is strengthening environmental regulations, raising public awareness, and promoting green energy to address environmental issues.`
  String get revised_text {
    return Intl.message(
      'Revised Text: The government is strengthening environmental regulations, raising public awareness, and promoting green energy to address environmental issues.',
      name: 'revised_text',
      desc: '',
      args: [],
    );
  }

  /// `Select from the following scenarios or tell AI how to edit`
  String get select_scenario {
    return Intl.message(
      'Select from the following scenarios or tell AI how to edit',
      name: 'select_scenario',
      desc: '',
      args: [],
    );
  }

  /// `Please improve the selected paragraph to make it clearer and more expressive.`
  String get improve_writing_prompt {
    return Intl.message(
      'Please improve the selected paragraph to make it clearer and more expressive.',
      name: 'improve_writing_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please check the selected paragraph for spelling and grammar errors and fix any issues.`
  String get fix_spelling_grammar_prompt {
    return Intl.message(
      'Please check the selected paragraph for spelling and grammar errors and fix any issues.',
      name: 'fix_spelling_grammar_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please rewrite the selected paragraph to make it more concise while retaining its original meaning.`
  String get shorten_prompt {
    return Intl.message(
      'Please rewrite the selected paragraph to make it more concise while retaining its original meaning.',
      name: 'shorten_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please enrich the selected paragraph, making it more detailed and comprehensive.`
  String get enrich_prompt {
    return Intl.message(
      'Please enrich the selected paragraph, making it more detailed and comprehensive.',
      name: 'enrich_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please change the writing style of the selected paragraph, such as formal, informal, academic, or humorous.`
  String get switch_style_prompt {
    return Intl.message(
      'Please change the writing style of the selected paragraph, such as formal, informal, academic, or humorous.',
      name: 'switch_style_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please simplify the language of the selected paragraph to make it easier to understand.`
  String get simplify_language_prompt {
    return Intl.message(
      'Please simplify the language of the selected paragraph to make it easier to understand.',
      name: 'simplify_language_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please continue writing based on the selected paragraph, expanding the content.`
  String get continue_writing_prompt {
    return Intl.message(
      'Please continue writing based on the selected paragraph, expanding the content.',
      name: 'continue_writing_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please summarize the main points of the selected paragraph.`
  String get summarize_prompt {
    return Intl.message(
      'Please summarize the main points of the selected paragraph.',
      name: 'summarize_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please translate the selected paragraph into English.`
  String get translate_prompt {
    return Intl.message(
      'Please translate the selected paragraph into English.',
      name: 'translate_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please explain the main content and significance of the selected paragraph.`
  String get explain_prompt {
    return Intl.message(
      'Please explain the main content and significance of the selected paragraph.',
      name: 'explain_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Edit Options`
  String get edit_options {
    return Intl.message(
      'Edit Options',
      name: 'edit_options',
      desc: '',
      args: [],
    );
  }

  /// `Improve Writing`
  String get improve_writing {
    return Intl.message(
      'Improve Writing',
      name: 'improve_writing',
      desc: '',
      args: [],
    );
  }

  /// `Fix Spelling and Grammar`
  String get fix_spelling_grammar {
    return Intl.message(
      'Fix Spelling and Grammar',
      name: 'fix_spelling_grammar',
      desc: '',
      args: [],
    );
  }

  /// `Shorten`
  String get shorten {
    return Intl.message(
      'Shorten',
      name: 'shorten',
      desc: '',
      args: [],
    );
  }

  /// `Enrich`
  String get enrich {
    return Intl.message(
      'Enrich',
      name: 'enrich',
      desc: '',
      args: [],
    );
  }

  /// `Switch Style`
  String get switch_style {
    return Intl.message(
      'Switch Style',
      name: 'switch_style',
      desc: '',
      args: [],
    );
  }

  /// `Simplify Language`
  String get simplify_language {
    return Intl.message(
      'Simplify Language',
      name: 'simplify_language',
      desc: '',
      args: [],
    );
  }

  /// `Summarize`
  String get summarize {
    return Intl.message(
      'Summarize',
      name: 'summarize',
      desc: '',
      args: [],
    );
  }

  /// `Translate`
  String get translate {
    return Intl.message(
      'Translate',
      name: 'translate',
      desc: '',
      args: [],
    );
  }

  /// `Explain`
  String get explain {
    return Intl.message(
      'Explain',
      name: 'explain',
      desc: '',
      args: [],
    );
  }

  /// `AI`
  String get ai {
    return Intl.message(
      'AI',
      name: 'ai',
      desc: '',
      args: [],
    );
  }

  /// `For the content of the task {title}, please click the link to view: {link}`
  String copy_and_share_with_title(Object title, Object link) {
    return Intl.message(
      'For the content of the task $title, please click the link to view: $link',
      name: 'copy_and_share_with_title',
      desc: '',
      args: [title, link],
    );
  }

  /// `Copy link and share`
  String get copy_and_share {
    return Intl.message(
      'Copy link and share',
      name: 'copy_and_share',
      desc: '',
      args: [],
    );
  }

  /// `Type something...`
  String get type_something {
    return Intl.message(
      'Type something...',
      name: 'type_something',
      desc: '',
      args: [],
    );
  }

  /// `DateTime`
  String get datetime {
    return Intl.message(
      'DateTime',
      name: 'datetime',
      desc: '',
      args: [],
    );
  }

  /// `url attachment`
  String get url_attachment {
    return Intl.message(
      'url attachment',
      name: 'url_attachment',
      desc: '',
      args: [],
    );
  }

  /// `Please select attachment`
  String get please_select_attachment {
    return Intl.message(
      'Please select attachment',
      name: 'please_select_attachment',
      desc: '',
      args: [],
    );
  }

  /// `Choose attachment`
  String get choose_attachment {
    return Intl.message(
      'Choose attachment',
      name: 'choose_attachment',
      desc: '',
      args: [],
    );
  }

  /// `Upload Attachment`
  String get upload_attachment {
    return Intl.message(
      'Upload Attachment',
      name: 'upload_attachment',
      desc: '',
      args: [],
    );
  }

  /// `Attachment`
  String get attachment {
    return Intl.message(
      'Attachment',
      name: 'attachment',
      desc: '',
      args: [],
    );
  }

  /// `Unregister successful`
  String get unregister_success {
    return Intl.message(
      'Unregister successful',
      name: 'unregister_success',
      desc: '',
      args: [],
    );
  }

  /// `Deprecated`
  String get deprecated {
    return Intl.message(
      'Deprecated',
      name: 'deprecated',
      desc: '',
      args: [],
    );
  }

  /// `In selection word count: {wordCount}, character count: {charCount}`
  String in_selection_word_count_and_char_count(
      Object wordCount, Object charCount) {
    return Intl.message(
      'In selection word count: $wordCount, character count: $charCount',
      name: 'in_selection_word_count_and_char_count',
      desc: '',
      args: [wordCount, charCount],
    );
  }

  /// `Word count: {wordCount}, character count: {charCount}`
  String word_count_and_char_count(Object wordCount, Object charCount) {
    return Intl.message(
      'Word count: $wordCount, character count: $charCount',
      name: 'word_count_and_char_count',
      desc: '',
      args: [wordCount, charCount],
    );
  }

  /// `Download failed`
  String get download_fail {
    return Intl.message(
      'Download failed',
      name: 'download_fail',
      desc: '',
      args: [],
    );
  }

  /// `Save failed`
  String get save_fail {
    return Intl.message(
      'Save failed',
      name: 'save_fail',
      desc: '',
      args: [],
    );
  }

  /// `Save Successful`
  String get save_success {
    return Intl.message(
      'Save Successful',
      name: 'save_success',
      desc: '',
      args: [],
    );
  }

  /// `Upload successful`
  String get upload_success {
    return Intl.message(
      'Upload successful',
      name: 'upload_success',
      desc: '',
      args: [],
    );
  }

  /// `Upload failed`
  String get upload_error {
    return Intl.message(
      'Upload failed',
      name: 'upload_error',
      desc: '',
      args: [],
    );
  }

  /// `Bold`
  String get bold {
    return Intl.message(
      'Bold',
      name: 'bold',
      desc: '',
      args: [],
    );
  }

  /// `Bulleted List`
  String get bulletedList {
    return Intl.message(
      'Bulleted List',
      name: 'bulletedList',
      desc: '',
      args: [],
    );
  }

  /// `Checkbox`
  String get checkbox {
    return Intl.message(
      'Checkbox',
      name: 'checkbox',
      desc: '',
      args: [],
    );
  }

  /// `Embed Code`
  String get embedCode {
    return Intl.message(
      'Embed Code',
      name: 'embedCode',
      desc: '',
      args: [],
    );
  }

  /// `H1`
  String get heading1 {
    return Intl.message(
      'H1',
      name: 'heading1',
      desc: '',
      args: [],
    );
  }

  /// `H2`
  String get heading2 {
    return Intl.message(
      'H2',
      name: 'heading2',
      desc: '',
      args: [],
    );
  }

  /// `H3`
  String get heading3 {
    return Intl.message(
      'H3',
      name: 'heading3',
      desc: '',
      args: [],
    );
  }

  /// `Highlight`
  String get highlight {
    return Intl.message(
      'Highlight',
      name: 'highlight',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color {
    return Intl.message(
      'Color',
      name: 'color',
      desc: '',
      args: [],
    );
  }

  /// `image`
  String get image {
    return Intl.message(
      'image',
      name: 'image',
      desc: '',
      args: [],
    );
  }

  /// `Italic`
  String get italic {
    return Intl.message(
      'Italic',
      name: 'italic',
      desc: '',
      args: [],
    );
  }

  /// `Link`
  String get link {
    return Intl.message(
      'Link',
      name: 'link',
      desc: '',
      args: [],
    );
  }

  /// `Numbered List`
  String get numberedList {
    return Intl.message(
      'Numbered List',
      name: 'numberedList',
      desc: '',
      args: [],
    );
  }

  /// `Quote`
  String get quote {
    return Intl.message(
      'Quote',
      name: 'quote',
      desc: '',
      args: [],
    );
  }

  /// `Strikethrough`
  String get strikethrough {
    return Intl.message(
      'Strikethrough',
      name: 'strikethrough',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get text {
    return Intl.message(
      'Text',
      name: 'text',
      desc: '',
      args: [],
    );
  }

  /// `Underline`
  String get underline {
    return Intl.message(
      'Underline',
      name: 'underline',
      desc: '',
      args: [],
    );
  }

  /// `Default`
  String get fontColorDefault {
    return Intl.message(
      'Default',
      name: 'fontColorDefault',
      desc: '',
      args: [],
    );
  }

  /// `Gray`
  String get fontColorGray {
    return Intl.message(
      'Gray',
      name: 'fontColorGray',
      desc: '',
      args: [],
    );
  }

  /// `Brown`
  String get fontColorBrown {
    return Intl.message(
      'Brown',
      name: 'fontColorBrown',
      desc: '',
      args: [],
    );
  }

  /// `Orange`
  String get fontColorOrange {
    return Intl.message(
      'Orange',
      name: 'fontColorOrange',
      desc: '',
      args: [],
    );
  }

  /// `Yellow`
  String get fontColorYellow {
    return Intl.message(
      'Yellow',
      name: 'fontColorYellow',
      desc: '',
      args: [],
    );
  }

  /// `Green`
  String get fontColorGreen {
    return Intl.message(
      'Green',
      name: 'fontColorGreen',
      desc: '',
      args: [],
    );
  }

  /// `Blue`
  String get fontColorBlue {
    return Intl.message(
      'Blue',
      name: 'fontColorBlue',
      desc: '',
      args: [],
    );
  }

  /// `Purple`
  String get fontColorPurple {
    return Intl.message(
      'Purple',
      name: 'fontColorPurple',
      desc: '',
      args: [],
    );
  }

  /// `Pink`
  String get fontColorPink {
    return Intl.message(
      'Pink',
      name: 'fontColorPink',
      desc: '',
      args: [],
    );
  }

  /// `Red`
  String get fontColorRed {
    return Intl.message(
      'Red',
      name: 'fontColorRed',
      desc: '',
      args: [],
    );
  }

  /// `Default background`
  String get backgroundColorDefault {
    return Intl.message(
      'Default background',
      name: 'backgroundColorDefault',
      desc: '',
      args: [],
    );
  }

  /// `Gray background`
  String get backgroundColorGray {
    return Intl.message(
      'Gray background',
      name: 'backgroundColorGray',
      desc: '',
      args: [],
    );
  }

  /// `Brown background`
  String get backgroundColorBrown {
    return Intl.message(
      'Brown background',
      name: 'backgroundColorBrown',
      desc: '',
      args: [],
    );
  }

  /// `Orange background`
  String get backgroundColorOrange {
    return Intl.message(
      'Orange background',
      name: 'backgroundColorOrange',
      desc: '',
      args: [],
    );
  }

  /// `Yellow background`
  String get backgroundColorYellow {
    return Intl.message(
      'Yellow background',
      name: 'backgroundColorYellow',
      desc: '',
      args: [],
    );
  }

  /// `Green background`
  String get backgroundColorGreen {
    return Intl.message(
      'Green background',
      name: 'backgroundColorGreen',
      desc: '',
      args: [],
    );
  }

  /// `Blue background`
  String get backgroundColorBlue {
    return Intl.message(
      'Blue background',
      name: 'backgroundColorBlue',
      desc: '',
      args: [],
    );
  }

  /// `Purple background`
  String get backgroundColorPurple {
    return Intl.message(
      'Purple background',
      name: 'backgroundColorPurple',
      desc: '',
      args: [],
    );
  }

  /// `Pink background`
  String get backgroundColorPink {
    return Intl.message(
      'Pink background',
      name: 'backgroundColorPink',
      desc: '',
      args: [],
    );
  }

  /// `Red background`
  String get backgroundColorRed {
    return Intl.message(
      'Red background',
      name: 'backgroundColorRed',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Tint 1`
  String get tint1 {
    return Intl.message(
      'Tint 1',
      name: 'tint1',
      desc: '',
      args: [],
    );
  }

  /// `Tint 2`
  String get tint2 {
    return Intl.message(
      'Tint 2',
      name: 'tint2',
      desc: '',
      args: [],
    );
  }

  /// `Tint 3`
  String get tint3 {
    return Intl.message(
      'Tint 3',
      name: 'tint3',
      desc: '',
      args: [],
    );
  }

  /// `Tint 4`
  String get tint4 {
    return Intl.message(
      'Tint 4',
      name: 'tint4',
      desc: '',
      args: [],
    );
  }

  /// `Tint 5`
  String get tint5 {
    return Intl.message(
      'Tint 5',
      name: 'tint5',
      desc: '',
      args: [],
    );
  }

  /// `Tint 6`
  String get tint6 {
    return Intl.message(
      'Tint 6',
      name: 'tint6',
      desc: '',
      args: [],
    );
  }

  /// `Tint 7`
  String get tint7 {
    return Intl.message(
      'Tint 7',
      name: 'tint7',
      desc: '',
      args: [],
    );
  }

  /// `Tint 8`
  String get tint8 {
    return Intl.message(
      'Tint 8',
      name: 'tint8',
      desc: '',
      args: [],
    );
  }

  /// `Tint 9`
  String get tint9 {
    return Intl.message(
      'Tint 9',
      name: 'tint9',
      desc: '',
      args: [],
    );
  }

  /// `Purple`
  String get lightLightTint1 {
    return Intl.message(
      'Purple',
      name: 'lightLightTint1',
      desc: '',
      args: [],
    );
  }

  /// `Pink`
  String get lightLightTint2 {
    return Intl.message(
      'Pink',
      name: 'lightLightTint2',
      desc: '',
      args: [],
    );
  }

  /// `Light Pink`
  String get lightLightTint3 {
    return Intl.message(
      'Light Pink',
      name: 'lightLightTint3',
      desc: '',
      args: [],
    );
  }

  /// `Orange`
  String get lightLightTint4 {
    return Intl.message(
      'Orange',
      name: 'lightLightTint4',
      desc: '',
      args: [],
    );
  }

  /// `Yellow`
  String get lightLightTint5 {
    return Intl.message(
      'Yellow',
      name: 'lightLightTint5',
      desc: '',
      args: [],
    );
  }

  /// `Lime`
  String get lightLightTint6 {
    return Intl.message(
      'Lime',
      name: 'lightLightTint6',
      desc: '',
      args: [],
    );
  }

  /// `Green`
  String get lightLightTint7 {
    return Intl.message(
      'Green',
      name: 'lightLightTint7',
      desc: '',
      args: [],
    );
  }

  /// `Aqua`
  String get lightLightTint8 {
    return Intl.message(
      'Aqua',
      name: 'lightLightTint8',
      desc: '',
      args: [],
    );
  }

  /// `Blue`
  String get lightLightTint9 {
    return Intl.message(
      'Blue',
      name: 'lightLightTint9',
      desc: '',
      args: [],
    );
  }

  /// `List item`
  String get listItemPlaceholder {
    return Intl.message(
      'List item',
      name: 'listItemPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `To-do`
  String get toDoPlaceholder {
    return Intl.message(
      'To-do',
      name: 'toDoPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `URL`
  String get urlHint {
    return Intl.message(
      'URL',
      name: 'urlHint',
      desc: '',
      args: [],
    );
  }

  /// `Heading 1`
  String get mobileHeading1 {
    return Intl.message(
      'Heading 1',
      name: 'mobileHeading1',
      desc: '',
      args: [],
    );
  }

  /// `Heading 2`
  String get mobileHeading2 {
    return Intl.message(
      'Heading 2',
      name: 'mobileHeading2',
      desc: '',
      args: [],
    );
  }

  /// `Heading 3`
  String get mobileHeading3 {
    return Intl.message(
      'Heading 3',
      name: 'mobileHeading3',
      desc: '',
      args: [],
    );
  }

  /// `Text Color`
  String get textColor {
    return Intl.message(
      'Text Color',
      name: 'textColor',
      desc: '',
      args: [],
    );
  }

  /// `Background Color`
  String get backgroundColor {
    return Intl.message(
      'Background Color',
      name: 'backgroundColor',
      desc: '',
      args: [],
    );
  }

  /// `Add your link`
  String get addYourLink {
    return Intl.message(
      'Add your link',
      name: 'addYourLink',
      desc: '',
      args: [],
    );
  }

  /// `Open link`
  String get openLink {
    return Intl.message(
      'Open link',
      name: 'openLink',
      desc: '',
      args: [],
    );
  }

  /// `Copy link`
  String get copyLink {
    return Intl.message(
      'Copy link',
      name: 'copyLink',
      desc: '',
      args: [],
    );
  }

  /// `Remove link`
  String get removeLink {
    return Intl.message(
      'Remove link',
      name: 'removeLink',
      desc: '',
      args: [],
    );
  }

  /// `Edit link`
  String get editLink {
    return Intl.message(
      'Edit link',
      name: 'editLink',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get linkText {
    return Intl.message(
      'Text',
      name: 'linkText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter text`
  String get linkTextHint {
    return Intl.message(
      'Please enter text',
      name: 'linkTextHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter URL`
  String get linkAddressHint {
    return Intl.message(
      'Please enter URL',
      name: 'linkAddressHint',
      desc: '',
      args: [],
    );
  }

  /// `Highlight Color`
  String get highlightColor {
    return Intl.message(
      'Highlight Color',
      name: 'highlightColor',
      desc: '',
      args: [],
    );
  }

  /// `Clear highlight color`
  String get clearHighlightColor {
    return Intl.message(
      'Clear highlight color',
      name: 'clearHighlightColor',
      desc: '',
      args: [],
    );
  }

  /// `Custom color`
  String get customColor {
    return Intl.message(
      'Custom color',
      name: 'customColor',
      desc: '',
      args: [],
    );
  }

  /// `Hex value`
  String get hexValue {
    return Intl.message(
      'Hex value',
      name: 'hexValue',
      desc: '',
      args: [],
    );
  }

  /// `Opacity`
  String get opacity {
    return Intl.message(
      'Opacity',
      name: 'opacity',
      desc: '',
      args: [],
    );
  }

  /// `Reset to default color`
  String get resetToDefaultColor {
    return Intl.message(
      'Reset to default color',
      name: 'resetToDefaultColor',
      desc: '',
      args: [],
    );
  }

  /// `LTR`
  String get ltr {
    return Intl.message(
      'LTR',
      name: 'ltr',
      desc: '',
      args: [],
    );
  }

  /// `RTL`
  String get rtl {
    return Intl.message(
      'RTL',
      name: 'rtl',
      desc: '',
      args: [],
    );
  }

  /// `Automatic`
  String get auto {
    return Intl.message(
      'Automatic',
      name: 'auto',
      desc: '',
      args: [],
    );
  }

  /// `Cut`
  String get cut {
    return Intl.message(
      'Cut',
      name: 'cut',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Paste`
  String get paste {
    return Intl.message(
      'Paste',
      name: 'paste',
      desc: '',
      args: [],
    );
  }

  /// `Find`
  String get find {
    return Intl.message(
      'Find',
      name: 'find',
      desc: '',
      args: [],
    );
  }

  /// `Previous match`
  String get previousMatch {
    return Intl.message(
      'Previous match',
      name: 'previousMatch',
      desc: '',
      args: [],
    );
  }

  /// `Next match`
  String get nextMatch {
    return Intl.message(
      'Next match',
      name: 'nextMatch',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get closeFind {
    return Intl.message(
      'Close',
      name: 'closeFind',
      desc: '',
      args: [],
    );
  }

  /// `Replace all`
  String get replaceAll {
    return Intl.message(
      'Replace all',
      name: 'replaceAll',
      desc: '',
      args: [],
    );
  }

  /// `Regex`
  String get regex {
    return Intl.message(
      'Regex',
      name: 'regex',
      desc: '',
      args: [],
    );
  }

  /// `Case sensitive`
  String get caseSensitive {
    return Intl.message(
      'Case sensitive',
      name: 'caseSensitive',
      desc: '',
      args: [],
    );
  }

  /// `Regex Error`
  String get regexError {
    return Intl.message(
      'Regex Error',
      name: 'regexError',
      desc: '',
      args: [],
    );
  }

  /// `No result`
  String get noFindResult {
    return Intl.message(
      'No result',
      name: 'noFindResult',
      desc: '',
      args: [],
    );
  }

  /// `Enter a pattern`
  String get emptySearchBoxHint {
    return Intl.message(
      'Enter a pattern',
      name: 'emptySearchBoxHint',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get uploadImage {
    return Intl.message(
      'Upload',
      name: 'uploadImage',
      desc: '',
      args: [],
    );
  }

  /// `URL`
  String get urlImage {
    return Intl.message(
      'URL',
      name: 'urlImage',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect Link`
  String get incorrectLink {
    return Intl.message(
      'Incorrect Link',
      name: 'incorrectLink',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `Choose an image`
  String get chooseImage {
    return Intl.message(
      'Choose an image',
      name: 'chooseImage',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Could not load the image`
  String get imageLoadFailed {
    return Intl.message(
      'Could not load the image',
      name: 'imageLoadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Divider`
  String get divider {
    return Intl.message(
      'Divider',
      name: 'divider',
      desc: '',
      args: [],
    );
  }

  /// `Add before`
  String get colAddBefore {
    return Intl.message(
      'Add before',
      name: 'colAddBefore',
      desc: '',
      args: [],
    );
  }

  /// `Add before`
  String get rowAddBefore {
    return Intl.message(
      'Add before',
      name: 'rowAddBefore',
      desc: '',
      args: [],
    );
  }

  /// `Add after`
  String get colAddAfter {
    return Intl.message(
      'Add after',
      name: 'colAddAfter',
      desc: '',
      args: [],
    );
  }

  /// `Add after`
  String get rowAddAfter {
    return Intl.message(
      'Add after',
      name: 'rowAddAfter',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get colRemove {
    return Intl.message(
      'Remove',
      name: 'colRemove',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get rowRemove {
    return Intl.message(
      'Remove',
      name: 'rowRemove',
      desc: '',
      args: [],
    );
  }

  /// `Duplicate`
  String get colDuplicate {
    return Intl.message(
      'Duplicate',
      name: 'colDuplicate',
      desc: '',
      args: [],
    );
  }

  /// `Duplicate`
  String get rowDuplicate {
    return Intl.message(
      'Duplicate',
      name: 'rowDuplicate',
      desc: '',
      args: [],
    );
  }

  /// `Clear Content`
  String get colClear {
    return Intl.message(
      'Clear Content',
      name: 'colClear',
      desc: '',
      args: [],
    );
  }

  /// `Clear Content`
  String get rowClear {
    return Intl.message(
      'Clear Content',
      name: 'rowClear',
      desc: '',
      args: [],
    );
  }

  /// `Enter a / to insert a block, or start typing`
  String get slashPlaceHolder {
    return Intl.message(
      'Enter a / to insert a block, or start typing',
      name: 'slashPlaceHolder',
      desc: '',
      args: [],
    );
  }

  /// `Align Left`
  String get textAlignLeft {
    return Intl.message(
      'Align Left',
      name: 'textAlignLeft',
      desc: '',
      args: [],
    );
  }

  /// `Align Center`
  String get textAlignCenter {
    return Intl.message(
      'Align Center',
      name: 'textAlignCenter',
      desc: '',
      args: [],
    );
  }

  /// `Align Right`
  String get textAlignRight {
    return Intl.message(
      'Align Right',
      name: 'textAlignRight',
      desc: '',
      args: [],
    );
  }

  /// `Convert to link`
  String get cmdConvertToLink {
    return Intl.message(
      'Convert to link',
      name: 'cmdConvertToLink',
      desc: '',
      args: [],
    );
  }

  /// `convert to paragraph`
  String get cmdConvertToParagraph {
    return Intl.message(
      'convert to paragraph',
      name: 'cmdConvertToParagraph',
      desc: '',
      args: [],
    );
  }

  /// `Copy selection`
  String get cmdCopySelection {
    return Intl.message(
      'Copy selection',
      name: 'cmdCopySelection',
      desc: '',
      args: [],
    );
  }

  /// `Cut selection`
  String get cmdCutSelection {
    return Intl.message(
      'Cut selection',
      name: 'cmdCutSelection',
      desc: '',
      args: [],
    );
  }

  /// `Delete character to the left`
  String get cmdDeleteLeft {
    return Intl.message(
      'Delete character to the left',
      name: 'cmdDeleteLeft',
      desc: '',
      args: [],
    );
  }

  /// `Delete to beginning of line`
  String get cmdDeleteLineLeft {
    return Intl.message(
      'Delete to beginning of line',
      name: 'cmdDeleteLineLeft',
      desc: '',
      args: [],
    );
  }

  /// `Delete character to the right`
  String get cmdDeleteRight {
    return Intl.message(
      'Delete character to the right',
      name: 'cmdDeleteRight',
      desc: '',
      args: [],
    );
  }

  /// `delete word at left`
  String get cmdDeleteWordLeft {
    return Intl.message(
      'delete word at left',
      name: 'cmdDeleteWordLeft',
      desc: '',
      args: [],
    );
  }

  /// `delete word at right`
  String get cmdDeleteWordRight {
    return Intl.message(
      'delete word at right',
      name: 'cmdDeleteWordRight',
      desc: '',
      args: [],
    );
  }

  /// `exit editing mode`
  String get cmdExitEditing {
    return Intl.message(
      'exit editing mode',
      name: 'cmdExitEditing',
      desc: '',
      args: [],
    );
  }

  /// `indent`
  String get cmdIndent {
    return Intl.message(
      'indent',
      name: 'cmdIndent',
      desc: '',
      args: [],
    );
  }

  /// `move cursor to the bottom`
  String get cmdMoveCursorBottom {
    return Intl.message(
      'move cursor to the bottom',
      name: 'cmdMoveCursorBottom',
      desc: '',
      args: [],
    );
  }

  /// `Select all until end of file`
  String get cmdMoveCursorBottomSelect {
    return Intl.message(
      'Select all until end of file',
      name: 'cmdMoveCursorBottomSelect',
      desc: '',
      args: [],
    );
  }

  /// `move cursor down`
  String get cmdMoveCursorDown {
    return Intl.message(
      'move cursor down',
      name: 'cmdMoveCursorDown',
      desc: '',
      args: [],
    );
  }

  /// `Select downward`
  String get cmdMoveCursorDownSelect {
    return Intl.message(
      'Select downward',
      name: 'cmdMoveCursorDownSelect',
      desc: '',
      args: [],
    );
  }

  /// `move cursor left`
  String get cmdMoveCursorLeft {
    return Intl.message(
      'move cursor left',
      name: 'cmdMoveCursorLeft',
      desc: '',
      args: [],
    );
  }

  /// `Select left`
  String get cmdMoveCursorLeftSelect {
    return Intl.message(
      'Select left',
      name: 'cmdMoveCursorLeftSelect',
      desc: '',
      args: [],
    );
  }

  /// `move cursor to the end of line`
  String get cmdMoveCursorLineEnd {
    return Intl.message(
      'move cursor to the end of line',
      name: 'cmdMoveCursorLineEnd',
      desc: '',
      args: [],
    );
  }

  /// `Select to end of line`
  String get cmdMoveCursorLineEndSelect {
    return Intl.message(
      'Select to end of line',
      name: 'cmdMoveCursorLineEndSelect',
      desc: '',
      args: [],
    );
  }

  /// `move cursor to start of line`
  String get cmdMoveCursorLineStart {
    return Intl.message(
      'move cursor to start of line',
      name: 'cmdMoveCursorLineStart',
      desc: '',
      args: [],
    );
  }

  /// `Select to start of line`
  String get cmdMoveCursorLineStartSelect {
    return Intl.message(
      'Select to start of line',
      name: 'cmdMoveCursorLineStartSelect',
      desc: '',
      args: [],
    );
  }

  /// `move cursor right`
  String get cmdMoveCursorRight {
    return Intl.message(
      'move cursor right',
      name: 'cmdMoveCursorRight',
      desc: '',
      args: [],
    );
  }

  /// `Select right`
  String get cmdMoveCursorRightSelect {
    return Intl.message(
      'Select right',
      name: 'cmdMoveCursorRightSelect',
      desc: '',
      args: [],
    );
  }

  /// `move cursor to the top`
  String get cmdMoveCursorTop {
    return Intl.message(
      'move cursor to the top',
      name: 'cmdMoveCursorTop',
      desc: '',
      args: [],
    );
  }

  /// `Select all until start of file`
  String get cmdMoveCursorTopSelect {
    return Intl.message(
      'Select all until start of file',
      name: 'cmdMoveCursorTopSelect',
      desc: '',
      args: [],
    );
  }

  /// `move cursor up`
  String get cmdMoveCursorUp {
    return Intl.message(
      'move cursor up',
      name: 'cmdMoveCursorUp',
      desc: '',
      args: [],
    );
  }

  /// `Select upward`
  String get cmdMoveCursorUpSelect {
    return Intl.message(
      'Select upward',
      name: 'cmdMoveCursorUpSelect',
      desc: '',
      args: [],
    );
  }

  /// `move cursor to word on the left`
  String get cmdMoveCursorWordLeft {
    return Intl.message(
      'move cursor to word on the left',
      name: 'cmdMoveCursorWordLeft',
      desc: '',
      args: [],
    );
  }

  /// `Select word to the left`
  String get cmdMoveCursorWordLeftSelect {
    return Intl.message(
      'Select word to the left',
      name: 'cmdMoveCursorWordLeftSelect',
      desc: '',
      args: [],
    );
  }

  /// `move cursor to word on the right`
  String get cmdMoveCursorWordRight {
    return Intl.message(
      'move cursor to word on the right',
      name: 'cmdMoveCursorWordRight',
      desc: '',
      args: [],
    );
  }

  /// `Select word to the right`
  String get cmdMoveCursorWordRightSelect {
    return Intl.message(
      'Select word to the right',
      name: 'cmdMoveCursorWordRightSelect',
      desc: '',
      args: [],
    );
  }

  /// `Open Find`
  String get cmdOpenFind {
    return Intl.message(
      'Open Find',
      name: 'cmdOpenFind',
      desc: '',
      args: [],
    );
  }

  /// `Open Find and Replace`
  String get cmdOpenFindAndReplace {
    return Intl.message(
      'Open Find and Replace',
      name: 'cmdOpenFindAndReplace',
      desc: '',
      args: [],
    );
  }

  /// `open link`
  String get cmdOpenLink {
    return Intl.message(
      'open link',
      name: 'cmdOpenLink',
      desc: '',
      args: [],
    );
  }

  /// `open links`
  String get cmdOpenLinks {
    return Intl.message(
      'open links',
      name: 'cmdOpenLinks',
      desc: '',
      args: [],
    );
  }

  /// `outdent`
  String get cmdOutdent {
    return Intl.message(
      'outdent',
      name: 'cmdOutdent',
      desc: '',
      args: [],
    );
  }

  /// `paste content`
  String get cmdPasteContent {
    return Intl.message(
      'paste content',
      name: 'cmdPasteContent',
      desc: '',
      args: [],
    );
  }

  /// `paste content as plain text`
  String get cmdPasteContentAsPlainText {
    return Intl.message(
      'paste content as plain text',
      name: 'cmdPasteContentAsPlainText',
      desc: '',
      args: [],
    );
  }

  /// `redo`
  String get cmdRedo {
    return Intl.message(
      'redo',
      name: 'cmdRedo',
      desc: '',
      args: [],
    );
  }

  /// `scroll page down`
  String get cmdScrollPageDown {
    return Intl.message(
      'scroll page down',
      name: 'cmdScrollPageDown',
      desc: '',
      args: [],
    );
  }

  /// `scroll page up`
  String get cmdScrollPageUp {
    return Intl.message(
      'scroll page up',
      name: 'cmdScrollPageUp',
      desc: '',
      args: [],
    );
  }

  /// `scroll to bottom`
  String get cmdScrollToBottom {
    return Intl.message(
      'scroll to bottom',
      name: 'cmdScrollToBottom',
      desc: '',
      args: [],
    );
  }

  /// `scroll to top`
  String get cmdScrollToTop {
    return Intl.message(
      'scroll to top',
      name: 'cmdScrollToTop',
      desc: '',
      args: [],
    );
  }

  /// `select all`
  String get cmdSelectAll {
    return Intl.message(
      'select all',
      name: 'cmdSelectAll',
      desc: '',
      args: [],
    );
  }

  /// `Table: add line break`
  String get cmdTableLineBreak {
    return Intl.message(
      'Table: add line break',
      name: 'cmdTableLineBreak',
      desc: '',
      args: [],
    );
  }

  /// `Move to down cell at same offset`
  String get cmdTableMoveToDownCellAtSameOffset {
    return Intl.message(
      'Move to down cell at same offset',
      name: 'cmdTableMoveToDownCellAtSameOffset',
      desc: '',
      args: [],
    );
  }

  /// `Move to left cell if its at start of current cell`
  String get cmdTableMoveToLeftCellIfItsAtStartOfCurrentCell {
    return Intl.message(
      'Move to left cell if its at start of current cell',
      name: 'cmdTableMoveToLeftCellIfItsAtStartOfCurrentCell',
      desc: '',
      args: [],
    );
  }

  /// `Move to right cell if its at the end of current cell`
  String get cmdTableMoveToRightCellIfItsAtTheEndOfCurrentCell {
    return Intl.message(
      'Move to right cell if its at the end of current cell',
      name: 'cmdTableMoveToRightCellIfItsAtTheEndOfCurrentCell',
      desc: '',
      args: [],
    );
  }

  /// `Move to up cell at same offset`
  String get cmdTableMoveToUpCellAtSameOffset {
    return Intl.message(
      'Move to up cell at same offset',
      name: 'cmdTableMoveToUpCellAtSameOffset',
      desc: '',
      args: [],
    );
  }

  /// `Navigate around the cells at same offset`
  String get cmdTableNavigateCells {
    return Intl.message(
      'Navigate around the cells at same offset',
      name: 'cmdTableNavigateCells',
      desc: '',
      args: [],
    );
  }

  /// `Navigate around the cells at same offset in reverse`
  String get cmdTableNavigateCellsReverse {
    return Intl.message(
      'Navigate around the cells at same offset in reverse',
      name: 'cmdTableNavigateCellsReverse',
      desc: '',
      args: [],
    );
  }

  /// `Stop at the beginning of the cell`
  String get cmdTableStopAtTheBeginningOfTheCell {
    return Intl.message(
      'Stop at the beginning of the cell',
      name: 'cmdTableStopAtTheBeginningOfTheCell',
      desc: '',
      args: [],
    );
  }

  /// `toggle bold`
  String get cmdToggleBold {
    return Intl.message(
      'toggle bold',
      name: 'cmdToggleBold',
      desc: '',
      args: [],
    );
  }

  /// `toggle code`
  String get cmdToggleCode {
    return Intl.message(
      'toggle code',
      name: 'cmdToggleCode',
      desc: '',
      args: [],
    );
  }

  /// `toggle highlight`
  String get cmdToggleHighlight {
    return Intl.message(
      'toggle highlight',
      name: 'cmdToggleHighlight',
      desc: '',
      args: [],
    );
  }

  /// `toggle italic`
  String get cmdToggleItalic {
    return Intl.message(
      'toggle italic',
      name: 'cmdToggleItalic',
      desc: '',
      args: [],
    );
  }

  /// `toggle strikethrough`
  String get cmdToggleStrikethrough {
    return Intl.message(
      'toggle strikethrough',
      name: 'cmdToggleStrikethrough',
      desc: '',
      args: [],
    );
  }

  /// `toggle the todo list`
  String get cmdToggleTodoList {
    return Intl.message(
      'toggle the todo list',
      name: 'cmdToggleTodoList',
      desc: '',
      args: [],
    );
  }

  /// `toggle underline`
  String get cmdToggleUnderline {
    return Intl.message(
      'toggle underline',
      name: 'cmdToggleUnderline',
      desc: '',
      args: [],
    );
  }

  /// `undo`
  String get cmdUndo {
    return Intl.message(
      'undo',
      name: 'cmdUndo',
      desc: '',
      args: [],
    );
  }

  /// `note`
  String get note_text {
    return Intl.message(
      'note',
      name: 'note_text',
      desc: '',
      args: [],
    );
  }

  /// `Previous match`
  String get previous_match {
    return Intl.message(
      'Previous match',
      name: 'previous_match',
      desc: '',
      args: [],
    );
  }

  /// `Next match`
  String get next_match {
    return Intl.message(
      'Next match',
      name: 'next_match',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Replace all`
  String get replace_all {
    return Intl.message(
      'Replace all',
      name: 'replace_all',
      desc: '',
      args: [],
    );
  }

  /// `No result`
  String get no_result {
    return Intl.message(
      'No result',
      name: 'no_result',
      desc: '',
      args: [],
    );
  }

  /// `add subtask`
  String get add_subtask {
    return Intl.message(
      'add subtask',
      name: 'add_subtask',
      desc: '',
      args: [],
    );
  }

  /// `Pin`
  String get pin {
    return Intl.message(
      'Pin',
      name: 'pin',
      desc: '',
      args: [],
    );
  }

  /// `Discard`
  String get discard {
    return Intl.message(
      'Discard',
      name: 'discard',
      desc: '',
      args: [],
    );
  }

  /// `Label`
  String get label {
    return Intl.message(
      'Label',
      name: 'label',
      desc: '',
      args: [],
    );
  }

  /// `Task Activity`
  String get task_activity {
    return Intl.message(
      'Task Activity',
      name: 'task_activity',
      desc: '',
      args: [],
    );
  }

  /// `Save as Template`
  String get save_as_template {
    return Intl.message(
      'Save as Template',
      name: 'save_as_template',
      desc: '',
      args: [],
    );
  }

  /// `Create Copy`
  String get create_copy {
    return Intl.message(
      'Create Copy',
      name: 'create_copy',
      desc: '',
      args: [],
    );
  }

  /// `Copy link`
  String get copy_link {
    return Intl.message(
      'Copy link',
      name: 'copy_link',
      desc: '',
      args: [],
    );
  }

  /// `Open Sticky Note`
  String get open_sticky_note {
    return Intl.message(
      'Open Sticky Note',
      name: 'open_sticky_note',
      desc: '',
      args: [],
    );
  }

  /// `Convert to Note`
  String get convert_to_note {
    return Intl.message(
      'Convert to Note',
      name: 'convert_to_note',
      desc: '',
      args: [],
    );
  }

  /// `Print`
  String get print {
    return Intl.message(
      'Print',
      name: 'print',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Go to Login Page`
  String get to_login {
    return Intl.message(
      'Go to Login Page',
      name: 'to_login',
      desc: '',
      args: [],
    );
  }

  /// `Password set successfully, go to login`
  String get reset_to_login_page {
    return Intl.message(
      'Password set successfully, go to login',
      name: 'reset_to_login_page',
      desc: '',
      args: [],
    );
  }

  /// `Login/Register`
  String get login_or_register {
    return Intl.message(
      'Login/Register',
      name: 'login_or_register',
      desc: '',
      args: [],
    );
  }

  /// `Password reset email has been sent to your email`
  String get reset_password_has_been_sent {
    return Intl.message(
      'Password reset email has been sent to your email',
      name: 'reset_password_has_been_sent',
      desc: '',
      args: [],
    );
  }

  /// `User exists, you can reset your password`
  String get user_exist_reset_password {
    return Intl.message(
      'User exists, you can reset your password',
      name: 'user_exist_reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Copy list '{title}'`
  String copy_mission_model(Object title) {
    return Intl.message(
      'Copy list \'$title\'',
      name: 'copy_mission_model',
      desc: '',
      args: [title],
    );
  }

  /// `Confirmation email has been sent to your email, please check your email to verify and login with your password`
  String get login_email_to_verifie {
    return Intl.message(
      'Confirmation email has been sent to your email, please check your email to verify and login with your password',
      name: 'login_email_to_verifie',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get please_input_correct_email {
    return Intl.message(
      'Please enter a valid email',
      name: 'please_input_correct_email',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get please_input_email {
    return Intl.message(
      'Please enter your email',
      name: 'please_input_email',
      desc: '',
      args: [],
    );
  }

  /// `Total {num}`
  String total_maju(Object num) {
    return Intl.message(
      'Total $num',
      name: 'total_maju',
      desc: '',
      args: [num],
    );
  }

  /// `From {date1} to {date2}`
  String between_date(Object date1, Object date2) {
    return Intl.message(
      'From $date1 to $date2',
      name: 'between_date',
      desc: '',
      args: [date1, date2],
    );
  }

  /// `After {date}`
  String after_date(Object date) {
    return Intl.message(
      'After $date',
      name: 'after_date',
      desc: '',
      args: [date],
    );
  }

  /// `Before {date}`
  String before_date(Object date) {
    return Intl.message(
      'Before $date',
      name: 'before_date',
      desc: '',
      args: [date],
    );
  }

  /// `Number of missions`
  String get num_mission {
    return Intl.message(
      'Number of missions',
      name: 'num_mission',
      desc: '',
      args: [],
    );
  }

  /// `ALL`
  String get all_maju {
    return Intl.message(
      'ALL',
      name: 'all_maju',
      desc: '',
      args: [],
    );
  }

  /// `(No project)`
  String get no_project_parenthese {
    return Intl.message(
      '(No project)',
      name: 'no_project_parenthese',
      desc: '',
      args: [],
    );
  }

  /// `{num} missions / {total} total missions`
  String num_mission_percent(Object num, Object total) {
    return Intl.message(
      '$num missions / $total total missions',
      name: 'num_mission_percent',
      desc: '',
      args: [num, total],
    );
  }

  /// `Total {num} tomatoes`
  String total_tomatoes(Object num) {
    return Intl.message(
      'Total $num tomatoes',
      name: 'total_tomatoes',
      desc: '',
      args: [num],
    );
  }

  /// `{num} tomatoes`
  String num_tomatoes(Object num) {
    return Intl.message(
      '$num tomatoes',
      name: 'num_tomatoes',
      desc: '',
      args: [num],
    );
  }

  /// `Lyubichs duration`
  String get lyubichs {
    return Intl.message(
      'Lyubichs duration',
      name: 'lyubichs',
      desc: '',
      args: [],
    );
  }

  /// `Do it now represents tasks that need to be done immediately. Setting 'Do it now' will initiate a countdown.`
  String get do_it_now_desc {
    return Intl.message(
      'Do it now represents tasks that need to be done immediately. Setting \'Do it now\' will initiate a countdown.',
      name: 'do_it_now_desc',
      desc: '',
      args: [],
    );
  }

  /// `New Task Resets Timer`
  String get focus_switch_title {
    return Intl.message(
      'New Task Resets Timer',
      name: 'focus_switch_title',
      desc: '',
      args: [],
    );
  }

  /// `Does switching tasks during focus reset the timer?`
  String get focus_switch_desc {
    return Intl.message(
      'Does switching tasks during focus reset the timer?',
      name: 'focus_switch_desc',
      desc: '',
      args: [],
    );
  }

  /// `Copy the link and share it with your friends, so they can join the group list by the group code {code}`
  String copy_link_description(Object code) {
    return Intl.message(
      'Copy the link and share it with your friends, so they can join the group list by the group code $code',
      name: 'copy_link_description',
      desc: '',
      args: [code],
    );
  }

  /// `The group list number for {listing_name} is {code}. Download {app_name}, enter the group list number, and you can work with your partners.`
  String share_the_link(Object listing_name, Object code, Object app_name) {
    return Intl.message(
      'The group list number for $listing_name is $code. Download $app_name, enter the group list number, and you can work with your partners.',
      name: 'share_the_link',
      desc: '',
      args: [listing_name, code, app_name],
    );
  }

  /// `Password is incorrect`
  String get password_incorrect {
    return Intl.message(
      'Password is incorrect',
      name: 'password_incorrect',
      desc: '',
      args: [],
    );
  }

  /// `Content cannot be empty`
  String get content_cannot_be_empty {
    return Intl.message(
      'Content cannot be empty',
      name: 'content_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Dismiss the group`
  String get dismiss_group {
    return Intl.message(
      'Dismiss the group',
      name: 'dismiss_group',
      desc: '',
      args: [],
    );
  }

  /// `Leave the group`
  String get leave_group {
    return Intl.message(
      'Leave the group',
      name: 'leave_group',
      desc: '',
      args: [],
    );
  }

  /// `Who can view/edit files`
  String get who_can_view_edit_files {
    return Intl.message(
      'Who can view/edit files',
      name: 'who_can_view_edit_files',
      desc: '',
      args: [],
    );
  }

  /// `Only me`
  String get only_me {
    return Intl.message(
      'Only me',
      name: 'only_me',
      desc: '',
      args: [],
    );
  }

  /// `Everyone can view`
  String get everyone_can_view {
    return Intl.message(
      'Everyone can view',
      name: 'everyone_can_view',
      desc: '',
      args: [],
    );
  }

  /// `Everyone can edit`
  String get everyone_can_edit {
    return Intl.message(
      'Everyone can edit',
      name: 'everyone_can_edit',
      desc: '',
      args: [],
    );
  }

  /// `Set a password for the group. Users need to enter the password to join the group list.`
  String get set_password_for_group {
    return Intl.message(
      'Set a password for the group. Users need to enter the password to join the group list.',
      name: 'set_password_for_group',
      desc: '',
      args: [],
    );
  }

  /// `Set a 6-digit password`
  String get set_6_digit_password {
    return Intl.message(
      'Set a 6-digit password',
      name: 'set_6_digit_password',
      desc: '',
      args: [],
    );
  }

  /// `Password is correct`
  String get password_correct {
    return Intl.message(
      'Password is correct',
      name: 'password_correct',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a 6-digit password`
  String get please_enter_6_digit_password {
    return Intl.message(
      'Please enter a 6-digit password',
      name: 'please_enter_6_digit_password',
      desc: '',
      args: [],
    );
  }

  /// `Password set successfully`
  String get password_set_success {
    return Intl.message(
      'Password set successfully',
      name: 'password_set_success',
      desc: '',
      args: [],
    );
  }

  /// `Password required for sharing files`
  String get password_required_for_sharing {
    return Intl.message(
      'Password required for sharing files',
      name: 'password_required_for_sharing',
      desc: '',
      args: [],
    );
  }

  /// `Only share with friends`
  String get only_share_with_friends {
    return Intl.message(
      'Only share with friends',
      name: 'only_share_with_friends',
      desc: '',
      args: [],
    );
  }

  /// `Can view`
  String get can_view {
    return Intl.message(
      'Can view',
      name: 'can_view',
      desc: '',
      args: [],
    );
  }

  /// `Can edit`
  String get can_edit {
    return Intl.message(
      'Can edit',
      name: 'can_edit',
      desc: '',
      args: [],
    );
  }

  /// `Share to`
  String get share_to {
    return Intl.message(
      'Share to',
      name: 'share_to',
      desc: '',
      args: [],
    );
  }

  /// `Generate image`
  String get generate_image {
    return Intl.message(
      'Generate image',
      name: 'generate_image',
      desc: '',
      args: [],
    );
  }

  /// `Generate QR code`
  String get generate_qr_code {
    return Intl.message(
      'Generate QR code',
      name: 'generate_qr_code',
      desc: '',
      args: [],
    );
  }

  /// `Administrator`
  String get administrator {
    return Intl.message(
      'Administrator',
      name: 'administrator',
      desc: '',
      args: [],
    );
  }

  /// `Offline`
  String get offline {
    return Intl.message(
      'Offline',
      name: 'offline',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message(
      'Online',
      name: 'online',
      desc: '',
      args: [],
    );
  }

  /// `in focus`
  String get focusing {
    return Intl.message(
      'in focus',
      name: 'focusing',
      desc: '',
      args: [],
    );
  }

  /// `Relaxing`
  String get relaxing {
    return Intl.message(
      'Relaxing',
      name: 'relaxing',
      desc: '',
      args: [],
    );
  }

  /// `Cannot handle myself`
  String get cannot_handle_myself {
    return Intl.message(
      'Cannot handle myself',
      name: 'cannot_handle_myself',
      desc: '',
      args: [],
    );
  }

  /// `Long rest duration`
  String get long_rest_duration {
    return Intl.message(
      'Long rest duration',
      name: 'long_rest_duration',
      desc: '',
      args: [],
    );
  }

  /// `Long rest interval`
  String get long_rest_interval {
    return Intl.message(
      'Long rest interval',
      name: 'long_rest_interval',
      desc: '',
      args: [],
    );
  }

  /// `Remove user`
  String get remove_user {
    return Intl.message(
      'Remove user',
      name: 'remove_user',
      desc: '',
      args: [],
    );
  }

  /// `Cancel administrator`
  String get cancel_setting_administrator {
    return Intl.message(
      'Cancel administrator',
      name: 'cancel_setting_administrator',
      desc: '',
      args: [],
    );
  }

  /// `Set as administrator`
  String get setting_administrator {
    return Intl.message(
      'Set as administrator',
      name: 'setting_administrator',
      desc: '',
      args: [],
    );
  }

  /// `Add group listing`
  String get add_group_listing {
    return Intl.message(
      'Add group listing',
      name: 'add_group_listing',
      desc: '',
      args: [],
    );
  }

  /// `Sharing listing`
  String get sharing_listing {
    return Intl.message(
      'Sharing listing',
      name: 'sharing_listing',
      desc: '',
      args: [],
    );
  }

  /// `Group announcement`
  String get group_announcement {
    return Intl.message(
      'Group announcement',
      name: 'group_announcement',
      desc: '',
      args: [],
    );
  }

  /// `Group ID: {id}`
  String group_id(Object id) {
    return Intl.message(
      'Group ID: $id',
      name: 'group_id',
      desc: '',
      args: [id],
    );
  }

  /// `Enter the list number to search the list`
  String get join_group_code_desc {
    return Intl.message(
      'Enter the list number to search the list',
      name: 'join_group_code_desc',
      desc: '',
      args: [],
    );
  }

  /// `Enter the list number`
  String get join_group_code {
    return Intl.message(
      'Enter the list number',
      name: 'join_group_code',
      desc: '',
      args: [],
    );
  }

  /// `Already in the group`
  String get already_in_group {
    return Intl.message(
      'Already in the group',
      name: 'already_in_group',
      desc: '',
      args: [],
    );
  }

  /// `share`
  String get share {
    return Intl.message(
      'share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Who can view/edit files`
  String get who_can_view_or_edit {
    return Intl.message(
      'Who can view/edit files',
      name: 'who_can_view_or_edit',
      desc: '',
      args: [],
    );
  }

  /// `View only`
  String get view_only {
    return Intl.message(
      'View only',
      name: 'view_only',
      desc: '',
      args: [],
    );
  }

  /// `Advanced permissions: can set restrictions on copying, commenting, etc.`
  String get advanced_permissions {
    return Intl.message(
      'Advanced permissions: can set restrictions on copying, commenting, etc.',
      name: 'advanced_permissions',
      desc: '',
      args: [],
    );
  }

  /// `QQ friends`
  String get qq_friends {
    return Intl.message(
      'QQ friends',
      name: 'qq_friends',
      desc: '',
      args: [],
    );
  }

  /// `WeChat friends`
  String get wechat_friends {
    return Intl.message(
      'WeChat friends',
      name: 'wechat_friends',
      desc: '',
      args: [],
    );
  }

  /// `App lock supports lock screen password settings`
  String get lock_screen_auto_password_setting_for_applock {
    return Intl.message(
      'App lock supports lock screen password settings',
      name: 'lock_screen_auto_password_setting_for_applock',
      desc: '',
      args: [],
    );
  }

  /// `Lock Screen Auto-Password Setting`
  String get lock_screen_auto_password_setting {
    return Intl.message(
      'Lock Screen Auto-Password Setting',
      name: 'lock_screen_auto_password_setting',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get please_confirm_your_password {
    return Intl.message(
      'Please confirm your password',
      name: 'please_confirm_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Lock Screen Password Setting`
  String get lock_screen_password_setting {
    return Intl.message(
      'Lock Screen Password Setting',
      name: 'lock_screen_password_setting',
      desc: '',
      args: [],
    );
  }

  /// `please create your password`
  String get please_create_ur_password {
    return Intl.message(
      'please create your password',
      name: 'please_create_ur_password',
      desc: '',
      args: [],
    );
  }

  /// `please enter your password`
  String get please_enter_ur_password {
    return Intl.message(
      'please enter your password',
      name: 'please_enter_ur_password',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get report2 {
    return Intl.message(
      'Report',
      name: 'report2',
      desc: '',
      args: [],
    );
  }

  /// `Create Chat`
  String get create_chat {
    return Intl.message(
      'Create Chat',
      name: 'create_chat',
      desc: '',
      args: [],
    );
  }

  /// `Please input your question`
  String get please_input_first_gpt_sentence {
    return Intl.message(
      'Please input your question',
      name: 'please_input_first_gpt_sentence',
      desc: '',
      args: [],
    );
  }

  /// `The browser does not support multiline input. For a better experience, you can download the client.`
  String get browser_not_support_multiline {
    return Intl.message(
      'The browser does not support multiline input. For a better experience, you can download the client.',
      name: 'browser_not_support_multiline',
      desc: '',
      args: [],
    );
  }

  /// `Module Filtering Setting`
  String get module_filtering_setting {
    return Intl.message(
      'Module Filtering Setting',
      name: 'module_filtering_setting',
      desc: '',
      args: [],
    );
  }

  /// `Create Mission`
  String get create_mission {
    return Intl.message(
      'Create Mission',
      name: 'create_mission',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get preview {
    return Intl.message(
      'Preview',
      name: 'preview',
      desc: '',
      args: [],
    );
  }

  /// `Give me chart\nListing:\nTime:`
  String get search_chart_listing_title_content {
    return Intl.message(
      'Give me chart\nListing:\nTime:',
      name: 'search_chart_listing_title_content',
      desc: '',
      args: [],
    );
  }

  /// `Give me listing chart`
  String get search_chart_listingtitle {
    return Intl.message(
      'Give me listing chart',
      name: 'search_chart_listingtitle',
      desc: '',
      args: [],
    );
  }

  /// `Give me chart\nTime:`
  String get search_chart_title_content {
    return Intl.message(
      'Give me chart\nTime:',
      name: 'search_chart_title_content',
      desc: '',
      args: [],
    );
  }

  /// `Give me chart`
  String get search_chart_title {
    return Intl.message(
      'Give me chart',
      name: 'search_chart_title',
      desc: '',
      args: [],
    );
  }

  /// `Chart`
  String get search_chart_by_gpt {
    return Intl.message(
      'Chart',
      name: 'search_chart_by_gpt',
      desc: '',
      args: [],
    );
  }

  /// `Give me listing data:\nListing Title:\nDescription:`
  String get search_listing_content {
    return Intl.message(
      'Give me listing data:\nListing Title:\nDescription:',
      name: 'search_listing_content',
      desc: '',
      args: [],
    );
  }

  /// `Give me listing data`
  String get search_listing_title {
    return Intl.message(
      'Give me listing data',
      name: 'search_listing_title',
      desc: '',
      args: [],
    );
  }

  /// `Search Listings & Missions`
  String get search_listing_by_gpt {
    return Intl.message(
      'Search Listings & Missions',
      name: 'search_listing_by_gpt',
      desc: '',
      args: [],
    );
  }

  /// `Give me chart\nTime:`
  String get create_mission_title_content {
    return Intl.message(
      'Give me chart\nTime:',
      name: 'create_mission_title_content',
      desc: '',
      args: [],
    );
  }

  /// `Give me chart`
  String get create_mission_title {
    return Intl.message(
      'Give me chart',
      name: 'create_mission_title',
      desc: '',
      args: [],
    );
  }

  /// `Help me create a mission:\nMission Title:\nDescription:`
  String get create_mission_by_content {
    return Intl.message(
      'Help me create a mission:\nMission Title:\nDescription:',
      name: 'create_mission_by_content',
      desc: '',
      args: [],
    );
  }

  /// `Create Mission`
  String get create_mission_by_title {
    return Intl.message(
      'Create Mission',
      name: 'create_mission_by_title',
      desc: '',
      args: [],
    );
  }

  /// `Create Mission or Listing`
  String get create_mission_by_gpt {
    return Intl.message(
      'Create Mission or Listing',
      name: 'create_mission_by_gpt',
      desc: '',
      args: [],
    );
  }

  /// `Acting as {app_name}'s timekeeper`
  String gpt_role(Object app_name) {
    return Intl.message(
      'Acting as $app_name\'s timekeeper',
      name: 'gpt_role',
      desc: '',
      args: [app_name],
    );
  }

  /// `Click to view`
  String get click_to_view {
    return Intl.message(
      'Click to view',
      name: 'click_to_view',
      desc: '',
      args: [],
    );
  }

  /// `{date1} to {date2}`
  String date1_to_date2(Object date1, Object date2) {
    return Intl.message(
      '$date1 to $date2',
      name: 'date1_to_date2',
      desc: '',
      args: [date1, date2],
    );
  }

  /// `Time segment`
  String get time_segment {
    return Intl.message(
      'Time segment',
      name: 'time_segment',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Apple Login`
  String get apple_login {
    return Intl.message(
      'Apple Login',
      name: 'apple_login',
      desc: '',
      args: [],
    );
  }

  /// `Hide`
  String get popup_invisible3 {
    return Intl.message(
      'Hide',
      name: 'popup_invisible3',
      desc: '',
      args: [],
    );
  }

  /// `Show`
  String get popup_visible2 {
    return Intl.message(
      'Show',
      name: 'popup_visible2',
      desc: '',
      args: [],
    );
  }

  /// `Display Content`
  String get popup_select1 {
    return Intl.message(
      'Display Content',
      name: 'popup_select1',
      desc: '',
      args: [],
    );
  }

  /// `Focus Setting`
  String get focus_setting {
    return Intl.message(
      'Focus Setting',
      name: 'focus_setting',
      desc: '',
      args: [],
    );
  }

  /// `Filtering Setting`
  String get filtering_setting {
    return Intl.message(
      'Filtering Setting',
      name: 'filtering_setting',
      desc: '',
      args: [],
    );
  }

  /// `To-Do List`
  String get todo_listing {
    return Intl.message(
      'To-Do List',
      name: 'todo_listing',
      desc: '',
      args: [],
    );
  }

  /// `Fragment List`
  String get fragment_listing {
    return Intl.message(
      'Fragment List',
      name: 'fragment_listing',
      desc: '',
      args: [],
    );
  }

  /// `RULES FOR AI`
  String get rules_for_ai {
    return Intl.message(
      'RULES FOR AI',
      name: 'rules_for_ai',
      desc: '',
      args: [],
    );
  }

  /// `Enter up to {num} characters`
  String max_input_num(Object num) {
    return Intl.message(
      'Enter up to $num characters',
      name: 'max_input_num',
      desc: '',
      args: [num],
    );
  }

  /// `e.g.."always describe in bullet points, never use unwrap, always output your answers in English"`
  String get example_demo_hint {
    return Intl.message(
      'e.g.."always describe in bullet points, never use unwrap, always output your answers in English"',
      name: 'example_demo_hint',
      desc: '',
      args: [],
    );
  }

  /// `Search chat history`
  String get hint_search_chat {
    return Intl.message(
      'Search chat history',
      name: 'hint_search_chat',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message(
      'Chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `Me`
  String get me {
    return Intl.message(
      'Me',
      name: 'me',
      desc: '',
      args: [],
    );
  }

  /// `Unselected`
  String get unselected {
    return Intl.message(
      'Unselected',
      name: 'unselected',
      desc: '',
      args: [],
    );
  }

  /// `Create {Folder}`
  String create_xxx(Object Folder) {
    return Intl.message(
      'Create $Folder',
      name: 'create_xxx',
      desc: '',
      args: [Folder],
    );
  }

  /// `Please input {xxx}`
  String please_input_xxx_name(Object xxx) {
    return Intl.message(
      'Please input $xxx',
      name: 'please_input_xxx_name',
      desc: '',
      args: [xxx],
    );
  }

  /// `Folder Name`
  String get folder_name {
    return Intl.message(
      'Folder Name',
      name: 'folder_name',
      desc: '',
      args: [],
    );
  }

  /// `Create Folder`
  String get create_folder_desc {
    return Intl.message(
      'Create Folder',
      name: 'create_folder_desc',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the list and related sub-tasks under the folder "{folderName}"?`
  String confirm_delete_mission_models(Object folderName) {
    return Intl.message(
      'Are you sure you want to delete the list and related sub-tasks under the folder "$folderName"?',
      name: 'confirm_delete_mission_models',
      desc: '',
      args: [folderName],
    );
  }

  /// `It cannot be restored after deletion`
  String get confirm_delete_folder_desc {
    return Intl.message(
      'It cannot be restored after deletion',
      name: 'confirm_delete_folder_desc',
      desc: '',
      args: [],
    );
  }

  /// `Confirm delete folder "{folderName}"`
  String confirm_delete_folder(Object folderName) {
    return Intl.message(
      'Confirm delete folder "$folderName"',
      name: 'confirm_delete_folder',
      desc: '',
      args: [folderName],
    );
  }

  /// `Folder`
  String get folder {
    return Intl.message(
      'Folder',
      name: 'folder',
      desc: '',
      args: [],
    );
  }

  /// `Please input the correct password first`
  String get input_correct_password {
    return Intl.message(
      'Please input the correct password first',
      name: 'input_correct_password',
      desc: '',
      args: [],
    );
  }

  /// `The local password is correct, you can directly create tasks`
  String get password_correct_desc {
    return Intl.message(
      'The local password is correct, you can directly create tasks',
      name: 'password_correct_desc',
      desc: '',
      args: [],
    );
  }

  /// `No tasks available, you need to create tasks first`
  String get no_mission_desc {
    return Intl.message(
      'No tasks available, you need to create tasks first',
      name: 'no_mission_desc',
      desc: '',
      args: [],
    );
  }

  /// `Quadrants, categories, lists, groups, timelines, schedules, Gantt charts, calendars - various views to meet all your needs`
  String get multi_view_desc {
    return Intl.message(
      'Quadrants, categories, lists, groups, timelines, schedules, Gantt charts, calendars - various views to meet all your needs',
      name: 'multi_view_desc',
      desc: '',
      args: [],
    );
  }

  /// `Multiple Views`
  String get multi_view {
    return Intl.message(
      'Multiple Views',
      name: 'multi_view',
      desc: '',
      args: [],
    );
  }

  /// `Real-time data analysis to help you better understand yourself`
  String get data_analyse_desc {
    return Intl.message(
      'Real-time data analysis to help you better understand yourself',
      name: 'data_analyse_desc',
      desc: '',
      args: [],
    );
  }

  /// `Data Analysis`
  String get data_analyse {
    return Intl.message(
      'Data Analysis',
      name: 'data_analyse',
      desc: '',
      args: [],
    );
  }

  /// `Multiple background sounds to enter a state of deep focus`
  String get focus_timer_desc {
    return Intl.message(
      'Multiple background sounds to enter a state of deep focus',
      name: 'focus_timer_desc',
      desc: '',
      args: [],
    );
  }

  /// `Focus Timer`
  String get focus_timer {
    return Intl.message(
      'Focus Timer',
      name: 'focus_timer',
      desc: '',
      args: [],
    );
  }

  /// `Develop a habit in 21 days, Ebbinghaus' long-term memory of what's learned`
  String get habit_clockin_desc {
    return Intl.message(
      'Develop a habit in 21 days, Ebbinghaus\' long-term memory of what\'s learned',
      name: 'habit_clockin_desc',
      desc: '',
      args: [],
    );
  }

  /// `Habit Clock-in`
  String get habit_clockin {
    return Intl.message(
      'Habit Clock-in',
      name: 'habit_clockin',
      desc: '',
      args: [],
    );
  }

  /// `Clear and concise, constantly reminding`
  String get todo_list_desc {
    return Intl.message(
      'Clear and concise, constantly reminding',
      name: 'todo_list_desc',
      desc: '',
      args: [],
    );
  }

  /// `Please input the original password`
  String get please_origin_password {
    return Intl.message(
      'Please input the original password',
      name: 'please_origin_password',
      desc: '',
      args: [],
    );
  }

  /// `Numeric password incorrect`
  String get digit_password_incorrect {
    return Intl.message(
      'Numeric password incorrect',
      name: 'digit_password_incorrect',
      desc: '',
      args: [],
    );
  }

  /// `Please input the password for the list '{name}'`
  String please_input_folder_password(Object name) {
    return Intl.message(
      'Please input the password for the list \'$name\'',
      name: 'please_input_folder_password',
      desc: '',
      args: [name],
    );
  }

  /// `Please input a 6-digit numeric password`
  String get input_6_digit_password {
    return Intl.message(
      'Please input a 6-digit numeric password',
      name: 'input_6_digit_password',
      desc: '',
      args: [],
    );
  }

  /// `Local numeric password`
  String get local_password {
    return Intl.message(
      'Local numeric password',
      name: 'local_password',
      desc: '',
      args: [],
    );
  }

  /// `The local numeric password is only stored on the phone after encryption, and will not be uploaded to the server or synchronized with other devices. You can set the local numeric password in settings`
  String get local_password_desc {
    return Intl.message(
      'The local numeric password is only stored on the phone after encryption, and will not be uploaded to the server or synchronized with other devices. You can set the local numeric password in settings',
      name: 'local_password_desc',
      desc: '',
      args: [],
    );
  }

  /// `Normal`
  String get normal {
    return Intl.message(
      'Normal',
      name: 'normal',
      desc: '',
      args: [],
    );
  }

  /// `Encrypt`
  String get encrypt {
    return Intl.message(
      'Encrypt',
      name: 'encrypt',
      desc: '',
      args: [],
    );
  }

  /// `Decrypt`
  String get decrypt {
    return Intl.message(
      'Decrypt',
      name: 'decrypt',
      desc: '',
      args: [],
    );
  }

  /// `After encryption, it can only be decrypted using your numeric password. It is recommended to use this feature for sensitive data, otherwise, it may affect the user experience`
  String get encrypt_desc {
    return Intl.message(
      'After encryption, it can only be decrypted using your numeric password. It is recommended to use this feature for sensitive data, otherwise, it may affect the user experience',
      name: 'encrypt_desc',
      desc: '',
      args: [],
    );
  }

  /// `Please set your numeric password`
  String get encrypt_password {
    return Intl.message(
      'Please set your numeric password',
      name: 'encrypt_password',
      desc: '',
      args: [],
    );
  }

  /// `Please re-enter your numeric password`
  String get encrypt_password_confirm {
    return Intl.message(
      'Please re-enter your numeric password',
      name: 'encrypt_password_confirm',
      desc: '',
      args: [],
    );
  }

  /// `The two passwords entered do not match`
  String get encrypt_password_not_match {
    return Intl.message(
      'The two passwords entered do not match',
      name: 'encrypt_password_not_match',
      desc: '',
      args: [],
    );
  }

  /// `You have not set a numeric password`
  String get encrypt_password_not_set {
    return Intl.message(
      'You have not set a numeric password',
      name: 'encrypt_password_not_set',
      desc: '',
      args: [],
    );
  }

  /// `Store numeric password locally`
  String get encrypt_store_password {
    return Intl.message(
      'Store numeric password locally',
      name: 'encrypt_store_password',
      desc: '',
      args: [],
    );
  }

  /// `Light Mode`
  String get light_mode {
    return Intl.message(
      'Light Mode',
      name: 'light_mode',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get dark_mode {
    return Intl.message(
      'Dark Mode',
      name: 'dark_mode',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Create Reproducibility`
  String get micro_mastery_step4 {
    return Intl.message(
      'Create Reproducibility',
      name: 'micro_mastery_step4',
      desc: '',
      args: [],
    );
  }

  /// `Create Clear Rewards`
  String get micro_mastery_step3 {
    return Intl.message(
      'Create Clear Rewards',
      name: 'micro_mastery_step3',
      desc: '',
      args: [],
    );
  }

  /// `Gain Background Support`
  String get micro_mastery_step2 {
    return Intl.message(
      'Gain Background Support',
      name: 'micro_mastery_step2',
      desc: '',
      args: [],
    );
  }

  /// `Find Entry-Level Skills`
  String get micro_mastery_step1 {
    return Intl.message(
      'Find Entry-Level Skills',
      name: 'micro_mastery_step1',
      desc: '',
      args: [],
    );
  }

  /// `Micro Mastery`
  String get micro_mastery {
    return Intl.message(
      'Micro Mastery',
      name: 'micro_mastery',
      desc: '',
      args: [],
    );
  }

  /// `Micro Mastery\n\nWe are often told that to master something, we must pour all our passion into it and spend 10,000 hours in rigorous practice. However, in reality, most successful people, including Nobel Prize winners, use their spare time to learn new skills and start new activities.\n\nMicro Mastery can be divided into 4 parts\n1. Find Entry-Level Skills - Start with practice, not theory, based on simple attempts by industry experts\n2. Gain Background Support - Engage in something to gain motivation, buy equipment, create a sense of ceremony, etc.\n3. Create Clear Rewards - Receive positive and negative feedback, form a virtuous cycle, teach others, etc., apply what is learned, and avoid aimlessness and procrastination\n4. Create Reproducibility - Be able to repeat continuously, improve with each repetition, and make progress, which can lead to increasing confidence and a sharper observation ability\n\nSuccess Case\nSteve Jobs, who applied the calligraphy art he learned from skipping college classes globally to Mac, designing computers from an artistic perspective, which became very popular`
  String get micro_mastery_desc {
    return Intl.message(
      'Micro Mastery\n\nWe are often told that to master something, we must pour all our passion into it and spend 10,000 hours in rigorous practice. However, in reality, most successful people, including Nobel Prize winners, use their spare time to learn new skills and start new activities.\n\nMicro Mastery can be divided into 4 parts\n1. Find Entry-Level Skills - Start with practice, not theory, based on simple attempts by industry experts\n2. Gain Background Support - Engage in something to gain motivation, buy equipment, create a sense of ceremony, etc.\n3. Create Clear Rewards - Receive positive and negative feedback, form a virtuous cycle, teach others, etc., apply what is learned, and avoid aimlessness and procrastination\n4. Create Reproducibility - Be able to repeat continuously, improve with each repetition, and make progress, which can lead to increasing confidence and a sharper observation ability\n\nSuccess Case\nSteve Jobs, who applied the calligraphy art he learned from skipping college classes globally to Mac, designing computers from an artistic perspective, which became very popular',
      name: 'micro_mastery_desc',
      desc: '',
      args: [],
    );
  }

  /// `Today's Focus Duration`
  String get today_focus_duration {
    return Intl.message(
      'Today\'s Focus Duration',
      name: 'today_focus_duration',
      desc: '',
      args: [],
    );
  }

  /// `Today's Focus Record`
  String get today_focus_record {
    return Intl.message(
      'Today\'s Focus Record',
      name: 'today_focus_record',
      desc: '',
      args: [],
    );
  }

  /// `Create a group from January to December`
  String get jan_to_dec_desc {
    return Intl.message(
      'Create a group from January to December',
      name: 'jan_to_dec_desc',
      desc: '',
      args: [],
    );
  }

  /// `Create a group from the first to the fourth quarter`
  String get four_seasons_desc {
    return Intl.message(
      'Create a group from the first to the fourth quarter',
      name: 'four_seasons_desc',
      desc: '',
      args: [],
    );
  }

  /// `January to December`
  String get jan_to_dec {
    return Intl.message(
      'January to December',
      name: 'jan_to_dec',
      desc: '',
      args: [],
    );
  }

  /// `Fourth Quarter`
  String get four_seasons_step4 {
    return Intl.message(
      'Fourth Quarter',
      name: 'four_seasons_step4',
      desc: '',
      args: [],
    );
  }

  /// `Third Quarter`
  String get four_seasons_step3 {
    return Intl.message(
      'Third Quarter',
      name: 'four_seasons_step3',
      desc: '',
      args: [],
    );
  }

  /// `Second Quarter`
  String get four_seasons_step2 {
    return Intl.message(
      'Second Quarter',
      name: 'four_seasons_step2',
      desc: '',
      args: [],
    );
  }

  /// `First Quarter`
  String get four_seasons_step1 {
    return Intl.message(
      'First Quarter',
      name: 'four_seasons_step1',
      desc: '',
      args: [],
    );
  }

  /// `First to Fourth Quarter`
  String get four_seasons {
    return Intl.message(
      'First to Fourth Quarter',
      name: 'four_seasons',
      desc: '',
      args: [],
    );
  }

  /// `Plan`
  String get pdpa_step1 {
    return Intl.message(
      'Plan',
      name: 'pdpa_step1',
      desc: '',
      args: [],
    );
  }

  /// `Do`
  String get pdpa_step2 {
    return Intl.message(
      'Do',
      name: 'pdpa_step2',
      desc: '',
      args: [],
    );
  }

  /// `Check`
  String get pdpa_step3 {
    return Intl.message(
      'Check',
      name: 'pdpa_step3',
      desc: '',
      args: [],
    );
  }

  /// `Action`
  String get pdpa_step4 {
    return Intl.message(
      'Action',
      name: 'pdpa_step4',
      desc: '',
      args: [],
    );
  }

  /// `Review and Summary`
  String get gtd_step5 {
    return Intl.message(
      'Review and Summary',
      name: 'gtd_step5',
      desc: '',
      args: [],
    );
  }

  /// `Take Action`
  String get gtd_step4 {
    return Intl.message(
      'Take Action',
      name: 'gtd_step4',
      desc: '',
      args: [],
    );
  }

  /// `Organize`
  String get gtd_step3 {
    return Intl.message(
      'Organize',
      name: 'gtd_step3',
      desc: '',
      args: [],
    );
  }

  /// `Clarify Meaning`
  String get gtd_step2 {
    return Intl.message(
      'Clarify Meaning',
      name: 'gtd_step2',
      desc: '',
      args: [],
    );
  }

  /// `Collect Information`
  String get gtd_step1 {
    return Intl.message(
      'Collect Information',
      name: 'gtd_step1',
      desc: '',
      args: [],
    );
  }

  /// `The five steps of GTD:；\n (1) Collect everything that has our attention;\n(2) Clarify the meaning and actions associated with each collection;\n(3) Organize the outcomes, listing the next actions for each item;\n(4) Take action;\n(5) Regularly review and reflect.`
  String get gtd_desc {
    return Intl.message(
      'The five steps of GTD:；\n (1) Collect everything that has our attention;\n(2) Clarify the meaning and actions associated with each collection;\n(3) Organize the outcomes, listing the next actions for each item;\n(4) Take action;\n(5) Regularly review and reflect.',
      name: 'gtd_desc',
      desc: '',
      args: [],
    );
  }

  /// `GTD`
  String get gtd {
    return Intl.message(
      'GTD',
      name: 'gtd',
      desc: '',
      args: [],
    );
  }

  /// `P (Planning) - Planning function includes three parts: goal, plan, and budget.\nD (Design) - Design solutions and layouts.\nC (4C) - 4C management: Check, Communicate, Clean, Control.\nA (2A) - Act (execute, deal with the results of the summary check), Aim (act according to the goal requirements, such as improvement, enhancement).`
  String get pdpa_desc {
    return Intl.message(
      'P (Planning) - Planning function includes three parts: goal, plan, and budget.\nD (Design) - Design solutions and layouts.\nC (4C) - 4C management: Check, Communicate, Clean, Control.\nA (2A) - Act (execute, deal with the results of the summary check), Aim (act according to the goal requirements, such as improvement, enhancement).',
      name: 'pdpa_desc',
      desc: '',
      args: [],
    );
  }

  /// `PDCA`
  String get pdpa {
    return Intl.message(
      'PDCA',
      name: 'pdpa',
      desc: '',
      args: [],
    );
  }

  /// `Move Left`
  String get move_to_previous {
    return Intl.message(
      'Move Left',
      name: 'move_to_previous',
      desc: '',
      args: [],
    );
  }

  /// `Move Right`
  String get move_to_next {
    return Intl.message(
      'Move Right',
      name: 'move_to_next',
      desc: '',
      args: [],
    );
  }

  /// `Jump to Previous Group`
  String get jump_previous_group {
    return Intl.message(
      'Jump to Previous Group',
      name: 'jump_previous_group',
      desc: '',
      args: [],
    );
  }

  /// `Jump to Next Group`
  String get jump_next_group {
    return Intl.message(
      'Jump to Next Group',
      name: 'jump_next_group',
      desc: '',
      args: [],
    );
  }

  /// `Add Group on the Right`
  String get add_group_on_the_right {
    return Intl.message(
      'Add Group on the Right',
      name: 'add_group_on_the_right',
      desc: '',
      args: [],
    );
  }

  /// `Add Group on the Left`
  String get add_group_on_the_left {
    return Intl.message(
      'Add Group on the Left',
      name: 'add_group_on_the_left',
      desc: '',
      args: [],
    );
  }

  /// `Rename`
  String get rename {
    return Intl.message(
      'Rename',
      name: 'rename',
      desc: '',
      args: [],
    );
  }

  /// `Select Background Color`
  String get select_background_color {
    return Intl.message(
      'Select Background Color',
      name: 'select_background_color',
      desc: '',
      args: [],
    );
  }

  /// `Cannot reorder when adding a group`
  String get add_group_cannot_reorder {
    return Intl.message(
      'Cannot reorder when adding a group',
      name: 'add_group_cannot_reorder',
      desc: '',
      args: [],
    );
  }

  /// `Unordered group cannot be sorted`
  String get unorder_group_not_order_toast {
    return Intl.message(
      'Unordered group cannot be sorted',
      name: 'unorder_group_not_order_toast',
      desc: '',
      args: [],
    );
  }

  /// `Unordered group`
  String get unorder_group {
    return Intl.message(
      'Unordered group',
      name: 'unorder_group',
      desc: '',
      args: [],
    );
  }

  /// `Add group`
  String get add_group {
    return Intl.message(
      'Add group',
      name: 'add_group',
      desc: '',
      args: [],
    );
  }

  /// `Timeline view`
  String get timelineview {
    return Intl.message(
      'Timeline view',
      name: 'timelineview',
      desc: '',
      args: [],
    );
  }

  /// `Group view`
  String get groupview {
    return Intl.message(
      'Group view',
      name: 'groupview',
      desc: '',
      args: [],
    );
  }

  /// `List view`
  String get listview {
    return Intl.message(
      'List view',
      name: 'listview',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message(
      'View',
      name: 'view',
      desc: '',
      args: [],
    );
  }

  /// `Rotate screen`
  String get screen_rorate {
    return Intl.message(
      'Rotate screen',
      name: 'screen_rorate',
      desc: '',
      args: [],
    );
  }

  /// `Portrait`
  String get vertical {
    return Intl.message(
      'Portrait',
      name: 'vertical',
      desc: '',
      args: [],
    );
  }

  /// `Landscape`
  String get landscape {
    return Intl.message(
      'Landscape',
      name: 'landscape',
      desc: '',
      args: [],
    );
  }

  /// `Pure mode`
  String get pure_mode {
    return Intl.message(
      'Pure mode',
      name: 'pure_mode',
      desc: '',
      args: [],
    );
  }

  /// `Switch font`
  String get switch_font {
    return Intl.message(
      'Switch font',
      name: 'switch_font',
      desc: '',
      args: [],
    );
  }

  /// `All finished tasks`
  String get all_finished_mission {
    return Intl.message(
      'All finished tasks',
      name: 'all_finished_mission',
      desc: '',
      args: [],
    );
  }

  /// `All tasks`
  String get all_mission {
    return Intl.message(
      'All tasks',
      name: 'all_mission',
      desc: '',
      args: [],
    );
  }

  /// `Please set your hourly value first {value}$/hour`
  String mission_value_toast(Object value) {
    return Intl.message(
      'Please set your hourly value first $value\$/hour',
      name: 'mission_value_toast',
      desc: '',
      args: [value],
    );
  }

  /// `Open https://www.timerbell.com in a browser to use the same function anywhere`
  String get web_desc {
    return Intl.message(
      'Open https://www.timerbell.com in a browser to use the same function anywhere',
      name: 'web_desc',
      desc: '',
      args: [],
    );
  }

  /// `Unarchive`
  String get unarchive {
    return Intl.message(
      'Unarchive',
      name: 'unarchive',
      desc: '',
      args: [],
    );
  }

  /// `Archive`
  String get archive {
    return Intl.message(
      'Archive',
      name: 'archive',
      desc: '',
      args: [],
    );
  }

  /// `Wallpaper`
  String get background {
    return Intl.message(
      'Wallpaper',
      name: 'background',
      desc: '',
      args: [],
    );
  }

  /// `Manual`
  String get manual {
    return Intl.message(
      'Manual',
      name: 'manual',
      desc: '',
      args: [],
    );
  }

  /// `Task List`
  String get tasks_list {
    return Intl.message(
      'Task List',
      name: 'tasks_list',
      desc: '',
      args: [],
    );
  }

  /// `note`
  String get note_plain {
    return Intl.message(
      'note',
      name: 'note_plain',
      desc: '',
      args: [],
    );
  }

  /// `File size exceeds 5MB, please select a smaller file.`
  String get max_5m_files_size {
    return Intl.message(
      'File size exceeds 5MB, please select a smaller file.',
      name: 'max_5m_files_size',
      desc: '',
      args: [],
    );
  }

  /// `{value}$/hour`
  String value_per_hour(Object value) {
    return Intl.message(
      '$value\$/hour',
      name: 'value_per_hour',
      desc: '',
      args: [value],
    );
  }

  /// `value:{value}`
  String value(Object value) {
    return Intl.message(
      'value:$value',
      name: 'value',
      desc: '',
      args: [value],
    );
  }

  /// `Mission value`
  String get mission_value {
    return Intl.message(
      'Mission value',
      name: 'mission_value',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number cannot be empty, please enter the mobile number!`
  String get input_mobile {
    return Intl.message(
      'Mobile number cannot be empty, please enter the mobile number!',
      name: 'input_mobile',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the correct mobile number`
  String get input_correct_mobile {
    return Intl.message(
      'Please enter the correct mobile number',
      name: 'input_correct_mobile',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get password_at_least_6 {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'password_at_least_6',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty, please enter the password!`
  String get password_not_empty {
    return Intl.message(
      'Password cannot be empty, please enter the password!',
      name: 'password_not_empty',
      desc: '',
      args: [],
    );
  }

  /// `$`
  String get dollar {
    return Intl.message(
      '\$',
      name: 'dollar',
      desc: '',
      args: [],
    );
  }

  /// `The mission's evaluation value($)`
  String get mission_evaluation_value {
    return Intl.message(
      'The mission\'s evaluation value(\$)',
      name: 'mission_evaluation_value',
      desc: '',
      args: [],
    );
  }

  /// `My work value per hour`
  String get my_money_per_hour {
    return Intl.message(
      'My work value per hour',
      name: 'my_money_per_hour',
      desc: '',
      args: [],
    );
  }

  /// `Work value per hour($)`
  String get money_per_hour {
    return Intl.message(
      'Work value per hour(\$)',
      name: 'money_per_hour',
      desc: '',
      args: [],
    );
  }

  /// `Current version {version}`
  String version_num(Object version) {
    return Intl.message(
      'Current version $version',
      name: 'version_num',
      desc: '',
      args: [version],
    );
  }

  /// `Historical event`
  String get history_event {
    return Intl.message(
      'Historical event',
      name: 'history_event',
      desc: '',
      args: [],
    );
  }

  /// `End time cannot be earlier than start time`
  String get endtime_cannot_before_starttime {
    return Intl.message(
      'End time cannot be earlier than start time',
      name: 'endtime_cannot_before_starttime',
      desc: '',
      args: [],
    );
  }

  /// `Delay mission`
  String get delay_mission {
    return Intl.message(
      'Delay mission',
      name: 'delay_mission',
      desc: '',
      args: [],
    );
  }

  /// `Already delayed`
  String get already_delay {
    return Intl.message(
      'Already delayed',
      name: 'already_delay',
      desc: '',
      args: [],
    );
  }

  /// `Postpone to today`
  String get postpone {
    return Intl.message(
      'Postpone to today',
      name: 'postpone',
      desc: '',
      args: [],
    );
  }

  /// `This mission is a cycle mission`
  String get this_mission_is_cycle_mission {
    return Intl.message(
      'This mission is a cycle mission',
      name: 'this_mission_is_cycle_mission',
      desc: '',
      args: [],
    );
  }

  /// `Close all cycle missions`
  String get close_all_cycle_mission {
    return Intl.message(
      'Close all cycle missions',
      name: 'close_all_cycle_mission',
      desc: '',
      args: [],
    );
  }

  /// `Mission setting`
  String get mission_setting {
    return Intl.message(
      'Mission setting',
      name: 'mission_setting',
      desc: '',
      args: [],
    );
  }

  /// `Note and multi-mission`
  String get note_and_multimission {
    return Intl.message(
      'Note and multi-mission',
      name: 'note_and_multimission',
      desc: '',
      args: [],
    );
  }

  /// `Bill cleared`
  String get bill_cleared {
    return Intl.message(
      'Bill cleared',
      name: 'bill_cleared',
      desc: '',
      args: [],
    );
  }

  /// `Repayment`
  String get repayment {
    return Intl.message(
      'Repayment',
      name: 'repayment',
      desc: '',
      args: [],
    );
  }

  /// `Add credit card bill`
  String get add_credit_card_bill {
    return Intl.message(
      'Add credit card bill',
      name: 'add_credit_card_bill',
      desc: '',
      args: [],
    );
  }

  /// `Bill this statement`
  String get bill_this_statement {
    return Intl.message(
      'Bill this statement',
      name: 'bill_this_statement',
      desc: '',
      args: [],
    );
  }

  /// `Bill detail`
  String get bill_detail {
    return Intl.message(
      'Bill detail',
      name: 'bill_detail',
      desc: '',
      args: [],
    );
  }

  /// `Repayment day`
  String get repayment_day {
    return Intl.message(
      'Repayment day',
      name: 'repayment_day',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the amount`
  String get enter_amount {
    return Intl.message(
      'Please enter the amount',
      name: 'enter_amount',
      desc: '',
      args: [],
    );
  }

  /// `Repayment channel`
  String get repayment_channel {
    return Intl.message(
      'Repayment channel',
      name: 'repayment_channel',
      desc: '',
      args: [],
    );
  }

  /// `Mark repaid amount`
  String get mark_repaid_amount {
    return Intl.message(
      'Mark repaid amount',
      name: 'mark_repaid_amount',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Repayment record`
  String get repayment_record {
    return Intl.message(
      'Repayment record',
      name: 'repayment_record',
      desc: '',
      args: [],
    );
  }

  /// `Update credit card bill`
  String get update_credit_card_bill {
    return Intl.message(
      'Update credit card bill',
      name: 'update_credit_card_bill',
      desc: '',
      args: [],
    );
  }

  /// `Add bill`
  String get add_bill {
    return Intl.message(
      'Add bill',
      name: 'add_bill',
      desc: '',
      args: [],
    );
  }

  /// `Days after bill day`
  String get days_after_bill_day {
    return Intl.message(
      'Days after bill day',
      name: 'days_after_bill_day',
      desc: '',
      args: [],
    );
  }

  /// `Bill day`
  String get bill_day {
    return Intl.message(
      'Bill day',
      name: 'bill_day',
      desc: '',
      args: [],
    );
  }

  /// `All pending repayment`
  String get all_pending_repayment {
    return Intl.message(
      'All pending repayment',
      name: 'all_pending_repayment',
      desc: '',
      args: [],
    );
  }

  /// `Days after repayment day`
  String get days_after_repayment_day {
    return Intl.message(
      'Days after repayment day',
      name: 'days_after_repayment_day',
      desc: '',
      args: [],
    );
  }

  /// `Repaid`
  String get repaid {
    return Intl.message(
      'Repaid',
      name: 'repaid',
      desc: '',
      args: [],
    );
  }

  /// `Card number`
  String get card_number {
    return Intl.message(
      'Card number',
      name: 'card_number',
      desc: '',
      args: [],
    );
  }

  /// `Bank`
  String get bank {
    return Intl.message(
      'Bank',
      name: 'bank',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Current amount`
  String get current_amount {
    return Intl.message(
      'Current amount',
      name: 'current_amount',
      desc: '',
      args: [],
    );
  }

  /// `Credit limit`
  String get credit_limit {
    return Intl.message(
      'Credit limit',
      name: 'credit_limit',
      desc: '',
      args: [],
    );
  }

  /// `Billing day`
  String get billing_day {
    return Intl.message(
      'Billing day',
      name: 'billing_day',
      desc: '',
      args: [],
    );
  }

  /// `Add bill`
  String get addBill {
    return Intl.message(
      'Add bill',
      name: 'addBill',
      desc: '',
      args: [],
    );
  }

  /// `Add bill, remind repayment, avoid expectation`
  String get addBillReminder {
    return Intl.message(
      'Add bill, remind repayment, avoid expectation',
      name: 'addBillReminder',
      desc: '',
      args: [],
    );
  }

  /// `Please enter full card number`
  String get enterFullCardNumber {
    return Intl.message(
      'Please enter full card number',
      name: 'enterFullCardNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter bank name`
  String get enterBankName {
    return Intl.message(
      'Please enter bank name',
      name: 'enterBankName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter real name`
  String get enterRealName {
    return Intl.message(
      'Please enter real name',
      name: 'enterRealName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter bill amount`
  String get enterBillAmount {
    return Intl.message(
      'Please enter bill amount',
      name: 'enterBillAmount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter credit limit (optional)`
  String get enterCreditLimit {
    return Intl.message(
      'Please enter credit limit (optional)',
      name: 'enterCreditLimit',
      desc: '',
      args: [],
    );
  }

  /// `Card bag`
  String get credit_bag {
    return Intl.message(
      'Card bag',
      name: 'credit_bag',
      desc: '',
      args: [],
    );
  }

  /// `Overdue {days} days`
  String n_days_overdue(Object days) {
    return Intl.message(
      'Overdue $days days',
      name: 'n_days_overdue',
      desc: '',
      args: [days],
    );
  }

  /// `Please enter the bill amount`
  String get please_input_bill_amount {
    return Intl.message(
      'Please enter the bill amount',
      name: 'please_input_bill_amount',
      desc: '',
      args: [],
    );
  }

  /// `WeChat`
  String get wechat {
    return Intl.message(
      'WeChat',
      name: 'wechat',
      desc: '',
      args: [],
    );
  }

  /// `Alipay`
  String get alipay {
    return Intl.message(
      'Alipay',
      name: 'alipay',
      desc: '',
      args: [],
    );
  }

  /// `Repayment instantly`
  String get repayment_instantly {
    return Intl.message(
      'Repayment instantly',
      name: 'repayment_instantly',
      desc: '',
      args: [],
    );
  }

  /// `Mark repayment amount`
  String get mark_repayment_amount {
    return Intl.message(
      'Mark repayment amount',
      name: 'mark_repayment_amount',
      desc: '',
      args: [],
    );
  }

  /// `Update bill`
  String get update_bill {
    return Intl.message(
      'Update bill',
      name: 'update_bill',
      desc: '',
      args: [],
    );
  }

  /// `Request permission`
  String get request_permission {
    return Intl.message(
      'Request permission',
      name: 'request_permission',
      desc: '',
      args: [],
    );
  }

  /// `You may need the recording function when taking notes, and you need to authorize the microphone permission at this time`
  String get microphone_permission_description {
    return Intl.message(
      'You may need the recording function when taking notes, and you need to authorize the microphone permission at this time',
      name: 'microphone_permission_description',
      desc: '',
      args: [],
    );
  }

  /// `In order to use the camera function, you need to authorize the camera permission`
  String get camera_permission_description {
    return Intl.message(
      'In order to use the camera function, you need to authorize the camera permission',
      name: 'camera_permission_description',
      desc: '',
      args: [],
    );
  }

  /// `Your personal time management expert`
  String get your_time_prof {
    return Intl.message(
      'Your personal time management expert',
      name: 'your_time_prof',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to "{appName}"`
  String welcome_to_time_department(Object appName) {
    return Intl.message(
      'Welcome to "$appName"',
      name: 'welcome_to_time_department',
      desc: '',
      args: [appName],
    );
  }

  /// `Copy successful`
  String get copy_success {
    return Intl.message(
      'Copy successful',
      name: 'copy_success',
      desc: '',
      args: [],
    );
  }

  /// `Please search "{name}" in the app store`
  String please_seaarch_on_app_store(Object name) {
    return Intl.message(
      'Please search "$name" in the app store',
      name: 'please_seaarch_on_app_store',
      desc: '',
      args: [name],
    );
  }

  /// `Listing`
  String get listing {
    return Intl.message(
      'Listing',
      name: 'listing',
      desc: '',
      args: [],
    );
  }

  /// `overdue`
  String get overdue_buffer {
    return Intl.message(
      'overdue',
      name: 'overdue_buffer',
      desc: '',
      args: [],
    );
  }

  /// `Thirty minutes`
  String get thirty_mins {
    return Intl.message(
      'Thirty minutes',
      name: 'thirty_mins',
      desc: '',
      args: [],
    );
  }

  /// `One hour`
  String get one_hour {
    return Intl.message(
      'One hour',
      name: 'one_hour',
      desc: '',
      args: [],
    );
  }

  /// `Three hours`
  String get three_hours {
    return Intl.message(
      'Three hours',
      name: 'three_hours',
      desc: '',
      args: [],
    );
  }

  /// `Six hours`
  String get six_hours {
    return Intl.message(
      'Six hours',
      name: 'six_hours',
      desc: '',
      args: [],
    );
  }

  /// `Twelve hours`
  String get twelve_12hours {
    return Intl.message(
      'Twelve hours',
      name: 'twelve_12hours',
      desc: '',
      args: [],
    );
  }

  /// `Twenty one days`
  String get twenty_one_days {
    return Intl.message(
      'Twenty one days',
      name: 'twenty_one_days',
      desc: '',
      args: [],
    );
  }

  /// `One month`
  String get one_month {
    return Intl.message(
      'One month',
      name: 'one_month',
      desc: '',
      args: [],
    );
  }

  /// `Three months`
  String get three_months {
    return Intl.message(
      'Three months',
      name: 'three_months',
      desc: '',
      args: [],
    );
  }

  /// `Six months`
  String get six_months {
    return Intl.message(
      'Six months',
      name: 'six_months',
      desc: '',
      args: [],
    );
  }

  /// `One year`
  String get one_year {
    return Intl.message(
      'One year',
      name: 'one_year',
      desc: '',
      args: [],
    );
  }

  /// `Customize`
  String get customize {
    return Intl.message(
      'Customize',
      name: 'customize',
      desc: '',
      args: [],
    );
  }

  /// `Do it now`
  String get do_it_now {
    return Intl.message(
      'Do it now',
      name: 'do_it_now',
      desc: '',
      args: [],
    );
  }

  /// `Unset`
  String get unset {
    return Intl.message(
      'Unset',
      name: 'unset',
      desc: '',
      args: [],
    );
  }

  /// `Listing icon`
  String get listing_icon_optional {
    return Intl.message(
      'Listing icon',
      name: 'listing_icon_optional',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color_optional {
    return Intl.message(
      'Color',
      name: 'color_optional',
      desc: '',
      args: [],
    );
  }

  /// `List time (optional)`
  String get listing_time_optional {
    return Intl.message(
      'List time (optional)',
      name: 'listing_time_optional',
      desc: '',
      args: [],
    );
  }

  /// `{days} days`
  String num_days(Object days) {
    return Intl.message(
      '$days days',
      name: 'num_days',
      desc: '',
      args: [days],
    );
  }

  /// `Start Focusing`
  String get start_focus {
    return Intl.message(
      'Start Focusing',
      name: 'start_focus',
      desc: '',
      args: [],
    );
  }

  /// `Grid`
  String get grid {
    return Intl.message(
      'Grid',
      name: 'grid',
      desc: '',
      args: [],
    );
  }

  /// `List`
  String get list {
    return Intl.message(
      'List',
      name: 'list',
      desc: '',
      args: [],
    );
  }

  /// `{total} Recurring Task`
  String repeative_content(Object total) {
    return Intl.message(
      '$total Recurring Task',
      name: 'repeative_content',
      desc: '',
      args: [total],
    );
  }

  /// `Listing {num}/{total}`
  String num_mission_total(Object num, Object total) {
    return Intl.message(
      'Listing $num/$total',
      name: 'num_mission_total',
      desc: '',
      args: [num, total],
    );
  }

  /// `{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: Weekend Shopping List - November 5, folder_id: null, flomo_object_id: null, type: 3, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 0, wqbWrongQuestionContent: , wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: Content:\n\nFresh Fruits: Apples (around 2 kg), Oranges (1 net), Dragon Fruit (2 pcs)\nVegetables: Spinach (1 bunch), Tomatoes (5 pcs), Cucumbers (3 pcs)\nMeats: Chicken breast (500g), Beef steaks (2 pcs)\nSnacks: Potato Chips (2 bags), Chocolate (100g)\nHousehold Items: Hand soap (1 bottle), Dishwashing liquid (1 bottle), Toilet paper (1 pack)\nBeverages: Milk (1 carton), Green tea (1 pack)\n\nNotes:\n\nCheck for valid coupons and membership discounts\nPrefer organic products and eco-friendly packaging\nComplete shopping by 6:00 PM, wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}`
  String get memo_prompt {
    return Intl.message(
      '{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: Weekend Shopping List - November 5, folder_id: null, flomo_object_id: null, type: 3, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 0, wqbWrongQuestionContent: , wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: Content:\n\nFresh Fruits: Apples (around 2 kg), Oranges (1 net), Dragon Fruit (2 pcs)\nVegetables: Spinach (1 bunch), Tomatoes (5 pcs), Cucumbers (3 pcs)\nMeats: Chicken breast (500g), Beef steaks (2 pcs)\nSnacks: Potato Chips (2 bags), Chocolate (100g)\nHousehold Items: Hand soap (1 bottle), Dishwashing liquid (1 bottle), Toilet paper (1 pack)\nBeverages: Milk (1 carton), Green tea (1 pack)\n\nNotes:\n\nCheck for valid coupons and membership discounts\nPrefer organic products and eco-friendly packaging\nComplete shopping by 6:00 PM, wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}',
      name: 'memo_prompt',
      desc: '',
      args: [],
    );
  }

  /// `{createdAt: null, updatedAt: null, indexSearchingStart: null, state: 0, indexSearchingEnd: null, background_url: null, title: 1. Click on the upper rig, folder_id: null, flomo_object_id: null, type: 1, masterScore: 1.0, update_time: 1699019897598, causeAnalysis: [], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 0, wqbWrongQuestionContent: , wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 0, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: , wqbAnswerRichContentUrl: , content: 1. Click on the upper right corner and select Set to Desktop Components\n2. Desktop widgets can be set up on Android, iPhone, and Mac, device_id: B5CC32ED-595A-54B7-A814-7BC911FBD2D4, tagNames: [], tagIds: null, isFinished: null, color: 4291946748, order_index: 4, status: null, priorityStatus: null, uid: 0aa14757-7695-4e52-9b23-45f839a16715}`
  String get note_prompt {
    return Intl.message(
      '{createdAt: null, updatedAt: null, indexSearchingStart: null, state: 0, indexSearchingEnd: null, background_url: null, title: 1. Click on the upper rig, folder_id: null, flomo_object_id: null, type: 1, masterScore: 1.0, update_time: 1699019897598, causeAnalysis: [], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 0, wqbWrongQuestionContent: , wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 0, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: , wqbAnswerRichContentUrl: , content: 1. Click on the upper right corner and select Set to Desktop Components\n2. Desktop widgets can be set up on Android, iPhone, and Mac, device_id: B5CC32ED-595A-54B7-A814-7BC911FBD2D4, tagNames: [], tagIds: null, isFinished: null, color: 4291946748, order_index: 4, status: null, priorityStatus: null, uid: 0aa14757-7695-4e52-9b23-45f839a16715}',
      name: 'note_prompt',
      desc: '',
      args: [],
    );
  }

  /// `{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: What is th, folder_id: null, flomo_object_id: null, type: 2, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 2, wqbWrongQuestionContent: What is the past tense form of the irregular verb "go"?\n\n, wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: The past tense of "go" is "went". Example: He went to the store yesterday.\n\nThis card helps learners memorize and practice the past tense forms of common irregular verbs in English.\n\n, wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}`
  String get anki_card_prompt {
    return Intl.message(
      '{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: What is th, folder_id: null, flomo_object_id: null, type: 2, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 0, wqbKnowledgeContent: , wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 2, wqbWrongQuestionContent: What is the past tense form of the irregular verb "go"?\n\n, wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: The past tense of "go" is "went". Example: He went to the store yesterday.\n\nThis card helps learners memorize and practice the past tense forms of common irregular verbs in English.\n\n, wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}',
      name: 'anki_card_prompt',
      desc: '',
      args: [],
    );
  }

  /// `{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: Solving Quadratic Equations, folder_id: null, flomo_object_id: null, type: 0, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 2, wqbKnowledgeContent: Solving Quadratic Equations, wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 2, wqbWrongQuestionContent: Solve the equation \(2x^2 - 4x - 6 = 0\).\n\n\(x = 1\) or \(x = -3\)\n, wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: \(x = 3\) or \(x = -1\).\n, wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}`
  String get wrong_question_book_prompt {
    return Intl.message(
      '{createdAt: null, updatedAt: null, _id: null, indexSearchingStart: -1, state: 0, indexSearchingEnd: -1, background_url: null, title: Solving Quadratic Equations, folder_id: null, flomo_object_id: null, type: 0, masterScore: 2.0, update_time: null, causeAnalysis: [{code: confused, weight: 0}, {code: examination, weight: 0}, {code: wrong_thinking, weight: 0}, {code: arithmetic_error, weight: 0}, {code: carelessness, weight: 0}], wqbTypeKnowledgePoint: 2, wqbKnowledgeContent: Solving Quadratic Equations, wqbKnowledgeRichContentUrl: , wqbKnowledgeRecordUrls: [], wqbKnowledgeSmallUrls: [], wqbKnowledgeBigUrls: [], wqbKnowledgeOriginUrls: [], wqbTypeWrongQuestion: 2, wqbWrongQuestionContent: Solve the equation \\(2x^2 - 4x - 6 = 0\\).\n\n\\(x = 1\\) or \\(x = -3\\)\n, wqbWrongQuestionRichContentUrl: , wqbWrongQuestionRecordUrls: [], wqbWrongQuestionSmallUrls: [], wqbWrongQuestionBigUrls: [], wqbWrongQuestionOriginUrls: [], wqbTypeAnswer: 2, wqbAnswerRecordUrls: [], wqbAnswerSmallUrls: [], wqbAnswerBigUrls: [], wqbAnswerOriginUrls: [], wqbAnswerContent: \\(x = 3\\) or \\(x = -1\\).\n, wqbAnswerRichContentUrl: , content: , device_id: null, tagNames: [], tagIds: null, isFinished: false, color: 4294936576, order_index: null, status: null, priorityStatus: 3, uid: null}',
      name: 'wrong_question_book_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Close Multiple Selection`
  String get close_multi {
    return Intl.message(
      'Close Multiple Selection',
      name: 'close_multi',
      desc: '',
      args: [],
    );
  }

  /// `export`
  String get export {
    return Intl.message(
      'export',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Not Completed`
  String get not_completed {
    return Intl.message(
      'Not Completed',
      name: 'not_completed',
      desc: '',
      args: [],
    );
  }

  /// `Multi select`
  String get multi_select {
    return Intl.message(
      'Multi select',
      name: 'multi_select',
      desc: '',
      args: [],
    );
  }

  /// `The subtask {submission} under the mission {mission} has started, please be prepared`
  String mission_submission_started(Object submission, Object mission) {
    return Intl.message(
      'The subtask $submission under the mission $mission has started, please be prepared',
      name: 'mission_submission_started',
      desc: '',
      args: [submission, mission],
    );
  }

  /// `Background Setting`
  String get background_setting {
    return Intl.message(
      'Background Setting',
      name: 'background_setting',
      desc: '',
      args: [],
    );
  }

  /// `Subtask - Add&update By Clicking Enter`
  String get sub_task_add_newline {
    return Intl.message(
      'Subtask - Add&update By Clicking Enter',
      name: 'sub_task_add_newline',
      desc: '',
      args: [],
    );
  }

  /// `Loop Setting`
  String get loop_setting {
    return Intl.message(
      'Loop Setting',
      name: 'loop_setting',
      desc: '',
      args: [],
    );
  }

  /// `Automatically start resting after focus is completed`
  String get focus_completed_auto_start_rest {
    return Intl.message(
      'Automatically start resting after focus is completed',
      name: 'focus_completed_auto_start_rest',
      desc: '',
      args: [],
    );
  }

  /// `Automatically start playing after rest is completed`
  String get rest_completed_auto_start_play {
    return Intl.message(
      'Automatically start playing after rest is completed',
      name: 'rest_completed_auto_start_play',
      desc: '',
      args: [],
    );
  }

  /// `Turn off loop`
  String get auto_next_off {
    return Intl.message(
      'Turn off loop',
      name: 'auto_next_off',
      desc: '',
      args: [],
    );
  }

  /// `Turn on loop`
  String get auto_next_on {
    return Intl.message(
      'Turn on loop',
      name: 'auto_next_on',
      desc: '',
      args: [],
    );
  }

  /// `Desktop Widget{note}`
  String desktop_widget_with_note_n(Object note) {
    return Intl.message(
      'Desktop Widget$note',
      name: 'desktop_widget_with_note_n',
      desc: '',
      args: [note],
    );
  }

  /// `Set to desktop widget`
  String get set_to_desktop_widget {
    return Intl.message(
      'Set to desktop widget',
      name: 'set_to_desktop_widget',
      desc: '',
      args: [],
    );
  }

  /// `Note `
  String get note_n {
    return Intl.message(
      'Note ',
      name: 'note_n',
      desc: '',
      args: [],
    );
  }

  /// `Note 7`
  String get note_7 {
    return Intl.message(
      'Note 7',
      name: 'note_7',
      desc: '',
      args: [],
    );
  }

  /// `Note 6`
  String get note_6 {
    return Intl.message(
      'Note 6',
      name: 'note_6',
      desc: '',
      args: [],
    );
  }

  /// `Note 5`
  String get note_5 {
    return Intl.message(
      'Note 5',
      name: 'note_5',
      desc: '',
      args: [],
    );
  }

  /// `Note 4`
  String get note_4 {
    return Intl.message(
      'Note 4',
      name: 'note_4',
      desc: '',
      args: [],
    );
  }

  /// `Note 3`
  String get note_3 {
    return Intl.message(
      'Note 3',
      name: 'note_3',
      desc: '',
      args: [],
    );
  }

  /// `Note 2`
  String get note_2 {
    return Intl.message(
      'Note 2',
      name: 'note_2',
      desc: '',
      args: [],
    );
  }

  /// `Note 1`
  String get note_1 {
    return Intl.message(
      'Note 1',
      name: 'note_1',
      desc: '',
      args: [],
    );
  }

  /// `S-Note`
  String get super_notebook {
    return Intl.message(
      'S-Note',
      name: 'super_notebook',
      desc: '',
      args: [],
    );
  }

  /// `Saving`
  String get saving {
    return Intl.message(
      'Saving',
      name: 'saving',
      desc: '',
      args: [],
    );
  }

  /// `Save Failed`
  String get save_failure {
    return Intl.message(
      'Save Failed',
      name: 'save_failure',
      desc: '',
      args: [],
    );
  }

  /// `Editing`
  String get editing {
    return Intl.message(
      'Editing',
      name: 'editing',
      desc: '',
      args: [],
    );
  }

  /// `Front Card`
  String get front_card {
    return Intl.message(
      'Front Card',
      name: 'front_card',
      desc: '',
      args: [],
    );
  }

  /// `Back Card`
  String get back_card {
    return Intl.message(
      'Back Card',
      name: 'back_card',
      desc: '',
      args: [],
    );
  }

  /// `Not started`
  String get not_started {
    return Intl.message(
      'Not started',
      name: 'not_started',
      desc: '',
      args: [],
    );
  }

  /// `Memorizing`
  String get memorizing {
    return Intl.message(
      'Memorizing',
      name: 'memorizing',
      desc: '',
      args: [],
    );
  }

  /// `Memorized`
  String get memorized {
    return Intl.message(
      'Memorized',
      name: 'memorized',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note2 {
    return Intl.message(
      'Note',
      name: 'note2',
      desc: '',
      args: [],
    );
  }

  /// `memorandum`
  String get memorandum {
    return Intl.message(
      'memorandum',
      name: 'memorandum',
      desc: '',
      args: [],
    );
  }

  /// `wrong question book`
  String get wrong_question_book {
    return Intl.message(
      'wrong question book',
      name: 'wrong_question_book',
      desc: '',
      args: [],
    );
  }

  /// `card`
  String get card {
    return Intl.message(
      'card',
      name: 'card',
      desc: '',
      args: [],
    );
  }

  /// `create date`
  String get creating_date {
    return Intl.message(
      'create date',
      name: 'creating_date',
      desc: '',
      args: [],
    );
  }

  /// `Wrong question knowledge points`
  String get wrong_question_knowledge_points {
    return Intl.message(
      'Wrong question knowledge points',
      name: 'wrong_question_knowledge_points',
      desc: '',
      args: [],
    );
  }

  /// `normal solution`
  String get normal_solution {
    return Intl.message(
      'normal solution',
      name: 'normal_solution',
      desc: '',
      args: [],
    );
  }

  /// `Question/Mistake`
  String get question_mistake {
    return Intl.message(
      'Question/Mistake',
      name: 'question_mistake',
      desc: '',
      args: [],
    );
  }

  /// `Target Duration Period`
  String get target_duration_period {
    return Intl.message(
      'Target Duration Period',
      name: 'target_duration_period',
      desc: '',
      args: [],
    );
  }

  /// `Mastering the situation`
  String get mastering_the_situation {
    return Intl.message(
      'Mastering the situation',
      name: 'mastering_the_situation',
      desc: '',
      args: [],
    );
  }

  /// `skilled`
  String get skilled {
    return Intl.message(
      'skilled',
      name: 'skilled',
      desc: '',
      args: [],
    );
  }

  /// `rusty`
  String get rusty {
    return Intl.message(
      'rusty',
      name: 'rusty',
      desc: '',
      args: [],
    );
  }

  /// `heavy`
  String get heavy {
    return Intl.message(
      'heavy',
      name: 'heavy',
      desc: '',
      args: [],
    );
  }

  /// `light`
  String get light {
    return Intl.message(
      'light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `some confused ideas`
  String get confused {
    return Intl.message(
      'some confused ideas',
      name: 'confused',
      desc: '',
      args: [],
    );
  }

  /// `Examination error`
  String get examination {
    return Intl.message(
      'Examination error',
      name: 'examination',
      desc: '',
      args: [],
    );
  }

  /// `Wrong thinking`
  String get wrong_thinking {
    return Intl.message(
      'Wrong thinking',
      name: 'wrong_thinking',
      desc: '',
      args: [],
    );
  }

  /// `Arithmetic error`
  String get arithmetic_error {
    return Intl.message(
      'Arithmetic error',
      name: 'arithmetic_error',
      desc: '',
      args: [],
    );
  }

  /// `Carelessness`
  String get carelessness {
    return Intl.message(
      'Carelessness',
      name: 'carelessness',
      desc: '',
      args: [],
    );
  }

  /// `Knowledge Point of Wrong Question`
  String get wrong_question_knowledge_point {
    return Intl.message(
      'Knowledge Point of Wrong Question',
      name: 'wrong_question_knowledge_point',
      desc: '',
      args: [],
    );
  }

  /// `Question/Wrong Question`
  String get question_wrong_question {
    return Intl.message(
      'Question/Wrong Question',
      name: 'question_wrong_question',
      desc: '',
      args: [],
    );
  }

  /// `Correct Answer`
  String get correct_answer {
    return Intl.message(
      'Correct Answer',
      name: 'correct_answer',
      desc: '',
      args: [],
    );
  }

  /// `please input content`
  String get please_input_content {
    return Intl.message(
      'please input content',
      name: 'please_input_content',
      desc: '',
      args: [],
    );
  }

  /// `record`
  String get record {
    return Intl.message(
      'record',
      name: 'record',
      desc: '',
      args: [],
    );
  }

  /// `rich text`
  String get rich_text {
    return Intl.message(
      'rich text',
      name: 'rich_text',
      desc: '',
      args: [],
    );
  }

  /// `plain text`
  String get plain_text {
    return Intl.message(
      'plain text',
      name: 'plain_text',
      desc: '',
      args: [],
    );
  }

  /// `cause analysis`
  String get cause_analysis {
    return Intl.message(
      'cause analysis',
      name: 'cause_analysis',
      desc: '',
      args: [],
    );
  }

  /// `New Card`
  String get new_card {
    return Intl.message(
      'New Card',
      name: 'new_card',
      desc: '',
      args: [],
    );
  }

  /// `Locking apps can help you focus better by not being disturbed by unnecessary applications.`
  String get lock_app_setting_description {
    return Intl.message(
      'Locking apps can help you focus better by not being disturbed by unnecessary applications.',
      name: 'lock_app_setting_description',
      desc: '',
      args: [],
    );
  }

  /// `Lock Apps Setting`
  String get lock_app_setting {
    return Intl.message(
      'Lock Apps Setting',
      name: 'lock_app_setting',
      desc: '',
      args: [],
    );
  }

  /// `lock Apps`
  String get lock_app {
    return Intl.message(
      'lock Apps',
      name: 'lock_app',
      desc: '',
      args: [],
    );
  }

  /// `Recommended Target`
  String get recommended_Target {
    return Intl.message(
      'Recommended Target',
      name: 'recommended_Target',
      desc: '',
      args: [],
    );
  }

  /// `Continuing`
  String get continuously {
    return Intl.message(
      'Continuing',
      name: 'continuously',
      desc: '',
      args: [],
    );
  }

  /// `Archived`
  String get archived {
    return Intl.message(
      'Archived',
      name: 'archived',
      desc: '',
      args: [],
    );
  }

  /// `Continuous Clock-in`
  String get continously_clockin {
    return Intl.message(
      'Continuous Clock-in',
      name: 'continously_clockin',
      desc: '',
      args: [],
    );
  }

  /// `Finish clock-in mission '{title}'`
  String complete_flomo_mission(Object title) {
    return Intl.message(
      'Finish clock-in mission \'$title\'',
      name: 'complete_flomo_mission',
      desc: '',
      args: [title],
    );
  }

  /// `Delete clock-in mission '{title}'`
  String delete_flomo_mission(Object title) {
    return Intl.message(
      'Delete clock-in mission \'$title\'',
      name: 'delete_flomo_mission',
      desc: '',
      args: [title],
    );
  }

  /// `Clock-in for the {times}/{total} time for '{title}'`
  String create_name_flomo_mission(Object times, Object total, Object title) {
    return Intl.message(
      'Clock-in for the $times/$total time for \'$title\'',
      name: 'create_name_flomo_mission',
      desc: '',
      args: [times, total, title],
    );
  }

  /// `Don't remind again`
  String get dont_remind_again {
    return Intl.message(
      'Don\'t remind again',
      name: 'dont_remind_again',
      desc: '',
      args: [],
    );
  }

  /// `Write down your thoughts`
  String get write_your_clockin_feedback {
    return Intl.message(
      'Write down your thoughts',
      name: 'write_your_clockin_feedback',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get no_data {
    return Intl.message(
      'No data',
      name: 'no_data',
      desc: '',
      args: [],
    );
  }

  /// `Clock In`
  String get clock_in {
    return Intl.message(
      'Clock In',
      name: 'clock_in',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one option in the repeat cycle`
  String get please_select_at_least_one_option_in_repeat_cycle {
    return Intl.message(
      'Please select at least one option in the repeat cycle',
      name: 'please_select_at_least_one_option_in_repeat_cycle',
      desc: '',
      args: [],
    );
  }

  /// `already exists at this time`
  String get already_exists_at_this_time {
    return Intl.message(
      'already exists at this time',
      name: 'already_exists_at_this_time',
      desc: '',
      args: [],
    );
  }

  /// `Add Reminder`
  String get add_reminder {
    return Intl.message(
      'Add Reminder',
      name: 'add_reminder',
      desc: '',
      args: [],
    );
  }

  /// `Continuous Clock-in`
  String get continuous_clock_in {
    return Intl.message(
      'Continuous Clock-in',
      name: 'continuous_clock_in',
      desc: '',
      args: [],
    );
  }

  /// `Completion Degree`
  String get completion_degree {
    return Intl.message(
      'Completion Degree',
      name: 'completion_degree',
      desc: '',
      args: [],
    );
  }

  /// `This Month's Plan`
  String get this_month_plan {
    return Intl.message(
      'This Month\'s Plan',
      name: 'this_month_plan',
      desc: '',
      args: [],
    );
  }

  /// `Already Persisted`
  String get already_persisted {
    return Intl.message(
      'Already Persisted',
      name: 'already_persisted',
      desc: '',
      args: [],
    );
  }

  /// `Same Treatment`
  String get same_treatment {
    return Intl.message(
      'Same Treatment',
      name: 'same_treatment',
      desc: '',
      args: [],
    );
  }

  /// `Target Details`
  String get target_details {
    return Intl.message(
      'Target Details',
      name: 'target_details',
      desc: '',
      args: [],
    );
  }

  /// `Clock-in Calendar`
  String get clock_in_calendar {
    return Intl.message(
      'Clock-in Calendar',
      name: 'clock_in_calendar',
      desc: '',
      args: [],
    );
  }

  /// `Daily Completion Times`
  String get daily_completion_times {
    return Intl.message(
      'Daily Completion Times',
      name: 'daily_completion_times',
      desc: '',
      args: [],
    );
  }

  /// `Write a sentence to encourage yourself~`
  String get encourage_yourself {
    return Intl.message(
      'Write a sentence to encourage yourself~',
      name: 'encourage_yourself',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one option in the repeat cycle`
  String get select_repeat_option {
    return Intl.message(
      'Please select at least one option in the repeat cycle',
      name: 'select_repeat_option',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your desired end time`
  String get input_end_time {
    return Intl.message(
      'Please enter your desired end time',
      name: 'input_end_time',
      desc: '',
      args: [],
    );
  }

  /// `Icon`
  String get icon {
    return Intl.message(
      'Icon',
      name: 'icon',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Period`
  String get repeat_period {
    return Intl.message(
      'Repeat Period',
      name: 'repeat_period',
      desc: '',
      args: [],
    );
  }

  /// `Target Time`
  String get target_time {
    return Intl.message(
      'Target Time',
      name: 'target_time',
      desc: '',
      args: [],
    );
  }

  /// `Please select {content}`
  String please_select_content(Object content) {
    return Intl.message(
      'Please select $content',
      name: 'please_select_content',
      desc: '',
      args: [content],
    );
  }

  /// `Enter the goal you want to stick to~`
  String get input_your_goal {
    return Intl.message(
      'Enter the goal you want to stick to~',
      name: 'input_your_goal',
      desc: '',
      args: [],
    );
  }

  /// `Publish`
  String get publish {
    return Intl.message(
      'Publish',
      name: 'publish',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a title`
  String get pleaseInputTitle {
    return Intl.message(
      'Please enter a title',
      name: 'pleaseInputTitle',
      desc: '',
      args: [],
    );
  }

  /// `Target Reward`
  String get target_reward {
    return Intl.message(
      'Target Reward',
      name: 'target_reward',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue2 {
    return Intl.message(
      'Continue',
      name: 'continue2',
      desc: '',
      args: [],
    );
  }

  /// `Start Date`
  String get start_date {
    return Intl.message(
      'Start Date',
      name: 'start_date',
      desc: '',
      args: [],
    );
  }

  /// `Finished Time`
  String get end_time {
    return Intl.message(
      'Finished Time',
      name: 'end_time',
      desc: '',
      args: [],
    );
  }

  /// `Alert Time`
  String get alert_time {
    return Intl.message(
      'Alert Time',
      name: 'alert_time',
      desc: '',
      args: [],
    );
  }

  /// `Frequency`
  String get frequency {
    return Intl.message(
      'Frequency',
      name: 'frequency',
      desc: '',
      args: [],
    );
  }

  /// `Join Days`
  String get join_days {
    return Intl.message(
      'Join Days',
      name: 'join_days',
      desc: '',
      args: [],
    );
  }

  /// `Completed Days`
  String get completed_days {
    return Intl.message(
      'Completed Days',
      name: 'completed_days',
      desc: '',
      args: [],
    );
  }

  /// `Continuous Days`
  String get continuous_days {
    return Intl.message(
      'Continuous Days',
      name: 'continuous_days',
      desc: '',
      args: [],
    );
  }

  /// `{month} month clock-in rate`
  String month_clockin_rate(Object month) {
    return Intl.message(
      '$month month clock-in rate',
      name: 'month_clockin_rate',
      desc: '',
      args: [month],
    );
  }

  /// `{month} month clock-in record`
  String month_clockin_record(Object month) {
    return Intl.message(
      '$month month clock-in record',
      name: 'month_clockin_record',
      desc: '',
      args: [month],
    );
  }

  /// `miss`
  String get miss_clockin {
    return Intl.message(
      'miss',
      name: 'miss_clockin',
      desc: '',
      args: [],
    );
  }

  /// `The time has not arrived, you cannot clock in`
  String get time_not_arrive_cannot_clcokin {
    return Intl.message(
      'The time has not arrived, you cannot clock in',
      name: 'time_not_arrive_cannot_clcokin',
      desc: '',
      args: [],
    );
  }

  /// `Clock in continuously for {times} days`
  String clockin_n_days_continuously(Object times) {
    return Intl.message(
      'Clock in continuously for $times days',
      name: 'clockin_n_days_continuously',
      desc: '',
      args: [times],
    );
  }

  /// `Total clock in for {n} days`
  String clockin_n_days_totally(Object n) {
    return Intl.message(
      'Total clock in for $n days',
      name: 'clockin_n_days_totally',
      desc: '',
      args: [n],
    );
  }

  // skipped getter for the '8_hour_after' key

  // skipped getter for the '1_hour_after' key

  // skipped getter for the '20_mins_after' key

  /// `I want you to act as an intelligent input method, returning an array of phrases List<String> that the user might input based on the prompt. The array should contain no more than 20 items and must cover the words input by the user (Note: We are not discussing the entire history).`
  String get role_prompts_chatgpt_msg {
    return Intl.message(
      'I want you to act as an intelligent input method, returning an array of phrases List<String> that the user might input based on the prompt. The array should contain no more than 20 items and must cover the words input by the user (Note: We are not discussing the entire history).',
      name: 'role_prompts_chatgpt_msg',
      desc: '',
      args: [],
    );
  }

  /// `'{name}' clock-in task reminder`
  String mission_clocks_in_with_name(Object name) {
    return Intl.message(
      '\'$name\' clock-in task reminder',
      name: 'mission_clocks_in_with_name',
      desc: '',
      args: [name],
    );
  }

  /// `Your clock-in task '{name}' has started. Please come and clock in.`
  String your_clockin_mission_with_name_has_begun(Object name) {
    return Intl.message(
      'Your clock-in task \'$name\' has started. Please come and clock in.',
      name: 'your_clockin_mission_with_name_has_begun',
      desc: '',
      args: [name],
    );
  }

  /// `{num}/{total}`
  String num_of_total(Object num, Object total) {
    return Intl.message(
      '$num/$total',
      name: 'num_of_total',
      desc: '',
      args: [num, total],
    );
  }

  /// `{n} times every day`
  String everyDayOnce(Object n) {
    return Intl.message(
      '$n times every day',
      name: 'everyDayOnce',
      desc: '',
      args: [n],
    );
  }

  /// `times`
  String get times {
    return Intl.message(
      'times',
      name: 'times',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get repeative1 {
    return Intl.message(
      'Daily',
      name: 'repeative1',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get repeative2 {
    return Intl.message(
      'Weekly',
      name: 'repeative2',
      desc: '',
      args: [],
    );
  }

  /// `Ebbinghaus`
  String get repeative3 {
    return Intl.message(
      'Ebbinghaus',
      name: 'repeative3',
      desc: '',
      args: [],
    );
  }

  /// `AI Helper`
  String get ai_helper {
    return Intl.message(
      'AI Helper',
      name: 'ai_helper',
      desc: '',
      args: [],
    );
  }

  /// `Do you confirm the need for cloud synchronization (Note: It is only necessary to use this when you have logged in two accounts on one phone, and you need to synchronize the data from the previous phone number to the current one)?`
  String get confirmToSyncCloudData {
    return Intl.message(
      'Do you confirm the need for cloud synchronization (Note: It is only necessary to use this when you have logged in two accounts on one phone, and you need to synchronize the data from the previous phone number to the current one)?',
      name: 'confirmToSyncCloudData',
      desc: '',
      args: [],
    );
  }

  /// `visible`
  String get visible {
    return Intl.message(
      'visible',
      name: 'visible',
      desc: '',
      args: [],
    );
  }

  /// `hidden`
  String get hidden {
    return Intl.message(
      'hidden',
      name: 'hidden',
      desc: '',
      args: [],
    );
  }

  /// `Please note, act according to your actual situation. If you are not satisfied with {trainee}'s response, you can communicate with {trainee} to give more detailed commands to help you plan your time.`
  String trainee_advice_notice(Object trainee) {
    return Intl.message(
      'Please note, act according to your actual situation. If you are not satisfied with $trainee\'s response, you can communicate with $trainee to give more detailed commands to help you plan your time.',
      name: 'trainee_advice_notice',
      desc: '',
      args: [trainee],
    );
  }

  /// `I know`
  String get i_know {
    return Intl.message(
      'I know',
      name: 'i_know',
      desc: '',
      args: [],
    );
  }

  /// `{trainee}'s advice`
  String trainee_give_your_advice(Object trainee) {
    return Intl.message(
      '$trainee\'s advice',
      name: 'trainee_give_your_advice',
      desc: '',
      args: [trainee],
    );
  }

  /// `Content`
  String get content {
    return Intl.message(
      'Content',
      name: 'content',
      desc: '',
      args: [],
    );
  }

  /// `Manual Create`
  String get manual_create {
    return Intl.message(
      'Manual Create',
      name: 'manual_create',
      desc: '',
      args: [],
    );
  }

  /// `AI Create`
  String get ai_create {
    return Intl.message(
      'AI Create',
      name: 'ai_create',
      desc: '',
      args: [],
    );
  }

  /// `Time Manager`
  String get role_time_manager {
    return Intl.message(
      'Time Manager',
      name: 'role_time_manager',
      desc: '',
      args: [],
    );
  }

  /// `please enter your questing`
  String get please_enter_your_question {
    return Intl.message(
      'please enter your questing',
      name: 'please_enter_your_question',
      desc: '',
      args: [],
    );
  }

  /// `Please input the work plan (please describe the approximate time, work content, etc.)`
  String get role_message_placehodler {
    return Intl.message(
      'Please input the work plan (please describe the approximate time, work content, etc.)',
      name: 'role_message_placehodler',
      desc: '',
      args: [],
    );
  }

  /// `I want you to play a {role}, you need to plan the following content, the time is {time}, {content}, and return an array of JSON objects. The key values and explanations of each field in the JSON are as follows: \nString? title = ''; //Title is required \nint? total_tomatoes; //Directly calculate the result, the number of completed tomatoes (daily_end_time - daily_start_time)/tomato_duration \nint? tomato_duration = 1500000;  //Directly calculate the result, the value is always 25 * 60 * 1000 milliseconds, representing a tomato focus of 25 minutes \nString? end_time; //Directly calculate the result, the end time in {timestampFormat1} format is required \nint? priorityStatus; //3 No priority  2 Low priority 1 Medium priority 0 High priority is required \nString? daily_start_time; //Directly calculate the result, the task start time in {timestampFormat2} format \nString? daily_end_time; //Directly calculate the result, the task end time in {timestampFormat3} format \nString? message; //Task reminder \nNote: Cannot be null, the value in key:value directly gives the result, the daily_start_time and daily_end_time of each task cannot overlap \nThe title needs to be clearly described, no other explanation is needed, each task must be at least 5 minutes apart \nOnly return a JSON string with an array as the root, such as [object, object,]`
  String role_chatgpt_msg(
      Object role,
      Object time,
      Object content,
      Object timestampFormat1,
      Object timestampFormat2,
      Object timestampFormat3) {
    return Intl.message(
      'I want you to play a $role, you need to plan the following content, the time is $time, $content, and return an array of JSON objects. The key values and explanations of each field in the JSON are as follows: \nString? title = \'\'; //Title is required \nint? total_tomatoes; //Directly calculate the result, the number of completed tomatoes (daily_end_time - daily_start_time)/tomato_duration \nint? tomato_duration = 1500000;  //Directly calculate the result, the value is always 25 * 60 * 1000 milliseconds, representing a tomato focus of 25 minutes \nString? end_time; //Directly calculate the result, the end time in $timestampFormat1 format is required \nint? priorityStatus; //3 No priority  2 Low priority 1 Medium priority 0 High priority is required \nString? daily_start_time; //Directly calculate the result, the task start time in $timestampFormat2 format \nString? daily_end_time; //Directly calculate the result, the task end time in $timestampFormat3 format \nString? message; //Task reminder \nNote: Cannot be null, the value in key:value directly gives the result, the daily_start_time and daily_end_time of each task cannot overlap \nThe title needs to be clearly described, no other explanation is needed, each task must be at least 5 minutes apart \nOnly return a JSON string with an array as the root, such as [object, object,]',
      name: 'role_chatgpt_msg',
      desc: '',
      args: [
        role,
        time,
        content,
        timestampFormat1,
        timestampFormat2,
        timestampFormat3
      ],
    );
  }

  /// `request error, please try again`
  String get request_error_try_again {
    return Intl.message(
      'request error, please try again',
      name: 'request_error_try_again',
      desc: '',
      args: [],
    );
  }

  /// `add listing`
  String get add_listing {
    return Intl.message(
      'add listing',
      name: 'add_listing',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Wechat share`
  String get wechat_share {
    return Intl.message(
      'Wechat share',
      name: 'wechat_share',
      desc: '',
      args: [],
    );
  }

  /// `QQ share`
  String get qq_share {
    return Intl.message(
      'QQ share',
      name: 'qq_share',
      desc: '',
      args: [],
    );
  }

  /// `Don't remind`
  String get not_remind_again {
    return Intl.message(
      'Don\'t remind',
      name: 'not_remind_again',
      desc: '',
      args: [],
    );
  }

  /// `Used for cross terminal data synchronization`
  String get cloud_sync_content {
    return Intl.message(
      'Used for cross terminal data synchronization',
      name: 'cloud_sync_content',
      desc: '',
      args: [],
    );
  }

  /// `cloud sync`
  String get cloud_sync {
    return Intl.message(
      'cloud sync',
      name: 'cloud_sync',
      desc: '',
      args: [],
    );
  }

  /// `This is a class you created yourself`
  String get your_created_class {
    return Intl.message(
      'This is a class you created yourself',
      name: 'your_created_class',
      desc: '',
      args: [],
    );
  }

  /// `Course Introduction`
  String get course_introduction {
    return Intl.message(
      'Course Introduction',
      name: 'course_introduction',
      desc: '',
      args: [],
    );
  }

  /// `Author presentation content`
  String get author_presentation_content {
    return Intl.message(
      'Author presentation content',
      name: 'author_presentation_content',
      desc: '',
      args: [],
    );
  }

  /// `Other login model`
  String get other_login_mode {
    return Intl.message(
      'Other login model',
      name: 'other_login_mode',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get one_key_login {
    return Intl.message(
      'Login',
      name: 'one_key_login',
      desc: '',
      args: [],
    );
  }

  /// `老师`
  String get chatgpt_ai_username_huawei {
    return Intl.message(
      '老师',
      name: 'chatgpt_ai_username_huawei',
      desc: '',
      args: [],
    );
  }

  /// `send again`
  String get send_again {
    return Intl.message(
      'send again',
      name: 'send_again',
      desc: '',
      args: [],
    );
  }

  /// `order by mission tag`
  String get order_by_mission_tag {
    return Intl.message(
      'order by mission tag',
      name: 'order_by_mission_tag',
      desc: '',
      args: [],
    );
  }

  /// `requesting, please wait`
  String get requesting_please_wait {
    return Intl.message(
      'requesting, please wait',
      name: 'requesting_please_wait',
      desc: '',
      args: [],
    );
  }

  /// `request fail`
  String get request_fail {
    return Intl.message(
      'request fail',
      name: 'request_fail',
      desc: '',
      args: [],
    );
  }

  /// `My {course}`
  String my(Object course) {
    return Intl.message(
      'My $course',
      name: 'my',
      desc: '',
      args: [course],
    );
  }

  /// `Participated in the course`
  String get already_in_course {
    return Intl.message(
      'Participated in the course',
      name: 'already_in_course',
      desc: '',
      args: [],
    );
  }

  /// `Google Login`
  String get google_login {
    return Intl.message(
      'Google Login',
      name: 'google_login',
      desc: '',
      args: [],
    );
  }

  /// `Good score, loss weight`
  String get course_desc {
    return Intl.message(
      'Good score, loss weight',
      name: 'course_desc',
      desc: '',
      args: [],
    );
  }

  /// `Any question you have will find an answer`
  String get chatgpt_desc {
    return Intl.message(
      'Any question you have will find an answer',
      name: 'chatgpt_desc',
      desc: '',
      args: [],
    );
  }

  /// `Any question you have will be answered here`
  String get chatgpt_desc_huawei {
    return Intl.message(
      'Any question you have will be answered here',
      name: 'chatgpt_desc_huawei',
      desc: '',
      args: [],
    );
  }

  /// `Your token has expired, please add WeChat ID cannywill to apply for GPT access permission.`
  String get gpt_token_expired {
    return Intl.message(
      'Your token has expired, please add WeChat ID cannywill to apply for GPT access permission.',
      name: 'gpt_token_expired',
      desc: '',
      args: [],
    );
  }

  /// `Cannot exceed {max} characters`
  String max_words(Object max) {
    return Intl.message(
      'Cannot exceed $max characters',
      name: 'max_words',
      desc: '',
      args: [max],
    );
  }

  /// `Do not discuss any pornographic or politically sensitive topics`
  String get gpt_system_msg_forbidden {
    return Intl.message(
      'Do not discuss any pornographic or politically sensitive topics',
      name: 'gpt_system_msg_forbidden',
      desc: '',
      args: [],
    );
  }

  /// `Please input using the built-in voice input method of your phone`
  String get voice_guide {
    return Intl.message(
      'Please input using the built-in voice input method of your phone',
      name: 'voice_guide',
      desc: '',
      args: [],
    );
  }

  /// `Request error, please try again`
  String get try_again {
    return Intl.message(
      'Request error, please try again',
      name: 'try_again',
      desc: '',
      args: [],
    );
  }

  /// `Newline:{newline}`
  String newline(Object newline) {
    return Intl.message(
      'Newline:$newline',
      name: 'newline',
      desc: '',
      args: [newline],
    );
  }

  /// `GPT`
  String get chatgpt {
    return Intl.message(
      'GPT',
      name: 'chatgpt',
      desc: '',
      args: [],
    );
  }

  /// `AI Helper`
  String get chatgpt_huawei {
    return Intl.message(
      'AI Helper',
      name: 'chatgpt_huawei',
      desc: '',
      args: [],
    );
  }

  /// `no auth`
  String get no_auth {
    return Intl.message(
      'no auth',
      name: 'no_auth',
      desc: '',
      args: [],
    );
  }

  /// `please input correct password`
  String get please_input_correct_password {
    return Intl.message(
      'please input correct password',
      name: 'please_input_correct_password',
      desc: '',
      args: [],
    );
  }

  /// `edit sharing`
  String get edit_sharing {
    return Intl.message(
      'edit sharing',
      name: 'edit_sharing',
      desc: '',
      args: [],
    );
  }

  /// `sharing course`
  String get sharing_course {
    return Intl.message(
      'sharing course',
      name: 'sharing_course',
      desc: '',
      args: [],
    );
  }

  /// `Training Program`
  String get public_course {
    return Intl.message(
      'Training Program',
      name: 'public_course',
      desc: '',
      args: [],
    );
  }

  /// `training plan already exist`
  String get already_exist {
    return Intl.message(
      'training plan already exist',
      name: 'already_exist',
      desc: '',
      args: [],
    );
  }

  /// `Successfully obtained {name} locally, you can start your training.`
  String get_train_plan_successful(Object name) {
    return Intl.message(
      'Successfully obtained $name locally, you can start your training.',
      name: 'get_train_plan_successful',
      desc: '',
      args: [name],
    );
  }

  /// `get training plan`
  String get get_training_plan {
    return Intl.message(
      'get training plan',
      name: 'get_training_plan',
      desc: '',
      args: [],
    );
  }

  /// `buy training plan`
  String get buy_training_plan {
    return Intl.message(
      'buy training plan',
      name: 'buy_training_plan',
      desc: '',
      args: [],
    );
  }

  /// `Browse`
  String get browse {
    return Intl.message(
      'Browse',
      name: 'browse',
      desc: '',
      args: [],
    );
  }

  /// `course`
  String get course {
    return Intl.message(
      'course',
      name: 'course',
      desc: '',
      args: [],
    );
  }

  /// `Training Plan Edit`
  String get training_plan_edit {
    return Intl.message(
      'Training Plan Edit',
      name: 'training_plan_edit',
      desc: '',
      args: [],
    );
  }

  /// `Provide your sharers with a more detailed training plan to help them improve themselves in more detail`
  String get detailed_training_plan_desc {
    return Intl.message(
      'Provide your sharers with a more detailed training plan to help them improve themselves in more detail',
      name: 'detailed_training_plan_desc',
      desc: '',
      args: [],
    );
  }

  /// `Click to view the detailed training plan for the course`
  String get detailed_training_plan_desc_2 {
    return Intl.message(
      'Click to view the detailed training plan for the course',
      name: 'detailed_training_plan_desc_2',
      desc: '',
      args: [],
    );
  }

  /// `Detailed Training Plan（Optional）`
  String get detailed_training_plan_optional {
    return Intl.message(
      'Detailed Training Plan（Optional）',
      name: 'detailed_training_plan_optional',
      desc: '',
      args: [],
    );
  }

  /// `Detailed Training Plan`
  String get detailed_training_plan {
    return Intl.message(
      'Detailed Training Plan',
      name: 'detailed_training_plan',
      desc: '',
      args: [],
    );
  }

  /// `All user share editing status`
  String get isEditable {
    return Intl.message(
      'All user share editing status',
      name: 'isEditable',
      desc: '',
      args: [],
    );
  }

  /// `course intro`
  String get course_intro {
    return Intl.message(
      'course intro',
      name: 'course_intro',
      desc: '',
      args: [],
    );
  }

  /// `Author introduction`
  String get author_intro {
    return Intl.message(
      'Author introduction',
      name: 'author_intro',
      desc: '',
      args: [],
    );
  }

  /// `{text} cannot be empty`
  String xxx_cannot_be_empty(Object text) {
    return Intl.message(
      '$text cannot be empty',
      name: 'xxx_cannot_be_empty',
      desc: '',
      args: [text],
    );
  }

  /// `Please set the username first`
  String get please_input_your_username {
    return Intl.message(
      'Please set the username first',
      name: 'please_input_your_username',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a 4-digit digital password`
  String get four_pws {
    return Intl.message(
      'Please enter a 4-digit digital password',
      name: 'four_pws',
      desc: '',
      args: [],
    );
  }

  /// `sales amount`
  String get sales_amount {
    return Intl.message(
      'sales amount',
      name: 'sales_amount',
      desc: '',
      args: [],
    );
  }

  /// `free_open`
  String get free_open {
    return Intl.message(
      'free_open',
      name: 'free_open',
      desc: '',
      args: [],
    );
  }

  /// `private`
  String get private {
    return Intl.message(
      'private',
      name: 'private',
      desc: '',
      args: [],
    );
  }

  /// `sales`
  String get sales {
    return Intl.message(
      'sales',
      name: 'sales',
      desc: '',
      args: [],
    );
  }

  /// `examine time`
  String get guide_examine_time {
    return Intl.message(
      'examine time',
      name: 'guide_examine_time',
      desc: '',
      args: [],
    );
  }

  /// `Countdown`
  String get count_down_text {
    return Intl.message(
      'Countdown',
      name: 'count_down_text',
      desc: '',
      args: [],
    );
  }

  /// `counting`
  String get counting {
    return Intl.message(
      'counting',
      name: 'counting',
      desc: '',
      args: [],
    );
  }

  /// `Finished`
  String get finished {
    return Intl.message(
      'Finished',
      name: 'finished',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Deletion`
  String get confirm_deletion {
    return Intl.message(
      'Confirm Deletion',
      name: 'confirm_deletion',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Please input the mission title`
  String get please_input_mission_title {
    return Intl.message(
      'Please input the mission title',
      name: 'please_input_mission_title',
      desc: '',
      args: [],
    );
  }

  /// `Please input the mission title first`
  String get input_mission_title_first {
    return Intl.message(
      'Please input the mission title first',
      name: 'input_mission_title_first',
      desc: '',
      args: [],
    );
  }

  /// `Create success`
  String get create_success {
    return Intl.message(
      'Create success',
      name: 'create_success',
      desc: '',
      args: [],
    );
  }

  /// `Network error`
  String get network_error {
    return Intl.message(
      'Network error',
      name: 'network_error',
      desc: '',
      args: [],
    );
  }

  /// `update completed`
  String get update_success {
    return Intl.message(
      'update completed',
      name: 'update_success',
      desc: '',
      args: [],
    );
  }

  /// `Remarks (optional)`
  String get remarks_optional {
    return Intl.message(
      'Remarks (optional)',
      name: 'remarks_optional',
      desc: '',
      args: [],
    );
  }

  /// `time`
  String get time {
    return Intl.message(
      'time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Unit`
  String get unit {
    return Intl.message(
      'Unit',
      name: 'unit',
      desc: '',
      args: [],
    );
  }

  /// `Day, Hour, Minute, Second`
  String get day_hour_minute_second {
    return Intl.message(
      'Day, Hour, Minute, Second',
      name: 'day_hour_minute_second',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get reminder {
    return Intl.message(
      'Reminder',
      name: 'reminder',
      desc: '',
      args: [],
    );
  }

  /// `Whether to repeat or not`
  String get whether_to_repeat {
    return Intl.message(
      'Whether to repeat or not',
      name: 'whether_to_repeat',
      desc: '',
      args: [],
    );
  }

  /// `Change background`
  String get change_background {
    return Intl.message(
      'Change background',
      name: 'change_background',
      desc: '',
      args: [],
    );
  }

  /// `{day} days {hour}:{mins}:{secs}`
  String count_down(Object day, Object hour, Object mins, Object secs) {
    return Intl.message(
      '$day days $hour:$mins:$secs',
      name: 'count_down',
      desc: '',
      args: [day, hour, mins, secs],
    );
  }

  /// `{hour}:{mins}:{secs}`
  String count_down2(Object hour, Object mins, Object secs) {
    return Intl.message(
      '$hour:$mins:$secs',
      name: 'count_down2',
      desc: '',
      args: [hour, mins, secs],
    );
  }

  /// `{mins}:{secs}`
  String count_down3(Object mins, Object secs) {
    return Intl.message(
      '$mins:$secs',
      name: 'count_down3',
      desc: '',
      args: [mins, secs],
    );
  }

  /// `submit`
  String get submit {
    return Intl.message(
      'submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `If you think it's good, give us a 5-star review or suggestion 😄`
  String get rating_guide {
    return Intl.message(
      'If you think it\'s good, give us a 5-star review or suggestion 😄',
      name: 'rating_guide',
      desc: '',
      args: [],
    );
  }

  /// `reset password successfully`
  String get reset_pwd_successful {
    return Intl.message(
      'reset password successfully',
      name: 'reset_pwd_successful',
      desc: '',
      args: [],
    );
  }

  /// `reset password`
  String get reset_pwd {
    return Intl.message(
      'reset password',
      name: 'reset_pwd',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get copy_qq_success {
    return Intl.message(
      '',
      name: 'copy_qq_success',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get click_copy_qq {
    return Intl.message(
      '',
      name: 'click_copy_qq',
      desc: '',
      args: [],
    );
  }

  /// `Join facebook`
  String get copy_qq {
    return Intl.message(
      'Join facebook',
      name: 'copy_qq',
      desc: '',
      args: [],
    );
  }

  /// `Join our facebook and give us opinion^^`
  String get copy_sub_title {
    return Intl.message(
      'Join our facebook and give us opinion^^',
      name: 'copy_sub_title',
      desc: '',
      args: [],
    );
  }

  /// `background auto change off`
  String get background_change_auto_prompt_off {
    return Intl.message(
      'background auto change off',
      name: 'background_change_auto_prompt_off',
      desc: '',
      args: [],
    );
  }

  /// `background auto change on`
  String get background_change_auto_prompt_on {
    return Intl.message(
      'background auto change on',
      name: 'background_change_auto_prompt_on',
      desc: '',
      args: [],
    );
  }

  /// `bg auto`
  String get background_auto_mode {
    return Intl.message(
      'bg auto',
      name: 'background_auto_mode',
      desc: '',
      args: [],
    );
  }

  /// `Background`
  String get change_bg {
    return Intl.message(
      'Background',
      name: 'change_bg',
      desc: '',
      args: [],
    );
  }

  /// `time`
  String get time_management {
    return Intl.message(
      'time',
      name: 'time_management',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_pattern {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_pattern',
      desc: '',
      args: [],
    );
  }

  /// `End time cannot be earlier than start time`
  String get end_time_cannot_before_start_time {
    return Intl.message(
      'End time cannot be earlier than start time',
      name: 'end_time_cannot_before_start_time',
      desc: '',
      args: [],
    );
  }

  /// `please select start time`
  String get please_select_daily_start_time {
    return Intl.message(
      'please select start time',
      name: 'please_select_daily_start_time',
      desc: '',
      args: [],
    );
  }

  /// `Start time`
  String get start_time {
    return Intl.message(
      'Start time',
      name: 'start_time',
      desc: '',
      args: [],
    );
  }

  /// `daily start time`
  String get daily_start_time {
    return Intl.message(
      'daily start time',
      name: 'daily_start_time',
      desc: '',
      args: [],
    );
  }

  /// `daily end time`
  String get daily_end_time {
    return Intl.message(
      'daily end time',
      name: 'daily_end_time',
      desc: '',
      args: [],
    );
  }

  /// `(optional)`
  String get optional_with_parenthese {
    return Intl.message(
      '(optional)',
      name: 'optional_with_parenthese',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Finish`
  String get cancel_finish {
    return Intl.message(
      'Cancel Finish',
      name: 'cancel_finish',
      desc: '',
      args: [],
    );
  }

  /// `Search Country`
  String get search_country {
    return Intl.message(
      'Search Country',
      name: 'search_country',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Mobile Number`
  String get invalid_mobile_number {
    return Intl.message(
      'Invalid Mobile Number',
      name: 'invalid_mobile_number',
      desc: '',
      args: [],
    );
  }

  /// `No.:{value}`
  String focus_numbers_with_value(Object value) {
    return Intl.message(
      'No.:$value',
      name: 'focus_numbers_with_value',
      desc: '',
      args: [value],
    );
  }

  /// `Duration:{value}`
  String focus_duration_with_value(Object value) {
    return Intl.message(
      'Duration:$value',
      name: 'focus_duration_with_value',
      desc: '',
      args: [value],
    );
  }

  /// `No.:{value}`
  String rest_focus_numbers_with_value(Object value) {
    return Intl.message(
      'No.:$value',
      name: 'rest_focus_numbers_with_value',
      desc: '',
      args: [value],
    );
  }

  /// `Duration:{value}`
  String rest_focus_duration_with_value(Object value) {
    return Intl.message(
      'Duration:$value',
      name: 'rest_focus_duration_with_value',
      desc: '',
      args: [value],
    );
  }

  /// `add note`
  String get add_note {
    return Intl.message(
      'add note',
      name: 'add_note',
      desc: '',
      args: [],
    );
  }

  /// `write diary`
  String get write_diary {
    return Intl.message(
      'write diary',
      name: 'write_diary',
      desc: '',
      args: [],
    );
  }

  /// `add link`
  String get add_link {
    return Intl.message(
      'add link',
      name: 'add_link',
      desc: '',
      args: [],
    );
  }

  /// `Come back and make plans`
  String get notification_title {
    return Intl.message(
      'Come back and make plans',
      name: 'notification_title',
      desc: '',
      args: [],
    );
  }

  /// `It's time to make plans for tomorrow`
  String get notification0 {
    return Intl.message(
      'It\'s time to make plans for tomorrow',
      name: 'notification0',
      desc: '',
      args: [],
    );
  }

  /// `Don't wait for opportunities, create them. Use the Pomodoro Focus app to make the most of your time.`
  String get notification1 {
    return Intl.message(
      'Don\'t wait for opportunities, create them. Use the Pomodoro Focus app to make the most of your time.',
      name: 'notification1',
      desc: '',
      args: [],
    );
  }

  /// `Success is not final, failure is not fatal. It's the courage to continue that counts. Use the Pomodoro Focus app to keep going.`
  String get notification2 {
    return Intl.message(
      'Success is not final, failure is not fatal. It\'s the courage to continue that counts. Use the Pomodoro Focus app to keep going.',
      name: 'notification2',
      desc: '',
      args: [],
    );
  }

  /// `The journey of a thousand miles begins with one step. Use the Pomodoro Focus app to take that first step.`
  String get notification3 {
    return Intl.message(
      'The journey of a thousand miles begins with one step. Use the Pomodoro Focus app to take that first step.',
      name: 'notification3',
      desc: '',
      args: [],
    );
  }

  /// `The future belongs to those who believe in the beauty of their dreams. Use the Pomodoro Focus app to work towards your dreams.`
  String get notification4 {
    return Intl.message(
      'The future belongs to those who believe in the beauty of their dreams. Use the Pomodoro Focus app to work towards your dreams.',
      name: 'notification4',
      desc: '',
      args: [],
    );
  }

  /// `It's not about the destination, it's about the journey. Use the Pomodoro Focus app to make the most of every moment.`
  String get notification5 {
    return Intl.message(
      'It\'s not about the destination, it\'s about the journey. Use the Pomodoro Focus app to make the most of every moment.',
      name: 'notification5',
      desc: '',
      args: [],
    );
  }

  /// `Don't let yesterday take up too much of today. Use the Pomodoro Focus app to focus on the present moment.`
  String get notification6 {
    return Intl.message(
      'Don\'t let yesterday take up too much of today. Use the Pomodoro Focus app to focus on the present moment.',
      name: 'notification6',
      desc: '',
      args: [],
    );
  }

  /// `If you want to achieve greatness, stop asking for permission. Use the Pomodoro Focus app to take charge of your life.`
  String get notification7 {
    return Intl.message(
      'If you want to achieve greatness, stop asking for permission. Use the Pomodoro Focus app to take charge of your life.',
      name: 'notification7',
      desc: '',
      args: [],
    );
  }

  /// `Believe you can and you're halfway there. Use the Pomodoro Focus app to believe in yourself.`
  String get notification8 {
    return Intl.message(
      'Believe you can and you\'re halfway there. Use the Pomodoro Focus app to believe in yourself.',
      name: 'notification8',
      desc: '',
      args: [],
    );
  }

  /// `The only way to do great work is to love what you do. Use the Pomodoro Focus app to enjoy the journey.`
  String get notification9 {
    return Intl.message(
      'The only way to do great work is to love what you do. Use the Pomodoro Focus app to enjoy the journey.',
      name: 'notification9',
      desc: '',
      args: [],
    );
  }

  /// `Believe in yourself and all that you are. Use the Pomodoro Focus app to unlock your full potential.`
  String get notification10 {
    return Intl.message(
      'Believe in yourself and all that you are. Use the Pomodoro Focus app to unlock your full potential.',
      name: 'notification10',
      desc: '',
      args: [],
    );
  }

  /// `Believe in yourself and all that you are. Use the Pomodoro Focus app to unlock your full potential.`
  String get notification11 {
    return Intl.message(
      'Believe in yourself and all that you are. Use the Pomodoro Focus app to unlock your full potential.',
      name: 'notification11',
      desc: '',
      args: [],
    );
  }

  /// `Don't let the fear of striking out hold you back. Use the Pomodoro Focus app to take calculated risks.`
  String get notification12 {
    return Intl.message(
      'Don\'t let the fear of striking out hold you back. Use the Pomodoro Focus app to take calculated risks.',
      name: 'notification12',
      desc: '',
      args: [],
    );
  }

  /// `Success is not easy, but it's worth it. Use the Pomodoro Focus app to keep pushing forward.`
  String get notification13 {
    return Intl.message(
      'Success is not easy, but it\'s worth it. Use the Pomodoro Focus app to keep pushing forward.',
      name: 'notification13',
      desc: '',
      args: [],
    );
  }

  /// `You don't have to be great to start, but you have to start to be great. Use the Pomodoro Focus app to take that first step.`
  String get notification14 {
    return Intl.message(
      'You don\'t have to be great to start, but you have to start to be great. Use the Pomodoro Focus app to take that first step.',
      name: 'notification14',
      desc: '',
      args: [],
    );
  }

  /// `The greatest glory in living lies not in never falling, but in rising every time we fall. Use the Pomodoro Focus app to persevere through failure.`
  String get notification15 {
    return Intl.message(
      'The greatest glory in living lies not in never falling, but in rising every time we fall. Use the Pomodoro Focus app to persevere through failure.',
      name: 'notification15',
      desc: '',
      args: [],
    );
  }

  /// `our only limit is the amount of willingness to take action. Use the Pomodoro Focus app to take action towards your goals.`
  String get notification16 {
    return Intl.message(
      'our only limit is the amount of willingness to take action. Use the Pomodoro Focus app to take action towards your goals.',
      name: 'notification16',
      desc: '',
      args: [],
    );
  }

  /// `Don't watch the clock, do what it does: keep going. Use the Pomodoro Focus app to make the most of your time.`
  String get notification17 {
    return Intl.message(
      'Don\'t watch the clock, do what it does: keep going. Use the Pomodoro Focus app to make the most of your time.',
      name: 'notification17',
      desc: '',
      args: [],
    );
  }

  /// `What you get by achieving your goals is not as important as what you become by achieving your goals. Use the Pomodoro Focus app to become your best self.`
  String get notification18 {
    return Intl.message(
      'What you get by achieving your goals is not as important as what you become by achieving your goals. Use the Pomodoro Focus app to become your best self.',
      name: 'notification18',
      desc: '',
      args: [],
    );
  }

  /// `The greatest wealth is to live content with little. Use the Pomodoro Focus app to appreciate the simple things in life.`
  String get notification19 {
    return Intl.message(
      'The greatest wealth is to live content with little. Use the Pomodoro Focus app to appreciate the simple things in life.',
      name: 'notification19',
      desc: '',
      args: [],
    );
  }

  /// `Your future is created by what you do today, not tomorrow. Use the Pomodoro Focus app to take action towards your future.`
  String get notification20 {
    return Intl.message(
      'Your future is created by what you do today, not tomorrow. Use the Pomodoro Focus app to take action towards your future.',
      name: 'notification20',
      desc: '',
      args: [],
    );
  }

  /// `Customize your work content for tomorrow`
  String get notification_more {
    return Intl.message(
      'Customize your work content for tomorrow',
      name: 'notification_more',
      desc: '',
      args: [],
    );
  }

  /// `Today you have {value} missions to do，preview duration:{hour} hour {mins} mins`
  String notification_num_mission_to_finish(
      Object value, Object hour, Object mins) {
    return Intl.message(
      'Today you have $value missions to do，preview duration:$hour hour $mins mins',
      name: 'notification_num_mission_to_finish',
      desc: '',
      args: [value, hour, mins],
    );
  }

  /// `there are {n} delayed tasks，preview duration:{hour} hour {mins} mins `
  String notification_num_mission_to_finish_delay(
      Object n, Object hour, Object mins) {
    return Intl.message(
      'there are $n delayed tasks，preview duration:$hour hour $mins mins ',
      name: 'notification_num_mission_to_finish_delay',
      desc: '',
      args: [n, hour, mins],
    );
  }

  /// `no delayed task`
  String get no_delayed_task {
    return Intl.message(
      'no delayed task',
      name: 'no_delayed_task',
      desc: '',
      args: [],
    );
  }

  /// `Delete Successfully`
  String get delete_success {
    return Intl.message(
      'Delete Successfully',
      name: 'delete_success',
      desc: '',
      args: [],
    );
  }

  /// `Finish voice note`
  String get complete_voice_note {
    return Intl.message(
      'Finish voice note',
      name: 'complete_voice_note',
      desc: '',
      args: [],
    );
  }

  /// `note diary`
  String get note_diary {
    return Intl.message(
      'note diary',
      name: 'note_diary',
      desc: '',
      args: [],
    );
  }

  /// `voice diary`
  String get voice_diary {
    return Intl.message(
      'voice diary',
      name: 'voice_diary',
      desc: '',
      args: [],
    );
  }

  /// `type`
  String get type {
    return Intl.message(
      'type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `voice`
  String get voice {
    return Intl.message(
      'voice',
      name: 'voice',
      desc: '',
      args: [],
    );
  }

  /// `{name}`
  String complete_voice_diary_with_title(Object name) {
    return Intl.message(
      '$name',
      name: 'complete_voice_diary_with_title',
      desc: '',
      args: [name],
    );
  }

  /// `Finish voice diary`
  String get complete_voice_diary {
    return Intl.message(
      'Finish voice diary',
      name: 'complete_voice_diary',
      desc: '',
      args: [],
    );
  }

  /// `resume`
  String get resume {
    return Intl.message(
      'resume',
      name: 'resume',
      desc: '',
      args: [],
    );
  }

  /// `Maximum recording time:{time}`
  String maximum_recording_time(Object time) {
    return Intl.message(
      'Maximum recording time:$time',
      name: 'maximum_recording_time',
      desc: '',
      args: [time],
    );
  }

  /// `No permission of microphone, please turn on first`
  String get no_microphone_permission {
    return Intl.message(
      'No permission of microphone, please turn on first',
      name: 'no_microphone_permission',
      desc: '',
      args: [],
    );
  }

  /// `play`
  String get play {
    return Intl.message(
      'play',
      name: 'play',
      desc: '',
      args: [],
    );
  }

  /// `sound recording`
  String get sound_recording {
    return Intl.message(
      'sound recording',
      name: 'sound_recording',
      desc: '',
      args: [],
    );
  }

  /// `privacy`
  String get privacy {
    return Intl.message(
      'privacy',
      name: 'privacy',
      desc: '',
      args: [],
    );
  }

  /// `ON`
  String get on {
    return Intl.message(
      'ON',
      name: 'on',
      desc: '',
      args: [],
    );
  }

  /// `OFF`
  String get off {
    return Intl.message(
      'OFF',
      name: 'off',
      desc: '',
      args: [],
    );
  }

  /// `No Notification Permission`
  String get no_notification_permission_title {
    return Intl.message(
      'No Notification Permission',
      name: 'no_notification_permission_title',
      desc: '',
      args: [],
    );
  }

  /// `Need to open notification permission to use this function`
  String get need_notification_permission_content {
    return Intl.message(
      'Need to open notification permission to use this function',
      name: 'need_notification_permission_content',
      desc: '',
      args: [],
    );
  }

  /// `Open to setting`
  String get go_to_setting {
    return Intl.message(
      'Open to setting',
      name: 'go_to_setting',
      desc: '',
      args: [],
    );
  }

  /// `The mission {name} has begun, please prepare`
  String your_mission_with_name_has_begun(Object name) {
    return Intl.message(
      'The mission $name has begun, please prepare',
      name: 'your_mission_with_name_has_begun',
      desc: '',
      args: [name],
    );
  }

  /// `Mission Alert: {name}`
  String mission_alert_with_name(Object name) {
    return Intl.message(
      'Mission Alert: $name',
      name: 'mission_alert_with_name',
      desc: '',
      args: [name],
    );
  }

  /// `Uploading Image`
  String get uploading_pic {
    return Intl.message(
      'Uploading Image',
      name: 'uploading_pic',
      desc: '',
      args: [],
    );
  }

  /// `Last update time:{time}`
  String update_last_time(Object time) {
    return Intl.message(
      'Last update time:$time',
      name: 'update_last_time',
      desc: '',
      args: [time],
    );
  }

  /// `insert successfully`
  String get insert_success {
    return Intl.message(
      'insert successfully',
      name: 'insert_success',
      desc: '',
      args: [],
    );
  }

  /// `insert event`
  String get insert_event {
    return Intl.message(
      'insert event',
      name: 'insert_event',
      desc: '',
      args: [],
    );
  }

  /// `edit failed`
  String get edit_fail {
    return Intl.message(
      'edit failed',
      name: 'edit_fail',
      desc: '',
      args: [],
    );
  }

  /// `add failed`
  String get add_fail {
    return Intl.message(
      'add failed',
      name: 'add_fail',
      desc: '',
      args: [],
    );
  }

  /// `edit successfully, it can be viewed it in TimeLine page`
  String get edit_successfully {
    return Intl.message(
      'edit successfully, it can be viewed it in TimeLine page',
      name: 'edit_successfully',
      desc: '',
      args: [],
    );
  }

  /// `add successfully, you can be viewed it in TimeLine page`
  String get add_successfully {
    return Intl.message(
      'add successfully, you can be viewed it in TimeLine page',
      name: 'add_successfully',
      desc: '',
      args: [],
    );
  }

  /// `detail`
  String get see {
    return Intl.message(
      'detail',
      name: 'see',
      desc: '',
      args: [],
    );
  }

  /// `Write a title?`
  String get write_a_title {
    return Intl.message(
      'Write a title?',
      name: 'write_a_title',
      desc: '',
      args: [],
    );
  }

  /// `wrote a not:{diary}`
  String wrote_a_note(Object diary) {
    return Intl.message(
      'wrote a not:$diary',
      name: 'wrote_a_note',
      desc: '',
      args: [diary],
    );
  }

  /// `wrote a diary:{diary}`
  String wrote_a_diary(Object diary) {
    return Intl.message(
      'wrote a diary:$diary',
      name: 'wrote_a_diary',
      desc: '',
      args: [diary],
    );
  }

  /// `trans.`
  String get transaction {
    return Intl.message(
      'trans.',
      name: 'transaction',
      desc: '',
      args: [],
    );
  }

  /// `event`
  String get event {
    return Intl.message(
      'event',
      name: 'event',
      desc: '',
      args: [],
    );
  }

  /// `note`
  String get note_short {
    return Intl.message(
      'note',
      name: 'note_short',
      desc: '',
      args: [],
    );
  }

  /// `diary`
  String get diary {
    return Intl.message(
      'diary',
      name: 'diary',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Capture a video`
  String get capture_a_video {
    return Intl.message(
      'Capture a video',
      name: 'capture_a_video',
      desc: '',
      args: [],
    );
  }

  /// `Capture a photo`
  String get capture_a_photo {
    return Intl.message(
      'Capture a photo',
      name: 'capture_a_photo',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'load error' key

  /// `Add content`
  String get add_content {
    return Intl.message(
      'Add content',
      name: 'add_content',
      desc: '',
      args: [],
    );
  }

  /// `Timeline`
  String get timeline {
    return Intl.message(
      'Timeline',
      name: 'timeline',
      desc: '',
      args: [],
    );
  }

  /// `now`
  String get now {
    return Intl.message(
      'now',
      name: 'now',
      desc: '',
      args: [],
    );
  }

  /// `{money} days later`
  String days_later(Object money) {
    return Intl.message(
      '$money days later',
      name: 'days_later',
      desc: '',
      args: [money],
    );
  }

  /// `{money} later`
  String time_later(Object money) {
    return Intl.message(
      '$money later',
      name: 'time_later',
      desc: '',
      args: [money],
    );
  }

  /// `{money} ago`
  String time_ago(Object money) {
    return Intl.message(
      '$money ago',
      name: 'time_ago',
      desc: '',
      args: [money],
    );
  }

  /// `{money} ago`
  String days_ago(Object money) {
    return Intl.message(
      '$money ago',
      name: 'days_ago',
      desc: '',
      args: [money],
    );
  }

  /// `Consume {money} coins to buy a {present}`
  String consume_money_buy_present(Object money, Object present) {
    return Intl.message(
      'Consume $money coins to buy a $present',
      name: 'consume_money_buy_present',
      desc: '',
      args: [money, present],
    );
  }

  /// `Consume「{money}」coins（entered manually）`
  String consume_money(Object money) {
    return Intl.message(
      'Consume「$money」coins（entered manually）',
      name: 'consume_money',
      desc: '',
      args: [money],
    );
  }

  /// `create  tag '{title}'`
  String create_name_tag(Object title) {
    return Intl.message(
      'create  tag \'$title\'',
      name: 'create_name_tag',
      desc: '',
      args: [title],
    );
  }

  /// `Modify tag title to '{title}'`
  String modify_name_tag(Object title) {
    return Intl.message(
      'Modify tag title to \'$title\'',
      name: 'modify_name_tag',
      desc: '',
      args: [title],
    );
  }

  /// `Modify listing title to {title}`
  String modify_name_listing(Object title) {
    return Intl.message(
      'Modify listing title to $title',
      name: 'modify_name_listing',
      desc: '',
      args: [title],
    );
  }

  /// `Create listing '{title}'`
  String create_name_listing(Object title) {
    return Intl.message(
      'Create listing \'$title\'',
      name: 'create_name_listing',
      desc: '',
      args: [title],
    );
  }

  /// `in the listing '{listing}' create a mission '{title}'`
  String create_name_mission(Object listing, Object title) {
    return Intl.message(
      'in the listing \'$listing\' create a mission \'$title\'',
      name: 'create_name_mission',
      desc: '',
      args: [listing, title],
    );
  }

  /// `Create mission '{title}'`
  String create_name_mission2(Object title) {
    return Intl.message(
      'Create mission \'$title\'',
      name: 'create_name_mission2',
      desc: '',
      args: [title],
    );
  }

  /// `in the listing '{listing}' update a mission '{title}'`
  String update_name_mission(Object listing, Object title) {
    return Intl.message(
      'in the listing \'$listing\' update a mission \'$title\'',
      name: 'update_name_mission',
      desc: '',
      args: [listing, title],
    );
  }

  /// `Update mission '{title}'`
  String update_name_mission2(Object title) {
    return Intl.message(
      'Update mission \'$title\'',
      name: 'update_name_mission2',
      desc: '',
      args: [title],
    );
  }

  /// `In the list '{listing}', created a ClockIn task '{title}'`
  String create_name_flomomission(Object listing, Object title) {
    return Intl.message(
      'In the list \'$listing\', created a ClockIn task \'$title\'',
      name: 'create_name_flomomission',
      desc: '',
      args: [listing, title],
    );
  }

  /// `Created a ClockIn task '{title}'`
  String create_name_flomomission2(Object title) {
    return Intl.message(
      'Created a ClockIn task \'$title\'',
      name: 'create_name_flomomission2',
      desc: '',
      args: [title],
    );
  }

  /// `Batch delete '{numbers}' tasks`
  String batch_delete_missions(Object numbers) {
    return Intl.message(
      'Batch delete \'$numbers\' tasks',
      name: 'batch_delete_missions',
      desc: '',
      args: [numbers],
    );
  }

  /// `Batch update '{numbers}' tasks`
  String batch_update_missions(Object numbers) {
    return Intl.message(
      'Batch update \'$numbers\' tasks',
      name: 'batch_update_missions',
      desc: '',
      args: [numbers],
    );
  }

  /// `Batch complete '{numbers}' tasks`
  String batch_complete_missions(Object numbers) {
    return Intl.message(
      'Batch complete \'$numbers\' tasks',
      name: 'batch_complete_missions',
      desc: '',
      args: [numbers],
    );
  }

  /// `Batch uncomplete '{numbers}' tasks`
  String batch_uncomplete_missions(Object numbers) {
    return Intl.message(
      'Batch uncomplete \'$numbers\' tasks',
      name: 'batch_uncomplete_missions',
      desc: '',
      args: [numbers],
    );
  }

  /// `Start focusing on task '{title}'`
  String start_focusing_mission_name(Object title) {
    return Intl.message(
      'Start focusing on task \'$title\'',
      name: 'start_focusing_mission_name',
      desc: '',
      args: [title],
    );
  }

  /// `Complete one-time focusing task '{title}', focused for {time}, and get {num} coins `
  String complete_one_time_focusing_mission_name(
      Object title, Object time, Object num) {
    return Intl.message(
      'Complete one-time focusing task \'$title\', focused for $time, and get $num coins ',
      name: 'complete_one_time_focusing_mission_name',
      desc: '',
      args: [title, time, num],
    );
  }

  /// `Complete focusing task '{title}', and get {num} coins `
  String complete_focusing_mission_name(Object title, Object num) {
    return Intl.message(
      'Complete focusing task \'$title\', and get $num coins ',
      name: 'complete_focusing_mission_name',
      desc: '',
      args: [title, num],
    );
  }

  /// `Stop focusing on mission '{title}',focused for {time}, and get {num} coins `
  String stop_focusing_mission_name(Object title, Object time, Object num) {
    return Intl.message(
      'Stop focusing on mission \'$title\',focused for $time, and get $num coins ',
      name: 'stop_focusing_mission_name',
      desc: '',
      args: [title, time, num],
    );
  }

  /// `Leave app,Mission「{title}」,Focus duration {time},made {num} coins`
  String exist_app_focusing_mission_name(
      Object title, Object time, Object num) {
    return Intl.message(
      'Leave app,Mission「$title」,Focus duration $time,made $num coins',
      name: 'exist_app_focusing_mission_name',
      desc: '',
      args: [title, time, num],
    );
  }

  /// `Stop resting mission 「{title}」`
  String stop_resting_mission_name(Object title) {
    return Intl.message(
      'Stop resting mission 「$title」',
      name: 'stop_resting_mission_name',
      desc: '',
      args: [title],
    );
  }

  /// `complete resting mission 「{title}」`
  String complete_resting_mission_name(Object title) {
    return Intl.message(
      'complete resting mission 「$title」',
      name: 'complete_resting_mission_name',
      desc: '',
      args: [title],
    );
  }

  /// `start resting mission 「{title}」`
  String start_resting_name(Object title) {
    return Intl.message(
      'start resting mission 「$title」',
      name: 'start_resting_name',
      desc: '',
      args: [title],
    );
  }

  /// `Finish mission 「{title}」`
  String finish_mission_name(Object title) {
    return Intl.message(
      'Finish mission 「$title」',
      name: 'finish_mission_name',
      desc: '',
      args: [title],
    );
  }

  /// `complete resting mission 「{title}」`
  String complete_resting_name(Object title) {
    return Intl.message(
      'complete resting mission 「$title」',
      name: 'complete_resting_name',
      desc: '',
      args: [title],
    );
  }

  /// `order by update time(Suitable for work report)`
  String get order_by_update_time {
    return Intl.message(
      'order by update time(Suitable for work report)',
      name: 'order_by_update_time',
      desc: '',
      args: [],
    );
  }

  /// `Successfully copied to clipboard`
  String get successfully_copied_to_clipboard {
    return Intl.message(
      'Successfully copied to clipboard',
      name: 'successfully_copied_to_clipboard',
      desc: '',
      args: [],
    );
  }

  /// `export data`
  String get export_data {
    return Intl.message(
      'export data',
      name: 'export_data',
      desc: '',
      args: [],
    );
  }

  /// `Sliding left and right`
  String get slide_left_right {
    return Intl.message(
      'Sliding left and right',
      name: 'slide_left_right',
      desc: '',
      args: [],
    );
  }

  /// `Select content`
  String get select_contents {
    return Intl.message(
      'Select content',
      name: 'select_contents',
      desc: '',
      args: [],
    );
  }

  /// `offer next version`
  String get offer_next_version {
    return Intl.message(
      'offer next version',
      name: 'offer_next_version',
      desc: '',
      args: [],
    );
  }

  /// `export to Excel File`
  String get export_excel {
    return Intl.message(
      'export to Excel File',
      name: 'export_excel',
      desc: '',
      args: [],
    );
  }

  /// `Latest Update Time`
  String get update_time_last_time {
    return Intl.message(
      'Latest Update Time',
      name: 'update_time_last_time',
      desc: '',
      args: [],
    );
  }

  /// `Create Time`
  String get create_time {
    return Intl.message(
      'Create Time',
      name: 'create_time',
      desc: '',
      args: [],
    );
  }

  /// `{num}`
  String num_unit(Object num) {
    return Intl.message(
      '$num',
      name: 'num_unit',
      desc: '',
      args: [num],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get tagNames {
    return Intl.message(
      'Tags',
      name: 'tagNames',
      desc: '',
      args: [],
    );
  }

  /// `Total Finished Tasks`
  String get no_tomotoes_finished {
    return Intl.message(
      'Total Finished Tasks',
      name: 'no_tomotoes_finished',
      desc: '',
      args: [],
    );
  }

  /// `total tasks(Total Tomatoes)`
  String get total_tasks_count {
    return Intl.message(
      'total tasks(Total Tomatoes)',
      name: 'total_tasks_count',
      desc: '',
      args: [],
    );
  }

  /// `Total Tomatoes`
  String get total_tomotoes {
    return Intl.message(
      'Total Tomatoes',
      name: 'total_tomotoes',
      desc: '',
      args: [],
    );
  }

  /// `Focused Duration`
  String get tomato_duration {
    return Intl.message(
      'Focused Duration',
      name: 'tomato_duration',
      desc: '',
      args: [],
    );
  }

  /// `Finished Time `
  String get time_finished {
    return Intl.message(
      'Finished Time ',
      name: 'time_finished',
      desc: '',
      args: [],
    );
  }

  /// `Priority:`
  String get priorityStatus {
    return Intl.message(
      'Priority:',
      name: 'priorityStatus',
      desc: '',
      args: [],
    );
  }

  /// `message`
  String get message {
    return Intl.message(
      'message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Finished Status`
  String get isFinished {
    return Intl.message(
      'Finished Status',
      name: 'isFinished',
      desc: '',
      args: [],
    );
  }

  /// `Is Delayed`
  String get isDelayed {
    return Intl.message(
      'Is Delayed',
      name: 'isDelayed',
      desc: '',
      args: [],
    );
  }

  /// `Repeative Type`
  String get repetiveType {
    return Intl.message(
      'Repeative Type',
      name: 'repetiveType',
      desc: '',
      args: [],
    );
  }

  /// `Repeative Value`
  String get repetiveValue {
    return Intl.message(
      'Repeative Value',
      name: 'repetiveValue',
      desc: '',
      args: [],
    );
  }

  /// `Repeative Days`
  String get repetiveWeekDay {
    return Intl.message(
      'Repeative Days',
      name: 'repetiveWeekDay',
      desc: '',
      args: [],
    );
  }

  /// `please input mobile`
  String get please_input_mobile_no {
    return Intl.message(
      'please input mobile',
      name: 'please_input_mobile_no',
      desc: '',
      args: [],
    );
  }

  /// `please input password`
  String get please_input_password {
    return Intl.message(
      'please input password',
      name: 'please_input_password',
      desc: '',
      args: [],
    );
  }

  /// `reply`
  String get reply {
    return Intl.message(
      'reply',
      name: 'reply',
      desc: '',
      args: [],
    );
  }

  /// `Switch to timer mode, will work next time`
  String get switch_timer_mode_success {
    return Intl.message(
      'Switch to timer mode, will work next time',
      name: 'switch_timer_mode_success',
      desc: '',
      args: [],
    );
  }

  /// `Switch to chronograph mode, will work next time`
  String get switch_chronograph_mode_success {
    return Intl.message(
      'Switch to chronograph mode, will work next time',
      name: 'switch_chronograph_mode_success',
      desc: '',
      args: [],
    );
  }

  /// `chronograph`
  String get chronograph {
    return Intl.message(
      'chronograph',
      name: 'chronograph',
      desc: '',
      args: [],
    );
  }

  /// `timer`
  String get timer {
    return Intl.message(
      'timer',
      name: 'timer',
      desc: '',
      args: [],
    );
  }

  /// `no ranking`
  String get no_ranking {
    return Intl.message(
      'no ranking',
      name: 'no_ranking',
      desc: '',
      args: [],
    );
  }

  /// `no task`
  String get no_task {
    return Intl.message(
      'no task',
      name: 'no_task',
      desc: '',
      args: [],
    );
  }

  /// `others`
  String get others {
    return Intl.message(
      'others',
      name: 'others',
      desc: '',
      args: [],
    );
  }

  /// `Create Task`
  String get add_task {
    return Intl.message(
      'Create Task',
      name: 'add_task',
      desc: '',
      args: [],
    );
  }

  /// `analyse`
  String get analyse {
    return Intl.message(
      'analyse',
      name: 'analyse',
      desc: '',
      args: [],
    );
  }

  /// `{month},{year}`
  String year_month(Object month, Object year) {
    return Intl.message(
      '$month,$year',
      name: 'year_month',
      desc: '',
      args: [month, year],
    );
  }

  /// `{num} mins`
  String num_mins(Object num) {
    return Intl.message(
      '$num mins',
      name: 'num_mins',
      desc: '',
      args: [num],
    );
  }

  /// `last 7 days`
  String get last_7_days {
    return Intl.message(
      'last 7 days',
      name: 'last_7_days',
      desc: '',
      args: [],
    );
  }

  /// `{date}'s data`
  String title_data(Object date) {
    return Intl.message(
      '$date\'s data',
      name: 'title_data',
      desc: '',
      args: [date],
    );
  }

  /// `Total focus time`
  String get total_focus_duration {
    return Intl.message(
      'Total focus time',
      name: 'total_focus_duration',
      desc: '',
      args: [],
    );
  }

  /// `Completion Rate`
  String get completion_rate {
    return Intl.message(
      'Completion Rate',
      name: 'completion_rate',
      desc: '',
      args: [],
    );
  }

  /// `Focus on time period distribution`
  String get focus_on_time_period_distribution {
    return Intl.message(
      'Focus on time period distribution',
      name: 'focus_on_time_period_distribution',
      desc: '',
      args: [],
    );
  }

  /// `Focus duration distribution`
  String get focus_duration_distribution {
    return Intl.message(
      'Focus duration distribution',
      name: 'focus_duration_distribution',
      desc: '',
      args: [],
    );
  }

  /// `{num} tasks`
  String num_tasks(Object num) {
    return Intl.message(
      '$num tasks',
      name: 'num_tasks',
      desc: '',
      args: [num],
    );
  }

  /// `{num} times`
  String num_times(Object num) {
    return Intl.message(
      '$num times',
      name: 'num_times',
      desc: '',
      args: [num],
    );
  }

  /// `Finished plan classification`
  String get complete_plan_classification {
    return Intl.message(
      'Finished plan classification',
      name: 'complete_plan_classification',
      desc: '',
      args: [],
    );
  }

  /// `Unfinished plan classification`
  String get uncomplete_plan_classification {
    return Intl.message(
      'Unfinished plan classification',
      name: 'uncomplete_plan_classification',
      desc: '',
      args: [],
    );
  }

  /// `Completion plan priority`
  String get priority_distribution_of_completion_plan {
    return Intl.message(
      'Completion plan priority',
      name: 'priority_distribution_of_completion_plan',
      desc: '',
      args: [],
    );
  }

  /// `Unfinished plan priority`
  String get priority_distribution_of_uncompletion_plan {
    return Intl.message(
      'Unfinished plan priority',
      name: 'priority_distribution_of_uncompletion_plan',
      desc: '',
      args: [],
    );
  }

  /// `Compared with yesterday`
  String get compare_to_tomorrow {
    return Intl.message(
      'Compared with yesterday',
      name: 'compare_to_tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `Total Finishing Tasks`
  String get num_tasks_finished {
    return Intl.message(
      'Total Finishing Tasks',
      name: 'num_tasks_finished',
      desc: '',
      args: [],
    );
  }

  /// `Today's data`
  String get today_data {
    return Intl.message(
      'Today\'s data',
      name: 'today_data',
      desc: '',
      args: [],
    );
  }

  /// `summary`
  String get summary {
    return Intl.message(
      'summary',
      name: 'summary',
      desc: '',
      args: [],
    );
  }

  /// `please input the task title`
  String get please_input_the_mission_title {
    return Intl.message(
      'please input the task title',
      name: 'please_input_the_mission_title',
      desc: '',
      args: [],
    );
  }

  /// `optional`
  String get optional {
    return Intl.message(
      'optional',
      name: 'optional',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get select_all {
    return Intl.message(
      'Select All',
      name: 'select_all',
      desc: '',
      args: [],
    );
  }

  /// `Quadrant`
  String get four_quadrant {
    return Intl.message(
      'Quadrant',
      name: 'four_quadrant',
      desc: '',
      args: [],
    );
  }

  /// `Please select the search year`
  String get please_select_year_to_search {
    return Intl.message(
      'Please select the search year',
      name: 'please_select_year_to_search',
      desc: '',
      args: [],
    );
  }

  /// `Please select the search month`
  String get please_select_month {
    return Intl.message(
      'Please select the search month',
      name: 'please_select_month',
      desc: '',
      args: [],
    );
  }

  /// `Please select the search date`
  String get please_select_date {
    return Intl.message(
      'Please select the search date',
      name: 'please_select_date',
      desc: '',
      args: [],
    );
  }

  /// `Please select the search date range`
  String get please_select_daterange {
    return Intl.message(
      'Please select the search date range',
      name: 'please_select_daterange',
      desc: '',
      args: [],
    );
  }

  /// `Jan`
  String get jan {
    return Intl.message(
      'Jan',
      name: 'jan',
      desc: '',
      args: [],
    );
  }

  /// `Feb`
  String get feb {
    return Intl.message(
      'Feb',
      name: 'feb',
      desc: '',
      args: [],
    );
  }

  /// `Mar`
  String get mar {
    return Intl.message(
      'Mar',
      name: 'mar',
      desc: '',
      args: [],
    );
  }

  /// `Apr`
  String get apr {
    return Intl.message(
      'Apr',
      name: 'apr',
      desc: '',
      args: [],
    );
  }

  /// `May`
  String get may {
    return Intl.message(
      'May',
      name: 'may',
      desc: '',
      args: [],
    );
  }

  /// `Jun`
  String get jun {
    return Intl.message(
      'Jun',
      name: 'jun',
      desc: '',
      args: [],
    );
  }

  /// `Jul`
  String get jul {
    return Intl.message(
      'Jul',
      name: 'jul',
      desc: '',
      args: [],
    );
  }

  /// `Aug`
  String get aug {
    return Intl.message(
      'Aug',
      name: 'aug',
      desc: '',
      args: [],
    );
  }

  /// `Sep`
  String get sep {
    return Intl.message(
      'Sep',
      name: 'sep',
      desc: '',
      args: [],
    );
  }

  /// `Oct`
  String get oct {
    return Intl.message(
      'Oct',
      name: 'oct',
      desc: '',
      args: [],
    );
  }

  /// `Nov`
  String get nov {
    return Intl.message(
      'Nov',
      name: 'nov',
      desc: '',
      args: [],
    );
  }

  /// `Dec`
  String get dec {
    return Intl.message(
      'Dec',
      name: 'dec',
      desc: '',
      args: [],
    );
  }

  /// `January`
  String get janFull {
    return Intl.message(
      'January',
      name: 'janFull',
      desc: '',
      args: [],
    );
  }

  /// `February`
  String get febFull {
    return Intl.message(
      'February',
      name: 'febFull',
      desc: '',
      args: [],
    );
  }

  /// `March`
  String get marFull {
    return Intl.message(
      'March',
      name: 'marFull',
      desc: '',
      args: [],
    );
  }

  /// `April`
  String get aprFull {
    return Intl.message(
      'April',
      name: 'aprFull',
      desc: '',
      args: [],
    );
  }

  /// `May`
  String get mayFull {
    return Intl.message(
      'May',
      name: 'mayFull',
      desc: '',
      args: [],
    );
  }

  /// `June`
  String get junFull {
    return Intl.message(
      'June',
      name: 'junFull',
      desc: '',
      args: [],
    );
  }

  /// `July`
  String get julFull {
    return Intl.message(
      'July',
      name: 'julFull',
      desc: '',
      args: [],
    );
  }

  /// `August`
  String get augFull {
    return Intl.message(
      'August',
      name: 'augFull',
      desc: '',
      args: [],
    );
  }

  /// `September`
  String get sepFull {
    return Intl.message(
      'September',
      name: 'sepFull',
      desc: '',
      args: [],
    );
  }

  /// `October`
  String get octFull {
    return Intl.message(
      'October',
      name: 'octFull',
      desc: '',
      args: [],
    );
  }

  /// `November`
  String get novFull {
    return Intl.message(
      'November',
      name: 'novFull',
      desc: '',
      args: [],
    );
  }

  /// `December`
  String get decFull {
    return Intl.message(
      'December',
      name: 'decFull',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `imp. & urg.`
  String get four_quadrant_priority1_abbr {
    return Intl.message(
      'imp. & urg.',
      name: 'four_quadrant_priority1_abbr',
      desc: '',
      args: [],
    );
  }

  /// `not imp. & urg.`
  String get four_quadrant_priority2_abbr {
    return Intl.message(
      'not imp. & urg.',
      name: 'four_quadrant_priority2_abbr',
      desc: '',
      args: [],
    );
  }

  /// `imp. & not urg.`
  String get four_quadrant_priority3_abbr {
    return Intl.message(
      'imp. & not urg.',
      name: 'four_quadrant_priority3_abbr',
      desc: '',
      args: [],
    );
  }

  /// `not imp. & not urg.`
  String get four_quadrant_priority4_abbr {
    return Intl.message(
      'not imp. & not urg.',
      name: 'four_quadrant_priority4_abbr',
      desc: '',
      args: [],
    );
  }

  /// `important and urgent`
  String get four_quadrant_priority1 {
    return Intl.message(
      'important and urgent',
      name: 'four_quadrant_priority1',
      desc: '',
      args: [],
    );
  }

  /// `highest priority to do`
  String get four_quadrant_priority1_desc {
    return Intl.message(
      'highest priority to do',
      name: 'four_quadrant_priority1_desc',
      desc: '',
      args: [],
    );
  }

  /// `imp.&not urg.`
  String get four_quadrant_priority2 {
    return Intl.message(
      'imp.&not urg.',
      name: 'four_quadrant_priority2',
      desc: '',
      args: [],
    );
  }

  /// `make a plan to do it`
  String get four_quadrant_priority2_desc {
    return Intl.message(
      'make a plan to do it',
      name: 'four_quadrant_priority2_desc',
      desc: '',
      args: [],
    );
  }

  /// `not imp.&urgent`
  String get four_quadrant_priority3 {
    return Intl.message(
      'not imp.&urgent',
      name: 'four_quadrant_priority3',
      desc: '',
      args: [],
    );
  }

  /// `make others to do`
  String get four_quadrant_priority3_desc {
    return Intl.message(
      'make others to do',
      name: 'four_quadrant_priority3_desc',
      desc: '',
      args: [],
    );
  }

  /// `not imp.&not urg.`
  String get four_quadrant_priority4 {
    return Intl.message(
      'not imp.&not urg.',
      name: 'four_quadrant_priority4',
      desc: '',
      args: [],
    );
  }

  /// `do it when free`
  String get four_quadrant_priority4_desc {
    return Intl.message(
      'do it when free',
      name: 'four_quadrant_priority4_desc',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a title`
  String get please_input_title {
    return Intl.message(
      'Please enter a title',
      name: 'please_input_title',
      desc: '',
      args: [],
    );
  }

  /// `Edit title "{title}"`
  String edit_title(Object title) {
    return Intl.message(
      'Edit title "$title"',
      name: 'edit_title',
      desc: '',
      args: [title],
    );
  }

  /// `Temporarily not processed`
  String get not_handling {
    return Intl.message(
      'Temporarily not processed',
      name: 'not_handling',
      desc: '',
      args: [],
    );
  }

  /// `Comment cannot be empty`
  String get comment_not_empty {
    return Intl.message(
      'Comment cannot be empty',
      name: 'comment_not_empty',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `We will try our best to realize any reasonable suggestion from you within one week`
  String get comment_placeholder {
    return Intl.message(
      'We will try our best to realize any reasonable suggestion from you within one week',
      name: 'comment_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `processed`
  String get status_complete {
    return Intl.message(
      'processed',
      name: 'status_complete',
      desc: '',
      args: [],
    );
  }

  /// `In development`
  String get status_developping {
    return Intl.message(
      'In development',
      name: 'status_developping',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get status_handling {
    return Intl.message(
      'Processing',
      name: 'status_handling',
      desc: '',
      args: [],
    );
  }

  /// `waiting for processing`
  String get status_waiting {
    return Intl.message(
      'waiting for processing',
      name: 'status_waiting',
      desc: '',
      args: [],
    );
  }

  /// `feedback`
  String get feedback {
    return Intl.message(
      'feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Begin Focusing`
  String get guide1 {
    return Intl.message(
      'Begin Focusing',
      name: 'guide1',
      desc: '',
      args: [],
    );
  }

  /// `Click the header input box to add tasks`
  String get guide2 {
    return Intl.message(
      'Click the header input box to add tasks',
      name: 'guide2',
      desc: '',
      args: [],
    );
  }

  /// `Swipe right to edit or delete tasks`
  String get guide3_mobile {
    return Intl.message(
      'Swipe right to edit or delete tasks',
      name: 'guide3_mobile',
      desc: '',
      args: [],
    );
  }

  /// `Swipe the mouse to edit or delete tasks`
  String get guide3_pc {
    return Intl.message(
      'Swipe the mouse to edit or delete tasks',
      name: 'guide3_pc',
      desc: '',
      args: [],
    );
  }

  /// `Click the red play button to focus on timing`
  String get guide4 {
    return Intl.message(
      'Click the red play button to focus on timing',
      name: 'guide4',
      desc: '',
      args: [],
    );
  }

  /// `Poromoro ToDo`
  String get app_name {
    return Intl.message(
      'Poromoro ToDo',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Permission settings`
  String get permission_setting {
    return Intl.message(
      'Permission settings',
      name: 'permission_setting',
      desc: '',
      args: [],
    );
  }

  /// `Targeted push settings`
  String get is_push_setting {
    return Intl.message(
      'Targeted push settings',
      name: 'is_push_setting',
      desc: '',
      args: [],
    );
  }

  /// `Turn on targeted push settings, which will help you to be notified of the completion of your tasks`
  String get is_push_setting_detail {
    return Intl.message(
      'Turn on targeted push settings, which will help you to be notified of the completion of your tasks',
      name: 'is_push_setting_detail',
      desc: '',
      args: [],
    );
  }

  /// `Unregister Account`
  String get unregister {
    return Intl.message(
      'Unregister Account',
      name: 'unregister',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get unregister_temp {
    return Intl.message(
      'Cancel',
      name: 'unregister_temp',
      desc: '',
      args: [],
    );
  }

  /// `Please complete SMS password verification`
  String get please_finish_msn {
    return Intl.message(
      'Please complete SMS password verification',
      name: 'please_finish_msn',
      desc: '',
      args: [],
    );
  }

  /// `After logging out, the following information will be affected`
  String get unregister_title {
    return Intl.message(
      'After logging out, the following information will be affected',
      name: 'unregister_title',
      desc: '',
      args: [],
    );
  }

  /// `All account information will be deleted\nAll your related list, task data\nPackage coupons will be emptied and cannot be restored\nRegister again after logout, but historical data will not be restored`
  String get unregister_content {
    return Intl.message(
      'All account information will be deleted\\nAll your related list, task data\\nPackage coupons will be emptied and cannot be restored\\nRegister again after logout, but historical data will not be restored',
      name: 'unregister_content',
      desc: '',
      args: [],
    );
  }

  /// `think about it`
  String get consider_it {
    return Intl.message(
      'think about it',
      name: 'consider_it',
      desc: '',
      args: [],
    );
  }

  /// `Confirm unregister`
  String get confirm_unregister {
    return Intl.message(
      'Confirm unregister',
      name: 'confirm_unregister',
      desc: '',
      args: [],
    );
  }

  /// `Unregister account`
  String get unregister_account {
    return Intl.message(
      'Unregister account',
      name: 'unregister_account',
      desc: '',
      args: [],
    );
  }

  /// `Unregister Account And Delete Related Data`
  String get account_unregister {
    return Intl.message(
      'Unregister Account And Delete Related Data',
      name: 'account_unregister',
      desc: '',
      args: [],
    );
  }

  /// `privacy management`
  String get privacy_management {
    return Intl.message(
      'privacy management',
      name: 'privacy_management',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty 1: 10 words`
  String get level1_num_10 {
    return Intl.message(
      'Difficulty 1: 10 words',
      name: 'level1_num_10',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty 2: 20 words`
  String get level2_num_20 {
    return Intl.message(
      'Difficulty 2: 20 words',
      name: 'level2_num_20',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty 2: 50 words`
  String get level3_num_50 {
    return Intl.message(
      'Difficulty 2: 50 words',
      name: 'level3_num_50',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty 1: Listen and watch`
  String get level1_show_words {
    return Intl.message(
      'Difficulty 1: Listen and watch',
      name: 'level1_show_words',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty 2: Hide the vocabulary on the left`
  String get level2_hide_leftpart_words {
    return Intl.message(
      'Difficulty 2: Hide the vocabulary on the left',
      name: 'level2_hide_leftpart_words',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty 3: Hide the vocabulary on the right`
  String get level3_hide_rightpart_words {
    return Intl.message(
      'Difficulty 3: Hide the vocabulary on the right',
      name: 'level3_hide_rightpart_words',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty 4: Hide all vocabulary`
  String get level4_hide_all_parts {
    return Intl.message(
      'Difficulty 4: Hide all vocabulary',
      name: 'level4_hide_all_parts',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty 5: silent writing`
  String get level5_write_words {
    return Intl.message(
      'Difficulty 5: silent writing',
      name: 'level5_write_words',
      desc: '',
      args: [],
    );
  }

  /// `Train`
  String get practice {
    return Intl.message(
      'Train',
      name: 'practice',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one prize`
  String get at_least_one_prize {
    return Intl.message(
      'Please select at least one prize',
      name: 'at_least_one_prize',
      desc: '',
      args: [],
    );
  }

  /// `lottery`
  String get select_lottery {
    return Intl.message(
      'lottery',
      name: 'select_lottery',
      desc: '',
      args: [],
    );
  }

  /// `select rewards`
  String get select_prize {
    return Intl.message(
      'select rewards',
      name: 'select_prize',
      desc: '',
      args: [],
    );
  }

  /// `manual input`
  String get input_manually {
    return Intl.message(
      'manual input',
      name: 'input_manually',
      desc: '',
      args: [],
    );
  }

  /// `{number} prizes`
  String number_present(Object number) {
    return Intl.message(
      '$number prizes',
      name: 'number_present',
      desc: '',
      args: [number],
    );
  }

  /// `consumable prizes`
  String get consump_present {
    return Intl.message(
      'consumable prizes',
      name: 'consump_present',
      desc: '',
      args: [],
    );
  }

  /// `Create present you like to reward yourself by coins`
  String get consump_present_description {
    return Intl.message(
      'Create present you like to reward yourself by coins',
      name: 'consump_present_description',
      desc: '',
      args: [],
    );
  }

  /// `To spend coins:`
  String get consump_money {
    return Intl.message(
      'To spend coins:',
      name: 'consump_money',
      desc: '',
      args: [],
    );
  }

  /// `How much coins does {present} cost`
  String present_value_dialog(Object present) {
    return Intl.message(
      'How much coins does $present cost',
      name: 'present_value_dialog',
      desc: '',
      args: [present],
    );
  }

  /// `create rewards`
  String get create_present {
    return Intl.message(
      'create rewards',
      name: 'create_present',
      desc: '',
      args: [],
    );
  }

  /// `lottery`
  String get lottery {
    return Intl.message(
      'lottery',
      name: 'lottery',
      desc: '',
      args: [],
    );
  }

  /// `life value:`
  String get num_lives {
    return Intl.message(
      'life value:',
      name: 'num_lives',
      desc: '',
      args: [],
    );
  }

  /// `Completeness:`
  String get finish_level {
    return Intl.message(
      'Completeness:',
      name: 'finish_level',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for timing`
  String get game_input_waiting {
    return Intl.message(
      'Waiting for timing',
      name: 'game_input_waiting',
      desc: '',
      args: [],
    );
  }

  /// `{duraiton} seconds to complete`
  String game1_time_usage(Object duraiton) {
    return Intl.message(
      '$duraiton seconds to complete',
      name: 'game1_time_usage',
      desc: '',
      args: [duraiton],
    );
  }

  /// `{correct} correct answers, {error} incorrect answers, accuracy rate {percent}`
  String game2_ranking_text(Object correct, Object error, Object percent) {
    return Intl.message(
      '$correct correct answers, $error incorrect answers, accuracy rate $percent',
      name: 'game2_ranking_text',
      desc: '',
      args: [correct, error, percent],
    );
  }

  /// `My current ranking is {ranking}`
  String my_ranking_this_time(Object ranking) {
    return Intl.message(
      'My current ranking is $ranking',
      name: 'my_ranking_this_time',
      desc: '',
      args: [ranking],
    );
  }

  /// `mine`
  String get my_answer {
    return Intl.message(
      'mine',
      name: 'my_answer',
      desc: '',
      args: [],
    );
  }

  /// `Answer`
  String get answer {
    return Intl.message(
      'Answer',
      name: 'answer',
      desc: '',
      args: [],
    );
  }

  /// `preparing`
  String get readying {
    return Intl.message(
      'preparing',
      name: 'readying',
      desc: '',
      args: [],
    );
  }

  /// `processing`
  String get ongoing {
    return Intl.message(
      'processing',
      name: 'ongoing',
      desc: '',
      args: [],
    );
  }

  /// `digital challenge`
  String get random_by_number {
    return Intl.message(
      'digital challenge',
      name: 'random_by_number',
      desc: '',
      args: [],
    );
  }

  /// `alphabet challenge`
  String get random_by_alphabet {
    return Intl.message(
      'alphabet challenge',
      name: 'random_by_alphabet',
      desc: '',
      args: [],
    );
  }

  /// `Alphabet challenge (case insensitive)`
  String get random_by_alphabet_lowercase_capital {
    return Intl.message(
      'Alphabet challenge (case insensitive)',
      name: 'random_by_alphabet_lowercase_capital',
      desc: '',
      args: [],
    );
  }

  /// `Alphabet and Number Challenge`
  String get random_by_alphabetAndNumber {
    return Intl.message(
      'Alphabet and Number Challenge',
      name: 'random_by_alphabetAndNumber',
      desc: '',
      args: [],
    );
  }

  /// `Alphabet (case insensitive) and number challenge`
  String get random_by_alphabetAndNumber_lowercase_capital {
    return Intl.message(
      'Alphabet (case insensitive) and number challenge',
      name: 'random_by_alphabetAndNumber_lowercase_capital',
      desc: '',
      args: [],
    );
  }

  /// `Purpose`
  String get objective {
    return Intl.message(
      'Purpose',
      name: 'objective',
      desc: '',
      args: [],
    );
  }

  /// `method`
  String get method {
    return Intl.message(
      'method',
      name: 'method',
      desc: '',
      args: [],
    );
  }

  /// `Setup failed`
  String get setting_fail {
    return Intl.message(
      'Setup failed',
      name: 'setting_fail',
      desc: '',
      args: [],
    );
  }

  /// `successfully set`
  String get setting_success {
    return Intl.message(
      'successfully set',
      name: 'setting_success',
      desc: '',
      args: [],
    );
  }

  /// `Username needs to be set`
  String get need_update_username {
    return Intl.message(
      'Username needs to be set',
      name: 'need_update_username',
      desc: '',
      args: [],
    );
  }

  /// `Complete time`
  String get finish_time {
    return Intl.message(
      'Complete time',
      name: 'finish_time',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get hour3 {
    return Intl.message(
      'Time',
      name: 'hour3',
      desc: '',
      args: [],
    );
  }

  /// `Minute`
  String get min3 {
    return Intl.message(
      'Minute',
      name: 'min3',
      desc: '',
      args: [],
    );
  }

  /// `Second`
  String get sec {
    return Intl.message(
      'Second',
      name: 'sec',
      desc: '',
      args: [],
    );
  }

  /// `ranking`
  String get ranking {
    return Intl.message(
      'ranking',
      name: 'ranking',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Focus on training camp`
  String get focus_campus {
    return Intl.message(
      'Focus on training camp',
      name: 'focus_campus',
      desc: '',
      args: [],
    );
  }

  /// `skip this version`
  String get jump_to_this_version {
    return Intl.message(
      'skip this version',
      name: 'jump_to_this_version',
      desc: '',
      args: [],
    );
  }

  /// `Downloading, please wait...`
  String get downloading_please_wait {
    return Intl.message(
      'Downloading, please wait...',
      name: 'downloading_please_wait',
      desc: '',
      args: [],
    );
  }

  /// `ready to download`
  String get ready_to_download {
    return Intl.message(
      'ready to download',
      name: 'ready_to_download',
      desc: '',
      args: [],
    );
  }

  /// `update immediately`
  String get update_now {
    return Intl.message(
      'update immediately',
      name: 'update_now',
      desc: '',
      args: [],
    );
  }

  /// `next time`
  String get next_time {
    return Intl.message(
      'next time',
      name: 'next_time',
      desc: '',
      args: [],
    );
  }

  /// `new version found`
  String get find_new_version {
    return Intl.message(
      'new version found',
      name: 'find_new_version',
      desc: '',
      args: [],
    );
  }

  /// `Add a task in "{title}", press "Enter" to save`
  String header_input_placeholder_with_title(Object title) {
    return Intl.message(
      'Add a task in "$title", press "Enter" to save',
      name: 'header_input_placeholder_with_title',
      desc: '',
      args: [title],
    );
  }

  /// `Task "{title}"`
  String mission_title(Object title) {
    return Intl.message(
      'Task "$title"',
      name: 'mission_title',
      desc: '',
      args: [title],
    );
  }

  /// `{missionFinished} finished, please start {missionToDo}, {missionToDo} duration: {duration}`
  String push_counter_status_notification(
      Object missionFinished, Object missionToDo, Object duration) {
    return Intl.message(
      '$missionFinished finished, please start $missionToDo, $missionToDo duration: $duration',
      name: 'push_counter_status_notification',
      desc: '',
      args: [missionFinished, missionToDo, duration],
    );
  }

  /// `(unnamed user)`
  String get unname_user {
    return Intl.message(
      '(unnamed user)',
      name: 'unname_user',
      desc: '',
      args: [],
    );
  }

  /// `ranking:{ranking}`
  String my_ranking(Object ranking) {
    return Intl.message(
      'ranking:$ranking',
      name: 'my_ranking',
      desc: '',
      args: [ranking],
    );
  }

  /// `focus duration`
  String get total_focus_time {
    return Intl.message(
      'focus duration',
      name: 'total_focus_time',
      desc: '',
      args: [],
    );
  }

  /// `MAC or PC cannot support this function temporarily, please use mobile phone to operate`
  String get pc_not_available {
    return Intl.message(
      'MAC or PC cannot support this function temporarily, please use mobile phone to operate',
      name: 'pc_not_available',
      desc: '',
      args: [],
    );
  }

  /// `add tag`
  String get add_tag {
    return Intl.message(
      'add tag',
      name: 'add_tag',
      desc: '',
      args: [],
    );
  }

  /// `Tag`
  String get tag {
    return Intl.message(
      'Tag',
      name: 'tag',
      desc: '',
      args: [],
    );
  }

  /// `Consumption failed`
  String get consume_failure {
    return Intl.message(
      'Consumption failed',
      name: 'consume_failure',
      desc: '',
      args: [],
    );
  }

  /// `successful consumption`
  String get consume_success {
    return Intl.message(
      'successful consumption',
      name: 'consume_success',
      desc: '',
      args: [],
    );
  }

  /// `Not enough money, please complete more focused tasks to make money`
  String get money_not_enough_toast {
    return Intl.message(
      'Not enough money, please complete more focused tasks to make money',
      name: 'money_not_enough_toast',
      desc: '',
      args: [],
    );
  }

  /// `Amount of consumption`
  String get title_consume {
    return Intl.message(
      'Amount of consumption',
      name: 'title_consume',
      desc: '',
      args: [],
    );
  }

  /// `consumption description`
  String get desc_consume {
    return Intl.message(
      'consumption description',
      name: 'desc_consume',
      desc: '',
      args: [],
    );
  }

  /// `SPEND`
  String get i_consume {
    return Intl.message(
      'SPEND',
      name: 'i_consume',
      desc: '',
      args: [],
    );
  }

  /// `Gain per minute of focus`
  String get localmoney_made_per_minute {
    return Intl.message(
      'Gain per minute of focus',
      name: 'localmoney_made_per_minute',
      desc: '',
      args: [],
    );
  }

  /// `for self motivation`
  String get localmoney_made_per_minute_description {
    return Intl.message(
      'for self motivation',
      name: 'localmoney_made_per_minute_description',
      desc: '',
      args: [],
    );
  }

  /// `currency`
  String get rmb {
    return Intl.message(
      'currency',
      name: 'rmb',
      desc: '',
      args: [],
    );
  }

  /// `RMB`
  String get yuan {
    return Intl.message(
      'RMB',
      name: 'yuan',
      desc: '',
      args: [],
    );
  }

  /// `Starting time`
  String get curTimeF {
    return Intl.message(
      'Starting time',
      name: 'curTimeF',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get custom {
    return Intl.message(
      'Custom',
      name: 'custom',
      desc: '',
      args: [],
    );
  }

  /// `unlimited`
  String get no_time_limit {
    return Intl.message(
      'unlimited',
      name: 'no_time_limit',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get min_en {
    return Intl.message(
      'min',
      name: 'min_en',
      desc: '',
      args: [],
    );
  }

  /// `Focus Duration`
  String get focus_duration {
    return Intl.message(
      'Focus Duration',
      name: 'focus_duration',
      desc: '',
      args: [],
    );
  }

  /// `Rest time`
  String get rest_duration {
    return Intl.message(
      'Rest time',
      name: 'rest_duration',
      desc: '',
      args: [],
    );
  }

  /// `rest`
  String get rest {
    return Intl.message(
      'rest',
      name: 'rest',
      desc: '',
      args: [],
    );
  }

  /// `concentrate on`
  String get focus {
    return Intl.message(
      'concentrate on',
      name: 'focus',
      desc: '',
      args: [],
    );
  }

  /// `Music`
  String get music {
    return Intl.message(
      'Music',
      name: 'music',
      desc: '',
      args: [],
    );
  }

  /// `Volume`
  String get volume {
    return Intl.message(
      'Volume',
      name: 'volume',
      desc: '',
      args: [],
    );
  }

  /// `{month}, {year}`
  String missionModelDate3(Object month, Object year) {
    return Intl.message(
      '$month, $year',
      name: 'missionModelDate3',
      desc: '',
      args: [month, year],
    );
  }

  /// `{month}/{day}/{year}`
  String missionModelDate2(Object month, Object day, Object year) {
    return Intl.message(
      '$month/$day/$year',
      name: 'missionModelDate2',
      desc: '',
      args: [month, day, year],
    );
  }

  /// `{year}/{month}/{day},{weekday}`
  String missionModelDate(
      Object year, Object month, Object day, Object weekday) {
    return Intl.message(
      '$year/$month/$day,$weekday',
      name: 'missionModelDate',
      desc: '',
      args: [year, month, day, weekday],
    );
  }

  /// `{year}-{month}-{day} {hour}:{min},{weekday}`
  String missionModelDate4(Object year, Object month, Object day, Object hour,
      Object min, Object weekday) {
    return Intl.message(
      '$year-$month-$day $hour:$min,$weekday',
      name: 'missionModelDate4',
      desc: '',
      args: [year, month, day, hour, min, weekday],
    );
  }

  /// `Uncategorized list`
  String get unorder_folderlist {
    return Intl.message(
      'Uncategorized list',
      name: 'unorder_folderlist',
      desc: '',
      args: [],
    );
  }

  /// `Sort by list`
  String get order_by_list {
    return Intl.message(
      'Sort by list',
      name: 'order_by_list',
      desc: '',
      args: [],
    );
  }

  /// `Sort by end time`
  String get order_by_end_time {
    return Intl.message(
      'Sort by end time',
      name: 'order_by_end_time',
      desc: '',
      args: [],
    );
  }

  /// `Sort by time`
  String get order_by_time {
    return Intl.message(
      'Sort by time',
      name: 'order_by_time',
      desc: '',
      args: [],
    );
  }

  /// `Sort by created time`
  String get order_by_created_time {
    return Intl.message(
      'Sort by created time',
      name: 'order_by_created_time',
      desc: '',
      args: [],
    );
  }

  /// `Task`
  String get task {
    return Intl.message(
      'Task',
      name: 'task',
      desc: '',
      args: [],
    );
  }

  /// `Sort by task priority`
  String get order_by_mission_priority {
    return Intl.message(
      'Sort by task priority',
      name: 'order_by_mission_priority',
      desc: '',
      args: [],
    );
  }

  /// `focus end ringtone`
  String get focus_finished_ringtone {
    return Intl.message(
      'focus end ringtone',
      name: 'focus_finished_ringtone',
      desc: '',
      args: [],
    );
  }

  /// `end of break bell`
  String get resting_stopping_ringtone {
    return Intl.message(
      'end of break bell',
      name: 'resting_stopping_ringtone',
      desc: '',
      args: [],
    );
  }

  /// `Focus on music`
  String get focusing_music {
    return Intl.message(
      'Focus on music',
      name: 'focusing_music',
      desc: '',
      args: [],
    );
  }

  /// `music during break`
  String get resting_music {
    return Intl.message(
      'music during break',
      name: 'resting_music',
      desc: '',
      args: [],
    );
  }

  /// `select sound`
  String get select_ringtone {
    return Intl.message(
      'select sound',
      name: 'select_ringtone',
      desc: '',
      args: [],
    );
  }

  /// `not started`
  String get waitingToStart {
    return Intl.message(
      'not started',
      name: 'waitingToStart',
      desc: '',
      args: [],
    );
  }

  /// `stop`
  String get stop {
    return Intl.message(
      'stop',
      name: 'stop',
      desc: '',
      args: [],
    );
  }

  /// `add username`
  String get add_username {
    return Intl.message(
      'add username',
      name: 'add_username',
      desc: '',
      args: [],
    );
  }

  /// `The input box cannot be empty`
  String get can_not_be_empty {
    return Intl.message(
      'The input box cannot be empty',
      name: 'can_not_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Please select an avatar`
  String get select_avatar {
    return Intl.message(
      'Please select an avatar',
      name: 'select_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Please select an avatar`
  String get avatar {
    return Intl.message(
      'Please select an avatar',
      name: 'avatar',
      desc: '',
      args: [],
    );
  }

  /// `User does not exist`
  String get code_user_not_exist {
    return Intl.message(
      'User does not exist',
      name: 'code_user_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `Account or password is incorrect`
  String get code_user_password_not_correct {
    return Intl.message(
      'Account or password is incorrect',
      name: 'code_user_password_not_correct',
      desc: '',
      args: [],
    );
  }

  /// `login successful`
  String get login_success {
    return Intl.message(
      'login successful',
      name: 'login_success',
      desc: '',
      args: [],
    );
  }

  /// `The number of tasks completed today`
  String get today_mission_completed {
    return Intl.message(
      'The number of tasks completed today',
      name: 'today_mission_completed',
      desc: '',
      args: [],
    );
  }

  /// `Number of tasks completed this week`
  String get week_mission_completed {
    return Intl.message(
      'Number of tasks completed this week',
      name: 'week_mission_completed',
      desc: '',
      args: [],
    );
  }

  /// `Number of tasks completed this month`
  String get month_mission_completed {
    return Intl.message(
      'Number of tasks completed this month',
      name: 'month_mission_completed',
      desc: '',
      args: [],
    );
  }

  /// `Number of tasks completed this year`
  String get year_mission_completed {
    return Intl.message(
      'Number of tasks completed this year',
      name: 'year_mission_completed',
      desc: '',
      args: [],
    );
  }

  /// `Duration today (minutes)`
  String get today_duration_completed {
    return Intl.message(
      'Duration today (minutes)',
      name: 'today_duration_completed',
      desc: '',
      args: [],
    );
  }

  /// `Duration this week (minutes)`
  String get week_duration_completed {
    return Intl.message(
      'Duration this week (minutes)',
      name: 'week_duration_completed',
      desc: '',
      args: [],
    );
  }

  /// `Duration this month (minutes)`
  String get month_duration_completed {
    return Intl.message(
      'Duration this month (minutes)',
      name: 'month_duration_completed',
      desc: '',
      args: [],
    );
  }

  /// `Duration this year (minutes)`
  String get year_duration_completed {
    return Intl.message(
      'Duration this year (minutes)',
      name: 'year_duration_completed',
      desc: '',
      args: [],
    );
  }

  /// `Complete the tomato count today`
  String get today_tomatoes_completed {
    return Intl.message(
      'Complete the tomato count today',
      name: 'today_tomatoes_completed',
      desc: '',
      args: [],
    );
  }

  /// `Completed Pomodoros this week`
  String get week_tomatoes_completed {
    return Intl.message(
      'Completed Pomodoros this week',
      name: 'week_tomatoes_completed',
      desc: '',
      args: [],
    );
  }

  /// `The number of tomatoes completed this month`
  String get month_tomatoes_completed {
    return Intl.message(
      'The number of tomatoes completed this month',
      name: 'month_tomatoes_completed',
      desc: '',
      args: [],
    );
  }

  /// `The number of tomatoes completed this year`
  String get year_tomatoes_completed {
    return Intl.message(
      'The number of tomatoes completed this year',
      name: 'year_tomatoes_completed',
      desc: '',
      args: [],
    );
  }

  /// `Project Statistics`
  String get projectStatistic {
    return Intl.message(
      'Project Statistics',
      name: 'projectStatistic',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get byday {
    return Intl.message(
      'Day',
      name: 'byday',
      desc: '',
      args: [],
    );
  }

  /// `this week`
  String get thisweek {
    return Intl.message(
      'this week',
      name: 'thisweek',
      desc: '',
      args: [],
    );
  }

  /// `Number Of Tasks`
  String get missionNums {
    return Intl.message(
      'Number Of Tasks',
      name: 'missionNums',
      desc: '',
      args: [],
    );
  }

  /// `Total time to complete (minutes)`
  String get wholeComepleteTime {
    return Intl.message(
      'Total time to complete (minutes)',
      name: 'wholeComepleteTime',
      desc: '',
      args: [],
    );
  }

  /// `analyze`
  String get analytics {
    return Intl.message(
      'analyze',
      name: 'analytics',
      desc: '',
      args: [],
    );
  }

  /// `notes...(optional)`
  String get note {
    return Intl.message(
      'notes...(optional)',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Add task... (press "Enter" to save)`
  String get missionPageInputHolder {
    return Intl.message(
      'Add task... (press "Enter" to save)',
      name: 'missionPageInputHolder',
      desc: '',
      args: [],
    );
  }

  /// `update`
  String get update {
    return Intl.message(
      'update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `update completed`
  String get updateSuccess {
    return Intl.message(
      'update completed',
      name: 'updateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `created successfully`
  String get createSuccess {
    return Intl.message(
      'created successfully',
      name: 'createSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Total duration (minutes)`
  String get totalTimeMinute {
    return Intl.message(
      'Total duration (minutes)',
      name: 'totalTimeMinute',
      desc: '',
      args: [],
    );
  }

  /// `Focus Duration`
  String get totalTime {
    return Intl.message(
      'Focus Duration',
      name: 'totalTime',
      desc: '',
      args: [],
    );
  }

  /// `Mine`
  String get mine {
    return Intl.message(
      'Mine',
      name: 'mine',
      desc: '',
      args: [],
    );
  }

  /// `Charts`
  String get curAnalytics {
    return Intl.message(
      'Charts',
      name: 'curAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Pomodoro`
  String get tomatoClock {
    return Intl.message(
      'Pomodoro',
      name: 'tomatoClock',
      desc: '',
      args: [],
    );
  }

  /// `{title}(remaining time:{min}:{secs}）`
  String notificationTxt(Object title, Object min, Object secs) {
    return Intl.message(
      '$title(remaining time:$min:$secs）',
      name: 'notificationTxt',
      desc: '',
      args: [title, min, secs],
    );
  }

  /// `Pause`
  String get restPausing {
    return Intl.message(
      'Pause',
      name: 'restPausing',
      desc: '',
      args: [],
    );
  }

  /// `break complete`
  String get restingFinished {
    return Intl.message(
      'break complete',
      name: 'restingFinished',
      desc: '',
      args: [],
    );
  }

  /// `resting`
  String get resting {
    return Intl.message(
      'resting',
      name: 'resting',
      desc: '',
      args: [],
    );
  }

  /// `focus on pause`
  String get focusPausing {
    return Intl.message(
      'focus on pause',
      name: 'focusPausing',
      desc: '',
      args: [],
    );
  }

  /// `focus on completion`
  String get focusFinished {
    return Intl.message(
      'focus on completion',
      name: 'focusFinished',
      desc: '',
      args: [],
    );
  }

  /// `pause`
  String get pause {
    return Intl.message(
      'pause',
      name: 'pause',
      desc: '',
      args: [],
    );
  }

  /// `start to rest`
  String get startResting {
    return Intl.message(
      'start to rest',
      name: 'startResting',
      desc: '',
      args: [],
    );
  }

  /// `start to focus`
  String get startFocusing {
    return Intl.message(
      'start to focus',
      name: 'startFocusing',
      desc: '',
      args: [],
    );
  }

  /// `continue`
  String get continueTxt {
    return Intl.message(
      'continue',
      name: 'continueTxt',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message(
      'Finish',
      name: 'finish',
      desc: '',
      args: [],
    );
  }

  /// `Unfinished`
  String get unfinished {
    return Intl.message(
      'Unfinished',
      name: 'unfinished',
      desc: '',
      args: [],
    );
  }

  /// `SMS verification code`
  String get smsVerificationCode {
    return Intl.message(
      'SMS verification code',
      name: 'smsVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Please input sms dynamic code`
  String get inputSmsVerificationCode {
    return Intl.message(
      'Please input sms dynamic code',
      name: 'inputSmsVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Click for authentication code`
  String get getVerificationCode {
    return Intl.message(
      'Click for authentication code',
      name: 'getVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Next step`
  String get nextStep {
    return Intl.message(
      'Next step',
      name: 'nextStep',
      desc: '',
      args: [],
    );
  }

  /// `register`
  String get register {
    return Intl.message(
      'register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `password can not be blank`
  String get passwordNotEmpty {
    return Intl.message(
      'password can not be blank',
      name: 'passwordNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get password {
    return Intl.message(
      'password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `E-mail can not be empty`
  String get emailCannotBeNull {
    return Intl.message(
      'E-mail can not be empty',
      name: 'emailCannotBeNull',
      desc: '',
      args: [],
    );
  }

  /// `phone number`
  String get phoneNo {
    return Intl.message(
      'phone number',
      name: 'phoneNo',
      desc: '',
      args: [],
    );
  }

  /// `welcome`
  String get welcome {
    return Intl.message(
      'welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `account`
  String get account {
    return Intl.message(
      'account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `about`
  String get about {
    return Intl.message(
      'about',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `please log in first`
  String get loginFirst {
    return Intl.message(
      'please log in first',
      name: 'loginFirst',
      desc: '',
      args: [],
    );
  }

  /// `Login invalid, please log in again`
  String get tokenExpired {
    return Intl.message(
      'Login invalid, please log in again',
      name: 'tokenExpired',
      desc: '',
      args: [],
    );
  }

  /// `Accounts will be automatically created for new users`
  String get loginContent {
    return Intl.message(
      'Accounts will be automatically created for new users',
      name: 'loginContent',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your mobile phone number to complete the registration, and you can enjoy an efficient life`
  String get registerStep1 {
    return Intl.message(
      'Please enter your mobile phone number to complete the registration, and you can enjoy an efficient life',
      name: 'registerStep1',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your mobile phone number to complete the registration, and you can enjoy an efficient life`
  String get registerStep2 {
    return Intl.message(
      'Please enter your mobile phone number to complete the registration, and you can enjoy an efficient life',
      name: 'registerStep2',
      desc: '',
      args: [],
    );
  }

  /// `username`
  String get username {
    return Intl.message(
      'username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `please choose a color`
  String get pleaseSelectColor {
    return Intl.message(
      'please choose a color',
      name: 'pleaseSelectColor',
      desc: '',
      args: [],
    );
  }

  /// `{month}/{day},{weekday}`
  String monthDay(Object month, Object day, Object weekday) {
    return Intl.message(
      '$month/$day,$weekday',
      name: 'monthDay',
      desc: '',
      args: [month, day, weekday],
    );
  }

  /// `Mon`
  String get mondayShort {
    return Intl.message(
      'Mon',
      name: 'mondayShort',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get tuesdayShort {
    return Intl.message(
      'Tue',
      name: 'tuesdayShort',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get wednesdayShort {
    return Intl.message(
      'Wed',
      name: 'wednesdayShort',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get thursdayShort {
    return Intl.message(
      'Thu',
      name: 'thursdayShort',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get fridayShort {
    return Intl.message(
      'Fri',
      name: 'fridayShort',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get saturdayShort {
    return Intl.message(
      'Sat',
      name: 'saturdayShort',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get sundayShort {
    return Intl.message(
      'Sun',
      name: 'sundayShort',
      desc: '',
      args: [],
    );
  }

  /// `Create List`
  String get createMission {
    return Intl.message(
      'Create List',
      name: 'createMission',
      desc: '',
      args: [],
    );
  }

  /// `List`
  String get mission {
    return Intl.message(
      'List',
      name: 'mission',
      desc: '',
      args: [],
    );
  }

  /// `months later`
  String get monthsLater {
    return Intl.message(
      'months later',
      name: 'monthsLater',
      desc: '',
      args: [],
    );
  }

  /// `diva`
  String get daysLater {
    return Intl.message(
      'diva',
      name: 'daysLater',
      desc: '',
      args: [],
    );
  }

  /// ` of `
  String get de {
    return Intl.message(
      ' of ',
      name: 'de',
      desc: '',
      args: [],
    );
  }

  /// `Every`
  String get eachSpace {
    return Intl.message(
      'Every',
      name: 'eachSpace',
      desc: '',
      args: [],
    );
  }

  /// `Pomodoro Duration`
  String get tomatoesDuration {
    return Intl.message(
      'Pomodoro Duration',
      name: 'tomatoesDuration',
      desc: '',
      args: [],
    );
  }

  /// `Estimated number of tomatoes`
  String get previewTomatoesNum {
    return Intl.message(
      'Estimated number of tomatoes',
      name: 'previewTomatoesNum',
      desc: '',
      args: [],
    );
  }

  /// `7 days later`
  String get inSevenDays {
    return Intl.message(
      '7 days later',
      name: 'inSevenDays',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Pomodoros: {numTotatoes} x {duration} minutes = {time} hours {minute} minutes`
  String calculateTomatoesTime(
      Object numTotatoes, Object duration, Object time, Object minute) {
    return Intl.message(
      'Estimated Pomodoros: $numTotatoes x $duration minutes = $time hours $minute minutes',
      name: 'calculateTomatoesTime',
      desc: '',
      args: [numTotatoes, duration, time, minute],
    );
  }

  /// `The {missionTitle} mission is in progress, are you sure to stop?`
  String missionRunningAlert(Object missionTitle) {
    return Intl.message(
      'The $missionTitle mission is in progress, are you sure to stop?',
      name: 'missionRunningAlert',
      desc: '',
      args: [missionTitle],
    );
  }

  /// `day`
  String get day {
    return Intl.message(
      'day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get week {
    return Intl.message(
      'Week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message(
      'Month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Every`
  String get each {
    return Intl.message(
      'Every',
      name: 'each',
      desc: '',
      args: [],
    );
  }

  /// `create tags`
  String get createTag {
    return Intl.message(
      'create tags',
      name: 'createTag',
      desc: '',
      args: [],
    );
  }

  /// `repeat`
  String get repeat {
    return Intl.message(
      'repeat',
      name: 'repeat',
      desc: '',
      args: [],
    );
  }

  /// `return`
  String get back {
    return Intl.message(
      'return',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `hint`
  String get remind {
    return Intl.message(
      'hint',
      name: 'remind',
      desc: '',
      args: [],
    );
  }

  /// `sign out`
  String get logout {
    return Intl.message(
      'sign out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `already logged in`
  String get hasLogined {
    return Intl.message(
      'already logged in',
      name: 'hasLogined',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get login {
    return Intl.message(
      'Log in',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Tomatoes`
  String get unitTomatoes {
    return Intl.message(
      'Tomatoes',
      name: 'unitTomatoes',
      desc: '',
      args: [],
    );
  }

  /// `Tasks`
  String get unitMissions {
    return Intl.message(
      'Tasks',
      name: 'unitMissions',
      desc: '',
      args: [],
    );
  }

  /// `Next task:`
  String get nextMission {
    return Intl.message(
      'Next task:',
      name: 'nextMission',
      desc: '',
      args: [],
    );
  }

  /// `Default focus time`
  String get defaultFocusDuration {
    return Intl.message(
      'Default focus time',
      name: 'defaultFocusDuration',
      desc: '',
      args: [],
    );
  }

  /// `Choose theme color`
  String get selectThemeColor {
    return Intl.message(
      'Choose theme color',
      name: 'selectThemeColor',
      desc: '',
      args: [],
    );
  }

  /// `After selecting the theme color, restart the app to change the theme color ^^`
  String get selectThemeColorDesc {
    return Intl.message(
      'After selecting the theme color, restart the app to change the theme color ^^',
      name: 'selectThemeColorDesc',
      desc: '',
      args: [],
    );
  }

  /// `Theme color panel matching`
  String get appThmeSetting {
    return Intl.message(
      'Theme color panel matching',
      name: 'appThmeSetting',
      desc: '',
      args: [],
    );
  }

  /// `pomodoro setting`
  String get tomatoClockSetting {
    return Intl.message(
      'pomodoro setting',
      name: 'tomatoClockSetting',
      desc: '',
      args: [],
    );
  }

  /// `Reminder ringtone`
  String get tipsAlertTone {
    return Intl.message(
      'Reminder ringtone',
      name: 'tipsAlertTone',
      desc: '',
      args: [],
    );
  }

  /// `Current ringtone: {tone}`
  String currentRingTone(Object tone) {
    return Intl.message(
      'Current ringtone: $tone',
      name: 'currentRingTone',
      desc: '',
      args: [tone],
    );
  }

  /// `default break time`
  String get confirmRestDuration {
    return Intl.message(
      'default break time',
      name: 'confirmRestDuration',
      desc: '',
      args: [],
    );
  }

  /// `{month}/{day},{hour}:{mins}`
  String dateFromMonthToMins(
      Object month, Object day, Object hour, Object mins) {
    return Intl.message(
      '$month/$day,$hour:$mins',
      name: 'dateFromMonthToMins',
      desc: '',
      args: [month, day, hour, mins],
    );
  }

  /// `Wed`
  String get wednesday {
    return Intl.message(
      'Wed',
      name: 'wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get thursday {
    return Intl.message(
      'Thu',
      name: 'thursday',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get friday {
    return Intl.message(
      'Fri',
      name: 'friday',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get saturday {
    return Intl.message(
      'Sat',
      name: 'saturday',
      desc: '',
      args: [],
    );
  }

  /// `sun`
  String get sunday {
    return Intl.message(
      'sun',
      name: 'sunday',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get tuesday {
    return Intl.message(
      'Tue',
      name: 'tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get monday {
    return Intl.message(
      'Mon',
      name: 'monday',
      desc: '',
      args: [],
    );
  }

  /// `{month}/{day}`
  String dateFromMonth(Object month, Object day) {
    return Intl.message(
      '$month/$day',
      name: 'dateFromMonth',
      desc: '',
      args: [month, day],
    );
  }

  /// `{hour} hour {min} mins`
  String hourAndMin(Object hour, Object min) {
    return Intl.message(
      '$hour hour $min mins',
      name: 'hourAndMin',
      desc: '',
      args: [hour, min],
    );
  }

  /// `{min} min {sec} sec`
  String minAndSec(Object min, Object sec) {
    return Intl.message(
      '$min min $sec sec',
      name: 'minAndSec',
      desc: '',
      args: [min, sec],
    );
  }

  /// `{hour} hour {min} min {sec} sec`
  String hourAndMinAndSec(Object hour, Object min, Object sec) {
    return Intl.message(
      '$hour hour $min min $sec sec',
      name: 'hourAndMinAndSec',
      desc: '',
      args: [hour, min, sec],
    );
  }

  /// `next week`
  String get nextWeek {
    return Intl.message(
      'next week',
      name: 'nextWeek',
      desc: '',
      args: [],
    );
  }

  /// `last week`
  String get lastWeek {
    return Intl.message(
      'last week',
      name: 'lastWeek',
      desc: '',
      args: [],
    );
  }

  /// `this week`
  String get thisWeek {
    return Intl.message(
      'this week',
      name: 'thisWeek',
      desc: '',
      args: [],
    );
  }

  /// `Hour`
  String get hour {
    return Intl.message(
      'Hour',
      name: 'hour',
      desc: '',
      args: [],
    );
  }

  /// `Min`
  String get mins2 {
    return Intl.message(
      'Min',
      name: 'mins2',
      desc: '',
      args: [],
    );
  }

  /// `The date you selected is out of range`
  String get dateOutOfLimit {
    return Intl.message(
      'The date you selected is out of range',
      name: 'dateOutOfLimit',
      desc: '',
      args: [],
    );
  }

  /// ` mins`
  String get minsSpace {
    return Intl.message(
      ' mins',
      name: 'minsSpace',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you have completed this task?`
  String get confirmToFinishMission {
    return Intl.message(
      'Are you sure you have completed this task?',
      name: 'confirmToFinishMission',
      desc: '',
      args: [],
    );
  }

  /// `Repeat`
  String get repetive {
    return Intl.message(
      'Repeat',
      name: 'repetive',
      desc: '',
      args: [],
    );
  }

  /// `Remind`
  String get alert {
    return Intl.message(
      'Remind',
      name: 'alert',
      desc: '',
      args: [],
    );
  }

  /// `Expiry date`
  String get deadLine {
    return Intl.message(
      'Expiry date',
      name: 'deadLine',
      desc: '',
      args: [],
    );
  }

  /// `Focus Times`
  String get tomatoNums2 {
    return Intl.message(
      'Focus Times',
      name: 'tomatoNums2',
      desc: '',
      args: [],
    );
  }

  /// `Focus Times`
  String get tomatoNums {
    return Intl.message(
      'Focus Times',
      name: 'tomatoNums',
      desc: '',
      args: [],
    );
  }

  /// `(Tomato Count)`
  String get tomatoNums3 {
    return Intl.message(
      '(Tomato Count)',
      name: 'tomatoNums3',
      desc: '',
      args: [],
    );
  }

  /// `tomato`
  String get tomato {
    return Intl.message(
      'tomato',
      name: 'tomato',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get complete {
    return Intl.message(
      'Finish',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `imp. & urg.`
  String get priority1 {
    return Intl.message(
      'imp. & urg.',
      name: 'priority1',
      desc: '',
      args: [],
    );
  }

  /// `not imp. & urg.`
  String get priority2 {
    return Intl.message(
      'not imp. & urg.',
      name: 'priority2',
      desc: '',
      args: [],
    );
  }

  /// `imp. & not urg.`
  String get priority3 {
    return Intl.message(
      'imp. & not urg.',
      name: 'priority3',
      desc: '',
      args: [],
    );
  }

  /// `not imp. & not urg.`
  String get priority4 {
    return Intl.message(
      'not imp. & not urg.',
      name: 'priority4',
      desc: '',
      args: [],
    );
  }

  /// `Added successfully`
  String get addsuccess {
    return Intl.message(
      'Added successfully',
      name: 'addsuccess',
      desc: '',
      args: [],
    );
  }

  /// `priority`
  String get priority {
    return Intl.message(
      'priority',
      name: 'priority',
      desc: '',
      args: [],
    );
  }

  /// `confirm complete`
  String get confirmToFinished {
    return Intl.message(
      'confirm complete',
      name: 'confirmToFinished',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you have completed this task?`
  String get confirmToFinishedContent {
    return Intl.message(
      'Are you sure you have completed this task?',
      name: 'confirmToFinishedContent',
      desc: '',
      args: [],
    );
  }

  /// `pick list`
  String get selectMission {
    return Intl.message(
      'pick list',
      name: 'selectMission',
      desc: '',
      args: [],
    );
  }

  /// `select tab`
  String get selectTag {
    return Intl.message(
      'select tab',
      name: 'selectTag',
      desc: '',
      args: [],
    );
  }

  /// `The number of tomatoes cannot be 0`
  String get alertMessage1 {
    return Intl.message(
      'The number of tomatoes cannot be 0',
      name: 'alertMessage1',
      desc: '',
      args: [],
    );
  }

  /// `The title can not be blank`
  String get alertMessage2 {
    return Intl.message(
      'The title can not be blank',
      name: 'alertMessage2',
      desc: '',
      args: [],
    );
  }

  /// `mission accomplished`
  String get missionCompleted {
    return Intl.message(
      'mission accomplished',
      name: 'missionCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Add task...`
  String get addMissions2 {
    return Intl.message(
      'Add task...',
      name: 'addMissions2',
      desc: '',
      args: [],
    );
  }

  /// `Minute`
  String get mins {
    return Intl.message(
      'Minute',
      name: 'mins',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Time`
  String get previewTime {
    return Intl.message(
      'Estimated Time',
      name: 'previewTime',
      desc: '',
      args: [],
    );
  }

  /// `Unfinished Tasks`
  String get missionToBeComplete {
    return Intl.message(
      'Unfinished Tasks',
      name: 'missionToBeComplete',
      desc: '',
      args: [],
    );
  }

  /// `Focus Duration`
  String get timefocused {
    return Intl.message(
      'Focus Duration',
      name: 'timefocused',
      desc: '',
      args: [],
    );
  }

  /// `Finished Tasks`
  String get missioncompleted {
    return Intl.message(
      'Finished Tasks',
      name: 'missioncompleted',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete?\nNote: Deleted tasks cannot be recovered`
  String get confirmToDelete {
    return Intl.message(
      'Are you sure to delete?\nNote: Deleted tasks cannot be recovered',
      name: 'confirmToDelete',
      desc: '',
      args: [],
    );
  }

  /// `Tomorrow`
  String get tomorrow {
    return Intl.message(
      'Tomorrow',
      name: 'tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `Latest 7 days`
  String get comingSoon {
    return Intl.message(
      'Latest 7 days',
      name: 'comingSoon',
      desc: '',
      args: [],
    );
  }

  /// `to be determined`
  String get bePening {
    return Intl.message(
      'to be determined',
      name: 'bePening',
      desc: '',
      args: [],
    );
  }

  /// `All Unfinished Tasks`
  String get allUnfinishedMissions {
    return Intl.message(
      'All Unfinished Tasks',
      name: 'allUnfinishedMissions',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get schedule {
    return Intl.message(
      'Calendar',
      name: 'schedule',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message(
      'Calendar',
      name: 'calendar',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar2 {
    return Intl.message(
      'Calendar',
      name: 'calendar2',
      desc: '',
      args: [],
    );
  }

  /// `The dynamic code is incorrect`
  String get code_dynamic_code_incorrect {
    return Intl.message(
      'The dynamic code is incorrect',
      name: 'code_dynamic_code_incorrect',
      desc: '',
      args: [],
    );
  }

  /// `User already exists`
  String get code_user_exist {
    return Intl.message(
      'User already exists',
      name: 'code_user_exist',
      desc: '',
      args: [],
    );
  }

  /// `User Privacy Agreement`
  String get user_privacy_protocol_title {
    return Intl.message(
      'User Privacy Agreement',
      name: 'user_privacy_protocol_title',
      desc: '',
      args: [],
    );
  }

  /// `reject`
  String get refuse {
    return Intl.message(
      'reject',
      name: 'refuse',
      desc: '',
      args: [],
    );
  }

  /// `agree`
  String get agree {
    return Intl.message(
      'agree',
      name: 'agree',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Agreement`
  String get privacy_protocol_title {
    return Intl.message(
      'Privacy Agreement',
      name: 'privacy_protocol_title',
      desc: '',
      args: [],
    );
  }

  /// `Kind tips`
  String get gently_remind {
    return Intl.message(
      'Kind tips',
      name: 'gently_remind',
      desc: '',
      args: [],
    );
  }

  /// `Push Settings`
  String get notification_setting {
    return Intl.message(
      'Push Settings',
      name: 'notification_setting',
      desc: '',
      args: [],
    );
  }

  /// `Turning on notifications will help you know when tasks are completed or started`
  String get notification_setting_content {
    return Intl.message(
      'Turning on notifications will help you know when tasks are completed or started',
      name: 'notification_setting_content',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for trusting and using this product. We attach great importance to your privacy protection and personal information protection,\n\nPlease read all the terms of the "Privacy Policy" carefully. Learn about what we do to protect your information\nSpecific measures and commitments, agree and accept all the terms before starting to use our services.\nWe will collect it in business scenarios such as account registration. In the process of using this product step by step, you will need to enable corresponding device permissions according to different business scenarios, such as location information, camera permissions, etc.`
  String get privacy_protocol_content {
    return Intl.message(
      'Thank you for trusting and using this product. We attach great importance to your privacy protection and personal information protection,\\n\\nPlease read all the terms of the "Privacy Policy" carefully. Learn about what we do to protect your information\\nSpecific measures and commitments, agree and accept all the terms before starting to use our services.\\nWe will collect it in business scenarios such as account registration. In the process of using this product step by step, you will need to enable corresponding device permissions according to different business scenarios, such as location information, camera permissions, etc.',
      name: 'privacy_protocol_content',
      desc: '',
      args: [],
    );
  }

  /// `We attach great importance to your privacy protection and personal information protection, and will adopt leading security measures to protect your information security. If you continue to use our services, you agree to collect, use and protect your personal information in accordance with the "Privacy Policy". If you do not agree to the above content, you can choose to stop using it.`
  String get privacy_protocol_content2 {
    return Intl.message(
      'We attach great importance to your privacy protection and personal information protection, and will adopt leading security measures to protect your information security. If you continue to use our services, you agree to collect, use and protect your personal information in accordance with the "Privacy Policy". If you do not agree to the above content, you can choose to stop using it.',
      name: 'privacy_protocol_content2',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'HK'),
      Locale.fromSubtags(
          languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
