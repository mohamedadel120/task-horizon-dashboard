import 'package:flutter/material.dart';

class ZoomDrawerController {
  _ZoomDrawerState? _state;

  void toggle() => _state?.toggle();
  void open() => _state?.open();
  void close() => _state?.close();
  bool get isOpen => _state?.isOpen ?? false;
}

class ZoomDrawer extends StatefulWidget {
  final Widget menuScreen;
  final Widget mainScreen;
  final ZoomDrawerController controller;
  final Color backgroundColor;
  final double borderRadius;
  final double slideWidth;

  const ZoomDrawer({
    super.key,
    required this.menuScreen,
    required this.mainScreen,
    required this.controller,
    this.backgroundColor = const Color(0xFF1F1F29), // Default dark background
    this.borderRadius = 24.0,
    this.slideWidth = 260.0,
  });

  static ZoomDrawerController? of(BuildContext context) {
    final ZoomDrawerStateProvider? provider = context
        .dependOnInheritedWidgetOfExactType<ZoomDrawerStateProvider>();
    return provider?.controller;
  }

  @override
  State<ZoomDrawer> createState() => _ZoomDrawerState();
}

class _ZoomDrawerState extends State<ZoomDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    widget.controller._state = this;
  }

  void toggle() {
    // If it's mostly closed, open it. Otherwise close it.
    if (_animationController.value < 0.5) {
      open();
    } else {
      close();
    }
  }

  void open() {
    _animationController.forward();
  }

  void close() {
    _animationController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  bool get isOpen =>
      _animationController.isCompleted ||
      _animationController.status == AnimationStatus.forward;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double slide = widget.slideWidth;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return ZoomDrawerStateProvider(
      controller: widget.controller,
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        body: Stack(
          children: [
            // Menu Screen (Background)
            // Align menu to the end (Right for LTR, Left for RTL) - inverted
            PositionedDirectional(
              end: 0,
              top: 0,
              bottom: 0,
              width: slide,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  // Track the drag and update animation value
                  // For RTL (drawer on left): swipe right (positive delta) to close
                  // For LTR (drawer on right): swipe left (negative delta) to close
                  final dragDelta = details.primaryDelta ?? 0;
                  final shouldClose = isRtl ? dragDelta < 0 : dragDelta > 0;

                  if (shouldClose) {
                    // Update animation based on drag
                    final dragAmount = dragDelta.abs() / slide;
                    _animationController.value =
                        (_animationController.value - dragAmount).clamp(
                          0.0,
                          1.0,
                        );
                  }
                },
                onHorizontalDragEnd: (details) {
                  // Use fling animation for smoother closing based on velocity
                  final velocity = details.primaryVelocity ?? 0;
                  final velocityThreshold = 800; // pixels/second

                  // Calculate if user is flinging to close
                  final isFlingClose = isRtl
                      ? velocity < -velocityThreshold
                      : velocity > velocityThreshold;

                  if (isFlingClose) {
                    // Fast fling - close quickly with velocity-based duration
                    final flingVelocity = velocity.abs() / 1000; // Scale down
                    _animationController.fling(
                      velocity: -flingVelocity, // Negative to close
                    );
                  } else if (_animationController.value < 0.5) {
                    // Dragged past halfway - close with smooth curve
                    close();
                  } else {
                    // Snap back to open
                    _animationController.animateTo(
                      1.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                    );
                  }
                },
                child: SafeArea(child: widget.menuScreen),
              ),
            ),

            // Main Screen (Foreground)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                double animValue = _animationController.value;
                double scaleValue = 1 - (0.15 * animValue);

                // For RTL, slide to right (positive X). For LTR, slide to left (negative X).
                double translateX = (isRtl ? 1 : -1) * slide * animValue;

                return Transform(
                  transform: Matrix4.identity()
                    ..translate(translateX)
                    ..scale(scaleValue),
                  alignment: isRtl
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius * animValue,
                    ),
                    child: Stack(
                      children: [
                        child!,
                        // Overlay to capture taps and swipes when open to close
                        if (animValue > 0)
                          GestureDetector(
                            onTap: close,
                            onHorizontalDragUpdate: (details) {
                              // Track the drag and update animation value
                              // For RTL (drawer on left): swipe left (negative delta) to close
                              // For LTR (drawer on right): swipe right (positive delta) to close
                              final dragDelta = details.primaryDelta ?? 0;
                              final shouldClose = isRtl
                                  ? dragDelta < 0
                                  : dragDelta > 0;

                              if (shouldClose) {
                                // Update animation based on drag
                                final dragAmount = dragDelta.abs() / slide;
                                _animationController.value =
                                    (_animationController.value - dragAmount)
                                        .clamp(0.0, 1.0);
                              }
                            },
                            onHorizontalDragEnd: (details) {
                              // Use fling animation for smoother closing based on velocity
                              final velocity = details.primaryVelocity ?? 0;
                              final velocityThreshold = 800; // pixels/second

                              // Calculate if user is flinging to close
                              final isFlingClose = isRtl
                                  ? velocity < -velocityThreshold
                                  : velocity > velocityThreshold;

                              if (isFlingClose) {
                                // Fast fling - close quickly with velocity-based duration
                                final flingVelocity =
                                    velocity.abs() / 1000; // Scale down
                                _animationController.fling(
                                  velocity: -flingVelocity, // Negative to close
                                );
                              } else if (_animationController.value < 0.5) {
                                // Dragged past halfway - close with smooth curve
                                close();
                              } else {
                                // Snap back to open
                                _animationController.animateTo(
                                  1.0,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOutCubic,
                                );
                              }
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
              child: widget.mainScreen,
            ),
            // Edge Swipe Detector to OPEN
            PositionedDirectional(
              end: 0,
              top: 100, // Avoid covering the AppBar
              bottom: 0,
              width: 40.0, // Slightly wider for better touch target
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, _) {
                  // Only active when fully closed
                  if (_animationController.value > 0) {
                    return const SizedBox.shrink();
                  }

                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragUpdate: (details) {
                      // For RTL (drawer on left): swipe right (positive delta) to open
                      // For LTR (drawer on right): swipe left (negative delta) to open
                      final dragDelta = details.primaryDelta ?? 0;
                      final shouldOpen = isRtl ? dragDelta > 0 : dragDelta < 0;

                      if (shouldOpen) {
                        final dragAmount = dragDelta.abs() / slide;
                        _animationController.value =
                            (_animationController.value + dragAmount).clamp(
                              0.0,
                              1.0,
                            );
                      }
                    },
                    onHorizontalDragEnd: (details) {
                      final velocity = details.primaryVelocity ?? 0;
                      final velocityThreshold = 800;

                      // Calculate if user is flinging to open
                      // RTL: Positive velocity to open
                      // LTR: Negative velocity to open
                      final isFlingOpen = isRtl
                          ? velocity > velocityThreshold
                          : velocity < -velocityThreshold;

                      if (isFlingOpen) {
                        final flingVelocity = velocity.abs() / 1000;
                        _animationController.fling(velocity: flingVelocity);
                      } else if (_animationController.value > 0.5) {
                        open();
                      } else {
                        close();
                      }
                    },
                    child: Container(color: Colors.transparent),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ZoomDrawerStateProvider extends InheritedWidget {
  final ZoomDrawerController controller;

  const ZoomDrawerStateProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant ZoomDrawerStateProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}

