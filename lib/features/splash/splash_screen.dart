import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../shared/providers.dart';
import '../home/home_screen.dart';

/// The first screen shown while the bundled dua content is parsed.
///
/// Navigates to [HomeScreen] once [contentLoaderProvider] completes. Kept
/// minimal — the app starts fast and the load is small.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    // Navigate once content finishes loading.
    ref.listen(contentLoaderProvider, (_, AsyncValue<void> next) {
      if (next is AsyncData) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
        );
      }
    });

    final AsyncValue<void> loader = ref.watch(contentLoaderProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.mosque_rounded,
                size: 72, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text(l.t('app_name'), style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              l.t('app_tagline'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            if (loader is AsyncError)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  loader.error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              )
            else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
