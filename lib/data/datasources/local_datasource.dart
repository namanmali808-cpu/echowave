import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import 'package:echowave/core/constants/app_constants.dart';
import 'package:echowave/core/errors/app_exception.dart';
import 'package:echowave/data/models/song_model.dart';
import 'package:echowave/data/models/user_model.dart';

class LocalDataSource {
  late final Box _box;
  late final FlutterSecureStorage _secureStorage;

  LocalDataSource() {
    _secureStorage = const FlutterSecureStorage();
  }

  Future<void> init() async {
    try {
      _box = await Hive.openBox(AppConstants.hiveBoxName);
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to open local storage',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> saveUser(UserModel user) async {
    try {
      await _box.put('current_user', jsonEncode(user.toJson()));
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to save user',
        stackTrace: stackTrace,
      );
    }
  }

  Future<UserModel?> getUser() async {
    try {
      final data = _box.get('current_user') as String?;
      if (data == null) return null;
      return UserModel.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to get user',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: 'auth_token', value: token);
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to save token',
        stackTrace: stackTrace,
      );
    }
  }

  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: 'auth_token');
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to get token',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> clearAuth() async {
    try {
      await _box.delete('current_user');
      await _secureStorage.delete(key: 'auth_token');
      await _secureStorage.delete(key: 'refresh_token');
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to clear auth data',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> cacheSongs(List<SongModel> songs) async {
    try {
      final songsJson =
          songs.map((s) => s.toJson()).toList();
      await _box.put('cached_songs', jsonEncode(songsJson));
      await _box.put('cached_songs_timestamp', DateTime.now().toIso8601String());
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to cache songs',
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<SongModel>?> getCachedSongs() async {
    try {
      final timestamp = _box.get('cached_songs_timestamp') as String?;
      if (timestamp == null) return null;

      final cachedTime = DateTime.parse(timestamp);
      if (DateTime.now().difference(cachedTime) > AppConstants.cacheDuration) {
        return null;
      }

      final data = _box.get('cached_songs') as String?;
      if (data == null) return null;

      final List<dynamic> decoded = jsonDecode(data) as List<dynamic>;
      return decoded
          .map((e) => SongModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to get cached songs',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> addToFavorites(SongModel song) async {
    try {
      final favorites = await getFavorites();
      favorites.add(song);
      final favoritesJson =
          favorites.map((s) => s.toJson()).toList();
      await _box.put('favorites', jsonEncode(favoritesJson));
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to add to favorites',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> removeFromFavorites(String songId) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((s) => s.id == songId);
      final favoritesJson =
          favorites.map((s) => s.toJson()).toList();
      await _box.put('favorites', jsonEncode(favoritesJson));
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to remove from favorites',
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<SongModel>> getFavorites() async {
    try {
      final data = _box.get('favorites') as String?;
      if (data == null) return [];
      final List<dynamic> decoded = jsonDecode(data) as List<dynamic>;
      return decoded
          .map((e) => SongModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to get favorites',
        stackTrace: stackTrace,
      );
    }
  }

  Future<bool> isFavorite(String songId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((s) => s.id == songId);
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to check favorite status',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> addToHistory(SongModel song) async {
    try {
      final history = await getHistory();
      history.removeWhere((s) => s.id == song.id);
      history.insert(0, song);
      if (history.length > AppConstants.recentlyPlayedLimit) {
        history.removeRange(
            AppConstants.recentlyPlayedLimit, history.length);
      }
      final historyJson =
          history.map((s) => s.toJson()).toList();
      await _box.put('history', jsonEncode(historyJson));
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to add to history',
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<SongModel>> getHistory() async {
    try {
      final data = _box.get('history') as String?;
      if (data == null) return [];
      final List<dynamic> decoded = jsonDecode(data) as List<dynamic>;
      return decoded
          .map((e) => SongModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to get history',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> saveSetting(String key, dynamic value) async {
    try {
      await _box.put('setting_$key', value);
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to save setting',
        stackTrace: stackTrace,
      );
    }
  }

  dynamic getSetting(String key) {
    try {
      return _box.get('setting_$key');
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to get setting',
        stackTrace: stackTrace,
      );
    }
  }

  Future<bool> isDownloaded(String songId) async {
    try {
      final data = _box.get('downloaded_songs') as String?;
      if (data == null) return false;
      final List<dynamic> downloaded =
          jsonDecode(data) as List<dynamic>;
      return downloaded.contains(songId);
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to check download status',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> markDownloaded(String songId) async {
    try {
      final data = _box.get('downloaded_songs') as String?;
      final List<dynamic> downloaded =
          data != null ? jsonDecode(data) as List<dynamic> : [];
      if (!downloaded.contains(songId)) {
        downloaded.add(songId);
        await _box.put('downloaded_songs', jsonEncode(downloaded));
      }
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to mark as downloaded',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> removeDownload(String songId) async {
    try {
      final data = _box.get('downloaded_songs') as String?;
      if (data == null) return;
      final List<dynamic> downloaded =
          jsonDecode(data) as List<dynamic>;
      downloaded.remove(songId);
      await _box.put('downloaded_songs', jsonEncode(downloaded));
    } catch (e, stackTrace) {
      throw CacheException(
        message: 'Failed to remove download record',
        stackTrace: stackTrace,
      );
    }
  }
}
