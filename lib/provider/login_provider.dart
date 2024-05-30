import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum AuthStatus { NOT_AUTHENTICATED, AUTHENTICADES, CHECKING }

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthStatus authStatus = AuthStatus.NOT_AUTHENTICATED;

  Future<void> login({
    required String email,
    required String password,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      authStatus = AuthStatus.CHECKING;
      notifyListeners();

      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('email', isEqualTo: email.toLowerCase())
          .limit(1)
          .get();

      if (!result.docs.isNotEmpty) {
        onError('No se encontro el usuario');
      }
      final UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      onSuccess(user);
    } catch (e) {
      onError(e.toString());
    }
  }
}
