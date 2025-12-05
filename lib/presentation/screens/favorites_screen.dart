import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/design_tokens.dart';
import '../../data/models/favorite_location.dart';
import '../animations/animation_utils.dart';
import '../bloc/bloc_exports.dart';
import '../widgets/error_view.dart';
import '../widgets/skeleton_loading.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(
              'Saved Locations',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha((0.1 * 255).round()),
                    borderRadius: AppRadius.borderRadiusSm,
                  ),
                  child: Icon(
                    Icons.add_location_alt_rounded,
                    size: AppIconSize.sm,
                    color: theme.colorScheme.primary,
                  ),
                ),
                tooltip: 'Add custom location',
                onPressed: () => _showAddLocationSheet(context),
              ),
              SizedBox(width: AppSpacing.sm),
            ],
          ),

          // Content
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              if (state.status == FavoritesStatus.loading) {
                return SliverPadding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.md),
                        child: LocationCardSkeleton(),
                      ),
                      childCount: 4,
                    ),
                  ),
                );
              }

              final customLocations = state.favorites.where((f) => !f.isPredefined).toList();
              final hasAnyLocations = state.predefinedLocations.isNotEmpty || customLocations.isNotEmpty;

              if (!hasAnyLocations) {
                return SliverFillRemaining(
                  child: EmptyView.noFavorites(
                    onAddLocation: () => _showAddLocationSheet(context),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildListDelegate([
                  // Predefined locations section
                  if (state.predefinedLocations.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Turkmenistan',
                      icon: Icons.flag_rounded,
                      count: state.predefinedLocations.length,
                    ),
                    ...state.predefinedLocations.asMap().entries.map((entry) {
                      final index = entry.key;
                      final location = entry.value;
                      return SlideUpFadeIn(
                        delay: Duration(milliseconds: 50 * index),
                        child: _LocationCard(
                          location: location,
                          isFavorite: state.isFavorite(location.id),
                          onTap: () => _loadEarthquakesNear(context, location),
                          onFavoriteToggle: () {
                            context.read<FavoritesCubit>().toggleFavorite(location);
                          },
                        ),
                      );
                    }),
                    SizedBox(height: AppSpacing.xl),
                  ],

                  // Custom locations section
                  if (customLocations.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'My Locations',
                      icon: Icons.bookmark_rounded,
                      count: customLocations.length,
                    ),
                    ...customLocations.asMap().entries.map((entry) {
                      final index = entry.key;
                      final location = entry.value;
                      return SlideUpFadeIn(
                        delay: Duration(milliseconds: 50 * (index + state.predefinedLocations.length)),
                        child: _DismissibleLocationCard(
                          location: location,
                          isFavorite: state.isFavorite(location.id),
                          onTap: () => _loadEarthquakesNear(context, location),
                          onFavoriteToggle: () {
                            context.read<FavoritesCubit>().toggleFavorite(location);
                          },
                          onDelete: () {
                            context.read<FavoritesCubit>().removeFavorite(location.id);
                          },
                        ),
                      );
                    }),
                  ],

                  // Bottom padding
                  SizedBox(height: AppSpacing.xxl + MediaQuery.of(context).padding.bottom),
                ]),
              );
            },
          ),
        ],
      ),
    );
  }

  void _loadEarthquakesNear(BuildContext context, FavoriteLocation location) {
    context.read<EarthquakeBloc>().add(LoadNearbyEarthquakes(
      latitude: location.latitude,
      longitude: location.longitude,
      radiusKm: location.radiusKm,
      minMagnitude: 2.5,
      days: 30,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text('Loading earthquakes near ${location.name}...'),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(AppSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    context.go('/');
  }

  void _showAddLocationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<FavoritesCubit>(),
        child: const _AddLocationSheet(),
      ),
    );
  }
}

