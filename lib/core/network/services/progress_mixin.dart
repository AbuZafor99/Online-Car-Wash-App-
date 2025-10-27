// lib/core/network/services/progress_mixin.dart

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../services/progress_manager.dart';

mixin ProgressMixin {
  final ProgressManager _progressManager = ProgressManager();

  /// Get progress manager instance
  ProgressManager get progressManager => _progressManager;

  /// Start a new upload operation
  String startUpload([String? operationName]) {
    final operationId = ProgressManager.generateOperationId(
      operationName ?? 'upload',
    );
    _progressManager.startOperation(operationId, ProgressType.upload);
    return operationId;
  }

  /// Start a new download operation
  String startDownload([String? operationName]) {
    final operationId = ProgressManager.generateOperationId(
      operationName ?? 'download',
    );
    _progressManager.startOperation(operationId, ProgressType.download);
    return operationId;
  }

  /// Get upload progress callback
  ProgressCallback getUploadCallback(String operationId) {
    return _progressManager.getUploadCallback(operationId);
  }

  /// Get download progress callback
  ProgressCallback getDownloadCallback(String operationId) {
    return _progressManager.getDownloadCallback(operationId);
  }

  /// Get progress notifier for specific operation
  ValueListenable<ProgressInfo?> getProgressNotifier(String operationId) {
    return _progressManager.getProgressNotifier(operationId);
  }

  /// Complete an operation
  void completeOperation(String operationId) {
    _progressManager.completeOperation(operationId);
  }

  /// Remove an operation
  void removeOperation(String operationId) {
    _progressManager.removeOperation(operationId);
  }

  /// Check if there are active uploads
  ValueListenable<bool> get hasActiveUploads =>
      _progressManager.hasActiveUploads;

  /// Check if there are active downloads
  ValueListenable<bool> get hasActiveDownloads =>
      _progressManager.hasActiveDownloads;

  /// Get count of active operations
  ValueListenable<int> get activeOperationsCount =>
      _progressManager.activeOperationsCount;

  /// Get all progress information
  ValueListenable<Map<String, ProgressInfo>> get allProgress =>
      _progressManager.allProgress;
}
