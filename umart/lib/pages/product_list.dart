import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umart/pages/cart.dart';
import 'package:umart/models/add_to_cart.dart';

class ProductList extends StatefulWidget {
  final String categoryName;
  const ProductList({super.key, required this.categoryName});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  int selectedCategory = 0;

  final List<Map<String, String>> categories = [
    {"img": "assets/images/lg.png", "title": "Top Deals"},
    {"img": "assets/images/lg.png", "title": "Bestsellers"},
    {"img": "assets/images/vegetable.png", "title": "Fruits & Vegetables"},
    {"img": "assets/images/bread.png", "title": "Munchies & Snacks"},
    {"img": "assets/images/oil.png", "title": "Drinks & Beverages"},
  ];

  final List<Map<String, dynamic>> products = List.generate(
    10,
    (index) => {
      "img": "assets/images/f.jpg",
      "title": "Product ${index + 1}",
      "price": 10.0,
    },
  );

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<AddToCart>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 228, 228),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            ),
            child: Stack(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.black54),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      cart.cartItems.length.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: screenWidth * 0.28,
            color: Colors.white,
            child: Column(
              children: categories.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> category = entry.value;
                bool isActive = selectedCategory == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = index),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.asset(category['img']!, height: 50, width: 50),
                        Text(
                          category['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isActive ? Colors.red : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = screenWidth < 600 ? 2 : 3;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio:
                          0.7, // Controls the height-to-width ratio
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(products[index], cart);
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, AddToCart cart) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.asset(
              product['img']!,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product['title']!,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text("\$${product['price']}",
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () => cart.addToCart(product),
                    child: const Text("ADD"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
