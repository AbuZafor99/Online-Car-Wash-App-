// lib/core/network/models/network_success.dart
import 'package:equatable/equatable.dart';

class NetworkSuccess<T> extends Equatable {
  final T data;
  final String message;
  final int statusCode;

  const NetworkSuccess({
    required this.data,
    required this.message,
    required this.statusCode,
  });

  @override
  List<Object?> get props => [data, message, statusCode];
}

class ServerSuccess<T> extends NetworkSuccess<T> {
  const ServerSuccess({
    required super.data,
    required super.message,
    required super.statusCode,
  });
}

class CreatedSuccess<T> extends NetworkSuccess<T> {
  const CreatedSuccess({
    required super.data,
    required super.message,
    super.statusCode = 201,
  });
}

class UpdatedSuccess<T> extends NetworkSuccess<T> {
  const UpdatedSuccess({
    required super.data,
    required super.message,
    super.statusCode = 200,
  });
}

class DeletedSuccess extends NetworkSuccess<void> {
  const DeletedSuccess({required super.message, super.statusCode = 204})
    : super(data: null);
}

class RetrievedSuccess<T> extends NetworkSuccess<T> {
  const RetrievedSuccess({
    required super.data,
    required super.message,
    super.statusCode = 200,
  });
}
