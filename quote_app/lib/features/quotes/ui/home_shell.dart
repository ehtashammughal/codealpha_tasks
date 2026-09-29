import 'package:flutter/material.dart';

import 'favorites_screen.dart';
import 'quote_screen.dart';

/// Bottom-nav shell: Home (random quote) and Favorites.
/// Uses IndexedStack so each tab keeps its scroll position and state
/// when you switch away and back.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _screens = [QuoteScreen(), FavoritesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      //BOTTOMNAVIGATIOBAR
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.format_quote_outlined),
            selectedIcon: Icon(Icons.format_quote),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite, color: Colors.red),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
