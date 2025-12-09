import 'package:plumora/ui/views/manuscript/manuscript_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../services/user_service.dart';
import '../../../services/manuscript_service.dart';
import '../../../models/manuscript.dart';
import '../../../app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends StreamViewModel<List<Manuscript>> {
  final _userService = locator<UserService>();
  final _manuscriptService = locator<ManuscriptService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();

  String get displayName {
    final u = _userService.currentUser;
    if (u == null) return '';
    return (u.penName != null && u.penName!.isNotEmpty) ? u.penName! : u.email;
  }

  @override
  Stream<List<Manuscript>> get stream =>
      _manuscriptService.watchMyManuscripts();

  List<Manuscript> get manuscripts => data ?? const [];

  bool get hasManuscripts => manuscripts.isNotEmpty;

  Future<void> createNewManuscript() async {
    _navigationService.navigateToNewmanuscriptView();
  }

  Future<String?> _askForTitle() async {
    // MVP : on met un titre par défaut pour ne pas bloquer
    return 'Nouveau manuscrit';
  }

  void openManuscript(Manuscript manuscript) {
    _navigationService.navigateToView(
      ManuscriptView(manuscriptId: manuscript.id),
    );
  }

  void logout() {
    // Tu peux utiliser AuthService + UserService ici si tu veux
    _navigationService.replaceWithLoginView();
  }
}
