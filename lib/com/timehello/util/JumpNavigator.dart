import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/page/CountDownListViewPage/CountDownListViewPage.dart';
import 'package:time_hello/com/timehello/util/AnalyticsEventsManager.dart';

import '../config/CONSTANTS.dart';
import '../config/ENUMS.dart';
import '../page/CreditCardManagementPage/pages/CreditCardPage.dart';
import '../page/RecorderPage/RecordPage2.dart';
import '../page/RecorderPage/RecorderPage.dart';
import '../page/RichEditor/RichEditorPage.dart';
import '../page/TimeLinePage/TimeLinePage.dart';
import 'DialogManagement.dart';
import 'Utility.dart';

class JumpNavigator {
  static onClickCustomHeaderGridView(BuildContext context, String code) {
    switch (code) {
      case 'CreditCardPage':
        Utility.openPagePCAndMobile(context,
            child: CreditCardPage(
              onTapItemListener: (item) {},
            ));
        // Utility.pushDesktopMainContainerNavigator(context, "CreditCardPage", {});
        break;
      case 'timeline':
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_timeline",
          "description": "时间轴",
        });
        if (Utility.isHandsetBySize() == true) {
          Future.delayed(Duration(milliseconds: 100), () {
            Utility.pushNavigator(
                context,
                TimeLinePage(
                  key: ValueKey("jfwijf"),
                  timelinePageFromEnum: TimelineModeEnum.all.index,
                  shouldShowNav: true,
                ));
            // Utility.showCurTab(context, CONSTANTS.getCurPage(PageEnum.QuadrantPage), {"curTab": 1});
          });
        } else {
          Utility.pushDesktopMainContainerNavigator(
              context, "TimelinePage", {});
        }
        break;
      case 'addlink':
        break;
      case 'addnote':
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_writing_note",
          "description": "写笔记",
        });
        if (Utility.isHandsetBySize() == true) {
          Future.delayed(Duration(milliseconds: 100), () {
            Utility.pushNavigator(context,
                RichEditorPage(richTextModeEnum: RichTextModeEnum.note));
          });
        } else {
          Future.delayed(Duration(milliseconds: 100), () {
            DialogManagement.getInstance().showPCCustomDialog(
                context: context,
                widget:
                    RichEditorPage(richTextModeEnum: RichTextModeEnum.note));
          });
        }
        break;
      case 'voicenote':
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_speaking_note",
          "description": "语音笔记",
        });
        if (Utility.isHandsetBySize() == true) {
          Future.delayed(Duration(milliseconds: 100), () {
            Utility.pushNavigator(
                context,
                const RecordPage2(
                  richTextModeEnum: RichTextModeEnum.note,
                  shouldShowTitle: null,
                  onSubmit: null,
                ));
          });
        } else {
          Future.delayed(Duration(milliseconds: 100), () {
            DialogManagement.getInstance().showPCCustomDialog(
                context: context,
                widget: const RecordPage2(
                  richTextModeEnum: RichTextModeEnum.note,
                  shouldShowTitle: null,
                  onSubmit: null,
                ));
          });
        }
        break;
      case 'writediary':
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_write_note",
          "description": "写日记",
        });
        if (Utility.isHandsetBySize() == true) {
          Future.delayed(Duration(milliseconds: 100), () {
            Utility.pushNavigator(context,
                RichEditorPage(richTextModeEnum: RichTextModeEnum.diary));
          });
        } else {
          Future.delayed(Duration(milliseconds: 100), () {
            DialogManagement.getInstance().showPCCustomDialog(
                context: context,
                widget:
                    RichEditorPage(richTextModeEnum: RichTextModeEnum.diary));
          });
        }
        break;
      case 'voicediary':
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_write_voice_note",
          "description": "写语音日记",
        });
        if (Utility.isHandsetBySize() == true) {
          Future.delayed(Duration(milliseconds: 100), () {
            Utility.pushNavigator(
                context,
                const RecordPage2(
                  richTextModeEnum: RichTextModeEnum.diary,
                  shouldShowTitle: null,
                  onSubmit: null,
                ));
          });
        } else {
          Future.delayed(Duration(milliseconds: 100), () {
            DialogManagement.getInstance().showPCCustomDialog(
                context: context,
                widget: const RecordPage2(
                  richTextModeEnum: RichTextModeEnum.diary,
                  shouldShowTitle: null,
                  onSubmit: null,
                ));
          });
        }
        break;
      case 'timeline':
        break;
      case 'CountDownListViewPage':
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "folderpage",
          "eventType": "folderpage_flip_clock_timing",
          "description": "倒计时",
        });
        if (Utility.isHandsetBySize() == true) {
          Future.delayed(Duration(milliseconds: 100), () {
            // Utility.showCurTab(context, CONSTANTS.getCurPage(PageEnum.CountDownListViewPage), {"curTab": 1});
            Utility.pushNavigator(context,
                CountDownListViewPage(pageFromEnum: PageFromEnum.Normal));
          });
        } else {
          Utility.pushDesktopMainContainerNavigator(
              context, "CountDownListViewPage", {});
        }
        break;
    }
  }
}
