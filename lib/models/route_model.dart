import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:userapp/models/driver_profile_model.dart';
import 'package:userapp/models/profile_model.dart';
import 'package:userapp/models/state_model.dart';

class RouteModel {
  final Timestamp startDate;
  final Timestamp endDate;
  final String to;
  final String from;
  final String remainingPassenger;
  final int maxPassengerCount;
  final int journeyDuration;
  final bool isActive;
  final bool isComplete;
  final String driverId;
  final String driverPlate;
  final DriverProfileModel profile;
  final String docId;
  final String pricePerPerson;
  RouteModel({
    required this.startDate,
    required this.endDate,
    required this.to,
    required this.from,
    required this.remainingPassenger,
    required this.maxPassengerCount,
    required this.journeyDuration,
    required this.isActive,
    required this.isComplete,
    required this.driverId,
    required this.driverPlate,
    required this.profile,
    required this.pricePerPerson,
    required this.docId,
  });
  factory RouteModel.fromJson(Map<String, dynamic> json, String docId) {
    return RouteModel(
      startDate: json['startDate'],
      endDate: json['endDate'],
      to: json["to"],
      from: json["from"],
      remainingPassenger: json['remainingPassenger'],
      maxPassengerCount: json['maxPassengerCount'],
      journeyDuration: json['journeyDuration'],
      isActive: json['isActive'],
      isComplete: json['isComplete'],
      driverPlate: json['driverPlate'],
      driverId: json['driverId'],
      pricePerPerson: json['pricePerPerson'],
      profile: DriverProfileModel.fromJson(json["profile"]),
      docId: docId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'to': to,
      'from': from,
      'remainingPassenger': remainingPassenger,
      'maxPAssengerCount': maxPassengerCount,
      'journeyDuration': journeyDuration,
      'isActive': isActive,
      'isComplete': isComplete,
      'driverPlate': driverPlate,
      'pricePerPerson': pricePerPerson,
      'driverId': driverId
    };
  }
}
