import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/app_cubit/app_cubit.dart';
import 'package:liness/core/app_cubit/app_state.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'dart:math' as math;

/// Custom animated theme wrapper with ripple effect
class AnimatedThemeWrapper extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;
  final Curve animationCurve;

  const AnimatedThemeWrapper({
    Key? key,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationCurve = Curves.easeInOutCubic,
  }) : super(key: key);

  @override
  State<AnimatedThemeWrapper> createState() => _AnimatedThemeWrapperState();
}

class _AnimatedThemeWrapperState extends State<AnimatedThemeWrapper>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _fadeController;
  late Animation<double> _rippleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isDarkMode = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _rippleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Initialize animations
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: widget.animationCurve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: ColorsManger.white.withOpacity(0.0),
      end: ColorsManger.mainBlue.withOpacity(0.3),
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: widget.animationCurve,
    ));

    // Get initial theme state
    final appCubit = context.read<AppCubit>();
    _isDarkMode = appCubit.isDarkMode();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _startThemeTransition() {
    if (_isAnimating || !mounted) return;

    setState(() {
      _isAnimating = true;
    });

    if (_rippleController.isAnimating || _rippleController.isCompleted) {
      _rippleController.reset();
    }

    if (_fadeController.isAnimating || _fadeController.isCompleted) {
      _fadeController.reset();
    }

    // Start ripple animation
    _rippleController.forward().then((_) {
      if (mounted) {
        // Reset for next animation
        _rippleController.reset();
        setState(() {
          _isAnimating = false;
        });
      }
    });

    // Start fade animation
    _fadeController.forward().then((_) {
      if (mounted) {
        _fadeController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listenWhen: (previous, current) => current is AppStateChangeTheme,
      listener: (context, state) {
        if (state is AppStateChangeTheme) {
          _startThemeTransition();
        }
      },
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen: (previous, current) => current is AppStateChangeTheme,
        builder: (context, state) {
          final appCubit = context.read<AppCubit>();
          _isDarkMode = appCubit.isDarkMode();

          return AnimatedBuilder(
            animation: Listenable.merge([_rippleController, _fadeController]),
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Main content with fade animation
                  AnimatedOpacity(
                    opacity: _fadeAnimation.value,
                    duration: const Duration(milliseconds: 200),
                    child: widget.child,
                  ),

                  // Ripple effect overlay
                  if (_isAnimating)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: RipplePainter(
                          animation: _rippleAnimation,
                          color: _colorAnimation.value ?? Colors.transparent,
                          isDarkMode: _isDarkMode,
                        ),
                      ),
                    ),

                  // Subtle glow effect
                  if (_isAnimating)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: _rippleAnimation.value * 2,
                            colors: [
                              (_isDarkMode
                                      ? ColorsManger.mainBlue
                                      : ColorsManger.primaryColor)
                                  .withOpacity(_rippleAnimation.value * 0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// Custom painter for ripple effect
class RipplePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final bool isDarkMode;

  RipplePainter({
    required this.animation,
    required this.color,
    required this.isDarkMode,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width > size.height ? size.width : size.height;

    // Create multiple ripple circles
    for (int i = 0; i < 3; i++) {
      final delay = i * 0.2;
      final progress = (animation.value - delay).clamp(0.0, 1.0);

      if (progress > 0) {
        final radius = progress * maxRadius * 0.8;
        final opacity = (1.0 - progress) * 0.3;

        paint.color = color.withOpacity(opacity);
        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return animation != oldDelegate.animation ||
        color != oldDelegate.color ||
        isDarkMode != oldDelegate.isDarkMode;
  }
}

/// Alternative wave transition effect
class WaveThemeTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const WaveThemeTransition({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  @override
  State<WaveThemeTransition> createState() => _WaveThemeTransitionState();
}

class _WaveThemeTransitionState extends State<WaveThemeTransition>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listenWhen: (previous, current) => current is AppStateChangeTheme,
      listener: (context, state) {
        if (state is AppStateChangeTheme) {
          _waveController.forward().then((_) {
            _waveController.reset();
          });
        }
      },
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: WavePainter(
              animation: _waveAnimation,
              isDarkMode: context.read<AppCubit>().isDarkMode(),
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Wave painter for wave transition effect
class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final bool isDarkMode;

  WavePainter({
    required this.animation,
    required this.isDarkMode,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (animation.value == 0) return;

    final paint = Paint()
      ..color = (isDarkMode ? ColorsManger.mainBlue : ColorsManger.primaryColor)
          .withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = size.height * 0.1;
    final waveLength = size.width * 0.5;

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x += 1) {
      final y = size.height -
          (waveHeight *
              math.sin((x / waveLength) * 2 * math.pi +
                  animation.value * 2 * math.pi));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return animation != oldDelegate.animation ||
        isDarkMode != oldDelegate.isDarkMode;
  }
}
