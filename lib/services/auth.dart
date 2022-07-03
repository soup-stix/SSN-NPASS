import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email = "";
  String _pass = "";
  String _type = "";
  // sign in email
  Future signinemail(String a, String b) async {
    _email = a;
    if (_email.contains("@ssn.edu.in") == false) {
      return 3;
    }
    _pass = b;
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _pass
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 1;
      } else if (e.code == 'wrong-password') {
        return 2;
      }
    }
    return 0;
  }
  //register email
  Future registeremail(String a, String b) async {
    _email = a;
    if (_email.contains(".ssn.edu.in") == false){
      return 12;
    }
    _pass = b;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _pass
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }
    return 0;
  }

  //signin via database
  Future signindatabase(String a, String b, String c) async{
    _email = a;
    if (_email.contains("@ssn.edu.in") == false) {
      return 3;
    }
    _pass = b;
    _type = c;
    final url = 'http://10.0.2.2:5000/login';
    final dynamic send = await http.post(Uri.parse(url),body:json.encode({'email':_email,'password':_pass,'type':_type}));
    final decoded = json.decode(send.body) as Map<String, dynamic>;
    print(decoded);
    return decoded['status'];
  }
  /*
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print(credential);
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }*/

}