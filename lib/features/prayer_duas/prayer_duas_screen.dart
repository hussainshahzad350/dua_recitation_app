import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/widgets/dua_list_view.dart';
import '../../data/models/dua.dart';
import '../../shared/providers.dart';

/// Lists the duas recited after a specific prayer.
class PrayerDuasScreen extends ConsumerWidget {
  const PrayerDuasScreen({required this.prayerId, super.key});

  /// The prayer whose duas are shown (e.g. `fajr`).
  final String prayerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    final List<Dua> duas = ref.watch(duasByPrayerProvider(prayerId));

    return Scaffold(
      appBar: AppBar(title: Text(l.prayerDuasTitle(prayerId))),
      body: DuaListView(
        duas: duas,
        emptyIcon: Icons.menu_book_rounded,
        emptyMessage: l.t('category_empty'),
      ),
    );
  }
}
