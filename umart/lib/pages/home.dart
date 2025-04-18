import 'dart:async';
import 'package:flutter/material.dart';
import 'package:umart/pages/cart.dart';
import 'package:umart/pages/components/category_section.dart';
import 'package:umart/pages/components/horizontal_List.dart';
import 'package:umart/pages/location.dart';

class Home extends StatefulWidget {
  final String address;
  const Home({super.key, required this.address});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> items = ["Flowers", "Chocolates", "Roses", "Gifts", "Teddy"];
  int currentIndex = 0;
  late Timer timer;
  String selectedCategory = "All"; // Default selected category

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      setState(() {
        currentIndex = (currentIndex + 1) % items.length;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // Handle category selection
  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(120),
                        color: const Color.fromARGB(255, 216, 214, 214),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(120),
                        child: Image.asset(
                          "assets/images/lg.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => Location())),
                          child: Text(
                            "Location",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: const Color.fromARGB(255, 99, 97, 97),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 18,
                            ),
                            SizedBox(
                              width: 150, // Adjust width as needed
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  widget.address,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(120),
                          color: const Color.fromARGB(255, 216, 214, 214),
                        ),
                        child: Icon(Icons.shopping_cart),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(255, 197, 195, 195)
                        .withOpacity(0.2),
                    filled: true,
                    hintText: 'Search for "${items[currentIndex]}"',
                    hintStyle: TextStyle(color: Colors.grey.shade700),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Icon(Icons.sort),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              // Updated CategoriesSection with selected category
              CategoriesSection(
                onCategorySelected: onCategorySelected,
                selectedCategory: selectedCategory,
              ),
              SizedBox(height: 5),

              // Show promotional banner for all categories
              _buildPromotionalBanner(),

              // Show horizontal list with offers filtered by category
              HorizontalList(selectedCategory: selectedCategory),
            ],
          ),
        ),
      ),
    );
  }

  // Extracted promotional banner to a separate method
  Widget _buildPromotionalBanner() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage("assets/images/f.jpg"),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, -8),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        Positioned(
          top: 40,
          left: 50,
          child: Text(
            "New recipe",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 34,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          top: 80,
          left: 50,
          child: Text(
            "When you order 10% Off\nAutomatically applied.",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          top: 130,
          left: 50,
          child: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                "Order Now",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        )
      ],
    );
  }
}