/// Section header with icon and count.
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha((0.1 * 255).round()),
              borderRadius: AppRadius.borderRadiusSm,
            ),
            child: Icon(
              icon,
              size: AppIconSize.sm,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: AppRadius.borderRadiusSm,
            ),
            child: Text(
              '$count',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Location card with modern styling.
class _LocationCard extends StatelessWidget {
  final FavoriteLocation location;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const _LocationCard({
    required this.location,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Material(
        color: isDark ? AppColors.surfaceContainerDark : Colors.white,
        borderRadius: AppRadius.borderRadiusMd,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.borderRadiusMd,
          child: Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: AppRadius.borderRadiusMd,
              border: Border.all(
                color: isDark
                    ? AppColors.gray700.withAlpha((0.3 * 255).round())
                    : AppColors.gray200.withAlpha((0.5 * 255).round()),
              ),
            ),
            child: Row(
              children: [
                // Location icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withAlpha((0.2 * 255).round()),
                        theme.colorScheme.primary.withAlpha((0.05 * 255).round()),
                      ],
                    ),
                    borderRadius: AppRadius.borderRadiusMd,
                  ),
                  child: Icon(
                    location.isPredefined ? Icons.location_city_rounded : Icons.place_rounded,
                    color: theme.colorScheme.primary,
                    size: AppIconSize.lg,
                  ),
                ),
                SizedBox(width: AppSpacing.lg),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Icon(
                            Icons.my_location_rounded,
                            size: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            '${location.latitude.toStringAsFixed(2)}°, ${location.longitude.toStringAsFixed(2)}°',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(width: AppSpacing.md),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha((0.1 * 255).round()),
                              borderRadius: AppRadius.borderRadiusSm,
                            ),
                            child: Text(
                              '${location.radiusKm.toInt()} km',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Favorite toggle
                TapScaleAnimation(
                  onTap: onFavoriteToggle,
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: Icon(
                      isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: isFavorite ? AppColors.warning : theme.colorScheme.onSurfaceVariant,
                      size: AppIconSize.lg,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Dismissible location card with swipe to delete.
class _DismissibleLocationCard extends StatelessWidget {
  final FavoriteLocation location;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onDelete;

  const _DismissibleLocationCard({
    required this.location,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(location.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: AppRadius.borderRadiusMd,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppSpacing.xl),
        child: Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: AppIconSize.lg,
        ),
      ),
      child: _LocationCard(
        location: location,
        isFavorite: isFavorite,
        onTap: onTap,
        onFavoriteToggle: onFavoriteToggle,
      ),
    );
  }
}

/// Bottom sheet for adding custom location.
class _AddLocationSheet extends StatefulWidget {
  const _AddLocationSheet();

  @override
  State<_AddLocationSheet> createState() => _AddLocationSheetState();
}

class _AddLocationSheetState extends State<_AddLocationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  double _radius = 500;

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return ClipRRect(
      borderRadius: AppRadius.borderRadiusTopXl,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.xl + bottomPadding,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceContainerDark.withAlpha((0.95 * 255).round())
                : Colors.white.withAlpha((0.98 * 255).round()),
            borderRadius: AppRadius.borderRadiusTopXl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.gray600 : AppColors.gray300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xl),

                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha((0.1 * 255).round()),
                        borderRadius: AppRadius.borderRadiusMd,
                      ),
                      child: Icon(
                        Icons.add_location_alt_rounded,
                        color: theme.colorScheme.primary,
                        size: AppIconSize.lg,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Location',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Monitor earthquakes in a custom area',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl),

                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Location Name',
                    hintText: 'e.g., My City',
                    prefixIcon: Icon(Icons.label_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.lg),

                // Coordinates row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latController,
                        decoration: InputDecoration(
                          labelText: 'Latitude',
                          hintText: '37.96',
                          prefixIcon: Icon(Icons.north_rounded),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          final lat = double.tryParse(value);
                          if (lat == null || lat < -90 || lat > 90) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _lngController,
                        decoration: InputDecoration(
                          labelText: 'Longitude',
                          hintText: '58.33',
                          prefixIcon: Icon(Icons.east_rounded),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          final lng = double.tryParse(value);
                          if (lng == null || lng < -180 || lng > 180) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl),

                // Radius slider
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Search Radius',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha((0.1 * 255).round()),
                            borderRadius: AppRadius.borderRadiusSm,
                          ),
                          child: Text(
                            '${_radius.toInt()} km',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Slider(
                      value: _radius,
                      min: 50,
                      max: 2000,
                      divisions: 39,
                      onChanged: (value) {
                        setState(() {
                          _radius = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '50 km',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '2000 km',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add Location'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<FavoritesCubit>().addCustomLocation(
        name: _nameController.text.trim(),
        latitude: double.parse(_latController.text),
        longitude: double.parse(_lngController.text),
        radiusKm: _radius,
      );
      Navigator.pop(context);
    }
  }
}
