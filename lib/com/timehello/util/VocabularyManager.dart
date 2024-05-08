
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/beans/Word/VocabularyLevelList.dart';
import 'package:time_hello/com/timehello/beans/Word/VocabularyUnitList.dart';
import 'package:time_hello/com/timehello/beans/Word/WordList.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../beans/Word/TextVoiceBean.dart';
import '../beans/Word/TextVoiceListBean.dart';
import '../beans/Word/VocabularyUnitBean.dart';
import '../beans/Word/WordBean.dart';
import '../config/ColorsConfig.dart';
import '../config/Params.dart';
import '../config/StylesConfig.dart';

/**
 * 公共组件的管理
 */
class VocabularyManager {
  static VocabularyManager? instance;
  VocabularyLevelList? vocabularyLevelList;
  VocabularyUnitList? vocabularyUnitList;
  List<TextVoiceBean>? textVoiceBeanList;

  static VocabularyManager? getInstance() {
    if (instance == null) {
      instance = new VocabularyManager();
      instance?.init();
    }
    return instance;
  }

  void init() {
    requestGetTextVoiceBeanList(
        codes:
            "please_say_first_word,please_say_second_word,please_say_third_word,please_say_fourth_word,please_say_fifth_word"
                .split(','));
  }

  Future<VocabularyLevelList?> requestGetVocabulariLevelList() async {
    if (vocabularyLevelList == null) {
      BaseBean res = await HttpManager.getInstance()
          .doPostRequest(Apis.getVocabulariLevelList);
      VocabularyLevelList list = VocabularyLevelList.fromJson(res.data);
      this.vocabularyLevelList = list;
      return list;
    } else {
      return vocabularyLevelList;
    }
  }

  Future<List<VocabularyUnitBean>> requestGetVocabulariUnitList(
      {level: ""}) async {
    List<VocabularyUnitBean> listTmp = [];
    if (vocabularyUnitList == null) {
      BaseBean res = await HttpManager.getInstance()
          .doPostRequest(Apis.getVocabulariUnits);
      VocabularyUnitList list = VocabularyUnitList.fromJson(res.data);
      vocabularyUnitList = list;
      return getVocabulariesUnitListByLevel(list, level, listTmp);
    } else {
      return getVocabulariesUnitListByLevel(
          vocabularyUnitList!, level, listTmp);
    }
  }

  List<VocabularyUnitBean> getVocabulariesUnitListByLevel(
      VocabularyUnitList list, level, List<VocabularyUnitBean> listTmp) {
    for (int i = 0; i < (vocabularyUnitList?.list?.length ?? 0); i++) {
      VocabularyUnitBean? item = vocabularyUnitList?.list?[i];
      if (item?.level == level) {
        listTmp.add(item!);
      }
    }
    return listTmp;
  }

  Future<WordList> requestGetWordList(String url) async {
    BaseBean res = await HttpManager.getInstance().doGetFileContentRequest(url);
    WordList wordList = WordList.fromJson({
      "list": [...res.data]
    });
    return wordList;
  }

  Future<List<WordBean>?> requestGetRandomWordList(String url,
      [int nums = -1]) async {
    try {
      BaseBean res =
          await HttpManager.getInstance().doGetFileContentRequest(url);
      WordList wordList = WordList.fromJson({
        "list": [...res.data]
      });
      // wordList.list.sort()
      wordList.list?.sort((val1, val2) {
        return Utility.getRandom(from: -50, max: 50);
      });
      int max = (wordList.list?.length ?? 0) > nums
          ? (wordList.list?.length ?? 0)
          : nums;
      int random = Utility.getRandom(max: max - nums);
      if (nums == -1) {
        return wordList.list;
      } else {
        return wordList.list?.sublist(random, random + nums);
      }
    } catch (error) {
      print(error.toString());
    }
      return [];
  }

  Future<List<TextVoiceBean>?> requestGetTextVoiceBeanList(
      {required List<String> codes}) async {
    if (textVoiceBeanList == null) {
      BaseBean res = await HttpManager.getInstance().doPostRequest(
          Apis.getTextVoiceList,
          params: {"code": codes.join(',')});
      TextVoiceListBean wordList = TextVoiceListBean.fromJson({
        "list": [...res.data]
      });
      return wordList.list;
    } else {
      return textVoiceBeanList;
    }
  }
}
