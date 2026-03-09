import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/app_cubit/app_cubit.dart';
import 'package:liness/core/app_cubit/app_state.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'dart:math' as math;

/// Advanced theme transition with multiple effects
class AdvancedThemeTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final TransitionType transitionType;

  const AdvancedThemeTransition({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1200),
    this.transitionType = TransitionType.ripple,
  }) : super(key: key);

  @override
  State<AdvancedThemeTransition> createState() =>
      _AdvancedThemeTransitionState();
}

enum TransitionType {
  ripple,
  wave,
  spiral,
  explosion,
  morphing,
}

class _AdvancedThemeTransitionState extends State<AdvancedThemeTransition>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _secondaryController;
  late Animation<double> _mainAnimation;
  late Animation<double> _secondaryAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isDarkMode = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _secondaryController = AnimationController(
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
      vsync: this,
    );

    _mainAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOutCubic),
    );

    _secondaryAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _secondaryController, curve: Curves.elasticOut),
    );

    _colorAnimation = ColorTween(
      begin: ColorsManger.primaryColor.withOpacity(0.0),
      end: ColorsManger.mainBlue.withOpacity(0.4),
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeInOut,
    ));

    final appCubit = context.read<AppCubit>();
    _isDarkMode = appCubit.isDarkMode();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _secondaryController.dispose();
    super.dispose();
  }

  void _startTransition() {
    if (_isAnimating || !mounted) return;

    setState(() {
      _isAnimating = true;
    });

    if (_mainController.isAnimating || _mainController.isCompleted) {
      _mainController.reset();
    }

    if (_secondaryController.isAnimating || _secondaryController.isCompleted) {
      _secondaryController.reset();
    }

    _mainController.forward().then((_) {
      if (mounted) {
        _mainController.reset();
        setState(() {
          _isAnimating = false;
        });
      }
    });

    _secondaryController.forward().then((_) {
      if (mounted) {
        _secondaryController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listenWhen: (previous, current) => current is AppStateChangeTheme,
      listener: (context, state) {
        if (state is AppStateChangeTheme) {
          _startTransition();
        }
      },
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen: (previous, current) => current is AppStateChangeTheme,
        builder: (context, state) {
          final appCubit = context.read<AppCubit>();
          _isDarkMode = appCubit.isDarkMode();

          return AnimatedBuilder(
            animation:
                Listenable.merge([_mainController, _secondaryController]),
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Main content with subtle fade
                  AnimatedOpacity(
                    opacity: 1.0 - (_mainAnimation.value * 0.1),
                    duration: const Duration(milliseconds: 100),
                    child: widget.child,
                  ),

                  // Transition effect overlay
                  if (_isAnimating)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _getTransitionPainter(),
                      ),
                    ),

                  // Particle effects
                  if (_isAnimating &&
                      widget.transitionType == TransitionType.explosion)
                    ..._buildParticles(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  CustomPainter _getTransitionPainter() {
    switch (widget.transitionType) {
      case TransitionType.ripple:
        return RippleTransitionPainter(
          animation: _mainAnimation,
          color: _colorAnimation.value ?? Colors.transparent,
          isDarkMode: _isDarkMode,
        );
      case TransitionType.wave:
        return WaveTransitionPainter(
          animation: _mainAnimation,
          secondaryAnimation: _secondaryAnimation,
          isDarkMode: _isDarkMode,
        );
      case TransitionType.spiral:
        return SpiralTransitionPainter(
          animation: _mainAnimation,
          color: _colorAnimation.value ?? Colors.transparent,
          isDarkMode: _isDarkMode,
        );
      case TransitionType.morphing:
        return MorphingTransitionPainter(
          animation: _mainAnimation,
          secondaryAnimation: _secondaryAnimation,
          isDarkMode: _isDarkMode,
        );
      case TransitionType.explosion:
        return ExplosionTransitionPainter(
          animation: _mainAnimation,
          secondaryAnimation: _secondaryAnimation,
          isDarkMode: _isDarkMode,
        );
    }
  }

  List<Widget> _buildParticles() {
    return List.generate(20, (index) {
      return Positioned(
        left: MediaQuery.of(context).size.width * (0.2 + (index % 3) * 0.2),
        top: MediaQuery.of(context).size.height * (0.3 + (index % 4) * 0.15),
        child: AnimatedBuilder(
          animation: _secondaryAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _secondaryAnimation.value,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: _isDarkMode
                      ? ColorsManger.mainBlue
                      : ColorsManger.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

/// Ripple transition painter
class RippleTransitionPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final bool isDarkMode;

  RippleTransitionPainter({
    required this.animation,
    required this.color,
    required this.isDarkMode,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.max(size.width, size.height);

    // Multiple ripple circles with different delays
    for (int i = 0; i < 4; i++) {
      final delay = i * 0.15;
      final progress = (animation.value - delay).clamp(0.0, 1.0);

      if (progress > 0) {
        final radius = progress * maxRadius * 0.6;
        final opacity = (1.0 - progress) * 0.4;

        paint.color =
            (isDarkMode ? ColorsManger.mainBlue : ColorsManger.primaryColor)
                .withOpacity(opacity);

        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(RippleTransitionPainter oldDelegate) {
    return animation != oldDelegate.animation ||
        color != oldDelegate.color ||
        isDarkMode != oldDelegate.isDarkMode;
  }
}

/// Wave transition painter
class WaveTransitionPainter extends CustomPainter {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final bool isDarkMode;

  WaveTransitionPainter({
    required this.animation,
    required this.secondaryAnimation,
    required this.isDarkMode,
  }) : super(repaint: Listenable.merge([animation, secondaryAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDarkMode ? ColorsManger.mainBlue : ColorsManger.primaryColor)
          .withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = size.height * 0.15;
    final waveLength = size.width * 0.3;

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x += 2) {
      final y = size.height -
          (waveHeight *
              math.sin((x / waveLength) * 2 * math.pi +
                  animation.value * 4 * math.pi +
                  secondaryAnimation.value * 2 * math.pi));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaveTransitionPainter oldDelegate) {
    return animation != oldDelegate.animation ||
        secondaryAnimation != oldDelegate.secondaryAnimation ||
        isDarkMode != oldDelegate.isDarkMode;
  }
}

/// Spiral transition painter
class SpiralTransitionPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final bool isDarkMode;

  SpiralTransitionPainter({
    required this.animation,
    required this.color,
    required this.isDarkMode,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDarkMode ? ColorsManger.mainBlue : ColorsManger.primaryColor)
          .withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) * 0.4;

    final path = Path();
    final turns = 3.0;
    final points = 200;

    for (int i = 0; i <= points; i++) {
      final t = i / points;
      final angle = t * turns * 2 * math.pi;
      final radius = t * maxRadius * animation.value;

      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SpiralTransitionPainter oldDelegate) {
    return animation != oldDelegate.animation ||
        color != oldDelegate.color ||
        isDarkMode != oldDelegate.isDarkMode;
  }
}

/// Morphing transition painter
class MorphingTransitionPainter extends CustomPainter {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final bool isDarkMode;

  MorphingTransitionPainter({
    required this.animation,
    required this.secondaryAnimation,
    required this.isDarkMode,
  }) : super(repaint: Listenable.merge([animation, secondaryAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDarkMode ? ColorsManger.mainBlue : ColorsManger.primaryColor)
          .withOpacity(0.25)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.3;

    // Create morphing shape
    final path = Path();
    final sides = 6 + (secondaryAnimation.value * 6).round();

    for (int i = 0; i < sides; i++) {
      final angle = (i / sides) * 2 * math.pi;
      final morphFactor = animation.value;
      final currentRadius = radius * (1.0 + morphFactor * 0.5);

      final x = center.dx + currentRadius * math.cos(angle);
      final y = center.dy + currentRadius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MorphingTransitionPainter oldDelegate) {
    return animation != oldDelegate.animation ||
        secondaryAnimation != oldDelegate.secondaryAnimation ||
        isDarkMode != oldDelegate.isDarkMode;
  }
}

/// Explosion transition painter
class ExplosionTransitionPainter extends CustomPainter {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final bool isDarkMode;

  ExplosionTransitionPainter({
    required this.animation,
    required this.secondaryAnimation,
    required this.isDarkMode,
  }) : super(repaint: Listenable.merge([animation, secondaryAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDarkMode ? ColorsManger.mainBlue : ColorsManger.primaryColor)
          .withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.max(size.width, size.height) * 0.5;

    // Draw explosion rays
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * math.pi;
      final rayLength = maxRadius * animation.value;

      final endX = center.dx + rayLength * math.cos(angle);
      final endY = center.dy + rayLength * math.sin(angle);

      paint.strokeWidth = 4 - (animation.value * 3);
      paint.style = PaintingStyle.stroke;

      canvas.drawLine(center, Offset(endX, endY), paint);
    }

    // Draw center circle
    paint.style = PaintingStyle.fill;
    paint.color =
        (isDarkMode ? ColorsManger.mainBlue : ColorsManger.primaryColor)
            .withOpacity(0.6);

    canvas.drawCircle(center, 20 * secondaryAnimation.value, paint);
  }

  @override
  bool shouldRepaint(ExplosionTransitionPainter oldDelegate) {
    return animation != oldDelegate.animation ||
        secondaryAnimation != oldDelegate.secondaryAnimation ||
        isDarkMode != oldDelegate.isDarkMode;
  }
}
