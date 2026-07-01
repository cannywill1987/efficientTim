/**
 * 文件类型：Flutter 我的反馈卡片组件
 * 文件作用：展示用户提交的单条 CommentModel 反馈。
 * 主要职责：统一反馈标题、摘要、时间、状态和官方回复的视觉结构。
 */
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/CommentModel.dart';

import 'FeedbackStatusHelper.dart';

class MyFeedbackCard extends StatelessWidget {
  final CommentModel model;

  const MyFeedbackCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = _safeText(model.title).isEmpty
        ? _safeText(model.content)
        : _safeText(model.title);
    if (title.isEmpty) {
      title = "我的反馈";
    }
    final String content = _safeText(model.content);
    final String reply = _safeText(model.officialReply);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffedf0f6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xff10131a),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _StatusBadge(status: model.status),
            ],
          ),
          if (content.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xff667085),
                fontSize: 15,
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                _formatTime(model.createdAt, model.create_time),
                style: const TextStyle(color: Color(0xff667085), fontSize: 14),
              ),
              const Spacer(),
              if ((model.rating ?? 0) > 0)
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xffffc233), size: 18),
                    const SizedBox(width: 3),
                    Text(
                      "${model.rating}",
                      style: const TextStyle(
                          color: Color(0xff667085), fontSize: 14),
                    ),
                  ],
                ),
            ],
          ),
          if (reply.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xffeefaf1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "官方回复",
                    style: TextStyle(
                      color: Color(0xff18933a),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    reply,
                    style: const TextStyle(
                      color: Color(0xff667085),
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _safeText(String? text) {
    return (text ?? "").trim();
  }

  String _formatTime(String? createdAt, int? createTime) {
    if ((createdAt ?? "").isNotEmpty) {
      return createdAt!.replaceFirst("T", " ").split(".").first;
    }
    if (createTime == null || createTime <= 0) {
      return "";
    }
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(createTime);
    return "${dateTime.year.toString().padLeft(4, '0')}-"
        "${dateTime.month.toString().padLeft(2, '0')}-"
        "${dateTime.day.toString().padLeft(2, '0')} "
        "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}";
  }
}

class _StatusBadge extends StatelessWidget {
  final int? status;

  const _StatusBadge({Key? key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: FeedbackStatusHelper.getBackgroundColor(status),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        FeedbackStatusHelper.getTitle(status),
        style: TextStyle(
          color: FeedbackStatusHelper.getTextColor(status),
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
