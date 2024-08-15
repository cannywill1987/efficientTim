import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * CheckButtonStateModel
 * pc端右上角日历button
 */
class AppFlowyCheckButtonStateModel {
  String? code;
  String? title;
  String? content;
  dynamic? value;
  int? color;
  bool isCheck = false;
  Widget? checkIcon;
  Widget? uncheckIcon;
  String? checkIconUrl;
  String? uncheckIconUrl;
  AppFlowyCheckButtonStateModel({this.code, this.value, this.title, this.content, this.isCheck = false, this.color, this.checkIconUrl, this.uncheckIconUrl, this.checkIcon, this.uncheckIcon});

  static List<AppFlowyCheckButtonStateModel> getAIMoreListPrompts() {
    List<AppFlowyCheckButtonStateModel> list = [];
    return list;
  }

  static List<AppFlowyCheckButtonStateModel> getAIListPrompts() {
    List<AppFlowyCheckButtonStateModel> list = [];
    const double size = 20;
    const Color activeColor = Colors.purple;
    const Color inactiveColor = Colors.grey;

    return [
      AppFlowyCheckButtonStateModel(
        code: 'modern_poetry',
        checkIcon: Icon(Icons.bookmark, size: size, color: activeColor),
        uncheckIcon: Icon(Icons.bookmark, size: size, color: inactiveColor),
        title: i18nInstanceLocal.modern_poetry,
        content: i18nInstanceLocal.modern_poetry_placeholder,
        value: i18nInstanceLocal.modern_poetry_prompt,
        isCheck: true,
      ),
      AppFlowyCheckButtonStateModel(
        code: 'creative_story',
        checkIcon: Icon(Icons.lightbulb, size: size, color: activeColor),
        uncheckIcon: Icon(Icons.lightbulb, size: size, color: inactiveColor),
        title: i18nInstanceLocal.creative_story,
        content: i18nInstanceLocal.creative_story_placeholder,
        value: i18nInstanceLocal.creative_story_prompt,
        isCheck: true,
      ),
      AppFlowyCheckButtonStateModel(
        code: 'meeting_agenda',
        checkIcon: Icon(Icons.event_note, size: size, color: activeColor),
        uncheckIcon: Icon(Icons.event_note, size: size, color: inactiveColor),
        title: i18nInstanceLocal.meeting_agenda,
        content: i18nInstanceLocal.meeting_agenda_placeholder,
        value: i18nInstanceLocal.meeting_agenda_prompt,
        isCheck: true,
      ),
      AppFlowyCheckButtonStateModel(
        code: 'todo_list',
        checkIcon: Icon(Icons.check_box, size: size, color: activeColor),
        uncheckIcon: Icon(Icons.check_box, size: size, color: inactiveColor),
        title: i18nInstanceLocal.todo_list,
        content: i18nInstanceLocal.todo_list_placeholder,
        value: i18nInstanceLocal.todo_list_prompt,
        isCheck: true,
      ),
      AppFlowyCheckButtonStateModel(
        code: 'emoji_conversion',
        checkIcon: Icon(Icons.emoji_emotions, size: size, color: activeColor),
        uncheckIcon: Icon(Icons.emoji_emotions, size: size, color: inactiveColor),
        title: i18nInstanceLocal.emoji_conversion,
        content: i18nInstanceLocal.emoji_conversion_placeholder,
        value: i18nInstanceLocal.emoji_conversion_prompt,
        isCheck: true,
      ),
      AppFlowyCheckButtonStateModel(
        code: 'leave_reason',
        checkIcon: Icon(Icons.event_busy, size: size, color: activeColor),
        uncheckIcon: Icon(Icons.event_busy, size: size, color: inactiveColor),
        title: i18nInstanceLocal.leave_reason,
        content: i18nInstanceLocal.leave_reason_placeholder,
        value: i18nInstanceLocal.leave_reason_prompt,
        isCheck: true,
      ),
      AppFlowyCheckButtonStateModel(
        code: 'pros_and_cons',
        checkIcon: Icon(Icons.view_list, size: size, color: activeColor),
        uncheckIcon: Icon(Icons.view_list, size: size, color: inactiveColor),
        title: i18nInstanceLocal.pros_and_cons,
        content: i18nInstanceLocal.pros_and_cons_placeholder,
        value: i18nInstanceLocal.pros_and_cons_prompt,
        isCheck: true,
      ),
      AppFlowyCheckButtonStateModel(
        code: 'press_release',
        checkIcon: Icon(Icons.article, size: size, color: activeColor),
        uncheckIcon: Icon(Icons.article, size: size, color: inactiveColor),
        title: i18nInstanceLocal.press_release,
        content: i18nInstanceLocal.press_release_placeholder,
        value: i18nInstanceLocal.press_release_prompt,
        isCheck: true,
      ),
      AppFlowyCheckButtonStateModel(
        code: 'advertising_copy',
        checkIcon: Icon(Icons.campaign, size: size, color: activeColor),
        uncheckIcon: Icon(Icons.campaign, size: size, color: inactiveColor),
        title: i18nInstanceLocal.advertising_copy,
        content: i18nInstanceLocal.advertising_copy_placeholder,
        value: i18nInstanceLocal.advertising_copy_prompt,
        isCheck: true,
      ),
      AppFlowyCheckButtonStateModel(
        code: 'job_description',
        checkIcon: Icon(Icons.description, size: size, color: activeColor),
        uncheckIcon: Icon(Icons.description, size: size, color: inactiveColor),
        title: i18nInstanceLocal.job_description,
        content: i18nInstanceLocal.job_description_placeholder,
        value: i18nInstanceLocal.job_description_prompt,
        isCheck: true,
      ),
      AppFlowyCheckButtonStateModel(
        code: 'interview_questions',
        checkIcon: Icon(Icons.question_answer, size: size, color: activeColor),
        uncheckIcon: Icon(Icons.question_answer, size: size, color: inactiveColor),
        title: i18nInstanceLocal.interview_questions,
        content: i18nInstanceLocal.interview_questions_placeholder,
        value: i18nInstanceLocal.interview_questions_prompt,
        isCheck: true,
      ),
      AppFlowyCheckButtonStateModel(
        code: 'food_reviews',
        checkIcon: Icon(Icons.restaurant, size: size, color: activeColor),
        uncheckIcon: Icon(Icons.restaurant, size: size, color: inactiveColor),
        title: i18nInstanceLocal.food_reviews,
        content: i18nInstanceLocal.food_reviews_placeholder,
        value: i18nInstanceLocal.food_reviews_prompt,
        isCheck: true,
      ),
    ];
  }

