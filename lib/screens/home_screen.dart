import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'encyclopedia_screen.dart';
import 'recognition_screen.dart';
import 'facts_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2; // Start with Home (center position)

  final List<Widget> _screens = [
    const EncyclopediaScreen(),
    const RecognitionScreen(),
    const DashboardScreen(), // New home dashboard
    const FactsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // Remove hardcoded colors to use theme configuration
        // selectedItemColor and unselectedItemColor will be inherited from BottomNavigationBarTheme
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Encyclopedia',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Recognition',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _currentIndex == 2
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.home,
                size: _currentIndex == 2 ? 28 : 24,
              ),
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Facts',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      // floatingActionButton: _currentIndex == 1 // Removed FAB
      //     ? null
      //     : FloatingActionButton(
      //         onPressed: () {
      //           setState(() {
      //             _currentIndex = 1; // Switch to recognition screen
      //           });
      //         },
      //         child: const Icon(Icons.camera_alt),
      //       ),
    );
  }
}