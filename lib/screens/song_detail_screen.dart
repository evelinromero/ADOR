import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/song.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/audio_player_card.dart';
import '../widgets/osm_map.dart';
import '../widgets/song_widgets.dart';
import 'song_form_screen.dart';

class SongDetailScreen extends StatelessWidget {
  final String songId;
  const SongDetailScreen({super.key, required this.songId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final song = state.songById(songId);
    if (song == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
            icon: Icons.music_off, text: 'Esta canción ya no existe.'),
      );
    }
    final fav = state.isFavorite(song.id);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
                    color: fav ? kAccent : null),
                tooltip: 'Favorito',
                onPressed: () => state.toggleFavorite(song.id),
              ),
              if (state.isAdmin) ...[
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Editar',
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SongFormScreen(song: song))),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Eliminar',
                  onPressed: () => _confirmDelete(context, state, song),
                ),
              ],
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(fit: StackFit.expand, children: [
                Hero(
                  tag: 'img-${song.id}',
                  child: SongImage(base64Image: song.imageBase64),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, kBackground],
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            sliver: SliverList.list(children: [
              Text(song.title,
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                [
                  song.artist,
                  if (song.year != null) '${song.year}',
                  if (song.genre.isNotEmpty) song.genre,
                ].join(' · '),
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: Colors.white70),
              ),
              if (song.event.isNotEmpty) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    avatar: const Icon(Icons.history_edu, size: 18),
                    label: Text(song.event),
                    backgroundColor: const Color(0xFF3B0A10),
                    side: BorderSide.none,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (song.audioUrl.isNotEmpty) AudioPlayerCard(url: song.audioUrl),
              if (song.externalUrl.isNotEmpty) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Escuchar en YouTube / Spotify'),
                  onPressed: () => launchUrl(Uri.parse(song.externalUrl),
                      mode: LaunchMode.externalApplication),
                ),
              ],
              if (song.audioUrl.isEmpty && song.externalUrl.isEmpty)
                const Text('Esta canción aún no tiene audio.',
                    style: TextStyle(color: Colors.white38)),
              _Section(
                  icon: Icons.public,
                  title: 'El suceso',
                  text: song.history),
              _Section(
                  icon: Icons.visibility,
                  title: 'Lo que dice entre líneas',
                  text: song.meaning),
              _Section(icon: Icons.lyrics, title: 'Letra', text: song.lyrics),
              if (song.hasLocation) ...[
                const SizedBox(height: 28),
                _SectionTitle(
                    icon: Icons.place,
                    title: song.placeName.isEmpty ? 'Ubicación' : song.placeName),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 220,
                    child: OsmMap(
                      center: LatLng(song.latitude!, song.longitude!),
                      zoom: 6,
                      markers: [
                        pinMarker(LatLng(song.latitude!, song.longitude!))
                      ],
                    ),
                  ),
                ),
              ],
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, AppState state, Song song) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar canción'),
        content: Text('¿Seguro que quieres eliminar "${song.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    Navigator.of(context).pop();
    await state.backend.deleteSong(song.id);
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, color: kAccent, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ),
      ]);
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const _Section({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(icon: icon, title: title),
          const SizedBox(height: 10),
          SelectableText(text,
              style: const TextStyle(
                  fontSize: 15.5, height: 1.55, color: Colors.white)),
        ],
      ),
    );
  }
}
