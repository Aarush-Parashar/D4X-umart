import 'package:flutter/material.dart';

class Offers extends StatefulWidget {
  const Offers({super.key});

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  int selectedCategory = 0;
  final List<Map<String, String>> categories = [
    {"img": "assets/images/lg.png", "title": "Top Deals"},
    {"img": "assets/images/lg.png", "title": "Bestsellers"},
    {"img": "assets/images/vegetable.png", "title": "Fruits & Vegetables"},
    {"img": "assets/images/bread.png", "title": "Munchies & Snacks"},
    {"img": "assets/images/oil.png", "title": "Drinks & Beverages"},
    {"img": "assets/images/cereal.png", "title": "Sweet Tooth"},
    {"img": "assets/images/bread.png", "title": "Electronics"},
    {"img": "assets/images/dried-fruits.png", "title": "Cooking Essentials"},
    {
      "img": "assets/images/dairy-products.png",
      "title": "Diary, Breads & Eggs"
    },
    {"img": "assets/images/lg.png", "title": "Min 30% off"}
  ];

  // Sample product list for each category
  final List<Map<String, String>> products = List.generate(
    8, // Total 8 items (2 columns x 4 rows)
    (index) => {
      "img": "assets/images/s.jpeg",
      "title": "Product ${index + 1}",
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 228, 228),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Best deals and free delivery",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "569 items",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                )
              ],
            ),
            Row(
              children: const [
                Icon(Icons.search, color: Colors.black54),
                SizedBox(width: 5),
                Icon(Icons.share_outlined, color: Colors.black54)
              ],
            )
          ],
        ),
      ),
      body: Row(
        children: [
          // Left Side - Categories
          Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5),
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  bool isActive = selectedCategory == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isActive
                                  ? const Color.fromARGB(255, 143, 13, 62)
                                  : const Color.fromARGB(255, 235, 233, 233),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Transform.scale(
                                scale: isActive ? 1.2 : 1.0,
                                child: Image.asset(categories[index]['img']!),
                              ),
                            ),
                          ),
                          Text(
                            categories[index]["title"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isActive
                                  ? const Color.fromARGB(255, 143, 13, 62)
                                  : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Right Side - Grid View
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GridView.builder(
                  itemCount: products.length, // 8 items in grid
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 columns
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8, // Adjust height/width ratio
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            child: Image.asset(
                              products[index]['img']!,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            products[index]['title']!,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Divider(
                            height: 2,
                          ),
                          Text(" \$10"),
                          Container(
                            height: 28,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Center(
                              child: Text(
                                "ADD",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
