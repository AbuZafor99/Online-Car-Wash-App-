// // lib/core/network/api_result.dart

// sealed class ApiResult<T> {
//   const ApiResult();

//   factory ApiResult.success({
//     required T data,
//     required String message,
//     required int statusCode,
//   }) = ApiSuccess<T>;

//   factory ApiResult.failure({
//     required String message,
//     required int statusCode,
//     T? data,
//   }) = ApiFailure<T>;

//   // Helper methods
//   bool get isSuccess => this is ApiSuccess<T>;
//   bool get isFailure => this is ApiFailure<T>;

//   T? get data => switch (this) {
//     ApiSuccess<T> success => success.data,
//     ApiFailure<T> failure => failure.data,
//   };

//   String get message => switch (this) {
//     ApiSuccess<T> success => success.message,
//     ApiFailure<T> failure => failure.message,
//   };

//   int get statusCode => switch (this) {
//     ApiSuccess<T> success => success.statusCode,
//     ApiFailure<T> failure => failure.statusCode,
//   };

//   // Fold method for handling both cases
//   R fold<R>({
//     required R Function(T data, String message) onSuccess,
//     required R Function(String message, int statusCode, T? data) onFailure,
//     required Null Function(String message) onError,
//   }) {
//     return switch (this) {
//       ApiSuccess<T> success => onSuccess(success.data, success.message),
//       ApiFailure<T> failure => onFailure(
//         failure.message,
//         failure.statusCode,
//         failure.data,
//       ),
//     };
//   }

//   // When method for handling both cases
//   R when<R>({
//     required R Function(T data, String message) success,
//     required R Function(String message) error,
//   }) {
//     return switch (this) {
//       ApiSuccess<T> successResult => success(
//         successResult.data,
//         successResult.message,
//       ),
//       ApiFailure<T> failure => error(failure.message),
//     };
//   }

//   // Map method for transforming success data
//   ApiResult<R> map<R>(R Function(T) transform) {
//     return switch (this) {
//       ApiSuccess<T> success => ApiResult.success(
//         data: transform(success.data),
//         message: success.message,
//         statusCode: success.statusCode,
//       ),
//       ApiFailure<T> failure => ApiResult.failure(
//         message: failure.message,
//         statusCode: failure.statusCode,
//         data: null,
//       ),
//     };
//   }
// }

// final class ApiSuccess<T> extends ApiResult<T> {
//   final T data;
//   final String message;
//   final int statusCode;

//   const ApiSuccess({
//     required this.data,
//     required this.message,
//     required this.statusCode,
//   });

//   @override
//   String toString() =>
//       'ApiSuccess(data: $data, message: $message, statusCode: $statusCode)';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is ApiSuccess<T> &&
//         other.data == data &&
//         other.message == message &&
//         other.statusCode == statusCode;
//   }

//   @override
//   int get hashCode => Object.hash(data, message, statusCode);
// }

// final class ApiFailure<T> extends ApiResult<T> {
//   final String message;
//   final int statusCode;
//   final T? data;

//   const ApiFailure({
//     required this.message,
//     required this.statusCode,
//     this.data,
//   });

//   @override
//   String toString() =>
//       'ApiFailure(message: $message, statusCode: $statusCode, data: $data)';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is ApiFailure<T> &&
//         other.message == message &&
//         other.statusCode == statusCode &&
//         other.data == data;
//   }

//   @override
//   int get hashCode => Object.hash(message, statusCode, data);
// }
