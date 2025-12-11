import 'package:stacked/stacked.dart';
import 'package:plumora/app/app.locator.dart';
import 'package:plumora/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../services/auth_service.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Wait for Firebase to emit the initial auth state to avoid race conditions.
    _authService.firebaseAuthInstance.authStateChanges().listen((user) {
      if (user == null) {
        _navigationService.replaceWithLoginView();
      } else {
        _navigationService.replaceWithHomeView();
      }
    });
  }
}
