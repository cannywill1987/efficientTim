import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/FocusRankingModel.dart';
import 'package:time_hello/com/timehello/util/CounterManagement.dart';
import 'package:time_hello/com/timehello/util/FocusRankingManager.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

enum FocusRankingTab { active, todayDesc, todayAsc }

class FocusRankingWidget extends StatefulWidget {
  final double width;
  final double height;

  const FocusRankingWidget({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<FocusRankingWidget> createState() => _FocusRankingWidgetState();
}

class _FocusRankingWidgetState extends State<FocusRankingWidget> {
  FocusRankingListModel? data;
  FocusRankingTab tab = FocusRankingTab.active;
  Timer? timer;
  bool isGrid = false;
  bool isShareOpen = true;

  @override
  void initState() {
    super.initState();
    isShareOpen = FocusRankingManager.getInstance().isShareOpen();
    requestData();
    timer = Timer.periodic(const Duration(seconds: 60), (_) => requestData());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> requestData() async {
    if (LoginManager.isLogin() != true) return;
    FocusRankingListModel? res =
        await FocusRankingManager.getInstance().getList(pageSize: 20);
    if (mounted) {
      setState(() {
        data = res;
      });
    }
  }

  List<FocusRankingModel> getCurrentList() {
    if (tab == FocusRankingTab.active) {
      return data?.activeRanking ?? [];
    } else if (tab == FocusRankingTab.todayAsc) {
      return data?.todayLessRanking ?? [];
    }
    return data?.todayRanking ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = ThemeManager.getInstance()
        .getCardBackgroundColor(defaultColor: Colors.white);
    return Container(
      width: widget.width,
      height: widget.height,
      color: bgColor,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  getI18NKey().focus_ranking,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ThemeManager.getInstance().getTextColor(),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: _toggleShare,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                  child: Text(
                    isShareOpen
                        ? getI18NKey().share_close
                        : getI18NKey().share_open,
                    style: const TextStyle(
                      color: Color(0xff2f80ed),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildSegmentedTabs()),
              const SizedBox(width: 8),
              Tooltip(
                message: isGrid ? getI18NKey().list : getI18NKey().grid,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      isGrid = !isGrid;
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ThemeManager.getInstance().isDark()
                          ? const Color(0xff2b2b2b)
                          : const Color(0xffffefe3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ThemeManager.getInstance().isDark()
                            ? const Color(0xff444444)
                            : const Color(0xffead2bf),
                      ),
                    ),
                    child: Icon(
                      isGrid
                          ? Icons.format_list_bulleted_rounded
                          : Icons.grid_view_rounded,
                      size: 18,
                      color:
                          isGrid ? ColorsConfig.red : const Color(0xff8a6a55),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSegmentedTabs() {
    return Container(
      height: 36,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: ThemeManager.getInstance().isDark()
            ? const Color(0xff262626)
            : const Color(0xfffff6ee),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeManager.getInstance().isDark()
              ? const Color(0xff3a3a3a)
              : const Color(0xffead2bf),
        ),
      ),
      child: Row(
        children: [
          _buildSegmentItem(
              icon: Icons.radio_button_checked_rounded,
              text: getI18NKey().focus_companion_active,
              value: FocusRankingTab.active),
          _buildSegmentItem(
              icon: Icons.trending_up_rounded,
              text: getI18NKey().focus_companion_most,
              value: FocusRankingTab.todayDesc),
          _buildSegmentItem(
              icon: Icons.trending_down_rounded,
              text: getI18NKey().focus_companion_less,
              value: FocusRankingTab.todayAsc),
        ],
      ),
    );
  }

  Widget _buildSegmentItem({
    required IconData icon,
    required String text,
    required FocusRankingTab value,
  }) {
    final bool checked = tab == value;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: () {
          setState(() {
            tab = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: checked ? const Color(0xff6b85ff) : Colors.transparent,
            borderRadius: BorderRadius.circular(17),
            boxShadow: checked
                ? [
                    BoxShadow(
                      color: const Color(0xff6b85ff).withValues(alpha: 0.26),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: checked ? Colors.white : const Color(0xff6b85ff),
                ),
                const SizedBox(width: 3),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: checked ? Colors.white : const Color(0xff8a6a55),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final List<FocusRankingModel> list =
        _moveMeToTop(_appendMeWhenFocusing(getCurrentList()));
    if (LoginManager.isLogin() != true) {
      return Center(child: Text(getI18NKey().login_to_view_focus_ranking));
    }
    if (list.isEmpty) {
      return Center(
        child: Text(
          tab == FocusRankingTab.active
              ? getI18NKey().no_one_focusing_now
              : getI18NKey().no_focus_ranking_data_today,
          style: TextStyle(color: ColorsConfig.gray_a7, fontSize: 12),
        ),
      );
    }
    if (isGrid) {
      return GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.45,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: list.length,
        itemBuilder: (_, index) => _buildGridItem(list[index], index),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: list.length,
      itemBuilder: (_, index) => _buildListItem(list[index], index),
    );
  }

  Widget _buildListItem(FocusRankingModel item, int index) {
    final bool isMe = _isMe(item);
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isMe
            ? const Color(0xff6b85ff).withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildRank(index),
          const SizedBox(width: 8),
          _buildAvatar(item, 28),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TextUtil.isEmpty(item.username)
                      ? 'TimeHello'
                      : item.username!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    if (isMe && tab == FocusRankingTab.active) ...[
                      _buildMePill(),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        TextUtil.isEmpty(item.missionTitle)
                            ? getI18NKey().focusing
                            : item.missionTitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ColorsConfig.gray_a7, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            _formatDuration(tab == FocusRankingTab.active
                ? item.currentSessionFocusMillis
                : item.todayFocusMillis),
            style: TextStyle(color: ColorsConfig.red, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(FocusRankingModel item, int index) {
    final bool isMe = _isMe(item);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isMe
            ? const Color(0xff6b85ff).withValues(alpha: 0.10)
            : ThemeManager.getInstance().isDark()
                ? const Color(0xff242424)
                : const Color(0xfff7f7f7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildRank(index),
              const Spacer(),
              Text(
                _formatDuration(tab == FocusRankingTab.active
                    ? item.currentSessionFocusMillis
                    : item.todayFocusMillis),
                style: TextStyle(color: ColorsConfig.red, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _buildAvatar(item, 24),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  TextUtil.isEmpty(item.username)
                      ? 'TimeHello'
                      : item.username!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          if (isMe && tab == FocusRankingTab.active) ...[
            const SizedBox(height: 4),
            _buildMePill(),
          ],
        ],
      ),
    );
  }

  void _toggleShare() {
    final bool nextValue = !isShareOpen;
    SharePreferenceUtil.getSyncInstance().setBool(
      key: ShareprefrenceKeys.isMissionDetailFocusRankingShareOpen,
      val: nextValue,
    );
    setState(() {
      isShareOpen = nextValue;
    });
    if (nextValue) {
      FocusRankingManager.getInstance().start(
        missionModel: CounterManagement.getInstance().missionModel,
        timeUsedProvider: () => CounterManagement.getInstance().timeUsed,
      );
      requestData();
    } else {
      FocusRankingManager.getInstance().stop();
    }
  }

  List<FocusRankingModel> _moveMeToTop(List<FocusRankingModel> list) {
    if (tab != FocusRankingTab.active) return list;
    final String? uid = LoginManager.getInstance().getUserBean().uid;
    if (TextUtil.isEmpty(uid)) return list;
    final List<FocusRankingModel> copied = [...list];
    final int index = copied.indexWhere((item) => item.uid == uid);
    if (index <= 0) return copied;
    final FocusRankingModel me = copied.removeAt(index);
    return [me, ...copied];
  }

  List<FocusRankingModel> _appendMeWhenFocusing(List<FocusRankingModel> list) {
    if (isShareOpen != true ||
        tab != FocusRankingTab.active ||
        LoginManager.isLogin() != true) {
      return list;
    }
    final CounterManagement counterManagement = CounterManagement.getInstance();
    if (counterManagement.counterStatus != CounterStatus.focusing) {
      return list;
    }
    final userBean = LoginManager.getInstance().getUserBean();
    if (TextUtil.isEmpty(userBean.uid)) return list;

    final List<FocusRankingModel> copied = [...list];
    final int index = copied.indexWhere((item) => item.uid == userBean.uid);
    final FocusRankingModel me = FocusRankingModel()
      ..uid = userBean.uid
      ..username = userBean.username
      ..avatar = userBean.avatar
      ..missionId = counterManagement.missionModel?.objectId
      ..missionTitle = counterManagement.missionModel?.title
      ..active = true
      ..currentSessionFocusMillis = counterManagement.timeUsed
      ..todayFocusMillis = counterManagement.timeUsed;
    if (index >= 0) {
      copied[index] = me;
    } else {
      copied.insert(0, me);
    }
    return copied;
  }

  bool _isMe(FocusRankingModel item) {
    return !TextUtil.isEmpty(item.uid) &&
        item.uid == LoginManager.getInstance().getUserBean().uid;
  }

  Widget _buildMePill() {
    return Container(
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xff6b85ff),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        getI18NKey().me_too,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildRank(int index) {
    return Container(
      width: 22,
      alignment: Alignment.center,
      child: Text(
        '#${index + 1}',
        style: TextStyle(
          color: index < 3 ? ColorsConfig.red : ColorsConfig.gray_a7,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildAvatar(FocusRankingModel item, double size) {
    if (!TextUtil.isEmpty(item.avatar)) {
      return ClipOval(
        child: Image.network(
          item.avatar!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildDefaultAvatar(size),
        ),
      );
    }
    return _buildDefaultAvatar(size);
  }

  Widget _buildDefaultAvatar(double size) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorsConfig.red.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, size: size * 0.62, color: ColorsConfig.red),
    );
  }

  String _formatDuration(int millis) {
    if (millis <= 0) return '0分钟';
    final int minutes = (millis / (60 * 1000)).floor();
    if (minutes < 60) return '${minutes}分钟';
    final int hours = minutes ~/ 60;
    final int mins = minutes % 60;
    return mins == 0 ? '${hours}小时' : '${hours}小时${mins}分';
  }
}
