import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';

class FeatureListWidget extends StatelessWidget {
  // 功能项数据
  final List<Map<String, String>> features = [
    {
      "icon": R.assetsImgIcAds1Calendar,
      "title": "日历月视图",
      "description": "使用网格查看每一天的任务安排"
    },
    {
      "icon": R.assetsImgIcAds2Timeline,
      "title": "日历时间轴视图",
      "description": "全天24小时一览无余"
    },
    {
      "icon": R.assetsImgIcAds3Timesegment,
      "title": "时间段",
      "description": "为任务设置开始和结束时间"
    },
    {
      "icon": R.assetsImgIcAds4Filterer,
      "title": "过滤器",
      "description": "根据筛选自定义筛选任务"
    },
    {
      "icon": R.assetsImgIcAds5Alert,
      "title": "检查事项提醒",
      "description": "为每个重要事项设置提醒"
    },
    {
      "icon": R.assetsImgIcAds6Theme,
      "title": "专属主题",
      "description": "为界面定制不同的系列主题"
    },
    {
      "icon": R.assetsImgIcAds7Alarm,
      "title": "更多提醒",
      "description": "设置更多5个提醒防止错过重要事件"
    },
    {
      "icon": R.assetsImgIcAds8MoreGroupUsers,
      "title": "更多共享成员",
      "description": "为任务分配成员共享清单"
    },
    {
      "icon": R.assetsImgIcAds9Attachment,
      "title": "上传更多附件",
      "description": "每天99个附件方便存储和备查"
    },
    {
      "icon": R.assetsImgIcAds10MoreListing,
      "title": "更多清单和任务",
      "description": "为你的收纳分类清单"
    },
    {
      "icon": R.assetsImgIcAds11MissionDynamic,
      "title": "任务动态",
      "description": "查看每个任务的修订记录"
    },
    {
      "icon": R.assetsImgIcAds12AdvanceSearch,
      "title": "高级搜索",
      "description": "使用搜索精准查找任务"
    },
    {
      "icon": R.assetsImgIcAiHelper,
      "title": "AI助手",
      "description": "AI智能推荐，创建任务和清单"
    },
    {
      "icon": R.assetsImgIcAds13Countdown,
      "title": "倒计时",
      "description": "倒计时和倒计时桌面小组件时刻提醒你重要时刻"
    },
    {
      "icon": R.assetsImgIcAds14Widget,
      "title": "桌面组件",
      "description": "清单，四象限，倒计时，日历，打卡等丰富组件"
    },
    {
      "icon": R.assetsImgIcLockscreenView,
      "title": "锁定App设置",
      "description": "支持苹果手机指定时间锁定APP"
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
