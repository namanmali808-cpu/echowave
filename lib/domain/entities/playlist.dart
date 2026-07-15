import 'package:equatable/equatable.dart';
import 'song.dart';

class Playlist extends Equatable {
  final String id;
  final String name;
  final String description;
  final String coverUrl;
  final String createdBy;
  final int songCount;
  final int totalDuration;
  final bool isPublic;
  final bool isLikedSongs;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Song> songs;

  const Playlist({
    required this.id,
    required this.name,
    this.description = '',
    this.coverUrl = '',
    required this.createdBy,
    this.songCount = 0,
    this.totalDuration = 0,
    this.isPublic = true,
    this.isLikedSongs = false,
    required this.createdAt,
    required this.updatedAt,
    this.songs = const [],
  });

  Playlist copyWith({
    String? id,
    String? name,
    String? description,
    String? coverUrl,
    String? createdBy,
    int? songCount,
    int? totalDuration,
    bool? isPublic,
    bool? isLikedSongs,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Song>? songs,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      createdBy: createdBy ?? this.createdBy,
      songCount: songCount ?? this.songCount,
      totalDuration: totalDuration ?? this.totalDuration,
      isPublic: isPublic ?? this.isPublic,
      isLikedSongs: isLikedSongs ?? this.isLikedSongs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      songs: songs ?? this.songs,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        coverUrl,
        createdBy,
        songCount,
        totalDuration,
        isPublic,
        isLikedSongs,
        createdAt,
        updatedAt,
        songs,
      ];
}
