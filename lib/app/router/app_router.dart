import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/animations/page_transitions.dart' show HeroDetailPage;
import '../../presentation/navigation/app_shell.dart';
import '../../presentation/screens/earthquake_detail_screen.dart';
import '../../presentation/screens/earthquake_list_screen.dart';
import '../../presentation/screens/earthquake_map_screen.dart';
import '../../presentation/screens/favorites_screen.dart';
import '../theme/app_colors.dart';
import '../theme/design_tokens.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Shell route for bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Earthquakes list
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: const EarthquakeListScreen(),
                ),
              ),
            ],
          ),
          // Branch 1: Map
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/map',
                name: 'map',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: const EarthquakeMapScreen(),
                ),
              ),
            ],
          ),
          // Branch 2: Favorites/Saved
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/saved',
                name: 'saved',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: const FavoritesScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      // Detail route - outside shell (full screen, no bottom nav)
      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return HeroDetailPage(
            child: EarthquakeDetailScreen(earthquakeId: id),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => _ErrorPage(uri: state.uri.toString()),
  );
}

/// Error page with refined styling.
class _ErrorPage extends StatelessWidget {
  final String uri;

  const _ErrorPage({required this.uri});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.gray800
                        : AppColors.gray100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.explore_off_rounded,
                    size: AppIconSize.xxl,
                    color: AppColors.gray500,
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                Text(
                  'Page not found',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  uri,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.xxl),
                FilledButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
