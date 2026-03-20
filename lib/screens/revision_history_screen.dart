import 'package:flutter/material.dart';
import '../models/recipe_revision.dart';
import '../state/app_state.dart';

class RevisionHistoryScreen extends StatelessWidget {
  final String recipeId;
  final bool showLatest;

  const RevisionHistoryScreen({
    super.key,
    required this.recipeId,
    this.showLatest = false,
  });

  String _formatDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} at $hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final recipe = appState.getRecipeById(recipeId);
    final colorScheme = Theme.of(context).colorScheme;

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Revision History')),
        body: const Center(child: Text('Recipe not found')),
      );
    }

    // Show revisions newest-first
    final revisions = recipe.revisions.reversed.toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Revision History'),
        backgroundColor: colorScheme.surface,
        subtitle: Text(
          recipe.title,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      ),
      body: revisions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history,
                      size: 64, color: colorScheme.outlineVariant),
                  const SizedBox(height: 16),
                  Text(
                    'No revisions yet.\nEdit the recipe to create one.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: revisions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                final revision = revisions[index];
                final isLatest = index == 0;
                return _RevisionCard(
                  revision: revision,
                  revisionNumber: revisions.length - index,
                  isLatest: isLatest && showLatest,
                  formatDate: _formatDate,
                );
              },
            ),
    );
  }
}

class _RevisionCard extends StatefulWidget {
  final RecipeRevision revision;
  final int revisionNumber;
  final bool isLatest;
  final String Function(DateTime) formatDate;

  const _RevisionCard({
    required this.revision,
    required this.revisionNumber,
    required this.isLatest,
    required this.formatDate,
  });

  @override
  State<_RevisionCard> createState() => _RevisionCardState();
}

class _RevisionCardState extends State<_RevisionCard> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isLatest;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final revision = widget.revision;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: widget.isLatest
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHigh,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.isLatest
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'v${widget.revisionNumber}',
                    style: textTheme.labelSmall?.copyWith(
                      color: widget.isLatest
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: colorScheme.outlineVariant,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Card content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 0,
                color: widget.isLatest
                    ? colorScheme.primaryContainer.withAlpha(76)
                    : colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: widget.isLatest
                      ? BorderSide(
                          color: colorScheme.primary.withAlpha(76), width: 1)
                      : BorderSide.none,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => setState(() => _expanded = !_expanded),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (widget.isLatest)
                                  Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Latest',
                                      style: textTheme.labelSmall?.copyWith(
                                          color: colorScheme.onPrimary),
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    revision.title,
                                    style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Icon(
                                  _expanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  size: 20,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.formatDate(revision.editedAt),
                              style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant),
                            ),
                            if (revision.changeNote.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondaryContainer
                                      .withAlpha(128),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit_note,
                                        size: 14,
                                        color: colorScheme.onSecondaryContainer),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        revision.changeNote,
                                        style: textTheme.bodySmall?.copyWith(
                                          color:
                                              colorScheme.onSecondaryContainer,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (_expanded) ...[
                      Divider(
                          height: 1, color: colorScheme.outlineVariant),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (revision.description.isNotEmpty) ...[
                              Text(
                                revision.description,
                                style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant),
                              ),
                              const SizedBox(height: 12),
                            ],
                            Row(
                              children: [
                                Icon(Icons.people_outline,
                                    size: 14,
                                    color: colorScheme.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Text(
                                  '${revision.servings} servings',
                                  style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text('Ingredients',
                                style: textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            ...revision.ingredients.map(
                              (ing) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: Text(ing.name,
                                            style: textTheme.bodySmall)),
                                    Text(
                                      '${_fmtAmt(ing.amount)} ${ing.unit}',
                                      style: textTheme.bodySmall?.copyWith(
                                          color:
                                              colorScheme.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (revision.steps.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text('Steps',
                                  style: textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              ...revision.steps.asMap().entries.map(
                                    (e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${e.key + 1}. ',
                                            style: textTheme.bodySmall
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color:
                                                        colorScheme.primary),
                                          ),
                                          Expanded(
                                            child: Text(e.value,
                                                style: textTheme.bodySmall),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmtAmt(double amount) {
    if (amount == amount.roundToDouble()) return amount.toInt().toString();
    return double.parse(amount.toStringAsFixed(2))
        .toString()
        .replaceAll(RegExp(r'\.?0+$'), '');
  }
}
