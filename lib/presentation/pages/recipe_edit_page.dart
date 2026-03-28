import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';
import '../blocs/recipe/recipe_cubit.dart';
import 'revision_history_page.dart';

class RecipeEditPage extends StatefulWidget {
  final String? recipeId;
  const RecipeEditPage({super.key, this.recipeId});

  @override
  State<RecipeEditPage> createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _changeNoteCtrl = TextEditingController();
  int _servings = 2;
  final List<_IngEntry> _ingredients = [];
  final List<TextEditingController> _stepCtrls = [];

  bool get _isEditing => widget.recipeId != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadExisting());
  }

  void _loadExisting() {
    if (!_isEditing) {
      _addIngredient();
      _addStep();
      return;
    }
    final recipe = context.read<RecipeCubit>().getById(widget.recipeId!);
    if (recipe == null) return;

    _titleCtrl.text = recipe.title;
    _descCtrl.text = recipe.description;
    setState(() {
      _servings = recipe.servings;
      _ingredients.addAll(recipe.ingredients.map((ing) => _IngEntry(
            id: ing.id,
            nameCtrl: TextEditingController(text: ing.name),
            amountCtrl: TextEditingController(
                text: Formatters.amount(ing.amount)),
            unitCtrl: TextEditingController(text: ing.unit),
          )));
      _stepCtrls.addAll(
          recipe.steps.map((s) => TextEditingController(text: s)));
    });
  }

  void _addIngredient() => setState(() => _ingredients.add(_IngEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nameCtrl: TextEditingController(),
        amountCtrl: TextEditingController(),
        unitCtrl: TextEditingController(),
      )));

  void _removeIngredient(int i) => setState(() {
        _ingredients[i].dispose();
        _ingredients.removeAt(i);
      });

  void _addStep() =>
      setState(() => _stepCtrls.add(TextEditingController()));

  void _removeStep(int i) => setState(() {
        _stepCtrls[i].dispose();
        _stepCtrls.removeAt(i);
      });

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final ingredients = _ingredients
        .where((e) => e.nameCtrl.text.trim().isNotEmpty)
        .map((e) => Ingredient(
              id: e.id,
              name: e.nameCtrl.text.trim(),
              amount: double.tryParse(e.amountCtrl.text.trim()) ?? 0,
              unit: e.unitCtrl.text.trim(),
            ))
        .toList();

    final steps = _stepCtrls
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (_isEditing) {
      final existing =
          context.read<RecipeCubit>().getById(widget.recipeId!)!;
      final updated = existing.copyWith(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        ingredients: ingredients,
        steps: steps,
        servings: _servings,
        updatedAt: now,
      );
      context.read<RecipeCubit>().updateRecipe(
            widget.recipeId!,
            updated,
            changeNote: _changeNoteCtrl.text.trim(),
          );
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RevisionHistoryPage(
              recipeId: widget.recipeId!, showLatest: true),
        ),
      );
    } else {
      context.read<RecipeCubit>().addRecipe(Recipe(
            id: now.millisecondsSinceEpoch.toString(),
            title: _titleCtrl.text.trim(),
            description: _descCtrl.text.trim(),
            ingredients: ingredients,
            steps: steps,
            servings: _servings,
            createdAt: now,
            updatedAt: now,
          ));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _changeNoteCtrl.dispose();
    for (final e in _ingredients) e.dispose();
    for (final c in _stepCtrls) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Recipe' : 'New Recipe'),
        backgroundColor: AppColors.bgDark,
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              'SAVE',
              style: GoogleFonts.courierPrime(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _SectionLabel(label: 'BASIC INFO'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleCtrl,
              style: GoogleFonts.playfairDisplay(
                  color: AppColors.cream, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                labelText: 'Recipe title',
                hintText: 'e.g. Classic Carbonara',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Title required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              style: GoogleFonts.courierPrime(
                  color: AppColors.cream, fontSize: 13),
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'A brief description...',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Servings
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                  color: AppColors.bgMid,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.border)),
              child: Row(
                children: [
                  const Icon(Icons.people_outline, size: 18),
                  const SizedBox(width: 10),
                  Text('Servings',
                      style: GoogleFonts.courierPrime(
                          color: AppColors.creamMuted, fontSize: 13)),
                  const Spacer(),
                  _CircleButton(
                    icon: Icons.remove,
                    onTap: _servings > 1
                        ? () => setState(() => _servings--)
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '$_servings',
                      style: GoogleFonts.playfairDisplay(
                        color: AppColors.cream,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _CircleButton(
                    icon: Icons.add,
                    onTap: () => setState(() => _servings++),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Ingredients
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionLabel(label: 'INGREDIENTS'),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 14),
                  label: const Text('ADD'),
                  onPressed: _addIngredient,
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (_ingredients.isEmpty)
              _EmptyHint(text: 'No ingredients yet. Tap ADD to begin.'),
            ...(_ingredients.asMap().entries.map((e) => _IngFormRow(
                  key: ValueKey(e.value.id),
                  entry: e.value,
                  index: e.key,
                  onRemove: () => _removeIngredient(e.key),
                ))),
            const SizedBox(height: 28),

            // Steps
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionLabel(label: 'STEPS'),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 14),
                  label: const Text('ADD STEP'),
                  onPressed: _addStep,
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (_stepCtrls.isEmpty)
              _EmptyHint(text: 'No steps yet. Tap ADD STEP to begin.'),
            ...(_stepCtrls.asMap().entries.map((e) => _StepFormRow(
                  key: ValueKey('step_${e.key}'),
                  ctrl: e.value,
                  number: e.key + 1,
                  onRemove: () => _removeStep(e.key),
                ))),
            const SizedBox(height: 28),

            // Change note (edit only)
            if (_isEditing) ...[
              _SectionLabel(label: 'CHANGE NOTE'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _changeNoteCtrl,
                style: GoogleFonts.courierPrime(
                    color: AppColors.cream, fontSize: 13),
                decoration: const InputDecoration(
                  labelText: 'What changed? (optional)',
                  hintText: 'e.g. Adjusted seasoning...',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 6),
              Text(
                'This note will be saved in the revision history.',
                style: GoogleFonts.courierPrime(
                    color: AppColors.creamMuted,
                    fontSize: 11,
                    letterSpacing: 0.5),
              ),
              const SizedBox(height: 28),
            ],

            // Save button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check, size: 16),
                label:
                    Text(_isEditing ? 'SAVE CHANGES' : 'CREATE RECIPE'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─── Helper widgets ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.courierPrime(
        color: AppColors.accent,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 3,
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;
  const _EmptyHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(text,
          style: GoogleFonts.courierPrime(
              color: AppColors.creamMuted,
              fontSize: 12,
              fontStyle: FontStyle.italic)),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CircleButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: onTap == null
                  ? AppColors.border
                  : AppColors.borderAccent),
        ),
        child: Icon(icon,
            size: 16,
            color: onTap == null
                ? AppColors.creamMuted.withAlpha(100)
                : AppColors.accent),
      ),
    );
  }
}

// ─── Ingredient entry ─────────────────────────────────────────────────────────
class _IngEntry {
  final String id;
  final TextEditingController nameCtrl;
  final TextEditingController amountCtrl;
  final TextEditingController unitCtrl;

  _IngEntry({
    required this.id,
    required this.nameCtrl,
    required this.amountCtrl,
    required this.unitCtrl,
  });

  void dispose() {
    nameCtrl.dispose();
    amountCtrl.dispose();
    unitCtrl.dispose();
  }
}

class _IngFormRow extends StatelessWidget {
  final _IngEntry entry;
  final int index;
  final VoidCallback onRemove;

  const _IngFormRow(
      {super.key,
      required this.entry,
      required this.index,
      required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: TextFormField(
              controller: entry.nameCtrl,
              style: GoogleFonts.courierPrime(
                  color: AppColors.cream, fontSize: 13),
              decoration: InputDecoration(
                  labelText: 'Ingredient ${index + 1}',
                  hintText: 'Flour'),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: entry.amountCtrl,
              style: GoogleFonts.courierPrime(
                  color: AppColors.cream, fontSize: 13),
              decoration:
                  const InputDecoration(labelText: 'Amount'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (double.tryParse(v.trim()) == null) return 'Invalid';
                return null;
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: entry.unitCtrl,
              style: GoogleFonts.courierPrime(
                  color: AppColors.cream, fontSize: 13),
              decoration: const InputDecoration(
                  labelText: 'Unit', hintText: 'g, cup…'),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 20),
            color: AppColors.error,
            onPressed: onRemove,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _StepFormRow extends StatelessWidget {
  final TextEditingController ctrl;
  final int number;
  final VoidCallback onRemove;

  const _StepFormRow(
      {super.key,
      required this.ctrl,
      required this.number,
      required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(top: 14),
            decoration: BoxDecoration(
              color: AppColors.bgMid,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: AppColors.borderAccent),
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: GoogleFonts.playfairDisplay(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: ctrl,
              style: GoogleFonts.courierPrime(
                  color: AppColors.cream, fontSize: 13),
              decoration: InputDecoration(
                  labelText: 'Step $number',
                  hintText: 'Describe this step…'),
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 20),
            color: AppColors.error,
            onPressed: onRemove,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
