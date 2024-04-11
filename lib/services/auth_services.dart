import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskforge/model/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<UserCredential?> registerUser(UserModel user) async {
    UserCredential userData = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: user.email.toString(), password: user.password.toString());

    if (userData != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userData.user!.uid)
          .set({
        'uid': userData.user!.uid,
        'email': userData.user!.email,
        'name': user.name,
        'createdAt': user.createdAt,
        'status': user.status
      });
      return userData;
    }
  }

//login
///////////////////
  Future<DocumentSnapshot?> loginUser(UserModel user) async {
    DocumentSnapshot snap;

    SharedPreferences _pref = await SharedPreferences.getInstance();

    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: user.email.toString(), password: user.password.toString());

    String? token = await userCredential.user!.getIdToken();

    if (userCredential != null) {
      snap = await _userCollection.doc(userCredential.user!.uid).get();

      await _pref.setString(('token'), token!);
      await _pref.setString(('name'), snap['name']);
      await _pref.setString(('email'), snap['email']);
      await _pref.setString(('uid'), snap['uid']);

      return snap;
    }
  }

  ///////////////////logout

  Future<void> logout() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    await _pref.clear();
    await _auth.signOut();
  }

  //is logged in

  Future<bool> isloggedin() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    String? _token = await _pref.getString('token');

    if (_token == null) {
      return false;
    } else {
      return true;
    }
  }
}



