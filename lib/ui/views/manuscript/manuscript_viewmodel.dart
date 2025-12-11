import 'package:stacked/stacked.dart';

import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../services/manuscript_service.dart';
import '../../../models/manuscript.dart';

class ManuscriptViewModel extends BaseViewModel {
  final _manuscriptService = locator<ManuscriptService>();
  final _navigationService = locator<NavigationService>();

  Manuscript? manuscript;

  Future<void> init(String manuscriptId) async {
    setBusy(true);
    manuscript = await _manuscriptService.getManuscriptById(manuscriptId);
    setBusy(false);

    notifyListeners();
  }

  void goBack() {
    _navigationService.back();
  }
}
