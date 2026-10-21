import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/osm_map.dart';

/// Pantalla para elegir un punto tocando el mapa.
class LocationPickerScreen extends StatefulWidget {
  final LatLng? initial;
  const LocationPickerScreen({super.key, this.initial});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late LatLng? _point = widget.initial;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toca el mapa para elegir')),
      body: OsmMap(
        center: widget.initial ?? const LatLng(25, 0),
        zoom: widget.initial == null ? 2 : 6,
        onTap: (p) => setState(() => _point = p),
        markers: [if (_point != null) pinMarker(_point!)],
      ),
      floatingActionButton: _point == null
          ? null
          : FloatingActionButton.extended(
              icon: const Icon(Icons.check),
              label: const Text('Usar esta ubicación'),
              onPressed: () => Navigator.of(context).pop(_point),
            ),
    );
  }
}
