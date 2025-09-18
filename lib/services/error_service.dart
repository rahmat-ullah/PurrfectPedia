import 'package:flutter/foundation.dart';
import '../utils/result.dart';

/// A service for handling and reporting errors throughout the application
class ErrorService {
  static final ErrorService _instance = ErrorService._internal();
  factory ErrorService() => _instance;
  ErrorService._internal();

  final List<AppError> _errorHistory = [];
  final List<void Function(AppError)> _errorListeners = [];

  /// Get the error history
  List<AppError> get errorHistory => List.unmodifiable(_errorHistory);

  /// Add an error listener
  void addErrorListener(void Function(AppError) listener) {
    _errorListeners.add(listener);
  }

  /// Remove an error listener
  void removeErrorListener(void Function(AppError) listener) {
    _errorListeners.remove(listener);
  }

  /// Report an error
  void reportError(AppError error) {
    _errorHistory.add(error);
    
    // Keep only the last 100 errors to prevent memory issues
    if (_errorHistory.length > 100) {
      _errorHistory.removeAt(0);
    }

    // Notify all listeners
    for (final listener in _errorListeners) {
      try {
        listener(error);
      } catch (e) {
        // Prevent listener errors from crashing the app
        debugPrint('Error in error listener: $e');
      }
    }

    // Log error for debugging
    _logError(error);
  }

  /// Clear error history
  void clearErrorHistory() {
    _errorHistory.clear();
  }

  /// Get errors by type
  List<T> getErrorsByType<T extends AppError>() {
    return _errorHistory.whereType<T>().toList();
  }

  /// Get recent errors (last N errors)
  List<AppError> getRecentErrors([int count = 10]) {
    final startIndex = _errorHistory.length > count 
        ? _errorHistory.length - count 
        : 0;
    return _errorHistory.sublist(startIndex);
  }

  /// Check if there are any network errors in recent history
  bool hasRecentNetworkErrors([int minutes = 5]) {
    final cutoff = DateTime.now().subtract(Duration(minutes: minutes));
    return _errorHistory
        .whereType<NetworkError>()
        .any((error) => _getErrorTimestamp(error).isAfter(cutoff));
  }

  /// Check if there are any API errors in recent history
  bool hasRecentApiErrors([int minutes = 5]) {
    final cutoff = DateTime.now().subtract(Duration(minutes: minutes));
    return _errorHistory
        .whereType<ApiError>()
        .any((error) => _getErrorTimestamp(error).isAfter(cutoff));
  }

  /// Get user-friendly error message
  String getUserFriendlyMessage(AppError error) {
    if (error is NetworkError) {
      switch (error.code) {
        case 'TIMEOUT':
          return 'The request timed out. Please check your internet connection and try again.';
        case 'NO_CONNECTION':
          return 'No internet connection. Please check your network settings.';
        default:
          return 'Network error occurred. Please try again.';
      }
    } else if (error is ApiError) {
      switch (error.statusCode) {
        case 400:
          return 'Invalid request. Please try again.';
        case 401:
          return 'Authentication required. Please log in again.';
        case 403:
          return 'Access denied. You don\'t have permission for this action.';
        case 404:
          return 'The requested resource was not found.';
        case 429:
          return 'Too many requests. Please wait a moment and try again.';
        case 500:
          return 'Server error. Please try again later.';
        case 503:
          return 'Service temporarily unavailable. Please try again later.';
        default:
          return 'Server error occurred. Please try again.';
      }
    } else if (error is CacheError) {
      return 'Storage error occurred. Some features may not work properly.';
    } else if (error is ValidationError) {
      return error.message; // Validation errors are usually user-friendly
    }

    return 'An unexpected error occurred. Please try again.';
  }

