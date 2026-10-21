import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/osm_map.dart';
import '../widgets/song_widgets.dart';
import 'song_detail_screen.dart';

/// Todas las canciones con ubicación en un mapa.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final songs =
        context.watch<AppState>().songs.where((s) => s.hasLocation).toList();
    if (songs.isEmpty) {
      return const EmptyState(
          icon: Icons.location_off,
          text: 'Ninguna canción tiene ubicación todavía.');
    }
    return OsmMap(
      center: const LatLng(30, -20),
      zoom: 2,
      markers: [
        for (final s in songs)
          pinMarker(
            LatLng(s.latitude!, s.longitude!),
            label: s.title,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SongDetailScreen(songId: s.id))),
          ),
      ],
    );
  }
}
