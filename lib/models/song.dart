class Song {
  final String id;
  final String title;
  final String artist;
  final int? year;
  final String genre;

  /// Suceso histórico que representa la canción (ej. "Guerra en Afganistán").
  final String event;

  /// Contexto / historia del suceso.
  final String history;

  /// Doble sentido / significado oculto de la letra.
  final String meaning;

  final String lyrics;

  /// Imagen en base64 (JPEG comprimido) para no depender de un servidor de archivos.
  final String? imageBase64;

  /// Enlace directo a un audio (mp3) para reproducir dentro de la app.
  final String audioUrl;

  /// Enlace externo (YouTube, Spotify...).
  final String externalUrl;

  /// Lugar donde se creó la canción (opcional).
  final String placeName;
  final double? latitude;
  final double? longitude;

  final DateTime createdAt;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    this.year,
    this.genre = '',
    this.event = '',
    this.history = '',
    this.meaning = '',
    this.lyrics = '',
    this.imageBase64,
    this.audioUrl = '',
    this.externalUrl = '',
    this.placeName = '',
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  bool get hasLocation => latitude != null && longitude != null;

  Song copyWith({String? id}) => Song(
        id: id ?? this.id,
        title: title,
        artist: artist,
        year: year,
        genre: genre,
        event: event,
        history: history,
        meaning: meaning,
        lyrics: lyrics,
        imageBase64: imageBase64,
        audioUrl: audioUrl,
        externalUrl: externalUrl,
        placeName: placeName,
        latitude: latitude,
        longitude: longitude,
        createdAt: createdAt,
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'artist': artist,
        'year': year,
        'genre': genre,
        'event': event,
        'history': history,
        'meaning': meaning,
        'lyrics': lyrics,
        'imageBase64': imageBase64,
        'audioUrl': audioUrl,
        'externalUrl': externalUrl,
        'placeName': placeName,
        'latitude': latitude,
        'longitude': longitude,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  factory Song.fromMap(String id, Map<String, dynamic> m) => Song(
        id: id,
        title: m['title'] as String? ?? '',
        artist: m['artist'] as String? ?? '',
        year: (m['year'] as num?)?.toInt(),
        genre: m['genre'] as String? ?? '',
        event: m['event'] as String? ?? '',
        history: m['history'] as String? ?? '',
        meaning: m['meaning'] as String? ?? '',
        lyrics: m['lyrics'] as String? ?? '',
        imageBase64: m['imageBase64'] as String?,
        audioUrl: m['audioUrl'] as String? ?? '',
        externalUrl: m['externalUrl'] as String? ?? '',
        placeName: m['placeName'] as String? ?? '',
        latitude: (m['latitude'] as num?)?.toDouble(),
        longitude: (m['longitude'] as num?)?.toDouble(),
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            (m['createdAt'] as num?)?.toInt() ?? 0),
      );
}

class AppUser {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final bool isAdmin;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.isAdmin,
  });
}
