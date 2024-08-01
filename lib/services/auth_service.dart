import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:userapp/models/profile_model.dart';

class AppUser {
  AppUser({
    required this.uid,
  });
  final String uid;
}

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class AuthService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<ProfileModel?> getCurrentUser(String userId) async {
    try {
      var user = await firestore.collection('users').doc(userId).get();
      if (user.exists) {
        return ProfileModel.fromJson((user.data() ?? {}));
      } else {
        throw Exception("User could not found");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future setDeviceToken(String userId, String deviceToken) async {
    try {
      firestore
          .collection("users")
          .doc(userId)
          .set({"deviceToken": deviceToken}, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e);
    }
  }
  static Future deleteUser(String userId) async {
    try {
      firestore
          .collection("users")
          .doc(userId).delete();
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
  //-----------------------------------------------------------------------------------------------------
  // static Future<String> signIn(String email, String password) async {
  //   User? user = (await FirebaseAuth.instance
  //           .signInWithEmailAndPassword(email: email, password: password))
  //       .user;
  //   return user.uid;
  // }

  // static Future<String> signUp(
  //     {@required String email,
  //     @required String password,
  //     @required String name,
  //     @required String surname,
  //     @required String gender,
  //     @required String dob}) async {
  //   var user = (await FirebaseAuth.instance
  //           .createUserWithEmailAndPassword(email: email, password: password))
  //       .user;
  //   if (user == null) {
  //     throw FirebaseAuthException(code: "1");
  //   }
  //   var profileVariables = UserProfileVariables(
  //       email: email,
  //       currentUserId: user.uid,
  //       name: name,
  //       surname: surname,
  //       dob: dob,
  //       gender: gender);
  //   var newValues = UserProfileVariables().toJson(profileVariables);
  //   FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   String collection = 'users';
  //   _firestore.collection(collection).doc(user.uid).set(newValues);

  //   return user.uid;
  // }

  static Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  static Future<User> getCurrentFirebaseUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw FirebaseAuthException(code: "1");
    }
    return user;
  }

  static Future<bool> checkUserExist(String userID) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance.doc("users/$userID").get().then((doc) {
        if (doc.exists) {
          exists = true;
        } else {
          exists = false;
        }
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static changePassword(String password) async {
    //Create an instance of the current user.
    var user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw FirebaseAuthException(code: "1");
    }
    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Succesfull changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  static Future<bool> updateProfilePicture(
      String userId, String profileUrl) async {
    try {
      await firestore.collection("users").doc(userId).set(
        {"profileUrl": profileUrl},
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      print(
        e.toString(),
      );
      return false;
    }
  }

  static Future<ProfileModel?> updateProfile(
    String userId,
    String familyName,
    String name,
    String phoneNumber,
  ) async {
    try {
      await firestore.collection("users").doc(userId).set(
        {"name": name, "familyName": familyName, "phoneNumber": phoneNumber},
        SetOptions(merge: true),
      );
      return await getCurrentUser(userId);
    } catch (e) {
      print(
        e.toString(),
      );
      return null;
    }
  }

  static Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      var response = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this e-mail not found.';
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
        case 'The email address is already in use by another account.':
          return 'Email address is already taken.';
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }
}
