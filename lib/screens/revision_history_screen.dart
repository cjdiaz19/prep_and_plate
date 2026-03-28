import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/recipe_cubit.dart';
import '../blocs/recipe_state.dart';
import '../main.dart';
import '../models/recipe_revision.dart';

class RevisionHistoryScreen extends StatelessWidget {
  final String recipeId;
  final bool showLatest;

  const RevisionHistoryScreen({
    super.key,
    required this.recipeId,
    this.showLatest = false,
  });

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} · $h:$m $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
      builder: (context, state) {
        final recipe = context.read<RecipeCubit>().getById(recipeId);

        if (recipe == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Revision History')),
            body: const Center(child: Text('Recipe not found.')),
          );
        }

        final revisions = recipe.revisions.reversed.toList();

        return Scaffold(
          backgroundColor: kBgDark,
          appBar: AppBar(
            title: const Text('Revision History'),
            backgroundColor: kBgDark,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(28),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    recipe.title,
                    style: GoogleFonts.playfairDisplay(
                      color: kCreamMuted,
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: revisions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('📋', style: TextStyle(fontSize: 56)),
                      const SizedBox(height: 20),
                      Text(
                        'No revisions yet.\nEdit the recipe to create one.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.courierPrime(
                            color: kCreamMuted, fontSize: 14, height: 1.8),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  itemCount: revisions.length,
                  itemBuilder: (context, index) {
                    return _RevisionCard(
                      revision: revisions[index],
                      number: revisions.length - index,
                      isFirst: index == 0,
                      isLast: index == revisions.length - 1,
                      isHighlighted: index == 0 && showLatest,
                      formatDate: _formatDate,
                    );
                  },
                ),
        );
      },
    );
  }
}

class _RevisionCard extends StatefulWidget {
  final RecipeRevision revision;
  final int number;
  final bool isFirst;
  final bool isLast;
  final bool isHighlighted;
  final String Function(DateTime) formatDate;

  const _RevisionCard({
    required this.revision,
    required this.number,
    required this.isFirst,
    required this.isLast,
    required this.isHighlighted,
    required this.formatDate,
  });

  @override
  State<_RevisionCard> createState() => _RevisionCardState();
}

class _RevisionCardState extends State<_RevisionCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isHighlighted;
  }

  String _fmtAmt(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  @override
  Widget build(BuildContext context) {
    final revision = widget.revision;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Timeline ──────────────────────────────────────────────────
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color:
                        widget.isHighlighted ? kAccent : kBgCard,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: widget.isHighlighted
                          ? kAccent
                          : kBorderAccent,
                      width: widget.isHighlighted ? 2 : 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'v${widget.number}',
                    style: GoogleFonts.courierPrime(
                      color: widget.isHighlighted ? kBgDark : kAccent,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: kBorderAccent,
                    ),
                  ),
              ],
            ),
          ),

          // ── Card ──────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: widget.isLast ? 0 : 16),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.isHighlighted
                      ? kBgCard
                      : kBgCard,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: widget.isHighlighted
                        ? kBorderAccent
                        : kBorderColor,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    InkWell(
                      onTap: () =>
                          setState(() => _expanded = !_expanded),
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (widget.isHighlighted) ...[
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: kAccent,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Text(
                                      'LATEST',
                                      style: GoogleFonts.courierPrime(
                                        color: kBgDark,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ],
                                Expanded(
                                  child: Text(
                                    revision.title,
                                    style: GoogleFonts.playfairDisplay(
                                      color: kCream,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Icon(
                                  _expanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  size: 18,
                                  color: kCreamMuted,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.formatDate(revision.editedAt),
                              style: GoogleFonts.courierPrime(
                                color: kCreamMuted,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                            if (revision.changeNote.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: kBgMid,
                                  borderRadius: BorderRadius.circular(3),
                                  border:
                                      Border.all(color: kBorderColor),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.edit_note,
                                        size: 12, color: kAccent),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        revision.changeNote,
                                        style: GoogleFonts.courierPrime(
                                          color: kCreamMuted,
                                          fontSize: 11,
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

                    // Expanded content
                    if (_expanded) ...[
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (revision.description.isNotEmpty) ...[
                              Text(
                                revision.description,
                                style: GoogleFonts.courierPrime(
                                    color: kCreamMuted,
                                    fontSize: 12,
                                    height: 1.7),
                              ),
                              const SizedBox(height: 12),
                            ],
                            Row(children: [
                              const Icon(Icons.people_outline,
                                  size: 12, color: kCreamMuted),
                              const SizedBox(width: 5),
                              Text(
                                '${revision.servings} SERVINGS',
                                style: GoogleFonts.courierPrime(
                                  color: kCreamMuted,
                                  fontSize: 9,
                                  letterSpacing: 2,
                                ),
                              ),
                            ]),
                            const SizedBox(height: 14),

                            // Ingredients
                            Text(
                              'INGREDIENTS',
                              style: GoogleFonts.courierPrime(
                                color: kAccent,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...revision.ingredients.map(
                              (ing) => Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 4,
                                      margin: const EdgeInsets.only(
                                          right: 10, top: 2),
                                      decoration: const BoxDecoration(
                                        color: kAccent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(ing.name,
                                          style: GoogleFonts.courierPrime(
                                              color: kCream, fontSize: 12)),
                                    ),
                                    Text(
                                      '${_fmtAmt(ing.amount)} ${ing.unit}',
                                      style: GoogleFonts.courierPrime(
                                          color: kCreamMuted, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            if (revision.steps.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              Text(
                                'STEPS',
                                style: GoogleFonts.courierPrime(
                                  color: kAccent,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...revision.steps.asMap().entries.map(
                                    (e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${e.key + 1}.',
                                            style: GoogleFonts.courierPrime(
                                              color: kAccent,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(e.value,
                                                style:
                                                    GoogleFonts.courierPrime(
                                                        color: kCream,
                                                        fontSize: 12,
                                                        height: 1.6)),
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
}
