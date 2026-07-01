/**
 * 文件类型：Flutter 好评与反馈弹窗组件
 * 文件作用：承载五星好评、低星反馈表单和商店评分跳转。
 * 主要职责：保证好评引导只弹一次，并通过 MongoApisManager 写入 CommentModel。
 */
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class RatingFeedbackDialog extends StatefulWidget {
  final String scene;
  final VoidCallback? onFeedbackSubmitted;

  const RatingFeedbackDialog({
    Key? key,
    this.scene = "default",
    this.onFeedbackSubmitted,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    String scene = "default",
    VoidCallback? onFeedbackSubmitted,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => RatingFeedbackDialog(
        scene: scene,
        onFeedbackSubmitted: onFeedbackSubmitted,
      ),
    );
  }

  @override
  State<RatingFeedbackDialog> createState() => _RatingFeedbackDialogState();
}

class _RatingFeedbackDialogState extends State<RatingFeedbackDialog> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  int _rating = 5;
  bool _isFeedbackMode = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: _isFeedbackMode ? _buildFeedbackForm() : _buildRatingPanel(),
        ),
      ),
    );
  }

  Widget _buildRatingPanel() {
    return Padding(
      key: const ValueKey("rating"),
      padding: const EdgeInsets.fromLTRB(28, 22, 28, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, color: Color(0xff8b909b)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Container(
            width: 128,
            height: 128,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xfffff6d8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffffc233).withValues(alpha: 0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const Text("😉", style: TextStyle(fontSize: 68)),
          ),
          const SizedBox(height: 22),
          const Text(
            "给我们一个好评吧！",
            style: TextStyle(
              color: Color(0xff10131a),
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "您的满意是我们前进的最大动力",
            style: TextStyle(color: Color(0xff7a8194), fontSize: 16),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final int value = index + 1;
              final bool selected = value <= _rating;
              return IconButton(
                iconSize: 46,
                splashRadius: 28,
                onPressed: () => _handleRating(value),
                icon: Icon(
                  selected ? Icons.star_rounded : Icons.star_border_rounded,
                  color: const Color(0xffffc233),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            _rating >= 5 ? "非常满意" : "感谢反馈",
            style: const TextStyle(color: Color(0xff7a8194), fontSize: 15),
          ),
          const SizedBox(height: 26),
          Container(height: 1, color: const Color(0xffedf0f6)),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isFeedbackMode = true;
                if (_rating >= 5) {
                  _rating = 4;
                }
              });
            },
            icon: const Icon(Icons.sentiment_dissatisfied_outlined),
            label: const Text("不满意，提点意见"),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xff3b3f49),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Padding(
      key: const ValueKey("feedback"),
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => setState(() => _isFeedbackMode = false),
              ),
              const Expanded(
                child: Text(
                  "很抱歉没有让您满意",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff10131a),
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Color(0xff8b909b)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Center(child: Text("🙁", style: TextStyle(fontSize: 58))),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              "您的反馈对我们非常重要",
              style: TextStyle(color: Color(0xff7a8194), fontSize: 16),
            ),
          ),
          const SizedBox(height: 22),
          const Text("请告诉我们原因（选填）",
              style: TextStyle(color: Color(0xff10131a), fontSize: 16)),
          const SizedBox(height: 8),
          _buildContentField(),
          const SizedBox(height: 18),
          const Text("您愿意留下联系方式吗？（选填）",
              style: TextStyle(color: Color(0xff10131a), fontSize: 16)),
          const SizedBox(height: 8),
          _buildContactField(),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitFeedback,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xff7467f0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              child: Text(
                _isSubmitting ? "提交中..." : "提交反馈",
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text("感谢您的反馈！",
                style: TextStyle(color: Color(0xffa0a6b4), fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildContentField() {
    return TextField(
      controller: _contentController,
      maxLength: 500,
      minLines: 4,
      maxLines: 6,
      decoration: InputDecoration(
        hintText: "请描述您遇到的问题或不满意的原因，我们会努力改进...",
        hintStyle: const TextStyle(color: Color(0xffb0b6c3)),
        filled: true,
        fillColor: const Color(0xfffbfcff),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffe2e6ef)),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff7467f0)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildContactField() {
    return TextField(
      controller: _contactController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xffb0b6c3)),
        hintText: "请输入手机号或邮箱",
        hintStyle: const TextStyle(color: Color(0xffb0b6c3)),
        filled: true,
        fillColor: const Color(0xfffbfcff),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffe2e6ef)),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff7467f0)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _handleRating(int value) {
    setState(() => _rating = value);
    if (value >= 5) {
      _openStoreReviewOnce();
    } else {
      setState(() => _isFeedbackMode = true);
    }
  }

  Future<void> _openStoreReviewOnce() async {
    final SharePreferenceUtil prefs =
        await SharePreferenceUtil.getAsyncInstance();
    final String key =
        "rating_review_prompted_${Params.appScene}_${widget.scene}_${LoginManager.getInstance().getUid()}";
    final bool hasPrompted = prefs.getBool(key: key, defaultVal: false);
    if (hasPrompted) {
      Utility.showToastMsg(msg: "已经收到您的好评啦");
      Navigator.pop(context);
      return;
    }
    prefs.setBool(key: key, val: true);
    await MongoApisManager.getInstance().insertCommentModel(
      title: "五星好评",
      content: "用户选择五星好评",
      username: LoginManager.getInstance().getUserBean().username,
      avatar: LoginManager.getInstance().getUserBean().avatar,
      rating: 5,
      platform: _currentPlatformName(),
      market: _currentMarketName(),
      storeReviewPrompted: true,
      storeReviewPromptedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _openStoreReview();
    Navigator.pop(context);
  }

  Future<void> _openStoreReview() async {
    try {
      if (Utility.isIOS()) {
        final InAppReview inAppReview = InAppReview.instance;
        if (await inAppReview.isAvailable()) {
          await inAppReview.requestReview();
        } else {
          await inAppReview.openStoreListing(appStoreId: "1663610373");
        }
      } else if (Utility.isMacOS()) {
        CounterMethodChannelManager.getInstance().requestReview();
      } else if (Utility.isAndroid()) {
        Utility.openExternalWebView(
          url:
              "https://play.google.com/store/apps/details?id=com.timespeed.time_hello.efficienttime",
        );
      } else {
        Utility.openExternalWebView(url: Urls.ratingGuide);
      }
    } catch (e) {
      Utility.openExternalWebView(url: Urls.ratingGuide);
    }
  }

  Future<void> _submitFeedback() async {
    setState(() => _isSubmitting = true);
    await MongoApisManager.getInstance().insertCommentModel(
      title: _contentController.text.trim().isEmpty
          ? "用户反馈"
          : _contentController.text.trim(),
      content: _contentController.text.trim(),
      username: LoginManager.getInstance().getUserBean().username,
      avatar: LoginManager.getInstance().getUserBean().avatar,
      rating: _rating,
      contact: _contactController.text.trim(),
      platform: _currentPlatformName(),
      market: _currentMarketName(),
    );
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    widget.onFeedbackSubmitted?.call();
    Utility.showToastMsg(msg: "反馈已提交");
    Navigator.pop(context);
  }

  String _currentPlatformName() {
    if (Utility.isIOS()) return "iOS";
    if (Utility.isMacOS()) return "macOS";
    if (Utility.isAndroid()) return "Android";
    if (Utility.isWindows()) return "Windows";
    return "Web";
  }

  String _currentMarketName() {
    if (Utility.isIOS() || Utility.isMacOS()) return "App Store";
    if (Utility.isAndroid())
      return Utility.isGooglePlay() ? "Google Play" : "Android Market";
    return "Web";
  }
}
