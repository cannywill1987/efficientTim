/// 文件类型：弹窗工具与弹窗组件。
/// 文件作用：设置“我的每小时工作价值”，用于把专注时间换算成用户自定义价值。
/// 主要职责：展示金额输入、快捷金额选择、取消和确认回调，并通过 Overlay 浮层承载桌面端弹窗。
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../main.dart';
import '../config/CONSTANTS.dart';
import '../config/ColorsConfig.dart';
import '../models/CheckButtonStateModel.dart';

class SelectMoneyPerHourOfMeDialogUtil {
  static show(BuildContext mContext,
      {String? title,
      String? content,
      String? leftText,
      String? rightText,
      int initVal = 50,
      CounterEnum counterEnum = CounterEnum.chronograph,
      OnTapListener? onTapListener,
      Function? okCallBack,
      Function? cancelCallBack,
      String okRouteUri = "",
      bool input = false}) {
    title = title ?? "";
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return SelectMoneyPerHourOfMeDialog(
          title: title,
          content: content,
          leftText: leftText,
          initVal: initVal,
          rightText: rightText,
          counterEnum: counterEnum,
          okCallBack: okCallBack,
          onTapListener: onTapListener,
          cancelCallBack: cancelCallBack,
          okRouteUri: okRouteUri,
          input: input);
    });
    navigatorKey.currentState?.overlay?.insert(overlayEntry);
    // showDialog(
    //     context: mContext,
    //     builder: (BuildContext context) {
    //       return DialogContent(
    //           title: title,
    //           content: content,
    //           leftText: leftText,
    //           initVal: initVal,
    //           rightText: rightText,
    //           counterEnum: counterEnum,
    //           okCallBack: okCallBack,
    //           onTapListener: onTapListener,
    //           cancelCallBack: cancelCallBack,
    //           okRouteUri: okRouteUri,
    //           input: input);
    //     });
  }
}

class SelectMoneyPerHourOfMeDialog extends StatefulWidget {
  final String? title; //标题
  final String? content; //内容
  final String? leftText; //左边按钮文字
  final String? rightText; //右边按钮文字
  final bool? onlyRight; //右边按钮文字
  final Function? okCallBack; //右边回调
  final Function? cancelCallBack; //左边回调
  final String? okRouteUri; //右边按钮跳转路由
  final bool? input; //是否展示输入框
  final OnTapListener? onTapListener;
  final CounterEnum? counterEnum;
  final int? initVal;

  SelectMoneyPerHourOfMeDialog(
      {Key? key,
      this.onTapListener,
      this.title,
      this.content,
      this.leftText,
      this.rightText,
      this.onlyRight,
      this.okCallBack,
      this.initVal,
      this.cancelCallBack,
      this.counterEnum,
      this.okRouteUri,
      this.input})
      : super(key: key);

  @override
  SelectMoneyPerHourOfMeDialogState createState() =>
      SelectMoneyPerHourOfMeDialogState(
          onTapListener: this.onTapListener,
          title: this.title,
          content: this.content,
          leftText: this.leftText,
          rightText: this.rightText,
          onlyRight: this.onlyRight,
          initVal: this.initVal,
          okRouteUri: this.okRouteUri,
          input: this.input);
}

