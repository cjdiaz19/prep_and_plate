import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/recipe_cubit.dart';
import '../blocs/recipe_state.dart';
import '../blocs/shopping_list_cubit.dart';
import '../blocs/shopping_list_state.dart';
import '../main.dart';
import '../models/ingredient.dart';
import 'recipe_edit_screen.dart';
import 'revision_history_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  double _scale = 1.0;

  String _fmt(double amount) {
    final v = amount * _scale;
    if (v == v.roundToDouble()) return v.toInt().toString();
    return double.parse(v.toStringAsFixed(2))
        .toString()
        .replaceAll(RegExp(r'\.?0+$'), '');
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: const Text(
            'Are you sure? This will also remove any shopping list items from this recipe.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCEL')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFCF6679)),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<RecipeCubit>().deleteRecipe(widget.recipeId);
              context.read<ShoppingListCubit>().removeByRecipeId(widget.recipeId);
              Navigator.pop(context);
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
      builder: (context, recipeState) {
        return BlocBuilder<ShoppingListCubit, ShoppingListState>(
          builder: (context, shoppingState) {
            final recipe = context.read<RecipeCubit>().getById(widget.recipeId);

            if (recipe == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Recipe')),
                body: const Center(child: Text('Recipe not found.')),
              );
            }

            return Scaffold(
              backgroundColor: kBgDark,
              body: CustomScrollView(
                slivers: [
                  // ── App Bar ──────────────────────────────────────────────
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 120,
                    backgroundColor: kBgDark,
                    surfaceTintColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding:
                          const EdgeInsets.fromLTRB(56, 0, 20, 14),
                      title: Text(
                        recipe.title,
                        style: GoogleFonts.playfairDisplay(
                          color: kCream,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      background: Container(
                        decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: kBorderColor)),
                        ),
                      ),
                    ),
                    actions: [
                      if (recipe.revisions.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.history),
                          tooltip: 'Revision History',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RevisionHistoryScreen(
                                  recipeId: widget.recipeId),
                            ),
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Edit',
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
                        tooltip: 'Delete',
                        onPressed: () => _confirmDelete(context),
                      ),
                    ],
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Description
                        Text(
                          recipe.description,
                          style: GoogleFonts.courierPrime(
                              color: kCreamMuted, fontSize: 13, height: 1.8),
                        ),
                        const SizedBox(height: 20),

                        // Meta chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _MetaChip(
                              label:
                                  '${(recipe.servings * _scale).toStringAsFixed(_scale == _scale.roundToDouble() ? 0 : 1)} SERVINGS',
                              color: kAccent,
                            ),
                            _MetaChip(
                              label: '${recipe.ingredients.length} INGREDIENTS',
                              color: kCreamMuted,
                            ),
                            _MetaChip(
                              label: '${recipe.steps.length} STEPS',
                              color: kCreamMuted,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Scale selector
                        _ScaleCard(
                          scale: _scale,
                          onChanged: (v) => setState(() => _scale = v),
                        ),
                        const SizedBox(height: 28),

                        // Ingredients section header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SectionTitle(
                                prefix: 'Ingredients', italic: ''),
                            TextButton.icon(
                              icon: const Icon(Icons.add_shopping_cart,
                                  size: 14),
                              label: const Text('ADD ALL'),
                              onPressed: () {
                                final cubit =
                                    context.read<ShoppingListCubit>();
                                for (final ing in recipe.ingredients) {
                                  cubit.addIngredient(
                                      ing, recipe.id, recipe.title);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        'All ingredients added to list'),
                                    action: SnackBarAction(
                                      label: 'OK',
                                      onPressed: () {},
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Ingredient tiles
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: kBorderColor),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: recipe.ingredients
                                .asMap()
                                .entries
                                .map((e) => _IngredientTile(
                                      ingredient: e.value,
                                      scaledAmount: _fmt(e.value.amount),
                                      isLast: e.key ==
                                          recipe.ingredients.length - 1,
                                      inCart: context
                                          .read<ShoppingListCubit>()
                                          .isIngredientAdded(
                                              e.value.id, recipe.id),
                                      onToggleCart: () {
                                        final sl = context
                                            .read<ShoppingListCubit>();
                                        if (sl.isIngredientAdded(
                                            e.value.id, recipe.id)) {
                                          final item = shoppingState.items
                                              .firstWhere((i) =>
                                                  i.ingredientId ==
                                                      e.value.id &&
                                                  i.recipeId == recipe.id);
                                          sl.removeItem(item.id);
                                        } else {
                                          sl.addIngredient(
                                              e.value,
                                              recipe.id,
                                              recipe.title);
                                        }
                                      },
                                    ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Instructions section
                        _SectionTitle(prefix: 'Instructions', italic: ''),
                        const SizedBox(height: 16),
                        ...recipe.steps.asMap().entries.map(
                              (e) => _StepTile(
                                  number: e.key + 1,
                                  text: e.value,
                                  isLast: e.key == recipe.steps.length - 1),
                            ),
                        const SizedBox(height: 40),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Reusable widgets ─────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String prefix;
  final String italic;

  const _SectionTitle({required this.prefix, required this.italic});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          prefix,
          style: GoogleFonts.playfairDisplay(
            color: kCream,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        if (italic.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text(
            italic,
            style: GoogleFonts.playfairDisplay(
              color: kAccent,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              fontSize: 22,
            ),
          ),
        ],
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final Color color;

  const _MetaChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: color.withAlpha(76)),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: GoogleFonts.courierPrime(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _ScaleCard extends StatelessWidget {
  final double scale;
  final ValueChanged<double> onChanged;

  const _ScaleCard({required this.scale, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const presets = [0.5, 1.0, 1.5, 2.0, 3.0];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgCard,
        border: Border.all(color: kBorderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'SCALE RECIPE',
                style: GoogleFonts.courierPrime(
                  color: kAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                ),
              ),
              const Spacer(),
              Text(
                '${scale}×',
                style: GoogleFonts.playfairDisplay(
                  color: kAccent,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: presets
                .map((p) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: _PresetBtn(
                          label: '${p}×',
                          active: scale == p,
                          onTap: () => onChanged(p),
                        ),
                      ),
                    ))
                .toList(),
          ),
          Slider(
            value: scale.clamp(0.25, 4.0),
            min: 0.25,
            max: 4.0,
            divisions: 15,
            label: '${scale}×',
            onChanged: (v) =>
                onChanged(double.parse(v.toStringAsFixed(2))),
          ),
        ],
      ),
    );
  }
}

class _PresetBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _PresetBtn(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(3),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: active ? kAccent : kBgMid,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
              color: active ? kAccent : kBorderColor),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.courierPrime(
            color: active ? kBgDark : kCreamMuted,
            fontSize: 11,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final String scaledAmount;
  final bool isLast;
  final bool inCart;
  final VoidCallback onToggleCart;

  const _IngredientTile({
    required this.ingredient,
    required this.scaledAmount,
    required this.isLast,
    required this.inCart,
    required this.onToggleCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: kAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ingredient.name,
                  style: GoogleFonts.courierPrime(
                      color: kCream, fontSize: 13),
                ),
              ),
              Text(
                '$scaledAmount ${ingredient.unit}',
                style: GoogleFonts.courierPrime(
                  color: kCreamMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onToggleCart,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    inCart
                        ? Icons.shopping_cart
                        : Icons.add_shopping_cart_outlined,
                    size: 18,
                    color: inCart ? kAccent : kCreamMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}

class _StepTile extends StatelessWidget {
  final int number;
  final String text;
  final bool isLast;

  const _StepTile(
      {required this.number, required this.text, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: kBgMid,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: kBorderAccent),
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: GoogleFonts.playfairDisplay(
                color: kAccent,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: GoogleFonts.courierPrime(
                    color: kCream, fontSize: 13, height: 1.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
