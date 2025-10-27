// lib/core/network/dio_error_handler.dart

import 'package:dio/dio.dart';
import 'package:flutx_core/flutx_core.dart';

String dioErrorToUserMessage(DioException error) {
  // First try to get message from response body
  if (error.response != null) {
    try {
      final responseData = error.response?.data;
      if (responseData is Map) {
        if (responseData.containsKey('message')) {
          return responseData['message'] as String;
        }
      }
    } catch (e) {
      DPrint.error("Error parsing error response: $e");
    }

    // // Fall back to status code messages
    switch (error.response?.statusCode) {
      case 400:
        return "Bad request - please check your input";
      case 401:
        return "Unauthorized - please login again";
      case 403:
        return "Forbidden - you don't have permission";
      case 404:
        return "Resource not found";
      case 429:
        return "Too many requests - please slow down";
      case 500:
        return "Server error - please try again later";
      case 502:
        return "Bad gateway - service temporarily unavailable";
      case 503:
        return "Service unavailable - please try again later";
      case 504:
        return "Gateway timeout - please try again";
    }
  }

  // Fall back to default messages
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return "Connection timed out. Please try again.";
    case DioExceptionType.sendTimeout:
      return "Request timed out. Please check your network.";
    case DioExceptionType.receiveTimeout:
      return "Server took too long to respond.";
    case DioExceptionType.badCertificate:
      return "Invalid server certificate.";
    case DioExceptionType.badResponse:
      return "Server error occurred.";
    case DioExceptionType.cancel:
      return "Request was cancelled.";
    case DioExceptionType.connectionError:
      return "No internet connection.";
    case DioExceptionType.unknown:
      return "Something went wrong. Please try again.";
  }
}
