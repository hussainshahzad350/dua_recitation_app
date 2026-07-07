import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// A simple scrollable text screen used for About, Sources and Privacy Policy.
class InfoScreen extends StatelessWidget {
  const InfoScreen({required this.title, required this.body, super.key});

  /// The (already localized) screen title.
  final String title;

  /// The (already localized) body text.
  final String body;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.screenPadding),
        child: Text(
          body,
          style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
        ),
      ),
    );
  }
}
