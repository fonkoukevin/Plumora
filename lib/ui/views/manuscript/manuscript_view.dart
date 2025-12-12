import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/manuscript.dart';
import 'manuscript_viewmodel.dart';

class ManuscriptView extends StackedView<ManuscriptViewModel> {
  final String? manuscriptId;

  const ManuscriptView({
    super.key,
    this.manuscriptId,
  });

  @override
  void onViewModelReady(ManuscriptViewModel viewModel) {
    super.onViewModelReady(viewModel);
    if (manuscriptId != null && manuscriptId!.isNotEmpty) {
      viewModel.init(manuscriptId!);
    }
  }

  @override
  Widget builder(
    BuildContext context,
    ManuscriptViewModel viewModel,
    Widget? child,
  ) {
    final theme = Theme.of(context);

    if (viewModel.isBusy || viewModel.manuscript == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final m = viewModel.manuscript!;
    final wordsCount = _countWords(viewModel.contentController.text);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EC),
      body: SafeArea(
        child: Column(
          children: [
            // 🔶 HEADER AVEC GRADIENT
            _ManuscriptHeader(
              title: m.title,
              status: m.status,
              chapterCount: m.chapterCount,
              onBack: viewModel.goBack,
              onSave: viewModel.isSaving ? null : viewModel.saveContent,
              isSaving: viewModel.isSaving,
            ),

            // 🔶 CONTENU SCROLLABLE
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    // Carte infos manuscrit
                    _InfoCard(
                      manuscript: m,
                      wordsCount: wordsCount,
                    ),
                    const SizedBox(height: 12),

                    // Carte éditeur
                    _EditorCard(
                      controller: viewModel.contentController,
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 🔶 BOUTON FLOTTANT EN BAS
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: viewModel.isSaving ? null : viewModel.saveContent,
            icon: viewModel.isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: Text(
              viewModel.isSaving ? 'Enregistrement...' : 'Enregistrer',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5E3C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 4,
            ),
          ),
        ),
      ),
    );
  }

  @override
  ManuscriptViewModel viewModelBuilder(BuildContext context) =>
      ManuscriptViewModel();
}

/// Compte très simple des mots
int _countWords(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return 0;
  return trimmed.split(RegExp(r'\s+')).length;
}



/// 🔶 HEADER : retour, titre, statut, bouton sauvegarde
class _ManuscriptHeader extends StatelessWidget {
  final String title;
  final String status;
  final int chapterCount;
  final VoidCallback onBack;
  final VoidCallback? onSave;
  final bool isSaving;

  const _ManuscriptHeader({
    required this.title,
    required this.status,
    required this.chapterCount,
    required this.onBack,
    required this.onSave,
    required this.isSaving,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD3A36B), Color(0xFF8B5E3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ligne avec bouton retour + sauvegarde
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onSave,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  backgroundColor: Colors.black.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: isSaving
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check, size: 18),
                label: Text(
                  isSaving ? 'En cours' : 'Sauvegarder',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _StatusChip(status: status),
              const SizedBox(width: 8),
              Text(
                '$chapterCount chapitres',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




/// 🔶 Carte d’info du manuscrit : résumé + stats
class _InfoCard extends StatelessWidget {
  final Manuscript manuscript;
  final int wordsCount;

  const _InfoCard({
    required this.manuscript,
    required this.wordsCount,
  });

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
              _MiniStat(
                icon: Icons.text_snippet_outlined,
                label: 'Mots',
                value: wordsCount.toString(),
              ),
              _MiniStat(
                icon: Icons.bar_chart_rounded,
                label: 'Statut',
                value: statusLabel(),
              ),
              _MiniStat(
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


class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF8B5E3C)),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔶 Carte éditeur avec TextField stylé
class _EditorCard extends StatelessWidget {
  final TextEditingController controller;

  const _EditorCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contenu du manuscrit',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7F2EC),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            height: 350, // tu peux ajuster, + tard : plein écran
            child: TextField(
              controller: controller,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Commence à écrire ton histoire ici...',
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// 🔶 Chip de statut (réutilisé dans le header)
class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  String _label() {
    switch (status) {
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
        return status;
    }
  }

  Color _color() {
    switch (status) {
      case ManuscriptStatus.writing:
        return const Color(0xFFE57C8C);
      case ManuscriptStatus.editing:
        return const Color(0xFFFBC02D);
      case ManuscriptStatus.reviewing:
        return const Color(0xFF64B5F6);
      case ManuscriptStatus.selected:
        return const Color(0xFFAB47BC);
      case ManuscriptStatus.published:
        return const Color(0xFF66BB6A);
      default:
        return const Color(0xFFB0BEC5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color().withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _label(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: _color().withOpacity(0.9),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
