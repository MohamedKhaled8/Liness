import 'package:flutter/material.dart';

/// Custom wrapper to handle mouse tracking issues
class MouseTrackerWrapper extends StatefulWidget {
  final Widget child;
  final bool enableMouseTracking;

  const MouseTrackerWrapper({
    Key? key,
    required this.child,
    this.enableMouseTracking = true,
  }) : super(key: key);

  @override
  State<MouseTrackerWrapper> createState() => _MouseTrackerWrapperState();
}

class _MouseTrackerWrapperState extends State<MouseTrackerWrapper> {
  @override
  Widget build(BuildContext context) {
    if (!widget.enableMouseTracking) {
      return widget.child;
    }

    return MouseRegion(
      onEnter: (event) {
        if (mounted) {
          // Handle mouse enter
        }
      },
      onExit: (event) {
        if (mounted) {
          // Handle mouse exit
        }
      },
      onHover: (event) {
        // Handle hover events if needed
      },
      child: widget.child,
    );
  }
}

/// Safe navigation wrapper to prevent mouse tracker issues
class SafeNavigationWrapper extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final List<Widget> screens;
  final Function(int) onIndexChanged;

  const SafeNavigationWrapper({
    Key? key,
    required this.child,
    required this.currentIndex,
    required this.screens,
    required this.onIndexChanged,
  }) : super(key: key);

  @override
  State<SafeNavigationWrapper> createState() => _SafeNavigationWrapperState();
}

class _SafeNavigationWrapperState extends State<SafeNavigationWrapper> {
  bool _isTransitioning = false;

  @override
  void didUpdateWidget(SafeNavigationWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex) {
      _handleIndexChange();
    }
  }

  void _handleIndexChange() {
    if (_isTransitioning) return;

    setState(() {
      _isTransitioning = true;
    });

    // Add a small delay to prevent mouse tracker issues
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          _isTransitioning = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseTrackerWrapper(
      child: IndexedStack(
        index: widget.currentIndex,
        children: widget.screens,
      ),
    );
  }
}

/// Enhanced navigation bar with better mouse handling
class EnhancedNavigationBar extends StatefulWidget {
  final int currentIndex;
  final List<Widget> items;
  final Function(int) onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const EnhancedNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  }) : super(key: key);

  @override
  State<EnhancedNavigationBar> createState() => _EnhancedNavigationBarState();
}

class _EnhancedNavigationBarState extends State<EnhancedNavigationBar> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return MouseTrackerWrapper(
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.items.asMap().entries.map((entry) {
            int index = entry.key;
            Widget item = entry.value;

            return Expanded(
              child: MouseRegion(
                onEnter: (_) {
                  if (mounted) {
                    setState(() {
                      _hoveredIndex = index;
                    });
                  }
                },
                onExit: (_) {
                  if (mounted) {
                    setState(() {
                      _hoveredIndex = -1;
                    });
                  }
                },
                child: GestureDetector(
                  onTap: () {
                    widget.onTap(index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: (widget.currentIndex == index ||
                              _hoveredIndex == index)
                          ? (widget.selectedItemColor ?? Colors.blue)
                              .withOpacity(0.1)
                          : Colors.transparent,
                    ),
                    child: item,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
