// lib/core/network/models/error_response.dart

import 'base_response.dart';
import 'error_source.dart';

class ErrorResponse extends BaseResponse<void> {
  ErrorResponse({
    required super.success,
    required super.message,
    required List<ErrorSource> super.errorSources,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      errorSources: json['errorSources'] != null
          ? (json['errorSources'] as List)
                .map((e) => ErrorSource.fromJson(e))
                .toList()
          : [],
    );
  }

  static ErrorResponse fromBaseResponse(BaseResponse response) {
    return ErrorResponse(
      success: response.success,
      message: response.message,
      errorSources: response.errorSources ?? [],
    );
  }
}
