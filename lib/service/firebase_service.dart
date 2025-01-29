import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  // シングルトン
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  Future<String?> getIDToken() async{
    final currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser == null) return "";
    return await currentUser.getIdToken();
  }

  Future<bool> register(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> deleteAccount() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser == null) return;
    await currentUser.delete();
  }
}

