import 'package:eatit_dev/pages/faq.dart';
import 'package:eatit_dev/pages/product_card.dart';
import 'package:eatit_dev/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatit_dev/pages/cart_page.dart';
import 'package:eatit_dev/pages/home_page.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'search_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SellerInfoPage extends StatefulWidget {
  final String sid;
  const SellerInfoPage({super.key, required this.sid});

  @override
  State<SellerInfoPage> createState() => _SellerInfoPageState();
}

class _SellerInfoPageState extends State<SellerInfoPage> {

  late String sellerPicURL = "";
  String userName = "";
  String email = "";
  String bio = "";
  List<dynamic> interests = [];
  String dateSellerCreated = "";
  List<String> ethyBadgeUrls = [];

  @override
  void initState() {
    getSellerData();
    super.initState();
  }

  getSellerData() async {
    final sellerDocumentSnapshot = await FirebaseFirestore.instance.collection('sellers').doc(widget.sid).get();
    final userDocumentSnapshot = await FirebaseFirestore.instance.collection('users').doc(sellerDocumentSnapshot['uid']).get();
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('ethy')
        .where('uid', isEqualTo: sellerDocumentSnapshot['uid'])
        .get();
    final dateCreated = sellerDocumentSnapshot['dateSellerCreated'] as Timestamp;
    setState(() {
      dateSellerCreated = DateFormat.yMMMd().format(dateCreated.toDate());
      userName = sellerDocumentSnapshot['userName'];
      email = sellerDocumentSnapshot['email'];
      bio = sellerDocumentSnapshot['bio'];
      sellerPicURL = userDocumentSnapshot['profilePic'];
      interests = userDocumentSnapshot['interests'];
      ethyBadgeUrls = snapshot.docs.map((doc) => doc['badgeURL'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.person,
                                  color: Color(0xff171717),
                                  size: 27,
                                ),
                                onPressed: () {
                                  nextScreen(context, const ProfilePage());
                                },
                              ),
                              if (!isNarrow)
                                const Text(
                                  "Profile",
                                  style: TextStyle(
                                    color: Color(0xff171717),
                                    fontSize: 11,
                                  ),
                                ),
                            ],
                          ),
                          isNarrow ? const SizedBox(width: 8) : const SizedBox(width: 16),
                          Column(
                            mainAxisSize: MainAxisSize.min,
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
                              if (!isNarrow)
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
          return Padding(
            padding: EdgeInsets.only(top: 50, left: isNarrow ? 16 : 50, right: isNarrow ? 16 : 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: sellerPicURL,
                              height: 56,
                              width: 56,
                              placeholder: (context, url) => CircularProgressIndicator(color: Theme.of(context).primaryColor),
                              errorWidget: (context, url, error) => const Icon(Icons.account_circle, size: 100, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 5,),
                                Text(bio, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                const SizedBox(height: 10,),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: interests.map((interest) => Chip(
                                    label: Text(interest, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff415141)),),
                                    backgroundColor: const Color(0xffECF4EC),
                                  )).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isNarrow) ...[
                      Padding(
                        padding: const EdgeInsets.only(right: 200,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Ethy badges", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                            const SizedBox(height: 10,),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: ethyBadgeUrls.map((url) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: url,
                                        height: 40,
                                        width: 40,
                                        placeholder: (context, url) => CircularProgressIndicator(color: Theme.of(context).primaryColor),
                                        errorWidget: (context, url, error) => const Icon(Icons.badge_outlined, size: 30, color: Colors.grey),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 50,),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where('sid', isEqualTo: widget.sid)
                        .where('isAvailable', isEqualTo: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset("assets/empty_cart.png", height: 175),
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
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                          child: SizedBox(
                            width: isNarrow ? 300 : 350,
                            child: ProductCard(snap: snapshot.data!.docs[index].data()),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20,),
                if (!isNarrow) // Only show footer on wide screens
                  Container(
                    color: const Color(0xFF123113),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Buy It',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Make your everyday shopping more ethical, cheaper, and simple.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Legal',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              child: const Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                _launchURL('https://drive.google.com/file/d/1gDXeK8jjwCJC90zlF7fqJdeTLqV7rV79/view?usp=sharing');
                              },
                            ),
                            GestureDetector(
                              child: const Text(
                                'Privacy Policy for Buyers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                _launchURL('https://drive.google.com/file/d/1c0kYpZKRQUWeTPR-BIS2ohwDPprCR4rE/view?usp=sharing');
                              },
                            ),
                            GestureDetector(
                              child: const Text(
                                'Privacy Policy for Sellers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                _launchURL('https://drive.google.com/file/d/1c0kYpZKRQUWeTPR-BIS2ohwDPprCR4rE/view?usp=sharing');
                              },
                            ),
                            GestureDetector(
                              child: const Text(
                                'Refund Policy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                _launchURL('https://drive.google.com/file/d/1-DSyh0laZCgeyTdti3-3Sgbclg4e3XHO/view?usp=sharing');
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Contact us directly',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'support@buyit.market',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Help',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              child: const Text(
                                'F.A.Q.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                nextScreen(context, const faqPage());
                              },
                            ),
                            GestureDetector(
                              child: const Text(
                                'More about Ethy.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                _launchURL('https://ethy.co.uk/');
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            GestureDetector(
                              child: const FaIcon(FontAwesomeIcons.instagram, color: Colors.white,),
                              onTap: () {
                                _launchURL('https://www.instagram.com/buy_it_market_place?igsh=cHZ1dnFsOXF2OWJ4');
                              },
                            ), 
                            const SizedBox(width: 16),
                            GestureDetector(
                              child: const FaIcon(FontAwesomeIcons.youtube, color: Colors.white,),
                              onTap: () {
                                _launchURL('https://www.youtube.com/@BuyItMarketplace');
                              },
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              child: const FaIcon(FontAwesomeIcons.linkedin, color: Colors.white,),
                              onTap: () {
                                _launchURL('https://www.linkedin.com/company/buy-it-co');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

}
