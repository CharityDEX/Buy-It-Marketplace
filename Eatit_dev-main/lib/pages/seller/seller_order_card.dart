import 'package:eatit_dev/chat_screen.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatit_dev/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class SellerOrderCard extends StatefulWidget {
  final snap;
  const SellerOrderCard({super.key, required this.snap});

  @override
  State<SellerOrderCard> createState() => _SellerOrderCardState();
}

class _SellerOrderCardState extends State<SellerOrderCard> {
  String sellerPicURL = "";
  String buyerPicURL = "";
  String etsyBadgeURL = "";
  String userName = "";
  String productUrl = "";
  String title = "";
  String productType = "";
  String description = "";
  List likes = [];
  List dislikes = [];
  List cart = [];
  String sellerUID = "";
  String buyer = "";
  bool isAvailable = true;
  int reviewLen = 0;
  bool isUserNameExpanded = false;
  bool isTitleExpanded = false;

  @override
  void initState() {
    getProductData();
    getListValues();
    getReviews();
    super.initState();
  }

  getProductData() async {
    final productDocumentSnapshot = await FirebaseFirestore.instance.collection('products').doc(widget.snap['pid']).get();
    final buyerDocumentSnapshot = await FirebaseFirestore.instance.collection('users').doc(widget.snap['uid']).get();
    final userQuerySnapshot = await FirebaseFirestore.instance.collection('users').where('sid', isEqualTo: widget.snap['sid']).get();
    final userDocumentSnapshot = userQuerySnapshot.docs[0];
    setState(() {
      userName = productDocumentSnapshot['userName'];
      productUrl = productDocumentSnapshot['productUrl'];
      title = productDocumentSnapshot['title'];
      productType = productDocumentSnapshot['productType'];
      description = productDocumentSnapshot['description'];
      isAvailable = productDocumentSnapshot['isAvailable'];
      sellerPicURL = userDocumentSnapshot['profilePic'];
      etsyBadgeURL = userDocumentSnapshot['etsyBadge'];
      buyer = buyerDocumentSnapshot['userName'];
      buyerPicURL = buyerDocumentSnapshot['profilePic'];
      sellerUID = userDocumentSnapshot['uid'];
    });
  }

  getListValues() async {
    final productDocumentSnapshot = await FirebaseFirestore.instance.collection('products').doc(widget.snap['pid']).get();
    setState(() {
      likes = productDocumentSnapshot['likes'];
      dislikes = productDocumentSnapshot['dislikes'];
      cart = productDocumentSnapshot['cart'];
    });
  }

  void getReviews() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection('products').doc(widget.snap['pid']).collection('reviews').get();
      reviewLen = snap.docs.length;
    } catch (e) {
      showSnackbar(context, Colors.red, e.toString());
    }
    setState(() {});
  }

  String truncateText(String text, int limit) {
    if (text.length > limit) {
      return text.substring(0, limit) + '...';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isNarrowScreen = constraints.maxWidth < 600;

        return Card(
          margin: EdgeInsets.symmetric(
            horizontal: isNarrowScreen ? 10 : 60,
          ),
          color: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
                child: Text(
                  "Ordered: ${DateFormat.yMMMd().format(widget.snap['dateOrdered'].toDate())}",
                  style: TextStyle(
                    fontSize: isNarrowScreen ? 14 : 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
                child: Text(
                  "Delivering to: ${widget.snap['address']}",
                  style: TextStyle(
                    fontSize: isNarrowScreen ? 10 : 12,
                    color: const Color(0xff1E3010),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
                child: Text(
                  "ID: ${widget.snap['oid']}",
                  style: TextStyle(
                    fontSize: isNarrowScreen ? 10 : 12,
                    color: const Color(0xFF82A182),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // nextScreen(context, SellerInfoPage(sid: widget.snap['sid']));
                      },
                      child: ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: buyerPicURL,
                          height: isNarrowScreen ? 15 : 20,
                          width: isNarrowScreen ? 15 : 20,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(color: Theme.of(context).primaryColor),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.account_circle, size: 100, color: Colors.grey),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: GestureDetector(
                          onTap: () {
                            if (isNarrowScreen) {
                              setState(() {
                                isUserNameExpanded = !isUserNameExpanded;
                              });
                            }
                          },
                          child: Text(
                            isNarrowScreen && !isUserNameExpanded
                                ? truncateText(buyer, 12)
                                : buyer,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: isNarrowScreen ? 14 : 16,
                              color: const Color(0xff123113),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, right: 16.0, top: 16),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            if (widget.snap['isUserCompleted'] == false || widget.snap['isSellerCompleted'] == false)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isNarrowScreen ? 10.0 : 13.0,
                                  vertical: isNarrowScreen ? 3.0 : 5.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF514E97),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  'Packing',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isNarrowScreen ? 10 : 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            else
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isNarrowScreen ? 10.0 : 13.0,
                                  vertical: isNarrowScreen ? 3.0 : 5.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0XFFA2CAA2),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  'Delivered: ${DateFormat('dd.MM.yyyy').format(widget.snap['dateCompleted'].toDate())}',
                                  style: TextStyle(
                                    color: const Color(0xff123113),
                                    fontSize: isNarrowScreen ? 10 : 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),
                            Text(
                              '${widget.snap['orderQuantity']} items',
                              style: TextStyle(
                                fontSize: isNarrowScreen ? 14 : 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff123113),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  SizedBox(
                    height: isNarrowScreen ? 80 : 100,
                    width: isNarrowScreen ? 80 : 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: productUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(color: Theme.of(context).primaryColor),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/empty_cart.png', fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (isNarrowScreen) {
                                    setState(() {
                                      isTitleExpanded = !isTitleExpanded;
                                    });
                                  }
                                },
                                child: Text(
                                  isNarrowScreen && !isTitleExpanded
                                      ? truncateText(title, 12)
                                      : title,
                                  style: TextStyle(
                                    fontSize: isNarrowScreen ? 20 : 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                nextScreen(
                                  context,
                                  ChatScreen(
                                    snap: widget.snap,
                                    sellerPicURL: sellerPicURL,
                                    sellerName: userName,
                                    productName: title,
                                    productPrice: widget.snap['price'].toString(),
                                    productUrl: productUrl,
                                    sid: widget.snap['sid'],
                                  ),
                                );
                              },
                              icon: isNarrowScreen ? const Icon(
                                Icons.chat,
                                color: Colors.green,
                                size: 24,
                              ) : const Icon(
                                Icons.chat,
                                color: Colors.green,
                                size: 27,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "£${widget.snap['price'].toString()}",
                          style: TextStyle(
                            fontSize: isNarrowScreen ? 14 : 16,
                            color: const Color(0xff123113),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () async {
                            if (widget.snap['isSellerCompleted'] == false) {
                              showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Order Sent?"),
                                    content: const Text("Are you sure this order is sent?"),
                                    actions: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(Icons.cancel, color: Colors.red),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                                              .sellerOrderCompleted(widget.snap['oid']);
                                          if (widget.snap['isUserCompleted'] == true) {
                                            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                                                .orderCompleted(widget.snap['oid']);
                                          }
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(Icons.done, color: Colors.green),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text(
                            widget.snap['isSellerCompleted'] == false
                                ? "✔️✔️ Mark as sent"
                                : "✔️✔️ Marked as sent",
                            style: TextStyle(
                              color: widget.snap['isSellerCompleted'] == false ? Colors.black : const Color(0xffA2CAA2),
                              fontWeight: FontWeight.w500,
                              fontSize: isNarrowScreen ? 12 : 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        );
      },
    );
  }
}
