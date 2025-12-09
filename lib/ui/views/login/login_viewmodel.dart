import 'package:stacked/stacked.dart';

import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';

class LoginViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
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
    if (_email.isEmpty || _password.isEmpty) {
      errorMessage = 'Veuillez renseigner votre email et votre mot de passe.';
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

      if (user != null) {
        // Utilisateur connecté -> aller à l'écran principal
        _navigationService.replaceWithHomeView();
      }
    } on Exception {
      errorMessage = 'Connexion échouée. Vérifiez vos identifiants.';
      _snackbarService.showSnackbar(message: errorMessage!);
      // Option : logger l'erreur pour debug si nécessaire
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
