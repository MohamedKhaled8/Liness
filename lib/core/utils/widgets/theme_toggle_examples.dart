import 'package:flutter/material.dart';
import 'package:liness/core/utils/widgets/custom_theme_toggle.dart';
import 'package:liness/core/utils/constant/color_manger.dart';

/// Example usage of the custom theme toggle widget
/// This file demonstrates different ways to use the CustomThemeToggle
class ThemeToggleExamples extends StatelessWidget {
  const ThemeToggleExamples({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Toggle Examples'),
        actions: [
          // Simple circular toggle in app bar
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
            const Text(
              'Custom Theme Toggle Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Example 1: Default toggle
            const Text('Default Toggle:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            const CustomThemeToggle(),
            const SizedBox(height: 20),

            // Example 2: Custom sized toggle
            const Text('Custom Sized Toggle:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            const CustomThemeToggle(
              width: 80,
              height: 40,
              activeColor: ColorsManger.mainBlue,
              inactiveColor: ColorsManger.white,
              thumbColor: Colors.white,
            ),
            const SizedBox(height: 20),

            // Example 3: Fast animation toggle
            const Text(
              'Fast Animation Toggle:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const CustomThemeToggle(
              animationDuration: Duration(milliseconds: 150),
              animationCurve: Curves.easeInOut,
            ),
            const SizedBox(height: 20),

            // Example 4: Simple circular toggle
            const Text(
              'Simple Circular Toggle:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const SimpleThemeToggle(
              size: 60,
              activeColor: ColorsManger.mainBlue,
              inactiveColor: ColorsManger.white,
            ),
            const SizedBox(height: 20),

            // Example 5: Row of different toggles
            const Text('Different Styles:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                CustomThemeToggle(width: 50, height: 25),
                CustomThemeToggle(width: 70, height: 35),
                SimpleThemeToggle(size: 50),
                SimpleThemeToggle(size: 70),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Usage in AppBar
class AppBarWithThemeToggle extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarWithThemeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My App'),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Usage in Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            subtitle: const Text('Switch between light and dark mode'),
            trailing: CustomThemeToggle(
              width: 50,
              height: 25,
              activeColor: ColorsManger.mainBlue,
              inactiveColor: ColorsManger.white.withOpacity(0.3),
              thumbColor: Colors.white,
            ),
          ),
          // Other settings items...
        ],
      ),
    );
  }
}
