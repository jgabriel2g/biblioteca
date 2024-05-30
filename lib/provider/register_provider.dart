import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Rol { STUDENT, TEACHER }

extension RolExtension on Rol {
  String get name => toString().split('.').last;
}

class RegisterProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser({
    required String email,
    required String password,
    required String fullName,
    required String identificationNumber,
    required String rol,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final bool isExist = await checkUserExist(email.toLowerCase());
      if (isExist) {
        onError('Ya existe un usuario con este correo');
      }

      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User user = userCredential.user!;

      final data = {
        'id': user.uid,
        'full_name': fullName,
        'identification_number': identificationNumber,
        'rol': rol,
        'email': email
      };
      await _firestore.collection('users').doc(user.uid).set(data);
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<bool> checkUserExist(String email) async {
    final QuerySnapshot result = await _firestore
        .collection('users')
        .where('email', isEqualTo: email.toLowerCase())
        .limit(1)
        .get();
    return result.docs.isNotEmpty;
  }
}
