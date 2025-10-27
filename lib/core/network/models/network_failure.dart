// lib/core/network/models/network_failure.dart

import 'package:equatable/equatable.dart';

class NetworkFailure extends Equatable {
  final String message;
  final int statusCode;

  const NetworkFailure({required this.message, required this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends NetworkFailure {
  const ServerFailure({required super.message, required super.statusCode});
}

class ConnectionFailure extends NetworkFailure {
  const ConnectionFailure({required super.message, super.statusCode = 0});
}

class TimeoutFailure extends NetworkFailure {
  const TimeoutFailure({required super.message, super.statusCode = 408});
}

class UnauthorizedFailure extends NetworkFailure {
  const UnauthorizedFailure({required super.message, super.statusCode = 401});
}

class ValidationFailure extends NetworkFailure {
  final List<String> errors;

  const ValidationFailure({
    required super.message,
    required this.errors,
    super.statusCode = 400,
  });

  @override
  List<Object?> get props => [message, statusCode, errors];
}

class NoInternetFailure extends NetworkFailure {
  const NoInternetFailure()
    : super(message: 'No internet connection available', statusCode: 0);
}

class UnknownFailure extends NetworkFailure {
  const UnknownFailure({required super.message, super.statusCode = 0});
}
