import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/manuscript.dart';

class ManuscriptService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference get _manuscriptsRef =>
      _firestore.collection('manuscripts');

  String? get _currentUserId => _auth.currentUser?.uid;

  /// 🔥 Stream de tous les manuscrits de l'utilisateur connecté
  Stream<List<Manuscript>> watchMyManuscripts() {
    final uid = _currentUserId;
    if (uid == null) {
      // Si jamais pas connecté → stream vide
      return const Stream.empty();
    }

    return _manuscriptsRef
        .where('ownerId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      // Debug utile
      // print('Docs Firestore: ${snap.docs.length}');

      return snap.docs
          .map((doc) =>
              Manuscript.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  /// Création d'un nouveau manuscrit, retourne l'id
  Future<String> createManuscriptWithId({
    required String title,
    String? summary,
  }) async {
    final uid = _currentUserId;
    if (uid == null) {
      throw Exception('Utilisateur non connecté');
    }

    final now = DateTime.now();
    final doc = await _manuscriptsRef.add({
      'ownerId': uid,
      'title': title,
      'summary': summary,
      'status': ManuscriptStatus.writing,
      'chapterCount': 0,
      'avgRating': 0.0,
      'createdAt': now.toUtc().toIso8601String(),
      'updatedAt': now.toUtc().toIso8601String(),
    });

    return doc.id;
  }

  Future<Manuscript?> getManuscriptById(String id) async {
    final doc = await _manuscriptsRef.doc(id).get();
    if (!doc.exists) return null;
    return Manuscript.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }
}
