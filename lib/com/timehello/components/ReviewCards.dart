import 'package:flutter/material.dart';

class ReviewCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildReviewCard(
          title: "日程管理神器",
          review:
          "我每天晚上用日视图来安排第二天的日程，周末用周视图复盘本周的时间花费。对时间的清晰掌控不仅提升了我的工作效率，也减少了我的焦虑感。",
          rating: 5,
        ),
        SizedBox(height: 16.0),
        _buildReviewCard(
          title: "再也不忘记重要的事情",
          review:
          "我经常把提醒功能用来抢票、报名等重要事项，持续提醒功能让我不再错过任何一个关键的时间点。",
          rating: 5,
        ),
        SizedBox(height: 16.0),
        _buildReviewCard(
          title: "记录生活",
          review:
          "我喜欢用月视图来记录生活，比如读书、运动和学习打卡。每当月视图进行回顾时，我都会感到开心和不可思议：原来一个月能完成那么多事情！",
          rating: 5,
        ),
      ],
    );
  }

  Widget _buildReviewCard({required String title, required String review, required int rating}) {
    return Card(
      color: Color(0xFF222222),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Color(0xFF383631), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: List.generate(
                    rating,
                        (index) => Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              review,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}