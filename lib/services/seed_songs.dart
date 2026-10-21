import '../models/song.dart';

/// Canciones de ejemplo para el modo demo. La letra completa no se incluye
/// (tiene derechos de autor); el administrador puede agregarla desde el formulario.
List<Song> seedSongs() => [
      Song(
        id: 'seed-zombie',
        title: 'Zombie',
        artist: 'The Cranberries',
        year: 1994,
        genre: 'Rock alternativo',
        event: 'Atentado del IRA en Warrington (1993)',
        history:
            'En marzo de 1993 dos bombas del IRA explotaron en una calle comercial '
            'de Warrington, Inglaterra, y mataron a dos niños: Johnathan Ball (3 años) '
            'y Tim Parry (12 años). Dolores O\'Riordan escribió la canción como protesta '
            'por la violencia del conflicto de Irlanda del Norte ("The Troubles").',
        meaning:
            'El "zombie" representa a quienes siguen matando en nombre de un conflicto '
            'heredado de 1916, sin pensar, como muertos vivientes. La canción rechaza '
            'la violencia de ambos bandos.',
        placeName: 'Warrington, Inglaterra',
        latitude: 53.3900,
        longitude: -2.5970,
        createdAt: DateTime(2024, 1, 3),
      ),
      Song(
        id: 'seed-sbs',
        title: 'Sunday Bloody Sunday',
        artist: 'U2',
        year: 1983,
        genre: 'Rock',
        event: 'Domingo Sangriento, Derry (1972)',
        history:
            'El 30 de enero de 1972 soldados británicos dispararon contra una marcha '
            'por los derechos civiles en Derry, Irlanda del Norte, y mataron a 14 personas.',
        meaning:
            'No es una canción a favor de ningún bando: U2 la presentaba diciendo '
            '"this is not a rebel song". Habla del cansancio ante la violencia y '
            'contrapone el domingo sangriento con el domingo de Pascua.',
        placeName: 'Derry, Irlanda del Norte',
        latitude: 54.9966,
        longitude: -7.3086,
        createdAt: DateTime(2024, 1, 2),
      ),
      Song(
        id: 'seed-strange-fruit',
        title: 'Strange Fruit',
        artist: 'Billie Holiday',
        year: 1939,
        genre: 'Jazz',
        event: 'Linchamientos racistas en EE. UU.',
        history:
            'Abel Meeropol, profesor de Nueva York, escribió el poema tras ver la '
            'fotografía del linchamiento de Thomas Shipp y Abram Smith en Marion, '
            'Indiana (1930). Billie Holiday la grabó en 1939.',
        meaning:
            'Los "frutos extraños" que cuelgan de los árboles del sur son los cuerpos '
            'de personas negras linchadas. La metáfora suave contrasta con el horror real.',
        placeName: 'Marion, Indiana, EE. UU.',
        latitude: 40.5584,
        longitude: -85.6591,
        createdAt: DateTime(2024, 1, 1),
      ),
    ];
