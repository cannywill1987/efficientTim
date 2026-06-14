import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/SheetDataModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

typedef OnClickFinishListener = void Function(int numTomatoes, int duration);

GlobalKey<DialogContentState> DialogContentStateGlobalKey = GlobalKey();

class SelectTomatoesDialogUtil {
  static show(
    BuildContext mContext, {
    String? title,
    bool onlyRight = false,
    String? content,
    String? leftText,
    String? rightText,
    List<SheetDataModel>? list,
    OnTapListener? onTapListener,
    int? numTomatoes,
    int? duration,
    Function? okCallBack,
    Function? cancelCallBack,
    String okRouteUri = "",
    bool shouldShowBottom = false,
    bool input = false,
  }) {
    title = title ?? getI18NKey().remind;
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    showDialog(
      context: mContext,
      builder: (BuildContext context) {
        return DialogContent(
          key: DialogContentStateGlobalKey,
          title: title,
          content: content,
          leftText: leftText,
          rightText: rightText,
          onlyRight: onlyRight,
          numTomatoes: numTomatoes,
          shouldShowBottom: shouldShowBottom,
          duration: duration,
          okCallBack: okCallBack,
          list: list ?? [],
          onTapListener: onTapListener,
          cancelCallBack: cancelCallBack,
          okRouteUri: okRouteUri,
          input: input,
        );
      },
    );
  }
}

class DialogContent extends StatefulWidget {
  final String? title;
  final String? content;
  final String? leftText;
  final String? rightText;
  final bool? onlyRight;
  final Function? okCallBack;
  final Function? cancelCallBack;
  final String? okRouteUri;
  final bool? input;
  final List<SheetDataModel>? list;
  final OnTapListener? onTapListener;
  final int? numTomatoes;
  final int? duration;
  final bool? shouldShowBottom;

  DialogContent({
    Key? key,
    this.numTomatoes,
    this.duration,
    this.onTapListener,
    this.title,
    this.content,
    this.shouldShowBottom,
    this.leftText,
    this.rightText,
    this.onlyRight,
    this.okCallBack,
    this.list,
    this.cancelCallBack,
    this.okRouteUri,
    this.input,
  }) : super(key: key);

  @override
  DialogContentState createState() => DialogContentState(
        numTomatoes: numTomatoes ?? 0,
        duration: duration ?? 24,
        onTapListener: onTapListener,
        title: title,
        content: content,
        leftText: leftText,
        shouldShowBottom: shouldShowBottom,
        rightText: rightText,
        onlyRight: onlyRight,
        okCallBack: okCallBack,
        list: list,
        cancelCallBack: cancelCallBack,
        okRouteUri: okRouteUri,
        input: input,
      );
}

class DialogContentState extends State<DialogContent> {
  String? title;
  String? content;
  String? leftText;
  String? rightText;
  bool? onlyRight;
  Function? okCallBack;
  Function? cancelCallBack;
  String? okRouteUri;
  bool? input;
  List<SheetDataModel>? list;
  OnTapListener? onTapListener;
  bool? shouldShowBottom;

  int numTomatoes = 0;
  int duration = 24;
  int curTab = 0;

  late final TextEditingController _customTomatoesController;
  late final TextEditingController _customDurationController;

  DialogContentState({
    this.numTomatoes = 0,
    this.duration = 24,
    this.onTapListener,
    this.title,
    this.content,
    this.leftText,
    this.shouldShowBottom,
    this.rightText,
    this.onlyRight,
    this.okCallBack,
    this.list,
    this.cancelCallBack,
    this.okRouteUri,
    this.input,
  });

  int get _actualTomatoes => numTomatoes + 1;
  int get _actualDuration => duration + 1;

  @override
  void initState() {
    super.initState();
    _customTomatoesController =
        TextEditingController(text: _actualTomatoes.toString());
    _customDurationController =
        TextEditingController(text: _actualDuration.toString());
  }

