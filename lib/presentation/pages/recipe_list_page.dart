import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/recipe.dart';
import '../blocs/recipe/recipe_cubit.dart';
import '../blocs/recipe/recipe_state.dart';
import 'recipe_detail_page.dart';
import 'recipe_edit_page.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
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
    return BlocBuilder<RecipeCubit, RecipeState>(
      builder: (context, state) {
        final recipes = _filtered(state.recipes);

        return Scaffold(
          backgroundColor: AppColors.bgDark,
          body: CustomScrollView(
            slivers: [
              // ── App Bar ────────────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                expandedHeight: 100,
                backgroundColor: AppColors.bgDark,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Prep ',
                        style: GoogleFonts.playfairDisplay(
                          color: AppColors.cream,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        '&',
                        style: GoogleFonts.playfairDisplay(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        ' Plate',
                        style: GoogleFonts.playfairDisplay(
                          color: AppColors.cream,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppColors.border)),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColors.accent),
                    tooltip: 'New Recipe',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RecipeEditPage()),
                    ),
                  ),
                ],
              ),

              // ── Search ─────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: SearchBar(
                    controller: _searchController,
                    hintText: 'Search recipes...',
                    leading: const Icon(Icons.search, size: 18),
                    trailing: _query.isNotEmpty
                        ? [
                            IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                            )
                          ]
                        : null,
                    onChanged: (v) => setState(() => _query = v),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 14),
                    ),
                  ),
                ),
              ),

              // ── Count label ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Text(
                    '${recipes.length} RECIPE${recipes.length == 1 ? '' : 'S'}',
                    style: GoogleFonts.courierPrime(
                      color: AppColors.creamMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),

              // ── Recipe list / empty state ──────────────────────────────────
              if (recipes.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🍽️', style: TextStyle(fontSize: 56)),
                        const SizedBox(height: 20),
                        Text(
                          _query.isEmpty
                              ? 'No recipes yet.\nTap + to add your first!'
                              : 'No results for "$_query"',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.courierPrime(
                              color: AppColors.creamMuted,
                              fontSize: 14,
                              height: 1.8),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                  sliver: SliverList.separated(
                    itemCount: recipes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return _RecipeCard(
                        recipe: recipe,
                        emoji: Formatters.recipeEmoji(recipe.title),
                        shortDate: Formatters.shortDate(recipe.updatedAt),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RecipeDetailPage(recipeId: recipe.id),
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
              MaterialPageRoute(builder: (_) => const RecipeEditPage()),
            ),
            icon: const Icon(Icons.add, color: AppColors.bgDark),
            label: Text(
              'NEW RECIPE',
              style: GoogleFonts.courierPrime(
                color: AppColors.bgDark,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                fontSize: 11,
              ),
            ),
            backgroundColor: AppColors.accent,
          ),
        );
      },
    );
  }
}

// ─── Recipe Card ──────────────────────────────────────────────────────────────

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final String emoji;
  final String shortDate;
  final VoidCallback onTap;

  const _RecipeCard({
    required this.recipe,
    required this.emoji,
    required this.shortDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.accent.withAlpha(20),
        highlightColor: AppColors.accent.withAlpha(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image area ────────────────────────────────────────────────
            SizedBox(
              height: 140,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: AppColors.bgMid,
                    child: Center(
                      child: Text(emoji,
                          style: const TextStyle(fontSize: 64)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 50,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.bgCard.withAlpha(200),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (recipe.revisions.isNotEmpty)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: _Badge(
                        label:
                            '${recipe.revisions.length} REV${recipe.revisions.length == 1 ? '' : 'S'}',
                      ),
                    ),
                ],
              ),
            ),
            // ── Card body ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MetaRow(recipe: recipe),
                  const SizedBox(height: 8),
                  Text(
                    recipe.title,
                    style: GoogleFonts.playfairDisplay(
                      color: AppColors.cream,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    recipe.description,
                    style: GoogleFonts.courierPrime(
                        color: AppColors.creamMuted, fontSize: 12, height: 1.6),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        shortDate,
                        style: GoogleFonts.courierPrime(
                            color: AppColors.creamMuted,
                            fontSize: 10,
                            letterSpacing: 0.5),
                      ),
                      const Icon(Icons.arrow_forward,
                          size: 14, color: AppColors.accent),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        label,
        style: GoogleFonts.courierPrime(
          color: AppColors.bgDark,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final Recipe recipe;
  const _MetaRow({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetaItem(
            icon: Icons.people_outline, text: '${recipe.servings} servings'),
        const _Dot(),
        _MetaItem(
            icon: Icons.list_alt,
            text: '${recipe.ingredients.length} ingr.'),
        const _Dot(),
        _MetaItem(
            icon: Icons.format_list_numbered,
            text: '${recipe.steps.length} steps'),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: AppColors.creamMuted),
        const SizedBox(width: 3),
        Text(
          text,
          style: GoogleFonts.courierPrime(
              color: AppColors.creamMuted, fontSize: 10, letterSpacing: 0.5),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text('●', style: TextStyle(fontSize: 4, color: AppColors.accent)),
    );
  }
}
