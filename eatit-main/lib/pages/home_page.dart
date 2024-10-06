import 'package:eatit/pages/auth/signin_page.dart';
import 'package:eatit/pages/cart_page.dart';
import 'package:eatit/pages/faq.dart';
import 'package:eatit/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:eatit/services/auth_service.dart';
import 'package:eatit/pages/profile_page.dart';
import 'package:eatit/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatit/pages/product_card.dart';
import 'package:eatit/helper/helper_function.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSignedIn = false;
  AuthService authService = AuthService();
  String _selectedProductType = 'Crafts';

  final List<Map<String, String>> _productTypes = [
    {'name': 'Fashion', 'icon': 'assets/empty_cart.png'},
    {'name': 'Accessories', 'icon': 'assets/empty_cart.png'},
    {'name': 'Beauty', 'icon': 'assets/empty_cart.png'},
    {'name': 'Home', 'icon': 'assets/empty_cart.png'},
    {'name': 'Crafts', 'icon': 'assets/empty_cart.png'},
    {'name': 'Lifestyle', 'icon': 'assets/empty_cart.png'},
    {'name': 'Wellness', 'icon': 'assets/empty_cart.png'},
    {'name': 'Gifts', 'icon': 'assets/empty_cart.png'},
    {'name': 'Physical Goods', 'icon': 'assets/empty_cart.png'},
    {'name': 'Local services', 'icon': 'assets/empty_cart.png'},
    {'name': 'Ticketed Events', 'icon': 'assets/empty_cart.png'},
    {'name': 'Other', 'icon': 'assets/empty_cart.png'},
  ];

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
  preferredSize: const Size.fromHeight(kToolbarHeight),
  child: SafeArea(
    child: LayoutBuilder(
      builder: (context, constraints) {
        // Determine if the screen is narrow or wide
        bool isNarrow = constraints.maxWidth < 600;

        return Container(
          color: const Color(0xffFFFFFF),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Buy It",
                      style: TextStyle(
                        color: Color(0xff415141),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Satoshi',
                      ),
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
                            _isSignedIn
                                ? nextScreen(context, const ProfilePage())
                                : nextScreen(context, const AuthPage());
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
                            Icons.shopping_cart_outlined,
                            color: Color(0xff171717),
                            size: 27,
                          ),
                        // icon: ImageIcon(
                        //   AssetImage('cart_icon.png'),
                        //   color: Color(0xff171717),
                        //   size: 27,
                        // ),
                        onPressed: () {
                          _isSignedIn
                              ? nextScreen(context, const CartPage())
                              : nextScreen(context,const AuthPage());
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: _productTypes.map((type) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedProductType = type['name']!;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: _selectedProductType == type['name'] ? Color(0XffA2CAA2) : Color(0xffECF4EC),
                              radius: 35,
                              child: Image.asset(
                                type['icon']!,
                                height: 30,
                                width: 30,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              type['name']!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                  const SizedBox(height: 20,),
                  const Text(
                    'Top Products',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where('isAvailable', isEqualTo: true)
                        .where('productType', isEqualTo: _selectedProductType)
                        .snapshots(),
                    builder: (
                      context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "This category is not filled yet. But it will be full of items very soon! Want to help? Invite your local business to sell in this category!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }
                      return SizedBox(
                        height: 550,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                            child: SizedBox(
                              width: 350,
                              child: ProductCard(snap: snapshot.data!.docs[index].data()),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20,),
                  const Text(
                    'Up to 50% off!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where('isAvailable', isEqualTo: true)
                        .where('productType', isEqualTo: _selectedProductType)
                        .snapshots(),
                    builder: (
                      context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return SizedBox(
                        height: 550,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final product = snapshot.data!.docs[index].data();
                            if (product['discount'] == null || product['discount'] < 50) {
                              return Container();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                              child: SizedBox(
                                width: 350,
                                child: ProductCard(snap: product),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20,),
                  const Text(
                    'Verified by Ethy',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where('isAvailable', isEqualTo: true)
                        .where('productType', isEqualTo: _selectedProductType)
                        .where('ethyStatus', isEqualTo: true)
                        .snapshots(),
                    builder: (
                      context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return SizedBox(
                        height: 550,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                            child: SizedBox(
                              width: 350,
                              child: ProductCard(snap: snapshot.data!.docs[index].data()),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20,),               
                ],
              ),
            ),
            Container(
                    color: Color(0xFF123113),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: screenWidth < 600
                        ? Column(
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Legal',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    child: Text(
                                    'Terms and Conditions',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: (){
                                    _launchURL('https://drive.google.com/file/d/1gDXeK8jjwCJC90zlF7fqJdeTLqV7rV79/view?usp=sharing');
                                  },
                                  ),
                                  GestureDetector(
                                    child: Text(
                                    'Privacy Policy for Buyers',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: (){
                                    _launchURL('https://drive.google.com/file/d/1c0kYpZKRQUWeTPR-BIS2ohwDPprCR4rE/view?usp=sharing');
                                  },
                                  ),
                                  GestureDetector(
                                    child: Text(
                                    'Privacy Policy for Sellers',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: (){
                                    _launchURL('https://drive.google.com/file/d/10KOMOR9AX4ZvaztgzkBNL9NubQrlTmuC/view?usp=sharing');
                                  },
                                  ),
                                  GestureDetector(
                                    child: Text(
                                    'Refund Policy',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: (){
                                    _launchURL('https://drive.google.com/file/d/1-DSyh0laZCgeyTdti3-3Sgbclg4e3XHO/view?usp=sharing');
                                  },
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Contact us directly',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'support@buyit.market',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Help',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    child: Text(
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
                                    child: Text(
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
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  //Icon(Icons.linkedin, color: Colors.white),
                                  const SizedBox(width: 16),
                                  GestureDetector(child: FaIcon(FontAwesomeIcons.instagram, color: Colors.white,),
                                  onTap: () {
                                   _launchURL('https://www.instagram.com/buy_it_market_place?igsh=cHZ1dnFsOXF2OWJ4');
                                  },
                                  ), 
                                  const SizedBox(width: 16),
                                  GestureDetector(child: FaIcon(FontAwesomeIcons.youtube, color: Colors.white,),
                                  onTap: () {
                                   _launchURL('https://www.youtube.com/@BuyItMarketplace');
                                  },
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(child: FaIcon(FontAwesomeIcons.linkedin, color: Colors.white,),
                                  onTap: () {
                                   _launchURL('https://www.linkedin.com/company/buy-it-co');
                                  },
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
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
                                  Text(
                                    'Legal',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    child: Text(
                                    'Terms and Conditions',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: (){
                                    _launchURL('https://drive.google.com/file/d/1gDXeK8jjwCJC90zlF7fqJdeTLqV7rV79/view?usp=sharing');
                                  },
                                  ),
                                  GestureDetector(
                                    child: Text(
                                    'Privacy Policy for Buyers',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: (){
                                    _launchURL('https://drive.google.com/file/d/1c0kYpZKRQUWeTPR-BIS2ohwDPprCR4rE/view?usp=sharing');
                                  },
                                  ),
                                  GestureDetector(
                                    child: Text(
                                    'Privacy Policy for Sellers',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: (){
                                    _launchURL('https://drive.google.com/file/d/10KOMOR9AX4ZvaztgzkBNL9NubQrlTmuC/view?usp=sharing');
                                  },
                                  ),
                                  GestureDetector(
                                    child: Text(
                                    'Refund Policy',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: (){
                                    _launchURL('https://drive.google.com/file/d/1-DSyh0laZCgeyTdti3-3Sgbclg4e3XHO/view?usp=sharing');
                                  },
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Contact us directly',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
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
                                  Text(
                                    'Help',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    child: Text(
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
                                    child: Text(
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
                                  //Icon(Icons.linkedin, color: Colors.white),
                                  const SizedBox(width: 16),
                                  GestureDetector(child: FaIcon(FontAwesomeIcons.instagram, color: Colors.white,),
                                  onTap: () {
                                   _launchURL('https://www.instagram.com/buy_it_market_place?igsh=cHZ1dnFsOXF2OWJ4');
                                  },
                                  ), 
                                  const SizedBox(width: 16),
                                  GestureDetector(child: FaIcon(FontAwesomeIcons.youtube, color: Colors.white,),
                                  onTap: () {
                                   _launchURL('https://www.youtube.com/@BuyItMarketplace');
                                  },
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(child: FaIcon(FontAwesomeIcons.linkedin, color: Colors.white,),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

}
