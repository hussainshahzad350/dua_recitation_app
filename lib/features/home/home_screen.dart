import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models/prayer.dart';
import '../favorites/favorites_screen.dart';
import '../important_duas/important_duas_screen.dart';
import '../prayer_duas/prayer_duas_screen.dart';
import '../search/search_screen.dart';
import '../settings/settings_screen.dart';

/// The home screen: large prayer cards for post-Salah duas, plus entries for
/// Important Duas, Favorites, Search and Settings. Deliberately uncluttered.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const Map<Prayer, IconData> _prayerIcons = <Prayer, IconData>{
    Prayer.fajr: Icons.wb_twilight_rounded,
    Prayer.dhuhr: Icons.wb_sunny_rounded,
    Prayer.asr: Icons.wb_cloudy_rounded,
    Prayer.maghrib: Icons.nightlight_round,
    Prayer.isha: Icons.dark_mode_rounded,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.t('app_name'))),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.screenPadding),
        children: <Widget>[
          SectionHeader(l.t('home_prayers_title')),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppConstants.cardSpacing,
            crossAxisSpacing: AppConstants.cardSpacing,
            childAspectRatio: 1.6,
            children: <Widget>[
              for (final Prayer prayer in Prayer.values)
                _PrayerCard(
                  label: l.prayer(prayer.id),
                  icon: _prayerIcons[prayer]!,
                  onTap: () => _push(
                      context, PrayerDuasScreen(prayerId: prayer.id)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SectionHeader(l.t('home_explore_title')),
          _ExploreTile(
            icon: Icons.auto_stories_rounded,
            label: l.t('important_duas'),
            onTap: () => _push(context, const ImportantDuasScreen()),
          ),
          _ExploreTile(
            icon: Icons.favorite_rounded,
            label: l.t('favorites'),
            onTap: () => _push(context, const FavoritesScreen()),
          ),
          _ExploreTile(
            icon: Icons.search_rounded,
            label: l.t('search'),
            onTap: () => _push(context, const SearchScreen()),
          ),
          _ExploreTile(
            icon: Icons.settings_rounded,
            label: l.t('settings'),
            onTap: () => _push(context, const SettingsScreen()),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

class _PrayerCard extends StatelessWidget {
  const _PrayerCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, color: theme.colorScheme.onPrimaryContainer),
              const Spacer(),
              Text(
                label,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreTile extends StatelessWidget {
  const _ExploreTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.cardSpacing),
      child: Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(label),
          trailing: const Icon(Icons.chevron_right_rounded),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
