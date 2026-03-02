import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_chip.dart';

class IngredientInputCard extends StatefulWidget {
  final List<String> ingredients;
  final Function(String) onAdd;
  final Function(int) onRemove;

  const IngredientInputCard({
    super.key,
    required this.ingredients,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<IngredientInputCard> createState() => _IngredientInputCardState();
}

class _IngredientInputCardState extends State<IngredientInputCard> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onAdd(text);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Row(
            children: [
              const Text(
                'Ingredientes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (widget.ingredients.isNotEmpty)
                Text(
                  '${widget.ingredients.length} agregados',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // TextField
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    hintText: 'Ej: Pollo, Tomate, Ajo...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.secondary,
                        width: 1
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _AddButton(onTap: _submit),
            ],
          ),

          // Chips de ingredientes
          if (widget.ingredients.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.ingredients.asMap().entries.map((entry) {
                return AppChip(
                  label: entry.value,
                  onRemove: () => widget.onRemove(entry.key),
                )
                    .animate()
                    .fadeIn(duration: 200.ms)
                    .scale(begin: const Offset(0.8, 0.8));
              }).toList(),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Aun no has añadido ingredientes.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Botón "+"
class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

