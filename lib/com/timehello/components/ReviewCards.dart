import 'package:flutter/material.dart';

import '../util/Utility.dart';

class ReviewCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildReviewCard(
          title: getI18NKey().schedule_management_tool,
          review: getI18NKey().schedule_management_review,
          rating: 5,
        ),
        SizedBox(height: 16.0),
        _buildReviewCard(
          title: getI18NKey().never_miss_important_things,
          review: getI18NKey().never_miss_review,
          rating: 5,
        ),
        SizedBox(height: 16.0),
        _buildReviewCard(
          title: getI18NKey().life_recording,
          review: getI18NKey().life_recording_review,
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