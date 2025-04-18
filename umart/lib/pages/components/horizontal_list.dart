import 'package:flutter/material.dart';

class HorizontalList extends StatefulWidget {
  final String selectedCategory;

  const HorizontalList({
    super.key,
    required this.selectedCategory,
  });

  @override
  State<HorizontalList> createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {
  final List<Map<String, dynamic>> allOffers = [
    {
      "name": "Fresh Fruits Bundle",
      "discount": "20%",
      "description": "Seasonal fruits pack",
      "image": "assets/images/fruits.jpg",
      "category": "Fresh"
    },
    {
      "name": "Organic Vegetables",
      "discount": "15%",
      "description": "Farm fresh vegetables",
      "image": "assets/images/vegetables.jpg",
      "category": "Fresh"
    },
    {
      "name": "Grocery Pack",
      "discount": "25%",
      "description": "Essential household items",
      "image": "assets/images/grocery.jpg",
      "category": "Grocery"
    },
    {
      "name": "Breakfast Bundle",
      "discount": "10%",
      "description": "Complete breakfast pack",
      "image": "assets/images/breakfast.jpg",
      "category": "Grocery"
    },
    {
      "name": "Smartphone Sale",
      "discount": "30%",
      "description": "Latest electronics",
      "image": "assets/images/smartphone.jpg",
      "category": "Electronics"
    },
    {
      "name": "Headphones",
      "discount": "40%",
      "description": "Premium sound quality",
      "image": "assets/images/headphones.jpg",
      "category": "Electronics"
    },
    {
      "name": "Makeup Kit",
      "discount": "35%",
      "description": "Complete beauty essentials",
      "image": "assets/images/makeup.jpg",
      "category": "Beauty"
    },
    {
      "name": "Skincare Bundle",
      "discount": "25%",
      "description": "Natural skincare products",
      "image": "assets/images/skincare.jpg",
      "category": "Beauty"
    },
  ];

  List<Map<String, dynamic>> get filteredOffers {
    if (widget.selectedCategory == "All") {
      return allOffers;
    } else {
      return allOffers
          .where((offer) => offer["category"] == widget.selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "${widget.selectedCategory} Offers",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.04),
          filteredOffers.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: screenWidth * 0.1,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "No offers available for ${widget.selectedCategory} category",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: screenWidth * 0.6,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredOffers.length,
                    itemBuilder: (context, index) {
                      final offer = filteredOffers[index];
                      return _buildOfferCard(offer, screenWidth);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer, double screenWidth) {
    return Container(
      width: screenWidth * 0.4, // Card width relative to screen size
      margin: EdgeInsets.only(right: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: screenWidth * 0.25,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    _getIconForCategory(offer["category"]),
                    size: screenWidth * 0.1,
                    color: Colors.grey.shade400,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "OFF ${offer["discount"]}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.03,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer["name"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.035,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  offer["description"],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenWidth * 0.03,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Order Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.03,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case "Fresh":
        return Icons.eco;
      case "Grocery":
        return Icons.shopping_basket;
      case "Electronics":
        return Icons.electrical_services;
      case "Beauty":
        return Icons.brush;
      default:
        return Icons.local_offer;
    }
  }
}
