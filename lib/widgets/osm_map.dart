import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../theme.dart';

/// Mapa de OpenStreetMap (no necesita API key).
class OsmMap extends StatelessWidget {
  final LatLng center;
  final double zoom;
  final List<Marker> markers;
  final void Function(LatLng)? onTap;
  final bool interactive;
  final MapController? controller;

  const OsmMap({
    super.key,
    required this.center,
    this.zoom = 4,
    this.markers = const [],
    this.onTap,
    this.interactive = true,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: center,
        initialZoom: zoom,
        onTap: onTap == null ? null : (_, p) => onTap!(p),
        interactionOptions: InteractionOptions(
          flags: interactive ? InteractiveFlag.all & ~InteractiveFlag.rotate
              : InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.mi_app',
        ),
        MarkerLayer(markers: markers),
        const SimpleAttributionWidget(
          source: Text('OpenStreetMap', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}

Marker pinMarker(LatLng p, {VoidCallback? onTap, String? label}) => Marker(
      point: p,
      width: 140,
      height: 70,
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 11)),
              ),
            const Icon(Icons.location_on, color: kAccent, size: 40),
          ],
        ),
      ),
    );
