import 'package:eatit/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:eatit/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'seller_order_card.dart';
import 'package:eatit/pages/cart_page.dart';
import 'package:eatit/pages/home_page.dart';
import 'package:eatit/pages/search_page.dart';

class CompletedOrders extends StatefulWidget {
  final String sid;
  const CompletedOrders({super.key, required this.sid});

  @override
  State<CompletedOrders> createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isNarrow = constraints.maxWidth < 600;

              return Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            child: const Text(
                              "Buy It",
                              style: TextStyle(
                                color: Color(0xff415141),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: () {
                              nextScreen(context, const HomePage());
                            },
                          ),
                          const SizedBox(width: 16.0),
                          if (!isNarrow)
                            GestureDetector(
                              onTap: () {
                                nextScreen(context, const SearchPage());
                              },
                              child: Container(
                                width: 220,
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: const Color(0xffF8F8F8),
                                  border: Border.all(color: const Color(0xffF8F8F8)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      "e.g. Mesh shopping bag",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (isNarrow)
                            IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: Color(0xff415141),
                                size: 24,
                              ),
                              onPressed: () {
                                nextScreen(context, const SearchPage());
                              },
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.tag_faces_outlined,
                                  color: Color(0xff171717),
                                  size: 27,
                                ),
                                onPressed: () {
                                  nextScreen(context, const ProfilePage());
                                },
                              ),
                              const Text(
                                "Profile",
                                style: TextStyle(
                                  color: Color(0xff171717),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16.0),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Color(0xff171717),
                                  size: 27,
                                ),
                                onPressed: () {
                                  nextScreen(context, const CartPage());
                                },
                              ),
                              const Text(
                                "Cart",
                                style: TextStyle(
                                  color: Color(0xff171717),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),

    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 30,),
            GestureDetector(
                  onTap: () {
                    nextScreen(context, const ProfilePage());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: const Color(0XffECF4EC),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Color(0xff123113),
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),

            const Padding(
            padding: EdgeInsets.only(left: 20, right: 70),
            child: Text(
              "Sellings History",
              style: TextStyle(
                color: Colors.black, // Adjust your color
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ],
        ),
        const SizedBox(height: 10,),
        Expanded(
          child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('orders').where('sid', isEqualTo: widget.sid).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.docs.isEmpty) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("assets/empty_cart.png", height: 175),
                        const SizedBox(height: 20),
                        Text(
                          "No completed Orders",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "You have not completed an order yet.",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
              SellerOrderCard(snap: snapshot.data!.docs[index].data()),
            );
          },
          ),
        ),
      ],
    ),
    );
  }
}