import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../models/manuscript.dart';
import 'manuscript_viewmodel.dart';

import 'package:flutter/material.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.manuscript?.title ?? 'Manuscrit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: viewModel.goBack,
        ),
      ),
      body: viewModel.isBusy || viewModel.manuscript == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: _buildContent(context, viewModel.manuscript!, theme),
            ),
    );
  }

  Widget _buildContent(
      BuildContext context, Manuscript manuscript, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          manuscript.title,
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (manuscript.summary != null && manuscript.summary!.trim().isNotEmpty)
          Text(
            manuscript.summary!,
            style: theme.textTheme.bodyMedium,
          ),
        const SizedBox(height: 16),
        Text(
          'Statut : ${manuscript.status}',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Chapitres : ${manuscript.chapterCount}',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, size: 18, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              manuscript.avgRating.toStringAsFixed(1),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Placeholder pour la suite
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[100],
          ),
          child: const Text(
            'Ici, plus tard :\n- Liste des chapitres\n- Outil d’écriture\n- Accès bêta-lecture\n- Outils d’édition...',
          ),
        ),
      ],
    );
  }

  @override
  ManuscriptViewModel viewModelBuilder(BuildContext context) =>
      ManuscriptViewModel();
}
