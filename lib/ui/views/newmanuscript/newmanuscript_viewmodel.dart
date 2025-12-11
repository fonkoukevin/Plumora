import 'package:stacked/stacked.dart';

import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/manuscript_service.dart';

class NewmanuscriptViewModel extends BaseViewModel {
  final _manuscriptService = locator<ManuscriptService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  String _title = '';
  String _summary = '';
  String? errorMessage;
  void onTitleChanged(String value) {
    _title = value;
  }

  void onSummaryChanged(String value) {
    _summary = value;
  } // onTitleChanged, onSummaryChanged...

  Future<void> create() async {
    if (_title.trim().isEmpty) {
      // ...
      return;
    }

    setBusy(true);
    errorMessage = null;
    notifyListeners();

    try {
      await _manuscriptService.createManuscriptWithId(
        title: _title.trim(),
        summary: _summary.trim().isEmpty ? null : _summary.trim(),
      );

      _snackbarService.showSnackbar(
        message: 'Manuscrit créé avec succès.',
      );

      _navigationService.replaceWithHomeView();
    } catch (e) {
      errorMessage = 'Impossible de créer le manuscrit.';
      _snackbarService.showSnackbar(message: errorMessage!);
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  void cancel() {
    _navigationService.back();
  }
}
