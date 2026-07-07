import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../data/models/dua.dart';
import '../../data/models/dua_reference.dart';

/// Shows the [Dua]'s scholarly reference in a modal bottom sheet.
Future<void> showReferenceSheet(BuildContext context, Dua dua) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext context) => _ReferenceSheet(dua: dua),
  );
}

class _ReferenceSheet extends StatelessWidget {
  const _ReferenceSheet({required this.dua});

  final Dua dua;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final DuaReference ref = dua.reference;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l.t('reference_title'),
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _Row(label: l.t('source_book'), value: ref.sourceBook),
              _Row(
                  label: l.t('hadith_collection'),
                  value: ref.hadithCollection),
              _Row(label: l.t('hadith_number'), value: ref.hadithNumber),
              _Row(label: l.t('authenticity'), value: ref.authenticity),
              const SizedBox(height: 16),
              Text(
                l.t('full_hadith'),
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                ref.fullHadith ?? l.t('full_hadith_unavailable'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: ref.fullHadith == null
                      ? theme.colorScheme.onSurfaceVariant
                      : null,
                  fontStyle:
                      ref.fullHadith == null ? FontStyle.italic : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
