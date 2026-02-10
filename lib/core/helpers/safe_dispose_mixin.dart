import 'package:flutter/material.dart';

/// A mixin that provides enhanced dispose functionality for cubits
/// with TextEditingControllers and other disposable resources
mixin SafeDisposeMixin {
  bool _isDisposed = false;

  /// Getter to check if the cubit is disposed
  bool get isDisposed => _isDisposed;

  /// Safely dispose a TextEditingController with error handling
  void safeDisposeController(
    TextEditingController controller,
    String controllerName,
  ) {
    try {
      // Check if controller has listeners before disposing
      if (!controller.hasListeners) {
        controller.dispose();
      } else {
        // Remove all listeners first, then dispose
        controller.removeListener(() {});
        controller.dispose();
      }
        } catch (e) {
      print('Error disposing $controllerName: $e');
    }
  }

  /// Safely dispose multiple TextEditingControllers
  void safeDisposeControllers(Map<TextEditingController, String> controllers) {
    controllers.forEach((controller, name) {
      safeDisposeController(controller, name);
    });
  }

  /// Clear all text controllers
  void clearControllers(List<TextEditingController> controllers) {
    try {
      for (final controller in controllers) {
        controller.clear();
            }
    } catch (e) {
      print('Error clearing controllers: $e');
    }
  }

  /// Reset form if it has a current state
  void resetForm(GlobalKey<FormState> formKey) {
    try {
      if (formKey.currentState != null) {
        formKey.currentState!.reset();
      }
    } catch (e) {
      print('Error resetting form: $e');
    }
  }

  /// Mark the cubit as disposed
  void markAsDisposed() {
    _isDisposed = true;
  }

  /// Check if cubit is disposed before performing operations
  bool shouldContinue() {
    return !_isDisposed;
  }

  /// Enhanced dispose method that should be called in cubit's close method
  Future<void> safeDispose({
    List<TextEditingController>? controllers,
    GlobalKey<FormState>? formKey,
    Map<TextEditingController, String>? namedControllers,
    VoidCallback? additionalCleanup,
  }) async {
    markAsDisposed();

    try {
      // Dispose named controllers if provided
      if (namedControllers != null) {
        safeDisposeControllers(namedControllers);
      }

      // Clear controllers if provided
      if (controllers != null) {
        clearControllers(controllers);
      }

      // Reset form if provided
      if (formKey != null) {
        resetForm(formKey);
      }

      // Additional cleanup if provided
      if (additionalCleanup != null) {
        additionalCleanup();
      }
    } catch (e) {
      print('Error during safe disposal: $e');
    }
  }
}

