import 'package:flutter/material.dart';
import 'package:task_dashboard/core/widget/app_snackbar.dart';

/// Comprehensive examples for using the global AppSnackBar widget
class AppSnackBarExamples {
  // ============================================================================
  // BASIC USAGE EXAMPLES
  // ============================================================================

  /// Example 1: Basic success SnackBar
  static void showBasicSuccess(BuildContext context) {
    AppSnackBar.showSuccess(
      context,
      message: 'Operation completed successfully!',
    );
  }

  /// Example 2: Basic error SnackBar
  static void showBasicError(BuildContext context) {
    AppSnackBar.showError(
      context,
      message: 'Something went wrong. Please try again.',
    );
  }

  /// Example 3: Basic warning SnackBar
  static void showBasicWarning(BuildContext context) {
    AppSnackBar.showWarning(
      context,
      message: 'Please check your input and try again.',
    );
  }

  /// Example 4: Basic info SnackBar
  static void showBasicInfo(BuildContext context) {
    AppSnackBar.showInfo(context, message: 'Your profile has been updated.');
  }

  // ============================================================================
  // ADVANCED USAGE EXAMPLES
  // ============================================================================

  /// Example 5: Custom duration
  static void showCustomDuration(BuildContext context) {
    AppSnackBar.showSuccess(
      context,
      message: 'This will show for 10 seconds',
      duration: Duration(seconds: 10),
    );
  }

  /// Example 6: With dismiss callback
  static void showWithCallback(BuildContext context) {
    AppSnackBar.showInfo(
      context,
      message: 'Tap dismiss to see the callback',
      onDismiss: () {
        print('SnackBar was dismissed!');
        // You can perform any action here
      },
    );
  }

