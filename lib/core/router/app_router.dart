import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_shell.dart';
import 'go_router_refresh_stream.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/camera_screen.dart';
import '../../features/recipe/presentation/screens/recipe_screen.dart';
import '../../features/saved_recipes/presentation/screens/saved_recipes_screen.dart';
import '../../features/saved_recipes/presentation/screens/saved_recipe_detail_screen.dart';
import '../../features/recipe/domain/entities/recipe_entity.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

// ─── Router provider ──────────────────────────────────────────────────────────

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,

    // Triggers redirect re-evaluation on every Firebase auth state change.
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),

    redirect: (BuildContext context, GoRouterState state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggedIn = user != null;
      final loc = state.matchedLocation;
      final isAuthRoute = loc == '/login' || loc == '/register';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/';
      return null;
    },

    routes: [
      // ── Auth routes (outside shell — no bottom nav) ──
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // ── Top-level stack routes (pushed on top of shell — no bottom nav) ──
      GoRoute(
        path: '/recipe',
        builder: (context, state) => const RecipeScreen(),
      ),
      GoRoute(
        path: '/camera',
        builder: (context, state) => const CameraScreen(),
      ),

      // ── Authenticated shell: 3-tab bottom navigation ──
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // Branch 0 — Home tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Branch 1 — Saved Recipes tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/saved',
                builder: (context, state) => const SavedRecipesScreen(),
                routes: [
                  GoRoute(
                    path: 'detail',
                    builder: (context, state) {
                      final recipe = state.extra as RecipeEntity;
                      return SavedRecipeDetailScreen(recipe: recipe);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch 2 — Profile tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
