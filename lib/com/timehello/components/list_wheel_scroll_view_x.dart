library list_wheel_scroll_view_x;

/// A Calculator.
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// ListWheelScrollViewX is modified version of ListWheelScrollView but having
/// scrollDirection arg. It used RotatedBox on ListWheelScrollView to accomplish
/// this.

class ListWheelScrollViewX extends StatelessWidget {
  /// Direction of the ListWheelScrollViewX
   Axis scrollDirection;

   List<Widget> children;

  /// Typically a [FixedExtentScrollController] used to control the current item.
  ///
  /// A [FixedExtentScrollController] can be used to read the currently
  /// selected/centered child item and can be used to change the current item.
  ///
  /// If none is provided, a new [FixedExtentScrollController] is implicitly
  /// created.
  ///
  /// If a [ScrollController] is used instead of [FixedExtentScrollController],
  /// [ScrollNotification.metrics] will no longer provide [FixedExtentMetrics]
  /// to indicate the current item index and [onSelectedItemChanged] will not
  /// work.
  ///
  /// To read the current selected item only when the value changes, use
  /// [onSelectedItemChanged].
  ScrollController? controller;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions.
   ScrollPhysics? physics;

  /// {@macro flutter.rendering.wheelList.diameterRatio}
   double? diameterRatio;

  /// {@macro flutter.rendering.wheelList.perspective}
   double? perspective;

  /// {@macro flutter.rendering.wheelList.offAxisFraction}
   double? offAxisFraction;

  /// {@macro flutter.rendering.wheelList.useMagnifier}
   bool? useMagnifier;

  /// {@macro flutter.rendering.wheelList.magnification}
   double? magnification;

  /// {@macro flutter.rendering.wheelList.overAndUnderCenterOpacity}
   double? overAndUnderCenterOpacity;

  /// Size of each child in the main axis. Must not be null and must be
  /// positive.
   double? itemExtent;

  /// {@macro flutter.rendering.wheelList.squeeze}
  ///
  /// Defaults to 1.
   double? squeeze;

  /// On optional listener that's called when the centered item changes.
   ValueChanged<int>? onSelectedItemChanged;

  /// {@macro flutter.rendering.wheelList.renderChildrenOutsideViewport}
   bool? renderChildrenOutsideViewport;

  /// A delegate that helps lazily instantiating child.
  ListWheelChildDelegate? childDelegate;

  /// {@macro flutter.widgets.Clip}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

   ListWheelScrollViewX({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.physics,
    this.diameterRatio = RenderListWheelViewport.defaultDiameterRatio,
    this.perspective = RenderListWheelViewport.defaultPerspective,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.overAndUnderCenterOpacity = 1.0,
    required this.itemExtent,
    this.squeeze = 1.0,
    required this.onSelectedItemChanged,
    this.renderChildrenOutsideViewport = false,
    this.clipBehavior = Clip.hardEdge,
    required this.children,
  })  : childDelegate = null,
        super(key: key);

   ListWheelScrollViewX.useDelegate({
    Key? key,
    this.scrollDirection = Axis.vertical,
    required this.controller,
    required this.physics,
    this.diameterRatio = RenderListWheelViewport.defaultDiameterRatio,
    this.perspective = RenderListWheelViewport.defaultPerspective,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.overAndUnderCenterOpacity = 1.0,
    required this.itemExtent,
    this.squeeze = 1.0,
    required this.onSelectedItemChanged,
    this.renderChildrenOutsideViewport = false,
    this.clipBehavior = Clip.hardEdge,
    required this.childDelegate,
  })  : children = [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _childDelegate = children != null
        ? ListWheelChildListDelegate(
            children: children.map((child) {
            return RotatedBox(
              quarterTurns: scrollDirection == Axis.horizontal ? 1 : 0,
              child: child,
            );
          }).toList())
        : ListWheelChildBuilderDelegate(
            builder: (context, index) {
              return RotatedBox(
                quarterTurns: scrollDirection == Axis.horizontal ? 1 : 0,
                child: childDelegate?.build(context, index),
              );
            },
          );

    return RotatedBox(
      quarterTurns: scrollDirection == Axis.horizontal ? 3 : 0,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        physics: FixedExtentScrollPhysics(),
        diameterRatio: diameterRatio!,
        perspective: perspective!,
        offAxisFraction: offAxisFraction!,
        useMagnifier: useMagnifier!,
        magnification: magnification!,
        overAndUnderCenterOpacity: overAndUnderCenterOpacity!,
        itemExtent: itemExtent!,
        squeeze: squeeze!,
        onSelectedItemChanged: onSelectedItemChanged,
        renderChildrenOutsideViewport: renderChildrenOutsideViewport!,
        clipBehavior: clipBehavior,
        childDelegate: _childDelegate,
      ),
    );
  }
}
