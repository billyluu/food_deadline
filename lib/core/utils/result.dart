import 'package:food_deadline/core/errors/app_exception.dart';

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  
  const Success(this.data);
  
  @override
  String toString() => 'Success($data)';
}

class Failure<T> extends Result<T> {
  final AppException exception;
  
  const Failure(this.exception);
  
  @override
  String toString() => 'Failure($exception)';
}

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  
  T? get data => switch (this) {
    Success<T>(data: final data) => data,
    Failure<T>() => null,
  };
  
  AppException? get exception => switch (this) {
    Success<T>() => null,
    Failure<T>(exception: final exception) => exception,
  };
  
  Result<R> map<R>(R Function(T data) transform) => switch (this) {
    Success<T>(data: final data) => Success(transform(data)),
    Failure<T>(exception: final exception) => Failure(exception),
  };
  
  Result<R> flatMap<R>(Result<R> Function(T data) transform) => switch (this) {
    Success<T>(data: final data) => transform(data),
    Failure<T>(exception: final exception) => Failure(exception),
  };
  
  T getOrElse(T defaultValue) => switch (this) {
    Success<T>(data: final data) => data,
    Failure<T>() => defaultValue,
  };
}