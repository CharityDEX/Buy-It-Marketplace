import 'package:eatit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:eatit/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatit/chat_card.dart';
import 'package:eatit/pages/cart_page.dart';
import 'package:eatit/pages/home_page.dart';
import 'package:eatit/pages/search_page.dart';
import 'package:eatit/pages/profile_page.dart';
import 'package:eatit/pages/seller_info.dart';

class ChatScreen extends StatefulWidget {
  final snap;
  final String sellerPicURL;
  final String sellerName;
  final String productName;
  final String productUrl;
  final String productPrice;
  final String sid;
  const ChatScreen({super.key, required this.snap, required this.sellerPicURL, required this.sellerName, required this.productName, required this.productUrl, required this.productPrice, required this.sid});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _chatController.dispose();
  }

  String userName = "";
  String userPicURL = "";

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    final userDocumentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      userName = userDocumentSnapshot['userName'];
      userPicURL = userDocumentSnapshot['profilePic'];
    });
  }

  Future<void> _sendMessage() async {
    if (_chatController.text.isEmpty) {
      showSnackbar(context, Colors.red, "Please enter a message");
    } else {
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).postChat(widget.snap['oid'], _chatController.text, FirebaseAuth.instance.currentUser!.uid, userName, userPicURL);
      setState(() {
        _chatController.text = "";
      });
    }
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

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child:CircleAvatar(
                      backgroundImage: NetworkImage(widget.sellerPicURL),
                      radius: 24,
                    ),
                    onTap: () {
                      nextScreen(context, SellerInfoPage(sid: widget.sid));
                    },
                    ),
                    const SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                     child: Text(widget.sellerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                     onTap: () {
                       nextScreen(context, SellerInfoPage(sid: widget.sid));
                     },
                    ),
                    Text(widget.productName, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(
                  height: 50,
                  child: VerticalDivider(color: Color(0xff6A7769), thickness: 1),
                ),
                Column(
                  children: [
                    Image.network(widget.productUrl, height: 40, width: 40, fit: BoxFit.cover),
                    Text("£${widget.productPrice}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                  ],
                ),
                const SizedBox(width: 1,),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('orders').doc(widget.snap['oid']).collection('chats').orderBy('datePublished').snapshots(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => ChatCard(
                    snap: (snapshot.data! as dynamic).docs[index].data(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userPicURL),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _chatController,
                    decoration: const InputDecoration(
                      hintText: "Start writing a message...",
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _sendMessage,
                child: const Icon(Icons.arrow_upward_sharp, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