  @override
  void dispose() {
    _customTomatoesController.dispose();
    _customDurationController.dispose();
    super.dispose();
  }

  void _syncCustomControllers() {
    _customTomatoesController.value = TextEditingValue(
      text: _actualTomatoes.toString(),
      selection: TextSelection.collapsed(
        offset: _actualTomatoes.toString().length,
      ),
    );
    _customDurationController.value = TextEditingValue(
      text: _actualDuration.toString(),
      selection: TextSelection.collapsed(
        offset: _actualDuration.toString().length,
      ),
    );
  }

  void _updateTomatoesFromActual(int actualValue) {
    setState(() {
      numTomatoes = actualValue.clamp(1, 999) - 1;
      _syncCustomControllers();
    });
  }

  void _updateDurationFromActual(int actualValue) {
    setState(() {
      duration = actualValue.clamp(1, 999) - 1;
      _syncCustomControllers();
    });
  }

  void _applyCustomTomatoes() {
    final int? value = int.tryParse(_customTomatoesController.text.trim());
    if (value == null || value <= 0) {
      return;
    }
    _updateTomatoesFromActual(value);
  }

  void _applyCustomDuration() {
    final int? value = int.tryParse(_customDurationController.text.trim());
    if (value == null || value <= 0) {
      return;
    }
    _updateDurationFromActual(value);
  }

  String _buildSummaryText() {
    final int totalMinutes = _actualTomatoes * _actualDuration;
    final int hours = totalMinutes ~/ 60;
    final int mins = totalMinutes % 60;
    return getI18NKey().calculateTomatoesTime(
      _actualTomatoes.toString(),
      _actualDuration.toString(),
      hours.toString(),
      mins.toString(),
    );
  }

