// import 'package:go_router/go_router.dart';
// import 'package:task_dashboard/core/models/notification_enums.dart';
// import 'package:task_dashboard/core/routing/go_router.dart';
// import 'package:task_dashboard/core/routing/routes.dart';
// import 'package:task_dashboard/features/notifications/data/models/notification_data_model.dart';

/// Handles navigation based on notification data
class NotificationNavigationHandler {
  /*
  /// Navigate to the appropriate screen based on notification data
  /// Uses BuildContext if provided, otherwise uses GoRouter directly
  static void handleNotificationNavigation(
    NotificationData data, {
    BuildContext? context,
  }) {
    try {
      final type = NotificationType.fromString(data.type);
      final screen = NotificationScreen.fromString(data.screen);

      if (type == null || screen == null) {
        if (kDebugMode) {
          print(
            'Invalid notification type or screen: ${data.type}, ${data.screen}',
          );
        }
        return;
      }

      switch (type) {
        case NotificationType.contract:
          _handleContractNavigation(screen, data, context: context);
          break;
        case NotificationType.advertisement:
          _handleAdvertisementNavigation(screen, data, context: context);
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error handling notification navigation: $e');
      }
    }
  }

  /// Determine if contract is incoming (owner) or outgoing (renter) based on notification key
  static bool _isIncomingContract(String key) {
    // Keys that indicate the user is the owner (incoming contracts)
    final incomingKeys = [
      'incoming_contract_created',
      'contract_payment_received',
      'contract_awaiting_return_owner',
    ];

    // Keys that indicate the user is the renter (outgoing contracts)
    final outgoingKeys = [
      'contract_approved',
      'contract_payment_confirmed',
      'contract_pickup_ready',
      'contract_awaiting_return',
    ];

    if (incomingKeys.contains(key)) {
      return true;
    }
    if (outgoingKeys.contains(key)) {
      return false;
    }

    // For ambiguous keys (rejected, completed), default to incoming
    // This can be adjusted based on your business logic
    return true;
  }

  /// Handle contract-related navigation
  static void _handleContractNavigation(
    NotificationScreen screen,
    NotificationData data, {
    BuildContext? context,
  }) {
    final contractId = data.id != 0 ? data.id : data.contractId;

    if (contractId == 0) {
      if (kDebugMode) {
        print('Invalid contract ID in notification data');
      }
      return;
    }

    // Determine if this is an incoming or outgoing contract based on notification key
    final isIncoming = _isIncomingContract(data.key);

    void navigate(String route, Object? extra) {
      if (context != null && context.mounted) {
        context.push(route, extra: extra);
      } else {
        // Use post-frame callback with retry logic to ensure app is ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 300), () {
            try {
              final router = AppRouter.router;
              final navigatorKey = router.routerDelegate.navigatorKey;
              final navContext = navigatorKey.currentContext;

              if (navContext != null && navContext.mounted) {
                navContext.push(route, extra: extra);
              } else {
                // Retry once more after a longer delay
                Future.delayed(const Duration(milliseconds: 500), () {
                  final retryContext = navigatorKey.currentContext;
                  if (retryContext != null && retryContext.mounted) {
                    retryContext.push(route, extra: extra);
                  } else if (kDebugMode) {
                    print(
                      'Navigation failed - context not available after retries',
                    );
                  }
                });
              }
            } catch (e) {
              if (kDebugMode) {
                print('Error navigating: $e');
              }
            }
          });
        });
      }
    }

    switch (screen) {
      case NotificationScreen.contractDetails:
        // Navigate to the appropriate screen based on user role (owner/renter)
        if (isIncoming) {
          navigate(Routes.inComingContractDetailsScreen, contractId);
        } else {
          navigate(Routes.outGoingContractDetailsScreen, contractId);
        }
        break;
      case NotificationScreen.contractPickup:
        // Pickup is typically for renter (outgoing contract)
        navigate(Routes.outGoingContractDetailsScreen, contractId);
        break;
      case NotificationScreen.contractReturn:
        // Return is typically for renter (outgoing contract)
        navigate(Routes.outGoingContractDetailsScreen, contractId);
        break;
      default:
        // Default based on notification key
        if (isIncoming) {
          navigate(Routes.inComingContractDetailsScreen, contractId);
        } else {
          navigate(Routes.outGoingContractDetailsScreen, contractId);
        }
        break;
    }
  }

  /// Handle advertisement-related navigation
  static void _handleAdvertisementNavigation(
    NotificationScreen screen,
    NotificationData data, {
    BuildContext? context,
  }) {
    final advertisementId = data.id != 0 ? data.id : data.advertisementId;

    if (advertisementId == 0) {
      if (kDebugMode) {
        print('Invalid advertisement ID in notification data');
      }
      return;
    }

    void navigate(String route, Object? extra) {
      if (context != null && context.mounted) {
        context.push(route, extra: extra);
      } else {
        // Use post-frame callback with retry logic to ensure app is ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 300), () {
            try {
              final router = AppRouter.router;
              final navigatorKey = router.routerDelegate.navigatorKey;
              final navContext = navigatorKey.currentContext;

              if (navContext != null && navContext.mounted) {
                navContext.push(route, extra: extra);
              } else {
                // Retry once more after a longer delay
                Future.delayed(const Duration(milliseconds: 500), () {
                  final retryContext = navigatorKey.currentContext;
                  if (retryContext != null && retryContext.mounted) {
                    retryContext.push(route, extra: extra);
                  } else if (kDebugMode) {
                    print(
                      'Navigation failed - context not available after retries',
                    );
                  }
                });
              }
            } catch (e) {
              if (kDebugMode) {
                print('Error navigating: $e');
              }
            }
          });
        });
      }
    }

    switch (screen) {
      case NotificationScreen.advertisementDetails:
        navigate(Routes.productDetailsScreen, advertisementId);
        break;
      default:
        // Default to advertisement details
        navigate(Routes.productDetailsScreen, advertisementId);
        break;
    }
  }

  /// Handle navigation from FCM data payload (Map<String, dynamic>)
  static void handleFcmDataNavigation(
    Map<String, dynamic> data, {
    BuildContext? context,
  }) {
    try {
      // Parse notification data from FCM payload
      final notificationData = NotificationData.fromJson(data);
      handleNotificationNavigation(notificationData, context: context);
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing FCM data for navigation: $e');
      }
    }
  }
  */
}
