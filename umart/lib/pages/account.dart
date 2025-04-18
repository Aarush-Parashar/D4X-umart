import 'package:flutter/material.dart';
import 'package:umart/pages/accountpages/address.dart';
import 'package:umart/pages/accountpages/edit_profile.dart';
import 'package:umart/pages/accountpages/money_gift_cards.dart';
import 'package:umart/pages/accountpages/settings.dart';
import 'package:umart/pages/landing_page.dart';
import 'package:umart/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:umart/providers/user_provider.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logout icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.deepOrange,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Confirmation text
              const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Are you sure you want to logout from your account?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.deepOrange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close popup
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Logout Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close the dialog
                        await AuthService.logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LandingPage()),
                          (route) => false, // Remove all previous routes
                        );
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the user profile data from the provider
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 30,
              width: 60,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 237, 231),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text(
                  "Help",
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //profile details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userProvider.userName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  RichText(
                      text: TextSpan(
                          text: "+91 - ${userProvider.phoneNumber}",
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                          children: [
                        TextSpan(text: ' | '),
                        TextSpan(text: userProvider.email)
                      ])),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // Navigate to EditProfile and wait for result
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(
                            initialName: userProvider.userName,
                            initialEmail: userProvider.email,
                            initialPhone: userProvider.phoneNumber,
                          ),
                        ),
                      );

                      // Update the UI if we got updated profile data
                      if (result != null && result is Map<String, String>) {
                        userProvider.updateUserProfile(
                          name: result['name']!,
                          email: result['email']!,
                          phone: result['phone']!,
                        );
                      }
                    },
                    child: Text(
                      "Edit Profile >",
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              const Divider(
                color: Colors.black54,
                indent: 2,
                endIndent: 2,
                height: 3,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Settings()));
                  },
                  child: list("Settings", "Reminders & delete account")),
              const Divider(
                color: Colors.black54,
                indent: 2,
                endIndent: 2,
                height: 3,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Address()));
                  },
                  child: list("Addresses", "Edit & Add New Addresses")),
              const Divider(
                color: Colors.black54,
                indent: 2,
                endIndent: 2,
                height: 3,
              ),

              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MoneyGiftCards()));
                  },
                  child: list("Money & Gift Cards",
                      "Account balance, Gift cards & Transaction History")),
              const Divider(
                color: Colors.black54,
                indent: 2,
                endIndent: 2,
                height: 3,
              ),
              GestureDetector(
                  onTap: () {
                    _showLogoutConfirmation(context);
                  },
                  child: list("Logout", "Logout your account!"))
            ],
          ),
        ),
      ),
    );
  }

  Padding list(String text, String subtext) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                subtext,
                style: const TextStyle(color: Colors.grey),
              )
            ],
          ),
          const Text(
            ">",
            style: TextStyle(
                fontSize: 26, color: Colors.grey, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
