import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/manuscript.dart';
import 'reading_viewmodel.dart';

class ReadingView extends StackedView<ReadingViewModel> {
  const ReadingView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ReadingViewModel viewModel,
    Widget? child,
  ) {
    final theme = Theme.of(context);
    final isLoading = viewModel.isBusy && !viewModel.hasManuscripts;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2EC),
        elevation: 0,
        title: Text(
          'Lecture',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4E342E),
          ),
        ),
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: viewModel.hasManuscripts
                  ? ListView.separated(
                      itemCount: viewModel.manuscripts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final m = viewModel.manuscripts[index];
                        return _ManuscriptReadingCard(
                          manuscript: m,
                          onOpenRead: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ReadingDetailView(manuscript: m),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Aucun manuscrit public pour le moment.\n'
                        'Quand des autrices rendront leurs manuscrits publics,\n'
                        'ils apparaîtront ici.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
            ),
    );
  }

  @override
  ReadingViewModel viewModelBuilder(BuildContext context) => ReadingViewModel();
}

/// Carte style "post Instagram" d’un manuscrit
class _ManuscriptReadingCard extends StatelessWidget {
  final Manuscript manuscript;
  final VoidCallback onOpenRead;

  const _ManuscriptReadingCard({
    required this.manuscript,
    required this.onOpenRead,
  });

  void _showSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature sera bientôt disponible ✨'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Pour l’instant, valeurs en dur (mock)
    const int likesCount = 124;
    const int commentsCount = 5;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onOpenRead, // 👉 tap sur la carte = ouvrir la lecture
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header : titre + petite info ---
            Text(
              manuscript.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4E342E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              manuscript.summary?.isNotEmpty == true
                  ? manuscript.summary!
                  : 'Pas de résumé pour le moment.',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.menu_book_outlined,
                    size: 14, color: Color(0xFF8B5E3C)),
                const SizedBox(width: 4),
                Text(
                  '${manuscript.chapterCount} chapitres',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  manuscript.avgRating.toStringAsFixed(1),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // --- Ligne d’actions façon Instagram ---
            Row(
              children: [
                IconButton(
                  onPressed: () => _showSoon(context, 'Le like'),
                  icon: const Icon(Icons.favorite_border),
                  splashRadius: 20,
                  color: const Color(0xFF8B5E3C),
                ),
                IconButton(
                  onPressed: () => _showSoon(context, 'Les commentaires'),
                  icon: const Icon(Icons.chat_bubble_outline),
                  splashRadius: 20,
                  color: const Color(0xFF8B5E3C),
                ),
                IconButton(
                  onPressed: () => _showSoon(context, 'Le partage'),
                  icon: const Icon(Icons.send_outlined),
                  splashRadius: 20,
                  color: const Color(0xFF8B5E3C),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showSoon(context, 'Les favoris'),
                  icon: const Icon(Icons.bookmark_border),
                  splashRadius: 20,
                  color: const Color(0xFF8B5E3C),
                ),
              ],
            ),

            // --- Texte sous la barre d’actions (comme Insta) ---
            Text(
              '$likesCount j\'aime',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Voir les $commentsCount commentaires',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Il y a 2 jours', // plus tard : calculer avec createdAt
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 👉 Écran de détail pour lire un manuscrit
class ReadingDetailView extends StatelessWidget {
  final Manuscript manuscript;

  const ReadingDetailView({
    super.key,
    required this.manuscript,
  });

  void _showSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label sera bientôt disponible ✨'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2EC),
        elevation: 0,
        title: Text(
          manuscript.title,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4E342E),
          ),
        ),
      ),
      body: Column(
        children: [
          // En-tête
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  manuscript.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4E342E),
                  ),
                ),
                const SizedBox(height: 4),
                // Text(
                //   'Autrice : inconnue pour l’instant',
                //   style: theme.textTheme.bodySmall?.copyWith(
                //     color: Colors.brown[700],
                //   ),
                // ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.menu_book_outlined,
                        size: 16, color: Color(0xFF8B5E3C)),
                    const SizedBox(width: 4),
                    Text(
                      '${manuscript.chapterCount} chapitres',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(
                      manuscript.avgRating.toStringAsFixed(1),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (manuscript.summary?.isNotEmpty == true)
                  Text(
                    manuscript.summary!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[800],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Zone de lecture
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF1E3D6),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: Text(
                        manuscript.content.isNotEmpty
                            ? manuscript.content
                            : 'Ce manuscrit est pour l’instant vide.\n'
                                'L’autrice n’a pas encore rempli le texte.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Barre d’actions en bas (lecture détaillée)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     _ActionButton(
            //       icon: Icons.favorite_border,
            //       label: 'Like',
            //       onTap: () => _showSoon(context, 'Le like'),
            //     ),
            //     _ActionButton(
            //       icon: Icons.chat_bubble_outline,
            //       label: 'Commenter',
            //       onTap: () => _showSoon(context, 'Les commentaires'),
            //     ),
            //     _ActionButton(
            //       icon: Icons.bookmark_border,
            //       label: 'Favori',
            //       onTap: () => _showSoon(context, 'Les favoris'),
            //     ),
            //     _ActionButton(
            //       icon: Icons.share,
            //       label: 'Partager',
            //       onTap: () => _showSoon(context, 'Le partage'),
            //     ),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF8B5E3C)),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
