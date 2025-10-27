// lib/core/network/services/auth_storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutx_core/flutx_core.dart';

import '../constants/key_constants.dart';

class AuthStorageService {
  final FlutterSecureStorage _secureStorage;

  AuthStorageService({FlutterSecureStorage? storage})
    : _secureStorage = storage ?? const FlutterSecureStorage();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  // Default values for testing when auth is not implemented
  static const String _defaultAccessToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2OGJmZjg3NzIwZmZmYTNiYjA2ZjEyMDYiLCJlbWFpbCI6Im5pbG95QGV4YW1wbGUuY29tIiwiaWF0IjoxNzYwNDk4NDE5LCJleHAiOjE3NjA1ODQ4MTl9.m0Vq4PQW-qtknZ744oMRZEImf9NbqobhbsQ_wYu56EI';
  static const String _defaultUserId = '68bff87720fffa3bb06f1206';

  // Store all auth data (tokens + user ID)
  Future<void> storeAuthData({
    required String accessToken,
    required String refreshToken,
    required String userId, // Added required userId parameter
  }) async {
    // Store tokens and user ID in parallel for better performance
    await Future.wait([
      _secureStorage.write(key: KeyConstants.accessToken, value: accessToken),
      _secureStorage.write(key: KeyConstants.refreshToken, value: refreshToken),
      _secureStorage.write(key: KeyConstants.userId, value: userId),
    ]);
  }

  // Store just access token
  Future<void> storeAccessToken(String token) async {
    await _secureStorage.write(key: KeyConstants.accessToken, value: token);
  }

  // Store just refresh token
  Future<void> storeRefreshToken(String token) async {
    await _secureStorage.write(key: KeyConstants.refreshToken, value: token);
  }

  // Store just user ID
  Future<void> storeUserId(String userId) async {
    await _secureStorage.write(key: KeyConstants.userId, value: userId);
  }

  // Get access token
  Future<String?> getAccessToken() async {
    final accessToken = await _secureStorage.read(
      key: KeyConstants.accessToken,
    );

    // If no token in storage, use default for testing
    if (accessToken != null) {
      _isAuthenticated = true;
      DPrint.info(
        "Get Access Token from storage: $accessToken $_isAuthenticated",
      );
      return accessToken;
    } else {
      _isAuthenticated = false;
      DPrint.info(
        "Get Access Token using default: $_defaultAccessToken $_isAuthenticated",
      );
      return _defaultAccessToken; // Return default token for testing
    }
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: KeyConstants.refreshToken);
  }

  // Get user ID
  Future<String?> getUserId() async {
    final userId = await _secureStorage.read(key: KeyConstants.userId);

    // If no userId in storage, use default for testing
    if (userId != null && userId.isNotEmpty) {
      DPrint.info("Get User ID from storage: $userId");
      return userId;
    } else {
      DPrint.info("Get User ID using default: $_defaultUserId");
      return _defaultUserId; // Return default userId for testing
    }
  }

  // Get all auth data at once
  Future<Map<String, String?>> getAllAuthData() async {
    return {
      'accessToken': await getAccessToken(),
      'refreshToken': await getRefreshToken(),
      'userId': await getUserId(),
    };
  }

  // Clear all auth data (logout)
  Future<void> clearAuthData() async {
    await Future.wait([
      _secureStorage.delete(key: KeyConstants.accessToken),
      _secureStorage.delete(key: KeyConstants.refreshToken),
      _secureStorage.delete(key: KeyConstants.userId),
    ]);
    _isAuthenticated = false;
  }

  // Check if user ID exists
  Future<bool> hasUserId() async {
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }
}
