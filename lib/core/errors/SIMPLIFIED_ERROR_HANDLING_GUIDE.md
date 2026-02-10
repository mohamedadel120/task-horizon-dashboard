# Simplified Error Handling System Guide

## Overview
This guide explains the simplified and focused error handling system designed for multi-feature Flutter apps. The system provides clear separation of concerns and follows best practices for error handling in BaseService and BaseRepository layers.

## Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    -------------------
│    BaseError    │    │      Failure     │    │    Exception    │
│    (Core)       │    │   (for Domain)   │    │   (Data)        │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Failures      │    │  FailureHandle   │    │  Exception      │
│ (Server/Network)│    │ (FailureHandler) │    │   Handler       │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  Exceptions     │    │ FailureHandler   │    │ App Exceptions  │
│ (App Logic)     │    │ (Server Errors)  │    │   (platform )   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Core Components

### 1. **BaseError** (`errors.dart`)
- **Purpose**: Base class for all errors with common properties and utility methods
- **Key Features**:
  - Error categorization (`isNetworkError`, `isServerError`, etc.)
  - Smart error analysis (`canRetry`, `requiresUserAction`)
  - User-friendly messages (`userFriendlyMessage`)

### 2. **Failures** (`failures.dart`)
- **Purpose**: Handle server-side failures and network errors
- **Types**: `NetworkFailure`, `ServerFailure`, `TimeoutFailure`, etc.
- **Usage**: Created by `FailureHandler` when handling DioException

### 3. **Exceptions** (`exceptions.dart`)
- **Purpose**: Handle application-level exceptions
- **Types**: `ValidationException`, `PermissionException`, `CacheException`, etc.
- **Usage**: Thrown by application logic and handled by `ExceptionHandler`

### 4. **FailureHandler** (`failure_handler.dart`)
- **Purpose**: **Handle server failures** - converts DioException to appropriate failures
- **Responsibility**: Network errors, HTTP status codes, timeouts
- **Usage**: Called automatically by `ErrorHandler` for DioException

### 5. **ExceptionHandler** (`exception_handler.dart`)
- **Purpose**: **Handle app exceptions** - converts AppException to failures
- **Responsibility**: Validation errors, permission errors, parsing errors
- **Usage**: Called automatically by `ErrorHandler` for non-DioException errors

### 6. **ErrorHandler** (`error_handler.dart`)
- **Purpose**: **Main entry point** - provides unified interface for all error handling
- **Responsibility**: Routes errors to appropriate handlers, provides utility methods
- **Usage**: Used directly in BaseService and BaseRepository

## Usage in BaseService and BaseRepository

### BaseService Example

```dart
abstract class BaseService {
  /// Handle any error
  BaseError handleError(dynamic error, [StackTrace? stackTrace]) {
    return ErrorHandler.handleError(error, stackTrace);
  }

  /// Handle server/network errors specifically
  BaseError handleServerError(dynamic error, [StackTrace? stackTrace, Map<String, dynamic>? context]) {
    return ErrorHandler.handleServerError(error, stackTrace, context);
  }

  /// Handle application errors specifically
  BaseError handleAppError(dynamic error, [StackTrace? stackTrace]) {
    return ErrorHandler.handleAppException(error);
  }

  /// Handle validation errors
  BaseError handleValidationError(String message, [dynamic originalError]) {
    return ErrorHandler.handleValidationError(message, 400, originalError);
  }

  /// Execute with retry logic
  Future<T> executeWithRetry<T>({
    required Future<T> Function() operation,
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    return ErrorHandler.handleWithRetry(
      operation: operation,
      maxRetries: maxRetries,
      delay: delay,
    );
  }
}
```

### BaseRepository Example

```dart
abstract class BaseRepository {
  /// Handle any error
  BaseError handleError(dynamic error, [StackTrace? stackTrace]) {
    return ErrorHandler.handleError(error, stackTrace);
  }

  /// Handle server/network errors specifically
  BaseError handleServerError(dynamic error, [StackTrace? stackTrace, Map<String, dynamic>? context]) {
    return ErrorHandler.handleServerError(error, stackTrace, context);
  }

  /// Handle application errors specifically
  BaseError handleAppError(dynamic error, [StackTrace? stackTrace]) {
    return ErrorHandler.handleAppException(error);
  }

  /// Execute with fallback
  T executeWithFallback<T>({
    required T Function() operation,
    required T fallbackValue,
  }) {
    return ErrorHandler.handleWithFallback(
      operation: operation,
      fallbackValue: fallbackValue,
    );
  }
}
```

## Error Handling Flow

### 1. **Server/Network Errors** (DioException)
```
DioException → ErrorHandler.handleError() → FailureHandler.handleDioError() → Failure
```

