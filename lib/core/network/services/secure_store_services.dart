// lib/core/network/services/secure_store_services.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutx_core/flutx_core.dart';
import '../constants/key_constants.dart';

class SecureStoreServices {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Default values for testing when auth is not implemented
  static const String _defaultAccessToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2OGJmZjg3NzIwZmZmYTNiYjA2ZjEyMDYiLCJlbWFpbCI6Im5pbG95QGV4YW1wbGUuY29tIiwiaWF0IjoxNzYwNDk4NDE5LCJleHAiOjE3NjA1ODQ4MTl9.m0Vq4PQW-qtknZ744oMRZEImf9NbqobhbsQ_wYu56EI';
  static const String _defaultUserId = '68bff87720fffa3bb06f1206';

  // Singleton Instance
  static final SecureStoreServices _instance = SecureStoreServices._internal();

  // Private constructor
  SecureStoreServices._internal();

  // Factory constructor to return the singleton instance
  factory SecureStoreServices() => _instance;

  /// [Method to store data securely]
  Future<void> storeData(String key, String value) async {
    DPrint.log("Successfully store the data");
    await _storage.write(key: key, value: value);
  }

  /// [Method to retrieve data securely]
  Future<String?> retrieveData(String key) async {
    final data = await _storage.read(key: key);

    // If no data in storage, use defaults for specific keys
    if (data == null || data.isEmpty) {
      if (key == KeyConstants.accessToken) {
        DPrint.log("Using default access token for testing");
        return _defaultAccessToken;
      } else if (key == KeyConstants.userId) {
        DPrint.log("Using default user ID for testing");
        return _defaultUserId;
      }
    }

    return data;
  }

  /// [Method to delete data securely]
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  /// [Medele all the data securely]
  Future<void> deleteAllData() async {
    await _storage.deleteAll();
  }
}
