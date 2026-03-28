import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/shopping_list_cubit.dart';
import '../blocs/shopping_list_state.dart';
import '../main.dart';
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
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, shoppingState) {
        final uncheckedCount =
            shoppingState.items.where((i) => !i.isChecked).length;

        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: kBorderColor)),
            ),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (i) =>
                  setState(() => _selectedIndex = i),
              destinations: [
                NavigationDestination(
                  icon: Icon(
                    Icons.menu_book_outlined,
                    color: _selectedIndex == 0 ? kAccent : kCreamMuted,
                  ),
                  label: 'Recipes',
                ),
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: uncheckedCount > 0,
                    label: Text(
                      '$uncheckedCount',
                      style: GoogleFonts.courierPrime(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: kBgDark),
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: _selectedIndex == 1 ? kAccent : kCreamMuted,
                    ),
                  ),
                  label: 'Shopping',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
