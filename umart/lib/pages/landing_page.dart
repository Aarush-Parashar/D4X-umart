import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:umart/pages/otp.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String? phoneNumber;
  bool showBottomSheet = false;
  final TextEditingController phonecontroller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isValid = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          showBottomSheet = true;
        });
        _focusNode.requestFocus();
      }
    });

    phonecontroller.addListener(() {
      setState(() {
        isValid = phonecontroller.text.length == 10;
      });
    });
  }

  void navigateToOtpPage() async {
    // Prevent multiple taps
    if (_isProcessing) return;

    if (isValid && phoneNumber != null) {
      setState(() {
        _isProcessing = true;
      });

      try {
        // In a real app, you would make an API call here to send OTP
        // Simulate a brief delay for the API call
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Otp(phone: phoneNumber ?? ""),
            ),
          ).then((_) {
            // Reset processing state when returning to this screen
            if (mounted) {
              setState(() {
                _isProcessing = false;
              });
            }
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${e.toString()}")),
          );
          setState(() {
            _isProcessing = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    phonecontroller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        if (_isProcessing) return false;
        SystemNavigator.pop(); // Exit the app
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/s.jpeg',
                fit: BoxFit.cover,
              ),
            ),

            // Animated Bottom Sheet
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              bottom: showBottomSheet ? 0 : -300,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: const [
                    BoxShadow(blurRadius: 10, color: Colors.black26)
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Enter your number",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        IntlPhoneField(
                          focusNode: _focusNode,
                          controller: phonecontroller,
                          enabled: !_isProcessing,
                          decoration: InputDecoration(
                            labelText: "Mobile Number",
                            labelStyle:
                                const TextStyle(color: Colors.deepOrange),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Colors.deepOrange),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Colors.deepOrange),
                            ),
                          ),
                          initialCountryCode: 'IN',
                          onChanged: (phone) {
                            setState(() {
                              phoneNumber = phone.completeNumber;
                              isValid = phone.number.length == 10;
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _isProcessing ? null : navigateToOtpPage,
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: (isValid && !_isProcessing)
                                  ? Colors.deepOrange
                                  : Colors.grey,
                            ),
                            child: Center(
                              child: _isProcessing
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    )
                                  : const Text(
                                      "Continue",
                                      style: TextStyle(
                                          fontSize: 24, color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: const TextSpan(
                            text: "By Clicking, I accept the ",
                            style: TextStyle(color: Colors.black54),
                            children: [
                              TextSpan(
                                text: "terms of service",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: " and "),
                              TextSpan(
                                text: "privacy policy.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
