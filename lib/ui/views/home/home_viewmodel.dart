import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/user_service.dart';
import '../../../services/manuscript_service.dart';
import '../../../models/manuscript.dart';
import '../newmanuscript/newmanuscript_view.dart';
// manuscript view is navigated via generated route helper

class HomeViewModel extends StreamViewModel<List<Manuscript>> {
  final _userService = locator<UserService>();
  final _manuscriptService = locator<ManuscriptService>();
  final _navigationService = locator<NavigationService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_userService];

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
    _navigationService.navigateToView(const NewmanuscriptView());
  }

  void openManuscript(Manuscript manuscript) {
    _navigationService.navigateToManuscriptView(manuscriptId: manuscript.id);
  }

  void logout() {
    _userService.signOut();
    _navigationService.replaceWithLoginView();
  }

  // 👉 utilisé par le bottom nav de HomeView
  void goToProfile() {
    _navigationService.navigateToProfileView();
  }

  // 👉 utilisé par le bottom nav de ProfileView
  void goToHome() {
    _navigationService.replaceWithHomeView();
  }

  void goToReading() {
    // si tu as généré la route ReadingView dans app.router.dart :
    _navigationService.navigateToReadingView();
  }

  void goToBeta() {
    // TODO: quand tu feras l’écran bêta
  }

  void goToNotifs() {
    // TODO: plus tard
  }
}
