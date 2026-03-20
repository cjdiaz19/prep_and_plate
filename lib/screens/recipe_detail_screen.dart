import 'package:flutter/material.dart';
import '../models/ingredient.dart';
import '../state/app_state.dart';
import 'recipe_edit_screen.dart';
import 'revision_history_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  double _scaleFactor = 1.0;

  String _formatAmount(double amount) {
    final scaled = amount * _scaleFactor;
    if (scaled == scaled.roundToDouble()) {
      return scaled.toInt().toString();
    }
    // Round to 2 decimal places, trimming trailing zeros
    final rounded = double.parse(scaled.toStringAsFixed(2));
    return rounded.toString().replaceAll(RegExp(r'\.?0+$'), '');
  }

  void _confirmDelete(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: const Text(
            'Are you sure you want to delete this recipe? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              appState.deleteRecipe(widget.recipeId);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final recipe = appState.getRecipeById(widget.recipeId);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recipe')),
        body: const Center(child: Text('Recipe not found')),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(recipe.title),
            backgroundColor: colorScheme.surface,
            actions: [
              if (recipe.revisions.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.history),
                  tooltip: 'Revision History',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RevisionHistoryScreen(recipeId: widget.recipeId),
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Recipe',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        RecipeEditScreen(recipeId: widget.recipeId),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete Recipe',
                onPressed: () => _confirmDelete(context, appState),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Description
                Text(
                  recipe.description,
                  style: textTheme.bodyLarge
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),

                // Meta row
                Row(
                  children: [
                    _MetaChip(
                      icon: Icons.people_outline,
                      label:
                          '${(recipe.servings * _scaleFactor).toStringAsFixed(_scaleFactor == _scaleFactor.roundToDouble() ? 0 : 1)} servings',
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    _MetaChip(
                      icon: Icons.list_alt,
                      label: '${recipe.ingredients.length} ingredients',
                      color: colorScheme.secondary,
                    ),
                    const SizedBox(width: 8),
                    _MetaChip(
                      icon: Icons.format_list_numbered,
                      label: '${recipe.steps.length} steps',
                      color: colorScheme.tertiary,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Scale selector
                _ScaleSelector(
                  scaleFactor: _scaleFactor,
                  onChanged: (v) => setState(() => _scaleFactor = v),
                ),
                const SizedBox(height: 24),

                // Ingredients section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ingredients',
                        style: textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: const Text('Add all'),
                      onPressed: () {
                        for (final ing in recipe.ingredients) {
                          appState.addIngredientToShoppingList(
                            ing,
                            recipe.id,
                            recipe.title,
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'All ingredients added to shopping list'),
                            action: SnackBarAction(
                              label: 'View',
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...recipe.ingredients.map(
                  (ing) => _IngredientTile(
                    ingredient: ing,
                    scaledAmount: _formatAmount(ing.amount),
                    isInShoppingList: appState.isIngredientInShoppingList(
                        ing.id, recipe.id),
                    onToggleShoppingList: () {
                      if (appState.isIngredientInShoppingList(
                          ing.id, recipe.id)) {
                        // Find and remove
                        final item = appState.shoppingList.firstWhere(
                          (i) =>
                              i.ingredientId == ing.id &&
                              i.recipeId == recipe.id,
                        );
                        appState.removeFromShoppingList(item.id);
                      } else {
                        appState.addIngredientToShoppingList(
                          ing,
                          recipe.id,
                          recipe.title,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Steps section
                Text('Instructions',
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...recipe.steps.asMap().entries.map(
                      (e) => _StepTile(
                          stepNumber: e.key + 1, step: e.value),
                    ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(76)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ScaleSelector extends StatelessWidget {
  final double scaleFactor;
  final ValueChanged<double> onChanged;

  const _ScaleSelector(
      {required this.scaleFactor, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final presets = [0.5, 1.0, 1.5, 2.0, 3.0];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.scale, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Scale Recipe',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Text(
                '${scaleFactor}x',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: presets
                .map(
                  (p) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _PresetButton(
                        label: '${p}x',
                        isSelected: scaleFactor == p,
                        onTap: () => onChanged(p),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          Slider(
            value: scaleFactor.clamp(0.25, 4.0),
            min: 0.25,
            max: 4.0,
            divisions: 15,
            label: '${scaleFactor}x',
            onChanged: (v) => onChanged(double.parse(v.toStringAsFixed(2))),
          ),
        ],
      ),
    );
  }
}

class _PresetButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetButton(
      {required this.label,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ),
    );
  }
}

class _IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final String scaledAmount;
  final bool isInShoppingList;
  final VoidCallback onToggleShoppingList;

  const _IngredientTile({
    required this.ingredient,
    required this.scaledAmount,
    required this.isInShoppingList,
    required this.onToggleShoppingList,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ingredient.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            '$scaledAmount ${ingredient.unit}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(
              isInShoppingList
                  ? Icons.shopping_cart
                  : Icons.add_shopping_cart_outlined,
              size: 20,
              color: isInShoppingList
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            tooltip: isInShoppingList
                ? 'Remove from shopping list'
                : 'Add to shopping list',
            visualDensity: VisualDensity.compact,
            onPressed: onToggleShoppingList,
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final int stepNumber;
  final String step;

  const _StepTile({required this.stepNumber, required this.step});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$stepNumber',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                step,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
