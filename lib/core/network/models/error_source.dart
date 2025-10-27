// lib/core/network/models/error_source.dart

class ErrorSource {
  final String path;
  final String message;

  ErrorSource({required this.path, required this.message});

  factory ErrorSource.fromJson(Map<String, dynamic> json) {
    return ErrorSource(
      path: json['path'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'path': path, 'message': message};
}
