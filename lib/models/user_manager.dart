import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojadomdiegoapp/helpers/firebase_errors.dart';
import 'package:lojadomdiegoapp/models/users.dart';

class UserManager extends ChangeNotifier {

  UserManager(){
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  User user;

  bool _loading = false;
  bool get loading => _loading;

  bool get isLoggedIn => user != null;

  Future <void> signIn({User user, Function onFail, Function onSuccess}) async {
   try {
     loading = true;
     final AuthResult result = await auth.signInWithEmailAndPassword(
         email: user.email, password: user.senha);

     await _loadCurrentUser(firebaseUser: result.user);

     onSuccess();
   } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
   }
    loading = false;
  }

  Future<void> signUp ({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.senha);

      //this.user = result.user;

      user.id = result.user.uid;
      this.user = user;

       await user.saveData();

      onSuccess();
    } on PlatformException catch (e){
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  void signOut(){
    auth.signOut();
    user = null;
    notifyListeners();
  }

  set loading (bool value){
    _loading = value;
    notifyListeners();
  }

  Future <void> _loadCurrentUser ({FirebaseUser firebaseUser}) async {
   final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
   if (currentUser != null){
      final DocumentSnapshot docUser = await firestore.collection('user').document(currentUser.uid).get();
      user = User.fromDocument(docUser);
      print(user.name);
      notifyListeners();
   }
  }

}