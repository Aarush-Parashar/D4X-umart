import 'package:flutter/material.dart';

class AddToCart with ChangeNotifier {
  final List<Map<String,dynamic>> _cartItems =[];
   List<Map<String, dynamic>> get cartItems => _cartItems;
   // Add item to cart
  void addToCart(Map<String, dynamic> item) {
    _cartItems.add(item);
    notifyListeners();
  }

  // Remove item from cart
  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
double totalPrice() {
  return cartItems.fold(0, (sum, item) => sum + (item["price"] ?? 0));
}


}