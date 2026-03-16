import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/google_sign_in_button.dart';

/// Login screen — email/password + Google Sign-In.
///
/// On successful authentication, GoRouter's redirect handles navigation
/// automatically (Phase 4). This screen does NOT call context.go() on success.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Inline validation ────────────────────────────────────────────────────

  bool _validate() {
    bool valid = true;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      setState(() => _emailError = 'Ingresá tu correo electrónico');
      valid = false;
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      setState(() => _emailError = 'El formato del correo no es válido');
      valid = false;
    }

    if (password.isEmpty) {
      setState(() => _passwordError = 'Ingresá tu contraseña');
      valid = false;
    }

    return valid;
  }

  void _clearErrors() {
    if (_emailError != null || _passwordError != null) {
      setState(() {
        _emailError = null;
        _passwordError = null;
      });
    }
  }

  // ── Actions ──────────────────────────────────────────────────────────────

  void _signIn() {
    // Clear any auth-level error before re-attempting
    _clearErrors();
    if (!_validate()) return;
    ref.read(authProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _signInWithGoogle() {
    _clearErrors();
    ref.read(authProvider.notifier).signInWithGoogle();
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    // Extract error message from state — shown in inline error container
    final String? authError = authState is AuthError ? authState.message : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // ── Header ──────────────────────────────────────────────────
              Text(
                'MoodFood',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 36,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Iniciá sesión para guardar tus recetas',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),

              const SizedBox(height: 40),

              // ── Auth error container (inline, per spec REQ-AUTH-07) ────
              if (authError != null) ...[
                _ErrorContainer(message: authError),
                const SizedBox(height: 16),
              ],

              // ── Email field ─────────────────────────────────────────────
              AuthTextField(
                label: 'Correo electrónico',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                errorText: _emailError,
                onChanged: (_) {
                  // Clear field-level error + any auth-level error on keystroke
                  if (_emailError != null) setState(() => _emailError = null);
                  if (authState is AuthError) {
                    ref.read(authProvider.notifier).clearError();
                  }
                },
              ),

              const SizedBox(height: 16),

              // ── Password field ──────────────────────────────────────────
              AuthTextField(
                label: 'Contraseña',
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                errorText: _passwordError,
                onChanged: (_) {
                  if (_passwordError != null) setState(() => _passwordError = null);
                  if (authState is AuthError) {
                    ref.read(authProvider.notifier).clearError();
                  }
                },
                onEditingComplete: _signIn,
              ),

              const SizedBox(height: 24),

              // ── Sign-in button ──────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Divider ─────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'o continuá con',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),

              const SizedBox(height: 16),

              // ── Google Sign-In button ───────────────────────────────────
              GoogleSignInButton(
                onPressed: _signInWithGoogle,
                isLoading: isLoading,
              ),

              const SizedBox(height: 32),

              // ── Link to Register ────────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: isLoading ? null : () => context.go('/register'),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        const TextSpan(text: '¿No tenés cuenta? '),
                        TextSpan(
                          text: 'Registrate',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Error container widget ───────────────────────────────────────────────────

class _ErrorContainer extends StatelessWidget {
  final String message;
  const _ErrorContainer({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red.shade800,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