  /// Get suggested actions for an error
  List<String> getSuggestedActions(AppError error) {
    if (error is NetworkError) {
      return [
        'Check your internet connection',
        'Try again in a few moments',
        'Switch to a different network if available',
      ];
    } else if (error is ApiError) {
      switch (error.statusCode) {
        case 401:
          return ['Log out and log back in', 'Check your credentials'];
        case 429:
          return ['Wait a few minutes before trying again'];
        case 500:
        case 503:
          return ['Try again later', 'Contact support if the problem persists'];
        default:
          return ['Try again', 'Contact support if the problem persists'];
      }
    } else if (error is CacheError) {
      return [
        'Clear app cache',
        'Restart the app',
        'Free up storage space',
      ];
    }

    return ['Try again', 'Restart the app if the problem persists'];
  }

  /// Check if an error is recoverable
  bool isRecoverable(AppError error) {
    if (error is NetworkError) {
      return true; // Network errors are usually recoverable
    } else if (error is ApiError) {
      // Some API errors are not recoverable
      return error.statusCode != 401 && error.statusCode != 403;
    } else if (error is CacheError) {
      return true; // Cache errors are usually recoverable
    } else if (error is ValidationError) {
      return true; // Validation errors can be fixed by user input
    }

    return true; // Default to recoverable
  }

  /// Create a Result.error with automatic error reporting
  Result<T> createErrorResult<T>(AppError error) {
    reportError(error);
    return Result.error(error);
  }

  /// Wrap a function call with error handling
  Future<Result<T>> wrapWithErrorHandling<T>(
    Future<T> Function() operation,
    String context,
  ) async {
    try {
      final result = await operation();
      return Result.success(result);
    } catch (e, stackTrace) {
      final error = _createAppErrorFromException(e, context, stackTrace);
      return createErrorResult(error);
    }
  }

  /// Log error for debugging
  void _logError(AppError error) {
    if (kDebugMode) {
      debugPrint('=== ERROR REPORTED ===');
      debugPrint('Type: ${error.runtimeType}');
      debugPrint('Message: ${error.message}');
      debugPrint('Code: ${error.code}');
      if (error.originalError != null) {
        debugPrint('Original: ${error.originalError}');
      }
      if (error.stackTrace != null) {
        debugPrint('StackTrace: ${error.stackTrace}');
      }
      debugPrint('=====================');
    }
  }

  /// Get timestamp for an error (approximated)
  DateTime _getErrorTimestamp(AppError error) {
    // Since we don't store timestamps, we approximate based on position in history
    final index = _errorHistory.indexOf(error);
    if (index == -1) return DateTime.now();
    
    // Assume errors are added roughly every few seconds
    final secondsAgo = (_errorHistory.length - index - 1) * 3;
    return DateTime.now().subtract(Duration(seconds: secondsAgo));
  }

  /// Create AppError from generic exception
  AppError _createAppErrorFromException(
    Object exception,
    String context,
    StackTrace stackTrace,
  ) {
    if (exception is AppError) {
      return exception;
    }

    return AppError(
      message: '$context: $exception',
      originalError: exception,
      stackTrace: stackTrace,
    );
  }
}

/// Extension to make error reporting easier
extension ResultErrorReporting<T> on Result<T> {
  /// Report error if this is an error result
  Result<T> reportError() {
    if (isError) {
      ErrorService().reportError(error!);
    }
    return this;
  }
}

/// Mixin for widgets that need error handling
mixin ErrorHandlingMixin {
  final ErrorService _errorService = ErrorService();

  /// Report an error
  void reportError(AppError error) {
    _errorService.reportError(error);
  }

  /// Get user-friendly error message
  String getUserFriendlyMessage(AppError error) {
    return _errorService.getUserFriendlyMessage(error);
  }

  /// Get suggested actions for an error
  List<String> getSuggestedActions(AppError error) {
    return _errorService.getSuggestedActions(error);
  }

  /// Check if an error is recoverable
  bool isRecoverable(AppError error) {
    return _errorService.isRecoverable(error);
  }
}