  Widget _buildTabButton(String text, int index) {
    final bool isActive = curTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            curTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: isActive
                ? const Color(0xFFF0F3DE)
                : Colors.white.withValues(alpha: 0.9),
            border: Border.all(
              color:
                  isActive ? const Color(0xFFB7CE6E) : const Color(0xFFEFE6DA),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 14,
              height: 1.15,
              fontWeight: FontWeight.w700,
              color: isActive
                  ? const Color(0xFF6D8A1D)
                  : ThemeManager.getInstance()
                      .getTextColor(defaultColor: const Color(0xFF7B7168)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCircle({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.92),
          border: Border.all(color: const Color(0xFFE7DCCD)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 24, color: const Color(0xFF3D372F)),
      ),
    );
  }

  Widget _buildCenterDial({
    required String value,
    required String label,
    required int currentValue,
    required int minValue,
    required int maxValue,
    required ValueChanged<int> onChanged,
  }) {
    return CircularTomatoSelector(
      currentValue: currentValue,
      minValue: minValue,
      maxValue: maxValue,
      displayValue: value,
      label: label,
      compactValueText: curTab == 1,
      onChanged: onChanged,
    );
  }

  Widget _buildPresetChip({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? const Color(0xFFF4F8E7) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFF9FBE52) : const Color(0xFFEAE2D7),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: selected ? const Color(0xFF6D8A1D) : const Color(0xFF70675E),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomInputRow({
    required TextEditingController controller,
    required String unit,
    required VoidCallback onApply,
  }) {
    return Row(
      children: [
        Text(
          getI18NKey().custom,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: ThemeManager.getInstance()
                .getTextColor(defaultColor: const Color(0xFF544A42)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFECE3D7)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => onApply(),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: getI18NKey().input_value_hint,
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E2924),
                    ),
                  ),
                ),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A8076),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onApply,
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFFF1F5E4),
              border: Border.all(color: const Color(0xFFCCE08B)),
            ),
            alignment: Alignment.center,
            child: Text(
              getI18NKey().apply_action,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6D8A1D),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountTab() {
    const List<int> presets = [1, 2, 3, 4, 5];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionCircle(
              icon: Icons.remove,
              onTap: () => _updateTomatoesFromActual(_actualTomatoes - 1),
            ),
            const SizedBox(width: 28),
            _buildCenterDial(
              value: _actualTomatoes.toString(),
              label: getI18NKey().tomato,
              currentValue: _actualTomatoes,
              minValue: 1,
              maxValue: math.max(12, _actualTomatoes),
              onChanged: _updateTomatoesFromActual,
            ),
            const SizedBox(width: 28),
            _buildActionCircle(
              icon: Icons.add,
              onTap: () => _updateTomatoesFromActual(_actualTomatoes + 1),
            ),
          ],
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: presets
              .map((value) => _buildPresetChip(
                    text: "$value${getI18NKey().tomato}",
                    selected: _actualTomatoes == value,
                    onTap: () => _updateTomatoesFromActual(value),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
        _buildCustomInputRow(
          controller: _customTomatoesController,
          unit: getI18NKey().tomato,
          onApply: _applyCustomTomatoes,
        ),
      ],
    );
  }

  Widget _buildDurationTab() {
    const List<int> presets = [25, 30, 45, 60];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionCircle(
              icon: Icons.remove,
              onTap: () => _updateDurationFromActual(_actualDuration - 1),
            ),
            const SizedBox(width: 28),
            _buildCenterDial(
              value: "${_actualDuration.toString().padLeft(2, '0')}:00",
              label: getI18NKey().focus,
              currentValue: _actualDuration,
              minValue: 1,
              maxValue: math.max(120, _actualDuration),
              onChanged: _updateDurationFromActual,
            ),
            const SizedBox(width: 28),
            _buildActionCircle(
              icon: Icons.add,
              onTap: () => _updateDurationFromActual(_actualDuration + 1),
            ),
          ],
        ),
        const SizedBox(height: 26),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            getI18NKey().tomatoesDuration,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: ThemeManager.getInstance()
                  .getTextColor(defaultColor: const Color(0xFF40372F)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: presets
              .map((value) => _buildPresetChip(
                    text: "$value ${getI18NKey().mins2}",
                    selected: _actualDuration == value,
                    onTap: () => _updateDurationFromActual(value),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
        _buildCustomInputRow(
          controller: _customDurationController,
          unit: getI18NKey().mins2,
          onApply: _applyCustomDuration,
        ),
      ],
    );
  }

  Widget _buildFooterButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () {
        Navigator.of(context).pop();
        if (okCallBack != null) {
          okCallBack!(numTomatoes, duration);
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: const LinearGradient(
            colors: [Color(0xFF8DB241), Color(0xFF6D9B2B)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7EA437).withValues(alpha: 0.26),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              rightText ?? getI18NKey().confirm,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.75)),
              ),
              child: const Icon(
                Icons.check,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = shouldShowBottom == true
        ? const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          )
        : BorderRadius.circular(28);

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Align(
            alignment: shouldShowBottom == true
                ? Alignment.bottomCenter
                : Alignment.center,
            child: ClipRRect(
              borderRadius: radius,
              child: Container(
                width: 460,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
                decoration: BoxDecoration(
                  color: ThemeManager.getInstance()
                      .getDialogBackgroundColor(defaultColor: Colors.white),
                  borderRadius: radius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        _buildTabButton(getI18NKey().previewTomatoesNum, 0),
                        const SizedBox(width: 12),
                        _buildTabButton(getI18NKey().tomatoesDuration, 1),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _buildSummaryText(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: ThemeManager.getInstance().getTextColor(
                            defaultColor: const Color(0xFF8B8278)),
                      ),
                    ),
                    const SizedBox(height: 22),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child:
                          curTab == 0 ? _buildCountTab() : _buildDurationTab(),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (cancelCallBack != null) {
                              cancelCallBack!();
                            }
                          },
                          child: Text(
                            leftText ?? getI18NKey().cancel,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: ThemeManager.getInstance().getTextColor(
                                  defaultColor: const Color(0xFF34302B)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: _buildFooterButton()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircularTomatoSelector extends StatelessWidget {
  final int currentValue;
  final int minValue;
  final int maxValue;
  final String displayValue;
  final String label;
  final bool compactValueText;
  final ValueChanged<int> onChanged;

  const CircularTomatoSelector({
    super.key,
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    required this.displayValue,
    required this.label,
    required this.onChanged,
    this.compactValueText = false,
  });

  double get _progress {
    if (maxValue <= minValue) {
      return 0;
    }
    return ((currentValue - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);
  }

  void _updateFromOffset(Offset localPosition, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Offset delta = localPosition - center;
    final double angle = math.atan2(delta.dy, delta.dx);
    final double normalized =
        ((angle + math.pi / 2) % (math.pi * 2) + (math.pi * 2)) % (math.pi * 2);
    final double progress = normalized / (math.pi * 2);
    final int nextValue =
        (minValue + ((maxValue - minValue) * progress).round())
            .clamp(minValue, maxValue);
    onChanged(nextValue);
  }

  @override
  Widget build(BuildContext context) {
    const double size = 236;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (details) =>
          _updateFromOffset(details.localPosition, const Size(size, size)),
      onPanUpdate: (details) =>
          _updateFromOffset(details.localPosition, const Size(size, size)),
      onTapDown: (details) =>
          _updateFromOffset(details.localPosition, const Size(size, size)),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(size, size),
              painter: _CircularTomatoDialPainter(progress: _progress),
            ),
            _CircularTomatoHandle(progress: _progress),
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.94),
                border: Border.all(color: const Color(0xFFF2EBDD)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.88),
                    blurRadius: 10,
                    offset: const Offset(-2, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    displayValue,
                    style: TextStyle(
                      fontSize: compactValueText ? 42 : 54,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      color: ThemeManager.getInstance()
                          .getTextColor(defaultColor: const Color(0xFF21201C)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6D8A1D),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularTomatoHandle extends StatelessWidget {
  final double progress;

  const _CircularTomatoHandle({required this.progress});

  @override
  Widget build(BuildContext context) {
    const double size = 236;
    // 句柄需要压在进度条中线上，而不是浮在外圈刻度上。
    const double ringRadius = 82;
    const double handleSize = 30;
    final double angle = (-math.pi / 2) + (math.pi * 2 * progress);
    final double center = size / 2;
    final double x = center + math.cos(angle) * ringRadius - handleSize / 2;
    final double y = center + math.sin(angle) * ringRadius - handleSize / 2;

    return Positioned(
      left: x,
      top: y,
      child: IgnorePointer(
        child: Container(
          width: handleSize,
          height: handleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Utility.getSVGPicture(R.assetsImgIcTomatoChecked, size: 22),
        ),
      ),
    );
  }
}

class _CircularTomatoDialPainter extends CustomPainter {
  final double progress;

  const _CircularTomatoDialPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2 - 22;

    final Paint baseRing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..color = const Color(0xFFEFE7DB);
    canvas.drawCircle(center, radius, baseRing);

    final Paint activeArc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFB6CD74);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      activeArc,
    );

    final Paint tickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 72; i++) {
      final double tickProgress = i / 72;
      final double angle = (-math.pi / 2) + tickProgress * math.pi * 2;
      final bool active = tickProgress <= progress;
      tickPaint
        ..strokeWidth = i % 6 == 0 ? 2.4 : 1.4
        ..color = active
            ? const Color(0xFFC8D998).withValues(alpha: 0.92)
            : const Color(0xFFF6F0E6);
      final double outerRadius = radius + 13;
      final double innerRadius = outerRadius - (i % 6 == 0 ? 10 : 6);
      final Offset start = Offset(
        center.dx + math.cos(angle) * innerRadius,
        center.dy + math.sin(angle) * innerRadius,
      );
      final Offset end = Offset(
        center.dx + math.cos(angle) * outerRadius,
        center.dy + math.sin(angle) * outerRadius,
      );
      canvas.drawLine(start, end, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircularTomatoDialPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
