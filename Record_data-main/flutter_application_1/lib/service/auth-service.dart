import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<String?> registration({
    required String email,
    required String password,
    required String confirm,
  }) async {
    try {
      // ตรวจสอบว่าพาสเวิร์ดตรงกันและยาวอย่างน้อย 8 ตัวอักษร
      if (password != confirm) {
        return 'Passwords do not match';
      }
      if (password.length < 8) {
        return 'Password must be at least 8 characters long';
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signin({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}