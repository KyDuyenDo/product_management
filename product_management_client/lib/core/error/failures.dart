import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = 'Unknown Failure']);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class ValidationFailure extends Failure {
  @override
  final String message;

  const ValidationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
