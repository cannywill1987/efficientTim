import 'package:flutter/material.dart';

BoxDecoration buildUnifiedDesktopCardDecoration({
  Color backgroundColor = const Color(0xFFFFFBF7),
  BorderRadiusGeometry borderRadius =
      const BorderRadius.all(Radius.circular(18)),
  BoxBorder? border,
  List<BoxShadow>? boxShadow,
}) {
  return BoxDecoration(
    color: backgroundColor,
    borderRadius: borderRadius,
    border: border ?? Border.all(color: const Color(0xFFF1E2D5)),
    boxShadow: boxShadow ??
        [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
  );
}

class UnifiedDesktopShell extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry outerPadding;
  final BorderRadius borderRadius;
  final Color surfaceColor;

  const UnifiedDesktopShell({
    super.key,
    required this.child,
    this.outerPadding = const EdgeInsets.fromLTRB(18, 16, 18, 18),
    this.borderRadius = const BorderRadius.all(Radius.circular(28)),
    this.surfaceColor = const Color(0xD1FFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8DAC4),
            Color(0xFFF7ECDD),
            Color(0xFFDDEDE0),
          ],
        ),
      ),
      child: Stack(
        children: [
          const _Blob(
            top: -72,
            left: -54,
            size: 190,
            color: Color(0xFFFFD7B8),
          ),
          const _Blob(
            top: 178,
            left: -62,
            size: 170,
            color: Color(0xFFCFE6D7),
          ),
          const _Blob(
            top: 64,
            right: -48,
            size: 150,
            color: Color(0xFFF7E2D0),
          ),
          Padding(
            padding: outerPadding,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: borderRadius,
                border: Border.all(color: const Color(0xFFF0DDCC)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UnifiedDesktopCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final Clip clipBehavior;

  const UnifiedDesktopCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.backgroundColor = const Color(0xFFFFFBF7),
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.border,
    this.boxShadow,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = padding == null
        ? child
        : Padding(
            padding: padding!,
            child: child,
          );

    return Container(
      margin: margin,
      decoration: buildUnifiedDesktopCardDecoration(
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow,
      ),
      child: clipBehavior == Clip.none
          ? content
          : ClipRRect(
              borderRadius: borderRadius,
              clipBehavior: clipBehavior,
              child: content,
            ),
    );
  }
}

class UnifiedActionChip extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const UnifiedActionChip({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8D5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1D3BA)),
      ),
      child: child,
    );
    if (onTap == null) {
      return content;
    }
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: content,
    );
  }
}

class UnifiedSectionPill extends StatelessWidget {
  final String title;
  final String? trailingText;
  final VoidCallback? onTapTrailing;

  const UnifiedSectionPill({
    super.key,
    required this.title,
    this.trailingText,
    this.onTapTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5EC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2E3D4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8B6A55),
              letterSpacing: 0.3,
            ),
          ),
          if (trailingText != null)
            InkWell(
              onTap: onTapTrailing,
              child: Text(
                trailingText!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFAF6F42),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double size;
  final Color color;

  const _Blob({
    this.top,
    this.left,
    this.right,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(size / 2),
        ),
      ),
    );
  }
}
