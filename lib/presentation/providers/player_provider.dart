import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:echowave/domain/entities/song.dart';
import 'package:echowave/data/services/audio_service.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

enum LoopModeState { off, one, all }

class PlayerStateData {
  final Song? currentSong;
  final List<Song> queue;
  final bool isPlaying;
  final bool isShuffled;
  final LoopModeState loopMode;
  final double speed;
  final Duration position;
  final Duration duration;
  final bool isLoading;

  const PlayerStateData({
    this.currentSong,
    this.queue = const [],
    this.isPlaying = false,
    this.isShuffled = false,
    this.loopMode = LoopModeState.off,
    this.speed = 1.0,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isLoading = false,
  });

  PlayerStateData copyWith({
    Song? currentSong,
    List<Song>? queue,
    bool? isPlaying,
    bool? isShuffled,
    LoopModeState? loopMode,
    double? speed,
    Duration? position,
    Duration? duration,
    bool? isLoading,
  }) {
    return PlayerStateData(
      currentSong: currentSong ?? this.currentSong,
      queue: queue ?? this.queue,
      isPlaying: isPlaying ?? this.isPlaying,
      isShuffled: isShuffled ?? this.isShuffled,
      loopMode: loopMode ?? this.loopMode,
      speed: speed ?? this.speed,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PlayerNotifier extends StateNotifier<PlayerStateData> {
  final AudioService _audioService;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlaybackState>? _playerStateSub;

  PlayerNotifier(this._audioService) : super(const PlayerStateData()) {
    _positionSub = _audioService.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });
    _durationSub = _audioService.durationStream.listen((dur) {
      state = state.copyWith(duration: dur);
    });
    _playerStateSub = _audioService.stateStream.listen((ps) {
      state = state.copyWith(
        isPlaying: ps == PlaybackState.playing,
        isLoading: ps == PlaybackState.loading,
      );
    });
  }

  Future<void> playSong(Song song, {List<Song>? queue}) async {
    state = state.copyWith(isLoading: true);
    if (queue != null) {
      final index = queue.indexWhere((s) => s.id == song.id);
      await _audioService.setQueue(queue, initialIndex: index >= 0 ? index : 0);
    } else {
      await _audioService.playSong(song);
    }
    state = state.copyWith(
      currentSong: song,
      queue: queue ?? [song],
      isPlaying: true,
      isLoading: false,
      position: Duration.zero,
    );
  }

  Future<void> togglePlayPause() async {
    if (_audioService.currentState == PlaybackState.playing) {
      await _audioService.pause();
      state = state.copyWith(isPlaying: false);
    } else {
      await _audioService.resume();
      state = state.copyWith(isPlaying: true);
    }
  }

  Future<void> next() async {
    await _audioService.next();
    state = state.copyWith(
      currentSong: _audioService.currentSong,
      position: Duration.zero,
    );
  }

  Future<void> previous() async {
    await _audioService.previous();
    state = state.copyWith(
      currentSong: _audioService.currentSong,
      position: Duration.zero,
    );
  }

  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
    state = state.copyWith(position: position);
  }

  void toggleShuffle() {
    final enabled = _audioService.shuffleMode == ShuffleMode.off;
    _audioService.shuffle(enabled: enabled);
    state = state.copyWith(isShuffled: enabled);
  }

  void toggleLoopMode() {
    final modes = [RepeatMode.off, RepeatMode.all, RepeatMode.one];
    final currentIndex = modes.indexOf(_audioService.repeatMode);
    final nextMode = modes[(currentIndex + 1) % modes.length];
    _audioService.setRepeatMode(nextMode);
    state = state.copyWith(
      loopMode: LoopModeState.values[nextMode.index],
    );
  }

  Future<void> setSpeed(double speed) async {
    await _audioService.setSpeed(speed);
    state = state.copyWith(speed: speed);
  }

  void addToQueue(Song song) {
    _audioService.addToQueue(song);
    state = state.copyWith(queue: _audioService.queue);
  }

  void removeFromQueue(int index) {
    _audioService.removeFromQueue(index);
    state = state.copyWith(
      queue: _audioService.queue,
      currentSong: _audioService.currentSong,
    );
  }

  void clearQueue() {
    _audioService.clearQueue();
    state = state.copyWith(
      queue: [],
      currentSong: null,
      isPlaying: false,
      position: Duration.zero,
    );
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    super.dispose();
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerStateData>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return PlayerNotifier(audioService);
});
