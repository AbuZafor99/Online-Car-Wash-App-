// lib/core/network/constants/cache_constants.dart

class ApiCacheConstants {
  static const String userCacheKey = 'user_cache_key';
  static const String settingsCacheKey = 'settings_cache_key';

  static const String enhancedCacheKey = 'enhanced_cache_key';

  // Cache configuration
  static const int maxCacheEntries = 1000;
  static const int maxCacheSize = 5 * 1024 * 1024; // 5MB
  static const Duration defaultCacheAge = Duration(minutes: 15);
  static const Duration staleWhileRevalidate = Duration(minutes: 5);
}
