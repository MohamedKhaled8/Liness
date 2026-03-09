import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/app_cubit/app_cubit.dart';
import 'package:liness/core/app_cubit/app_state.dart';
import 'package:liness/core/utils/constant/color_manger.dart';

class CustomThemeToggle extends StatefulWidget {
  final double? width;
  final double? height;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final Duration animationDuration;
  final Curve animationCurve;

  const CustomThemeToggle({
    Key? key,
    this.width,
    this.height,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  }) : super(key: key);

  @override
  State<CustomThemeToggle> createState() => _CustomThemeToggleState();
}

class _CustomThemeToggleState extends State<CustomThemeToggle>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _thumbAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _thumbAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    );

    _colorAnimation =
        ColorTween(
          begin: widget.inactiveColor ?? ColorsManger.white,
          end: widget.activeColor ?? ColorsManger.primaryColor,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: widget.animationCurve,
          ),
        );

    // Initialize animation state based on current theme
    final appCubit = context.read<AppCubit>();
    if (appCubit.isDarkMode()) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) => current is AppStateChangeTheme,
      builder: (context, state) {
        final appCubit = context.read<AppCubit>();
        final isDarkMode = appCubit.isDarkMode();

        // Update animation when theme changes
        if (isDarkMode && _animationController.value != 1.0) {
          _animationController.forward();
        } else if (!isDarkMode && _animationController.value != 0.0) {
          _animationController.reverse();
        }

        return GestureDetector(
          onTap: () {
            appCubit.toggleTheme();
          },
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                width: widget.width ?? 60,
                height: widget.height ?? 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: _colorAnimation.value,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background gradient effect
                    AnimatedContainer(
                      duration: widget.animationDuration,
                      curve: widget.animationCurve,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: isDarkMode
                              ? [
                                  ColorsManger.mainBlue.withOpacity(0.8),
                                  ColorsManger.primaryColor.withOpacity(0.6),
                                ]
                              : [
                                  ColorsManger.white.withOpacity(0.9),
                                  ColorsManger.primaryColor.withOpacity(0.3),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    // Thumb with smooth animation
                    AnimatedPositioned(
                      duration: widget.animationDuration,
                      curve: widget.animationCurve,
                      left:
                          _thumbAnimation.value *
                          ((widget.width ?? 60) - (widget.height ?? 30) + 4),
                      top: 2,
                      child: Container(
                        width: (widget.height ?? 30) - 4,
                        height: (widget.height ?? 30) - 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.thumbColor ?? Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: widget.animationDuration,
                          child: Icon(
                            isDarkMode
                                ? Icons.nightlight_round
                                : Icons.wb_sunny,
                            key: ValueKey(isDarkMode),
                            size: 16,
                            color: isDarkMode
                                ? ColorsManger.mainBlue
                                : ColorsManger.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    // Subtle glow effect
                    if (isDarkMode)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: ColorsManger.primaryColor.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Alternative simpler version for different use cases
class SimpleThemeToggle extends StatelessWidget {
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const SimpleThemeToggle({
    Key? key,
    this.size = 50,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) => current is AppStateChangeTheme,
      builder: (context, state) {
        final appCubit = context.read<AppCubit>();
        final isDarkMode = appCubit.isDarkMode();

        return GestureDetector(
          onTap: () {
            appCubit.toggleTheme();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode
                  ? (activeColor ?? ColorsManger.mainBlue)
                  : (inactiveColor ?? ColorsManger.white),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                key: ValueKey(isDarkMode),
                size: size * 0.5,
                color: isDarkMode ? Colors.white : ColorsManger.primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