  /// Example 7: Custom SnackBar with leading widget
  static void showCustomLeading(BuildContext context) {
    AppSnackBar.showCustom(
      context,
      message: 'Custom leading icon',
      type: SnackBarType.success,
      leading: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(Icons.star, color: Colors.green.shade600, size: 16),
      ),
    );
  }

  /// Example 8: Custom SnackBar with trailing widget
  static void showCustomTrailing(BuildContext context) {
    AppSnackBar.showCustom(
      context,
      message: 'Custom trailing widget',
      type: SnackBarType.info,
      trailing: IconButton(
        icon: Icon(Icons.close, color: Colors.white, size: 16),
        onPressed: () {
          AppSnackBar.hide(context);
        },
      ),
    );
  }

  /// Example 9: Custom SnackBar without dismiss action
  static void showWithoutDismissAction(BuildContext context) {
    AppSnackBar.showCustom(
      context,
      message: 'No dismiss button - auto-hide only',
      type: SnackBarType.warning,
      showDismissAction: false,
      duration: Duration(seconds: 2),
    );
  }

  /// Example 10: Custom styling
  static void showCustomStyling(BuildContext context) {
    AppSnackBar.showCustom(
      context,
      message: 'Custom styled SnackBar',
      type: SnackBarType.error,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      borderRadius: BorderRadius.circular(20),
    );
  }

  // ============================================================================
  // CONTEXT EXTENSION EXAMPLES
  // ============================================================================

  /// Example 11: Using context extension for success
  static void showSuccessWithExtension(BuildContext context) {
    context.showSuccessSnackBar('Success using extension!');
  }

  /// Example 12: Using context extension for error
  static void showErrorWithExtension(BuildContext context) {
    context.showErrorSnackBar('Error using extension!');
  }

  /// Example 13: Using context extension for warning
  static void showWarningWithExtension(BuildContext context) {
    context.showWarningSnackBar('Warning using extension!');
  }

  /// Example 14: Using context extension for info
  static void showInfoWithExtension(BuildContext context) {
    context.showInfoSnackBar('Info using extension!');
  }

  // ============================================================================
  // PRACTICAL EXAMPLES
  // ============================================================================

  /// Example 15: Form validation error
  static void showFormValidationError(BuildContext context, String fieldName) {
    AppSnackBar.showError(context, message: 'Please enter a valid $fieldName');
  }

  /// Example 16: Network error
  static void showNetworkError(BuildContext context) {
    AppSnackBar.showError(
      context,
      message:
          'Network connection failed. Please check your internet connection.',
      duration: Duration(seconds: 5),
    );
  }

  /// Example 17: Success with action
  static void showSuccessWithAction(BuildContext context, String action) {
    AppSnackBar.showSuccess(
      context,
      message: '$action completed successfully!',
      onDismiss: () {
        // Navigate or perform action after dismiss
        Navigator.pop(context);
      },
    );
  }

  /// Example 18: Loading completion
  static void showLoadingComplete(BuildContext context) {
    AppSnackBar.showInfo(
      context,
      message: 'Data loaded successfully',
      duration: Duration(seconds: 2),
    );
  }

  /// Example 19: User feedback
  static void showUserFeedback(BuildContext context, String feedback) {
    AppSnackBar.showCustom(
      context,
      message: feedback,
      type: SnackBarType.info,
      leading: Icon(Icons.feedback, color: Colors.white, size: 20),
      trailing: Icon(Icons.thumb_up, color: Colors.white, size: 16),
    );
  }

  /// Example 20: Authentication status
  static void showAuthStatus(BuildContext context, bool isSuccess) {
    if (isSuccess) {
      AppSnackBar.showSuccess(
        context,
        message: 'Authentication successful!',
        onDismiss: () {
          // Navigate to home screen
        },
      );
    } else {
      AppSnackBar.showError(
        context,
        message: 'Authentication failed. Please try again.',
      );
    }
  }

  // ============================================================================
  // UTILITY EXAMPLES
  // ============================================================================

  /// Example 21: Hide current SnackBar
  static void hideCurrentSnackBar(BuildContext context) {
    AppSnackBar.hide(context);
  }

  /// Example 22: Clear all SnackBars
  static void clearAllSnackBars(BuildContext context) {
    AppSnackBar.clearAll(context);
  }

  /// Example 23: Show multiple SnackBars in sequence
  static void showMultipleSnackBars(BuildContext context) {
    AppSnackBar.showInfo(context, message: 'First message');

    Future.delayed(Duration(seconds: 2), () {
      AppSnackBar.showSuccess(context, message: 'Second message');
    });

    Future.delayed(Duration(seconds: 4), () {
      AppSnackBar.showWarning(context, message: 'Third message');
    });
  }

  /// Example 24: Conditional SnackBar based on condition
  static void showConditionalSnackBar(BuildContext context, bool condition) {
    if (condition) {
      AppSnackBar.showSuccess(context, message: 'Condition is true!');
    } else {
      AppSnackBar.showWarning(context, message: 'Condition is false!');
    }
  }

  /// Example 25: SnackBar with custom action
  static void showSnackBarWithCustomAction(BuildContext context) {
    AppSnackBar.showCustom(
      context,
      message: 'Undo your last action',
      type: SnackBarType.info,
      trailing: TextButton(
        onPressed: () {
          // Perform undo action
          AppSnackBar.hide(context);
          AppSnackBar.showSuccess(context, message: 'Action undone!');
        },
        child: Text(
          'UNDO',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      showDismissAction: false,
    );
  }
}

/// Usage guide and best practices
class AppSnackBarUsageGuide {
  /// When to use each SnackBar type:
  static Map<String, String> getSnackBarTypeUsage() {
    return {
      'Success': 'Use for successful operations, completions, confirmations',
      'Error': 'Use for errors, failures, validation issues',
      'Warning': 'Use for warnings, cautions, important notices',
      'Info': 'Use for general information, updates, status changes',
    };
  }

  /// Best practices for using AppSnackBar:
  static List<String> getBestPractices() {
    return [
      'Keep messages concise and clear',
      'Use appropriate SnackBar types for different scenarios',
      'Don\'t show too many SnackBars in quick succession',
      'Use custom duration for important messages',
      'Provide dismiss callbacks for actionable feedback',
      'Use context extensions for cleaner code',
      'Test SnackBars on different screen sizes',
    ];
  }

  /// Common patterns:
  static Map<String, String> getCommonPatterns() {
    return {
      'Form Validation': '''
        AppSnackBar.showError(context, message: 'Please fill all required fields');
      ''',

      'API Success': '''
        AppSnackBar.showSuccess(context, message: 'Data saved successfully');
      ''',

      'Network Error': '''
        AppSnackBar.showError(context, message: 'Network connection failed');
      ''',

      'User Action': '''
        AppSnackBar.showInfo(context, message: 'Profile updated successfully');
      ''',

      'With Callback': '''
        AppSnackBar.showSuccess(
          context,
          message: 'Item deleted',
          onDismiss: () => refreshList(),
        );
      ''',
    };
  }
}
