import 'package:flutter/material.dart';
import 'package:liness/core/utils/widgets/custom_theme_toggle.dart';
import 'package:liness/core/utils/widgets/advanced_theme_transition.dart';
import 'package:liness/core/utils/widgets/theme_animation_settings.dart';
import 'package:liness/core/utils/constant/color_manger.dart';

/// Demo screen showcasing different theme transition animations
class ThemeAnimationDemo extends StatefulWidget {
  const ThemeAnimationDemo({Key? key}) : super(key: key);

  @override
  State<ThemeAnimationDemo> createState() => _ThemeAnimationDemoState();
}

class _ThemeAnimationDemoState extends State<ThemeAnimationDemo> {
  TransitionType _currentTransition = TransitionType.ripple;
  Duration _currentDuration = const Duration(milliseconds: 1000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Animation Demo'),
        actions: [
          // Quick theme toggle with current animation
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AdvancedThemeTransition(
              duration: _currentDuration,
              transitionType: _currentTransition,
              child: SimpleThemeToggle(
                size: 40,
                activeColor: ColorsManger.mainBlue,
                inactiveColor: ColorsManger.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Theme Transition Animations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Experience different animation effects when switching themes',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Current settings card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Settings',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.animation, size: 20),
                        const SizedBox(width: 8),
                        Text(
                            'Transition: ${_getTransitionName(_currentTransition)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 20),
                        const SizedBox(width: 8),
                        Text('Duration: ${_currentDuration.inMilliseconds}ms'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Animation type selector
            const Text(
              'Choose Animation Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Animation type buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TransitionType.values.map((type) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentTransition = type;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentTransition == type
                        ? ColorsManger.mainBlue
                        : Colors.grey[300],
                    foregroundColor: _currentTransition == type
                        ? Colors.white
                        : Colors.black87,
                  ),
                  child: Text(_getTransitionName(type)),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Duration selector
            const Text(
              'Choose Duration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                const Duration(milliseconds: 500),
                const Duration(milliseconds: 800),
                const Duration(milliseconds: 1000),
                const Duration(milliseconds: 1200),
                const Duration(milliseconds: 1500),
              ].map((duration) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentDuration = duration;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentDuration == duration
                        ? ColorsManger.primaryColor
                        : Colors.grey[300],
                    foregroundColor: _currentDuration == duration
                        ? Colors.white
                        : Colors.black87,
                  ),
                  child: Text('${duration.inMilliseconds}ms'),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Demo area
            const Text(
              'Demo Area',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Demo container with animation
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: ColorsManger.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorsManger.mainBlue.withOpacity(0.3),
                ),
              ),
              child: AdvancedThemeTransition(
                duration: _currentDuration,
                transitionType: _currentTransition,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getTransitionIcon(_currentTransition),
                        size: 48,
                        color: ColorsManger.mainBlue,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getTransitionName(_currentTransition),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the toggle above to see the animation',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Settings button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThemeAnimationSettings(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
                label: const Text('Advanced Settings'),
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

            const SizedBox(height: 24),

            // Theme toggle examples
            const Text(
              'Theme Toggle Examples',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Default'),
                    const SizedBox(height: 8),
                    const CustomThemeToggle(),
                  ],
                ),
                Column(
                  children: [
                    const Text('Large'),
                    const SizedBox(height: 8),
                    const CustomThemeToggle(
                      width: 80,
                      height: 40,
                      activeColor: ColorsManger.mainBlue,
                      inactiveColor: ColorsManger.white,
                      thumbColor: Colors.white,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Simple'),
                    const SizedBox(height: 8),
                    const SimpleThemeToggle(
                      size: 50,
                      activeColor: ColorsManger.mainBlue,
                      inactiveColor: ColorsManger.white,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTransitionName(TransitionType type) {
    switch (type) {
      case TransitionType.ripple:
        return 'Ripple';
      case TransitionType.wave:
        return 'Wave';
      case TransitionType.spiral:
        return 'Spiral';
      case TransitionType.morphing:
        return 'Morphing';
      case TransitionType.explosion:
        return 'Explosion';
    }
  }

  IconData _getTransitionIcon(TransitionType type) {
    switch (type) {
      case TransitionType.ripple:
        return Icons.radio_button_unchecked;
      case TransitionType.wave:
        return Icons.waves;
      case TransitionType.spiral:
        return Icons.refresh;
      case TransitionType.morphing:
        return Icons.transform;
      case TransitionType.explosion:
        return Icons.flash_on;
    }
  }
}
