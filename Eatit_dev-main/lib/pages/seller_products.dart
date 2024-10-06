import 'package:eatit_dev/pages/cart_page.dart';
import 'package:eatit_dev/pages/home_page.dart';
import 'package:eatit_dev/pages/product_card.dart';
import 'package:eatit_dev/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerProducts extends StatefulWidget {
  final String sid;
  const SellerProducts({super.key, required this.sid});

  @override
  State<SellerProducts> createState() => _SellerProducts();
}

class _SellerProducts extends State<SellerProducts> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey.shade200,
        title: Text("seller products", style: TextStyle(color: Colors.green.shade900, fontSize: 27,),),
      ),

    body: StreamBuilder(
    stream: FirebaseFirestore.instance.collection('products').where('sid', isEqualTo: widget.sid).where('isAvailable', isEqualTo: true).snapshots(),
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
                    "Nothing Here!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "This seller has no active product listing.",
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
        ProductCard(snap: snapshot.data!.docs[index].data()),
      );
    },
  ),

      bottomNavigationBar: BottomAppBar(
      color: Colors.indigoAccent.shade400,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, size: 32, color: Colors.white,),
            onPressed: () {
              nextScreen(context, const HomePage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, size: 32, color: Colors.white,),
            onPressed: () {
              nextScreen(context, const CartPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, size: 32, color: Colors.white,),
            onPressed: () {
              nextScreen(context, const ProfilePage());
            },
          ),
        ],
      ),
     ),
    );
  }
}