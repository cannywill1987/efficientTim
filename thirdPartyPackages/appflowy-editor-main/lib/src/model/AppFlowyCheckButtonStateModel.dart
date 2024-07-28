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

