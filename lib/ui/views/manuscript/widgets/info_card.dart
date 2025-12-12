import 'package:flutter/material.dart';
import '../../../../models/manuscript.dart';
import 'mini_stat.dart';

class InfoCard extends StatelessWidget {
  final Manuscript manuscript;
  final int wordsCount;

  const InfoCard({
    required this.manuscript,
    required this.wordsCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String statusLabel() {
      switch (manuscript.status) {
        case ManuscriptStatus.writing:
          return 'En cours d’écriture';
        case ManuscriptStatus.editing:
          return 'Édition';
        case ManuscriptStatus.reviewing:
          return 'Bêta-lecture';
        case ManuscriptStatus.selected:
          return 'Sélectionné';
        case ManuscriptStatus.published:
          return 'Publié';
        default:
          return manuscript.status;
      }
    }

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
          if (manuscript.summary != null &&
              manuscript.summary!.trim().isNotEmpty) ...[
            Text(
              'Résumé',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              manuscript.summary!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[800],
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              MiniStat(
                icon: Icons.text_snippet_outlined,
                label: 'Mots',
                value: wordsCount.toString(),
              ),
              MiniStat(
                icon: Icons.bar_chart_rounded,
                label: 'Statut',
                value: statusLabel(),
              ),
              MiniStat(
                icon: Icons.star_border_rounded,
                label: 'Note',
                value: manuscript.avgRating.toStringAsFixed(1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
