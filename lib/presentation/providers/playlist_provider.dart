import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:echowave/domain/entities/song.dart';
import 'package:echowave/domain/entities/playlist.dart';

class PlaylistState {
  final List<Playlist> playlists;
  final List<Song> favoriteSongs;
  final bool isLoading;
  final String? error;

  const PlaylistState({
    this.playlists = const [],
    this.favoriteSongs = const [],
    this.isLoading = false,
    this.error,
  });

  PlaylistState copyWith({
    List<Playlist>? playlists,
    List<Song>? favoriteSongs,
    bool? isLoading,
    String? error,
  }) {
    return PlaylistState(
      playlists: playlists ?? this.playlists,
      favoriteSongs: favoriteSongs ?? this.favoriteSongs,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class PlaylistNotifier extends StateNotifier<PlaylistState> {
  PlaylistNotifier() : super(const PlaylistState());

  Future<void> loadPlaylists() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final mockPlaylists = [
        Playlist(
          id: 'pl1',
          name: 'Chill Vibes',
          description: 'Relax and unwind',
          coverUrl: '',
          createdBy: '1',
          songCount: 12,
          totalDuration: 2400,
          isPublic: true,
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          updatedAt: DateTime.now(),
        ),
        Playlist(
          id: 'pl2',
          name: 'Workout Energy',
          description: 'High energy tracks',
          coverUrl: '',
          createdBy: '1',
          songCount: 8,
          totalDuration: 1800,
          isPublic: true,
          createdAt: DateTime.now().subtract(const Duration(days: 14)),
          updatedAt: DateTime.now(),
        ),
        Playlist(
          id: 'pl3',
          name: 'Road Trip',
          description: 'Songs for the journey',
          coverUrl: '',
          createdBy: '1',
          songCount: 20,
          totalDuration: 3600,
          isPublic: false,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        ),
        Playlist(
          id: 'pl4',
          name: 'Late Night Jazz',
          description: 'Smooth jazz for late hours',
          coverUrl: '',
          createdBy: '1',
          songCount: 15,
          totalDuration: 3000,
          isPublic: true,
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          updatedAt: DateTime.now(),
        ),
        Playlist(
          id: 'pl5',
          name: 'Throwback Hits',
          description: 'Classic hits from the past',
          coverUrl: '',
          createdBy: '1',
          songCount: 25,
          totalDuration: 4500,
          isPublic: true,
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
          updatedAt: DateTime.now(),
        ),
      ];
      state = state.copyWith(playlists: mockPlaylists, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load playlists',
      );
    }
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final mockFavorites = [
        Song(id: '1', title: 'Blinding Lights', artist: 'The Weeknd', artistId: 'a1', album: 'After Hours', albumId: 'al1', albumArtUrl: '', duration: 200, url: '', genre: 'Pop', isFavorite: true),
        Song(id: '2', title: 'Shape of You', artist: 'Ed Sheeran', artistId: 'a2', album: 'Divide', albumId: 'al2', albumArtUrl: '', duration: 233, url: '', genre: 'Pop', isFavorite: true),
        Song(id: '3', title: 'Bohemian Rhapsody', artist: 'Queen', artistId: 'a3', album: 'A Night at the Opera', albumId: 'al3', albumArtUrl: '', duration: 354, url: '', genre: 'Rock', isFavorite: true),
      ];
      state = state.copyWith(favoriteSongs: mockFavorites, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load favorites',
      );
    }
  }

  Future<void> toggleFavorite(Song song) async {
    final isCurrentlyFavorite = state.favoriteSongs.any((s) => s.id == song.id);
    if (isCurrentlyFavorite) {
      state = state.copyWith(
        favoriteSongs: state.favoriteSongs.where((s) => s.id != song.id).toList(),
      );
    } else {
      state = state.copyWith(
        favoriteSongs: [...state.favoriteSongs, song.copyWith(isFavorite: true)],
      );
    }
  }

  bool isFavorite(String songId) {
    return state.favoriteSongs.any((s) => s.id == songId);
  }
}

final playlistProvider = StateNotifierProvider<PlaylistNotifier, PlaylistState>((ref) {
  return PlaylistNotifier();
});
