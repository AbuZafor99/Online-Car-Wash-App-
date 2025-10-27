import 'package:dartz/dartz.dart';

import 'models/network_failure.dart';
import 'models/network_success.dart';

typedef NetworkResult<T> = Future<Either<NetworkFailure, NetworkSuccess<T>>>;