### 2. **Application Errors** (AppException)
```
AppException → ErrorHandler.handleError() → ExceptionHandler.handle() → Failure
```

### 3. **Standard Dart Errors**
```
Dart Error → ErrorHandler.handleError() → ExceptionHandler.handle() → Failure
```

## Best Practices

### 1. **Error Categorization**
```dart
try {
  // Your code here
} catch (error) {
  final failure = handleError(error);
  
  if (failure.isNetworkError) {
    // Handle network errors
    showNoInternetDialog();
  } else if (failure.isServerError) {
    // Handle server errors
    handleServerError(failure);
  } else if (failure.isValidationError) {
    // Handle validation errors
    showValidationError(failure.message);
  }
}
```

### 2. **User Experience**
```dart
if (failure.shouldShowToUser) {
  showErrorDialog(failure.userFriendlyMessage);
}

if (failure.canRetry) {
  showRetryButton(() => retryOperation());
}

if (failure.requiresUserAction) {
  showActionRequiredDialog(failure.message);
}
```

### 3. **Retry Logic**
```dart
final result = await executeWithRetry(
  operation: () => apiService.fetchData(),
  maxRetries: 3,
  delay: Duration(seconds: 2),
);
```

### 4. **Fallback Handling**
```dart
final data = executeWithFallback(
  operation: () => fetchFromServer(),
  fallbackValue: getCachedData(),
);
```

### 5. **Error Context**
```dart
final context = createErrorContext(
  operation: 'getUser',
  additionalData: {'userId': userId, 'timestamp': DateTime.now()},
);

final failure = handleServerError(error, StackTrace.current, context);
```

## Error Types and When to Use Them

### **Failures** (Server/Network)
- `NetworkFailure`: No internet, connection issues
- `ServerFailure`: HTTP errors (4xx, 5xx)
- `TimeoutFailure`: Request timeouts
- `RequestCancelledFailure`: Cancelled requests

### **Exceptions** (Application)
- `ValidationException`: Invalid input data
- `PermissionException`: Access denied
- `ParsingException`: Data format errors
- `CacheException`: Cache operation failures

## Integration with UI Layer

### 1. **Error Display**
```dart
void showError(BaseError error) {
  if (error.shouldShowToUser) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.userFriendlyMessage),
        backgroundColor: error.isServerError ? Colors.red : Colors.orange,
      ),
    );
  }
}
```

### 2. **Retry UI**
```dart
Widget buildRetryButton(BaseError error) {
  if (error.canRetry) {
    return ElevatedButton(
      onPressed: () => retryOperation(),
      child: Text('Retry'),
    );
  }
  return SizedBox.shrink();
}
```

### 3. **Action Required UI**
```dart
Widget buildActionRequired(BaseError error) {
  if (error.requiresUserAction) {
    return AlertDialog(
      title: Text('Action Required'),
      content: Text(error.message),
      actions: [
        TextButton(
          onPressed: () => performAction(),
          child: Text('OK'),
        ),
      ],
    );
  }
  return SizedBox.shrink();
}
```

## Testing

### 1. **Unit Tests**
```dart
test('should handle validation error correctly', () {
  final error = ValidationFailure(message: 'Invalid email');
  
  expect(error.isValidationError, true);
  expect(error.canRetry, false);
  expect(error.requiresUserAction, true);
  expect(error.shouldShowToUser, true);
});
```

### 2. **Integration Tests**
```dart
test('should convert DioException to NetworkFailure', () {
  final dioError = DioException(
    type: DioExceptionType.connectionError,
    message: 'Connection failed',
  );
  
  final failure = ErrorHandler.handleDioError(dioError);
  
  expect(failure, isA<NetworkFailure>());
  expect(failure.isNetworkError, true);
  expect(failure.canRetry, true);
});
```

## Migration from Old System

### 1. **Replace Direct Error Creation**
```dart
// Old
throw NetworkFailure(message: 'Network error');

// New
throw ErrorHandler.handleNetworkError(originalError);
```

### 2. **Use Base Classes**
```dart
// Old
class UserService {
  // Direct error handling
}

// New
class UserService extends BaseService {
  // Inherited error handling methods
}
```

### 3. **Leverage Utility Methods**
```dart
// Old
if (error is NetworkFailure || error is TimeoutFailure) {
  // Retry logic
}

// New
if (error.canRetry) {
  // Retry logic
}
```

## Conclusion

This simplified error handling system provides:

- **Clear separation of concerns** between server failures and app errors
- **Consistent API** across BaseService and BaseRepository
- **Easy to use** utility methods for common error scenarios
- **Best practices** for multi-feature Flutter apps
- **Maintainable code** with clear error categorization
- **User-friendly experience** with smart error analysis

The system is designed to be simple yet powerful, making it easy for developers to handle errors correctly while maintaining good user experience.

