import 'package:echowave/data/models/song_model.dart';
import 'package:echowave/domain/entities/album.dart';

class AlbumModel extends Album {
  const AlbumModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.artistId,
    super.coverUrl,
    super.year,
    super.songCount,
    super.totalDuration,
    super.genre,
    super.songs,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    final songList = <SongModel>[];
    if (json['songs'] != null && json['songs'] is List) {
      for (final s in json['songs'] as List) {
        if (s is Map<String, dynamic>) {
          songList.add(SongModel.fromJson(s));
        }
      }
    }

    return AlbumModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      artist: json['artist'] as String? ?? '',
      artistId: json['artist_id'] as String? ?? json['artistId'] as String? ?? '',
      coverUrl: json['cover_url'] as String? ?? json['coverUrl'] as String? ?? '',
      year: json['year'] is int
          ? json['year'] as int
          : int.tryParse(json['year']?.toString() ?? '') ?? 0,
      songCount: json['song_count'] is int
          ? json['song_count'] as int
          : int.tryParse(json['song_count']?.toString() ?? '') ?? 0,
      totalDuration: json['total_duration'] is int
          ? json['total_duration'] as int
          : int.tryParse(json['total_duration']?.toString() ?? '') ?? 0,
      genre: json['genre'] != null
          ? (json['genre'] as List<dynamic>).map((e) => e.toString()).toList()
          : <String>[],
      songs: songList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'artist_id': artistId,
      'cover_url': coverUrl,
      'year': year,
      'song_count': songCount,
      'total_duration': totalDuration,
      'genre': genre,
      'songs': songs.map((s) => (s as SongModel).toJson()).toList(),
    };
  }

  Album toEntity() {
    return Album(
      id: id,
      title: title,
      artist: artist,
      artistId: artistId,
      coverUrl: coverUrl,
      year: year,
      songCount: songCount,
      totalDuration: totalDuration,
      genre: genre,
      songs: songs,
    );
  }

  factory AlbumModel.fromEntity(Album album) {
    return AlbumModel(
      id: album.id,
      title: album.title,
      artist: album.artist,
      artistId: album.artistId,
      coverUrl: album.coverUrl,
      year: album.year,
      songCount: album.songCount,
      totalDuration: album.totalDuration,
      genre: album.genre,
      songs: album.songs.map((s) => SongModel.fromEntity(s)).toList(),
    );
  }
}
