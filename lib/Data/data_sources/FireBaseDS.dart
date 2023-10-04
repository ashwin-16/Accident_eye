import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class fbServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///Auth functions
  ///Register-User
  Future<bool> register(String email, String pass) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  ///SignIn-User
  Future<bool> login(String email, String pass) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  ///SignOut-User
  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // log('failed : $e');
    }
  }

  ///Check-CurrentUser-SignInStatus
  Future<bool> checkUserSignInStatus() async {
    try {
      final User? currentUser = _auth.currentUser;
      return currentUser != null;
    } catch (e) {
      return false;
    }
  }

  /// User-Crud functions
  /// Save user data with phone number as document ID
  Future<bool> saveuser(Map<String, dynamic> userData) async {
    final phoneNumber = userData['phoneNumber'];
    final userDocRef = _firestore.collection('users').doc(phoneNumber);

    try {
      await userDocRef.set(userData);
      return true;
    } catch (e) {
      return false;
    }
  }


}
