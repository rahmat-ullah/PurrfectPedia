/// A Result type for handling success and error states
sealed class Result<T> {
  const Result();
  
  /// Creates a successful result with data
  const factory Result.success(T data) = Success<T>;
  
  /// Creates an error result with an error
  const factory Result.error(AppError error) = Error<T>;
  
  /// Creates a loading result
  const factory Result.loading() = Loading<T>;
  
  /// Returns true if this is a success result
  bool get isSuccess => this is Success<T>;
  
  /// Returns true if this is an error result
  bool get isError => this is Error<T>;
  
  /// Returns true if this is a loading result
  bool get isLoading => this is Loading<T>;
  
  /// Returns the data if this is a success result, null otherwise
  T? get data => switch (this) {
    Success<T>(data: final data) => data,
    _ => null,
  };
  
  /// Returns the error if this is an error result, null otherwise
  AppError? get error => switch (this) {
    Error<T>(error: final error) => error,
    _ => null,
  };
  
  /// Maps the data if this is a success result
  Result<R> map<R>(R Function(T data) mapper) {
    return switch (this) {
      Success<T>(data: final data) => Result.success(mapper(data)),
      Error<T>(error: final error) => Result.error(error),
      Loading<T>() => Result.loading(),
    };
  }
  
  /// Executes different functions based on the result type
  R when<R>({
    required R Function(T data) success,
    required R Function(AppError error) onError,
    required R Function() loading,
  }) {
    return switch (this) {
      Success<T>(data: final data) => success(data),
      Error<T>(error: final error) => onError(error),
      Loading<T>() => loading(),
    };
  }
}

/// Success result containing data
final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && runtimeType == other.runtimeType && data == other.data;
  
  @override
  int get hashCode => data.hashCode;
  
  @override
  String toString() => 'Success(data: $data)';
}

/// Error result containing an error
final class Error<T> extends Result<T> {
  const Error(this.error);
  final AppError error;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Error<T> && runtimeType == other.runtimeType && error == other.error;
  
  @override
  int get hashCode => error.hashCode;
  
  @override
  String toString() => 'Error(error: $error)';
}

/// Loading result indicating an operation is in progress
final class Loading<T> extends Result<T> {
  const Loading();
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Loading<T> && runtimeType == other.runtimeType;
  
  @override
  int get hashCode => runtimeType.hashCode;
  
  @override
  String toString() => 'Loading()';
}

/// Application error types
class AppError {
  const AppError({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });
  
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;
  
  @override
  int get hashCode => message.hashCode ^ code.hashCode;
  
  @override
  String toString() => 'AppError(message: $message, code: $code)';
}

/// Network-related errors
class NetworkError extends AppError {
  const NetworkError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// API-related errors
class ApiError extends AppError {
  const ApiError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.statusCode,
  });
  
  final int? statusCode;
}

/// Cache-related errors
class CacheError extends AppError {
  const CacheError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Validation errors
class ValidationError extends AppError {
  const ValidationError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}
