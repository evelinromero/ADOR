import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/song_widgets.dart';
import 'map_screen.dart';
import 'song_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  String _query = '';

  List<Song> _filter(List<Song> songs) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return songs;
    return songs
        .where((s) =>
            s.title.toLowerCase().contains(q) ||
            s.artist.toLowerCase().contains(q) ||
            s.event.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user!;

    final Widget body;
    switch (_tab) {
      case 0:
        body = _songList(state, _filter(state.songs),
            emptyText: _query.isEmpty
                ? (state.isAdmin
                    ? 'Aún no hay canciones.\nToca "Agregar" para crear la primera.'
                    : 'Aún no hay canciones.')
                : 'Sin resultados para "$_query"',
            withSearch: true);
      case 1:
        body = _songList(
            state,
            state.songs.where((s) => state.isFavorite(s.id)).toList(),
            emptyText:
                'No tienes favoritos.\nToca el corazón de una canción para guardarla.');
      default:
        body = const MapScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(['Canciones', 'Favoritos', 'Mapa'][_tab]),
        actions: [
          if (state.isAdmin)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Chip(
                label: Text('ADMIN', style: TextStyle(fontSize: 11)),
                visualDensity: VisualDensity.compact,
                backgroundColor: kAccent,
                side: BorderSide.none,
              ),
            ),
          PopupMenuButton<String>(
            icon: CircleAvatar(
              radius: 16,
              backgroundImage:
                  user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
              child: user.photoUrl == null
                  ? Text(user.name.characters.first.toUpperCase())
                  : null,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                enabled: false,
                child: Text('${user.name}\n${user.email}',
                    style: const TextStyle(color: Colors.white70)),
              ),
              const PopupMenuItem(value: 'logout', child: Text('Cerrar sesión')),
            ],
            onSelected: (v) {
              if (v == 'logout') state.backend.signOut();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: body,
      floatingActionButton: state.isAdmin && _tab == 0
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text('Agregar'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const SongFormScreen())),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.library_music_outlined),
              selectedIcon: Icon(Icons.library_music),
              label: 'Canciones'),
          NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: 'Favoritos'),
          NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: 'Mapa'),
        ],
      ),
    );
  }

  Widget _songList(AppState state, List<Song> songs,
      {required String emptyText, bool withSearch = false}) {
    if (state.loadingSongs) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        if (withSearch)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar canción, banda o suceso',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide.none),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        Expanded(
          child: songs.isEmpty
              ? EmptyState(icon: Icons.music_off, text: emptyText)
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: songs.length,
                  itemBuilder: (_, i) => SongCard(song: songs[i]),
                ),
        ),
      ],
    );
  }
}
