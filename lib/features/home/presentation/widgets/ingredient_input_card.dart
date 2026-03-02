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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Row(
            children: [
              const Text('🥗', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text(
                'Mis ingredientes',
                style: TextStyle(
                  fontSize: 16,
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

          const SizedBox(height: 14),

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
                    hintText: 'Ej: pollo, tomate, ajo...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _AddButton(onTap: _submit),
            ],
          ),

          // Chips de ingredientes
          if (widget.ingredients.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.ingredients.asMap().entries.map((entry) {
                return AppChip(
                  label: entry.value,
                  onRemove: () => widget.onRemove(entry.key),
                )
                    .animate()
                    .fadeIn(duration: 250.ms)
                    .scale(begin: const Offset(0.8, 0.8));
              }).toList(),
            ),
          ] else ...[
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Agrega ingredientes para comenzar 👆',
                style: TextStyle(
                  fontSize: 13,
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
        duration: const Duration(milliseconds: 150),
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
    );
  }
}

