import 'package:flutter/material.dart';

class RecommendationCards extends StatelessWidget {
  double size = 120;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 第一张卡片 - 编辑推荐
            _buildCard("编辑推荐", "App Store"),
            // 第二张卡片 - 每日精选
            _buildCard("每日精选", "App Store"),
            // 第三张卡片 - 评分
            _buildRatingCard("20万+评分", "4.9", Icons.star),
          ],
        ),
    );
  }

  // 普通推荐卡片
  Widget _buildCard(String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white, width: 2),
      ),
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apple, color: Colors.white, size: 32),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // 评分卡片
  Widget _buildRatingCard(String subtitle, String rating, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white, width: 2),
      ),
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            rating,
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.yellow, size: 16),
              Icon(icon, color: Colors.yellow, size: 16),
              Icon(icon, color: Colors.yellow, size: 16),
              Icon(icon, color: Colors.yellow, size: 16),
              Icon(icon, color: Colors.yellow, size: 16),
            ],
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