  static List<AppFlowyCheckButtonStateModel> getModelList() {
    List<AppFlowyCheckButtonStateModel> models = [];
    Color color = Colors.purple;
    double iconSize = 18;
    models.add(AppFlowyCheckButtonStateModel(
      code: 'improve_writing_prompt',
      title: i18nInstanceLocal.improve_writing,
      content: i18nInstanceLocal.improve_writing_prompt,
      value: '',
      color: 0xFF0000FF,
      isCheck: true,
      checkIcon: Icon(Icons.text_fields, color: color, size: iconSize,),
      // checkIconUrl: 'https://example.com/check1.png',
      // uncheckIconUrl: 'https://example.com/uncheck1.png',
    ));

    models.add(AppFlowyCheckButtonStateModel(
      code: 'fix_spelling_grammar',
      title: i18nInstanceLocal.fix_spelling_grammar,
      content: i18nInstanceLocal.fix_spelling_grammar_prompt,
      checkIcon: Icon(Icons.spellcheck, color: color, size: iconSize,),
      // Optional fields can be omitted
    ));

    models.add(AppFlowyCheckButtonStateModel(
      code: 'shorten_prompt',
      title: i18nInstanceLocal.shorten,
      content: i18nInstanceLocal.shorten_prompt,
      checkIcon: Icon(Icons.short_text, color: color, size: iconSize,),
    ));

    models.add(AppFlowyCheckButtonStateModel(
      code: 'enrich_prompt',
      title: i18nInstanceLocal.enrich,
      content: i18nInstanceLocal.enrich_prompt,
      checkIcon: Icon(Icons.format_list_bulleted, color: color, size: iconSize,),
    ));

    models.add(AppFlowyCheckButtonStateModel(
      code: 'switch_style',
      title: i18nInstanceLocal.switch_style,
      content: i18nInstanceLocal.switch_style_prompt,
      checkIcon: Icon(Icons.format_paint, color: color, size: iconSize,),
    ));


    models.add(AppFlowyCheckButtonStateModel(
      code: 'simplify_language',
      title: i18nInstanceLocal.simplify_language,
      content: i18nInstanceLocal.simplify_language_prompt,
      checkIcon: Icon(Icons.language, color: color, size: iconSize,),
    ));

    models.add(AppFlowyCheckButtonStateModel(
      code: 'continue_writing',
      title: i18nInstanceLocal.continue_writing,
      content: i18nInstanceLocal.continue_writing_prompt,
      checkIcon: Icon(Icons.edit, color: color, size: iconSize,),
    ));


    models.add(AppFlowyCheckButtonStateModel(
      code: 'summarize',
      title: i18nInstanceLocal.summarize,
      content: i18nInstanceLocal.summarize_prompt,
      checkIcon: Icon(Icons.summarize, color: color, size: iconSize,),
    ));


    models.add(AppFlowyCheckButtonStateModel(
      code: 'translate',
      title: i18nInstanceLocal.translate,
      content: i18nInstanceLocal.translate_prompt,
      checkIcon: Icon(Icons.translate, color: color, size: iconSize,),
    ));


    models.add(AppFlowyCheckButtonStateModel(
      code: 'explain',
      title: i18nInstanceLocal.explain,
      content: i18nInstanceLocal.explain_prompt,
      checkIcon: Icon(Icons.help_outline, color: color, size: iconSize,),
    ));

    return models;
  }
}

