import 'drag_and_drop_builder_parameters.dart';
import 'drag_and_drop_item.dart';
import 'drag_and_drop_item_target.dart';
import 'drag_and_drop_layout_log.dart';
import 'drag_and_drop_item_wrapper.dart';
import 'drag_and_drop_list_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragAndDropList implements DragAndDropListInterface {
  /// The widget that is displayed at the top of the list.
  final Widget? header;

  /// The widget that is displayed at the bottom of the list.
  final Widget? footer;

  /// The widget that is displayed to the left of the list.
  final Widget? leftSide;

  /// The widget that is displayed to the right of the list.
  final Widget? rightSide;

  /// The widget to be displayed when a list is empty.
  /// If this is not null, it will override that set in [DragAndDropLists.contentsWhenEmpty].
  final Widget? contentsWhenEmpty;

  /// The widget to be displayed as the last element in the list that will accept
  /// a dragged item.
  final Widget? lastTarget;

  /// The decoration displayed around a list.
  /// If this is not null, it will override that set in [DragAndDropLists.listDecoration].
  final Decoration? decoration;

  /// The vertical alignment of the contents in this list.
  /// If this is not null, it will override that set in [DragAndDropLists.verticalAlignment].
  final CrossAxisAlignment verticalAlignment;

  /// The horizontal alignment of the contents in this list.
  /// If this is not null, it will override that set in [DragAndDropLists.horizontalAlignment].
  final MainAxisAlignment horizontalAlignment;

  /// The child elements that will be contained in this list.
  /// It is possible to not provide any children when an empty list is desired.
  final List<DragAndDropItem> children;

  dynamic? data;
  // final String key;

  /// Whether or not this item can be dragged.
  /// Set to true if it can be reordered.
  /// Set to false if it must remain fixed.
  final bool canDrag;

  DragAndDropList({
    required this.children,
    // required this.key,
    this.data,
    this.header,
    this.footer,
    this.leftSide,
    this.rightSide,
    this.contentsWhenEmpty,
    this.lastTarget,
    this.decoration,
    this.horizontalAlignment = MainAxisAlignment.start,
    this.verticalAlignment = CrossAxisAlignment.start,
    this.canDrag = true,
  });

  @override
  Widget generateWidget(DragAndDropBuilderParameters params) {
    var contents = <Widget>[];
    if (params.axis == Axis.horizontal) {
      return _generateHorizontalWidget(params);
    }
    if (header != null) {
      contents.add(Flexible(child: header!));
    }
    Widget intrinsicHeight = IntrinsicHeight(
      child: Row(
        mainAxisAlignment: horizontalAlignment,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _generateDragAndDropListInnerContents(params),
      ),
    );
    if (params.axis == Axis.horizontal) {
      intrinsicHeight = Container(
        width: params.listWidth,
        child: intrinsicHeight,
      );
    }
    if (params.listInnerDecoration != null) {
      intrinsicHeight = Container(
        decoration: params.listInnerDecoration,
        child: intrinsicHeight,
      );
    }
    contents.add(intrinsicHeight);

    if (footer != null) {
      contents.add(Flexible(child: footer!));
    }

    return Container(
      width: params.axis == Axis.vertical
          ? double.infinity
          : params.listWidth - params.listPadding!.horizontal,
      decoration: decoration ?? params.listDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: verticalAlignment,
        children: contents,
      ),
    );
  }

  /// 功能：生成桌面横向看板列。
  /// 说明：横向 ListView 会给每一列一个固定可用高度，不能再用 IntrinsicHeight 按全部任务内容撑开；
  /// 否则任务较多时列高度会突破父约束，引发 Scrollbar/ListView 的渲染断言。
  Widget _generateHorizontalWidget(DragAndDropBuilderParameters params) {
    dragBoardLog(
      'board-list-horizontal-generate',
      'itemCount=${children.length}, canDrag=$canDrag, listWidth=${params.listWidth}, listPadding=${params.listPadding}, hasHeader=${header != null}, hasFooter=${footer != null}, hasLeftSide=${leftSide != null}, hasRightSide=${rightSide != null}',
      onceKey:
          'list-horizontal-${children.length}-${params.listWidth}-${params.listPadding}-${header != null}-${footer != null}',
    );
    final Widget innerContent = Row(
      mainAxisAlignment: horizontalAlignment,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _generateDragAndDropListInnerContents(params),
    );
    final List<Widget> columnChildren = [];
    if (header != null) {
      columnChildren.add(header!);
    }
    columnChildren.add(
      Expanded(
        child: Container(
          width: params.listWidth,
          child: innerContent,
        ),
      ),
    );
    if (footer != null) {
      columnChildren.add(footer!);
    }
    return Container(
      width: params.listWidth - (params.listPadding?.horizontal ?? 0),
      decoration: decoration ?? params.listDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: verticalAlignment,
        children: columnChildren,
      ),
    );
  }

  List<Widget> _generateDragAndDropListInnerContents(
      DragAndDropBuilderParameters parameters) {
    var contents = <Widget>[];
    if (leftSide != null) {
      contents.add(leftSide!);
    }
    if (children.isNotEmpty) {
      List<Widget> allChildren = <Widget>[];
      if (parameters.addLastItemTargetHeightToTop) {
        allChildren.add(Padding(
          padding: EdgeInsets.only(top: parameters.lastItemTargetHeight),
        ));
      }
      for (int i = 0; i < children.length; i++) {
        allChildren.add(DragAndDropItemWrapper(
          child: children[i],
          parameters: parameters,
        ));
        if (parameters.itemDivider != null && i < children.length - 1) {
          allChildren.add(parameters.itemDivider!);
        }
      }
      allChildren.add(DragAndDropItemTarget(
        parent: this,
        parameters: parameters,
        onReorderOrAdd: parameters.onItemDropOnLastTarget!,
        child: lastTarget ??
            Container(
              height: parameters.lastItemTargetHeight,
            ),
      ));
      contents.add(
        Expanded(
          child: SingleChildScrollView(
            // 横向看板的每一列需要在固定列高内独立纵向滚动；竖向模式继续交给外层列表滚动。
            physics: parameters.axis == Axis.horizontal
                ? ClampingScrollPhysics()
                : NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: verticalAlignment,
              mainAxisSize: MainAxisSize.max,
              children: allChildren,
            ),
          ),
        ),
      );
    } else {
      contents.add(
        Expanded(
          child: SingleChildScrollView(
            // 空列也保持同一套滚动约束，避免拖拽目标在横向看板里撑破列高度。
            physics: parameters.axis == Axis.horizontal
                ? ClampingScrollPhysics()
                : NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                contentsWhenEmpty ??
                    Text(
                      'Empty list',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                DragAndDropItemTarget(
                  parent: this,
                  parameters: parameters,
                  onReorderOrAdd: parameters.onItemDropOnLastTarget!,
                  child: lastTarget ??
                      Container(
                        height: parameters.lastItemTargetHeight,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (rightSide != null) {
      contents.add(rightSide!);
    }
    return contents;
  }
}
