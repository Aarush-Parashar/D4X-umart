import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Address extends StatefulWidget {
  final String? newAddress;

  const Address({super.key, this.newAddress});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  List<String> userAddresses = [];
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAddresses();

    // Add the new address if provided (after the widget is built)
    if (widget.newAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _addAddress(widget.newAddress!);
      });
    }
  }

  Future<void> _loadAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userAddresses = prefs.getStringList('user_addresses') ?? [];
    });
  }

  Future<void> _saveAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user_addresses', userAddresses);
  }

  void _addAddress(String address) {
    if (address.isNotEmpty && !userAddresses.contains(address)) {
      setState(() {
        userAddresses.add(address);
        _addressController.clear();
      });
      _saveAddresses();

      // Show confirmation snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Address saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _removeAddress(int index) {
    setState(() {
      userAddresses.removeAt(index);
    });
    _saveAddresses();
  }

  void _showAddAddressDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Address'),
        content: TextField(
          controller: _addressController,
          decoration: const InputDecoration(
            hintText: 'Enter address',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addAddress(_addressController.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Addresses"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddAddressDialog,
          ),
        ],
      ),
      body: userAddresses.isEmpty
          ? const Center(
              child: Text(
                "No addresses saved yet.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: userAddresses.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(userAddresses[index]),
                    subtitle: index == 0
                        ? Text('Default address',
                            style: TextStyle(color: Colors.deepOrange))
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (index != 0)
                          IconButton(
                            icon: const Icon(Icons.home, color: Colors.blue),
                            onPressed: () {
                              // Set as default address
                              setState(() {
                                final address = userAddresses.removeAt(index);
                                userAddresses.insert(0, address);
                              });
                              _saveAddresses();
                            },
                            tooltip: 'Set as default',
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeAddress(index),
                          tooltip: 'Delete address',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
