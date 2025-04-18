import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:umart/pages/location.dart';
import 'package:umart/services/auth_service.dart';
import 'package:umart/pages/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  final String phone;
  const Otp({super.key, required this.phone});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  int _secondsRemaining = 30;
  Timer? _timer;
  bool showBottomSheet = false;
  bool _isVerifying = false;

  void _verifyOTP(String code) async {
    if (_isVerifying) return; // Prevent multiple verification attempts

    if (code.length == 6) {
      setState(() {
        _isVerifying = true;
      });

      try {
        // Save login information
        await AuthService.saveLoginInfo(widget.phone);

        // Check if user already has an address
        final prefs = await SharedPreferences.getInstance();
        final addresses = prefs.getStringList('user_addresses') ?? [];

        if (addresses.isNotEmpty) {
          // User already has address, go directly to home
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => BottomNav(address: addresses[0]),
              ),
              (route) => false, // Remove all previous routes
            );
          }
        } else {
          // User needs to set location first
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Location()),
              (route) => false, // Remove all previous routes
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${e.toString()}")),
          );
          setState(() {
            _isVerifying = false;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter a 6-digit verification code")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          showBottomSheet = true;
        });
      }
    });
  }

  void _startTimer() {
    _secondsRemaining = 30;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _resendCode() {
    if (_secondsRemaining == 0) {
      // Here you would actually call your SMS/OTP service
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification code resent")),
      );
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !_isVerifying; // Prevent back navigation during verification
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/s.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              bottom: showBottomSheet ? 0 : -300,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.76,
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
                          "Enter verification code",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Sent to ${widget.phone}",
                              style: const TextStyle(fontSize: 20),
                            ),
                            IconButton(
                                onPressed: () {
                                  if (!_isVerifying) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                icon: const Icon(
                                  Icons.edit_note,
                                  color: Colors.deepOrange,
                                ))
                          ],
                        ),
                        const SizedBox(height: 20),
                        Pinput(
                          length: 6,
                          onCompleted: _verifyOTP,
                          enabled: !_isVerifying,
                          defaultPinTheme: PinTheme(
                              width: 56,
                              height: 56,
                              textStyle: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              )),
                          focusedPinTheme: PinTheme(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.deepOrange))),
                        ),
                        if (_isVerifying)
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: Colors.deepOrange),
                            ),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: "Get verification code again in",
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black54),
                                children: [
                              TextSpan(
                                  text:
                                      " 00:${_secondsRemaining.toString().padLeft(2, '0')}",
                                  style:
                                      const TextStyle(color: Colors.deepOrange))
                            ])),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width / 2.2,
                              decoration: BoxDecoration(
                                color: _secondsRemaining == 0 && !_isVerifying
                                    ? Colors.deepOrange
                                    : const Color.fromARGB(255, 207, 206, 206),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: _isVerifying ? null : _resendCode,
                                  child: Text(
                                    "Get via SMS",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: _secondsRemaining == 0 &&
                                                !_isVerifying
                                            ? Colors.white
                                            : Colors.black54),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width / 2.2,
                              decoration: BoxDecoration(
                                color: _secondsRemaining == 0 && !_isVerifying
                                    ? Colors.deepOrange
                                    : const Color.fromARGB(255, 207, 206, 206),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: _isVerifying ? null : _resendCode,
                                  child: Text(
                                    "Get via Call",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: _secondsRemaining == 0 &&
                                              !_isVerifying
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
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
