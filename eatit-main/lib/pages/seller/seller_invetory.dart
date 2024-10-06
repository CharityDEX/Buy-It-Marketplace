import 'package:eatit/pages/seller/add_product.dart';
import 'package:eatit/pages/seller/inventory_card.dart';
import 'package:flutter/material.dart';
import 'package:eatit/pages/profile_page.dart';
import 'package:eatit/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatit/pages/cart_page.dart';
import 'package:eatit/pages/home_page.dart';
import 'package:eatit/pages/search_page.dart';
import 'seller_order_card.dart';

class SellerInventoryPage extends StatefulWidget {
  const SellerInventoryPage({super.key});

  @override
  State<SellerInventoryPage> createState() => _SellerInventoryPageState();
}

class _SellerInventoryPageState extends State<SellerInventoryPage> {
  String sid = "";
  String sortBy = 'recency';
  bool deletion = false;

  @override
  void initState() {
    getSellerData();
    super.initState();
  }

  getSellerData() async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      sid = documentSnapshot['sid'];
    });
    final sellerDocumentSnapshot = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(sid)
        .get();
    setState(() {
      deletion = sellerDocumentSnapshot['deletion'];
    });
  }

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isNarrow = constraints.maxWidth < 600;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {
                        nextScreen(context, const ProfilePage());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
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
                    Padding(
                      padding: EdgeInsets.only(left: isNarrow ? 20 : 20, right: isNarrow ? 20 : 70),
                      child: Text(
                        "Inventory",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isNarrow ? 24 : 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.only(left: isNarrow ? 20 : 80),
                  child: Text(
                    "Last Selling",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isNarrow ? 18 : 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: isNarrow
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: isNarrow ? constraints.maxWidth * 0.9 : 1100,
                      height: isNarrow ? 200 : 350,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('orders')
                            .where('sid', isEqualTo: sid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.data!.docs.isEmpty) {
                            return Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset("assets/empty_cart.png",
                                          height: 175),
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
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(height: 50),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                          return ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index) => SellerOrderCard(
                                snap: snapshot.data!.docs[index].data()),
                          );
                        },
                      ),
                    ),
                    if (!isNarrow) const SizedBox(width: 50),
                    if (!isNarrow)
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .where('uid',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .where('isAvailable', isEqualTo: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              padding:
                                  const EdgeInsets.only(right: 100, bottom: 50),
                              width: 308,
                              height: 138,
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total items:",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff123113)),
                                      ),
                                      Text(
                                        "0",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff123113)),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Discounted:",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff123113)),
                                      ),
                                      Text(
                                        "0",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff123113)),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                ],
                              ),
                            );
                          }
                          final int totalItems = snapshot.data!.docs.length;
                          final int discountedItems = snapshot.data!.docs
                              .where((doc) => doc['isDiscounted'] == true)
                              .length;
                          return Container(
                            padding:
                                const EdgeInsets.only(right: 100, bottom: 50),
                            width: 308,
                            height: 138,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total items:",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff123113)),
                                    ),
                                    Text(
                                      "$totalItems",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff123113)),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Discounted:",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff123113)),
                                    ),
                                    Text(
                                      "$discountedItems",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff123113)),
                                    ),
                                  ],
                                ),
                                const Divider(),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: isNarrow ? 20 : 60),
                  child: ElevatedButton(
                    onPressed: () {
                      deletion
                          ? showSnackbar(context, Colors.red,
                              "You can't add an item while your shop is pending deletion")
                          : nextScreen(context, const AddProductPage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XffA2CAA2),
                    ),
                    child: const Text(
                      '+ Add Item',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff123113)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                SizedBox(
                  height: isNarrow ? 300 : 500,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where('uid',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .where('isAvailable', isEqualTo: true)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
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
                                  Image.asset("assets/empty_cart.png",
                                      height: 175),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Inventory Empty",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade900,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Add products to your inventory and start selling!",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return GridView.builder(
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isNarrow ? 2 : 4,
                          childAspectRatio: 1.0,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => InventoryCard(
                          snap: snapshot.data!.docs[index].data(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
