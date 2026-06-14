import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/ColorsModel.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/SelectObjectTypeModel.dart';
import 'package:time_hello/com/timehello/page/createFolderPage/components/ColorsGridViewWidget.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import '../../components/DescriptionWidget.dart';
import '../../components/IconButtonListWidget.dart';
import '../../config/ColorsConfig.dart';
import '../../libs/mongodb/response/MongoDbSaved.dart';
import '../../models/DateTimeModel.dart';
import '../../models/GroupModel.dart';
import '../../models/PresentModel.dart';
import '../createFolderPage/components/IconsGridViewWidget.dart';

/**
 * 创建文件夹页面
 */
class ThemePage extends BaseWidget {
  PageNavShowEnum? pageNavShowEnum;

  ThemePage(
     ) {
  }

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _ThemePageState();
  }
}

class _ThemePageState<T> extends BaseWidgetState<ThemePage> {
  // FolderModel folderModel;
  // PageEnum pageEnum;
  // SelectObjectTypeModel? selectObjectTypeModel = SelectObjectTypeModel();
  GlobalKey<FormState>? _formKey = new GlobalKey<FormState>();
  TextEditingController? textEditingController;
  GlobalKey<IconsGridViewWidgetState>? IconsGridViewWidgetStateGlobalKey;
  List<GroupModel> listGroupModel = [];
  String method = "customized";

  _ThemePageState() {
    // this.folderModel = folderModel != null ? folderModel : new FolderModel();
    // this.pageEnum = pageEnum;
  }

  @override
  void onCreate() {
    super.onCreate();
    initData();
  }

  void initData() {
    _ensureLightThemeOnly();
  }

  @override
  componentDidMount() {
  }

  @override
  void didUpdateWidget(ThemePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    initData();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickCreateFolder': //创建folder
        onClickCreateFolder();
        break;
      case 'onClickUpdateFolder': //更新folder
        onClickUpdateFolder();
        break;
    }
  }

  void onClickUpdateFolder() {
  }

  void onClickCreateFolder() async {
  }


  void initState() {
    super.initState();
    // selectObjectTypeModel?.icon =  IconData(this.widget.folderModel.icon ?? Icons.fiber_manual_record.codePoint, fontFamily: 'MaterialIcons');
  }

  @override
  void dispose() {
    super.dispose();
    IconsGridViewWidgetStateGlobalKey = GlobalKey();
  }

  /// 主题设置页已经移除暗黑模式入口，这里在进入页面时统一兜底回亮色，
  /// 避免旧配置仍停留在暗黑模式，导致界面状态和可操作项不一致。
  void _ensureLightThemeOnly() {
    if (ThemeManager.getInstance().isDark()) {
      ThemeManager.getInstance().setThemeMode(AdaptiveThemeMode.light);
    }
  }




  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    //默认值
    return LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      return Container(
        padding: new EdgeInsets.fromLTRB(10, 10, 10, 0),
        constraints: BoxConstraints.expand(width: double.infinity),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                getI18NKey().theme,
                style: TextStyle(fontSize: 13, color: Color(0xff999999)),
              ),
            ),
            ColorsGridViewWidget(
                curIndex: 0,
                hasTitle: true,
                datas: CONSTANTS.getThemes(),
                // defaultIndexColor: 0xffff8800,
                onTapListener: (data) {
                  ColorsModel colorsModel = data;
                  ThemeManager.getInstance().setThemeMode(
                      colorsModel.code == "dark"
                          ? AdaptiveThemeMode.dark
                          : AdaptiveThemeMode.light);
                  setState(() {
                    // this.widget.folderModel.color = data.color;
                  });
                }),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                getI18NKey().color_optional,
                style: TextStyle(fontSize: 13, color: Color(0xff999999)),
              ),
            ),
            ColorsGridViewWidget(
              datas: CONSTANTS.getThemeColors(),
                defaultIndexColor: 0xffff8800,
                onTapListener: (data) {
                ThemeManager.getInstance().setDefautThemeColor(data.color);
                  setState(() {
                    // this.widget.folderModel.color = data.color;
                  });
                }),
            SizedBox(
              height: 30,
            ),
            // Align(
            //   alignment: Alignment.center,
            //   child: InkWell(
            //     onTap: () {
            //     },
            //     child: Container(
            //         margin: EdgeInsets.only(top: 20),
            //         width: 260,
            //         height: 45,
            //         alignment: Alignment.center,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           gradient: LinearGradient(
            //               colors:
            //               ThemeManager.getInstance().getButtonLinearGradientBackgroundColor()),
            //         ),
            //         child: Text(
            //     getI18NKey().update,
            //           style: TextStyle(color: Colors.white, fontSize: 14),
            //         )),
            //   ),
            // ),
            SizedBox(height: 20)
          ],
        ),
      );
    });
  }
}
