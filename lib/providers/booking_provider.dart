import 'package:flutter/material.dart';
import 'package:userapp/models/request_model.dart';

class BookingProvider extends ChangeNotifier {

  Future<List<RequestModel>>? _passengerListFuture;
  Future<List<RequestModel>>? get passengerListFuture => _passengerListFuture;
  set passengerListFuture(value) {
    _passengerListFuture = value;
    notifyListeners();
  }

}
