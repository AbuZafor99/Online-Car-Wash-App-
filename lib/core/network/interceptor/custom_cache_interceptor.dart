// lib/core/network/interceptor/custom_cache_interceptor.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import '../constants/cache_constants.dart';
import '../models/hive_cache_model.dart';

class CustomCacheInterceptor extends Interceptor {
  final Duration maxCacheAge;
  final Duration staleWhileRevalidate;
  final int maxCacheSize; // Maximum cache entries
  final int maxMemorySize; // Maximum memory in bytes (5MB default)
  final Set<String> _excludedPaths;
  final Box<HiveCacheModel> _cacheBox;
  final Map<String, DateTime> _memoryCache = {};

  CustomCacheInterceptor({
    this.maxCacheAge = const Duration(minutes: 15),
    this.staleWhileRevalidate = const Duration(minutes: 5),
    this.maxCacheSize = 1000,
    this.maxMemorySize = 5 * 1024 * 1024, // 5MB
    List<String>? excludedPaths,
  }) : _excludedPaths = Set.from(excludedPaths ?? []),
       _cacheBox = Hive.box<HiveCacheModel>(ApiCacheConstants.enhancedCacheKey);

  Box<HiveCacheModel> get cacheBox => _cacheBox;

  String generateCacheKey(RequestOptions options) {
    return _generateCacheKey(options);
  }

  dynamic getCachedData(String key) {
    final cached = _cacheBox.get(key);
    if (cached == null) return null;
    return _deserializeData(cached.responseBody, cached.dataType);
  }

  int? getCachedStatusCode(String key) {
    return _cacheBox.get(key)?.statusCode;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip non-GET requests and excluded paths
    if (options.method.toUpperCase() != 'GET' ||
        _excludedPaths.contains(options.path) ||
        _isAuthenticationEndpoint(options.path)) {
      return handler.next(options);
    }

    final key = _generateCacheKey(options);
    final cached = _cacheBox.get(key);

    if (cached != null) {
      final now = DateTime.now();
      final age = now.difference(cached.cachedAt);
      final isExpired = age > maxCacheAge;
      final isStale = age > staleWhileRevalidate;

      // Return cached data if not expired
      if (!isExpired) {
        DPrint.info(
          "🎯 Cache HIT for ${options.path} (age: ${age.inMinutes}m)",
        );

        try {
          final cachedData = _deserializeData(
            cached.responseBody,
            cached.dataType,
          );

          // Update access time for LRU
          cached.lastAccessedAt = now;
          await _cacheBox.put(key, cached);

          final response = Response(
            requestOptions: options,
            data: cachedData,
            statusCode: cached.statusCode,
            headers: Headers.fromMap({
              'x-cache': ['HIT'],
              'x-cache-age': [age.inSeconds.toString()],
              'x-cache-expires-in': [(maxCacheAge - age).inSeconds.toString()],
            }),
          );

          // If stale, trigger background refresh
          if (isStale) {
            _backgroundRefresh(options, key);
          }

          return handler.resolve(response);
        } catch (e) {
          DPrint.error("❌ Error parsing cached data: $e");
          await _cacheBox.delete(key);
        }
      } else {
        DPrint.info("⏰ Cache EXPIRED for ${options.path}");
        await _cacheBox.delete(key);
      }
    }

    // Add cache-control headers
    options.headers['Cache-Control'] = 'no-cache, no-store';
    options.headers['Pragma'] = 'no-cache';

    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final options = response.requestOptions;

    // Only cache successful GET responses
    if (options.method.toUpperCase() == 'GET' &&
        _shouldCacheResponse(response) &&
        !_excludedPaths.contains(options.path) &&
        !_isAuthenticationEndpoint(options.path)) {
      await _cacheResponse(options, response);
    }

    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;

    // Try to serve stale cache on network errors
    if (options.method.toUpperCase() == 'GET' &&
        !_excludedPaths.contains(options.path) &&
        _isNetworkError(err)) {
      final key = _generateCacheKey(options);
      final cached = _cacheBox.get(key);

      if (cached != null) {
        DPrint.info(
          "🔄 Serving stale cache due to network error for ${options.path}",
        );

        try {
          final cachedData = _deserializeData(
            cached.responseBody,
            cached.dataType,
          );

          return handler.resolve(
            Response(
              requestOptions: options,
              data: cachedData,
              statusCode: cached.statusCode,
              headers: Headers.fromMap({
                'x-cache': ['STALE (network error)'],
                'x-cache-age': [
                  DateTime.now()
                      .difference(cached.cachedAt)
                      .inSeconds
                      .toString(),
                ],
              }),
              statusMessage: 'OK (stale cache due to network error)',
            ),
          );
        } catch (e) {
          DPrint.error("❌ Error parsing stale cached data: $e");
          await _cacheBox.delete(key);
        }
      }
    }

    handler.next(err);
  }

