import 'package:echowave/data/models/album_model.dart';
import 'package:echowave/data/models/song_model.dart';
import 'package:echowave/domain/entities/artist.dart';

class ArtistModel extends Artist {
  const ArtistModel({
    required super.id,
    required super.name,
    super.imageUrl,
    super.bio,
    super.monthlyListeners,
    super.songCount,
    super.albumCount,
    super.topSongs,
    super.albums,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    final topSongsList = <SongModel>[];
    if (json['top_songs'] != null && json['top_songs'] is List) {
      for (final s in json['top_songs'] as List) {
        if (s is Map<String, dynamic>) {
          topSongsList.add(SongModel.fromJson(s));
        }
      }
    }

    final albumsList = <AlbumModel>[];
    if (json['albums'] != null && json['albums'] is List) {
      for (final a in json['albums'] as List) {
        if (a is Map<String, dynamic>) {
          albumsList.add(AlbumModel.fromJson(a));
        }
      }
    }

    return ArtistModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      monthlyListeners: json['monthly_listeners'] is int
          ? json['monthly_listeners'] as int
          : int.tryParse(json['monthly_listeners']?.toString() ?? '') ?? 0,
      songCount: json['song_count'] is int
          ? json['song_count'] as int
          : int.tryParse(json['song_count']?.toString() ?? '') ?? 0,
      albumCount: json['album_count'] is int
          ? json['album_count'] as int
          : int.tryParse(json['album_count']?.toString() ?? '') ?? 0,
      topSongs: topSongsList,
      albums: albumsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'bio': bio,
      'monthly_listeners': monthlyListeners,
      'song_count': songCount,
      'album_count': albumCount,
      'top_songs': topSongs.map((s) => (s as SongModel).toJson()).toList(),
      'albums': albums.map((a) => (a as AlbumModel).toJson()).toList(),
    };
  }

  Artist toEntity() {
    return Artist(
      id: id,
      name: name,
      imageUrl: imageUrl,
      bio: bio,
      monthlyListeners: monthlyListeners,
      songCount: songCount,
      albumCount: albumCount,
      topSongs: topSongs,
      albums: albums,
    );
  }

  factory ArtistModel.fromEntity(Artist artist) {
    return ArtistModel(
      id: artist.id,
      name: artist.name,
      imageUrl: artist.imageUrl,
      bio: artist.bio,
      monthlyListeners: artist.monthlyListeners,
      songCount: artist.songCount,
      albumCount: artist.albumCount,
      topSongs: artist.topSongs
          .map((s) => SongModel.fromEntity(s))
          .toList(),
      albums: artist.albums
          .map((a) => AlbumModel.fromEntity(a))
          .toList(),
    );
  }
}
