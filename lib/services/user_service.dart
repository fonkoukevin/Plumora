import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';

import '../models/app_user.dart';

class UserService with ListenableServiceMixin {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final ReactiveValue<AppUser?> _currentUser = ReactiveValue<AppUser?>(null);

  UserService() {
    listenToReactiveValues([_currentUser]);
  }

  CollectionReference get _usersRef => _firestore.collection('users');

  AppUser? get currentUser => _currentUser.value;
  bool get hasUser => _currentUser.value != null;

  /// À appeler après login ou register pour charger/initialiser le profil
  Future<void> syncUserFromFirebase({
    String? penName,
  }) async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) {
      _currentUser.value = null;
      return;
    }

    final doc = await _usersRef.doc(fbUser.uid).get();

    if (!doc.exists) {
      // Première connexion : on crée le profil dans Firestore
      final appUser = AppUser(
        id: fbUser.uid,
        email: fbUser.email ?? '',
        penName: penName,
        role: 'author', // par défaut
        createdAt: DateTime.now(),
      );

      await _usersRef.doc(fbUser.uid).set(appUser.toMap());
      _currentUser.value = appUser;
    } else {
      _currentUser.value = AppUser.fromMap(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    }
  }

  /// Recharge explicitement le user depuis Firestore (ex: après update profil)
  Future<void> reloadUser() async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) {
      _currentUser.value = null;
      return;
    }
    final doc = await _usersRef.doc(fbUser.uid).get();
    if (!doc.exists) return;
    _currentUser.value = AppUser.fromMap(
      doc.id,
      doc.data() as Map<String, dynamic>,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser.value = null;
  }
}
