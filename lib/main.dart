import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/storage_service.dart';
import 'shared/providers.dart';

/// Application entry point.
///
/// Initializes the only piece of state that must exist before the first frame
/// (the [StorageService] backing favorites/settings), then hands off to the
/// widget tree. All content is loaded lazily on the splash screen.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final StorageService storage = await StorageService.create();

  runApp(
    ProviderScope(
      overrides: <Override>[
        storageServiceProvider.overrideWithValue(storage),
      ],
      child: const DuaCompanionApp(),
    ),
  );
}
