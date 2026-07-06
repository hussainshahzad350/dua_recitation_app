import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/app_settings.dart';
import '../../data/models/dua.dart';
import '../../features/reference/reference_sheet.dart';
import '../../shared/providers.dart';
import '../constants/app_constants.dart';
import '../localization/app_localizations.dart';

/// The primary content widget: renders a single [Dua] with its Arabic text,
/// optional transliteration, both translations, and the action row
/// (play/stop, reference, favorite, share).
///
/// It is intentionally reusable — the same card is shown on the prayer,
/// category, favorites and search screens.
class DuaCard extends ConsumerWidget {
  const DuaCard(this.dua, {super.key});

  /// The dua to display.
  final Dua dua;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AppSettings settings = ref.watch(settingsProvider);
    final bool isFavorite =
        ref.watch(favoritesProvider).contains(dua.id);
    final bool isPlaying =
        ref.watch(audioControllerProvider) == dua.id;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (dua.repeat != null)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: _RepeatBadge(label: l.repeat(dua.repeat!)),
              ),
            // Arabic — always RTL, larger, prioritized for readability.
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                dua.arabic,
                textAlign: TextAlign.right,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: settings.arabicFontSize,
                  height: 1.9,
                ),
              ),
            ),
            if (settings.showTransliteration && dua.transliteration != null) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                dua.transliteration!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: settings.translationFontSize,
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Both translations, primary language first.
            ..._translations(context, settings),
            const Divider(height: 28),
            _ActionRow(
              dua: dua,
              isFavorite: isFavorite,
              isPlaying: isPlaying,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _translations(BuildContext context, AppSettings settings) {
    final ThemeData theme = Theme.of(context);
    Widget line(String text, TextDirection dir) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Directionality(
            textDirection: dir,
            child: Text(
              text,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontSize: settings.translationFontSize),
            ),
          ),
        );

    final Widget urdu = line(dua.translationUrdu, TextDirection.rtl);
    final Widget english = line(dua.translationEnglish, TextDirection.ltr);
    return settings.isRtl
        ? <Widget>[urdu, english]
        : <Widget>[english, urdu];
  }
}

class _RepeatBadge extends StatelessWidget {
  const _RepeatBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

class _ActionRow extends ConsumerWidget {
  const _ActionRow({
    required this.dua,
    required this.isFavorite,
    required this.isPlaying,
  });

  final Dua dua;
  final bool isFavorite;
  final bool isPlaying;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _Action(
          icon: isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
          tooltip: isPlaying ? l.t('stop') : l.t('play'),
          onPressed: () => _onPlay(context, ref),
        ),
        _Action(
          icon: Icons.menu_book_rounded,
          tooltip: l.t('reference'),
          onPressed: () => showReferenceSheet(context, dua),
        ),
        _Action(
          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
          tooltip: isFavorite ? l.t('remove_favorite') : l.t('add_favorite'),
          onPressed: () =>
              ref.read(favoritesProvider.notifier).toggle(dua.id),
        ),
        _Action(
          icon: Icons.share_rounded,
          tooltip: l.t('share'),
          onPressed: () => _onShare(),
        ),
      ],
    );
  }

  Future<void> _onPlay(BuildContext context, WidgetRef ref) async {
    final AppLocalizations l = AppLocalizations.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final AudioController controller =
        ref.read(audioControllerProvider.notifier);

    if (isPlaying) {
      await controller.stop();
      return;
    }
    final bool played = await controller.play(dua);
    if (!played) {
      messenger.showSnackBar(
        SnackBar(content: Text(l.t('audio_unavailable'))),
      );
    }
  }

  Future<void> _onShare() async {
    final StringBuffer buffer = StringBuffer()
      ..writeln(dua.arabic)
      ..writeln()
      ..writeln(dua.translationEnglish)
      ..writeln()
      ..writeln(dua.translationUrdu)
      ..writeln()
      ..writeln(
          '— ${dua.reference.hadithCollection} ${dua.reference.hadithNumber} '
          '(${dua.reference.authenticity})')
      ..writeln(AppConstants.appName);
    await Share.share(buffer.toString().trim());
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: onPressed,
      // Large touch target for accessibility.
      iconSize: 26,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    );
  }
}
