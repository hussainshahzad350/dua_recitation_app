import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/dua_category.dart';
import '../../shared/providers.dart';
import 'category_duas_screen.dart';

/// Grid of the "Important Duas" categories (Morning, Sleep, Forgiveness, …).
class ImportantDuasScreen extends ConsumerWidget {
  const ImportantDuasScreen({super.key});

  /// Maps a category's `icon` key to a Material icon.
  static const Map<String, IconData> _icons = <String, IconData>{
    'sun': Icons.wb_sunny_rounded,
    'forgiveness': Icons.volunteer_activism_rounded,
    'shield': Icons.shield_rounded,
    'heart': Icons.favorite_rounded,
    'hardship': Icons.spa_rounded,
    'rizq': Icons.eco_rounded,
    'debt': Icons.account_balance_wallet_rounded,
    'sleep': Icons.bedtime_rounded,
    'waking': Icons.wb_twilight_rounded,
    'parents': Icons.people_rounded,
    'travel': Icons.flight_takeoff_rounded,
    'home': Icons.home_rounded,
    'mosque': Icons.mosque_rounded,
    'market': Icons.storefront_rounded,
    'food': Icons.restaurant_rounded,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    final List<DuaCategory> categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.t('important_duas'))),
      body: GridView.count(
        padding: const EdgeInsets.all(AppConstants.screenPadding),
        crossAxisCount: 2,
        mainAxisSpacing: AppConstants.cardSpacing,
        crossAxisSpacing: AppConstants.cardSpacing,
        childAspectRatio: 1.5,
        children: <Widget>[
          for (final DuaCategory category in categories)
            _CategoryCard(
              label: category.title(isUrdu: l.isUrdu),
              icon: _icons[category.icon] ?? Icons.menu_book_rounded,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CategoryDuasScreen(category: category),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
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
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
