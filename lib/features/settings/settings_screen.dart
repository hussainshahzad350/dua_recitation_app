import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/app_settings.dart';
import '../../shared/providers.dart';
import 'info_screen.dart';

/// Lets the user configure language, theme, font sizes, transliteration, and
/// open the About / Sources / Privacy screens. Every change is persisted
/// immediately via [settingsProvider].
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    final AppSettings settings = ref.watch(settingsProvider);
    final SettingsNotifier notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l.t('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.screenPadding),
        children: <Widget>[
          // Language
          _GroupCard(
            title: l.t('settings_language'),
            child: SegmentedButton<String>(
              segments: <ButtonSegment<String>>[
                ButtonSegment<String>(
                    value: 'en', label: Text(l.t('language_english'))),
                ButtonSegment<String>(
                    value: 'ur', label: Text(l.t('language_urdu'))),
              ],
              selected: <String>{settings.languageCode},
              onSelectionChanged: (Set<String> s) =>
                  notifier.setLanguage(s.first),
            ),
          ),

          // Theme
          _GroupCard(
            title: l.t('settings_theme'),
            child: SegmentedButton<ThemeMode>(
              segments: <ButtonSegment<ThemeMode>>[
                ButtonSegment<ThemeMode>(
                    value: ThemeMode.system, label: Text(l.t('theme_system'))),
                ButtonSegment<ThemeMode>(
                    value: ThemeMode.light, label: Text(l.t('theme_light'))),
                ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark, label: Text(l.t('theme_dark'))),
              ],
              selected: <ThemeMode>{settings.themeMode},
              onSelectionChanged: (Set<ThemeMode> s) =>
                  notifier.setThemeMode(s.first),
            ),
          ),

          // Arabic font size
          _GroupCard(
            title: l.t('settings_arabic_font'),
            child: Column(
              children: <Widget>[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'رَبِّ زِدْنِي عِلْمًا',
                    style: TextStyle(fontSize: settings.arabicFontSize),
                  ),
                ),
                Slider(
                  value: settings.arabicFontSize,
                  min: AppConstants.minArabicFontSize,
                  max: AppConstants.maxArabicFontSize,
                  divisions: 13,
                  label: settings.arabicFontSize.round().toString(),
                  onChanged: notifier.setArabicFontSize,
                ),
              ],
            ),
          ),

          // Translation font size
          _GroupCard(
            title: l.t('settings_translation_font'),
            child: Column(
              children: <Widget>[
                Text(
                  l.t('settings_preview'),
                  style: TextStyle(fontSize: settings.translationFontSize),
                ),
                Slider(
                  value: settings.translationFontSize,
                  min: AppConstants.minTranslationFontSize,
                  max: AppConstants.maxTranslationFontSize,
                  divisions: 12,
                  label: settings.translationFontSize.round().toString(),
                  onChanged: notifier.setTranslationFontSize,
                ),
              ],
            ),
          ),

          // Transliteration toggle
          Card(
            child: SwitchListTile(
              title: Text(l.t('settings_show_transliteration')),
              value: settings.showTransliteration,
              onChanged: notifier.setShowTransliteration,
            ),
          ),
          const SizedBox(height: AppConstants.cardSpacing),

          // Info links
          Card(
            child: Column(
              children: <Widget>[
                _InfoTile(
                  label: l.t('settings_about'),
                  body: l.t('about_body'),
                ),
                _InfoTile(
                  label: l.t('settings_sources'),
                  body: l.t('sources_body'),
                ),
                _InfoTile(
                  label: l.t('settings_privacy'),
                  body: l.t('privacy_body'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.cardSpacing),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => InfoScreen(title: label, body: body),
        ),
      ),
    );
  }
}
