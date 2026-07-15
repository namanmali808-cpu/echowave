import 'package:echowave/domain/entities/album.dart';
import 'package:echowave/domain/entities/artist.dart';
import 'package:echowave/domain/entities/playlist.dart';
import 'package:echowave/domain/entities/song.dart';

abstract class SongRepository {
  Future<List<Song>> getSongs({int page = 1, int limit = 20});
  Future<List<Song>> searchSongs(String query, {int page = 1, int limit = 20});
  Future<Song> getSongDetail(String id);
  Future<List<Album>> getAlbums({int page = 1, int limit = 20});
  Future<Album> getAlbumDetail(String id);
  Future<List<Artist>> getArtists({int page = 1, int limit = 20});
  Future<Artist> getArtistDetail(String id);
  Future<List<Playlist>> getPlaylists({int page = 1, int limit = 20});
  Future<Playlist> getPlaylistDetail(String id);
  Future<List<Song>> getFavorites();
  Future<void> addToFavorite(Song song);
  Future<void> removeFromFavorite(String songId);
  Future<List<Song>> getHistory();
  Future<void> addToHistory(Song song);
  Future<String> getStreamUrl(String songId, {String quality = 'high'});
  Future<String> getLyrics(String songId);
}
