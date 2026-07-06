import 'package:flutter/material.dart';

/// A small, muted section title used to group content on a screen.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key});

  /// The (already localized) header text.
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
