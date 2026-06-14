import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/page/AIReplyAssistPage/AIReplyAssistPage.dart';
import 'package:time_hello/com/timehello/page/AIPage/AIPage.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/pages/GPTFoldersPage/GPTFoldersPage.dart';
import '../../config/ENUMS.dart';
import '../../util/ScreenUtil.dart';

class GPTContainer extends BaseWidget {
  const GPTContainer();

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return GPTContainerState();
  }
}

class GPTContainerState extends BaseWidgetState<GPTContainer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 0: 原聊天页（ChatGptPage），1: 回复助手页（AIReplyAssistPage）。
  int _selectedTabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isAppBarVisible = true;
    this.rightNavChildren = [
      IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
          // if (this.widget.onTapNavMenuListener != null) {
          //   this.widget.onTapNavMenuListener!();
          // }
        },
      )
    ];
  }

  @override
  Widget baseBuild(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   // title: Text('Test Page'),
      // ),
      drawer: Drawer(
        width: ScreenUtil.getScreenW(context) * 9 / 10,
        child: GPTFoldersPage(
          onTapItemListener: () {
            _scaffoldKey.currentState?.closeDrawer();
          },
        ),
      ),
      body: Column(
        children: [
          _buildTabSwitcher(),
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: [
                AIPage(
                  pageGPTFromEnum: PageGPTFromEnum.AIHelperPage,
                ),
                const AIReplyAssistPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget baseDesktoptBuild(context) {
    return Column(
      children: [
        _buildTabSwitcher(),
        Expanded(
          child: IndexedStack(
            index: _selectedTabIndex,
            children: [
              Row(
                children: [
                  Container(
                      width: 300,
                      child: GPTFoldersPage(
                        onTapItemListener: () {},
                      )),
                  Expanded(
                      child: AIPage(
                    pageGPTFromEnum: PageGPTFromEnum.AIHelperPage,
                  )),
                ],
              ),
              const AIReplyAssistPage(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabSwitcher() {
    // 入口层做轻量 tab 切换，避免影响原有 ChatGptPage 逻辑。
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffeceef3), width: 1),
        ),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _buildTabItem(index: 0, label: '聊天'),
          const SizedBox(width: 8),
          _buildTabItem(index: 1, label: '回复助手'),
        ],
      ),
    );
  }

  Widget _buildTabItem({required int index, required String label}) {
    final bool selected = _selectedTabIndex == index;
    return InkWell(
      onTap: () {
        if (_selectedTabIndex != index) {
          setState(() {
            _selectedTabIndex = index;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xff4f8cff) : const Color(0xfff4f6fa),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xff4f5565),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
