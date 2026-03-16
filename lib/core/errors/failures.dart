abstract class AppFailure {
  final String message;
  final String? technicalDetail;
  const AppFailure(this.message, {this.technicalDetail});
}

class RateLimitFailure extends AppFailure {
  const RateLimitFailure()
      : super(
          '¡Vaya! La cocina está muy ocupada 🍳\nEspera unos segundos e intenta de nuevo.',
        );
}

class NetworkFailure extends AppFailure {
  const NetworkFailure()
      : super(
          'Sin conexión a internet 📡\nRevisa tu red e intenta de nuevo.',
        );
}

class TimeoutFailure extends AppFailure {
  const TimeoutFailure()
      : super(
          'El chef tardó demasiado 🕐\nIntenta de nuevo en un momento.',
        );
}

class ImageTooLargeFailure extends AppFailure {
  const ImageTooLargeFailure()
      : super(
          'La foto es muy pesada 📸\nIntenta con una imagen más pequeña.',
        );
}

class ParseFailure extends AppFailure {
  const ParseFailure()
      : super(
          'El chef se confundió con la receta 🤔\nIntenta de nuevo.',
        );
}

class UnknownFailure extends AppFailure {
  const UnknownFailure(String detail)
      : super(
          'Algo salió mal en la cocina 😅\nIntenta de nuevo.',
          technicalDetail: detail,
        );
}

// ─── Auth failures ────────────────────────────────────────────────────────────

class AuthFailure extends AppFailure {
  const AuthFailure(super.message, {super.technicalDetail});
}

/// Thrown when the user cancels the Google Sign-In picker.
/// AuthNotifier catches this and stays silent (no error state).
class GoogleSignInCancelledFailure extends AppFailure {
  const GoogleSignInCancelledFailure()
      : super('', technicalDetail: 'user-cancelled');
}