import 'package:flutter/material.dart';

import '../../../../r.dart';
import '../../components/RecommendationCards.dart';
import '../../components/ReviewCards.dart';

class PremiumUpgradePage extends StatelessWidget {
  final PageController _pageController = PageController();
  double padding = 4;
  double horizontalPadding = 16;
  double marginItem = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeaderSection(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: this.marginItem),
                      SectionTitle(title: '功能特享特权'),
                      _buildFeatureTable(),
                      SizedBox(height: this.marginItem),
                      SectionTitle(title: '官方推荐'),
                      RecommendationCards(),
                      SizedBox(height: this.marginItem),
                      SectionTitle(title: '用户评价'),
                      ReviewCards(),
                      SizedBox(height: this.marginItem),
                      _buildRestorePurchaseButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildFooter(context)
      ],
    );
  }

  Widget _buildRestorePurchaseButton() {
    return OutlinedButton(
      onPressed: () {
        // 恢复购买逻辑
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.orange, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      ),
      child: Text(
        '恢复购买',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 250.0,
            decoration: BoxDecoration(
              color: Color(0xFF3E3E3E),
            ),
            child: PageView.builder(
              controller: _pageController,
              itemCount: 4, // Replace with the actual number of items
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.black,
                  child: index == 0
                      ? GuideWidget(
                          imagePath: R.assetsImgBgGuideBuy,
                          title: '畅享10倍扩容',
                          desc: '创建更多，达成更多',
                        )
                      : index == 1
                          ? GuideWidget(
                              imagePath: 'assets/images/feature_1.png',
                              title: '高级提醒',
                              desc: '不再遗忘任何重要事项',
                            )
                          : index == 2
                              ? GuideWidget(
                                  imagePath: 'assets/images/feature_2.png',
                                  title: '数据统计',
                                  desc: '详细的分析和报告',
                                )
                              : GuideWidget(
                                  imagePath: 'assets/images/feature_3.png',
                                  title: '个性主题',
                                  desc: '根据您的喜好定制外观',
                                ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFeatureTable() {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color(0xFF3E3E3E),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Color(0xFF3E3E3E), width: 1.0),
      ),
      child: Table(
        // border: TableBorder.all(color: Colors.grey),
        columnWidths: {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1),
        },
        children: [
          _buildHeaderTableRow('权益', '普通用户', '高级会员'),
          _buildTableRow('日历视图', '基础', '月/周/日/3日'),
          _buildTableRow('时间段', '-', '✓'),
          _buildTableRow('持续提醒', '-', '✓'),
          _buildTableRow('关联微信', '-', '✓'),
          _buildTableRow('小组件', '基础', '无限制'),
          _buildTableRow('外观主题', '基础', '无限制'),
          _buildTableRow('数据统计', '基础', '无限制'),
        ],
      ),
    );
  }

  TableRow _buildHeaderTableRow(
      String feature, String normalUser, String premiumUser) {
    return TableRow(
      decoration: BoxDecoration(color: Color(0xFF2D2D2D)),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(feature,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(normalUser, style: TextStyle(color: Colors.white)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(premiumUser,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
        ),
      ],
    );
  }

  TableRow _buildTableRow(
      String feature, String normalUser, String premiumUser) {
    return TableRow(
      decoration: BoxDecoration(color: Color(0xFF222222)),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(feature,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(normalUser, style: TextStyle(color: Colors.white)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(premiumUser, style: TextStyle(color: Colors.orange)),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text.rich(TextSpan(children: [
            TextSpan(
              text: '¥ 168.00 / 年',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '(折合 ¥14.00 / 月)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ])),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Add functionality to start the 7-day free trial
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              textStyle: TextStyle(fontSize: 20),
            ),
            child: Text(
              '免费试用 7 天',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '试用期结束后将以 ¥168.00/年自动续费，可随时取消。升级即视为你同意高级会员服务协议、隐私政策和使用条款。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.orange,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class GuideWidget extends StatelessWidget {
  final BorderRadius borderRadius = BorderRadius.circular(16.0);
  final String imagePath;
  final String title;
  final String desc;

  GuideWidget({
    required this.imagePath,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Container(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                desc,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          color: Colors.black,
        ),
      ),
    );
  }
}
