import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/shopping_list_cubit.dart';
import '../blocs/shopping_list_state.dart';
import '../main.dart';
import '../models/shopping_list_item.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        final items = state.items;
        final unchecked = items.where((i) => !i.isChecked).toList();
        final checked = items.where((i) => i.isChecked).toList();

        return Scaffold(
          backgroundColor: kBgDark,
          body: CustomScrollView(
            slivers: [
              // ── App Bar ──────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                expandedHeight: 100,
                backgroundColor: kBgDark,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Shopping ',
                        style: GoogleFonts.playfairDisplay(
                          color: kCream,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        'List',
                        style: GoogleFonts.playfairDisplay(
                          color: kAccent,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: kBorderColor))),
                  ),
                ),
                actions: [
                  if (checked.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.done_all),
                      tooltip: 'Clear checked',
                      onPressed: () =>
                          _confirmClearChecked(context),
                    ),
                  if (items.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.delete_sweep_outlined),
                      tooltip: 'Clear all',
                      onPressed: () => _confirmClearAll(context),
                    ),
                ],
              ),

              if (items.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🛒',
                            style: TextStyle(fontSize: 56)),
                        const SizedBox(height: 20),
                        Text(
                          'Your list is empty.\nAdd ingredients from a recipe!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.courierPrime(
                              color: kCreamMuted,
                              fontSize: 14,
                              height: 1.8),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Progress banner
                      _ProgressBanner(
                          total: items.length,
                          checked: checked.length),
                      const SizedBox(height: 24),

                      // Unchecked items grouped by recipe
                      if (unchecked.isNotEmpty)
                        ..._buildGroups(
                            context: context,
                            items: unchecked),

                      // Checked items
                      if (checked.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              'CHECKED — ${checked.length}',
                              style: GoogleFonts.courierPrime(
                                color: kCreamMuted,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 3,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () =>
                                  _confirmClearChecked(context),
                              child: const Text('CLEAR'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...checked.map((item) => _ItemTile(
                              item: item,
                              onToggle: () => context
                                  .read<ShoppingListCubit>()
                                  .toggleItem(item.id),
                              onRemove: () => context
                                  .read<ShoppingListCubit>()
                                  .removeItem(item.id),
                            )),
                      ],
                    ]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildGroups({
    required BuildContext context,
    required List<ShoppingListItem> items,
  }) {
    final Map<String?, List<ShoppingListItem>> groups = {};
    for (final item in items) {
      groups.putIfAbsent(item.recipeName, () => []).add(item);
    }

    final widgets = <Widget>[];
    var isFirst = true;
    for (final entry in groups.entries) {
      if (!isFirst) widgets.add(const SizedBox(height: 20));
      isFirst = false;

      if (entry.key != null) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(children: [
            const Icon(Icons.restaurant, size: 11, color: kAccent),
            const SizedBox(width: 6),
            Text(
              entry.key!.toUpperCase(),
              style: GoogleFonts.courierPrime(
                color: kAccent,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
          ]),
        ));
      }

      widgets.add(Container(
        decoration: BoxDecoration(
          border: Border.all(color: kBorderColor),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: entry.value
              .asMap()
              .entries
              .map((e) => _ItemTile(
                    item: e.value,
                    isLast: e.key == entry.value.length - 1,
                    onToggle: () => context
                        .read<ShoppingListCubit>()
                        .toggleItem(e.value.id),
                    onRemove: () => context
                        .read<ShoppingListCubit>()
                        .removeItem(e.value.id),
                  ))
              .toList(),
        ),
      ));
    }
    return widgets;
  }

  void _confirmClearChecked(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Checked'),
        content: const Text('Remove all checked items from the list?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCEL')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ShoppingListCubit>().clearChecked();
            },
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All'),
        content: const Text(
            'This will remove everything from your shopping list.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCEL')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFCF6679)),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ShoppingListCubit>().clearAll();
            },
            child: const Text('CLEAR ALL'),
          ),
        ],
      ),
    );
  }
}

// ─── Progress Banner ──────────────────────────────────────────────────────────

class _ProgressBanner extends StatelessWidget {
  final int total;
  final int checked;

  const _ProgressBanner({required this.total, required this.checked});

  @override
  Widget build(BuildContext context) {
    final remaining = total - checked;
    final progress = total > 0 ? checked / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgCard,
        border: Border.all(color: kBorderAccent.withAlpha(100)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$remaining ITEM${remaining == 1 ? '' : 'S'} REMAINING',
                style: GoogleFonts.courierPrime(
                  color: kCream,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '$checked / $total',
                style: GoogleFonts.playfairDisplay(
                  color: kAccent,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: kBgMid,
              valueColor: const AlwaysStoppedAnimation(kAccent),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Item Tile ────────────────────────────────────────────────────────────────

class _ItemTile extends StatelessWidget {
  final ShoppingListItem item;
  final bool isLast;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const _ItemTile({
    required this.item,
    this.isLast = true,
    required this.onToggle,
    required this.onRemove,
  });

  String _fmtAmt(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  @override
  Widget build(BuildContext context) {
    final checked = item.isChecked;

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF3D1520),
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6))
              : BorderRadius.zero,
        ),
        child: const Icon(Icons.delete_outline,
            color: Color(0xFFCF6679), size: 20),
      ),
      onDismissed: (_) => onRemove(),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: checked,
                      onChanged: (_) => onToggle(),
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.ingredientName,
                      style: GoogleFonts.courierPrime(
                        color: checked ? kCreamMuted : kCream,
                        fontSize: 13,
                        decoration: checked
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: kCreamMuted,
                      ),
                    ),
                  ),
                  Text(
                    '${_fmtAmt(item.amount)} ${item.unit}',
                    style: GoogleFonts.courierPrime(
                      color: checked ? kCreamMuted.withAlpha(100) : kCreamMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      decoration: checked
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: kCreamMuted,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onRemove,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close, size: 14, color: kCreamMuted),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isLast) const Divider(height: 1),
        ],
      ),
    );
  }
}
