import 'package:flutter/material.dart';

class HotDeals extends StatefulWidget {
  const HotDeals({super.key});

  @override
  State<HotDeals> createState() => _HotDealsState();
}

class _HotDealsState extends State<HotDeals> {
  final List<Map<String, dynamic>> hotDeals = [
    {
      "title": "Lay's Magic Masala",
      "image": "assets/images/lg.png",
      "weight": "48 g",
      "price": 20,
      "oldPrice": 30,
      "discount": 20,
      "deliveryTime": "12 mins",
    },
    {
      "title": "Supreme Harvest Sugar",
      "image": "assets/images/lg.png",
      "weight": "1 kg",
      "price": 55,
      "oldPrice": 80,
      "discount": 31,
      "deliveryTime": "12 mins",
    },
    {
      "title": "Potato (Aloo)",
      "image": "assets/images/lg.png",
      "weight": "1 kg",
      "price": 24,
      "oldPrice": 30,
      "discount": 20,
      "deliveryTime": "12 mins",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hot deals",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "See All >",
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 180, // Fixed height for list
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hotDeals.length,
              itemBuilder: (context, index) {
                final item = hotDeals[index];
                return _buildHotDealCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Single Item Card
Widget _buildHotDealCard(Map<String, dynamic> item) {
  return Container(
    width: 140, // Adjust width
    margin: const EdgeInsets.only(left: 10, right: 10),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image + Discount Label
        Stack(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Center(
                  child: Image.asset(item["image"],
                      height: 70, width: 100, fit: BoxFit.cover)),
            ),
            if (item["discount"] > 0)
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "${item["discount"]}% OFF",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 5),

        // Delivery Time
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                item["deliveryTime"],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),

        const SizedBox(height: 5),

        // Product Name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            item["title"],
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Weight
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            item["weight"],
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),

        const SizedBox(height: 5),

        // Price + Add Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹${item["price"]}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  if (item["oldPrice"] > item["price"])
                    Text(
                      "₹${item["oldPrice"]}",
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough),
                    ),
                ],
              ),

              // Add Button
              Container(
                height: 28,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    "ADD",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
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
