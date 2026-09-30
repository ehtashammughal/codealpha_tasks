import 'package:flutter/material.dart';

import 'favorites_screen.dart';
import 'quote_screen.dart';

/// Main navigation shell.
///
/// Mobile:
///   Uses NavigationBar at the bottom.
///
/// Desktop:
///   Uses NavigationRail on the left.
///
/// IndexedStack keeps each screen alive when switching tabs.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _screens = [
    QuoteScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop/tablet layout.
        if (constraints.maxWidth >= 800) {
          return _buildDesktopLayout();
        }

        // Mobile layout.
        return _buildMobileLayout();
      },
    );
  }

  // ------------------------------------------------------------
  // MOBILE
  // ------------------------------------------------------------

  Widget _buildMobileLayout() {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          setState(() {
            _index = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.format_quote_outlined),
            selectedIcon: Icon(Icons.format_quote),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // DESKTOP
  // ------------------------------------------------------------

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,

            onDestinationSelected: (index) {
              setState(() {
                _index = index;
              });
            },

            labelType: NavigationRailLabelType.all,

            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.format_quote_outlined),
                selectedIcon: Icon(Icons.format_quote),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                label: Text('Favorites'),
              ),
            ],
          ),

          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),

          Expanded(
            child: IndexedStack(
              index: _index,
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }
}