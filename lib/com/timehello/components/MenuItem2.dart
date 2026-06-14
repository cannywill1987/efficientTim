// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/unified/UnifiedDesktopShell.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class MenuItem2 extends StatefulWidget {
  Widget icon;
  String title;
  String? subTitle;
  Widget? rightPartContainer;
  OnTapListener? onTapListener;
  bool useUnifiedStyle;
  bool compactUnifiedStyle;
  bool useCreateMissionMobileStyle;
  double? width;
  MenuItem2(
      {required this.icon,
      required this.title,
      this.subTitle,
      this.rightPartContainer,
      this.onTapListener,
      this.useUnifiedStyle = false,
      this.compactUnifiedStyle = false,
      this.useCreateMissionMobileStyle = false,
      this.width});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MenuItemState();
  }
}

class MenuItemState extends State<MenuItem2> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          this.widget.icon,
          SizedBox(
            width: 7,
          ),
          Text(
            this.widget.title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 2,
          ),
          this.widget.subTitle == null
              ? SizedBox.shrink()
              : Text(
                  this.widget.subTitle ?? "",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffa0a0a0)),
                )
        ],
      )
    ];
    if (this.widget.rightPartContainer != null) {
      items.add(this.widget.rightPartContainer!);
    }
    if (widget.useUnifiedStyle) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() {
          _isHovered = true;
        }),
        onExit: (_) => setState(() {
          _isHovered = false;
        }),
        child: InkWell(
          onTap: () {
            if (this.widget.onTapListener != null) {
              this.widget.onTapListener!(null);
            }
          },
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            width: widget.width,
            constraints: BoxConstraints(
              minHeight: widget.compactUnifiedStyle ? 74 : 102,
            ),
            padding: EdgeInsets.fromLTRB(
              14,
              widget.compactUnifiedStyle ? 12 : 13,
              14,
              widget.compactUnifiedStyle ? 12 : 12,
            ),
            decoration: buildUnifiedDesktopCardDecoration(
              backgroundColor:
                  ThemeManager.getInstance().getCardBackgroundColor(
                defaultColor: _isHovered
                    ? const Color(0xFFFFF8F0)
                    : const Color(0xFFFFFCF7),
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _isHovered
                    ? const Color(0xFFE1C8B0)
                    : const Color(0xFFECDDCA),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withValues(alpha: _isHovered ? 0.05 : 0.03),
                  blurRadius: _isHovered ? 14 : 10,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: widget.compactUnifiedStyle
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? const Color(0xFFFFECD8)
                              : const Color(0xFFFFF2E2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        alignment: Alignment.center,
                        child: this.widget.icon,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              this.widget.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: ThemeManager.getInstance().getTextColor(
                                    defaultColor: const Color(0xFF6D5646)),
                              ),
                            ),
                            if ((this.widget.subTitle ?? "").isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                this.widget.subTitle ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeManager.getInstance()
                                      .getTextColor(
                                          defaultColor:
                                              const Color(0xFFA18A78)),
                                ),
                              ),
                            ],
                            if (this.widget.rightPartContainer != null)
                              const SizedBox(height: 5),
                            if (this.widget.rightPartContainer != null)
                              DefaultTextStyle.merge(
                                style: TextStyle(
                                  color: ThemeManager.getInstance()
                                      .getTextColor(
                                          defaultColor:
                                              const Color(0xFF3C2A1E)),
                                ),
                                child: this.widget.rightPartContainer!,
                              ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? const Color(0xFFFFECD8)
                              : const Color(0xFFFFF2E2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        alignment: Alignment.center,
                        child: this.widget.icon,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        this.widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: ThemeManager.getInstance().getTextColor(
                              defaultColor: const Color(0xFF6D5646)),
                        ),
                      ),
                      if ((this.widget.subTitle ?? "").isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          this.widget.subTitle ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: ThemeManager.getInstance().getTextColor(
                                defaultColor: const Color(0xFFA18A78)),
                          ),
                        ),
                      ],
                      if (this.widget.rightPartContainer != null)
                        const SizedBox(height: 12),
                      if (this.widget.rightPartContainer != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: DefaultTextStyle.merge(
                            style: TextStyle(
                              color: ThemeManager.getInstance().getTextColor(
                                  defaultColor: const Color(0xFF3C2A1E)),
                            ),
                            child: this.widget.rightPartContainer!,
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      );
    }
    if (widget.useCreateMissionMobileStyle) {
      return InkWell(
          onTap: () {
            if (this.widget.onTapListener != null) {
              this.widget.onTapListener!(null);
            }
          },
          child: Container(
              constraints: const BoxConstraints(minHeight: 66),
              padding: const EdgeInsets.fromLTRB(28, 0, 18, 0),
              decoration: BoxDecoration(
                color: ThemeManager.getInstance()
                    .getCardBackgroundColor(defaultColor: Colors.white),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withValues(alpha: 0.055),
                    width: 0.7,
                  ),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 24, height: 24, child: this.widget.icon),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          this.widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: ThemeManager.getInstance().getTextColor(
                                defaultColor: const Color(0xFF171717)),
                          ),
                        ),
                        if ((this.widget.subTitle ?? "").isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Text(
                            this.widget.subTitle ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF9E9E9E),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (this.widget.rightPartContainer != null)
                    DefaultTextStyle.merge(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w500,
                      ),
                      child: this.widget.rightPartContainer!,
                    ),
                ],
              )));
    }
    // TODO: implement build
    //获取星星
    return InkWell(
        onTap: () {
          if (this.widget.onTapListener != null) {
            this.widget.onTapListener!(null);
          }
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
            constraints: BoxConstraints(minHeight: 60),
            // height: 60,
            color: ThemeManager.getInstance().getCardBackgroundColor(
                context: context, defaultColor: Colors.white),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: items,
            )));
  }
}
