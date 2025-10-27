// import 'package:dio/dio.dart';
// import 'package:exodus/core/utils/debug_logger.dart';

// import '../../constants/api/api_constants_endpoints.dart';
// import '../../constants/app/key_constants.dart';
// import '../../services/secure_store_services.dart';
// import '../api_client.dart';

// class TokenRefreshInterceptor extends Interceptor {
//   final ApiClient _apiClient;
//   final SecureStoreServices _secureStoreServices;
//   bool _isRefreshing = false;
//   final List<RequestOptions> _pendingRequests = [];

//   // List of endpoints that should NOT trigger token refresh
//   static const _excludedPaths = [
//     ApiEndpoints.refreshToken,
//     ApiEndpoints.login,
//     ApiEndpoints.register,
//     ApiEndpoints.verifyOtp,
//     ApiEndpoints.forgetPassword,
//     ApiEndpoints.resetPassword,
//   ];

//   TokenRefreshInterceptor(this._apiClient, this._secureStoreServices);

//   @override
//   Future<void> onError(
//     DioException err,
//     ErrorInterceptorHandler handler,
//   ) async {
//     dPrint(
//       "Refresh Token Interceptor triggered for ${err.requestOptions.path}",
//     );

//     // Only handle 401 errors that are likely token-related
//     if (_shouldHandleError(err)) {
//       if (_isRefreshing) {
//         // If already refreshing, queue the request
//         return _queueRequest(err.requestOptions, handler);
//       }

//       _isRefreshing = true;
//       dPrint("Attempting token refresh...");

//       try {
//         final isRefreshed = await _apiClient.refreshToken();

//         if (isRefreshed) {
//           dPrint("Token refresh successful");
//           // Retry all pending requests
//           await _retryPendingRequests();
//           // Retry the current request
//           return _retryRequest(err.requestOptions, handler);
//         } else {
//           dPrint("Token refresh failed");
//           _clearPendingRequests();
//           // _logoutUser();
//           return handler.reject(err);
//         }
//       } catch (e) {
//         dPrint("Token refresh error: $e");
//         _clearPendingRequests();
//         return handler.reject(err);
//       } finally {
//         _isRefreshing = false;
//       }
//     } else if (err.response?.statusCode == 404 ||
//         err.response?.statusCode == 400) {
//       return handler.next(err); // Let your main error handler process it
//     }
//     // For all other errors, reject immediately
//     else {
//       return handler.reject(err);
//     }
//   }

//   bool _shouldHandleError(DioException err) {
//     return err.response?.statusCode == 401 &&
//         err.requestOptions.path != ApiEndpoints.refreshToken &&
//         err.requestOptions.path != ApiEndpoints.login &&
//         err.requestOptions.path != ApiEndpoints.register;
//   }

//   Future<void> _queueRequest(
//     RequestOptions options,
//     ErrorInterceptorHandler handler,
//   ) async {
//     dPrint("Queueing request for ${options.path}");
//     _pendingRequests.add(options);
//     handler.reject(
//       DioException(
//         requestOptions: options,
//         error: 'Waiting for token refresh',
//         type: DioExceptionType.unknown,
//       ),
//     );
//   }

//   Future<void> _retryPendingRequests() async {
//     dPrint("Retrying ${_pendingRequests.length} pending requests");
//     for (final options in _pendingRequests) {
//       try {
//         final newToken = await _secureStoreServices.retrieveData(
//           KeyConstants.accessToken,
//         );
//         options.headers['Authorization'] = 'Bearer $newToken';
//         await _apiClient.dio.fetch(options);
//       } catch (e) {
//         dPrint("Failed to retry request to ${options.path}: $e");
//       }
//     }
//     _pendingRequests.clear();
//   }

//   Future<void> _retryRequest(
//     RequestOptions options,
//     ErrorInterceptorHandler handler,
//   ) async {
//     try {
//       final newToken = await _secureStoreServices.retrieveData(
//         KeyConstants.accessToken,
//       );
//       options.headers['Authorization'] = 'Bearer $newToken';
//       final response = await _apiClient.dio.fetch(options);
//       handler.resolve(response);
//     } catch (e) {
//       dPrint("Failed to retry request: $e");
//       handler.reject(
//         DioException(
//           requestOptions: options,
//           error: 'Failed after token refresh',
//           type: DioExceptionType.unknown,
//         ),
//       );
//     }
//   }

//   void _clearPendingRequests() {
//     _pendingRequests.clear();
//   }
// }
