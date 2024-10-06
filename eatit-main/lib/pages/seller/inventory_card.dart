import 'package:eatit/pages/seller/edit_product.dart';
import 'package:eatit/pages/seller_info.dart';
import 'package:eatit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:eatit/services/database_service.dart';
import 'package:eatit/helper/helper_function.dart';

class InventoryCard extends StatefulWidget {
  final snap;
  const InventoryCard({super.key, required this.snap});

  @override
  State<InventoryCard> createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  String sellerPicURL = "";
  String etsyBadgeURL = "";
  int reviewLen = 0;
  double averageRating = 0.0;
  double userRating = 0.0;
  bool _isSignedIn = false;

  @override
  void initState() {
    getSellerData();
    getReviews();
    getAverageRating();
    getUserLoggedInStatus();
    super.initState();
  }

  getSellerData() async {
    final picDocumentSnapshot = await FirebaseFirestore.instance.collection('users').doc(widget.snap['uid']).get();
    setState(() {
      sellerPicURL = picDocumentSnapshot['profilePic'];
      etsyBadgeURL = picDocumentSnapshot['etsyBadge'];
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

  void getAverageRating() async {
    final ratingSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.snap['pid'])
        .collection('ratings')
        .get();

    double totalRating = 0.0;
    for (var doc in ratingSnapshot.docs) {
      totalRating += doc['rating'];
    }

    setState(() {
      if (ratingSnapshot.docs.length == 0) {
        averageRating = 0.0;
      } else {
        averageRating = totalRating / ratingSnapshot.docs.length;
      }
      var userRatingDoc = ratingSnapshot.docs.firstWhere((doc) => doc.id == FirebaseAuth.instance.currentUser?.uid,);
      userRating = userRatingDoc != null ? userRatingDoc['rating'] : 0.0;
    });
  }

  void handleRatingUpdate(double rating) async {
    if (rating == userRating) {
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).removeRating(widget.snap['pid']);
      setState(() {
        userRating = 0.0;
      });
    } else {
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).rateProduct(widget.snap['pid'], rating);
      setState(() {
        userRating = rating;
      });
    }
    getAverageRating();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // IMAGE SECTION WITH RATING OVERLAY
          Stack(
            children: [
              SizedBox(
                height: 312,
                width: 308,
                child: Image.network(
                  widget.snap['productUrl'],
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            averageRating.toStringAsFixed(1),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),
                          ),
                          const SizedBox(width: 4),
                          if (_isSignedIn)
                            RatingBar.builder(
                              itemSize: 15,
                              initialRating: userRating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.black,
                              ),
                              onRatingUpdate: handleRatingUpdate,
                            )
                          else
                            Text('Sign in to rate this product'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10,),

          // CAPTION AND COMMENTS
          Container(
            padding: const EdgeInsets.only(left: 80,),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                    const SizedBox(width: 20,),
                    GestureDetector(
                      child: Text(
                        widget.snap['userName'],
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xff123113)),
                      ),
                      onTap: () {
                        nextScreen(context, SellerInfoPage(sid: widget.snap['sid']));
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      widget.snap['title'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 10,),
                    if (widget.snap['isDiscounted'])
                      Padding(
                        padding: const EdgeInsets.only(left: 180,),
                        child: Row(
                          children: [
                            Text(
                              "£${widget.snap['price'].toString()}",
                              style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Text(
                              "£${widget.snap['discountedPerice'].toString()}",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                          ],
                        ),
                      )
                    else
                      Text(
                        "£${widget.snap['price'].toString()}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                  ],
                ),
                const SizedBox(height: 5,),
                Text(
                  "Cities: ${widget.snap['cities']}",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 5,),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20,),
                  width: 276,
                  //height: 48,
                  child: ElevatedButton(onPressed: (){
                    nextScreen(context, EditProductPage(title: widget.snap['title'], productType: widget.snap['productType'], description: widget.snap['description'], cities: widget.snap['cities'], price: widget.snap['price'], discountedPerice: widget.snap['discountedPerice'], isDiscounted: widget.snap['isDiscounted'], postPreview: widget.snap['productUrl'], amount: widget.snap['quantity'], pid: widget.snap['pid'], sid: widget.snap['sid'],));
                  },
                   style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XffA2CAA2),
                    ),
                    child: const Text('Manage', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),),),
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
