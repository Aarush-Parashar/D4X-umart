import 'package:flutter/material.dart';
import 'package:umart/services/auth_service.dart';
import 'package:umart/pages/landing_page.dart';

class LoginCheck extends StatelessWidget {
  final Widget child;

  const LoginCheck({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            ),
          );
        }

        final isLoggedIn = snapshot.data ?? false;

        if (isLoggedIn) {
          return child;
        } else {
          // Redirect to landing page if not logged in
          return const LandingPage();
        }
      },
    );
  }
}
