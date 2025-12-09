import 'package:flutter/material.dart';
import 'package:plumora/ui/views/newmanuscript/newmanuscript_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NewmanuscriptView extends StackedView<NewmanuscriptViewModel> {
  const NewmanuscriptView({super.key});

  @override
  Widget builder(
    BuildContext context,
    NewmanuscriptViewModel viewModel,
    Widget? child,
  ) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau manuscrit'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: viewModel.cancel,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Créer un nouveau projet de roman',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Commencez par donner un titre et un résumé rapide. Vous pourrez tout modifier plus tard.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              Text('Titre *', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              TextField(
                onChanged: viewModel.onTitleChanged,
                decoration: InputDecoration(
                  hintText: 'Ex : Les Plumes de la Nuit',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Résumé (optionnel)', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              TextField(
                onChanged: viewModel.onSummaryChanged,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Décrivez brièvement votre histoire...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              if (viewModel.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: viewModel.isBusy ? null : viewModel.create,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: viewModel.isBusy
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Créer le manuscrit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  NewmanuscriptViewModel viewModelBuilder(BuildContext context) =>
      NewmanuscriptViewModel();
}
