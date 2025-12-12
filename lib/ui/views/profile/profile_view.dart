import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../home/home_viewmodel.dart';
import '../../../models/manuscript.dart';

class ProfileView extends StackedView<HomeViewModel> {
  const ProfileView({super.key});

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    final theme = Theme.of(context);
    final userName = viewModel.displayName.isEmpty
        ? 'Autrice inconnue'
        : viewModel.displayName;
    final initials = _buildInitials(userName);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EC),
      body: SafeArea(
        child: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileHeader(
                      initials: initials,
                      name: userName,
                      subtitle: 'Autrice passionnée',
                      onEditProfile: () {
                        // TODO: édition du profil
                      },
                    ),
                    const SizedBox(height: 12),
                    _StatsRow(
                      manuscriptsCount: viewModel.manuscripts.length,
                      wordsCount: 248000,
                      hoursCount: 456,
                      awardsCount: 0,
                    ),
                    const SizedBox(height: 12),
                    const _AboutCard(
                      aboutText:
                          "Passionnée d'écriture depuis mon plus jeune âge, "
                          "je crée des mondes où la magie rencontre l'émotion.",
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Mes manuscrits',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (!viewModel.hasManuscripts)
                      const _EmptyManuscripts()
                    else
                      Column(
                        children: [
                          ...viewModel.manuscripts.map(
                            (m) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: _ManuscriptCard(
                                manuscript: m,
                                onTap: () => viewModel.openManuscript(m),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),
                    _SettingsSection(
                      onLogout: viewModel.logout,
                      onSettings: () {},
                    ),
                  ],
                ),
              ),
      ),
      // bottomNavigationBar: _BottomNavBar(
      //   onHomeTap: viewModel.goToHome,
      //   onLibraryTap: () {},
      //   onNotificationsTap: () {},
      //   onProfileTap: () {},
      // ),

      bottomNavigationBar: _BottomNavBar(
        onHomeTap: viewModel.goToHome,
        onBetaTap: viewModel.goToBeta, // TODO plus tard
        onReadingTap: viewModel.goToReading, // 👈 Lecture
        onNotificationsTap: viewModel.goToNotifs,
        onProfileTap: viewModel.goToProfile, // 👈 Profil
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}

String _buildInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty) return '';
  if (parts.length == 1) {
    return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '';
  }
  return (parts[0].isNotEmpty ? parts[0][0] : '').toUpperCase() +
      (parts[1].isNotEmpty ? parts[1][0] : '').toUpperCase();
}

class _ProfileHeader extends StatelessWidget {
  final String initials;
  final String name;
  final String subtitle;
  final VoidCallback onEditProfile;

  const _ProfileHeader({
    required this.initials,
    required this.name,
    required this.subtitle,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD3A36B), Color(0xFF8B5E3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFF7F2EC),
                child: Text(
                  initials,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B5E3C),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.dark_mode_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onEditProfile,
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Modifier le profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5E3C),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int manuscriptsCount;
  final int wordsCount;
  final int hoursCount;
  final int awardsCount;

  const _StatsRow({
    required this.manuscriptsCount,
    required this.wordsCount,
    required this.hoursCount,
    required this.awardsCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget statItem(String label, String value, IconData icon) {
      return Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF8B5E3C)),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: Colors.grey[700], fontSize: 11),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          statItem('Manuscrits', manuscriptsCount.toString(), Icons.menu_book),
          statItem('Mots', '${(wordsCount / 1000).round()}K',
              Icons.bar_chart_rounded),
          statItem('Heures', hoursCount.toString(), Icons.timer_outlined),
          statItem('Prix', awardsCount.toString(), Icons.emoji_events_outlined),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final String aboutText;

  const _AboutCard({required this.aboutText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'À propos',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            aboutText,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: Colors.grey[800], height: 1.3),
          ),
        ],
      ),
    );
  }
}

class _EmptyManuscripts extends StatelessWidget {
  const _EmptyManuscripts();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
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
            'Tu pourras créer un manuscrit depuis la page d’accueil.',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: Colors.grey[600], height: 1.3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ManuscriptCard extends StatelessWidget {
  final Manuscript manuscript;
  final VoidCallback onTap;

  const _ManuscriptCard({
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

  Color _statusColor(String status) {
    switch (status) {
      case ManuscriptStatus.writing:
        return const Color(0xFFEF9A9A); // rose clair
      case ManuscriptStatus.editing:
        return const Color(0xFFFFF59D); // jaune
      case ManuscriptStatus.published:
        return const Color(0xFFA5D6A7); // vert
      default:
        return const Color(0xFFB0BEC5); // gris
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: _statusColor(manuscript.status),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manuscript.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (manuscript.summary != null &&
                      manuscript.summary!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      manuscript.summary!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey[700]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _statusLabel(manuscript.status),
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: Colors.grey[700]),
                      ),
                      const Spacer(),
                      const Icon(Icons.menu_book_outlined, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${manuscript.chapterCount} chapitres',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final VoidCallback onSettings;
  final VoidCallback onLogout;

  const _SettingsSection({
    required this.onSettings,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget item(IconData icon, String label, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey[800]),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // item(Icons.settings_outlined, 'Paramètres', onSettings),
        const SizedBox(height: 6),
        item(Icons.logout, 'Déconnexion', onLogout),
      ],
    );
  }
}

// class _ProfileBottomNavBar extends StatelessWidget {
//   final VoidCallback onHomeTap;
//   final VoidCallback onLibraryTap;
//   final VoidCallback onNotificationsTap;
//   final VoidCallback onProfileTap;

//   const _ProfileBottomNavBar({
//     required this.onHomeTap,
//     required this.onLibraryTap,
//     required this.onNotificationsTap,
//     required this.onProfileTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       currentIndex: 4, // onglet Profil
//       onTap: (index) {
//         switch (index) {
//           case 0:
//             onHomeTap();
//             break;
//           case 1:
//             onLibraryTap();
//             break;
//           case 2:
//             onNotificationsTap();
//             break;
//           case 3:
//             break;
//           case 4:
//             onProfileTap();
//             break;
//         }
//       },
//       selectedItemColor: const Color(0xFF8B5E3C),
//       unselectedItemColor: Colors.grey[500],
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home_outlined),
//           label: 'Accueil',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.menu_book_outlined),
//           label: 'Bibliothèque',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.notifications_outlined),
//           label: 'Alertes',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person_outline),
//           label: 'Autre',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person),
//           label: 'Profil',
//         ),
//       ],
//     );
//   }
// }

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
      currentIndex: 4,
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
