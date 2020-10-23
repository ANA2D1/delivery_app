import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepo {
  final ref = Firestore.instance.collection("Users");
  UserModel _userModel;
  UserModel get user => this._userModel;
  StreamSubscription subscription;
  // BehaviorSubject<UserModel> _userStream = BehaviorSubject<UserModel>();

  // Stream<UserModel> get user$ => this._userStream.stream;

  set user(UserModel user) => this._userModel = user;

  UserRepo() {
    subscription = FirebaseAuth.instance.onAuthStateChanged.listen((event) {
      if (event != null) {
        getOrCreateUser(event).then((value) => this._userModel = value);
      } else {
        this._userModel = null;
      }
    });
  }

  Future<UserModel> getOrCreateUser(FirebaseUser fuser) async {
    final snap = await ref.document(fuser.uid).get();
    if (snap != null) {
      return UserModel.fromJson(snap.documentID, snap.data);
    } else {
      final user = UserModel(id: fuser.uid);
      await ref.document(user.id).setData(user.toJson());
      return user;
    }
  }

  void dispose() {
    subscription.cancel();
    // _userStream.close();
  }
}
