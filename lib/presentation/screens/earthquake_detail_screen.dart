import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/earthquake_utils.dart';
import '../../data/models/earthquake.dart';
import '../bloc/bloc_exports.dart';
import '../widgets/error_view.dart';

class EarthquakeDetailScreen extends StatefulWidget {
  final String earthquakeId;

  const EarthquakeDetailScreen({
    super.key,
    required this.earthquakeId,
  });

  @override
  State<EarthquakeDetailScreen> createState() => _EarthquakeDetailScreenState();
}

class _EarthquakeDetailScreenState extends State<EarthquakeDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadEarthquake();
  }

  void _loadEarthquake() {
    final bloc = context.read<EarthquakeBloc>();
    final existing = bloc.state.earthquakes.where((e) => e.id == widget.earthquakeId);

    if (existing.isNotEmpty) {
      bloc.add(SelectEarthquake(widget.earthquakeId));
    } else {
      bloc.add(LoadEarthquakeById(widget.earthquakeId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EarthquakeBloc, EarthquakeState>(
        builder: (context, state) {
          final earthquake = state.selectedEarthquake ??
              state.earthquakes.where((e) => e.id == widget.earthquakeId).firstOrNull;

          if (earthquake == null) {
            if (state.status == EarthquakeStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Scaffold(
              appBar: AppBar(),
              body: ErrorView(
                message: 'Earthquake not found',
                onRetry: _loadEarthquake,
              ),
            );
          }

          return _DetailContent(earthquake: earthquake);
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final EarthquakeFeature earthquake;

  const _DetailContent({required this.earthquake});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final props = earthquake.properties;
    final mag = props.mag ?? 0;
    final magColor = EarthquakeUtils.getMagnitudeColor(mag);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: _buildMap(context),
          ),
        ),
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, magColor),
                  const Divider(height: 32),
                  _buildInfoSection(context),
                  const Divider(height: 32),
                  _buildStatsSection(context),
                  if (props.url != null) ...[
                    const Divider(height: 32),
                    _buildActionsSection(context),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMap(BuildContext context) {
    final magColor = EarthquakeUtils.getMagnitudeColor(earthquake.properties.mag);

    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(earthquake.latitude, earthquake.longitude),
        initialZoom: 6,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.earthquakes',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(earthquake.latitude, earthquake.longitude),
              width: 48,
              height: 48,
              child: Container(
                decoration: BoxDecoration(
                  color: magColor.withAlpha((0.3 * 255).round()),
                  shape: BoxShape.circle,
                  border: Border.all(color: magColor, width: 3),
                ),
                child: Center(
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: magColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, Color magColor) {
    final theme = Theme.of(context);
    final props = earthquake.properties;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: magColor.withAlpha((0.15 * 255).round()),
              shape: BoxShape.circle,
              border: Border.all(color: magColor, width: 3),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (props.mag ?? 0).toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: magColor,
                    ),
                  ),
                  Text(
                    props.magType?.toUpperCase() ?? '',
                    style: TextStyle(
                      fontSize: 10,
                      color: magColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  props.place ?? 'Unknown Location',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  earthquake.magnitudeClass,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: magColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (earthquake.hasTsunamiWarning) ...[
                      _Badge(
                        icon: Icons.waves,
                        label: 'Tsunami',
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (props.alert != null)
                      _Badge(
                        icon: Icons.warning_amber,
                        label: props.alert!.toUpperCase(),
                        color: EarthquakeUtils.getAlertColor(props.alert),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final timeFormat = DateFormat('HH:mm:ss');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location & Time',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.calendar_today,
            label: 'Date',
            value: dateFormat.format(earthquake.time.toLocal()),
          ),
          _InfoRow(
            icon: Icons.access_time,
            label: 'Time (Local)',
            value: timeFormat.format(earthquake.time.toLocal()),
          ),
          _InfoRow(
            icon: Icons.location_on,
            label: 'Coordinates',
            value: EarthquakeUtils.formatCoordinates(
              earthquake.latitude,
              earthquake.longitude,
            ),
          ),
          _InfoRow(
            icon: Icons.arrow_downward,
            label: 'Depth',
            value: EarthquakeUtils.formatDepth(earthquake.depth),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final theme = Theme.of(context);
    final props = earthquake.properties;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technical Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _StatCard(
                label: 'Significance',
                value: '${props.sig ?? 0}',
                icon: Icons.priority_high,
              ),
              _StatCard(
                label: 'Felt Reports',
                value: '${props.felt ?? 0}',
                icon: Icons.people,
              ),
              if (props.cdi != null)
                _StatCard(
                  label: 'CDI',
                  value: props.cdi!.toStringAsFixed(1),
                  icon: Icons.assessment,
                ),
              if (props.mmi != null)
                _StatCard(
                  label: 'MMI',
                  value: props.mmi!.toStringAsFixed(1),
                  icon: Icons.show_chart,
                ),
              if (props.nst != null)
                _StatCard(
                  label: 'Stations',
                  value: '${props.nst}',
                  icon: Icons.sensors,
                ),
              if (props.gap != null)
                _StatCard(
                  label: 'Gap',
                  value: '${props.gap!.toStringAsFixed(0)}°',
                  icon: Icons.pie_chart,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    final props = earthquake.properties;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            onPressed: () => _openUsgsPage(props.url!),
            icon: const Icon(Icons.open_in_new),
            label: const Text('View on USGS'),
          ),
        ],
      ),
    );
  }

  Future<void> _openUsgsPage(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha((0.15 * 255).round()),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha((0.5 * 255).round())),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha((0.5 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
