import 'package:flutter/material.dart';

/// A customizable loading indicator widget
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.size = 24.0,
    this.strokeWidth = 2.0,
    this.color,
    this.message,
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? theme.colorScheme.primary,
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// A full-screen loading overlay
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    this.message,
    this.backgroundColor,
  });

  final String? message;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      color: backgroundColor ?? theme.colorScheme.surface.withOpacity(0.8),
      child: Center(
        child: LoadingIndicator(
          size: 48.0,
          message: message,
        ),
      ),
    );
  }
}

/// A skeleton loading widget for list items
class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    super.key,
    this.width,
    this.height = 16.0,
    this.borderRadius = 4.0,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(_animation.value * 0.1),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

/// A skeleton loading widget for breed cards
class BreedCardSkeleton extends StatelessWidget {
  const BreedCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image skeleton
            const SkeletonLoader(
              width: double.infinity,
              height: 200,
              borderRadius: 8.0,
            ),
            const SizedBox(height: 12),
            // Title skeleton
            const SkeletonLoader(
              width: 150,
              height: 20,
            ),
            const SizedBox(height: 8),
            // Subtitle skeleton
            const SkeletonLoader(
              width: 100,
              height: 16,
            ),
            const SizedBox(height: 8),
            // Description skeleton
            const SkeletonLoader(
              width: double.infinity,
              height: 14,
            ),
            const SizedBox(height: 4),
            const SkeletonLoader(
              width: 200,
              height: 14,
            ),
          ],
        ),
      ),
    );
  }
}

/// A skeleton loading widget for fact cards
class FactCardSkeleton extends StatelessWidget {
  const FactCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category skeleton
            const SkeletonLoader(
              width: 80,
              height: 16,
            ),
            const SizedBox(height: 12),
            // Fact text skeleton
            const SkeletonLoader(
              width: double.infinity,
              height: 16,
            ),
            const SizedBox(height: 4),
            const SkeletonLoader(
              width: double.infinity,
              height: 16,
            ),
            const SizedBox(height: 4),
            const SkeletonLoader(
              width: 150,
              height: 16,
            ),
            const SizedBox(height: 12),
            // Date skeleton
            const SkeletonLoader(
              width: 100,
              height: 14,
            ),
          ],
        ),
      ),
    );
  }
}

/// A loading state widget that shows different content based on loading state
class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.overlay = false,
  });

  final bool isLoading;
  final Widget child;
  final Widget? loadingWidget;
  final bool overlay;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    final loading = loadingWidget ?? const LoadingIndicator();

    if (overlay) {
      return Stack(
        children: [
          child,
          Positioned.fill(
            child: LoadingOverlay(
              message: 'Loading...',
            ),
          ),
        ],
      );
    }

    return loading;
  }
}

/// A widget that shows a loading indicator while a future is being resolved
class FutureLoadingBuilder<T> extends StatelessWidget {
  const FutureLoadingBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.loadingWidget,
    this.errorWidget,
  });

  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final Widget? loadingWidget;
  final Widget Function(BuildContext context, Object error)? errorWidget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ?? const LoadingIndicator();
        }

        if (snapshot.hasError) {
          return errorWidget?.call(context, snapshot.error!) ??
              ErrorDisplay(error: snapshot.error!);
        }

        if (snapshot.hasData) {
          return builder(context, snapshot.data as T);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

/// Import the ErrorDisplay from error_boundary.dart
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    required this.error,
    this.onRetry,
  });

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
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
}
