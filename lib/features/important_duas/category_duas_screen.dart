import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/widgets/dua_list_view.dart';
import '../../data/models/dua.dart';
import '../../data/models/dua_category.dart';
import '../../shared/providers.dart';

/// Lists the duas within a single "Important Duas" category.
class CategoryDuasScreen extends ConsumerWidget {
  const CategoryDuasScreen({required this.category, super.key});

  /// The category being displayed.
  final DuaCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    final List<Dua> duas = ref.watch(duasByCategoryProvider(category.id));

    return Scaffold(
      appBar: AppBar(title: Text(category.title(isUrdu: l.isUrdu))),
      body: DuaListView(
        duas: duas,
        emptyIcon: Icons.menu_book_rounded,
        emptyMessage: l.t('category_empty'),
      ),
    );
  }
}
