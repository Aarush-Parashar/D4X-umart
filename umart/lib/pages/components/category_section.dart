import 'package:flutter/material.dart';

class CategoriesSection extends StatefulWidget {
  final Function(String) onCategorySelected;
  final String selectedCategory;

  const CategoriesSection({
    super.key,
    required this.onCategorySelected,
    required this.selectedCategory,
  });

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  final List<Map<String, dynamic>> categories = [
    {"name": "All", "icon": Icons.shopping_bag, "img": "assets/images/all.png"},
    {
      "name": "Fresh",
      "icon": Icons.local_florist,
      "img": "assets/images/fresh.png"
    },
    {
      "name": "Grocery",
      "icon": Icons.local_grocery_store,
      "img": "assets/images/grocery.png"
    },
    {
      "name": "Electronics",
      "icon": Icons.headphones,
      "img": "assets/images/electronics.png"
    },
    {"name": "Beauty", "icon": Icons.brush, "img": "assets/images/beauty.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        height: 110,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category["name"] == widget.selectedCategory;
            return _buildCategoryItem(category, isSelected);
          },
        ),
      ),
    );
  }

  // Single Category Item
  Widget _buildCategoryItem(Map<String, dynamic> category, bool isSelected) {
    return GestureDetector(
      onTap: () {
        widget.onCategorySelected(category["name"]);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: isSelected
                  ? Colors.blue.withOpacity(0.3)
                  : const Color.fromARGB(255, 197, 195, 195).withOpacity(0.2),
              child: Icon(
                category["icon"],
                size: 30,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              category["name"],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
