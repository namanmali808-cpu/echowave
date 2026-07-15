import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:io';

import 'package:echowave/core/errors/app_exception.dart';

enum DownloadStatus { idle, downloading, paused, completed, failed }

class DownloadTask {
  final String songId;
  final String url;
  final String savePath;
  final DownloadStatus status;
  final double progress;
  final int receivedBytes;
  final int totalBytes;
  final String? error;

  const DownloadTask({
    required this.songId,
    required this.url,
    required this.savePath,
    this.status = DownloadStatus.idle,
    this.progress = 0.0,
    this.receivedBytes = 0,
    this.totalBytes = 0,
    this.error,
  });

  DownloadTask copyWith({
    String? songId,
    String? url,
    String? savePath,
    DownloadStatus? status,
    double? progress,
    int? receivedBytes,
    int? totalBytes,
    String? error,
  }) {
    return DownloadTask(
      songId: songId ?? this.songId,
      url: url ?? this.url,
      savePath: savePath ?? this.savePath,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      receivedBytes: receivedBytes ?? this.receivedBytes,
      totalBytes: totalBytes ?? this.totalBytes,
      error: error ?? this.error,
    );
  }
}

class DownloadService {
  final Dio _dio;
  final StreamController<DownloadTask> _taskController =
      StreamController<DownloadTask>.broadcast();

  final Map<String, CancelToken> _cancelTokens = {};
  final Map<String, DownloadTask> _tasks = {};

  Stream<DownloadTask> get taskStream => _taskController.stream;

  DownloadService(this._dio);


  Future<DownloadTask> startDownload(
      String songId, String url, String savePath) async {
    try {
      final cancelToken = CancelToken();
      _cancelTokens[songId] = cancelToken;

      final task = DownloadTask(
        songId: songId,
        url: url,
        savePath: savePath,
        status: DownloadStatus.downloading,
      );
      _tasks[songId] = task;
      _taskController.add(task);

      await _dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          final progress = total > 0 ? received / total : 0.0;
          final updated = _tasks[songId]?.copyWith(
                progress: progress,
                receivedBytes: received,
                totalBytes: total,
                status: DownloadStatus.downloading,
              ) ??
          _tasks[songId]!.copyWith(
                progress: progress,
                receivedBytes: received,
                totalBytes: total,
                status: DownloadStatus.downloading,
              );
          _tasks[songId] = updated;
          _taskController.add(updated);
        },
      );

      final completed = _tasks[songId]?.copyWith(
            status: DownloadStatus.completed,
            progress: 1.0,
          ) ??
          _tasks[songId]!.copyWith(status: DownloadStatus.completed, progress: 1.0);
      _tasks[songId] = completed;
      _taskController.add(completed);
      _cancelTokens.remove(songId);
      return completed;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        final paused = _tasks[songId]?.copyWith(
              status: DownloadStatus.paused,
              error: 'Download paused',
            ) ??
            _tasks[songId]!.copyWith(
              status: DownloadStatus.paused,
              error: 'Download paused',
            );
        _tasks[songId] = paused;
        _taskController.add(paused);
        return paused;
      }
      final failed = _tasks[songId]?.copyWith(
            status: DownloadStatus.failed,
            error: e.message ?? 'Download failed',
          ) ??
          _tasks[songId]!.copyWith(
            status: DownloadStatus.failed,
            error: e.message ?? 'Download failed',
          );
      _tasks[songId] = failed;
      _taskController.add(failed);
      _cancelTokens.remove(songId);
      throw DownloadException(
        message: 'Download failed: ${e.message}',
      );
    } catch (e, stackTrace) {
      final failed = _tasks[songId]?.copyWith(
            status: DownloadStatus.failed,
            error: e.toString(),
          ) ??
          _tasks[songId]!.copyWith(
            status: DownloadStatus.failed,
            error: e.toString(),
          );
      _tasks[songId] = failed;
      _taskController.add(failed);
      _cancelTokens.remove(songId);
      throw DownloadException(
        message: 'Download failed: ${e.toString()}',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> pauseDownload(String songId) async {
    final cancelToken = _cancelTokens[songId];
    if (cancelToken != null) {
      cancelToken.cancel();
      _cancelTokens.remove(songId);
    }
  }

  Future<DownloadTask> resumeDownload(String songId) async {
    final task = _tasks[songId];
    if (task == null) {
      throw DownloadException(message: 'No paused download found for song');
    }
    if (task.status != DownloadStatus.paused) {
      throw DownloadException(
          message: 'Download is not in paused state');
    }
    return await startDownload(songId, task.url, task.savePath);
  }

  Future<void> cancelDownload(String songId) async {
    final cancelToken = _cancelTokens[songId];
    if (cancelToken != null) {
      cancelToken.cancel();
      _cancelTokens.remove(songId);
    }
    _tasks.remove(songId);

    final task = _tasks[songId];
    if (task != null) {
      final file = File(task.savePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    _tasks.remove(songId);
  }

  DownloadStatus getStatus(String songId) {
    return _tasks[songId]?.status ?? DownloadStatus.idle;
  }

  double getProgress(String songId) {
    return _tasks[songId]?.progress ?? 0.0;
  }

  Future<void> dispose() async {
    for (final token in _cancelTokens.values) {
      token.cancel();
    }
    _cancelTokens.clear();
    _tasks.clear();
    await _taskController.close();
  }
}
