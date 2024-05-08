import 'package:flutter/cupertino.dart';

import '../../../../../beans/Word/WordBean.dart';
import '../../../../../config/ENUMS.dart';

class WordListView extends StatelessWidget {
  List<WordBean>? datas;
  GameStatusModeEnum gameStatusModeEnum;
  Game4EngLevelModeEnum game4EngLevelModeEnum;
  WordListView({this.datas, required this.gameStatusModeEnum, required this.game4EngLevelModeEnum});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bool hideLeftWords = false;
    bool hideRightWord = false;
    //游戏开始 隐藏左侧单词
    hideLeftWords = this.gameStatusModeEnum == GameStatusModeEnum.Starting && (this.game4EngLevelModeEnum == Game4EngLevelModeEnum.level2_hide_leftpart_words || this.game4EngLevelModeEnum == Game4EngLevelModeEnum.level4_hide_all_parts);
    //游戏开始 隐藏右侧单词
    hideRightWord = this.gameStatusModeEnum == GameStatusModeEnum.Starting && (this.game4EngLevelModeEnum == Game4EngLevelModeEnum.level3_hide_rightpart_words || this.game4EngLevelModeEnum == Game4EngLevelModeEnum.level4_hide_all_parts);
    return Wrap(
      direction: Axis.vertical,
        textDirection: TextDirection.ltr,
      children: [
        ...getListWidget(hideLeftWords: hideLeftWords, hideRightWord: hideRightWord),
      ],
    );
  }

  List<Widget> getListWidget({bool hideLeftWords = false, bool hideRightWord = false}) {
    List<Widget> list = [];
    for (int i = 0;i<(this.datas?.length ?? 0); i++) {
      WordBean bean = datas![i];
      if (hideLeftWords == false && hideRightWord == false) {
        list.add(WordItem(no: (i + 1).toString() + ".", chn: bean.meaning ?? "", en: bean.word ?? "", isCheck: bean.isCheck,));
      } else if (hideLeftWords == true && hideRightWord == false) {
        list.add(WordItem(no: (i + 1).toString() + ".", en: bean.word?.replaceAll(RegExp(r"."), '  ') ?? "", chn: bean.meaning ?? "", isCheck: bean.isCheck,));
      } else if (hideLeftWords == false && hideRightWord == true) {
        list.add(WordItem(no: (i + 1).toString() + ".", en: bean.word ?? "", chn: bean.meaning?.replaceAll(RegExp(r"."), '  ') ?? "", isCheck: bean.isCheck,));
      } else {
        list.add(WordItem(no: (i + 1).toString() + ".", en: bean.word?.replaceAll(RegExp(r"."), ' ') ?? "", chn: bean.meaning?.replaceAll(RegExp(r"."), '  ') ?? "", isCheck: bean.isCheck,));
      }
    }
    return list;
  }
}

class WordItem extends StatelessWidget {
  String no;
  String chn;
  String en;
  bool? isCheck;

  WordItem({required this.no, required this.chn, required this.en, this.isCheck= false});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(
      children: [
        Text(
          this.no,
          style: TextStyle(
              fontSize: 12,
              color:
              Color(0xff404040)),
        ),
        Text(
          en,
          style: TextStyle(
              fontSize: 12,
              color:
                  this.isCheck == true ? Color(0xff4395ff) : Color(0xffff8800)),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
        chn,
          style: TextStyle(fontSize: 12, color: Color(0xff404040)),
        )
      ],
    );
  }
}
