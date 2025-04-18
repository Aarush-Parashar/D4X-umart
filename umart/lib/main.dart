import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umart/pages/landing_page.dart';
import 'package:umart/models/add_to_cart.dart';
import 'package:umart/providers/user_provider.dart';
import 'package:umart/services/auth_service.dart';
import 'package:umart/pages/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Important for async operations
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AddToCart()),
      ChangeNotifierProvider(create: (_) => UserProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Umart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: FutureBuilder<bool>(
        future: AuthService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.deepOrange),
              ),
            );
          }

          final isLoggedIn = snapshot.data ?? false;

          if (isLoggedIn) {
            // If logged in, fetch the default address and go to BottomNav
            return FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, prefSnapshot) {
                if (!prefSnapshot.hasData) {
                  return const Scaffold(
                    body: Center(
                      child:
                          CircularProgressIndicator(color: Colors.deepOrange),
                    ),
                  );
                }

                final prefs = prefSnapshot.data!;
                final addresses = prefs.getStringList('user_addresses') ?? [];
                final defaultAddress = addresses.isNotEmpty
                    ? addresses[0]
                    : "Select your location";

                return BottomNav(address: defaultAddress);
              },
            );
          } else {
            // Not logged in, go to landing page
            return const LandingPage();
          }
        },
      ),
    );
  }
}
