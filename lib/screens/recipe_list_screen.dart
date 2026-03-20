import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../state/app_state.dart';
import 'recipe_detail_screen.dart';
import 'recipe_edit_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Recipe> _filtered(List<Recipe> recipes) {
    if (_query.isEmpty) return recipes;
    final q = _query.toLowerCase();
    return recipes
        .where((r) =>
            r.title.toLowerCase().contains(q) ||
            r.description.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final recipes = _filtered(appState.recipes);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Prep & Plate'),
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'New Recipe',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecipeEditScreen()),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SearchBar(
                controller: _searchController,
                hintText: 'Search recipes...',
                leading: const Icon(Icons.search),
                trailing: _query.isNotEmpty
                    ? [
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        )
                      ]
                    : null,
                onChanged: (v) => setState(() => _query = v),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
          if (recipes.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restaurant_menu,
                        size: 64, color: colorScheme.outlineVariant),
                    const SizedBox(height: 16),
                    Text(
                      _query.isEmpty
                          ? 'No recipes yet.\nTap + to add your first!'
                          : 'No recipes match "$_query"',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList.separated(
                itemCount: recipes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return _RecipeCard(
                    recipe: recipe,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(recipeId: recipe.id),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecipeEditScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('New Recipe'),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const _RecipeCard({required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.restaurant,
                    color: colorScheme.onPrimaryContainer, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recipe.description,
                      style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _Chip(
                            icon: Icons.people_outline,
                            label: '${recipe.servings} servings'),
                        const SizedBox(width: 8),
                        _Chip(
                            icon: Icons.list_alt,
                            label:
                                '${recipe.ingredients.length} ingredients'),
                        if (recipe.revisions.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          _Chip(
                              icon: Icons.history,
                              label: '${recipe.revisions.length} revisions'),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: colorScheme.primary),
        const SizedBox(width: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
              ),
        ),
      ],
    );
  }
}
