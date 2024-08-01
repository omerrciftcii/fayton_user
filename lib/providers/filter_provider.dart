import 'package:flutter/material.dart';
import 'package:userapp/models/route_model.dart';

class FilterProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  DateTime? _selectedStartDate;
  DateTime? get selectedStartDate => _selectedStartDate;
  set selectedStartDate(value) {
    _selectedStartDate = value;
    notifyListeners();
  }

  DateTime? _selectedEndDate;
  DateTime? get selectedEndDate => _selectedEndDate;
  set selectedEndDdate(value) {
    _selectedEndDate = value;
    notifyListeners();
  }

  Future<List<RouteModel>>? _filterRoutesFuture;
  Future<List<RouteModel>>? get filterRoutesFuture => _filterRoutesFuture;
  set filterRoutesFuture(value) {
    _filterRoutesFuture = value;
    notifyListeners();
  }
}
