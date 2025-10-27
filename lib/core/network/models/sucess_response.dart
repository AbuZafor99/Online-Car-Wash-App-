// lib/core/network/models/sucess_response.dart

class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;

  BaseResponse({required this.success, required this.message, this.data});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return BaseResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
