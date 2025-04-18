import 'package:flutter/material.dart';

class MoneyGiftCards extends StatefulWidget {
  const MoneyGiftCards({super.key});

  @override
  State<MoneyGiftCards> createState() => _MoneyGiftCardsState();
}

class _MoneyGiftCardsState extends State<MoneyGiftCards> {
  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive calculations
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive padding and sizing
    double horizontalPadding = screenWidth * 0.025;
    double verticalPadding = screenHeight * 0.015;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 239, 239),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 239, 239),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Flexible text for smaller screens
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("MONEY & CASHBACKS",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth > 600 ? 20 : 16)),
                  ),
                ),
                Flexible(
                  child: RichText(
                      text: TextSpan(
                          text: "Powered by ",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: screenWidth > 600 ? 16 : 12),
                          children: [
                        TextSpan(
                            text: "RazorPay",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth > 600 ? 16 : 12))
                      ])),
                )
              ],
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Column(
                    children: [
                      // First Container (Available Balance)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: screenHeight * 0.3,
                            minHeight: screenHeight * 0.2),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.green,
                                    const Color.fromARGB(255, 2, 102, 54)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Available Balance",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize:
                                              screenWidth > 600 ? 30 : 22),
                                    ),
                                    Image.asset("assets/images/lg.png",
                                        height: screenWidth > 600 ? 60 : 40)
                                  ],
                                ),
                                Text(
                                  "\$ 0",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: screenWidth > 600 ? 28 : 20),
                                ),
                                const Divider(color: Colors.white),
                                const SizedBox(height: 10),
                                Text(
                                  "Cashbacks money can be used for all your orders accross categories\n(Food,Umart,Dineout & more)",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth > 600 ? 15 : 12),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Second Container (E-gift Vouchers)
                      Container(
                        height: screenHeight * 0.2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Share love through e-gift vouchers!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              screenWidth > 600 ? 20 : 16),
                                    ),
                                    Text(
                                      "Umart HDFC Bank credit card cashback will now credit directly\ninto statement.",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Buy a gift voucher ",
                                      style: TextStyle(
                                          color: Colors.deepOrange,
                                          fontSize: screenWidth > 600 ? 18 : 14,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Image.asset("assets/images/lg.png",
                                height: screenWidth > 600 ? 60 : 40),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Third Container (Major Update)
                      Container(
                        height: screenHeight * 0.12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Image.asset("assets/images/lg.png",
                                height: screenWidth > 600 ? 60 : 40),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Major update alert!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              screenWidth > 600 ? 20 : 16),
                                    ),
                                    Text(
                                      "Umart HDFC Bank credit card cashback will now credit directly\n into statement.",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Container
            Container(
              height: screenHeight * 0.15,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      height: 50,
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 4, 121, 64),
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          "ADD BALANCE",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth > 600 ? 18 : 14),
                        ),
                      ),
                    ),
                  ),
                  RichText(
                      text: TextSpan(
                          text: "Have a gift voucher? ",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: screenWidth > 600 ? 16 : 12),
                          children: [
                        TextSpan(
                            text: "Redeem Now",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 4, 121, 64),
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth > 600 ? 16 : 12))
                      ]))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
