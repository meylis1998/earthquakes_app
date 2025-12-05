import 'package:flutter/material.dart';

import '../../app/theme/design_tokens.dart';
import '../../core/utils/earthquake_utils.dart';

/// Animated map marker for earthquake visualization.
/// Features pulse animation and selection state.
class AnimatedMarker extends StatefulWidget {
  final double magnitude;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool enablePulse;

  const AnimatedMarker({
    super.key,
    required this.magnitude,
    this.isSelected = false,
    this.onTap,
    this.enablePulse = false,
  });

  @override
  State<AnimatedMarker> createState() => _AnimatedMarkerState();
}

class _AnimatedMarkerState extends State<AnimatedMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.enablePulse && widget.magnitude >= 5.0) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enablePulse != oldWidget.enablePulse ||
        widget.magnitude != oldWidget.magnitude) {
      if (widget.enablePulse && widget.magnitude >= 5.0) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = EarthquakeUtils.getMagnitudeColor(widget.magnitude);
    final baseSize = EarthquakeUtils.getMarkerSize(widget.magnitude);
    final size = widget.isSelected ? baseSize + 8 : baseSize;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          final scale =
              widget.enablePulse && widget.magnitude >= 5.0
                  ? _pulseAnimation.value
                  : 1.0;

          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withAlpha((0.3 * 255).round()),
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.isSelected ? Colors.white : color,
              width: widget.isSelected ? 3 : 2,
            ),
            boxShadow: [
              if (widget.isSelected) ...[
                BoxShadow(
                  color: color.withAlpha((0.5 * 255).round()),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.white.withAlpha((0.3 * 255).round()),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ] else
                BoxShadow(
                  color: color.withAlpha((0.4 * 255).round()),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
            ],
          ),
          child: Center(
            child: Container(
              width: size * 0.4,
              height: size * 0.4,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Simple static marker without animation.
class SimpleMarker extends StatelessWidget {
  final double magnitude;
  final bool isSelected;
  final VoidCallback? onTap;

  const SimpleMarker({
    super.key,
    required this.magnitude,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = EarthquakeUtils.getMagnitudeColor(magnitude);
    final baseSize = EarthquakeUtils.getMarkerSize(magnitude);
    final size = isSelected ? baseSize + 8 : baseSize;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withAlpha((0.3 * 255).round()),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : color,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withAlpha((0.5 * 255).round()),
                blurRadius: 12,
                spreadRadius: 2,
              )
            else
              BoxShadow(
                color: color.withAlpha((0.4 * 255).round()),
                blurRadius: 6,
                spreadRadius: 0,
              ),
          ],
        ),
        child: Center(
          child: Container(
            width: size * 0.4,
            height: size * 0.4,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

/// Marker with magnitude label.
class LabeledMarker extends StatelessWidget {
  final double magnitude;
  final bool isSelected;
  final VoidCallback? onTap;

  const LabeledMarker({
    super.key,
    required this.magnitude,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = EarthquakeUtils.getMagnitudeColor(magnitude);
    final baseSize = EarthquakeUtils.getMarkerSize(magnitude);
    final size = isSelected ? baseSize + 8 : baseSize;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.borderRadiusSm,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.2 * 255).round()),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              magnitude.toStringAsFixed(1),
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          CustomPaint(
            size: const Size(8, 6),
            painter: _TrianglePainter(color: color),
          ),
          Container(
            width: size * 0.5,
            height: size * 0.5,
            decoration: BoxDecoration(
              color: color.withAlpha((0.3 * 255).round()),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Cluster marker for grouped earthquakes.
class ClusterMarker extends StatelessWidget {
  final int count;
  final double maxMagnitude;
  final VoidCallback? onTap;

  const ClusterMarker({
    super.key,
    required this.count,
    required this.maxMagnitude,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = EarthquakeUtils.getMagnitudeColor(maxMagnitude);
    final size = 48.0 + (count.clamp(0, 50) * 0.5);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withAlpha((0.3 * 255).round()),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha((0.4 * 255).round()),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
