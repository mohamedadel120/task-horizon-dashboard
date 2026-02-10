/// Common validation functions
class Validators {
  /// Validate required field
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(
    String? value,
    int min, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.trim().length < min) {
      return '$fieldName must be at least $min characters';
    }
    return null;
  }

  /// Validate maximum length
  static String? maxLength(
    String? value,
    int max, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.trim().length > max) {
      return '$fieldName must be at most $max characters';
    }
    return null;
  }

  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate numeric value
  static String? numeric(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) return null;
    if (double.tryParse(value.trim()) == null) {
      return '$fieldName must be a number';
    }
    return null;
  }

  /// Validate positive number
  static String? positiveNumber(
    String? value, {
    String fieldName = 'This field',
  }) {
    final numError = numeric(value, fieldName: fieldName);
    if (numError != null) return numError;

    if (value == null || value.trim().isEmpty) return null;
    final number = double.parse(value.trim());
    if (number <= 0) {
      return '$fieldName must be greater than 0';
    }
    return null;
  }

  /// Validate slug format
  static String? slug(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final slugRegex = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');
    if (!slugRegex.hasMatch(value.trim())) {
      return 'Slug can only contain lowercase letters, numbers, and hyphens';
    }
    return null;
  }

  /// Combine multiple validators
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}
