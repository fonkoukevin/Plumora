import 'package:flutter/material.dart';
import 'package:plumora/models/manuscript.dart';

import 'package:plumora/ui/theme/plumora_ui.dart';

class PlumoraHomeManuscriptCard extends StatelessWidget {
  final Manuscript manuscript;
  final VoidCallback onTap;

  const PlumoraHomeManuscriptCard({
    super.key,
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

    // v1: progression fixe (tu brancheras plus tard)
    const progress = 0.65;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(PlumoraUi.radiusCard),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: PlumoraUi.card,
          borderRadius: BorderRadius.circular(PlumoraUi.radiusCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              manuscript.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: PlumoraUi.textDark,
              ),
            ),
            const SizedBox(height: 4),
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
            const SizedBox(height: 10),

            // progress bar + %
            Stack(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: PlumoraUi.progressBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, c) => Container(
                    height: 4,
                    width: c.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: PlumoraUi.progressFill,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
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
