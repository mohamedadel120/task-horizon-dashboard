import 'package:json_annotation/json_annotation.dart';
part 'api_error_model.g.dart';

@JsonSerializable()
class ApiErrorModel {
  final String? message;
  @JsonKey(name: 'data')
  final dynamic errors;

  ApiErrorModel({this.message, this.errors});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);

  static String getAllErrorMessages(ApiErrorModel apiErrorModel) {
    // Check if there are error messages
    if (apiErrorModel.errors == null) {
      return apiErrorModel.message ?? "Unknown error occurred";
    }

    // Handle different error data types
    if (apiErrorModel.errors is List) {
      final errorList = apiErrorModel.errors as List;
      if (errorList.isEmpty) {
        return apiErrorModel.message ?? "Unknown error occurred";
      }
      final errorMessages = errorList
          .map<String>((message) => message.toString())
          .join('\n\n');
      return errorMessages;
    } else if (apiErrorModel.errors is Map) {
      final errorMap = apiErrorModel.errors as Map;
      if (errorMap.isEmpty) {
        return apiErrorModel.message ?? "Unknown error occurred";
      }

      // Handle the specific API structure: {"field": ["error1", "error2"]}
      final List<String> allErrors = [];
      errorMap.forEach((field, errors) {
        if (errors is List) {
          for (var error in errors) {
            allErrors.add(error.toString());
          }
        } else {
          allErrors.add(errors.toString());
        }
      });

      return allErrors.join('\n\n');
    }

    // Fallback to message or default
    return apiErrorModel.message ?? "Unknown error occurred";
  }
}

