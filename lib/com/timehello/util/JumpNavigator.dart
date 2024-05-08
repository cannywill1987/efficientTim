import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/page/CountDownListViewPage/CountDownListViewPage.dart';

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
    switch(code) {
      case 'CreditCardPage':
        Utility.openPagePCAndMobile(context, child: CreditCardPage(onTapItemListener: (item) {},));
        // Utility.pushDesktopMainContainerNavigator(context, "CreditCardPage", {});
        break;
      case 'timeline':
        if (Utility.isHandsetBySize() == true) {
          Future.delayed(Duration(milliseconds: 100), () {
            Utility.pushNavigator(context, TimeLinePage(key: ValueKey("jfwijf"), timelinePageFromEnum: TimelineModeEnum.all.index, shouldShowNav: true,));
            // Utility.showCurTab(context, CONSTANTS.getCurPage(PageEnum.QuadrantPage), {"curTab": 1});
          });
        } else {
          Utility.pushDesktopMainContainerNavigator(context, "TimelinePage", {});
        }
        break;
      case 'addlink':
        break;
      case 'addnote':
        if (Utility.isHandsetBySize() == true) {
          Future.delayed(Duration(milliseconds: 100), () {
            Utility.pushNavigator(
                context,
                RichEditorPage(
                    richTextModeEnum: RichTextModeEnum.note));
          });
        } else {
          Future.delayed(Duration(milliseconds: 100), () {
            DialogManagement.getInstance().showPCCustomDialog(
                context: context,
                widget: RichEditorPage(
                    richTextModeEnum: RichTextModeEnum.note));
          });
        }
        break;
      case 'voicenote':
        if (Utility.isHandsetBySize() == true) {
            Future.delayed(Duration(milliseconds: 100), () {
              Utility.pushNavigator(context,
                  const RecordPage2(richTextModeEnum: RichTextModeEnum.note, shouldShowTitle: null, onSubmit: null,));
            });
        } else {
            Future.delayed(Duration(milliseconds: 100), () {
              DialogManagement.getInstance().showPCCustomDialog(
                  context: context,
                  widget: const RecordPage2(
                      richTextModeEnum: RichTextModeEnum.note, shouldShowTitle: null, onSubmit: null,));
            });
        }
        break;
      case 'writediary':
        if (Utility.isHandsetBySize() == true) {
          Future.delayed(Duration(milliseconds: 100), () {
            Utility.pushNavigator(
                context,
                RichEditorPage(
                    richTextModeEnum: RichTextModeEnum.diary));
          });
        } else {
          Future.delayed(Duration(milliseconds: 100), () {
            DialogManagement.getInstance().showPCCustomDialog(
                context: context,
                widget: RichEditorPage(
                    richTextModeEnum: RichTextModeEnum.diary));
          });
        }
        break;
      case 'voicediary':
        if (Utility.isHandsetBySize() == true) {
          Future.delayed(Duration(milliseconds: 100), () {
            Utility.pushNavigator(context,
                const RecordPage2(richTextModeEnum: RichTextModeEnum.diary, shouldShowTitle: null, onSubmit: null,));
          });
        } else {
          Future.delayed(Duration(milliseconds: 100), () {
            DialogManagement.getInstance().showPCCustomDialog(
                context: context,
                widget: const RecordPage2(
                    richTextModeEnum: RichTextModeEnum.diary, shouldShowTitle: null, onSubmit: null,));
          });
        }
        break;
      case 'timeline':
        break;
      case 'CountDownListViewPage':
        if (Utility.isHandsetBySize() == true) {
          Future.delayed(Duration(milliseconds: 100), () {
            // Utility.showCurTab(context, CONSTANTS.getCurPage(PageEnum.CountDownListViewPage), {"curTab": 1});
            Utility.pushNavigator(context, CountDownListViewPage(pageFromEnum: PageFromEnum.Normal));
          });
        } else {
          Utility.pushDesktopMainContainerNavigator(context, "CountDownListViewPage", {});
        }
        break;
    }
  }
}