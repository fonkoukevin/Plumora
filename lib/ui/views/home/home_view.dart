import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';
import '../../../models/manuscript.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    final theme = Theme.of(context);
    final userName = viewModel.displayName.isEmpty
        ? 'Sophie'
        : viewModel.displayName.split(' ').first; // juste le prénom
    final greeting = 'Bonjour, $userName ✨';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EC),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.createNewManuscript,
        backgroundColor: const Color(0xFF8B5E3C),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER "Plumora" + bonjour
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Plumora',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
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
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD3A36B), Color(0xFF8B5E3C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.dark_mode_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // STATS DU JOUR (mock pour l'instant)
                    Row(
                      children: [
                        Expanded(
                          child: const _StatCard(
                            label: 'Mots aujourd\'hui',
                            value: '856', // TODO: brancher plus tard
                            icon: Icons.trending_up,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: const _StatCard(
                            label: 'Temps d\'écriture',
                            value: '1h 24m', // TODO: brancher plus tard
                            icon: Icons.access_time,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // BARRE DE RECHERCHE
                    const _SearchBar(),

                    const SizedBox(height: 10),

                    // CITATION
                    const _QuoteCard(),

                    const SizedBox(height: 16),

                    // SECTION MANUSCRITS
                    Row(
                      children: [
                        Text(
                          'Vos manuscrits',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // plus tard : bibliothèque
                          },
                          child: Text(
                            'Voir tout →',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF8B5E3C),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (!viewModel.hasManuscripts)
                      _EmptyManuscriptsHome(
                        onCreate: viewModel.createNewManuscript,
                      )
                    else
                      Column(
                        children: viewModel.manuscripts
                            .map(
                              (m) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: _ManuscriptHomeCard(
                                  manuscript: m,
                                  onTap: () => viewModel.openManuscript(m),
                                ),
                              ),
                            )
                            .toList(),
                      ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: _BottomNavBar(
        onHomeTap: () {}, // déjà sur Accueil
        onBetaTap: () {},
        onReadingTap: () {},
        onNotificationsTap: () {},
        onProfileTap: viewModel.goToProfile, // 👉 ouvre la page Profil
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF8B5E3C)),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Rechercher un manuscrit...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.format_quote, color: Color(0xFF8B5E3C)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '« N\'attendez pas l\'inspiration. Elle vient en écrivant. »',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '— Victor Hugo',
              style:
                  theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyManuscriptsHome extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyManuscriptsHome({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(Icons.menu_book_outlined, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'Aucun manuscrit pour le moment',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Appuie sur le bouton + pour créer ton premier manuscrit.',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ManuscriptHomeCard extends StatelessWidget {
  final Manuscript manuscript;
  final VoidCallback onTap;

  const _ManuscriptHomeCard({
    required this.manuscript,
    required this.onTap,
  });

  String _statusLabel(String status) {
    switch (status) {
      case ManuscriptStatus.writing:
        return 'En cours';
      case ManuscriptStatus.editing:
        return 'Édition';
      case ManuscriptStatus.reviewing:
        return 'Bêta-lecture';
      case ManuscriptStatus.selected:
        return 'Sélectionné';
      case ManuscriptStatus.published:
        return 'Publié';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO : plus tard, vrai pourcentage
    const double progress = 0.65;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              manuscript.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Romance • ${manuscript.chapterCount} chapitres',
              style:
                  theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(
              'Statut : ${_statusLabel(manuscript.status)}',
              style:
                  theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      height: 4,
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE57C8C),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(progress * 100).round()}%',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onBetaTap;
  final VoidCallback onReadingTap;
  final VoidCallback onNotificationsTap;
  final VoidCallback onProfileTap;

  const _BottomNavBar({
    required this.onHomeTap,
    required this.onBetaTap,
    required this.onReadingTap,
    required this.onNotificationsTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: const Color(0xFF8B5E3C),
      unselectedItemColor: Colors.grey[500],
      onTap: (index) {
        switch (index) {
          case 0:
            onHomeTap();
            break;
          case 1:
            onBetaTap();
            break;
          case 2:
            onReadingTap();
            break;
          case 3:
            onNotificationsTap();
            break;
          case 4:
            onProfileTap();
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups_outlined),
          label: 'Bêta',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          label: 'Lecture',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          label: 'Notifs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profil',
        ),
      ],
    );
  }
}
