import 'package:flutter/material.dart';

/// A centered, friendly placeholder shown when a list has no content
/// (empty favorites, empty category, no search results).
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.message,
    super.key,
  });

  /// Icon illustrating the empty state.
  final IconData icon;

  /// The (already localized) message to display.
  final String message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
