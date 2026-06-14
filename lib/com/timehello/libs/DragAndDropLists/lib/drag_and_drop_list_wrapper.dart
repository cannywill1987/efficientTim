import 'drag_and_drop_builder_parameters.dart';
import 'drag_and_drop_layout_log.dart';
import 'drag_and_drop_list_interface.dart';
import 'drag_handle.dart';
import 'measure_size.dart';
import 'package:flutter/material.dart';

class DragAndDropListWrapper extends StatefulWidget {
  final DragAndDropListInterface dragAndDropList;
  final DragAndDropBuilderParameters parameters;

  DragAndDropListWrapper(
      {required this.dragAndDropList, required this.parameters, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DragAndDropListWrapper();
}

class _DragAndDropListWrapper extends State<DragAndDropListWrapper>
    with TickerProviderStateMixin {
  DragAndDropListInterface? _hoveredDraggable;

  bool _dragging = false;
  Size _containerSize = Size.zero;
  Size _dragHandleSize = Size.zero;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dragBoardLog(
      'board-wrapper-build-start',
      'type=${widget.dragAndDropList.runtimeType}, itemCount=${widget.dragAndDropList.children?.length}, canDrag=${widget.dragAndDropList.canDrag}, axis=${widget.parameters.axis}, listWidth=${widget.parameters.listWidth}, listPadding=${widget.parameters.listPadding}, disableScrolling=${widget.parameters.disableScrolling}',
      onceKey:
          'wrapper-start-${widget.parameters.axis}-${widget.dragAndDropList.runtimeType}-${widget.dragAndDropList.children?.length}-${widget.parameters.listWidth}',
    );
    Widget dragAndDropListContents =
        widget.dragAndDropList.generateWidget(widget.parameters);

    Widget draggable;
    if (widget.dragAndDropList.canDrag) {
      if (widget.parameters.listDragHandle != null) {
        Widget dragHandle = MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: widget.parameters.listDragHandle,
        );

        Widget feedback =
            buildFeedbackWithHandle(dragAndDropListContents, dragHandle);

        draggable = MeasureSize(
          onSizeChange: (size) {
            setState(() {
              _containerSize = size!;
            });
          },
          child: Stack(
            children: [
              Visibility(
                visible: !_dragging,
                child: dragAndDropListContents,
              ),
              // dragAndDropListContents,
              Positioned(
                right: widget.parameters.listDragHandle!.onLeft ? null : 0,
                left: widget.parameters.listDragHandle!.onLeft ? 0 : null,
                top: _dragHandleDistanceFromTop(),
                child: Draggable<DragAndDropListInterface>(
                  data: widget.dragAndDropList,
                  axis: draggableAxis(),
                  child: MeasureSize(
                    onSizeChange: (size) {
                      setState(() {
                        _dragHandleSize = size!;
                      });
                    },
                    child: dragHandle,
                  ),
                  feedback: Transform.translate(
                    offset: _feedbackContainerOffset(),
                    child: feedback,
                  ),
                  childWhenDragging: Container(),
                  onDragStarted: () => _setDragging(true),
                  onDragCompleted: () => _setDragging(false),
                  onDraggableCanceled: (_, __) => _setDragging(false),
                  onDragEnd: (_) => _setDragging(false),
                ),
              ),
            ],
          ),
        );
      } else if (widget.parameters.dragOnLongPress) {
        draggable = LongPressDraggable<DragAndDropListInterface>(
          data: widget.dragAndDropList,
          axis: draggableAxis(),
          child: dragAndDropListContents,
          feedback:
              buildFeedbackWithoutHandle(context, dragAndDropListContents),
          childWhenDragging: Container(),
          onDragStarted: () => _setDragging(true),
          onDragCompleted: () => _setDragging(false),
          onDraggableCanceled: (_, __) => _setDragging(false),
          onDragEnd: (_) => _setDragging(false),
        );
      } else {
        draggable = Draggable<DragAndDropListInterface>(
          data: widget.dragAndDropList,
          axis: draggableAxis(),
          child: dragAndDropListContents,
          feedback:
              buildFeedbackWithoutHandle(context, dragAndDropListContents),
          childWhenDragging: Container(),
          onDragStarted: () => _setDragging(true),
          onDragCompleted: () => _setDragging(false),
          onDraggableCanceled: (_, __) => _setDragging(false),
          onDragEnd: (_) => _setDragging(false),
        );
      }
    } else {
      draggable = dragAndDropListContents;
    }

    var rowOrColumnChildren = <Widget>[
      AnimatedSize(
        duration:
            Duration(milliseconds: widget.parameters.listSizeAnimationDuration),
        alignment: widget.parameters.axis == Axis.vertical
            ? Alignment.bottomCenter
            : Alignment.centerLeft,
        child: _hoveredDraggable != null
            ? Opacity(
                opacity: widget.parameters.listGhostOpacity,
                child: widget.parameters.listGhost ??
                    Container(
                      padding: widget.parameters.axis == Axis.vertical
                          ? EdgeInsets.all(0)
                          : EdgeInsets.symmetric(
                              horizontal:
                                  widget.parameters.listPadding!.horizontal),
                      child:
                          _hoveredDraggable!.generateWidget(widget.parameters),
                    ),
              )
            : Container(),
      ),
      Listener(
        child: draggable,
        onPointerMove: _onPointerMove,
        onPointerDown: widget.parameters.onPointerDown,
        onPointerUp: widget.parameters.onPointerUp,
      ),
    ];

    var stack = Stack(
      children: <Widget>[
        widget.parameters.axis == Axis.vertical
            ? Column(
                children: rowOrColumnChildren,
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rowOrColumnChildren,
              ),
        Positioned.fill(
          child: DragTarget<DragAndDropListInterface>(
            builder: (context, candidateData, rejectedData) {
              if (candidateData.isNotEmpty) {}
              return Container();
            },
            onWillAccept: (incoming) {
              bool accept = true;
              if (widget.parameters.listOnWillAccept != null) {
                accept = widget.parameters.listOnWillAccept!(
                    incoming, widget.dragAndDropList);
              }
              if (accept && mounted) {
                setState(() {
                  _hoveredDraggable = incoming;
                });
              }
              return accept;
            },
            onLeave: (incoming) {
              if (_hoveredDraggable != null) {
                if (mounted) {
                  setState(() {
                    _hoveredDraggable = null;
                  });
                }
              }
            },
            onAccept: (incoming) {
              if (mounted) {
                setState(() {
                  widget.parameters.onListReordered!(
                      incoming, widget.dragAndDropList);
                  _hoveredDraggable = null;
                });
              }
            },
          ),
        ),
      ],
    );

    Widget toReturn = stack;
    if (widget.parameters.listPadding != null) {
      toReturn = Padding(
        padding: widget.parameters.listPadding!,
        child: stack,
      );
    }
    if (widget.parameters.axis == Axis.horizontal &&
        !widget.parameters.disableScrolling) {
      // 横向模式外层已经由 DragAndDropLists 的 ListView 负责横向滚动；
      // 这里不能再包默认纵向 SingleChildScrollView，否则会把 Padding/Stack 子树变成完全无约束，
      // 导致首个看板列 RenderStack 无法完成 layout，页面表现为空白。
      dragBoardLog(
        'board-wrapper-horizontal-scroll-skip',
        'type=${widget.dragAndDropList.runtimeType}, itemCount=${widget.dragAndDropList.children?.length}, listWidth=${widget.parameters.listWidth}, padding=${widget.parameters.listPadding}',
        onceKey:
            'wrapper-horizontal-scroll-skip-${widget.dragAndDropList.runtimeType}-${widget.dragAndDropList.children?.length}-${widget.parameters.listWidth}',
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // 记录每一列包装层拿到的约束，重点排查横向 ListView 子节点是否出现无限宽或缺失高度。
        dragBoardLog(
          'board-wrapper-constraints',
          '${dragBoardConstraints(constraints)}, type=${widget.dragAndDropList.runtimeType}, itemCount=${widget.dragAndDropList.children?.length}, axis=${widget.parameters.axis}',
          onceKey:
              'wrapper-constraints-${widget.parameters.axis}-${widget.dragAndDropList.runtimeType}-${widget.dragAndDropList.children?.length}-${constraints.maxWidth}-${constraints.maxHeight}',
        );
        return toReturn;
      },
    );
  }

