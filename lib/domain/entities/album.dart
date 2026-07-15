import 'package:equatable/equatable.dart';
import 'song.dart';

class Album extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String artistId;
  final String coverUrl;
  final int year;
  final int songCount;
  final int totalDuration;
  final List<String> genre;
  final List<Song> songs;

  const Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.artistId,
    this.coverUrl = '',
    this.year = 0,
    this.songCount = 0,
    this.totalDuration = 0,
    this.genre = const [],
    this.songs = const [],
  });

  Album copyWith({
    String? id,
    String? title,
    String? artist,
    String? artistId,
    String? coverUrl,
    int? year,
    int? songCount,
    int? totalDuration,
    List<String>? genre,
    List<Song>? songs,
  }) {
    return Album(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      artistId: artistId ?? this.artistId,
      coverUrl: coverUrl ?? this.coverUrl,
      year: year ?? this.year,
      songCount: songCount ?? this.songCount,
      totalDuration: totalDuration ?? this.totalDuration,
      genre: genre ?? this.genre,
      songs: songs ?? this.songs,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        artist,
        artistId,
        coverUrl,
        year,
        songCount,
        totalDuration,
        genre,
        songs,
      ];
}
