import 'package:eatit_dev/pages/cart_page.dart';
import 'package:eatit_dev/pages/seller_info.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatit_dev/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartCard extends StatefulWidget {
  final snap;
  final Function(int) onQuantityChanged;

  const CartCard({super.key, required this.snap, required this.onQuantityChanged});

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  String sellerPicURL = "";
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
  bool isDiscounted = false;
  double discountedPrice = 0.0;
  int reviewLen = 0;
  int Orderquantity = 1;

  @override
  void initState() {
    getProductData();
    getListValues();
    getReviews();
    super.initState();
  }

  getProductData() async {
    final productDocumentSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.snap['pid'])
        .get();
    final buyerDocumentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();
    final userQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('sid', isEqualTo: widget.snap['sid'])
        .get();
    final userDocumentSnapshot = userQuerySnapshot.docs[0];
    setState(() {
      userName = productDocumentSnapshot['userName'];
      productUrl = productDocumentSnapshot['productUrl'];
      title = productDocumentSnapshot['title'];
      isDiscounted = productDocumentSnapshot['isDiscounted'];
      discountedPrice = productDocumentSnapshot['discountedPerice'];
      productType = productDocumentSnapshot['productType'];
      description = productDocumentSnapshot['description'];
      isAvailable = productDocumentSnapshot['isAvailable'];
      sellerPicURL = userDocumentSnapshot['profilePic'];
      etsyBadgeURL = userDocumentSnapshot['etsyBadge'];
      buyer = buyerDocumentSnapshot['userName'];
      sellerUID = userDocumentSnapshot['uid'];
    });
  }

  getListValues() async {
    final productDocumentSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.snap['pid'])
        .get();
    setState(() {
      likes = productDocumentSnapshot['likes'];
      dislikes = productDocumentSnapshot['dislikes'];
      cart = productDocumentSnapshot['cart'];
    });
  }

  void getReviews() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.snap['pid'])
          .collection('reviews')
          .get();
      reviewLen = snap.docs.length;
    } catch (e) {
      showSnackbar(context, Colors.red, e.toString());
    }
    setState(() {});
  }

  void _updateQuantity(int newQuantity) {
    setState(() {
      Orderquantity = newQuantity;
      widget.onQuantityChanged(newQuantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isNarrow = MediaQuery.of(context).size.width < 600;

    return Card(
      margin: isNarrow
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
          : const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16).copyWith(right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: sellerPicURL,
                          height: 20,
                          width: 20,
                          placeholder: (context, url) => CircularProgressIndicator(color: Theme.of(context).primaryColor),
                          errorWidget: (context, url, error) => const Icon(Icons.account_circle, size: 100, color: Colors.grey),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: etsyBadgeURL,
                            height: 20,
                            width: 20,
                            placeholder: (context, url) => CircularProgressIndicator(color: Theme.of(context).primaryColor),
                            errorWidget: (context, url, error) => const Icon(Icons.account_circle, size: 100, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    nextScreen(context, SellerInfoPage(sid: widget.snap['sid']));
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: Text(
                            userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xff123113),
                            ),
                          ),
                          onTap: () {
                            nextScreen(context, SellerInfoPage(sid: widget.snap['sid']));
                          },
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    '$Orderquantity item',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              SizedBox(
                height: 160,
                width: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: productUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/empty_cart.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isNarrow?
                        Flexible(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            softWrap: true,
                          ),
                        ):
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: isNarrow? isDiscounted? Row(
                              children: [
                                Text(
                                  "£${widget.snap['price'].toString()}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff6A7769),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "£${discountedPrice.toString()}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ],
                            ):
                            Text(
                                  "£${widget.snap['price'].toString()}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ):
                          isDiscounted? Row(
                              children: [
                                Text(
                                  "£${widget.snap['price'].toString()}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff6A7769),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "£${discountedPrice.toString()}",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ],
                            ):
                            Text(
                                  "£${widget.snap['price'].toString()}",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    isNarrow
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: isNarrow? 100: 150,
                                  height: isNarrow? 40: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove,
                                          size: 16,
                                        ),
                                        onPressed: Orderquantity > 1
                                            ? () => _updateQuantity(Orderquantity - 1)
                                            : null,
                                      ),
                                      Text(
                                        '$Orderquantity',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          size: 16,
                                        ),
                                        onPressed: () => _updateQuantity(Orderquantity + 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: TextButton.icon(
                                  onPressed: () async {
                                    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                                        .addCart(widget.snap['pid'], widget.snap['cart']);
                                    nextScreenReplace(context, const CartPage());
                                  },
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    color: Color(0xffE42D36),
                                    size: 16,
                                  ),
                                  label: const Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Color(0xffE42D36),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: Container(
                                  width: 204,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove,
                                          size: 16,
                                        ),
                                        onPressed: Orderquantity > 1
                                            ? () => _updateQuantity(Orderquantity - 1)
                                            : null,
                                      ),
                                      Text(
                                        '$Orderquantity',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          size: 16,
                                        ),
                                        onPressed: () => _updateQuantity(Orderquantity + 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 10, top: 80),
                                child: TextButton.icon(
                                  onPressed: () async {
                                    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                                        .addCart(widget.snap['pid'], widget.snap['cart']);
                                    nextScreenReplace(context, const CartPage());
                                  },
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    color: Color(0xffE42D36),
                                    size: 16,
                                  ),
                                  label: const Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Color(0xffE42D36),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
