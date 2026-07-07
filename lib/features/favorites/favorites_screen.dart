import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/widgets/dua_list_view.dart';
import '../../data/models/dua.dart';
import '../../shared/providers.dart';

/// Lists the user's favorited duas. Updates live as favorites change.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    final List<Dua> duas = ref.watch(favoriteDuasProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.t('favorites'))),
      body: DuaListView(
        duas: duas,
        emptyIcon: Icons.favorite_border_rounded,
        emptyMessage: l.t('favorites_empty'),
      ),
    );
  }
}
