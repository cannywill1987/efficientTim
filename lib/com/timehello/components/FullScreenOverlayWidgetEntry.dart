import 'package:flutter/material.dart';

class FullScreenOverlayWidgetEntry {
  FullScreenOverlayWidgetEntry({
    this.top,
    // this.height,
    this.left,
    // this.width,
    required this.builder,
    this.tapToDismiss = true,
    this.dismissCallback,
    this.isCenter = false //lzb 是否居中
  });
  //lzb 是否居中
  final bool isCenter;
  final double? top;
  // final double? height;
  final double? left;
  // final double? width;
  final WidgetBuilder builder;
  final bool tapToDismiss;
  final VoidCallback? dismissCallback;

  OverlayEntry? _entry;

  OverlayEntry build() {
    _entry?.remove();
    _entry = OverlayEntry(
      builder: (context) {
        final size = MediaQuery.of(context).size;
        return SizedBox.fromSize(
          size: size,
          child: Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (tapToDismiss) {
                    // remove this from the overlay when tapped the opaque layer
                    _entry?.remove();
                    _entry = null;
                    dismissCallback?.call();
                  }
                },
              ),
              //lzb 居中
              if(this.isCenter)
                Align(
                  alignment: Alignment(0,-0.5),
                  child: Material(
                    // Avoid background color behind the child, so the child can fully control the overlay style
                    color: Colors.transparent,
                    child: builder(context),
                  ),
                )
              else
              Positioned(
                top: top,
                // bottom: top height,
                left: left,
                // right: left + width,
                child: Material(
                  // Avoid background color behind the child, so the child can fully control the overlay style
                  color: Colors.transparent,
                  child: builder(context),
                ),
              ),
            ],
          ),
        );
      },
    );
    return _entry!;
  }
}
