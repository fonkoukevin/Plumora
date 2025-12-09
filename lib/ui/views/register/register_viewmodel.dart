import 'package:plumora/app/app.locator.dart';
import 'package:plumora/app/app.router.dart';
import 'package:plumora/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../services/user_service.dart';
import '../../../models/app_user.dart';

class RegisterViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _penName = '';

  String? errorMessage;

  void onEmailChanged(String value) => _email = value;
  void onPasswordChanged(String value) => _password = value;
  void onConfirmPasswordChanged(String value) => _confirmPassword = value;
  void onPenNameChanged(String value) => _penName = value;

  Future<void> register() async {
    // Validations de base
    if (_email.isEmpty || _password.isEmpty || _confirmPassword.isEmpty) {
      errorMessage = 'Veuillez remplir tous les champs obligatoires.';
      notifyListeners();
      return;
    }

    if (_password.length < 6) {
      errorMessage = 'Le mot de passe doit contenir au moins 6 caractères.';
      notifyListeners();
      return;
    }

    if (_password != _confirmPassword) {
      errorMessage = 'Les mots de passe ne correspondent pas.';
      notifyListeners();
      return;
    }

    // Validation basique d'email (regex simple)
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(_email)) {
      errorMessage = 'Veuillez entrer une adresse email valide.';
      notifyListeners();
      return;
    }

    setBusy(true);
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signUpWithEmail(
        email: _email,
        password: _password,
      );

      if (user != null) {
        // Création + chargement du profil AppUser
        await _userService.syncUserFromFirebase(
          penName: _penName.isEmpty ? null : _penName,
        );

        _snackbarService.showSnackbar(
          message: 'Compte créé avec succès. Bienvenue sur Plumora.',
        );

        _navigationService.replaceWithHomeView();
      }
    } catch (e) {
      errorMessage =
          "L'inscription a échoué. Essayez avec un autre email ou vérifiez votre connexion.";
      _snackbarService.showSnackbar(message: errorMessage!);
      // Débug en console si nécessaire : print(e);
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  void goToLogin() {
    _navigationService.replaceWithLoginView();
  }
}