  Material buildFeedbackWithHandle(
      Widget dragAndDropListContents, Widget dragHandle) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: widget.parameters.listDecorationWhileDragging,
        child: Container(
          width: widget.parameters.listDraggingWidth ?? _containerSize.width,
          child: Stack(
            children: [
              Directionality(
                textDirection: Directionality.of(context),
                child: dragAndDropListContents,
              ),
              Positioned(
                right: widget.parameters.listDragHandle!.onLeft ? null : 0,
                left: widget.parameters.listDragHandle!.onLeft ? 0 : null,
                top: widget.parameters.listDragHandle!.verticalAlignment ==
                        DragHandleVerticalAlignment.bottom
                    ? null
                    : 0,
                bottom: widget.parameters.listDragHandle!.verticalAlignment ==
                        DragHandleVerticalAlignment.top
                    ? null
                    : 0,
                child: dragHandle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildFeedbackWithoutHandle(
      BuildContext context, Widget dragAndDropListContents) {
    return Container(
      width: widget.parameters.axis == Axis.vertical
          ? (widget.parameters.listDraggingWidth ??
              MediaQuery.of(context).size.width)
          : (widget.parameters.listDraggingWidth ??
              widget.parameters.listWidth),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: widget.parameters.listDecorationWhileDragging,
          child: Directionality(
            textDirection: Directionality.of(context),
            child: dragAndDropListContents,
          ),
        ),
      ),
    );
  }

  Axis? draggableAxis() {
    return widget.parameters.axis == Axis.vertical &&
            widget.parameters.constrainDraggingAxis
        ? Axis.vertical
        : null;
  }

  double _dragHandleDistanceFromTop() {
    switch (widget.parameters.listDragHandle!.verticalAlignment) {
      case DragHandleVerticalAlignment.top:
        return 0;
      case DragHandleVerticalAlignment.center:
        return (_containerSize.height / 2.0) - (_dragHandleSize.height / 2.0);
      case DragHandleVerticalAlignment.bottom:
        return _containerSize.height - _dragHandleSize.height;
      default:
        return 0;
    }
  }

  Offset _feedbackContainerOffset() {
    double xOffset;
    double yOffset;
    if (widget.parameters.listDragHandle!.onLeft) {
      xOffset = 0;
    } else {
      xOffset = -_containerSize.width + _dragHandleSize.width;
    }
    if (widget.parameters.listDragHandle!.verticalAlignment ==
        DragHandleVerticalAlignment.bottom) {
      yOffset = -_containerSize.height + _dragHandleSize.width;
    } else {
      yOffset = 0;
    }

    return Offset(xOffset, yOffset);
  }

  void _setDragging(bool dragging) {
    if (_dragging != dragging && mounted) {
      setState(() {
        _dragging = dragging;
      });
      if (widget.parameters.onListDraggingChanged != null) {
        widget.parameters.onListDraggingChanged!(
            widget.dragAndDropList, dragging);
      }
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_dragging) widget.parameters.onPointerMove!(event);
  }
}
