import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:echowave/core/errors/app_exception.dart';
import 'package:echowave/domain/entities/song.dart';

enum RepeatMode { off, one, all }

enum ShuffleMode { off, on }

enum PlaybackState { idle, loading, playing, paused, stopped, completed }

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  final StreamController<Duration> _durationController =
      StreamController<Duration>.broadcast();
  final StreamController<PlaybackState> _stateController =
      StreamController<PlaybackState>.broadcast();
  final StreamController<Song?> _currentSongController =
      StreamController<Song?>.broadcast();
  final StreamController<List<Song>> _queueController =
      StreamController<List<Song>>.broadcast();

  List<Song> _queue = [];
  int _currentIndex = -1;
  RepeatMode _repeatMode = RepeatMode.off;
  ShuffleMode _shuffleMode = ShuffleMode.off;
  List<int> _shuffleOrder = [];
  int _shuffleIndex = 0;
  double _speed = 1.0;
  PlaybackState _state = PlaybackState.idle;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _completionSubscription;

  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<PlaybackState> get stateStream => _stateController.stream;
  Stream<Song?> get currentSongStream => _currentSongController.stream;
  Stream<List<Song>> get queueStream => _queueController.stream;
  PlaybackState get currentState => _state;
  RepeatMode get repeatMode => _repeatMode;
  ShuffleMode get shuffleMode => _shuffleMode;
  List<Song> get queue => List.unmodifiable(_queue);
  Song? get currentSong => _currentIndex >= 0 && _currentIndex < _queue.length
      ? _queue[_currentIndex]
      : null;
  Duration get currentPosition => _player.position;
  Duration get currentDuration => _player.duration ?? Duration.zero;

  AudioService() {
    _setupListeners();
  }

  void _setupListeners() {
    _positionSubscription = _player.positionStream.listen((position) {
      _positionController.add(position);
    });

    _durationSubscription = _player.durationStream.listen((duration) {
      if (duration != null) {
        _durationController.add(duration);
      }
    });

    _playerStateSubscription = _player.playerStateStream.listen((state) {
      switch (state.processingState) {
        case ProcessingState.idle:
          _updateState(PlaybackState.idle);
          break;
        case ProcessingState.loading:
          _updateState(PlaybackState.loading);
          break;
        case ProcessingState.buffering:
          _updateState(PlaybackState.loading);
          break;
        case ProcessingState.ready:
          if (_state == PlaybackState.loading) {
            _updateState(PlaybackState.playing);
          }
          break;
        case ProcessingState.completed:
          _updateState(PlaybackState.completed);
          _onTrackComplete();
          break;
      }
    });

    _completionSubscription = _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _onTrackComplete();
      }
    });
  }

  void _updateState(PlaybackState state) {
    _state = state;
    _stateController.add(state);
  }

  void _onTrackComplete() {
    if (_repeatMode == RepeatMode.one) {
      _player.seek(Duration.zero);
      _player.play();
      return;
    }
    next();
  }

  Future<void> playSong(Song song) async {
    try {
      _updateState(PlaybackState.loading);
      await _player.setAudioSource(AudioSource.uri(Uri.parse(song.url)));
      await _player.setVolume(1.0);
      await _player.setSpeed(_speed);
      await _player.play();
      _currentSongController.add(song);
      _updateState(PlaybackState.playing);
    } catch (e, stackTrace) {
      _updateState(PlaybackState.idle);
      throw StreamException(
        message: 'Failed to play song: ${e.toString()}',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> setQueue(List<Song> songs, {int initialIndex = 0}) async {
    _queue = List.from(songs);
    _currentIndex = initialIndex;
    _queueController.add(_queue);
    if (initialIndex >= 0 && initialIndex < _queue.length) {
      await playSong(_queue[initialIndex]);
    }
  }

  Future<void> addToQueue(Song song) async {
    _queue.add(song);
    _queueController.add(_queue);
  }

  Future<void> removeFromQueue(int index) async {
    if (index >= 0 && index < _queue.length) {
      _queue.removeAt(index);
      if (index < _currentIndex) {
        _currentIndex--;
      } else if (index == _currentIndex) {
        if (_queue.isEmpty) {
          await stop();
        } else if (_currentIndex >= _queue.length) {
          _currentIndex = _queue.length - 1;
          await playSong(_queue[_currentIndex]);
        }
      }
      _queueController.add(_queue);
    }
  }

  Future<void> clearQueue() async {
    _queue.clear();
    _currentIndex = -1;
    _queueController.add(_queue);
    await stop();
  }

  Future<void> play() async {
    try {
      await _player.play();
      _updateState(PlaybackState.playing);
    } catch (e, stackTrace) {
      throw StreamException(
        message: 'Failed to play',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
      _updateState(PlaybackState.paused);
    } catch (e, stackTrace) {
      throw StreamException(
        message: 'Failed to pause',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> resume() async {
    try {
      await _player.play();
      _updateState(PlaybackState.playing);
    } catch (e, stackTrace) {
      throw StreamException(
        message: 'Failed to resume',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e, stackTrace) {
      throw StreamException(
        message: 'Failed to seek',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> next() async {
    if (_queue.isEmpty) return;

    int nextIndex;
    if (_shuffleMode == ShuffleMode.on) {
      _shuffleIndex++;
      if (_shuffleIndex >= _shuffleOrder.length) {
        if (_repeatMode == RepeatMode.all) {
          _shuffleIndex = 0;
          _generateShuffleOrder();
        } else {
          _updateState(PlaybackState.stopped);
          return;
        }
      }
      nextIndex = _shuffleOrder[_shuffleIndex];
    } else {
      nextIndex = _currentIndex + 1;
      if (nextIndex >= _queue.length) {
        if (_repeatMode == RepeatMode.all) {
          nextIndex = 0;
        } else {
          _updateState(PlaybackState.stopped);
          return;
        }
      }
    }

    _currentIndex = nextIndex;
    await playSong(_queue[_currentIndex]);
  }

  Future<void> previous() async {
    if (_queue.isEmpty) return;

    if (_player.position.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }

    int prevIndex;
    if (_shuffleMode == ShuffleMode.on) {
      _shuffleIndex--;
      if (_shuffleIndex < 0) {
        _shuffleIndex = _shuffleOrder.length - 1;
      }
      prevIndex = _shuffleOrder[_shuffleIndex];
    } else {
      prevIndex = _currentIndex - 1;
      if (prevIndex < 0) {
        prevIndex = _queue.length - 1;
      }
    }

    _currentIndex = prevIndex;
    await playSong(_queue[_currentIndex]);
  }

  Future<void> shuffle({required bool enabled}) async {
    _shuffleMode = enabled ? ShuffleMode.on : ShuffleMode.off;
    if (enabled) {
      _generateShuffleOrder();
      _shuffleIndex = _shuffleOrder.indexOf(_currentIndex);
      if (_shuffleIndex == -1) _shuffleIndex = 0;
    }
  }

  Future<void> setRepeatMode(RepeatMode mode) async {
    _repeatMode = mode;
  }

  Future<void> setSpeed(double speed) async {
    _speed = speed;
    await _player.setSpeed(speed);
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      _updateState(PlaybackState.stopped);
      _currentIndex = -1;
      _currentSongController.add(null);
    } catch (e, stackTrace) {
      throw StreamException(
        message: 'Failed to stop',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  void _generateShuffleOrder() {
    _shuffleOrder = List.generate(_queue.length, (i) => i);
    _shuffleOrder.shuffle();
  }

  Future<void> dispose() async {
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _completionSubscription?.cancel();
    await _positionController.close();
    await _durationController.close();
    await _stateController.close();
    await _currentSongController.close();
    await _queueController.close();
    await _player.dispose();
  }
}
