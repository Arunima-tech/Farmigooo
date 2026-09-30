import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'browse_land_screen.dart';
import 'browse_machinery_screen.dart';
import 'browse_workers_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final _screens = const [
    BrowseLandScreen(),
    BrowseMachineryScreen(),
    BrowseWorkersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        backgroundColor: AppColors.cardSurface,
        indicatorColor: AppColors.mossGreen.withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.landscape_outlined, color: AppColors.landAccent),
            label: 'Land',
          ),
          NavigationDestination(
            icon: Icon(Icons.agriculture_outlined, color: AppColors.machineryAccent),
            label: 'Machinery',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: AppColors.workerAccent),
            label: 'Workers',
          ),
        ],
      ),
    );
  }
}
