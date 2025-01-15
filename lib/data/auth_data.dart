import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_uygulama/data/firestore_data.dart';
//import 'package:firebase_core/firebase_core.dart';

abstract class AuthenticationDatasource {
  Future<void> register(String email, String password, String passwordConfirm);
  Future<void> login(String email, String password);
}

class AuthenticationRemote extends AuthenticationDatasource {
  @override
  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } catch (e) {
      print("Login Hatası:$e");
      rethrow;
    }
  }

  @override
  Future<void> register(
      String email, String password, String passwordConfirm) async {
    if (password == passwordConfirm) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        await FirestoreDatasource().createUser(email);
      } catch (e) {
        print("Register Hatası:$e");
        rethrow;
      }
    } else {
      throw Exception("Parolalar uyuşmuyor! Lütfen kontrol edin");
    }
  }
}
