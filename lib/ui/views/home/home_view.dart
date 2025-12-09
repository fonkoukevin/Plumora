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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Owl Writey',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Center(
            child: Text(
              viewModel.displayName,
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[200]),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: viewModel.logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: viewModel.createNewManuscript,
        icon: const Icon(Icons.add),
        label: const Text('Nouveau manuscrit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildBody(context, viewModel),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.isBusy) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!viewModel.hasManuscripts) {
      return _buildEmptyState(context, viewModel);
    }

    final manuscripts = viewModel.manuscripts;

    return ListView.separated(
      itemCount: manuscripts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final m = manuscripts[index];
        return _ManuscriptCard(
          manuscript: m,
          onTap: () => viewModel.openManuscript(m),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, HomeViewModel viewModel) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucun manuscrit pour le moment',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Créez votre premier roman pour commencer votre aventure.',
            textAlign: TextAlign.center,
            style:
                theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: viewModel.createNewManuscript,
            icon: const Icon(Icons.add),
            label: const Text('Créer un manuscrit'),
          ),
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
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
        return 'Écriture';
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.menu_book, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manuscript.title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (manuscript.summary != null &&
                      manuscript.summary!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      manuscript.summary!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: Colors.brown[100],
                        ),
                        child: Text(
                          _statusLabel(manuscript.status),
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${manuscript.chapterCount} chapitres',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey[700]),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        manuscript.avgRating.toStringAsFixed(1),
                        style: theme.textTheme.bodySmall,
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
