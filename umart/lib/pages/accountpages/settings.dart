import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSmsEnabled = false;
  bool isWhatsappEnabled = false;
  bool isPipEnabled = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF1EFEF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "SETTINGS",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * 0.02),
            sectionTitle("RECOMMENDATIONS & REMINDERS"),
            settingsDescription(
              "Keep this on to receive offer recommendations & timely updates based on your interests.",
            ),
            settingSwitch("SMS", isSmsEnabled, (value) {
              setState(() => isSmsEnabled = value);
            }),
            settingSwitch("WHATSAPP", isWhatsappEnabled, (value) {
              setState(() => isWhatsappEnabled = value);
            }),
            SizedBox(height: screenHeight * 0.05),
            sectionTitle("PICTURE IN PICTURE MODE"),
            settingSwitch("Allow Picture in Picture Mode", isPipEnabled,
                (value) {
              setState(() => isPipEnabled = value);
            }),
            settingsDescription(
                "PIP mode allows you to live track your order in a small window pinned to one corner of your screen while you navigate to other apps or the home screen."),
            SizedBox(height: screenHeight * 0.05),
            sectionTitle("ACCOUNT DELETION"),
            deleteAccountOption(),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget settingsDescription(String text) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 15,
        ),
      ),
    );
  }

  Widget settingSwitch(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Switch(
            activeColor: Colors.deepOrange,
            inactiveTrackColor: Colors.grey[400],
            value: value,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }

  Widget deleteAccountOption() {
    return GestureDetector(
      onTap: () {}, // Implement delete action
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Delete Account",
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
