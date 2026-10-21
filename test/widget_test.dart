import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/models/song.dart';

void main() {
  test('Song se serializa y deserializa', () {
    final s = Song(
      id: 'x',
      title: 'Burka azul',
      artist: 'Banda',
      year: 2001,
      latitude: 34.5,
      longitude: 69.2,
      createdAt: DateTime(2024),
    );
    final back = Song.fromMap('x', s.toMap());
    expect(back.title, 'Burka azul');
    expect(back.year, 2001);
    expect(back.hasLocation, isTrue);
  });
}
