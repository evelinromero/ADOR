import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../screens/song_detail_screen.dart';
import '../state/app_state.dart';
import '../theme.dart';

/// Imagen de la canción (base64) o un fondo de respaldo con icono.
class SongImage extends StatelessWidget {
  final String? base64Image;
  final double? width;
  final double? height;
  final BorderRadius? radius;

  const SongImage(
      {super.key, this.base64Image, this.width, this.height, this.radius});

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (base64Image != null && base64Image!.isNotEmpty) {
      child = Image.memory(
        base64Decode(base64Image!),
        width: width,
        height: height,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    } else {
      child = Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A1015), Color(0xFF1E1A20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(Icons.music_note, color: Colors.white38, size: 40),
      );
    }
    return radius == null ? child : ClipRRect(borderRadius: radius!, child: child);
  }
}

class SongCard extends StatelessWidget {
  final Song song;
  const SongCard({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final fav = state.isFavorite(song.id);
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => SongDetailScreen(songId: song.id))),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Hero(
                tag: 'img-${song.id}',
                child: SongImage(
                  base64Image: song.imageBase64,
                  width: 76,
                  height: 76,
                  radius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text(
                      [song.artist, if (song.year != null) '${song.year}']
                          .join(' · '),
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.white70),
                    ),
                    if (song.event.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.history_edu,
                            size: 14, color: kAccent),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(song.event,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: const Color(0xFFEF9A9A))),
                        ),
                      ]),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: fav ? 'Quitar de favoritos' : 'Agregar a favoritos',
                icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
                    color: fav ? kAccent : Colors.white54),
                onPressed: () => state.toggleFavorite(song.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;
  const EmptyState({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 56, color: Colors.white24),
            const SizedBox(height: 12),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54)),
          ]),
        ),
      );
}
