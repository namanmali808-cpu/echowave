import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String artistId;
  final String album;
  final String albumId;
  final String albumArtUrl;
  final String url;
  final String lyrics;
  final int duration;
  final int bitrate;
  final int size;
  final String genre;
  final int playCount;
  final bool isDownloaded;
  final bool isFavorite;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.artistId,
    required this.album,
    required this.albumId,
    this.albumArtUrl = '',
    this.url = '',
    this.lyrics = '',
    this.duration = 0,
    this.bitrate = 0,
    this.size = 0,
    this.genre = '',
    this.playCount = 0,
    this.isDownloaded = false,
    this.isFavorite = false,
  });

  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Song copyWith({
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
    return Song(
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

  @override
  List<Object?> get props => [
        id,
        title,
        artist,
        artistId,
        album,
        albumId,
        albumArtUrl,
        url,
        lyrics,
        duration,
        bitrate,
        size,
        genre,
        playCount,
        isDownloaded,
        isFavorite,
      ];
}