class SelectMoneyPerHourOfMeDialogState
    extends State<SelectMoneyPerHourOfMeDialog> {
  String? label = '';
  String? title; //标题
  String? content; //内容
  String? leftText; //左边按钮文字
  String? rightText; //右边按钮文字
  bool? onlyRight; //右边按钮文字
  String? okRouteUri; //右边按钮跳转路由
  bool? input; //是否展示输入框
  double? maxHeight = 350;
  OnTapListener? onTapListener;
  int? curSliderVal = 50;
  FixedExtentScrollController durationScrollController =
      FixedExtentScrollController(initialItem: 0);
  TextEditingController textfieldInputNumberController =
      TextEditingController();
  TextEditingController textfieldInputController = TextEditingController();
  FocusNode? _textfieldContentFocusNode = FocusNode();
  final FocusNode _keyboardFocusNode = FocusNode();
  List<CheckButtonStateModel>? timeLists = CONSTANTS.getSliderDialogList();
  int? maxVal = 1000;
  // CounterEnum? counterEnum = CounterEnum.chronograph;

  SelectMoneyPerHourOfMeDialogState(
      {this.onTapListener,
      this.title,
      this.content,
      this.leftText,
      this.rightText,
      this.onlyRight,
      int? initVal,
      this.okRouteUri,
      // this.counterEnum,
      this.input}) {
    curSliderVal = initVal;
    if ((initVal ?? 0) > 1000) {
      this.maxVal = initVal;
    } else {
      this.maxVal = 1000;
    }
    this.textfieldInputController.text = title ?? "";
  }

  @override
  void didUpdateWidget(SelectMoneyPerHourOfMeDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    textfieldInputNumberController.text = (curSliderVal ?? 0).toString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    durationScrollController.dispose();
    textfieldInputNumberController.dispose();
    textfieldInputController.dispose();
    _textfieldContentFocusNode?.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _updateAmount(int value) {
    final int safeValue = value <= 0 ? 1 : value;
    setState(() {
      curSliderVal = safeValue;
      maxVal = safeValue > 1000 ? safeValue + 1 : 1000;
      textfieldInputNumberController.text = safeValue.toString();
      textfieldInputNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: textfieldInputNumberController.text.length),
      );
    });
  }

  void _confirm() {
    this.widget.okCallBack?.call(curSliderVal);
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = ThemeManager.getInstance()
        .getBackgroundColor(defaultColor: Colors.white);
    final Color textColor = ThemeManager.getInstance().getTextColor(
        defaultColor: const Color(0xFF2E2520), defaultDarkColor: Colors.white);
    final Color subTextColor = ThemeManager.getInstance().getTextColor(
        defaultColor: const Color(0xFF7E746E),
        defaultDarkColor: Colors.white70);
    final String unit = getI18NKey().rmb;
    final String titleText = (this.widget.title?.isNotEmpty ?? false)
        ? this.widget.title!
        : getI18NKey().mission_value;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => this.widget.cancelCallBack?.call(),
              child: Container(color: Colors.black.withValues(alpha: 0.48)),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 桌面端给金额弹窗更宽的阅读空间；窄屏时保留安全边距，避免内容溢出屏幕。
                final double dialogWidth =
                    (constraints.maxWidth - 32).clamp(320.0, 560.0).toDouble();

                return KeyboardListener(
                  autofocus: true,
                  focusNode: _keyboardFocusNode,
                  onKeyEvent: (event) {
                    if (event is KeyDownEvent &&
                        event.physicalKey == PhysicalKeyboardKey.enter) {
                      _confirm();
                    }
                  },
                  child: Container(
                    width: dialogWidth,
                    padding: const EdgeInsets.fromLTRB(30, 28, 30, 26),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 38,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFBBA2FF),
                                    Color(0xFF7257F2)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF7257F2)
                                        .withValues(alpha: 0.22),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.currency_yen_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    titleText,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    content ??
                                        getI18NKey().value_per_hour(
                                            '${curSliderVal ?? 0} $unit'),
                                    style: TextStyle(
                                      color: subTextColor,
                                      fontSize: 13,
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            _buildCustomBadge(),
                            const Spacer(),
                            Text(
                              '${curSliderVal ?? 0} $unit',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildAmountInputCard(textColor, subTextColor, unit),
                        const SizedBox(height: 24),
                        _buildSectionDivider(subTextColor),
                        const SizedBox(height: 18),
                        _buildQuickAmountButtons(unit),
                        const SizedBox(height: 34),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildDialogButton(
                              text: getI18NKey().cancel,
                              isPrimary: false,
                              onTap: () => this.widget.cancelCallBack?.call(),
                            ),
                            const SizedBox(width: 14),
                            _buildDialogButton(
                              text: getI18NKey().confirm,
                              isPrimary: true,
                              onTap: _confirm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCustomBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFECE4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        getI18NKey().custom,
        style: const TextStyle(
          color: Color(0xFF805EF4),
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildAmountInputCard(
      Color textColor, Color subTextColor, String unit) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: ThemeManager.getInstance()
            .getBackgroundColor(defaultColor: const Color(0xFFFFFEFC)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEADFD7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFF7E6E), Color(0xFFFF413A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: TextField(
              focusNode: _textfieldContentFocusNode,
              controller: textfieldInputNumberController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
              onChanged: (String value) {
                final int parsed = int.tryParse(value) ?? 0;
                if (parsed > 0) {
                  setState(() {
                    curSliderVal = parsed;
                    maxVal = parsed > 1000 ? parsed + 1 : 1000;
                  });
                }
              },
              onSubmitted: (_) => _confirm(),
            ),
          ),
          const SizedBox(width: 18),
          Text(
            unit,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down_rounded,
              color: subTextColor, size: 20),
        ],
      ),
    );
  }

  Widget _buildSectionDivider(Color subTextColor) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: const Color(0xFFEFE7E1))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            getI18NKey().custom,
            style: TextStyle(
              color: subTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: const Color(0xFFEFE7E1))),
      ],
    );
  }

  Widget _buildQuickAmountButtons(String unit) {
    final List<CheckButtonStateModel> quickAmounts =
        CONSTANTS.getSelectMoneyDialogList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: quickAmounts.map((CheckButtonStateModel item) {
        final int value = int.tryParse(item.title ?? '') ?? 0;
        final bool isSelected = value == curSliderVal;
        return GestureDetector(
          onTap: () {
            if (value > 0) {
              _updateAmount(value);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF7F6BFF) : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF8B69FF),
                width: 1.4,
              ),
            ),
            child: Text(
              '$value $unit',
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF7B5DEB),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDialogButton({
    required String text,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 126,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? ColorsConfig.red : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isPrimary ? ColorsConfig.red : const Color(0xFFE6DDD6),
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: ColorsConfig.red.withValues(alpha: 0.22),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary ? Colors.white : const Color(0xFF5F5752),
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
