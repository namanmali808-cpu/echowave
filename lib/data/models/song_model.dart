import 'package:echowave/domain/entities/song.dart';

class SongModel extends Song {
  const SongModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.artistId,
    required super.album,
    required super.albumId,
    super.albumArtUrl,
    super.url,
    super.lyrics,
    super.duration,
    super.bitrate,
    super.size,
    super.genre,
    super.playCount,
    super.isDownloaded,
    super.isFavorite,
  });

  factory SongModel.fromDeezerJson(Map<String, dynamic> json) {
    final artist = json['artist'] is Map
        ? json['artist'] as Map<String, dynamic>
        : <String, dynamic>{};
    final album = json['album'] is Map
        ? json['album'] as Map<String, dynamic>
        : <String, dynamic>{};
    return SongModel(
      id: json['id'].toString(),
      title: json['title'] as String? ?? '',
      artist: artist['name'] as String? ?? '',
      artistId: artist['id']?.toString() ?? '',
      album: album['title'] as String? ?? '',
      albumId: album['id']?.toString() ?? '',
      albumArtUrl: album['cover_xl'] as String? ??
          album['cover_big'] as String? ??
          album['cover_medium'] as String? ??
          album['cover'] as String? ??
          '',
      duration: json['duration'] as int? ?? 0,
      url: json['preview'] as String? ?? '',
      genre: '',
    );
  }

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      artist: json['artist'] as String? ?? '',
      artistId: json['artist_id'] as String? ?? json['artistId'] as String? ?? '',
      album: json['album'] as String? ?? '',
      albumId: json['album_id'] as String? ?? json['albumId'] as String? ?? '',
      albumArtUrl:
          json['album_art_url'] as String? ?? json['albumArtUrl'] as String? ?? '',
      url: json['url'] as String? ?? '',
      lyrics: json['lyrics'] as String? ?? '',
      duration: json['duration'] is int
          ? json['duration'] as int
          : int.tryParse(json['duration']?.toString() ?? '') ?? 0,
      bitrate: json['bitrate'] is int
          ? json['bitrate'] as int
          : int.tryParse(json['bitrate']?.toString() ?? '') ?? 0,
      size: json['size'] is int
          ? json['size'] as int
          : int.tryParse(json['size']?.toString() ?? '') ?? 0,
      genre: json['genre'] as String? ?? '',
      playCount: json['play_count'] is int
          ? json['play_count'] as int
          : int.tryParse(json['play_count']?.toString() ?? '') ?? 0,
      isDownloaded: json['is_downloaded'] as bool? ?? json['isDownloaded'] as bool? ?? false,
      isFavorite: json['is_favorite'] as bool? ?? json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'artist_id': artistId,
      'album': album,
      'album_id': albumId,
      'album_art_url': albumArtUrl,
      'url': url,
      'lyrics': lyrics,
      'duration': duration,
      'bitrate': bitrate,
      'size': size,
      'genre': genre,
      'play_count': playCount,
      'is_downloaded': isDownloaded,
      'is_favorite': isFavorite,
    };
  }

  Song toEntity() {
    return Song(
      id: id,
      title: title,
      artist: artist,
      artistId: artistId,
      album: album,
      albumId: albumId,
      albumArtUrl: albumArtUrl,
      url: url,
      lyrics: lyrics,
      duration: duration,
      bitrate: bitrate,
      size: size,
      genre: genre,
      playCount: playCount,
      isDownloaded: isDownloaded,
      isFavorite: isFavorite,
    );
  }

  factory SongModel.fromEntity(Song song) {
    return SongModel(
      id: song.id,
      title: song.title,
      artist: song.artist,
      artistId: song.artistId,
      album: song.album,
      albumId: song.albumId,
      albumArtUrl: song.albumArtUrl,
      url: song.url,
      lyrics: song.lyrics,
      duration: song.duration,
      bitrate: song.bitrate,
      size: song.size,
      genre: song.genre,
      playCount: song.playCount,
      isDownloaded: song.isDownloaded,
      isFavorite: song.isFavorite,
    );
  }

  @override
  SongModel copyWith({
    String? id,
    String? title,
    String? artist,
    String? artistId,
    String? album,
    String? albumId,
    String? albumArtUrl,
    String? url,
    String? lyrics,
    int? duration,
    int? bitrate,
    int? size,
    String? genre,
    int? playCount,
    bool? isDownloaded,
    bool? isFavorite,
  }) {
    return SongModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      artistId: artistId ?? this.artistId,
      album: album ?? this.album,
      albumId: albumId ?? this.albumId,
      albumArtUrl: albumArtUrl ?? this.albumArtUrl,
      url: url ?? this.url,
      lyrics: lyrics ?? this.lyrics,
      duration: duration ?? this.duration,
      bitrate: bitrate ?? this.bitrate,
      size: size ?? this.size,
      genre: genre ?? this.genre,
      playCount: playCount ?? this.playCount,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
