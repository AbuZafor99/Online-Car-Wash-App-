// lib/core/network/services/connectivity_service.dart

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  static ConnectivityService? _instance;
  static ConnectivityService get instance =>
      _instance ??= ConnectivityService._internal();

  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Current connectivity status as ValueNotifier for reactive updates
  final ValueNotifier<bool> _isConnectedNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> get isConnectedNotifier => _isConnectedNotifier;
  bool get isConnected => _isConnectedNotifier.value;

  // Stream controller for connectivity changes
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();
  Stream<bool> get connectivityStream => _connectivityController.stream;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial connectivity
    await _checkConnectivity();

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
      onError: (error) {
        if (kDebugMode) print('Connectivity error: $error');
      },
    );
  }

  /// Check current connectivity status
  Future<bool> checkConnectivity() async {
    try {
      final List<ConnectivityResult> connectivityResults = await _connectivity
          .checkConnectivity();
      return _hasInternetConnection(connectivityResults);
    } catch (e) {
      if (kDebugMode) print('Error checking connectivity: $e');
      return false;
    }
  }

  /// Private method to check connectivity and update status
  Future<void> _checkConnectivity() async {
    final bool wasConnected = _isConnectedNotifier.value;
    final bool isNowConnected = await checkConnectivity();

    if (wasConnected != isNowConnected) {
      _isConnectedNotifier.value = isNowConnected;
      _connectivityController.add(isNowConnected);
      if (kDebugMode) {
        print(
          'Connectivity changed: ${isNowConnected ? 'Connected' : 'Disconnected'}',
        );
      }
    }
  }

  /// Handle connectivity changes
  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final bool wasConnected = _isConnectedNotifier.value;
    final bool isNowConnected = _hasInternetConnection(results);

    if (wasConnected != isNowConnected) {
      _isConnectedNotifier.value = isNowConnected;
      _connectivityController.add(isNowConnected);
      if (kDebugMode) {
        print(
          'Connectivity changed: ${isNowConnected ? 'Connected' : 'Disconnected'}',
        );
      }
    }
  }

  /// Check if any of the connectivity results indicate internet connection
  bool _hasInternetConnection(List<ConnectivityResult> results) {
    return results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn,
    );
  }

  /// Wait for internet connection (useful for retry mechanisms)
  Future<void> waitForConnection({Duration? timeout}) async {
    if (_isConnectedNotifier.value) return;

    final completer = Completer<void>();
    late StreamSubscription<bool> subscription;

    subscription = connectivityStream.listen((isConnected) {
      if (isConnected) {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    if (timeout != null) {
      Timer(timeout, () {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.completeError(
            TimeoutException('Connection timeout', timeout),
          );
        }
      });
    }

    return completer.future;
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityController.close();
    _isConnectedNotifier.dispose();
  }
}
