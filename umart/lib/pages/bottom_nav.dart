import 'package:flutter/material.dart';
import 'package:umart/pages/account.dart';
import 'package:umart/pages/categories.dart';
import 'package:umart/pages/home.dart';

class BottomNav extends StatefulWidget {
  final String address;
  const BottomNav({super.key, required this.address});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> page;
  int selectedIndex = 0;
  @override
  void initState() {
    page = [Home(address: widget.address), Categories(), Account()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        child: BottomNavigationBar(
            backgroundColor: Colors.white,
            iconSize: 35,
            elevation: 5,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            currentIndex: selectedIndex,
            onTap: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded,
                      color:
                          selectedIndex == 0 ? Colors.deepOrange : Colors.grey),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category,
                      color:
                          selectedIndex == 1 ? Colors.deepOrange : Colors.grey),
                  label: "Categories"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_outlined,
                      color:
                          selectedIndex == 2 ? Colors.deepOrange : Colors.grey),
                  label: "Account"),
            ]),
      ),
      body: page[selectedIndex],
    );
  }
}
