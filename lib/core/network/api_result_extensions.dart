// // lib/core/network/api_result_extensions.dart

// import 'api_result.dart';

// extension ApiResultExtensions<T> on ApiResult<T> {
//   // Easy message access
//   String get msg => message;

//   // Type checking
//   bool get isSuccess => this is ApiSuccess<T>;
//   bool get isError => this is ApiFailure<T>;

//   // Safe data access
//   T? get dataOrNull => isSuccess ? (this as ApiSuccess<T>).data : null;

//   // Handle result with callbacks
//   void handle({
//     required void Function(T? data, String message) onSuccess,
//     required void Function(String message) onError,
//   }) {
//     if (isSuccess) {
//       final success = this as ApiSuccess<T>;
//       onSuccess(success.data, success.message);
//     } else {
//       onError(message);
//     }
//   }
// }
