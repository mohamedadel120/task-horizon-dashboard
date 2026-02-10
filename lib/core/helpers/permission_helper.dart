import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:task_dashboard/core/services/notification_helper.dart';

/// Permission helper that follows Google and Apple policies
class PermissionHelper {
  /// Request photo library permission
  static Future<bool> requestPhotoLibraryPermission() async {
    if (Platform.isAndroid) {
      return await _requestAndroidPhotoPermission();
    } else {
      return await _requestIOSPhotoPermission();
    }
  }

  /// Request Android photo permission following user's policy
  static Future<bool> _requestAndroidPhotoPermission() async {
    try {
      // Try photos permission first (Android 13+)
      Permission? permission;

      try {
        final photosStatus = await Permission.photos.status;
        if (!photosStatus.isRestricted) {
          permission = Permission.photos;
        }
      } catch (e) {
        return true;
      }

      if (permission == null) {
        return true; // No permission needed
      }

      var status = await permission.status;

      if (status.isGranted) return true;
      if (status.isLimited) return true;

      if (status.isDenied) {
        try {
          final result = await permission.request();
          if (result.isGranted || result.isLimited) return true;
          if (result.isPermanentlyDenied) return false;
          return false;
        } catch (e) {
          return true;
        }
      }

      if (status.isPermanentlyDenied) return false;
      if (status.isRestricted) return true;

      return false;
    } catch (e) {
      return true;
    }
  }

  /// Request iOS photo permission following Apple's policy
  static Future<bool> _requestIOSPhotoPermission() async {
    final permission = Permission.photos;
    var status = await permission.status;

    if (status.isGranted) return true;
    if (status.isLimited) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted || result.isLimited;
    }

    if (status.isPermanentlyDenied) return false;

    return false;
  }

  /// Request camera permission
  static Future<bool> requestCameraPermission() async {
    final permission = Permission.camera;
    var status = await permission.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) return false;

    return false;
  }

  /// Request permission based on image source
  static Future<bool> requestImagePermission({required bool isGallery}) async {
    if (isGallery) {
      return await requestPhotoLibraryPermission();
    } else {
      return await requestCameraPermission();
    }
  }

  /// Check if we need to request permission before accessing gallery
  static Future<bool> shouldRequestGalleryPermission() async {
    if (!Platform.isAndroid) return true;

    try {
      try {
        final photosStatus = await Permission.photos.status;
        if (!photosStatus.isRestricted) {
          if (photosStatus.isGranted || photosStatus.isLimited) return false;
          return true;
        }
      } catch (e) {}

      try {
        final storageStatus = await Permission.storage.status;
        if (storageStatus.isRestricted) return false;
        return false;
      } catch (e) {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Open app settings page
  static Future<void> openAppSettingsPage() async {
    await openAppSettings();
  }

  /// Open app permissions page directly (Android only)
  static Future<void> openAppPermissionsPage() async {
    await openAppSettings();
  }

  /// Check notification permission status
  static Future<bool> checkNotificationPermission() async {
    if (Platform.isAndroid) {
      try {
        final permission = Permission.notification;
        final status = await permission.status;
        return status.isGranted;
      } catch (e) {
        return true;
      }
    } else {
      // Stub for iOS without Firebase dependency
      return false;
    }
  }

  /// Request notification permission
  static Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      try {
        final permission = Permission.notification;
        final status = await permission.status;

        if (status.isGranted) return true;

        if (status.isDenied) {
          final result = await permission.request();
          return result.isGranted;
        }

        if (status.isPermanentlyDenied) return false;

        return false;
      } catch (e) {
        return true;
      }
    } else {
      // Stub for iOS without Firebase/LocalNotifications dependency
      return false;
    }
  }
}
