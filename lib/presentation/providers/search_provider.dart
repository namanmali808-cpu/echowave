import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:echowave/core/constants/app_constants.dart';
import 'package:echowave/core/network/api_client.dart';
import 'package:echowave/data/datasources/remote_datasource.dart';
import 'package:echowave/domain/entities/song.dart';

class SearchState {
  final String query;
  final List<Song> results;
  final bool isSearching;
  final String? error;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.isSearching = false,
    this.error,
  });

  SearchState copyWith({
    String? query,
    List<Song>? results,
    bool? isSearching,
    String? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
      error: error ?? this.error,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final RemoteDataSource _remoteDataSource;
  Timer? _debounce;

  SearchNotifier(this._remoteDataSource) : super(const SearchState());

  void search(String query) {
    state = state.copyWith(query: query, error: null);
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      state = state.copyWith(results: [], isSearching: false);
      return;
    }
    state = state.copyWith(isSearching: true);
    _debounce = Timer(AppConstants.searchDebounce, () async {
      try {
        final results = await _remoteDataSource.searchSongs(query);
        state = state.copyWith(
          results: results.map((m) => m.toEntity()).toList(),
          isSearching: false,
        );
      } catch (e) {
        state = state.copyWith(
          isSearching: false,
          error: 'Search failed. Please try again.',
        );
      }
    });
  }

  void clearSearch() {
    _debounce?.cancel();
    state = const SearchState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final remoteDataSource = RemoteDataSource(ApiClient());
  return SearchNotifier(remoteDataSource);
});
