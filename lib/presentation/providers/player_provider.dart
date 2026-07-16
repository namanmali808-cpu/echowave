import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:echowave/domain/entities/song.dart';

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
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _playerStateSub;
  List<Song> _queue = [];
  int _currentIndex = -1;
  bool _isShuffled = false;
  List<int> _shuffleOrder = [];
  int _shuffleIndex = 0;

  PlayerNotifier() : super(const PlayerStateData()) {
    _positionSub = _player.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });
    _durationSub = _player.durationStream.listen((dur) {
      state = state.copyWith(duration: dur ?? Duration.zero);
    });
    _playerStateSub = _player.playerStateStream.listen((ps) {
      state = state.copyWith(
        isPlaying: ps.playing,
        isLoading: ps.processingState == ProcessingState.loading || ps.processingState == ProcessingState.buffering,
      );
      if (ps.processingState == ProcessingState.completed) {
        _onTrackComplete();
      }
    });
  }

  void _onTrackComplete() {
    final newIndex = _player.currentIndex ?? -1;
    if (newIndex >= 0 && newIndex < _queue.length) {
      _currentIndex = newIndex;
      state = state.copyWith(currentSong: _queue[_currentIndex]);
    }
  }

  Future<void> playSong(Song song, {List<Song>? queue}) async {
    state = state.copyWith(isLoading: true);
    Song songToPlay = song;
    if (songToPlay.url.isEmpty) {
      songToPlay = songToPlay.copyWith(
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      );
    }
    try {
      await _player.stop();
      if (queue != null) {
        _queue = List.from(queue);
        _currentIndex = queue.indexWhere((s) => s.id == song.id);
        if (_currentIndex < 0) _currentIndex = 0;
        _queue[_currentIndex] = songToPlay;
        final sources = _queue.map((s) {
          final u = s.url.isNotEmpty ? s.url : 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
          return AudioSource.uri(Uri.parse(u));
        }).toList();
        await _player.setAudioSource(
          ConcatenatingAudioSource(children: sources),
          initialIndex: _currentIndex,
        );
      } else {
        _queue = [songToPlay];
        _currentIndex = 0;
        await _player.setAudioSource(
          AudioSource.uri(Uri.parse(songToPlay.url)),
        );
      }
      await _player.setSpeed(state.speed);
      await _player.play();
      state = state.copyWith(
        currentSong: songToPlay,
        queue: List.from(_queue),
        isPlaying: true,
        isLoading: false,
        position: Duration.zero,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        currentSong: songToPlay,
        queue: List.from(_queue),
        isPlaying: false,
      );
    }
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
      state = state.copyWith(isPlaying: false);
    } else {
      await _player.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  Future<void> next() async {
    await _player.seekToNext();
    final newIndex = _player.currentIndex ?? -1;
    if (newIndex >= 0 && newIndex < _queue.length) {
      _currentIndex = newIndex;
    }
    state = state.copyWith(
      currentSong: _currentIndex >= 0 ? _queue[_currentIndex] : null,
      position: Duration.zero,
    );
  }

  Future<void> previous() async {
    if (_player.position.inSeconds > 3) {
      await _player.seek(Duration.zero);
    } else {
      await _player.seekToPrevious();
      final newIndex = _player.currentIndex ?? -1;
      if (newIndex >= 0 && newIndex < _queue.length) {
        _currentIndex = newIndex;
      }
    }
    state = state.copyWith(
      currentSong: _currentIndex >= 0 ? _queue[_currentIndex] : null,
      position: Duration.zero,
    );
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
    state = state.copyWith(position: position);
  }

  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    if (_isShuffled) {
      _generateShuffleOrder();
      _shuffleIndex = _shuffleOrder.indexOf(_currentIndex);
      if (_shuffleIndex == -1) _shuffleIndex = 0;
    }
    state = state.copyWith(isShuffled: _isShuffled);
  }

  void toggleLoopMode() {
    final modes = [LoopModeState.off, LoopModeState.one, LoopModeState.all];
    final currentIndex = modes.indexOf(state.loopMode);
    final nextMode = modes[(currentIndex + 1) % modes.length];
    switch (nextMode) {
      case LoopModeState.off:
        _player.setLoopMode(LoopMode.off);
      case LoopModeState.one:
        _player.setLoopMode(LoopMode.one);
      case LoopModeState.all:
        _player.setLoopMode(LoopMode.all);
    }
    state = state.copyWith(loopMode: nextMode);
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
    state = state.copyWith(speed: speed);
  }

  void addToQueue(Song song) {
    _queue.add(song);
    state = state.copyWith(queue: List.from(_queue));
  }

  void removeFromQueue(int index) {
    if (index >= 0 && index < _queue.length) {
      _queue.removeAt(index);
      state = state.copyWith(queue: List.from(_queue));
    }
  }

  void clearQueue() {
    _queue.clear();
    _currentIndex = -1;
    _player.stop();
    state = state.copyWith(
      queue: [],
      currentSong: null,
      isPlaying: false,
      position: Duration.zero,
    );
  }

  void _generateShuffleOrder() {
    _shuffleOrder = List.generate(_queue.length, (i) => i);
    _shuffleOrder.shuffle();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    _player.dispose();
    super.dispose();
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerStateData>((ref) {
  return PlayerNotifier();
});
