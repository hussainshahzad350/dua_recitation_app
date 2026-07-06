import 'package:flutter/material.dart';

import '../../data/models/dua.dart';
import '../constants/app_constants.dart';
import 'dua_card.dart';
import 'empty_state.dart';

/// A scrollable list of [DuaCard]s, or an [EmptyState] when [duas] is empty.
///
/// Shared by the prayer, category, favorites and search screens so their
/// layout stays consistent.
class DuaListView extends StatelessWidget {
  const DuaListView({
    required this.duas,
    required this.emptyIcon,
    required this.emptyMessage,
    super.key,
  });

  /// The duas to render.
  final List<Dua> duas;

  /// Icon for the empty state.
  final IconData emptyIcon;

  /// Localized message for the empty state.
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (duas.isEmpty) {
      return EmptyState(icon: emptyIcon, message: emptyMessage);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.screenPadding),
      itemCount: duas.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppConstants.cardSpacing),
      itemBuilder: (BuildContext context, int index) => DuaCard(duas[index]),
    );
  }
}
