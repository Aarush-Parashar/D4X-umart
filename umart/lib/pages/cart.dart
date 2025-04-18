import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:umart/models/add_to_cart.dart';
import 'package:umart/pages/tracking_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    // Razorpay event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clean up Razorpay instance
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
    );

    // Clear the cart after successful payment
    Provider.of<AddToCart>(context, listen: false).clearCart();
    // Redirect to Tracking Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TrackingScreen()),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("External Wallet Selected: ${response.walletName}")),
    );
  }

  void _startPayment(double amount) {
    var options = {
      'key': 'rzp_test_XFOAVzS1kujS5M', // Replace with your Razorpay API Key
      'amount': (amount * 100).toInt(), // Convert to paise
      'name': 'UMart',
      'description': 'Cart Purchase',
      'prefill': {'email': 'user@example.com', 'contact': '9999999999'},
      'theme': {'color': '#FF5722'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Razorpay Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<AddToCart>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: cart.cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (context, index) {
                final item = cart.cartItems[index];

                return ListTile(
                  leading: item["img"] != null
                      ? Image.asset(item["img"], width: 50, height: 50)
                      : const Icon(Icons.image_not_supported, size: 50),
                  title: Text(item["title"] ?? "No Name"),
                  subtitle: Text("₹${item["price"] ?? 0}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      cart.removeFromCart(index);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.cartItems.isEmpty
          ? const SizedBox.shrink()
          : Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Total Price Display
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "₹${cart.totalPrice()}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  // Checkout Button with Razorpay Integration
                  ElevatedButton(
                    onPressed: () {
                      _startPayment(cart.totalPrice());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text("Checkout with Razorpay",
                        style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
    );
  }
}
