import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../models/manuscript.dart';
import '../../../services/manuscript_service.dart';

class ReadingViewModel extends StreamViewModel<List<Manuscript>> {
  final _manuscriptService = locator<ManuscriptService>();

  @override
  Stream<List<Manuscript>> get stream =>
      _manuscriptService.watchPublicManuscripts();

  List<Manuscript> get manuscripts => data ?? [];
  bool get hasManuscripts => manuscripts.isNotEmpty;

  Manuscript? selected;

  void selectManuscript(Manuscript m) {
    selected = m;
    notifyListeners();
  }
}
