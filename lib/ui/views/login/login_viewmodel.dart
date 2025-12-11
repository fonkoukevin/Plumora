import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';

class LoginViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  String _email = '';
  String _password = '';
  String? errorMessage;

  void onEmailChanged(String value) {
    _email = value;
  }

  void onPasswordChanged(String value) {
    _password = value;
  }

  Future<void> login() async {
    if (_email.trim().isEmpty || _password.trim().isEmpty) {
      errorMessage = 'Email et mot de passe sont obligatoires.';
      notifyListeners();
      return;
    }

    setBusy(true);
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signInWithEmail(
        email: _email,
        password: _password,
      );

      if (user == null) {
        errorMessage = 'Connexion impossible.';
        _snackbarService.showSnackbar(message: errorMessage!);
        return;
      }

      // 🔥 On synchronise le AppUser (profil) depuis Firestore
      await _userService.syncUserFromFirebase();

      // ✅ Puis on va sur le dashboard
      _navigationService.replaceWithHomeView();
    } catch (e) {
      errorMessage = 'Échec de la connexion.';
      _snackbarService.showSnackbar(message: errorMessage!);
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  void goToRegister() {
    _navigationService.navigateToRegisterView();
  }

  void forgotPassword() {
    if (_email.isEmpty) {
      errorMessage =
          'Veuillez renseigner votre adresse email pour réinitialiser.';
      notifyListeners();
      return;
    }

    // Send reset email and show feedback
    _authService.sendPasswordResetEmail(email: _email).then((_) {
      _snackbarService.showSnackbar(
          message: 'Email de réinitialisation envoyé.');
    }).catchError((e) {
      _snackbarService.showSnackbar(message: 'Échec de l\'envoi.');
    });
  }
}
