// Profile feature has no independent StateNotifier.
//
// Design decision (sdd/firebase-auth-and-recipes/design § 9, point 5):
//   Profile screen reads user data directly from authStateStreamProvider.
//   Logout is delegated to authProvider.notifier.signOut().
//   No separate profile state machine is required.
//
// Usage in ProfileScreen:
//   final authAsync = ref.watch(authStateStreamProvider);  // AppUser? stream
//   ref.read(authProvider.notifier).signOut();             // logout action
//
// Both providers live in:
//   lib/features/auth/presentation/providers/auth_provider.dart
