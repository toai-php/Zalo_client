import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const double iconStartSize = 44;
const double iconEndSize = 120;
const double iconStartMarginTop = 36;
const double iconEndMarginTop = 80;
const double iconsVerticalSpacing = 24;
const double iconsHorizontalSpacing = 16;

class ExhibitionBottomSheet extends StatefulWidget {
  const ExhibitionBottomSheet({
    Key? key,
    this.controller,
    this.maxHeight = 700.0,
    this.minHeight = 200.0,
    this.topWidget,
    this.child,
    this.childBuilder,
    this.color = Colors.white,
  }) : super(key: key);

  final BottomSheetController? controller;

  final Widget? topWidget;
  final Widget? child;
  final Widget Function(ScrollController sc)? childBuilder;

  final Color color;

  final double maxHeight;
  final double minHeight;

  @override
  _ExhibitionBottomSheetState createState() => _ExhibitionBottomSheetState();
}

class _ExhibitionBottomSheetState extends State<ExhibitionBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late ScrollController _sc;

  late double maxHeight;

  late double minHeight;

  double get headerTopMargin =>
      lerp(20, 20 + MediaQuery.of(context).padding.top);

  double get headerFontSize => lerp(14, 24);

  double get itemBorderRadius => lerp(8, 24);

  double get iconLeftBorderRadius => itemBorderRadius;

  double get iconRightBorderRadius => lerp(8, 0);

  double get iconSize => lerp(iconStartSize, iconEndSize);

  bool get _isPanelOpen {
    return isShowed && (currHeight > 0);
  }

  bool get _isPanelClosed => (isShowed == false) || (currHeight <= 0);

  bool isShowed = true;

  bool scrollingEnabled = false;

  final VelocityTracker _vt = VelocityTracker.withKind(PointerDeviceKind.touch);

  double iconTopMargin(int index) =>
      lerp(iconStartMarginTop,
          iconEndMarginTop + index * (iconsVerticalSpacing + iconEndSize)) +
      headerTopMargin;

  double iconLeftMargin(int index) =>
      lerp(index * (iconsHorizontalSpacing + iconStartSize), 0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _sc = ScrollController();
    _sc.addListener(() {
      if (!scrollingEnabled) _sc.jumpTo(0);
    });
    maxHeight = widget.maxHeight;
    minHeight = widget.minHeight;
    currHeight = minHeight;
    widget.controller?._addState(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double currHeight = 0;

  double lerp(double min, double max) {
    currHeight = lerpDouble(min, max, _controller.value) ?? 0;
    return currHeight;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: isShowed ? math.min(widget.minHeight, currHeight) : 0,
              child: widget.topWidget ?? Container(),
            ),
            Positioned(
                height: isShowed ? lerp(minHeight, maxHeight) : 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Listener(
                  onPointerDown: (PointerDownEvent p) =>
                      _vt.addPosition(p.timeStamp, p.position),
                  onPointerMove: (PointerMoveEvent p) {
                    _vt.addPosition(p.timeStamp,
                        p.position); // add current position for velocity tracking
                    _onGestureSlide(p.delta.dy);
                  },
                  onPointerUp: (PointerUpEvent p) =>
                      _onGestureEnd(_vt.getVelocity()),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.color,
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                      ),
                    ),
                    child: widget.child ?? widget.childBuilder!(_sc),
                  ),
                )),
          ],
        );
      },
    );
  }

  Widget _gestureHandler({required Widget child}) {
    if (widget.child != null) {
      return GestureDetector(
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        child: child,
      );
    }

    return Listener(
      onPointerDown: (PointerDownEvent p) =>
          _vt.addPosition(p.timeStamp, p.position),
      onPointerMove: (PointerMoveEvent p) {
        _vt.addPosition(p.timeStamp,
            p.position); // add current position for velocity tracking
        _onGestureSlide(p.delta.dy);
      },
      onPointerUp: (PointerUpEvent p) => _onGestureEnd(_vt.getVelocity()),
      child: child,
    );
  }

  void _onGestureEnd(Velocity velo) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed ||
        _controller.value == 1.0) return;
    if (currHeight >= widget.minHeight) {
      minHeight = widget.minHeight;
      _controller.value = (currHeight - minHeight) / (maxHeight - minHeight);
    } else {
      maxHeight = widget.minHeight;
      _controller.value = currHeight / maxHeight;
    }

    final double flingVelocity = velo.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0) {
      _controller.fling(velocity: math.max(2.0, -flingVelocity)).then((value) {
        if (currHeight == widget.minHeight) {
          minHeight = widget.minHeight;
          maxHeight = widget.maxHeight;
          _controller.value = 0.0;
        }
      });
    } else if (flingVelocity > 0.0) {
      _controller.fling(velocity: math.min(-2.0, -flingVelocity)).then((value) {
        if (currHeight == widget.minHeight) {
          minHeight = widget.minHeight;
          maxHeight = widget.maxHeight;
          _controller.value = 0.0;
        }
      });
    } else {
      _controller
          .fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0)
          .then((value) {
        if (currHeight == widget.minHeight) {
          minHeight = widget.minHeight;
          maxHeight = widget.maxHeight;
          _controller.value = 0.0;
        }
      });
    }
  }

  void _onGestureSlide(double dy) {
    if (!scrollingEnabled) {
      if (minHeight != 0 || maxHeight != widget.maxHeight) {
        minHeight = 0;
        maxHeight = widget.maxHeight;
        _controller.value = currHeight / maxHeight;
      } else {
        _controller.value -= (dy) / maxHeight;
      }
    }

    if (currHeight == widget.maxHeight && _sc.hasClients && _sc.offset <= 0) {
      setState(() {
        if (dy < 0) {
          scrollingEnabled = true;
        } else {
          scrollingEnabled = false;
        }
      });
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!scrollingEnabled) {
      if (minHeight != 0 || maxHeight != widget.maxHeight) {
        minHeight = 0;
        maxHeight = widget.maxHeight;
        _controller.value = currHeight / maxHeight;
        return;
      }
      _controller.value -= (details.primaryDelta ?? 0) / maxHeight;
    }

    if (_controller.value == 1.0 && _sc.hasClients && _sc.offset <= 0) {
      setState(() {
        if (details.delta.dy < 0) {
          scrollingEnabled = true;
        } else {
          scrollingEnabled = false;
        }
      });
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    if (currHeight >= widget.minHeight) {
      minHeight = widget.minHeight;
      _controller.value = (currHeight - minHeight) / (maxHeight - minHeight);
    } else {
      maxHeight = widget.minHeight;
      _controller.value = currHeight / maxHeight;
    }

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0) {
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    } else if (flingVelocity > 0.0) {
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    } else {
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
    }
  }

  Future<void> _close() {
    minHeight = 0;
    maxHeight = widget.minHeight;
    _controller.value = 1;
    return _controller.fling(velocity: -4.0).then((value) {
      isShowed = false;
    });
  }

  Future<void> _open() {
    minHeight = 0;
    maxHeight = widget.minHeight;
    _controller.value = 0;
    isShowed = true;
    return _controller.fling(velocity: 4.0);
  }
}

class BottomSheetController {
  _ExhibitionBottomSheetState? _panelState;

  void _addState(_ExhibitionBottomSheetState panelState) {
    _panelState = panelState;
  }

  bool get isAttached => _panelState != null;

  double get sheetHeight {
    print("object");
    return _panelState?.headerFontSize ?? 0;
  }

  Future<void> close() {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState!._close();
  }

  Future<void> open() {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState!._open();
  }

  bool get isPanelOpen {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState!._isPanelOpen;
  }

  /// Returns whether or not the
  /// panel is closed.
  bool get isPanelClosed {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState!._isPanelClosed;
  }
}
