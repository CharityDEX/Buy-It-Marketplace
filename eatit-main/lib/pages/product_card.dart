import 'package:eatit/pages/auth/signin_page.dart';
import 'package:eatit/pages/report_page.dart';
import 'package:eatit/pages/seller_info.dart';
import 'package:eatit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatit/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatit/helper/helper_function.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductCard extends StatefulWidget {
  final snap;
  const ProductCard({super.key, required this.snap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isSignedIn = false;
  String sellerPicURL = "";
  String etsyBadgeURL = "";
  int reviewLen = 0;
  double averageRating = 0.0;
  double userRating = 0.0;

  @override
  void initState() {
    getUserLoggedInStatus();
    getSellerData();
    getReviews();
    getAverageRating();
    super.initState();
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

  getSellerData() async {
    final picDocumentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();
    setState(() {
      sellerPicURL = picDocumentSnapshot['profilePic'];
      etsyBadgeURL = picDocumentSnapshot['etsyBadge'];
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _isSignedIn
                        ? IconButton(
                            onPressed: FirebaseAuth.instance.currentUser!.uid == widget.snap['uid']
                                ? () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Remove Listing"),
                                            content: const Text("Are you sure you want to remove this product listing?"),
                                            actions: [
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                icon: const Icon(Icons.cancel, color: Colors.red),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).removeProduct(widget.snap['pid']);
                                                  Navigator.of(context).pop();
                                                },
                                                icon: const Icon(Icons.done, color: Colors.green),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                : null,
                            icon: FirebaseAuth.instance.currentUser!.uid == widget.snap['uid']
                                ? const Icon(Icons.delete_outline, color: Colors.black)
                                : Container(),
                          )
                        : Container(),
                    IconButton(
                      onPressed: () {
                        _isSignedIn
                            ? nextScreen(
                                context,
                                ReportPage(
                                  title: widget.snap['title'],
                                  description: widget.snap['description'],
                                  sellerPicURL: sellerPicURL,
                                  etsyBadgeURL: etsyBadgeURL,
                                  pid: widget.snap['pid'],
                                  sid: widget.snap['sid'],
                                  price: widget.snap['price'],
                                  userName: widget.snap['userName'],
                                  productUrl: widget.snap['productUrl'],
                                ))
                            : showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    title: Text("Sign In"),
                                    content: Text("Please sign in to report this product"),
                                  );
                                });
                      },
                      icon: const Icon(Icons.report_gmailerrorred_rounded, color: Colors.black),
                    ),
                  ],
                ),
              ),

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

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
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
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(color: Theme.of(context).primaryColor),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.account_circle, size: 100, color: Colors.grey),
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
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(color: Theme.of(context).primaryColor),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.account_circle, size: 100, color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: GestureDetector(
                          child: Text(
                            widget.snap['userName'],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            nextScreen(context, SellerInfoPage(sid: widget.snap['sid']));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // CAPTION AND COMMENTS
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(widget.snap['title']),
                                  );
                                },
                              );
                            },
                            child: Text(
                              widget.snap['title'],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (widget.snap['isDiscounted'])
                          Padding(
                            padding: const EdgeInsets.only(left: 150),
                            child: Row(
                              children: [
                                Text(
                                  "£${widget.snap['price'].toString()}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff6A7769),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "£${widget.snap['discountedPerice'].toString()}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          )
                        else
                          Text(
                            "£${widget.snap['price'].toString()}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                      ],
                    ),
                    Text(
                      "Delivering to: ${widget.snap['cities']}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.snap['description'],
                      style: const TextStyle(
                        fontSize: 15,
                        //softWrap: true,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    _isSignedIn?
                    Container(
                      padding: const EdgeInsets.only(left: 20, bottom: 10,),
                      width: 276,
                      //height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).addCart(widget.snap['pid'], widget.snap['cart']);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XffA2CAA2),
                        ),
                        child: widget.snap['cart'].contains(FirebaseAuth.instance.currentUser!.uid)
                            ? const Text('Remove from Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),)
                            : const Text('Add to Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),),
                      ),
                    ):
                    Container(
                      padding: const EdgeInsets.only(left: 20, bottom: 10,),
                      width: 276,
                      //height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          nextScreen(context, const AuthPage());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XffA2CAA2),
                        ),
                        child: const Text('Add to Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),),
                      ),
                    )
                    ,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
