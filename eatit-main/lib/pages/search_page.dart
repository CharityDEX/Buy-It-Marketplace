import 'package:eatit/pages/faq.dart';
import 'package:eatit/pages/home_page.dart';
import 'package:eatit/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eatit/pages/product_card.dart';
import 'package:eatit/pages/auth/signin_page.dart';
import 'package:eatit/pages/cart_page.dart';
import 'package:eatit/pages/profile_page.dart';
import 'package:eatit/widgets/widgets.dart';
import 'package:eatit/helper/helper_function.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum SortOptions { Latest, LowToHigh, HighToLow }

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  TextEditingController appBarSearchController = TextEditingController();
  bool isLoading = false;
  bool _isSignedIn = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String _selectedProductType = "Physical Goods";
  SortOptions selectedSortOption = SortOptions.Latest;
  bool _ethyApproved = false;

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
          child: Container(
            color: const Color(0xffFFFFFF),
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
                      Container(
                        width: 210,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color(0xffF8F8F8),
                          border: Border.all(color: const Color(0xffF8F8F8)),
                        ),
                        child: TextField(
                          controller: appBarSearchController,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "e.g. Mesh shopping bag",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          onSubmitted: (value) {
                            initiateSearchMethod(appBarSearchController.text);
                          },
                        ),
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
                              Icons.shopping_bag_outlined,
                              color: Color(0xff171717),
                              size: 27,
                            ),
                            onPressed: () {
                              _isSignedIn
                                  ? nextScreen(context, const CartPage())
                                  : showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          title: Text("Sign In"),
                                          content: Text("Please sign in to add items to your cart"),
                                        );
                                      });
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
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasUserSearched)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      appBarSearchController.text,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      '${searchSnapshot?.docs.length ?? 0}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffBEBEBE),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          shape: const CircleBorder(),
                          value: _ethyApproved,
                          activeColor: const Color(0xff123113),
                          onChanged: (bool? value) {
                            setState(() {
                              _ethyApproved = value ?? false;
                              initiateSearchMethod(appBarSearchController.text);
                            });
                          },
                        ),
                      ),
                      const Text(
                        "Ethy approved",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Satoshi',
                          color: Color(0xff6A7769),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30,),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedSortOption = SortOptions.Latest;
                        initiateSearchMethod(appBarSearchController.text);
                      });
                    },
                    child:const Text("Recency", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Satoshi', color: Color(0xff6A7769)),),
                  ),
                  const SizedBox(width: 20,),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedSortOption = SortOptions.LowToHigh;
                        initiateSearchMethod(appBarSearchController.text);
                      });
                    },
                    child:const Text("Price", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Satoshi', color: Color(0xff6A7769))),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30,),
                    child: Container(
                      width: 220,
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text(
                              'Physical Goods',
                              style: TextStyle(
                                fontSize: _selectedProductType == 'Physical Goods' ? 18 : 16,
                                fontWeight: _selectedProductType == 'Physical Goods'
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedProductType = 'Physical Goods';
                                initiateSearchMethod(appBarSearchController.text);
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Local Services',
                              style: TextStyle(
                                fontSize: _selectedProductType == 'Local Services' ? 18 : 16,
                                fontWeight: _selectedProductType == 'Local Services'
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedProductType = 'Local Services';
                                initiateSearchMethod(appBarSearchController.text);
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Ticketed Events',
                              style: TextStyle(
                                fontSize: _selectedProductType == 'Ticketed Events' ? 18 : 16,
                                fontWeight: _selectedProductType == 'Ticketed Events'
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedProductType = 'Ticketed Events';
                                initiateSearchMethod(appBarSearchController.text);
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Fashion',
                              style: TextStyle(
                                fontSize: _selectedProductType == 'Fashion' ? 18 : 16,
                                fontWeight: _selectedProductType == 'Fashion'
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedProductType = 'Fashion';
                                initiateSearchMethod(appBarSearchController.text);
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Accessories',
                              style: TextStyle(
                                fontSize: _selectedProductType == 'Accessories' ? 18 : 16,
                                fontWeight: _selectedProductType == 'Accessories'
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedProductType = 'Accessories';
                                initiateSearchMethod(appBarSearchController.text);
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Beauty',
                              style: TextStyle(
                                fontSize: _selectedProductType == 'Beauty' ? 18 : 16,
                                fontWeight: _selectedProductType == 'Beauty'
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedProductType = 'Beauty';
                                initiateSearchMethod(appBarSearchController.text);
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Home',
                              style: TextStyle(
                                fontSize: _selectedProductType == 'Home' ? 18 : 16,
                                fontWeight: _selectedProductType == 'Home'
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedProductType = 'Home';
                                initiateSearchMethod(appBarSearchController.text);
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Crafts',
                              style: TextStyle(
                                fontSize: _selectedProductType == 'Crafts' ? 18 : 16,
                                fontWeight: _selectedProductType == 'Crafts'
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedProductType = 'Crafts';
                                initiateSearchMethod(appBarSearchController.text);
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Lifestyle',
                              style: TextStyle(
                                fontSize: _selectedProductType == 'Lifestyle' ? 18 : 16,
                                fontWeight: _selectedProductType == 'Lifestyle'
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedProductType = 'Lifestyle';
                                initiateSearchMethod(appBarSearchController.text);
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Wellness',
                              style: TextStyle(
                                fontSize: _selectedProductType == 'Wellness' ? 18 : 16,
                                fontWeight: _selectedProductType == 'Wellness'
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedProductType = 'Wellness';
                                initiateSearchMethod(appBarSearchController.text);
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Gifts',
                              style: TextStyle(
                                fontSize: _selectedProductType == 'Gifts' ? 18 : 16,
                                fontWeight: _selectedProductType == 'Gifts'
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedProductType = 'Gifts';
                                initiateSearchMethod(appBarSearchController.text);
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Other',
                              style: TextStyle(
                                fontSize: _selectedProductType == 'Other' ? 18 : 16,
                                fontWeight: _selectedProductType == 'Other'
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedProductType = 'Other';
                                initiateSearchMethod(appBarSearchController.text);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                          height: 570,
                          child: VerticalDivider(
                            color: Color(0xff6A7769),
                            thickness: 1
                          ),
                        ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isLoading
                                ? Center(
                                    child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                                  )
                                : productList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
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
                                'info@eatit.com',
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
                              Icon(Icons.facebook, color: Colors.white),
                              const SizedBox(width: 16),
                              Icon(Icons.tiktok, color: Colors.white),
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
    );
  }

  initiateSearchMethod(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .searchByTitle(query, _selectedProductType, selectedSortOption, _ethyApproved)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  Widget productList() {
    if (hasUserSearched &&
        (searchSnapshot == null || searchSnapshot!.docs.isEmpty)) {
      return Stack(
        children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset("assets/empty_cart.png", height: 175),
                const SizedBox(height: 20),
                Text(
                  "No results.",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sorry but no items match your search",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 50),
              ],
            ),
        ],
      );
    }

    return hasUserSearched
        ? SizedBox(
            height: 550,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: searchSnapshot!.docs.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                child: SizedBox(
                  width: 350,
                  child: ProductCard(
                      snap: searchSnapshot!.docs[index].data() as Map<String, dynamic>),
                ),
              ),
            ),
          )
        : Container();
  }

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

}
