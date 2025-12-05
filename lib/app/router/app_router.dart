import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/earthquake_detail_screen.dart';
import '../../presentation/screens/earthquake_list_screen.dart';
import '../../presentation/screens/earthquake_map_screen.dart';
import '../../presentation/screens/favorites_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const EarthquakeListScreen(),
      ),
      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EarthquakeDetailScreen(earthquakeId: id);
        },
      ),
      GoRoute(
        path: '/map',
        name: 'map',
        builder: (context, state) => const EarthquakeMapScreen(),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
