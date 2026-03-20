import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'recipe_list_screen.dart';
import 'shopping_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const _screens = [
    RecipeListScreen(),
    ShoppingListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final shoppingCount = appState.shoppingList
        .where((i) => !i.isChecked)
        .length;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        backgroundColor: colorScheme.surfaceContainer,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Recipes',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: shoppingCount > 0,
              label: Text('$shoppingCount'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: shoppingCount > 0,
              label: Text('$shoppingCount'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Shopping List',
          ),
        ],
      ),
    );
  }
}
