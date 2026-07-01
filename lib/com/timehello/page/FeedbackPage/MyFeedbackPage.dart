/**
 * 文件类型：Flutter 我的反馈页面
 * 文件作用：展示当前 appScene 下当前用户或设备提交的反馈。
 * 主要职责：提供全部、未处理、开发中、已解决筛选和快捷反馈提交入口。
 */
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/libs/mongodb/response/MongoDbSaved.dart';
import 'package:time_hello/com/timehello/models/CommentModel.dart';
import 'package:time_hello/com/timehello/page/FeedbackPage/components/MyFeedbackCard.dart';
import 'package:time_hello/com/timehello/page/FeedbackPage/components/RatingFeedbackDialog.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import 'components/FeedbackStatusHelper.dart';

class MyFeedbackPage extends StatefulWidget {
  const MyFeedbackPage({Key? key}) : super(key: key);

  @override
  State<MyFeedbackPage> createState() => _MyFeedbackPageState();
}

class _MyFeedbackPageState extends State<MyFeedbackPage> {
  final TextEditingController _quickController = TextEditingController();
  final List<_FeedbackTab> _tabs = const [
    _FeedbackTab(title: "全部"),
    _FeedbackTab(title: "未处理", status: FeedbackStatusHelper.unhandled),
    _FeedbackTab(title: "开发中", status: FeedbackStatusHelper.developing),
    _FeedbackTab(title: "已解决", status: FeedbackStatusHelper.resolved),
  ];
  int _tabIndex = 0;
  bool _isLoading = true;
  bool _isSubmitting = false;
  List<CommentModel> _list = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _quickController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f8fc),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(child: _buildBody()),
            _buildQuickInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              "我的反馈",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff10131a),
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Utility.showToastMsg(msg: "未处理、开发中和已解决的问题都会显示在这里");
            },
            child: const Text("反馈说明"),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 0),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final bool selected = _tabIndex == index;
          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() => _tabIndex = index);
                _loadData();
              },
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selected
                          ? const Color(0xff7467f0)
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  _tabs[index].title,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xff7467f0)
                        : const Color(0xff667085),
                    fontSize: 16,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_list.isEmpty) {
      return Center(
        child: Text(
          LoginManager.isLogin() ? "还没有反馈记录" : "当前设备还没有匿名反馈记录",
          style: const TextStyle(color: Color(0xff98a2b3), fontSize: 16),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => _loadData(showLoading: false),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
        itemCount: _list.length + 1,
        itemBuilder: (context, index) {
          if (index == _list.length) {
            return const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 18),
              child: Center(
                child: Text("没有更多了",
                    style: TextStyle(color: Color(0xff98a2b3), fontSize: 14)),
              ),
            );
          }
          return MyFeedbackCard(model: _list[index]);
        },
      ),
    );
  }

  Widget _buildQuickInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _quickController,
              maxLength: 500,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                counterText: "",
                hintText: "还有其他问题或建议？告诉我们吧～",
                filled: true,
                fillColor: const Color(0xfffbfcff),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffd8dde8)),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xff7467f0)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 78,
            height: 62,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitQuickFeedback,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xff7467f0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send_rounded, size: 24),
                  const SizedBox(height: 3),
                  Text(_isSubmitting ? "提交中" : "提交"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 功能：按当前 Tab 查询当前 appScene 下当前用户或设备的反馈列表。
   * 说明：showLoading=false 用于提交后和下拉刷新，避免已有列表被整页 loading 覆盖。
   */
  Future<void> _loadData({bool showLoading = true}) async {
    if (showLoading && mounted) {
      setState(() => _isLoading = true);
    }
    try {
      final List<CommentModel> list =
          await MongoApisManager.getInstance().queryWhereEqual_CommentModel(
        status: _tabs[_tabIndex].status,
      );
      if (!mounted) return;
      setState(() {
        _list = list;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Utility.showToastMsg(msg: "反馈列表刷新失败，请稍后再试");
    }
  }

  /**
   * 功能：提交底部快捷反馈，并在成功后把新记录插入当前列表顶部。
   * 说明：真实写入仍走 MongoApisManager，由集中入口补齐 Params.appScene、uid 和 device_id。
   */
  Future<void> _submitQuickFeedback() async {
    final String content = _quickController.text.trim();
    if (content.isEmpty) {
      await RatingFeedbackDialog.show(
        context,
        scene: "MyFeedbackPage",
        onFeedbackSubmitted: _loadData,
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final MongoDbSaved? saved =
          await MongoApisManager.getInstance().insertCommentModel(
        title: content,
        content: content,
        username: LoginManager.getInstance().getUserBean().username,
        avatar: LoginManager.getInstance().getUserBean().avatar,
        platform: Utility.isIOS()
            ? "iOS"
            : Utility.isMacOS()
                ? "macOS"
                : Utility.isAndroid()
                    ? "Android"
                    : "Web",
      );
      if (!mounted) return;
      if (saved == null) {
        Utility.showToastMsg(msg: "反馈提交失败，请稍后再试");
        return;
      }
      _quickController.clear();
      setState(() {
        _isSubmitting = false;
        if (_tabs[_tabIndex].status == null ||
            _tabs[_tabIndex].status == FeedbackStatusHelper.unhandled) {
          _list = [_buildSubmittedComment(content, saved), ..._list];
        }
      });
      Utility.showToastMsg(msg: "反馈已提交");
      await _loadData(showLoading: false);
    } finally {
      if (mounted && _isSubmitting) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  /**
   * 功能：把服务器保存结果转换成可立即展示的反馈卡片数据。
   * 说明：这里显式写入 Params.appScene，保证本地乐观 UI 与远端查询隔离口径一致。
   */
  CommentModel _buildSubmittedComment(String content, MongoDbSaved saved) {
    final CommentModel model = CommentModel();
    model.objectId = saved.objectId;
    model.createdAt = saved.createdAt;
    model.create_time = DateTime.now().millisecondsSinceEpoch;
    model.appScene = Params.appScene;
    model.title = content;
    model.content = content;
    model.username = LoginManager.getInstance().getUserBean().username;
    model.avatar = LoginManager.getInstance().getUserBean().avatar;
    model.uid = LoginManager.getInstance().getUid();
    model.status = FeedbackStatusHelper.unhandled;
    model.rating = 0;
    model.platform = Utility.isIOS()
        ? "iOS"
        : Utility.isMacOS()
            ? "macOS"
            : Utility.isAndroid()
                ? "Android"
                : "Web";
    return model;
  }
}

class _FeedbackTab {
  final String title;
  final int? status;

  const _FeedbackTab({required this.title, this.status});
}
