import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_dashboard/core/helpers/shared_pref.dart';

/// Generic cache manager for storing and retrieving cached data
/// Can be used throughout the app for any type of data
class CacheManager {
  static const String _cachePrefix = 'app_cache_';
  static const String _cacheTimestampPrefix = 'app_cache_timestamp_';

  /// Default cache duration: 1 hour
  static const Duration defaultCacheDuration = Duration(hours: 1);

  /// Store data in cache with optional expiration
  ///
  /// [key] - Unique key for the cache entry
  /// [data] - Data to cache (will be converted to JSON)
  /// [duration] - How long the cache should be valid (default: 1 hour)
  static Future<void> setCache<T>(
    String key,
    T data, {
    Duration? duration,
  }) async {
    try {
      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_cacheTimestampPrefix$key';

      final jsonString = jsonEncode(data);
      final expirationTime = DateTime.now()
          .add(duration ?? defaultCacheDuration)
          .millisecondsSinceEpoch;

      await SharedPrefHelper.setData(cacheKey, jsonString);
      await SharedPrefHelper.setData(timestampKey, expirationTime.toString());

      log(
        'Cache set: $key (expires: ${DateTime.fromMillisecondsSinceEpoch(expirationTime)})',
      );
    } catch (e) {
      log('Error setting cache for key $key: $e');
    }
  }

  /// Get cached data if it exists and is not expired
  ///
  /// Returns null if cache doesn't exist or is expired
  static Future<T?> getCache<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_cacheTimestampPrefix$key';

      final cachedData = await SharedPrefHelper.getString(cacheKey);
      final timestampString = await SharedPrefHelper.getString(timestampKey);

      if (cachedData.isEmpty || timestampString.isEmpty) {
        log('Cache miss: $key (not found)');
        return null;
      }

      final expirationTime = int.tryParse(timestampString);
      if (expirationTime == null) {
        log('Cache miss: $key (invalid timestamp)');
        await _clearCache(key);
        return null;
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      if (now > expirationTime) {
        log('Cache miss: $key (expired)');
        await _clearCache(key);
        return null;
      }

      final jsonData = jsonDecode(cachedData) as Map<String, dynamic>;
      log('Cache hit: $key');
      return fromJson(jsonData);
    } catch (e) {
      log('Error getting cache for key $key: $e');
      return null;
    }
  }

  /// Get cached data as raw JSON (for simple types)
  static Future<Map<String, dynamic>?> getCacheRaw(String key) async {
    try {
      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_cacheTimestampPrefix$key';

      final cachedData = await SharedPrefHelper.getString(cacheKey);
      final timestampString = await SharedPrefHelper.getString(timestampKey);

      if (cachedData.isEmpty || timestampString.isEmpty) {
        return null;
      }

      final expirationTime = int.tryParse(timestampString);
      if (expirationTime == null) {
        await _clearCache(key);
        return null;
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      if (now > expirationTime) {
        await _clearCache(key);
        return null;
      }

      return jsonDecode(cachedData) as Map<String, dynamic>;
    } catch (e) {
      log('Error getting raw cache for key $key: $e');
      return null;
    }
  }

  /// Check if cache exists and is valid
  static Future<bool> hasCache(String key) async {
    try {
      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_cacheTimestampPrefix$key';

      final cachedData = await SharedPrefHelper.getString(cacheKey);
      final timestampString = await SharedPrefHelper.getString(timestampKey);

      if (cachedData.isEmpty || timestampString.isEmpty) {
        return false;
      }

      final expirationTime = int.tryParse(timestampString);
      if (expirationTime == null) {
        return false;
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      return now <= expirationTime;
    } catch (e) {
      return false;
    }
  }

  /// Clear specific cache entry
  static Future<void> clearCache(String key) async {
    await _clearCache(key);
  }

  /// Clear all cache entries
  static Future<void> clearAllCache() async {
    try {
      // Get all SharedPreferences keys
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();

      // Filter keys that start with cache prefix
      final cacheKeys = allKeys
          .where(
            (key) =>
                key.startsWith(_cachePrefix) ||
                key.startsWith(_cacheTimestampPrefix),
          )
          .toList();

      // Remove all cache keys
      for (final key in cacheKeys) {
        await SharedPrefHelper.removeData(key);
      }

      log('Cache cleared: ${cacheKeys.length} entries');
    } catch (e) {
      log('Error clearing all cache: $e');
    }
  }

  /// Update cache expiration time
  static Future<void> extendCache(String key, Duration duration) async {
    try {
      final timestampKey = '$_cacheTimestampPrefix$key';
      final expirationTime = DateTime.now()
          .add(duration)
          .millisecondsSinceEpoch;

      await SharedPrefHelper.setData(timestampKey, expirationTime.toString());
      log(
        'Cache extended: $key (new expiration: ${DateTime.fromMillisecondsSinceEpoch(expirationTime)})',
      );
    } catch (e) {
      log('Error extending cache for key $key: $e');
    }
  }

  /// Internal method to clear cache
  static Future<void> _clearCache(String key) async {
    try {
      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_cacheTimestampPrefix$key';

      await SharedPrefHelper.removeData(cacheKey);
      await SharedPrefHelper.removeData(timestampKey);

      log('Cache cleared: $key');
    } catch (e) {
      log('Error clearing cache for key $key: $e');
    }
  }
}
