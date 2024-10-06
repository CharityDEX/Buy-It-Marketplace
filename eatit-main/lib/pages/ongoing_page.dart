import 'package:eatit/pages/cart_page.dart';
import 'package:eatit/pages/home_page.dart';
import 'package:eatit/pages/order_card.dart';
import 'package:eatit/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:eatit/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OngoingPage extends StatefulWidget {
  const OngoingPage({super.key});

  @override
  State<OngoingPage> createState() => _OngoingPageState();
}

class _OngoingPageState extends State<OngoingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey.shade200,
        title: Text("ongoing orders", style: TextStyle(color: Colors.green.shade900, fontSize: 27,),),
      ),

    body: StreamBuilder(
    stream: FirebaseFirestore.instance.collection('orders').where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).where('isCompleted', isEqualTo: false).snapshots(),
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
                    "All done!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "You have no ongoing orders.",
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
        reverse: true,
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) =>
        OrderCard(snap: snapshot.data!.docs[index].data()),
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