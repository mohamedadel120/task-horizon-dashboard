import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/helpers/constance.dart';
import 'package:task_dashboard/core/routing/routes.dart';
import 'package:task_dashboard/core/widget/app_status_popup.dart';
import 'package:task_dashboard/core/widget/auth_guard/cubit/auth_guard_cubit.dart';
import 'package:task_dashboard/core/widget/popups/popup_actions.dart';

class AuthGuardHelper {
  /// List of routes that don't require authentication and shouldn't show the dialog
  static const List<String> _publicRoutes = [
    Routes.loginScreen,
    Routes.registerScreen,
    Routes.onBoardingScreen,
    Routes.forgotPasswordPhoneScreen,
    Routes.otpScreen,
    Routes.resetPasswordScreen,
    Routes.confirmResetPassScreen,
  ];

  /// Checks if user is logged in, shows dialog if not
  /// Returns true if user is logged in, false otherwise
  static bool checkAuthAndShowDialog(BuildContext context) {
    if (isLoggedInUser) {
      return true;
    }

    // Check if current route is a public route (auth pages)
    // Don't show dialog on authentication pages
    try {
      final router = GoRouter.of(context);
      String? currentLocation;

      // Method 1: Try to get from GoRouterState (most reliable)
      try {
        final state = GoRouterState.of(context);
        currentLocation = state.matchedLocation;
      } catch (_) {
        // Method 2: Try to get from router delegate
        try {
          final uri = router.routerDelegate.currentConfiguration.uri;
          currentLocation = uri.path;
        } catch (_) {}
      }

      // Method 3: Try to get from ModalRoute settings
      if (currentLocation == null || currentLocation.isEmpty) {
        final route = ModalRoute.of(context);
        if (route != null) {
          final settings = route.settings;
          if (settings.name != null) {
            currentLocation = settings.name;
          }
        }
      }

      // Check if current location is a public route
      if (currentLocation != null && currentLocation.isNotEmpty) {
        final location = currentLocation;
        final isPublicRoute = _publicRoutes.any(
          (route) =>
              location == route ||
              location.startsWith(route) ||
              location.contains(route),
        );

        if (isPublicRoute) {
          return false; // Don't show dialog on auth pages
        }
      }
    } catch (e) {
      // If we can't determine the route, proceed with showing dialog
    }

    _showAuthRequiredDialog(context);
    return false;
  }

  /// Shows authentication required dialog
  static void showAuthDialog(BuildContext context) {
    // Hide dialog in cubit first
    try {
      final cubit = context.read<AuthGuardCubit>();
      cubit.hideDialog();
    } catch (_) {
      // Cubit might not be available, continue anyway
    }

    AppStatusPopup.show(
      context,
      title: 'Authentication Required', // context.l10n.authRequiredTitle,
      subtitle: 'Please login to continue', // context.l10n.authRequiredMessage,
      type: AppStatusPopupType.custom,
      actions: [
        AppStatusPopupAction(
          label: 'Browse without Login', // context.l10n.browseWithoutLogin,
          onPressed: () {
            print('Browse without login callback executed');
          },
          isPrimary: false,
          actionType: PopupActionType.browseWithoutLogin,
        ),
        AppStatusPopupAction(
          label: 'Login', // context.l10n.goToLogin,
          onPressed: () {
            print('Go to login callback executed');
          },
          isPrimary: true,
          actionType: PopupActionType.goToLogin,
        ),
      ],
    );
  }

  /// Shows authentication required dialog (legacy method)
  static void _showAuthRequiredDialog(BuildContext context) {
    showAuthDialog(context);
  }

  static Widget? protectRoute(
    BuildContext context,
    Widget authenticatedWidget,
  ) {
    if (isLoggedInUser) {
      return authenticatedWidget;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAuthRequiredDialog(context);
    });

    return null;
  }
}
