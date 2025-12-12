import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/manuscript.dart';
import 'widgets/manuscript_header.dart';
import 'widgets/info_card.dart';
import 'widgets/editor_card.dart';
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
            ManuscriptHeader(
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
                    InfoCard(
                      manuscript: m,
                      wordsCount: wordsCount,
                    ),
                    const SizedBox(height: 12),

                    // Carte éditeur
                    EditorCard(
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
