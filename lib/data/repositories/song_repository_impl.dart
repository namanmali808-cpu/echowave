import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:echowave/data/datasources/local_datasource.dart';
import 'package:echowave/data/datasources/remote_datasource.dart';
import 'package:echowave/data/models/song_model.dart';
import 'package:echowave/domain/entities/album.dart';
import 'package:echowave/domain/entities/artist.dart';
import 'package:echowave/domain/entities/playlist.dart';
import 'package:echowave/domain/entities/song.dart';
import 'package:echowave/domain/repositories/song_repository.dart';

class SongRepositoryImpl implements SongRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final Connectivity _connectivity;

  SongRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._connectivity,
  );

  Future<bool> get _isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Future<List<Song>> getSongs({int page = 1, int limit = 20}) async {
    _backgroundFetchSongs(page, limit);
    return RemoteDataSource.demoSongs
        .map((m) => m.toEntity())
        .toList();
  }

  Future<void> _backgroundFetchSongs(int page, int limit) async {
    try {
      if (await _isConnected) {
        final songModels = await _remoteDataSource.getSongs(
          page: page,
          limit: limit,
        );
        if (page == 1) {
          await _localDataSource.cacheSongs(songModels);
        }
      }
    } catch (_) {}
  }

  @override
  Future<List<Song>> searchSongs(String query,
      {int page = 1, int limit = 20}) async {
    if (await _isConnected) {
      try {
        final songModels = await _remoteDataSource.searchSongs(
          query,
          page: page,
          limit: limit,
        );
        return songModels.map((m) => m.toEntity()).toList();
      } catch (_) {}
    }
    final cached = await _localDataSource.getCachedSongs();
    if (cached != null && cached.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      final filtered = cached
          .where((s) =>
              s.title.toLowerCase().contains(lowerQuery) ||
              s.artist.toLowerCase().contains(lowerQuery))
          .toList();
      return filtered.map((m) => m.toEntity()).toList();
    }
    final lowerQuery = query.toLowerCase();
    return RemoteDataSource.demoSongs
        .where((s) =>
            s.title.toLowerCase().contains(lowerQuery) ||
            s.artist.toLowerCase().contains(lowerQuery))
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<Song> getSongDetail(String id) async {
    if (await _isConnected) {
      try {
        final songModel = await _remoteDataSource.getSongDetail(id);
        return songModel.toEntity();
      } catch (_) {}
    }
    try {
      return RemoteDataSource.demoSongs
          .firstWhere((s) => s.id == id)
          .toEntity();
    } catch (_) {
      return RemoteDataSource.demoSongs[0].toEntity();
    }
  }

  @override
  Future<List<Album>> getAlbums({int page = 1, int limit = 20}) async {
    if (await _isConnected) {
      try {
        final albumModels = await _remoteDataSource.getAlbums(
          page: page,
          limit: limit,
        );
        return albumModels.map((m) => m.toEntity()).toList();
      } catch (_) {}
    }
    return RemoteDataSource.demoAlbums
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<Album> getAlbumDetail(String id) async {
    if (await _isConnected) {
      try {
        final albumModel = await _remoteDataSource.getAlbumDetail(id);
        return albumModel.toEntity();
      } catch (_) {}
    }
    try {
      return RemoteDataSource.demoAlbums
          .firstWhere((a) => a.id == id)
          .toEntity();
    } catch (_) {
      return RemoteDataSource.demoAlbums[0].toEntity();
    }
  }

  @override
  Future<List<Artist>> getArtists({int page = 1, int limit = 20}) async {
    if (await _isConnected) {
      try {
        final artistModels = await _remoteDataSource.getArtists(
          page: page,
          limit: limit,
        );
        return artistModels.map((m) => m.toEntity()).toList();
      } catch (_) {}
    }
    return RemoteDataSource.demoArtists
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<Artist> getArtistDetail(String id) async {
    if (await _isConnected) {
      try {
        final artistModel = await _remoteDataSource.getArtistDetail(id);
        return artistModel.toEntity();
      } catch (_) {}
    }
    try {
      return RemoteDataSource.demoArtists
          .firstWhere((a) => a.id == id)
          .toEntity();
    } catch (_) {
      return RemoteDataSource.demoArtists[0].toEntity();
    }
  }

  @override
  Future<List<Playlist>> getPlaylists({int page = 1, int limit = 20}) async {
    if (await _isConnected) {
      try {
        final playlistModels = await _remoteDataSource.getPlaylists(
          page: page,
          limit: limit,
        );
        return playlistModels.map((m) => m.toEntity()).toList();
      } catch (_) {}
    }
    return RemoteDataSource.demoPlaylists
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<Playlist> getPlaylistDetail(String id) async {
    if (await _isConnected) {
      try {
        final playlistModel = await _remoteDataSource.getPlaylistDetail(id);
        return playlistModel.toEntity();
      } catch (_) {}
    }
    try {
      return RemoteDataSource.demoPlaylists
          .firstWhere((p) => p.id == id)
          .toEntity();
    } catch (_) {
      return RemoteDataSource.demoPlaylists[0].toEntity();
    }
  }

  @override
  Future<List<Song>> getFavorites() async {
    final songModels = await _localDataSource.getFavorites();
    return songModels.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addToFavorite(Song song) async {
    final model = SongModel.fromEntity(song);
    await _localDataSource.addToFavorites(model);
  }

  @override
  Future<void> removeFromFavorite(String songId) async {
    await _localDataSource.removeFromFavorites(songId);
  }

  @override
  Future<List<Song>> getHistory() async {
    final songModels = await _localDataSource.getHistory();
    return songModels.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addToHistory(Song song) async {
    final model = SongModel.fromEntity(song);
    await _localDataSource.addToHistory(model);
  }

  @override
  Future<String> getStreamUrl(String songId,
      {String quality = 'high'}) async {
    if (await _isConnected) {
      try {
        return await _remoteDataSource.getStreamUrl(songId, quality: quality);
      } catch (_) {}
    }
    try {
      final demo = RemoteDataSource.demoSongs.firstWhere((s) => s.id == songId);
      if (demo.url.isNotEmpty) return demo.url;
    } catch (_) {}
    return '';
  }

  @override
  Future<String> getLyrics(String songId) async {
    if (await _isConnected) {
      try {
        return await _remoteDataSource.getLyrics(songId);
      } catch (_) {}
    }
    return '';
  }
}
