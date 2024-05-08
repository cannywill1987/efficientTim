import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../common/provider/GlobalStateEnv.dart';
import '../../models/CourseModel.dart';
import '../../util/DialogManagement.dart';
import '../SelectShareFolderPage/SelectShareFolderPage.dart';
import 'components/CourseListViewWidget.dart';

/**
 * 游戏列表首页
 */
class CoursePage extends BaseWidget {
  const CoursePage();

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _CoursePageWidgetState();
  }
}

class _CoursePageWidgetState<T> extends BaseWidgetState<CoursePage> {
  List<CourseModel>? listCourseModel = [];
  @override
  void deactivate() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this.isAppBarVisible = Utility.isHandsetBySize() ? true : false;
    requestDatas();

  }

  requestDatas() async {
    listCourseModel = await MongoApisManager.getInstance().queryWhereEqual_CourseModel();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickSegmentControl':
        break;
      case 'onClickPCValueType':
        break;
    }
  }

  Widget baseDesktoptBuild(BuildContext context) {
    List<CourseModel> list = context.watch<GlobalStateEnv>().listCourseModel ?? [];
    return CourseListViewWidget(
      // datas: listCourseModel,
        onTapListener: (res) {
          LoginManager.getInstance().hasUserName(context: context, callback: () {
            if (Utility.isHandsetBySize() == true) {
              Utility.pushNavigator(context, SelectShareFolderPage(courseModel: res,));
            } else {
              DialogManagement.getInstance()
                  .showPCCustomDialog(context: context, widget: SelectShareFolderPage(courseModel: res,));
            }
            // Utility.pushToGame(context: context, bean: res, isPC: true);
            // Utility.pushToGame(context: context, bean: res);
          });
        },
        datas: list);
  }

  Widget baseBuild(BuildContext context) {
    List<CourseModel> list = context.watch<GlobalStateEnv>().listCourseModel ?? [];
    return CourseListViewWidget(
        onTapListener: (res) {
          LoginManager.getInstance().hasUserName(context: context, callback: () {
            if (Utility.isHandsetBySize() == true) {
              Utility.pushNavigator(context, SelectShareFolderPage(courseModel: res,));
            } else {
              DialogManagement.getInstance()
                  .showPCCustomDialog(context: context, widget: SelectShareFolderPage(courseModel: res,));
            }
          });
        },
        datas: context.watch<GlobalStateEnv>().listCourseModel ?? []);
  }
}
