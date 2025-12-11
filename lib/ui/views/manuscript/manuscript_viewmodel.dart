import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../services/manuscript_service.dart';
import '../../../models/manuscript.dart';

class ManuscriptViewModel extends BaseViewModel {
  final _manuscriptService = locator<ManuscriptService>();
  final _navigationService = locator<NavigationService>();

  Manuscript? manuscript;

  /// Contrôleur pour la zone de texte d’écriture
  final TextEditingController contentController = TextEditingController();

  String? _manuscriptId;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  /// Appelé depuis la vue avec l’id passé par le router
  Future<void> init(String manuscriptId) async {
    _manuscriptId = manuscriptId;

    setBusy(true);
    manuscript = await _manuscriptService.getManuscriptById(manuscriptId);
    if (manuscript != null) {
      contentController.text = manuscript!.content;
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> saveContent() async {
    if (_manuscriptId == null || manuscript == null) return;

    _isSaving = true;
    notifyListeners();

    try {
      final newContent = contentController.text;

      await _manuscriptService.updateManuscriptContent(
        id: _manuscriptId!,
        content: newContent,
      );

      // on met à jour le modèle local
      manuscript = Manuscript(
        id: manuscript!.id,
        ownerId: manuscript!.ownerId,
        title: manuscript!.title,
        summary: manuscript!.summary,
        status: manuscript!.status,
        chapterCount: manuscript!.chapterCount,
        avgRating: manuscript!.avgRating,
        createdAt: manuscript!.createdAt,
        updatedAt: DateTime.now(),
        content: newContent,
      );
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void goBack() {
    _navigationService.back();
  }
}
