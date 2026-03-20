import 'package:flutter/material.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../state/app_state.dart';
import 'revision_history_screen.dart';

class RecipeEditScreen extends StatefulWidget {
  final String? recipeId;

  const RecipeEditScreen({super.key, this.recipeId});

  @override
  State<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

class _RecipeEditScreenState extends State<RecipeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _changeNoteController = TextEditingController();
  int _servings = 2;
  final List<_IngredientEntry> _ingredients = [];
  final List<TextEditingController> _stepControllers = [];

  bool get _isEditing => widget.recipeId != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRecipe());
  }

  void _loadRecipe() {
    if (!_isEditing) {
      _addStep();
      _addIngredient();
      return;
    }
    final appState = AppStateProvider.of(context);
    final recipe = appState.getRecipeById(widget.recipeId!);
    if (recipe == null) return;

    _titleController.text = recipe.title;
    _descController.text = recipe.description;
    setState(() {
      _servings = recipe.servings;
      _ingredients.addAll(recipe.ingredients.map((ing) => _IngredientEntry(
            id: ing.id,
            nameController: TextEditingController(text: ing.name),
            amountController:
                TextEditingController(text: _formatAmount(ing.amount)),
            unitController: TextEditingController(text: ing.unit),
          )));
      _stepControllers.addAll(
          recipe.steps.map((s) => TextEditingController(text: s)));
    });
  }

  String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) return amount.toInt().toString();
    return amount.toString();
  }

  void _addIngredient() {
    setState(() {
      _ingredients.add(_IngredientEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nameController: TextEditingController(),
        amountController: TextEditingController(),
        unitController: TextEditingController(),
      ));
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients[index].dispose();
      _ingredients.removeAt(index);
    });
  }

  void _addStep() {
    setState(() => _stepControllers.add(TextEditingController()));
  }

  void _removeStep(int index) {
    setState(() {
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final appState = AppStateProvider.of(context);
    final now = DateTime.now();

    final ingredients = _ingredients
        .where((e) => e.nameController.text.trim().isNotEmpty)
        .map((e) => Ingredient(
              id: e.id,
              name: e.nameController.text.trim(),
              amount:
                  double.tryParse(e.amountController.text.trim()) ?? 0,
              unit: e.unitController.text.trim(),
            ))
        .toList();

    final steps = _stepControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (_isEditing) {
      final existing = appState.getRecipeById(widget.recipeId!)!;
      final updated = existing.copyWith(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        ingredients: ingredients,
        steps: steps,
        servings: _servings,
        updatedAt: now,
      );
      appState.updateRecipe(
        widget.recipeId!,
        updated,
        changeNote: _changeNoteController.text.trim(),
      );

      // Navigate to revision history after edit
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RevisionHistoryScreen(
              recipeId: widget.recipeId!, showLatest: true),
        ),
      );
    } else {
      final recipe = Recipe(
        id: now.millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        ingredients: ingredients,
        steps: steps,
        servings: _servings,
        createdAt: now,
        updatedAt: now,
      );
      appState.addRecipe(recipe);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _changeNoteController.dispose();
    for (final e in _ingredients) {
      e.dispose();
    }
    for (final c in _stepControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Recipe' : 'New Recipe'),
        backgroundColor: colorScheme.surface,
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              'Save',
              style: TextStyle(
                  color: colorScheme.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Basic Info
            _SectionHeader(title: 'Basic Info'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Recipe Title',
                hintText: 'e.g. Classic Spaghetti Carbonara',
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'A brief description of the recipe...',
                prefixIcon: Icon(Icons.description_outlined),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.people_outline, size: 20),
                const SizedBox(width: 8),
                Text('Servings',
                    style: Theme.of(context).textTheme.bodyLarge),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _servings > 1
                      ? () => setState(() => _servings--)
                      : null,
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    '$_servings',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _servings++),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Ingredients
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionHeader(title: 'Ingredients'),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                  onPressed: _addIngredient,
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (_ingredients.isEmpty)
              _EmptyHint(label: 'No ingredients yet. Tap Add to begin.'),
            ...(_ingredients.asMap().entries.map(
                  (e) => _IngredientFormRow(
                    key: ValueKey(e.value.id),
                    entry: e.value,
                    index: e.key,
                    onRemove: () => _removeIngredient(e.key),
                  ),
                )),
            const SizedBox(height: 24),

            // Steps
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionHeader(title: 'Steps'),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Step'),
                  onPressed: _addStep,
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (_stepControllers.isEmpty)
              _EmptyHint(label: 'No steps yet. Tap Add Step to begin.'),
            ...(_stepControllers.asMap().entries.map(
                  (e) => _StepFormRow(
                    key: ValueKey('step_${e.key}'),
                    controller: e.value,
                    stepNumber: e.key + 1,
                    onRemove: () => _removeStep(e.key),
                  ),
                )),
            const SizedBox(height: 24),

            // Change note (only when editing)
            if (_isEditing) ...[
              _SectionHeader(title: 'Change Note'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _changeNoteController,
                decoration: const InputDecoration(
                  labelText: 'What changed? (optional)',
                  hintText: 'e.g. Adjusted seasoning, added extra step...',
                  prefixIcon: Icon(Icons.edit_note),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 8),
              Text(
                'This will be saved in the revision history.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: Text(_isEditing ? 'Save Changes' : 'Create Recipe'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String label;
  const _EmptyHint({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
      ),
    );
  }
}

class _IngredientEntry {
  final String id;
  final TextEditingController nameController;
  final TextEditingController amountController;
  final TextEditingController unitController;

  _IngredientEntry({
    required this.id,
    required this.nameController,
    required this.amountController,
    required this.unitController,
  });

  void dispose() {
    nameController.dispose();
    amountController.dispose();
    unitController.dispose();
  }
}

class _IngredientFormRow extends StatelessWidget {
  final _IngredientEntry entry;
  final int index;
  final VoidCallback onRemove;

  const _IngredientFormRow({
    super.key,
    required this.entry,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: TextFormField(
              controller: entry.nameController,
              decoration: InputDecoration(
                labelText: 'Ingredient ${index + 1}',
                hintText: 'e.g. Flour',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: entry.amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
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
              controller: entry.unitController,
              decoration: const InputDecoration(
                  labelText: 'Unit', hintText: 'g, cup...'),
              textCapitalization: TextCapitalization.none,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            color: Theme.of(context).colorScheme.error,
            onPressed: onRemove,
            tooltip: 'Remove ingredient',
          ),
        ],
      ),
    );
  }
}

class _StepFormRow extends StatelessWidget {
  final TextEditingController controller;
  final int stepNumber;
  final VoidCallback onRemove;

  const _StepFormRow({
    super.key,
    required this.controller,
    required this.stepNumber,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(top: 14),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$stepNumber',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                  labelText: 'Step $stepNumber',
                  hintText: 'Describe this step...'),
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            color: colorScheme.error,
            onPressed: onRemove,
            tooltip: 'Remove step',
          ),
        ],
      ),
    );
  }
}
