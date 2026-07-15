import 'package:equatable/equatable.dart';
import 'song.dart';
import 'album.dart';

class Artist extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String bio;
  final int monthlyListeners;
  final int songCount;
  final int albumCount;
  final List<Song> topSongs;
  final List<Album> albums;

  const Artist({
    required this.id,
    required this.name,
    this.imageUrl = '',
    this.bio = '',
    this.monthlyListeners = 0,
    this.songCount = 0,
    this.albumCount = 0,
    this.topSongs = const [],
    this.albums = const [],
  });

  Artist copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? bio,
    int? monthlyListeners,
    int? songCount,
    int? albumCount,
    List<Song>? topSongs,
    List<Album>? albums,
  }) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio ?? this.bio,
      monthlyListeners: monthlyListeners ?? this.monthlyListeners,
      songCount: songCount ?? this.songCount,
      albumCount: albumCount ?? this.albumCount,
      topSongs: topSongs ?? this.topSongs,
      albums: albums ?? this.albums,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        bio,
        monthlyListeners,
        songCount,
        albumCount,
        topSongs,
        albums,
      ];
}
