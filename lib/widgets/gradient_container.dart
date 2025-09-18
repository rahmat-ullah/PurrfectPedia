import 'package:flutter/material.dart';

/// A custom gradient container widget that implements the beautiful
/// purple to blue gradient specified in the design system.
/// 
/// Usage:
/// ```dart
/// GradientContainer(
///   child: Text('Hello World'),
///   height: 200,
/// )
/// ```
class GradientContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final AlignmentGeometry? alignment;

  const GradientContainer({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.borderRadius,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        // Gradient Base: linear-gradient(180deg, #5B21B6 0%, #1E3A8A 100%)
        // Rich purple → deep blue for headers & hero sections
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF5B21B6), // Rich purple at top
            Color(0xFF1E3A8A), // Deep blue at bottom
          ],
          stops: [0.0, 1.0],
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        // Optional: Add subtle shadow for depth
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// A gradient app bar that uses the custom gradient
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double elevation;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF5B21B6), // Rich purple at top
            Color(0xFF1E3A8A), // Deep blue at bottom
          ],
        ),
      ),
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFF9FAFB), // Primary Text - Pure white
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: actions,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: Colors.transparent,
        elevation: elevation,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(0xFFE5E7EB), // Icons (Default) - Neutral light gray
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// A gradient button that uses the primary accent color with gradient effect
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.padding,
    this.borderRadius,
    this.width,
    this.height,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 48,
      decoration: BoxDecoration(
        gradient: onPressed != null
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFA855F7), // Primary Accent - Vibrant violet
                  Color(0xFF6366F1), // Secondary Accent - Soft indigo
                ],
              )
            : null,
        color: onPressed == null ? const Color(0xFF9CA3AF) : null, // Disabled color
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: const Color(0xFFA855F7).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            alignment: Alignment.center,
            child: Text(
              text,
              style: textStyle ??
                  const TextStyle(
                    color: Color(0xFFF9FAFB), // Primary Text - Pure white
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A card with the custom dark theme styling
class ThemedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final BorderRadius? borderRadius;

  const ThemedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: const Color(0xFF1F123D), // Cards/Containers - Darker violet-tinted
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5), // Card shadows
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
