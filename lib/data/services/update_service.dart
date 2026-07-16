import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:echowave/core/constants/app_constants.dart';
import 'package:echowave/core/errors/app_exception.dart';

class UpdateInfo {
  final String latestVersion;
  final String downloadUrl;
  final String changelog;
  final bool isMandatory;
  final int fileSize;

  const UpdateInfo({
    required this.latestVersion,
    required this.downloadUrl,
    this.changelog = '',
    this.isMandatory = false,
    this.fileSize = 0,
  });
}

class UpdateService {
  final Dio _dio;
  final StreamController<double> _downloadProgressController =
      StreamController<double>.broadcast();

  Stream<double> get downloadProgressStream =>
      _downloadProgressController.stream;

  CancelToken? _cancelToken;

  UpdateService(this._dio);

  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await _dio.get(
        'https://api.github.com/repos/${AppConstants.githubOwner}/${AppConstants.githubRepo}/releases/latest',
        options: Options(headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'EchoWave',
        }),
      );

      final data = response.data as Map<String, dynamic>;
      final latestVersion = (data['tag_name'] as String?)?.replaceFirst('v', '') ?? '';

      if (latestVersion.isEmpty) return null;

      if (_compareVersions(latestVersion, currentVersion) > 0) {
        final assets = data['assets'] as List? ?? [];
        final downloadUrl = assets.isNotEmpty
            ? (assets[0] as Map<String, dynamic>)['browser_download_url'] as String? ?? ''
            : '';

        return UpdateInfo(
          latestVersion: latestVersion,
          downloadUrl: downloadUrl,
          changelog: data['body'] as String? ?? '',
          isMandatory: false,
          fileSize: assets.isNotEmpty
              ? (assets[0] as Map<String, dynamic>)['size'] as int? ?? 0
              : 0,
        );
      }

      return null;
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw ServerException(
        message: 'Failed to check for update',
        stackTrace: stackTrace,
      );
    }
  }

  int _compareVersions(String v1, String v2) {
    final parts1 = v1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final parts2 = v2.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final maxLength = parts1.length > parts2.length
        ? parts1.length
        : parts2.length;

    for (int i = 0; i < maxLength; i++) {
      final p1 = i < parts1.length ? parts1[i] : 0;
      final p2 = i < parts2.length ? parts2[i] : 0;
      if (p1 != p2) return p1 - p2;
    }
    return 0;
  }

  Future<String> downloadUpdate(UpdateInfo updateInfo) async {
    try {
      _cancelToken = CancelToken();

      Directory dir;
      try {
        if (Platform.isAndroid) {
          dir = Directory('/storage/emulated/0/Download');
          if (!await dir.exists()) {
            await dir.create(recursive: true);
          }
        } else {
          dir = await getApplicationDocumentsDirectory();
        }
      } catch (_) {
        dir = await getTemporaryDirectory();
      }
      final fileName = '${AppConstants.appName}_${updateInfo.latestVersion}.apk';
      final savePath = '${dir.path}/$fileName';

      await _dio.download(
        updateInfo.downloadUrl,
        savePath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = received / total;
            _downloadProgressController.add(progress);
          }
        },
      );

      _downloadProgressController.add(1.0);
      return savePath;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw DownloadException(
          message: 'Download cancelled by user',
        );
      }
      throw DownloadException(
        message: 'Failed to download update: ${e.message}',
      );
    } catch (e, stackTrace) {
      throw DownloadException(
        message: 'Failed to download update: ${e.toString()}',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> installUpdate(String downloadUrl) async {
    try {
      await launchUrl(
        Uri.parse(downloadUrl),
        mode: LaunchMode.externalApplication,
      );
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw DownloadException(
        message: 'Failed to start update download: ${e.toString()}',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> checkAndUpdate() async {
    final updateInfo = await checkForUpdate();
    if (updateInfo == null) return;

    await installUpdate(updateInfo.downloadUrl);
  }

  void cancelDownload() {
    _cancelToken?.cancel();
    _cancelToken = null;
  }

  Future<void> dispose() async {
    _cancelToken?.cancel();
    await _downloadProgressController.close();
  }
}
