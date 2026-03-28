import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../blocs/shopping_list/shopping_list_cubit.dart';
import '../blocs/shopping_list/shopping_list_state.dart';
import 'recipe_list_page.dart';
import 'shopping_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const _pages = [
    RecipeListPage(),
    ShoppingListPage(),
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
            children: _pages,
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (i) =>
                  setState(() => _selectedIndex = i),
              destinations: [
                NavigationDestination(
                  icon: Icon(
                    Icons.menu_book_outlined,
                    color: _selectedIndex == 0
                        ? AppColors.accent
                        : AppColors.creamMuted,
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
                        color: AppColors.bgDark,
                      ),
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: _selectedIndex == 1
                          ? AppColors.accent
                          : AppColors.creamMuted,
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
