import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/app_cubit/app_cubit.dart';
import 'package:liness/core/app_cubit/app_state.dart';
import 'package:liness/core/utils/widgets/custom_theme_toggle.dart';
import 'package:liness/core/utils/widgets/advanced_theme_transition.dart';
import 'package:liness/core/utils/constant/color_manger.dart';

/// Settings screen to customize theme transition animations
class ThemeAnimationSettings extends StatefulWidget {
  const ThemeAnimationSettings({Key? key}) : super(key: key);

  @override
  State<ThemeAnimationSettings> createState() => _ThemeAnimationSettingsState();
}

class _ThemeAnimationSettingsState extends State<ThemeAnimationSettings> {
  TransitionType _selectedTransition = TransitionType.ripple;
  Duration _selectedDuration = const Duration(milliseconds: 1000);

  final List<TransitionType> _transitionTypes = [
    TransitionType.ripple,
    TransitionType.wave,
    TransitionType.spiral,
    TransitionType.morphing,
    TransitionType.explosion,
  ];

  final List<Duration> _durations = [
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 800),
    const Duration(milliseconds: 1000),
    const Duration(milliseconds: 1200),
    const Duration(milliseconds: 1500),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Animation Settings'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SimpleThemeToggle(
              size: 40,
              activeColor: ColorsManger.mainBlue,
              inactiveColor: ColorsManger.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current theme toggle
            Card(
              child: ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Theme Toggle'),
                subtitle: const Text('Switch between light and dark mode'),
                trailing: CustomThemeToggle(
                  width: 50,
                  height: 25,
                  activeColor: ColorsManger.mainBlue,
                  inactiveColor: ColorsManger.white.withOpacity(0.3),
                  thumbColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Transition type selection
            const Text(
              'Transition Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ..._transitionTypes.map((type) {
              return RadioListTile<TransitionType>(
                title: Text(_getTransitionName(type)),
                subtitle: Text(_getTransitionDescription(type)),
                value: type,
                groupValue: _selectedTransition,
                onChanged: (value) {
                  setState(() {
                    _selectedTransition = value!;
                  });
                },
              );
            }).toList(),

            const SizedBox(height: 20),

            // Duration selection
            const Text(
              'Animation Duration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ..._durations.map((duration) {
              return RadioListTile<Duration>(
                title: Text('${duration.inMilliseconds}ms'),
                subtitle: Text(_getDurationDescription(duration)),
                value: duration,
                groupValue: _selectedDuration,
                onChanged: (value) {
                  setState(() {
                    _selectedDuration = value!;
                  });
                },
              );
            }).toList(),

            const SizedBox(height: 30),

            // Preview button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showPreviewDialog();
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Preview Animation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManger.mainBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTransitionName(TransitionType type) {
    switch (type) {
      case TransitionType.ripple:
        return 'Ripple Effect';
      case TransitionType.wave:
        return 'Wave Effect';
      case TransitionType.spiral:
        return 'Spiral Effect';
      case TransitionType.morphing:
        return 'Morphing Effect';
      case TransitionType.explosion:
        return 'Explosion Effect';
    }
  }

  String _getTransitionDescription(TransitionType type) {
    switch (type) {
      case TransitionType.ripple:
        return 'Smooth circular ripples expanding from center';
      case TransitionType.wave:
        return 'Wave-like animation across the screen';
      case TransitionType.spiral:
        return 'Spiral pattern expanding outward';
      case TransitionType.morphing:
        return 'Shape morphing with geometric patterns';
      case TransitionType.explosion:
        return 'Explosive effect with particles and rays';
    }
  }

  String _getDurationDescription(Duration duration) {
    if (duration.inMilliseconds <= 600) {
      return 'Fast and snappy';
    } else if (duration.inMilliseconds <= 1000) {
      return 'Smooth and balanced';
    } else {
      return 'Slow and dramatic';
    }
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: 300,
            height: 400,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Animation Preview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Preview container
                Expanded(
                  child: AdvancedThemeTransition(
                    duration: _selectedDuration,
                    transitionType: _selectedTransition,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorsManger.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColorsManger.mainBlue.withOpacity(0.3),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Tap to preview\nthe animation',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Apply settings (you can implement this)
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Animation settings applied!'),
                          ),
                        );
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Quick theme toggle widget for app bar
class QuickThemeToggle extends StatelessWidget {
  final TransitionType transitionType;
  final Duration duration;

  const QuickThemeToggle({
    Key? key,
    this.transitionType = TransitionType.ripple,
    this.duration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) => current is AppStateChangeTheme,
      builder: (context, state) {
        return AdvancedThemeTransition(
          duration: duration,
          transitionType: transitionType,
          child: SimpleThemeToggle(
            size: 40,
            activeColor: ColorsManger.mainBlue,
            inactiveColor: ColorsManger.white,
          ),
        );
      },
    );
  }
}
