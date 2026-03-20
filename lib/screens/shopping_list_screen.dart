import 'package:flutter/material.dart';
import '../models/shopping_list_item.dart';
import '../state/app_state.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final items = appState.shoppingList;
    final colorScheme = Theme.of(context).colorScheme;

    final unchecked = items.where((i) => !i.isChecked).toList();
    final checked = items.where((i) => i.isChecked).toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Shopping List'),
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            actions: [
              if (checked.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.done_all),
                  tooltip: 'Clear checked items',
                  onPressed: () => _confirmClearChecked(context, appState),
                ),
              if (items.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  tooltip: 'Clear all items',
                  onPressed: () => _confirmClearAll(context, appState),
                ),
            ],
          ),
          if (items.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined,
                        size: 64, color: colorScheme.outlineVariant),
                    const SizedBox(height: 16),
                    Text(
                      'Your shopping list is empty.\nAdd ingredients from a recipe!',
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
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Summary row
                  _SummaryBanner(
                    total: items.length,
                    checked: checked.length,
                  ),
                  const SizedBox(height: 16),

                  // Unchecked items grouped by recipe
                  if (unchecked.isNotEmpty) ...[
                    ..._buildGroupedSection(
                      context: context,
                      items: unchecked,
                      appState: appState,
                    ),
                  ],

                  // Checked items
                  if (checked.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 16,
                            color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text(
                          'Checked (${checked.length})',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  color: colorScheme.onSurfaceVariant),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () =>
                              _confirmClearChecked(context, appState),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...checked.map((item) => _ShoppingItemTile(
                          item: item,
                          onToggle: () =>
                              appState.toggleShoppingItem(item.id),
                          onRemove: () =>
                              appState.removeFromShoppingList(item.id),
                        )),
                  ],
                  const SizedBox(height: 32),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedSection({
    required BuildContext context,
    required List<ShoppingListItem> items,
    required AppState appState,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Group by recipe
    final Map<String?, List<ShoppingListItem>> groups = {};
    for (final item in items) {
      final key = item.recipeName;
      groups.putIfAbsent(key, () => []).add(item);
    }

    final widgets = <Widget>[];
    for (final entry in groups.entries) {
      if (entry.key != null) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(Icons.restaurant, size: 14, color: colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  entry.key!,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      widgets.addAll(entry.value.map((item) => _ShoppingItemTile(
            item: item,
            onToggle: () => appState.toggleShoppingItem(item.id),
            onRemove: () => appState.removeFromShoppingList(item.id),
          )));
      widgets.add(const SizedBox(height: 8));
    }
    return widgets;
  }

  void _confirmClearChecked(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Checked Items'),
        content:
            const Text('Remove all checked items from the shopping list?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              appState.clearCheckedItems();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Items'),
        content: const Text(
            'This will remove everything from your shopping list. Continue?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              Navigator.pop(ctx);
              appState.clearAllShoppingItems();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  final int total;
  final int checked;

  const _SummaryBanner({required this.total, required this.checked});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final remaining = total - checked;
    final progress = total > 0 ? checked / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withAlpha(76),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withAlpha(51)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$remaining item${remaining == 1 ? '' : 's'} remaining',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '$checked / $total',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: colorScheme.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation(colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShoppingItemTile extends StatelessWidget {
  final ShoppingListItem item;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const _ShoppingItemTile({
    required this.item,
    required this.onToggle,
    required this.onRemove,
  });

  String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) return amount.toInt().toString();
    return double.parse(amount.toStringAsFixed(2))
        .toString()
        .replaceAll(RegExp(r'\.?0+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isChecked = item.isChecked;

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline, color: colorScheme.onErrorContainer),
      ),
      onDismissed: (_) => onRemove(),
      child: Card(
        elevation: 0,
        color: isChecked
            ? colorScheme.surfaceContainerLowest
            : colorScheme.surfaceContainerLow,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 6),
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (_) => onToggle(),
                  shape: const CircleBorder(),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.ingredientName,
                        style: textTheme.bodyLarge?.copyWith(
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : null,
                          color: isChecked
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${_formatAmount(item.amount)} ${item.unit}',
                        style: textTheme.bodySmall?.copyWith(
                          color: isChecked
                              ? colorScheme.outlineVariant
                              : colorScheme.onSurfaceVariant,
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                  color: colorScheme.onSurfaceVariant,
                  visualDensity: VisualDensity.compact,
                  onPressed: onRemove,
                  tooltip: 'Remove',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
