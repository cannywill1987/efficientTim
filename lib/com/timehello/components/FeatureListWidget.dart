import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';

class FeatureListWidget extends StatelessWidget {
  // 功能项数据
  final List<Map<String, String>> features = [
    {
      "icon": R.assetsImgIcAds1Calendar,
      "title": getI18NKey().calendar_month_view,
      "description": getI18NKey().calendar_month_view_description
    },
    {
      "icon": R.assetsImgIcAds2Timeline,
      "title": getI18NKey().calendar_timeline_view,
      "description": getI18NKey().calendar_timeline_view_description
    },
    {
      "icon": R.assetsImgIcAds3Timesegment,
      "title": getI18NKey().time_segment,
      "description": getI18NKey().time_segment_description
    },
    {
      "icon": R.assetsImgIcAds4Filterer,
      "title": getI18NKey().filter,
      "description": getI18NKey().filter_description
    },
    {
      "icon": R.assetsImgIcAds5Alert,
      "title": getI18NKey().check_item_reminder,
      "description": getI18NKey().check_item_reminder_description
    },
    {
      "icon": R.assetsImgIcAds6Theme,
      "title": getI18NKey().custom_theme,
      "description": getI18NKey().custom_theme_description
    },
    {
      "icon": R.assetsImgIcAds7Alarm,
      "title": getI18NKey().more_reminders,
      "description": getI18NKey().more_reminders_description
    },
    {
      "icon": R.assetsImgIcAds8MoreGroupUsers,
      "title": getI18NKey().more_shared_members,
      "description": getI18NKey().more_shared_members_description
    },
    {
      "icon": R.assetsImgIcAds9Attachment,
      "title": getI18NKey().upload_more_attachments,
      "description": getI18NKey().upload_more_attachments_description
    },
    {
      "icon": R.assetsImgIcAds10MoreListing,
      "title": getI18NKey().more_lists_and_tasks,
      "description": getI18NKey().more_lists_and_tasks_description
    },
    {
      "icon": R.assetsImgIcAds11MissionDynamic,
      "title": getI18NKey().task_dynamics,
      "description": getI18NKey().task_dynamics_description
    },
    {
      "icon": R.assetsImgIcAds12AdvanceSearch,
      "title": getI18NKey().advanced_search,
      "description": getI18NKey().advanced_search_description
    },
    {
      "icon": R.assetsImgIcAiHelper,
      "title": getI18NKey().ai_helper,
      "description": getI18NKey().ai_helper_description
    },
    {
      "icon": R.assetsImgIcAds13Countdown,
      "title": getI18NKey().countdown,
      "description": getI18NKey().countdown_description
    },
    {
      "icon": R.assetsImgIcAds14Widget,
      "title": getI18NKey().desktop_widget,
      "description": getI18NKey().desktop_widget_description
    },
    {
      "icon": R.assetsImgIcLockscreenView,
      "title": getI18NKey().lock_app_settings,
      "description": getI18NKey().lock_app_settings_description
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildFeatureRows(features),
    );
  }

  List<Widget> _buildFeatureRows(List<Map<String, String>> features) {
    List<Widget> rows = [];
    for (int i = 0; i < features.length; i += 2) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (i < features.length)
              Expanded(
                child: _buildFeatureItem(features[i]),
              ),
            if (i + 1 < features.length)
              Expanded(
                child: _buildFeatureItem(features[i + 1]),
              ),
          ],
        ),
      );
      rows.add(SizedBox(height: 16)); // 行间距
    }
    return rows;
  }

  Widget _buildFeatureItem(Map<String, String> feature) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左边的图片
        Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(right: 14),
            child: Utility.getSVGPicture(feature['icon'] ?? "", size: 40)),
        SizedBox(width: 8),
        // 右边的标题和描述
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feature['title']!,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                feature['description']!,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
