import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:userapp/models/route_model.dart';
import 'package:userapp/models/state_model.dart';

class FilterService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static Future<List<RouteModel>> filterRoutes(
      DateTime? startDate, String from, String to, bool isAllTravel) async {
    try {
      List<RouteModel> routes = [];
      var response = await firestore
          .collection('routes')
          .where(Filter.and(
        Filter('from', isEqualTo: from),
        Filter('startDate', isGreaterThan: startDate),
        Filter('to', isEqualTo: to),
      ))
          .get();

      response.docs.forEach((element) {
        routes.add(RouteModel.fromJson(
          element.data(),
          element.id,
        ));
      });
      return routes;
    } catch (e) {
      debugPrint(e.toString());
      // throw Exception(e);
      return [];
    }
  }
}
