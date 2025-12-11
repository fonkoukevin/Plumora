import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';

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
    if (_email.trim().isEmpty ||
        _password.trim().isEmpty ||
        _confirmPassword.trim().isEmpty) {
      errorMessage = 'Tous les champs obligatoires doivent être remplis.';
      notifyListeners();
      return;
    }

    if (_password.trim() != _confirmPassword.trim()) {
      errorMessage = 'Les mots de passe ne correspondent pas.';
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

      if (user == null) {
        errorMessage = 'Inscription impossible.';
        _snackbarService.showSnackbar(message: errorMessage!);
        return;
      }

      // 🔥 On crée le profil AppUser dans Firestore
      await _userService.syncUserFromFirebase(
        penName: _penName.isEmpty ? null : _penName,
      );

      _snackbarService.showSnackbar(
        message: 'Compte créé avec succès.',
      );

      // ✅ Puis on va directement au dashboard
      _navigationService.replaceWithHomeView();
    } catch (e) {
      errorMessage = "Impossible de créer le compte.";
      _snackbarService.showSnackbar(message: errorMessage!);
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  void goToLogin() {
    _navigationService.replaceWithLoginView();
  }
}
