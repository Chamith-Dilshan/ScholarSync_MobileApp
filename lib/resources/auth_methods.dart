import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //login users
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
       await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      }
      else{
        res ="Please Fill all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

//Logout user
  Future<void> logOut()async{
    await _auth.signOut();
  }
}
