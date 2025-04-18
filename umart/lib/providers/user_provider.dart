import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userName = "AMAN BHANDARI";
  String _email = "amanbh@gmail.com";
  String _phoneNumber = "8171455246";

  // Getters
  String get userName => _userName;
  String get email => _email;
  String get phoneNumber => _phoneNumber;

  // Method to update user profile
  void updateUserProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    _userName = name;
    _email = email;
    _phoneNumber = phone;

    // Notify listeners to rebuild widgets that depend on this data
    notifyListeners();

    // Here you could also implement persistence (save to SharedPreferences or database)
  }
}
