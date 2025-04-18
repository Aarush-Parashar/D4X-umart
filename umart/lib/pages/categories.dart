import 'package:flutter/material.dart';
import 'package:umart/pages/product_list.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  // Categories Section Data
  final List<Map<String, dynamic>> groceryCategories = [
    {"title": "Fresh Vegetables", "img": "assets/images/vegetable.png"},
    {"title": "Fresh Fruits", "img": "assets/images/fruit.png"},
    {
      "title": "Dairy, Bread and Eggs",
      "img": "assets/images/dairy-products.png"
    },
    {"title": "Cereals and Breakfast", "img": "assets/images/cereal.png"},
    {"title": "Atta Rice and Dals", "img": "assets/images/flour.png"},
    {"title": "Oils and Ghee", "img": "assets/images/oil.png"},
    {
      "title": "Masalas and Dry Fruits",
      "img": "assets/images/dried-fruits.png"
    },
    {"title": "Bakery", "img": "assets/images/bread.png"},
    {"title": "Biscuits and Cakes", "img": "assets/images/cereal.png"},
    {"title": "Tea, Coffee and More", "img": "assets/images/bread.png"},
    {"title": "Kitchen and Dining", "img": "assets/images/oil.png"},
    {"title": "Meat and Seafood", "img": "assets/images/vegetable.png"},
  ];

  final List<Map<String, dynamic>> snackCategories = [
    {"title": "Chips and Namkeens", "img": "assets/images/bread.png"},
    {"title": "Ice Cream and Desserts", "img": "assets/images/cereal.png"},
    {"title": "Chocolates and Sweets", "img": "assets/images/fruit.png"},
    {"title": "Cold Drinks and Juices", "img": "assets/images/lg.png"},
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen size and orientation
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;

    // Responsive grid parameters
    int crossAxisCount = _calculateCrossAxisCount(screenWidth);
    double childAspectRatio = _calculateChildAspectRatio(screenWidth);
    double verticalSpacing = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            title: Text(
              "Categories",
              style: TextStyle(
                fontSize: screenWidth * 0.065,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  size: screenWidth * 0.07,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Add search functionality
                },
              ),
            ],
          ),

          // Grocery & Kitchen Section
          _buildSectionSliverTitle("GROCERY & KITCHEN", screenWidth),
          _buildCategorySliverGrid(
            groceryCategories,
            crossAxisCount,
            childAspectRatio,
            verticalSpacing,
            screenWidth,
          ),

          // Snacks & Drinks Section
          _buildSectionSliverTitle("SNACKS & DRINKS", screenWidth),
          _buildCategorySliverGrid(
            snackCategories,
            crossAxisCount,
            childAspectRatio,
            verticalSpacing,
            screenWidth,
          ),

          // Additional Sections
          _buildSectionSliverTitle("FOODS & DISHES", screenWidth),
          _buildCategorySliverGrid(
            snackCategories,
            crossAxisCount,
            childAspectRatio,
            verticalSpacing,
            screenWidth,
          ),
          _buildSectionSliverTitle("FOODS & DISHES", screenWidth),
          _buildCategorySliverGrid(
            snackCategories,
            crossAxisCount,
            childAspectRatio,
            verticalSpacing,
            screenWidth,
          ),
          _buildSectionSliverTitle("FOODS & DISHES", screenWidth),
          _buildCategorySliverGrid(
            snackCategories,
            crossAxisCount,
            childAspectRatio,
            verticalSpacing,
            screenWidth,
          ),

          // Bottom padding sliver
          SliverToBoxAdapter(
            child: SizedBox(height: screenWidth * 0.05),
          ),
        ],
      ),
    );
  }

  // Dynamically calculate grid cross axis count based on screen width
  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth < 320) return 3; // Small phones
    if (screenWidth < 480) return 4; // Most phones
    if (screenWidth < 600) return 5; // Large phones
    if (screenWidth < 840) return 6; // Tablets
    return 8; // Large tablets and desktops
  }

  // Dynamically calculate child aspect ratio based on screen width
  double _calculateChildAspectRatio(double screenWidth) {
    if (screenWidth < 320) return 0.7; // Small phones
    if (screenWidth < 480) return 0.85; // Most phones
    if (screenWidth < 600) return 0.9; // Large phones
    if (screenWidth < 840) return 1.0; // Tablets
    return 1.1; // Large tablets and desktops
  }

  // Section Title Sliver with Divider
  SliverToBoxAdapter _buildSectionSliverTitle(
      String title, double screenWidth) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenWidth * 0.025,
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Divider(
                color: Colors.black54,
                thickness: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Category Sliver Grid
  SliverGrid _buildCategorySliverGrid(
    List<Map<String, dynamic>> categories,
    int crossAxisCount,
    double childAspectRatio,
    double verticalSpacing,
    double screenWidth,
  ) {
    return SliverGrid.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: screenWidth * 0.025,
      mainAxisSpacing: verticalSpacing,
      childAspectRatio: childAspectRatio,
      children: categories
          .map((category) => _buildCategoryItem(
                category["title"],
                category["img"],
                screenWidth,
              ))
          .toList(),
    );
  }

  // Category Item Card
  Widget _buildCategoryItem(String title, String imgPath, double screenWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductList(categoryName: title)));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: screenWidth * 0.2,
            width: screenWidth * 0.2,
            padding: EdgeInsets.all(screenWidth * 0.025),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F1F4),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset(imgPath, fit: BoxFit.contain),
          ),
          SizedBox(height: screenWidth * 0.02),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          )
        ],
      ),
    );
  }
}
