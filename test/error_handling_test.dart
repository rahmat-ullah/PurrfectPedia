import 'package:flutter_test/flutter_test.dart';
import 'package:purrfect_pedia/utils/result.dart';
import 'package:purrfect_pedia/services/error_service.dart';

void main() {
  group('Result Type Tests', () {
    test('Success result works correctly', () {
      const data = 'test data';
      const result = Result.success(data);

      expect(result.isSuccess, isTrue);
      expect(result.isError, isFalse);
      expect(result.isLoading, isFalse);
      expect(result.data, equals(data));
      expect(result.error, isNull);
    });

    test('Error result works correctly', () {
      const error = AppError(message: 'Test error');
      const result = Result<String>.error(error);

      expect(result.isSuccess, isFalse);
      expect(result.isError, isTrue);
      expect(result.isLoading, isFalse);
      expect(result.data, isNull);
      expect(result.error, equals(error));
    });

    test('Loading result works correctly', () {
      const result = Result<String>.loading();

      expect(result.isSuccess, isFalse);
      expect(result.isError, isFalse);
      expect(result.isLoading, isTrue);
      expect(result.data, isNull);
      expect(result.error, isNull);
    });

    test('Result.when works correctly', () {
      const successResult = Result.success('success');
      const errorResult = Result<String>.error(AppError(message: 'error'));
      const loadingResult = Result<String>.loading();

      final successOutput = successResult.when(
        success: (data) => 'Success: $data',
        onError: (error) => 'Error: ${error.message}',
        loading: () => 'Loading',
      );

      final errorOutput = errorResult.when(
        success: (data) => 'Success: $data',
        onError: (error) => 'Error: ${error.message}',
        loading: () => 'Loading',
      );

      final loadingOutput = loadingResult.when(
        success: (data) => 'Success: $data',
        onError: (error) => 'Error: ${error.message}',
        loading: () => 'Loading',
      );

      expect(successOutput, equals('Success: success'));
      expect(errorOutput, equals('Error: error'));
      expect(loadingOutput, equals('Loading'));
    });

    test('Result.map works correctly', () {
      const result = Result.success(5);
      final mappedResult = result.map((data) => data * 2);

      expect(mappedResult.isSuccess, isTrue);
      expect(mappedResult.data, equals(10));
    });
  });

  group('AppError Types Tests', () {
    test('NetworkError has correct properties', () {
      const error = NetworkError(
        message: 'Network error',
        code: 'TIMEOUT',
      );

      expect(error.message, equals('Network error'));
      expect(error.code, equals('TIMEOUT'));
      expect(error is NetworkError, isTrue);
      expect(error is AppError, isTrue);
    });

    test('ApiError has correct properties', () {
      const error = ApiError(
        message: 'API error',
        code: 'SERVER_ERROR',
        statusCode: 500,
      );

      expect(error.message, equals('API error'));
      expect(error.code, equals('SERVER_ERROR'));
      expect(error.statusCode, equals(500));
      expect(error is ApiError, isTrue);
      expect(error is AppError, isTrue);
    });

    test('CacheError has correct properties', () {
      const error = CacheError(
        message: 'Cache error',
        code: 'STORAGE_FULL',
      );

      expect(error.message, equals('Cache error'));
      expect(error.code, equals('STORAGE_FULL'));
      expect(error is CacheError, isTrue);
      expect(error is AppError, isTrue);
    });

    test('ValidationError has correct properties', () {
      const error = ValidationError(
        message: 'Validation error',
        code: 'INVALID_INPUT',
      );

      expect(error.message, equals('Validation error'));
      expect(error.code, equals('INVALID_INPUT'));
      expect(error is ValidationError, isTrue);
      expect(error is AppError, isTrue);
    });
  });

  group('ErrorService Tests', () {
    late ErrorService errorService;

    setUp(() {
      errorService = ErrorService();
      errorService.clearErrorHistory();
    });

    test('Reports and stores errors', () {
      const error = AppError(message: 'Test error');
      
      errorService.reportError(error);
      
      expect(errorService.errorHistory.length, equals(1));
      expect(errorService.errorHistory.first, equals(error));
    });

    test('Limits error history size', () {
      // Add more than 100 errors
      for (int i = 0; i < 105; i++) {
        errorService.reportError(AppError(message: 'Error $i'));
      }
      
      expect(errorService.errorHistory.length, equals(100));
      // Should keep the most recent errors
      expect(errorService.errorHistory.last.message, equals('Error 104'));
    });

    test('Gets errors by type', () {
      const networkError = NetworkError(message: 'Network error');
      const apiError = ApiError(message: 'API error');
      const cacheError = CacheError(message: 'Cache error');
      
      errorService.reportError(networkError);
      errorService.reportError(apiError);
      errorService.reportError(cacheError);
      
      final networkErrors = errorService.getErrorsByType<NetworkError>();
      final apiErrors = errorService.getErrorsByType<ApiError>();
      
      expect(networkErrors.length, equals(1));
      expect(apiErrors.length, equals(1));
      expect(networkErrors.first, equals(networkError));
      expect(apiErrors.first, equals(apiError));
    });

    test('Gets recent errors', () {
      for (int i = 0; i < 15; i++) {
        errorService.reportError(AppError(message: 'Error $i'));
      }
      
      final recentErrors = errorService.getRecentErrors(5);
      
      expect(recentErrors.length, equals(5));
      expect(recentErrors.last.message, equals('Error 14'));
    });

    test('Provides user-friendly messages for network errors', () {
      const timeoutError = NetworkError(message: 'Timeout', code: 'TIMEOUT');
      const noConnectionError = NetworkError(message: 'No connection', code: 'NO_CONNECTION');
      
      expect(
        errorService.getUserFriendlyMessage(timeoutError),
        contains('timed out'),
      );
      expect(
        errorService.getUserFriendlyMessage(noConnectionError),
        contains('No internet connection'),
      );
    });

    test('Provides user-friendly messages for API errors', () {
      const notFoundError = ApiError(message: 'Not found', statusCode: 404);
      const serverError = ApiError(message: 'Server error', statusCode: 500);
      
      expect(
        errorService.getUserFriendlyMessage(notFoundError),
        contains('not found'),
      );
      expect(
        errorService.getUserFriendlyMessage(serverError),
        contains('Server error'),
      );
    });

    test('Determines if errors are recoverable', () {
      const networkError = NetworkError(message: 'Network error');
      const unauthorizedError = ApiError(message: 'Unauthorized', statusCode: 401);
      const serverError = ApiError(message: 'Server error', statusCode: 500);
      
      expect(errorService.isRecoverable(networkError), isTrue);
      expect(errorService.isRecoverable(unauthorizedError), isFalse);
      expect(errorService.isRecoverable(serverError), isTrue);
    });

    test('Provides suggested actions', () {
      const networkError = NetworkError(message: 'Network error');
      final actions = errorService.getSuggestedActions(networkError);

      expect(actions.isNotEmpty, isTrue);
      expect(actions.any((action) => action.contains('internet')), isTrue);
    });

    test('Creates error results with automatic reporting', () {
      const error = AppError(message: 'Test error');
      final result = errorService.createErrorResult<String>(error);
      
      expect(result.isError, isTrue);
      expect(result.error, equals(error));
      expect(errorService.errorHistory.contains(error), isTrue);
    });

    test('Wraps operations with error handling', () async {
      final result = await errorService.wrapWithErrorHandling<String>(
        () async => throw Exception('Test exception'),
        'Test operation',
      );
      
      expect(result.isError, isTrue);
      expect(result.error?.message, contains('Test operation'));
      expect(errorService.errorHistory.isNotEmpty, isTrue);
    });
  });

  group('Result Extension Tests', () {
    test('reportError extension works', () {
      final errorService = ErrorService();
      errorService.clearErrorHistory();
      
      const error = AppError(message: 'Test error');
      const result = Result<String>.error(error);
      
      result.reportError();
      
      expect(errorService.errorHistory.contains(error), isTrue);
    });

    test('reportError extension does nothing for success results', () {
      final errorService = ErrorService();
      errorService.clearErrorHistory();
      
      const result = Result.success('test');
      
      result.reportError();
      
      expect(errorService.errorHistory.isEmpty, isTrue);
    });
  });
}
