import 'package:flutter/material.dart';
import 'package:greenhouse_app/presentation/crops_screen.dart';
import 'package:greenhouse_app/presentation/settings_screen.dart';
import 'package:greenhouse_app/presentation/zones_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  final List<Widget> pages = [ZonesScreen(), CropsScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          bottomNavigationBar: NavigationBar(
            destinations: [
              NavigationDestination(icon: Icon(Icons.inbox), label: 'zones'),
              NavigationDestination(
                icon: Icon(Icons.align_vertical_bottom),
                label: 'crops',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: 'settings',
              ),
            ],

            selectedIndex: currentPageIndex,
            animationDuration: const Duration(milliseconds: 300),
            onDestinationSelected:
                (value) => setState(() {
                  currentPageIndex = value;
                }),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder:
                (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
            child: pages[currentPageIndex],
          ),
        );
      },
    );
  }
}
