import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/utils/earthquake_utils.dart';
import '../../data/models/earthquake.dart';
import '../bloc/bloc_exports.dart';

class EarthquakeMapScreen extends StatefulWidget {
  const EarthquakeMapScreen({super.key});

  @override
  State<EarthquakeMapScreen> createState() => _EarthquakeMapScreenState();
}

class _EarthquakeMapScreenState extends State<EarthquakeMapScreen> {
  final MapController _mapController = MapController();
  EarthquakeFeature? _selectedEarthquake;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquake Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Fit all earthquakes',
            onPressed: _fitAllMarkers,
          ),
        ],
      ),
      body: BlocBuilder<EarthquakeBloc, EarthquakeState>(
        builder: (context, state) {
          if (state.earthquakes.isEmpty) {
            return const Center(
              child: Text('No earthquakes to display on map'),
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _getInitialCenter(state.earthquakes),
                  initialZoom: 2,
                  onTap: (_, _) {
                    setState(() {
                      _selectedEarthquake = null;
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.earthquakes',
                  ),
                  MarkerLayer(
                    markers: _buildMarkers(state.earthquakes),
                  ),
                ],
              ),
              if (_selectedEarthquake != null)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16 + MediaQuery.of(context).padding.bottom,
                  child: _EarthquakeInfoCard(
                    earthquake: _selectedEarthquake!,
                    onClose: () {
                      setState(() {
                        _selectedEarthquake = null;
                      });
                    },
                    onTap: () {
                      context.push('/detail/${_selectedEarthquake!.id}');
                    },
                  ),
                ),
              Positioned(
                top: 16,
                left: 16,
                child: _MapLegend(),
              ),
            ],
          );
        },
      ),
    );
  }

  LatLng _getInitialCenter(List<EarthquakeFeature> earthquakes) {
    if (earthquakes.isEmpty) {
      return const LatLng(0, 0);
    }

    double sumLat = 0;
    double sumLng = 0;

    for (final eq in earthquakes) {
      sumLat += eq.latitude;
      sumLng += eq.longitude;
    }

    return LatLng(sumLat / earthquakes.length, sumLng / earthquakes.length);
  }

  List<Marker> _buildMarkers(List<EarthquakeFeature> earthquakes) {
    return earthquakes.map((eq) {
      final mag = eq.properties.mag ?? 0;
      final color = EarthquakeUtils.getMagnitudeColor(mag);
      final size = EarthquakeUtils.getMarkerSize(mag);
      final isSelected = _selectedEarthquake?.id == eq.id;

      return Marker(
        point: LatLng(eq.latitude, eq.longitude),
        width: size + (isSelected ? 8 : 0),
        height: size + (isSelected ? 8 : 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedEarthquake = eq;
            });
            _mapController.move(
              LatLng(eq.latitude, eq.longitude),
              _mapController.camera.zoom,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: color.withAlpha((isSelected ? 0.5 : 0.3) * 255 ~/ 1),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : color,
                width: isSelected ? 3 : 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withAlpha((0.5 * 255).round()),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                mag.toStringAsFixed(1),
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _fitAllMarkers() {
    final state = context.read<EarthquakeBloc>().state;
    if (state.earthquakes.isEmpty) return;

    final bounds = LatLngBounds.fromPoints(
      state.earthquakes.map((e) => LatLng(e.latitude, e.longitude)).toList(),
    );

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50),
      ),
    );
  }
}

class _EarthquakeInfoCard extends StatelessWidget {
  final EarthquakeFeature earthquake;
  final VoidCallback onClose;
  final VoidCallback onTap;

  const _EarthquakeInfoCard({
    required this.earthquake,
    required this.onClose,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final props = earthquake.properties;
    final mag = props.mag ?? 0;
    final color = EarthquakeUtils.getMagnitudeColor(mag);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withAlpha((0.15 * 255).round()),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Center(
                  child: Text(
                    mag.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      props.place ?? 'Unknown Location',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          earthquake.magnitudeClass,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${EarthquakeUtils.formatDepth(earthquake.depth)} deep',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                    visualDensity: VisualDensity.compact,
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Magnitude',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _LegendItem(color: Colors.green, label: '< 3.0'),
            _LegendItem(color: Colors.yellow.shade700, label: '3.0 - 4.9'),
            _LegendItem(color: Colors.orange, label: '5.0 - 5.9'),
            _LegendItem(color: Colors.red, label: '6.0+'),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color.withAlpha((0.3 * 255).round()),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
