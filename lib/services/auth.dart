import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // utk store data di cloud firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // utk otentikasi
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // utk signup
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Terjadi Error";
    try {
      // utk otentikasi firebase register user (email, password)
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // nambahin user ke firestore
      await _firestore.collection("users").doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'uid': credential.user!.uid,
      });
      res = "Berhasil";
    } catch (e) {
      print(e.toString());
    }
    return res;
  }
}
