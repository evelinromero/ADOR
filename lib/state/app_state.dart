import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/song.dart';
import '../services/backend.dart';

class AppState extends ChangeNotifier {
  final Backend backend;

  AppUser? user;
  List<Song> songs = [];
  Set<String> favorites = {};
  bool loadingSongs = true;

  StreamSubscription<AppUser?>? _authSub;
  StreamSubscription<List<Song>>? _songsSub;
  StreamSubscription<Set<String>>? _favSub;

  AppState(this.backend) {
    _authSub = backend.authChanges().listen(_onUser);
  }

  bool get isAdmin => user?.isAdmin ?? false;

  void _onUser(AppUser? u) {
    user = u;
    _songsSub?.cancel();
    _favSub?.cancel();
    songs = [];
    favorites = {};
    if (u != null) {
      loadingSongs = true;
      _songsSub = backend.songs().listen((list) {
        songs = list;
        loadingSongs = false;
        notifyListeners();
      }, onError: (Object e) {
        loadingSongs = false;
        debugPrint('Error cargando canciones: $e');
        notifyListeners();
      });
      _favSub = backend.favorites(u.uid).listen((f) {
        favorites = f;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  Song? songById(String id) {
    for (final s in songs) {
      if (s.id == id) return s;
    }
    return null;
  }

  bool isFavorite(String songId) => favorites.contains(songId);

  Future<void> toggleFavorite(String songId) async {
    final u = user;
    if (u == null) return;
    final fav = !isFavorite(songId);
    // Actualización optimista
    fav ? favorites.add(songId) : favorites.remove(songId);
    notifyListeners();
    await backend.setFavorite(u.uid, songId, fav);
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _songsSub?.cancel();
    _favSub?.cancel();
    super.dispose();
  }
}
