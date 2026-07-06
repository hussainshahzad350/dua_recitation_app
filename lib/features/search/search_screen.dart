import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/dua_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/dua.dart';
import '../../shared/providers.dart';

/// Instant, offline search across Arabic, translations, transliteration,
/// category and source.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: ref.read(searchQueryProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context);
    final String query = ref.watch(searchQueryProvider);
    final List<Dua> results = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l.t('search_hint'),
            border: InputBorder.none,
            suffixIcon: query.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _controller.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                    },
                  ),
          ),
          onChanged: (String value) =>
              ref.read(searchQueryProvider.notifier).state = value,
        ),
      ),
      body: _buildBody(context, l, query, results),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l, String query,
      List<Dua> results) {
    if (query.trim().isEmpty) {
      return EmptyState(
          icon: Icons.search_rounded, message: l.t('search_prompt'));
    }
    if (results.isEmpty) {
      return EmptyState(
          icon: Icons.search_off_rounded, message: l.t('no_results'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.screenPadding),
      itemCount: results.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppConstants.cardSpacing),
      itemBuilder: (BuildContext context, int index) =>
          DuaCard(results[index]),
    );
  }
}
