import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:userapp/firebase_options.dart';

class FirebaseHelper {
  const FirebaseHelper._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> setupFirebase() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );
  }

  static Future<void> testHealth() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('checkHealth');

    final response = await callable.call();

    if (response.data != null) {
      debugPrint(response.data);
    }
  }

  static Future<void> _onBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint('we have received a notification ${message.notification}');
  }

  static Future<String?> uploadImage(File file) async {
    final storageRef = FirebaseStorage.instance.ref();
    Reference? imageRef = storageRef.child('images/token_image.jpg');

    try {
      await imageRef.putFile(file);
      return await imageRef.getDownloadURL();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<bool> sendNotification({
    required String title,
    required String body,
    required String token,
    String? image,
  }) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendNotification');

    try {
      final response = await callable.call(<String, dynamic>{
        'title': title,
        'body': body,
        'image': image,
        'token': token,
      });

      debugPrint('result is ${response.data ?? 'No data came back'}');

      if (response.data == null) return false;
      return true;
    } catch (e) {
      debugPrint('There was an error $e');
      return false;
    }
  }
}
