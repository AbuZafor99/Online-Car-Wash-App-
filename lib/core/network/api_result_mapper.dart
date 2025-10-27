// // lib/core/network/api_result_mapper.dart

// import 'package:flutter/foundation.dart';
// import 'api_result.dart';
// import 'models/base_response.dart';
// import 'models/error_response.dart';

// ApiResult<T> mapBaseResponse<T>(BaseResponse<T> base) {
//   if (kDebugMode) {
//     print('''
//   Mapping BaseResponse:
//   - Success: ${base.success}
//   - Message: ${base.message}
//   - Data: ${base.data?.toString() ?? 'null'}
//   ''');
//   }

//   if (base.success) {
//     return ApiResult.success(
//       data: base.data as T,
//       message: base.message,
//       statusCode: 200,
//     );
//   } else {
//     // If we have error details, parse them
//     if (base.data is Map && (base.data as Map).containsKey('errorSources')) {
//       final errorResponse = ErrorResponse.fromJson(
//         base.data as Map<String, dynamic>,
//       );
//       return ApiResult.failure(
//         message: errorResponse.combinedErrorMessage,
//         statusCode: 400,
//       );
//     }

//     return ApiResult.failure(message: base.message, statusCode: 400);
//   }
// }
