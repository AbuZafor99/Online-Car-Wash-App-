// lib/core/network/services/progress_manager.dart

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

enum ProgressType { upload, download }

class ProgressInfo {
  final String operationId;
  final ProgressType type;
  final double progress;
  final int current;
  final int total;
  final bool isCompleted;
  final DateTime timestamp;

  ProgressInfo({
    required this.operationId,
    required this.type,
    required this.progress,
    required this.current,
    required this.total,
    required this.isCompleted,
    required this.timestamp,
  });

  ProgressInfo copyWith({
    String? operationId,
    ProgressType? type,
    double? progress,
    int? current,
    int? total,
    bool? isCompleted,
    DateTime? timestamp,
  }) {
    return ProgressInfo(
      operationId: operationId ?? this.operationId,
      type: type ?? this.type,
      progress: progress ?? this.progress,
      current: current ?? this.current,
      total: total ?? this.total,
      isCompleted: isCompleted ?? this.isCompleted,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  String get progressPercentage => '${(progress * 100).toStringAsFixed(1)}%';

  String get progressText => '$current / $total bytes';

  String get formattedSize {
    final mb = total / (1024 * 1024);
    if (mb >= 1) {
      return '${mb.toStringAsFixed(1)} MB';
    }
    final kb = total / 1024;
    return '${kb.toStringAsFixed(1)} KB';
  }
}

class ProgressManager {
  static final ProgressManager _instance = ProgressManager._internal();
  factory ProgressManager() => _instance;
  ProgressManager._internal();

  // Store progress for multiple operations
  final Map<String, ValueNotifier<ProgressInfo?>> _progressNotifiers = {};
  final ValueNotifier<Map<String, ProgressInfo>> _allProgress = ValueNotifier(
    {},
  );

  // Global progress states
  final ValueNotifier<bool> _hasActiveUploads = ValueNotifier(false);
  final ValueNotifier<bool> _hasActiveDownloads = ValueNotifier(false);
  final ValueNotifier<int> _activeOperationsCount = ValueNotifier(0);

  // Getters
  ValueListenable<Map<String, ProgressInfo>> get allProgress => _allProgress;
  ValueListenable<bool> get hasActiveUploads => _hasActiveUploads;
  ValueListenable<bool> get hasActiveDownloads => _hasActiveDownloads;
  ValueListenable<int> get activeOperationsCount => _activeOperationsCount;

  /// Get or create a progress notifier for a specific operation
  ValueListenable<ProgressInfo?> getProgressNotifier(String operationId) {
    if (!_progressNotifiers.containsKey(operationId)) {
      _progressNotifiers[operationId] = ValueNotifier<ProgressInfo?>(null);
    }
    return _progressNotifiers[operationId]!;
  }

  /// Start tracking progress for an operation
  void startOperation(String operationId, ProgressType type) {
    final progressInfo = ProgressInfo(
      operationId: operationId,
      type: type,
      progress: 0.0,
      current: 0,
      total: 0,
      isCompleted: false,
      timestamp: DateTime.now(),
    );

    _updateProgress(operationId, progressInfo);
    _updateGlobalState();
  }

  /// Update progress for an operation
  void updateProgress(String operationId, int current, int total) {
    final existingProgress = _allProgress.value[operationId];
    if (existingProgress == null) return;

    final progress = total > 0 ? current / total : 0.0;
    final isCompleted = progress >= 1.0;

    final updatedProgress = existingProgress.copyWith(
      progress: progress,
      current: current,
      total: total,
      isCompleted: isCompleted,
      timestamp: DateTime.now(),
    );

    _updateProgress(operationId, updatedProgress);

    if (isCompleted) {
      // Auto-remove completed operations after a delay
      Future.delayed(Duration(seconds: 2), () {
        removeOperation(operationId);
      });
    }

    _updateGlobalState();
  }

  /// Complete an operation manually
  void completeOperation(String operationId) {
    final existingProgress = _allProgress.value[operationId];
    if (existingProgress == null) return;

    final completedProgress = existingProgress.copyWith(
      progress: 1.0,
      isCompleted: true,
      timestamp: DateTime.now(),
    );

    _updateProgress(operationId, completedProgress);
    _updateGlobalState();

    // Auto-remove after delay
    Future.delayed(Duration(seconds: 2), () {
      removeOperation(operationId);
    });
  }

  /// Remove an operation from tracking
  void removeOperation(String operationId) {
    _progressNotifiers[operationId]?.dispose();
    _progressNotifiers.remove(operationId);

    final updatedProgress = Map<String, ProgressInfo>.from(_allProgress.value);
    updatedProgress.remove(operationId);
    _allProgress.value = updatedProgress;

    _updateGlobalState();
  }

  /// Clear all operations
  void clearAll() {
    for (var notifier in _progressNotifiers.values) {
      notifier.dispose();
    }
    _progressNotifiers.clear();
    _allProgress.value = {};
    _updateGlobalState();
  }

  /// Get progress callback for uploads
  ProgressCallback getUploadCallback(String operationId) {
    return (int sent, int total) {
      updateProgress(operationId, sent, total);
    };
  }

  /// Get progress callback for downloads
  ProgressCallback getDownloadCallback(String operationId) {
    return (int received, int total) {
      updateProgress(operationId, received, total);
    };
  }

  /// Create a unique operation ID
  static String generateOperationId([String? prefix]) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString();
    return '${prefix ?? 'op'}_${timestamp}_$random';
  }

  void _updateProgress(String operationId, ProgressInfo progressInfo) {
    // Update individual notifier
    if (_progressNotifiers.containsKey(operationId)) {
      _progressNotifiers[operationId]!.value = progressInfo;
    }

    // Update global progress map
    final updatedProgress = Map<String, ProgressInfo>.from(_allProgress.value);
    updatedProgress[operationId] = progressInfo;
    _allProgress.value = updatedProgress;
  }

  void _updateGlobalState() {
    final allOps = _allProgress.value.values;
    final activeOps = allOps.where((op) => !op.isCompleted);

    _activeOperationsCount.value = activeOps.length;
    _hasActiveUploads.value = activeOps.any(
      (op) => op.type == ProgressType.upload,
    );
    _hasActiveDownloads.value = activeOps.any(
      (op) => op.type == ProgressType.download,
    );
  }

  void dispose() {
    for (var notifier in _progressNotifiers.values) {
      notifier.dispose();
    }
    _progressNotifiers.clear();
    _allProgress.dispose();
    _hasActiveUploads.dispose();
    _hasActiveDownloads.dispose();
    _activeOperationsCount.dispose();
  }
}