  // Private Methods
  String _generateCacheKey(RequestOptions options) {
    final uri = Uri(
      path: options.path,
      queryParameters: options.queryParameters.isNotEmpty
          ? options.queryParameters
          : null,
    );

    // Include relevant headers in cache key
    final relevantHeaders = <String, dynamic>{};
    const headersToInclude = ['accept-language', 'user-agent'];

    for (final header in headersToInclude) {
      if (options.headers.containsKey(header)) {
        relevantHeaders[header] = options.headers[header];
      }
    }

    final keyData = {'url': uri.toString(), 'headers': relevantHeaders};

    final keyString = jsonEncode(keyData);
    final bytes = utf8.encode(keyString);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  bool _shouldCacheResponse(Response response) {
    // Check status code
    if (![
      200,
      201,
      202,
      203,
      204,
      300,
      301,
      302,
      304,
      307,
      308,
      404,
    ].contains(response.statusCode)) {
      return false;
    }

    // Check response size (don't cache responses larger than 1MB)
    final responseSize = _calculateResponseSize(response.data);
    if (responseSize > 1024 * 1024) {
      DPrint.warn("⚠️ Response too large to cache: ${responseSize}bytes");
      return false;
    }

    // Check if response has cache-control no-store
    final cacheControl = response.headers.value('cache-control');
    if (cacheControl?.contains('no-store') == true) {
      return false;
    }

    return true;
  }

  Future<void> _cacheResponse(RequestOptions options, Response response) async {
    try {
      final key = _generateCacheKey(options);
      final now = DateTime.now();

      // Clean cache if needed before adding new entry
      await _cleanCacheIfNeeded();

      final (serializedData, dataType) = _serializeData(response.data);

      final cacheModel = HiveCacheModel(
        responseBody: serializedData,
        dataType: dataType,
        statusCode: response.statusCode ?? 200,
        cachedAt: now,
        lastAccessedAt: now,
        size: _calculateResponseSize(response.data),
        etag: response.headers.value('etag'),
        lastModified: response.headers.value('last-modified'),
      );

      await _cacheBox.put(key, cacheModel);
      _memoryCache[key] = now;

      DPrint.info(
        "💾 Cached response for ${options.path} (${cacheModel.size} bytes)",
      );
    } catch (e) {
      DPrint.error("❌ Error caching response: $e");
    }
  }

  (String, String) _serializeData(dynamic data) {
    if (data == null) return ('null', 'null');

    if (data is String) return (data, 'string');
    if (data is num) return (data.toString(), 'number');
    if (data is bool) return (data.toString(), 'boolean');

    // For complex objects, serialize to JSON
    try {
      return (jsonEncode(data), 'json');
    } catch (e) {
      DPrint.error("❌ Error serializing data: $e");
      return (data.toString(), 'string');
    }
  }

  dynamic _deserializeData(String data, String dataType) {
    switch (dataType) {
      case 'null':
        return null;
      case 'string':
        return data;
      case 'number':
        return num.tryParse(data) ?? data;
      case 'boolean':
        return data.toLowerCase() == 'true';
      case 'json':
        return jsonDecode(data);
      default:
        return data;
    }
  }

  int _calculateResponseSize(dynamic data) {
    if (data == null) return 0;

    try {
      final jsonString = data is String ? data : jsonEncode(data);
      return utf8.encode(jsonString).length;
    } catch (e) {
      return data.toString().length * 2; // Rough estimate
    }
  }

  Future<void> _cleanCacheIfNeeded() async {
    final cacheSize = _cacheBox.length;
    final memorySize = _calculateTotalMemorySize();

    if (cacheSize > maxCacheSize || memorySize > maxMemorySize) {
      DPrint.info("🧹 Cleaning cache: $cacheSize entries, ${memorySize}bytes");
      await _performCacheCleanup();
    }
  }

  int _calculateTotalMemorySize() {
    int totalSize = 0;
    for (final value in _cacheBox.values) {
      totalSize += value.size;
    }
    return totalSize;
  }

  Future<void> _performCacheCleanup() async {
    final entries = _cacheBox.toMap().entries.toList();

    // Sort by last accessed time (LRU)
    entries.sort(
      (a, b) => a.value.lastAccessedAt.compareTo(b.value.lastAccessedAt),
    );

    // Remove oldest entries until we're under limits
    int currentSize = _calculateTotalMemorySize();
    int currentCount = entries.length;

    for (final entry in entries) {
      if (currentCount <= maxCacheSize * 0.8 &&
          currentSize <= maxMemorySize * 0.8) {
        break;
      }

      await _cacheBox.delete(entry.key);
      _memoryCache.remove(entry.key);
      currentSize -= entry.value.size;
      currentCount--;

      DPrint.info("🗑️ Removed cache entry: ${entry.key}");
    }

    DPrint.info(
      "✅ Cache cleanup complete: $currentCount entries, ${currentSize}bytes",
    );
  }

  bool _isAuthenticationEndpoint(String path) {
    const authPaths = [
      '/auth/',
      '/login',
      '/register',
      '/refresh-token',
      '/logout',
    ];
    return authPaths.any((authPath) => path.contains(authPath));
  }

  bool _isNetworkError(DioException error) {
    return [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.connectionError,
    ].contains(error.type);
  }

  void _backgroundRefresh(RequestOptions options, String key) {
    // Trigger background refresh without blocking current request
    Future.delayed(Duration.zero, () async {
      try {
        DPrint.info("🔄 Background refresh for ${options.path}");

        final dio = Dio();
        final response = await dio.request(
          options.path,
          queryParameters: options.queryParameters,
          options: Options(method: options.method, headers: options.headers),
        );

        if (_shouldCacheResponse(response)) {
          await _cacheResponse(options, response);
          DPrint.info("✅ Background refresh completed for ${options.path}");
        }
      } catch (e) {
        DPrint.error("❌ Background refresh failed for ${options.path}: $e");
      }
    });
  }

  // Public methods for cache management
  Future<void> clearCache() async {
    await _cacheBox.clear();
    _memoryCache.clear();
    DPrint.info("🧹 Cache cleared");
  }

  Future<void> clearExpiredCache() async {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    for (final entry in _cacheBox.toMap().entries) {
      if (now.difference(entry.value.cachedAt) > maxCacheAge) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      await _cacheBox.delete(key);
      _memoryCache.remove(key);
    }

    DPrint.info("🧹 Removed ${keysToRemove.length} expired cache entries");
  }

  Map<String, dynamic> getCacheStats() {
    final totalSize = _calculateTotalMemorySize();
    final entryCount = _cacheBox.length;

    return {
      'entryCount': entryCount,
      'totalSize': totalSize,
      'maxSize': maxMemorySize,
      'maxEntries': maxCacheSize,
      'utilizationPercent': (totalSize / maxMemorySize * 100).toStringAsFixed(
        1,
      ),
    };
  }
}
