import 'package:flutter/material.dart';
import '../utils/result.dart';

/// A widget that provides error boundary functionality for handling errors gracefully
class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({
    super.key,
    required this.child,
    this.onError,
    this.fallback,
  });

  final Widget child;
  final void Function(Object error, StackTrace stackTrace)? onError;
  final Widget Function(Object error, StackTrace stackTrace)? fallback;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.fallback?.call(_error!, _stackTrace!) ??
          ErrorDisplay(
            error: _error!,
            onRetry: () {
              setState(() {
                _error = null;
                _stackTrace = null;
              });
            },
          );
    }

    return widget.child;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ErrorWidget.builder = (FlutterErrorDetails details) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _error = details.exception;
            _stackTrace = details.stack;
          });
          widget.onError?.call(details.exception, details.stack ?? StackTrace.current);
        }
      });
      return const SizedBox.shrink();
    };
  }
}

/// A widget that displays error information with retry functionality
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    required this.error,
    this.onRetry,
    this.title,
    this.showDetails = false,
  });

  final Object error;
  final VoidCallback? onRetry;
  final String? title;
  final bool showDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appError = error is AppError ? error as AppError : null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getErrorIcon(appError),
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              title ?? _getErrorTitle(appError),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getErrorMessage(appError),
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (showDetails && appError?.code != null) ...[
              const SizedBox(height: 8),
              Text(
                'Error Code: ${appError!.code}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getErrorIcon(AppError? appError) {
    if (appError is NetworkError) {
      return Icons.wifi_off;
    } else if (appError is ApiError) {
      return Icons.cloud_off;
    } else if (appError is CacheError) {
      return Icons.storage;
    } else if (appError is ValidationError) {
      return Icons.warning;
    }
    return Icons.error_outline;
  }

  String _getErrorTitle(AppError? appError) {
    if (appError is NetworkError) {
      return 'Connection Problem';
    } else if (appError is ApiError) {
      return 'Server Error';
    } else if (appError is CacheError) {
      return 'Storage Error';
    } else if (appError is ValidationError) {
      return 'Invalid Data';
    }
    return 'Something Went Wrong';
  }

  String _getErrorMessage(AppError? appError) {
    if (appError != null) {
      return appError.message;
    }
    return error.toString();
  }
}

/// A widget that handles Result<T> states with loading, success, and error handling
class ResultBuilder<T> extends StatelessWidget {
  const ResultBuilder({
    super.key,
    required this.result,
    required this.onSuccess,
    this.onLoading,
    this.onError,
    this.showErrorDetails = false,
  });

  final Result<T> result;
  final Widget Function(T data) onSuccess;
  final Widget Function()? onLoading;
  final Widget Function(AppError error)? onError;
  final bool showErrorDetails;

  @override
  Widget build(BuildContext context) {
    return result.when(
      success: onSuccess,
      loading: () => onLoading?.call() ?? const Center(
        child: CircularProgressIndicator(),
      ),
      onError: (error) => onError?.call(error) ?? ErrorDisplay(
        error: error,
        showDetails: showErrorDetails,
      ),
    );
  }
}

/// A widget that provides retry functionality for async operations
class RetryWrapper extends StatefulWidget {
  const RetryWrapper({
    super.key,
    required this.onRetry,
    required this.builder,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  final Future<void> Function() onRetry;
  final Widget Function(VoidCallback retry, int retryCount) builder;
  final int maxRetries;
  final Duration retryDelay;

  @override
  State<RetryWrapper> createState() => _RetryWrapperState();
}

class _RetryWrapperState extends State<RetryWrapper> {
  int _retryCount = 0;
  bool _isRetrying = false;

  @override
  Widget build(BuildContext context) {
    return widget.builder(_retry, _retryCount);
  }

  void _retry() async {
    if (_isRetrying || _retryCount >= widget.maxRetries) return;

    setState(() {
      _isRetrying = true;
      _retryCount++;
    });

    try {
      await Future.delayed(widget.retryDelay);
      await widget.onRetry();
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }
}

/// A mixin that provides error handling capabilities to StatefulWidgets
mixin ErrorHandlerMixin<T extends StatefulWidget> on State<T> {
  String? _errorMessage;
  bool _hasError = false;

  String? get errorMessage => _errorMessage;
  bool get hasError => _hasError;

  void handleError(Object error, [StackTrace? stackTrace]) {
    setState(() {
      _hasError = true;
      if (error is AppError) {
        _errorMessage = error.message;
      } else {
        _errorMessage = error.toString();
      }
    });

    // Log error for debugging
    debugPrint('Error: $error');
    if (stackTrace != null) {
      debugPrint('StackTrace: $stackTrace');
    }
  }

  void clearError() {
    setState(() {
      _hasError = false;
      _errorMessage = null;
    });
  }

  Widget buildErrorWidget({VoidCallback? onRetry}) {
    if (!_hasError) return const SizedBox.shrink();

    return ErrorDisplay(
      error: AppError(message: _errorMessage ?? 'Unknown error'),
      onRetry: () {
        clearError();
        onRetry?.call();
      },
    );
  }
}
