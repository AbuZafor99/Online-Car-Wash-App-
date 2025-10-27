import 'package:flutx_core/flutx_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../network/constants/cache_constants.dart';
import '../network/models/hive_cache_model.dart';

class HiveInitialization {
  static Future<void> initHive() async {
    try {
      DPrint.info("📦 Initializing Hive...");

      // Initialize Hive Flutter (this handles path automatically)
      await Hive.initFlutter();

      // Register adapters with proper type checking
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(HiveCacheModelAdapter());
        DPrint.info("✅ Registered HiveCacheModelAdapter (typeId: 0)");
      }

      // if (!Hive.isAdapterRegistered(1)) {
      //   Hive.registerAdapter(EnhancedCacheModelAdapter());
      //   DPrint.info("✅ Registered EnhancedCacheModelAdapter (typeId: 1)");
      // }

      // Open all required boxes
      await _openBoxes();

      DPrint.info("✅ Hive initialization completed successfully");
    } catch (e) {
      DPrint.error("❌ Hive initialization failed: $e");
      rethrow;
    }
  }

  static Future<void> _openBoxes() async {
    try {
      // Open original cache box
      if (!Hive.isBoxOpen(ApiCacheConstants.userCacheKey)) {
        await Hive.openBox<HiveCacheModel>(ApiCacheConstants.userCacheKey);
        DPrint.info("✅ Opened box: ${ApiCacheConstants.userCacheKey}");
      }

      // Open enhanced cache box
      if (!Hive.isBoxOpen(ApiCacheConstants.enhancedCacheKey)) {
        await Hive.openBox<HiveCacheModel>(ApiCacheConstants.enhancedCacheKey);
        DPrint.info("✅ Opened box: ${ApiCacheConstants.enhancedCacheKey}");
      }

      // Open settings cache box if needed
      if (!Hive.isBoxOpen(ApiCacheConstants.settingsCacheKey)) {
        await Hive.openBox(ApiCacheConstants.settingsCacheKey);
        DPrint.info("✅ Opened box: ${ApiCacheConstants.settingsCacheKey}");
      }
    } catch (e) {
      DPrint.error("❌ Failed to open Hive boxes: $e");
      rethrow;
    }
  }

  static Future<void> cleanup() async {
    try {
      DPrint.info("🧹 Starting app cleanup...");

      // Close all Hive boxes
      await Hive.close();

      DPrint.info("✅ App cleanup completed");
    } catch (e) {
      DPrint.error("❌ App cleanup failed: $e");
    }
  }
}
