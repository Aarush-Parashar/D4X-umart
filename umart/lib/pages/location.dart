import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umart/pages/accountpages/address.dart';
import 'package:umart/pages/bottom_nav.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final TextEditingController _controller = TextEditingController();
  String locationMessage = "Try JP Nagar, Siri Gardenia, etc";
  List<dynamic> _places = [];

  // Fetch places based on search input
  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) return;

    final url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _places = json.decode(response.body);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location services are disabled."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check and request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locationMessage = "Permission denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationMessage = "Permission permanently denied.";
      });
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Convert lat & long to address
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];

    String address =
        "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

    setState(() {
      locationMessage = address;
    });

    // Show dialog to let user decide what to do with the address
    _showAddressOptionsDialog(address);
  }

  void _saveAddressAndContinue(String address, bool saveAddress) async {
    // If the user chooses to save the address
    if (saveAddress) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> addresses = prefs.getStringList('user_addresses') ?? [];

      // Only add if not already present
      if (!addresses.contains(address)) {
        addresses.add(address);
        await prefs.setStringList('user_addresses', addresses);
      }
    }

    // Navigate to bottom nav with selected address
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNav(address: address),
      ),
    );
  }

  // New method to show options for the address
  void _showAddressOptionsDialog(String address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Found'),
        content: Text('Address: $address\n\nWhat would you like to do?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _saveAddressAndContinue(address, false);
            },
            child: const Text('Use without saving'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _saveAddressAndContinue(address, true);
            },
            child: const Text('Save and continue'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to the Address page with the new address
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Address(newAddress: address),
                ),
              );
            },
            child: const Text('Manage all addresses'),
          ),
        ],
      ),
    );
  }

  // Navigate to address management screen
  void _navigateToAddressManager() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Address()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Select Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: _navigateToAddressManager,
            tooltip: 'Manage saved addresses',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your area or apartment name",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                      onTap: () {
                        _searchPlaces(_controller.text);
                      },
                      child: Icon(Icons.search)),
                  hintText: locationMessage,
                  hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: _getCurrentLocation,
                child: Row(
                  children: [
                    Icon(Icons.send, color: Colors.deepOrange),
                    SizedBox(width: 10),
                    Text(
                      "Use my current location",
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Divider(height: 2, color: Colors.grey),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _places.length,
                  itemBuilder: (context, index) {
                    final place = _places[index];
                    return ListTile(
                      title: Text(
                        place["display_name"],
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      onTap: () {
                        // Show options dialog for selected place
                        _showAddressOptionsDialog(place["display_name"]);
                      },
                    );
                  },
                ),
              ),
              // Add a section to show saved addresses
              FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return SizedBox();

                  final prefs = snapshot.data!;
                  final savedAddresses =
                      prefs.getStringList('user_addresses') ?? [];

                  if (savedAddresses.isEmpty) return SizedBox();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Saved Addresses",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: savedAddresses.length > 3
                              ? 3
                              : savedAddresses.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  _saveAddressAndContinue(
                                      savedAddresses[index], false);
                                },
                                child: Container(
                                  width: 200,
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        index == 0
                                            ? "Default"
                                            : "Address ${index + 1}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          savedAddresses[index],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: _navigateToAddressManager,
                        child: Text(
                          "View all addresses",
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
