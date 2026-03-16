import 'dart:async';
import 'package:flutter/foundation.dart';

/// A [ChangeNotifier] that wraps a [Stream] and calls [notifyListeners] on
/// every emission. Used as [GoRouter.refreshListenable] so that GoRouter
/// re-evaluates its redirect callback every time the auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
