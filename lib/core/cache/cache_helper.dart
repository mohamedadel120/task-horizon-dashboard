import 'package:task_dashboard/core/cache/cache_manager.dart';
import 'package:task_dashboard/core/cache/cache_keys.dart';

/// Helper class for common caching operations
/// Provides convenient methods for caching different types of data
class CacheHelper {
  CacheHelper._(); // Private constructor

  /// Cache profile data
  static Future<void> cacheProfile<T>(
    T profile,
    T Function(Map<String, dynamic>) fromJson, {
    Duration? duration,
  }) async {
    await CacheManager.setCache(CacheKeys.profile, profile, duration: duration);
  }

  /// Get cached profile data
  static Future<T?> getCachedProfile<T>(
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await CacheManager.getCache(CacheKeys.profile, fromJson);
  }

  /// Cache advertisement details
  static Future<void> cacheAdvertisementDetails<T>(
    int advertisementId,
    T details,
    T Function(Map<String, dynamic>) fromJson, {
    Duration? duration,
  }) async {
    await CacheManager.setCache(
      CacheKeys.advertisementDetailsById(advertisementId),
      details,
      duration: duration,
    );
  }

  /// Get cached advertisement details
  static Future<T?> getCachedAdvertisementDetails<T>(
    int advertisementId,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await CacheManager.getCache(
      CacheKeys.advertisementDetailsById(advertisementId),
      fromJson,
    );
  }

  /// Cache list of items (advertisements, categories, etc.)
  static Future<void> cacheList<T>(
    String key,
    List<T> items,
    Map<String, dynamic> Function(T) toJson, {
    Duration? duration,
  }) async {
    final jsonList = items.map((item) => toJson(item)).toList();
    await CacheManager.setCache(key, {'items': jsonList}, duration: duration);
  }

  /// Get cached list of items
  static Future<List<T>?> getCachedList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final cachedData = await CacheManager.getCacheRaw(key);
    if (cachedData == null) return null;

    final items = cachedData['items'] as List<dynamic>?;
    if (items == null) return null;

    return items.map((item) => fromJson(item as Map<String, dynamic>)).toList();
  }

  /// Clear specific cache by key
  static Future<void> clearCache(String key) async {
    await CacheManager.clearCache(key);
  }

  /// Check if cache exists
  static Future<bool> hasCache(String key) async {
    return await CacheManager.hasCache(key);
  }
}
