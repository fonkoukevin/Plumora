import 'package:flutter/material.dart';
import 'package:plumora/ui/widgets/common/plumora_bottom_navbar/plumora_bottom_navbar.dart';
import 'package:plumora/ui/widgets/common/plumora_fab/plumora_fab.dart';
import 'package:plumora/ui/widgets/common/plumora_home_manuscript_card/plumora_home_manuscript_card.dart';
import 'package:plumora/ui/widgets/common/plumora_moon_button/plumora_moon_button.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';
import '../../theme/plumora_ui.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final theme = Theme.of(context);
    final userName = viewModel.displayName.isEmpty
        ? 'kevin@test.com'
        : viewModel.displayName;
    final greeting = 'Bonjour, $userName ✨';

    return Scaffold(
      backgroundColor: PlumoraUi.bg,
      floatingActionButton: PlumoraFab(onTap: viewModel.createNewManuscript),
      body: SafeArea(
        child: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header exactement “avant”
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Plumora',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: PlumoraUi.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                greeting,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PlumoraMoonButton(),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Stats (si tu as déjà des widgets factorisés, garde-les)
                    Row(
                      children: [
                        Expanded(
                            child: _Stat(
                                label: "Mots aujourd'hui",
                                value: "856",
                                icon: Icons.trending_up)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _Stat(
                                label: "Temps d'écriture",
                                value: "1h 24m",
                                icon: Icons.access_time)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Search
                    _Search(),

                    const SizedBox(height: 10),

                    // Quote
                    _Quote(),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Text('Vos manuscrits',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w900)),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Voir tout →',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: PlumoraUi.brown,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    if (!viewModel.hasManuscripts)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(PlumoraUi.radiusCard),
                        ),
                        child: Text(
                          "Aucun manuscrit pour le moment.",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                      )
                    else
                      Column(
                        children: viewModel.manuscripts
                            .map((m) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: PlumoraHomeManuscriptCard(
                                    manuscript: m,
                                    onTap: () => viewModel.openManuscript(m),
                                  ),
                                ))
                            .toList(),
                      ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: PlumoraBottomNavBar(
        currentIndex: 0,
        onHome: () {},
        onBeta: viewModel.goToBeta,
        onReading: viewModel.goToReading,
        onNotif: viewModel.goToNotifs,
        onProfile: viewModel.goToProfile,
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}

/// Petits widgets locaux (tu peux aussi les sortir si tu veux)
class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _Stat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(PlumoraUi.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: PlumoraUi.brown),
          const SizedBox(height: 10),
          Text(value,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(label,
              style:
                  theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
        ],
      ),
    );
  }
}

class _Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Rechercher un manuscrit...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _Quote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(PlumoraUi.radiusCard),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote, color: PlumoraUi.brown),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "« N'attendez pas l'inspiration. Elle vient en écrivant. »\n— Victor Hugo",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                height: 1.3,
                color: Colors.grey[800],
              ),
            ),
          )
        ],
      ),
    );
  }
}
