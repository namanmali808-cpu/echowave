import 'package:echowave/data/models/song_model.dart';
import 'package:echowave/domain/entities/playlist.dart';

class PlaylistModel extends Playlist {
  const PlaylistModel({
    required super.id,
    required super.name,
    super.description,
    super.coverUrl,
    required super.createdBy,
    super.songCount,
    super.totalDuration,
    super.isPublic,
    super.isLikedSongs,
    required super.createdAt,
    required super.updatedAt,
    super.songs,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    final songList = <SongModel>[];
    if (json['songs'] != null && json['songs'] is List) {
      for (final s in json['songs'] as List) {
        if (s is Map<String, dynamic>) {
          songList.add(SongModel.fromJson(s));
        }
      }
    }

    return PlaylistModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      coverUrl: json['cover_url'] as String? ?? json['coverUrl'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? json['createdBy'] as String? ?? '',
      songCount: json['song_count'] is int
          ? json['song_count'] as int
          : int.tryParse(json['song_count']?.toString() ?? '') ?? 0,
      totalDuration: json['total_duration'] is int
          ? json['total_duration'] as int
          : int.tryParse(json['total_duration']?.toString() ?? '') ?? 0,
      isPublic: json['is_public'] as bool? ?? json['isPublic'] as bool? ?? true,
      isLikedSongs: json['is_liked_songs'] as bool? ?? json['isLikedSongs'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      songs: songList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cover_url': coverUrl,
      'created_by': createdBy,
      'song_count': songCount,
      'total_duration': totalDuration,
      'is_public': isPublic,
      'is_liked_songs': isLikedSongs,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'songs': songs.map((s) => (s as SongModel).toJson()).toList(),
    };
  }

  Playlist toEntity() {
    return Playlist(
      id: id,
      name: name,
      description: description,
      coverUrl: coverUrl,
      createdBy: createdBy,
      songCount: songCount,
      totalDuration: totalDuration,
      isPublic: isPublic,
      isLikedSongs: isLikedSongs,
      createdAt: createdAt,
      updatedAt: updatedAt,
      songs: songs,
    );
  }

  factory PlaylistModel.fromEntity(Playlist playlist) {
    return PlaylistModel(
      id: playlist.id,
      name: playlist.name,
      description: playlist.description,
      coverUrl: playlist.coverUrl,
      createdBy: playlist.createdBy,
      songCount: playlist.songCount,
      totalDuration: playlist.totalDuration,
      isPublic: playlist.isPublic,
      isLikedSongs: playlist.isLikedSongs,
      createdAt: playlist.createdAt,
      updatedAt: playlist.updatedAt,
      songs: playlist.songs.map((s) => SongModel.fromEntity(s)).toList(),
    );
  }
}
