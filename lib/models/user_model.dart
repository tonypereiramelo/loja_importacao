import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_importacao/helpers/class_helpers.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void signUp(
      {required Map<String, dynamic> userData,
      required String pass,
      required VoidCallback onSucess,
      required FailLogin onFail}) {
    isLoading = true;
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((auth) async {
      user = auth.user!;
      await _saveUserData(userData);
      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      FailLogin();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn(
      {required String email,
      required String pass,
      required VoidCallback onSucess,
      required FailLogin onFail}) async {
    isLoading = true;
    notifyListeners();
    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      user = user;
      await _loadCurrentUser();
    }).catchError((e) {
      FailLogin();
      isLoading = false;
      notifyListeners();
    });

    onSucess();
    isLoading = false;
    notifyListeners();
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    user = null;

    notifyListeners();
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return user != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .set(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (user == null) user = _auth.currentUser;
    if (user != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .get();
        userData = docUser.data() as Map<String, dynamic>;
      }
    }
    notifyListeners();
  }
}
