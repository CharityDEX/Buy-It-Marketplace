import 'package:eatit/pages/buy.dart';
import 'package:eatit/pages/cart_card.dart';
import 'package:flutter/material.dart';
import 'package:eatit/pages/profile_page.dart';
import 'package:eatit/widgets/widgets.dart';
import 'package:eatit/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'search_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _cartStream;
  Map<String, int> _orderQuantities = {};

  @override
  void initState() {
    super.initState();
    _cartStream = FirebaseFirestore.instance
        .collection('products')
        .where('cart', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .where('isAvailable', isEqualTo: true)
        .snapshots();
  }

  void _updateOrderQuantity(String productId, int quantity) {
    setState(() {
      _orderQuantities[productId] = quantity;
    });
  }

  num _calculateTotalPrice(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    num totalPrice = 0;
    if (snapshot.hasData) {
      for (var doc in snapshot.data!.docs) {
        int orderQuantity = _orderQuantities[doc.id] ?? 1;
        doc['isDiscounted']? totalPrice += (doc['discountedPerice'] ?? 0) * orderQuantity:
        totalPrice += (doc['price'] ?? 0) * orderQuantity;
      }
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Determine if the screen is narrow or wide
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: StreamBuilder(
                        stream: _cartStream,
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          int totalItems = 0;

                          if (snapshot.hasData) {
                            totalItems = snapshot.data!.docs.length;
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  snapshot.data!.docs.isEmpty==false?
                                  const Text(
                                    'Cart',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ):
                                  Container(),
                                  const SizedBox(width: 10,),
                                  snapshot.data!.docs.isEmpty==false?
                                  Text(
                                    totalItems.toString(),
                                    style: const TextStyle(
                                      color: Color(0xffBEBEBE),
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ):
                                  Container(),
                                ],
                              ),
                              isNarrow?
                              const Text("It may take up to 5 minutes for orders to reflect in your account.", style: TextStyle(fontSize: 10,
                                  fontWeight: FontWeight.w500, color: Colors.red),
                                  ):
                                const Text("It may take up to 5 minutes for orders to reflect in your account.", style: TextStyle(fontSize: 15,
                                  fontWeight: FontWeight.w500, color: Colors.red),
                                  ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _cartStream,
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Cart is empty",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Explore our products from different categories and add them to your cart.",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  width: 168,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ElevatedButton(onPressed: (){
                                nextScreenReplace(context, HomePage());
                              }, style: ElevatedButton.styleFrom(
                               backgroundColor: const Color(0XffA2CAA2),
                              ),
                              child: const Text('Explore Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),)
                              ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    int totalItems = snapshot.data!.docs.length;
                    num totalPrice = _calculateTotalPrice(snapshot);
                    return isNarrow
                        ? Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) =>
                                      CartCard(
                                        snap: snapshot.data!.docs[index].data(),
                                        onQuantityChanged: (quantity) {
                                          _updateOrderQuantity(snapshot.data!.docs[index].id, quantity);
                                        },
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF8F8F8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Total',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                '£${(totalPrice).toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          const Text(
                                      "Fees are included in item price.",
                                      style: TextStyle(
                                          fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                          const SizedBox(height: 16.0),
                                          Container(
                                            width: double.infinity,
                                            height: 46,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffF8F8F8),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: ElevatedButton(
                                              onPressed: totalItems != 0
                                                  ? () {
                                                      nextScreen(
                                                          context,
                                                          BuyPage(totalItems: totalItems, totalPrice: totalPrice, orderQuantities: _orderQuantities));
                                                    }
                                                  : null,
                                              child: Text('Proceed to checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0XffA2CAA2)
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) =>
                                      CartCard(
                                        snap: snapshot.data!.docs[index].data(),
                                        onQuantityChanged: (quantity) {
                                          _updateOrderQuantity(snapshot.data!.docs[index].id, quantity);
                                        },
                                      ),
                                ),
                              ),
                              SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 800, right: 30,),
                                  child: Container(
                                    width: 416,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF8F8F8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Total',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  '£${(totalPrice).toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10.0),
                                            const Text(
                                        "Fees are included in item price.",
                                        style: TextStyle(
                                            fontSize: 12, fontWeight: FontWeight.w500),
                                      ),
                                            const SizedBox(height: 16.0),
                                            Container(
                                              width: 384,
                                              height: 46,
                                              decoration: BoxDecoration(
                                                color: const Color(0xffF8F8F8),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: ElevatedButton(
                                                onPressed: totalItems != 0
                                                    ? () {
                                                        nextScreen(
                                                            context,
                                                            BuyPage(totalItems: totalItems, totalPrice: totalPrice, orderQuantities: _orderQuantities));
                                                      }
                                                    : null,
                                                child: Text('Proceed to checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0XffA2CAA2)
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
