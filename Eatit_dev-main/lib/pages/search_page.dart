import 'package:flutter/material.dart';
import 'package:eatit_dev/pages/faq.dart';
import 'package:eatit_dev/pages/home_page.dart';
import 'package:eatit_dev/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatit_dev/pages/product_card.dart';
import 'package:eatit_dev/pages/auth/signin_page.dart';
import 'package:eatit_dev/pages/cart_page.dart';
import 'package:eatit_dev/pages/profile_page.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:eatit_dev/helper/helper_function.dart';
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Container(
            color: const Color(0xffFFFFFF),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 600;
                  final textSize = isNarrow ? 18.0 : 24.0;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            child: Text(
                              "Buy It",
                              style: TextStyle(
                                color: const Color(0xff415141),
                                fontSize: textSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: () {
                              nextScreen(context, const HomePage());
                            },
                          ),
                          const SizedBox(width: 8.0),
                          Container(
                            width: isNarrow ? 150 : 210,
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
                                  Icons.person,
                                  color: Color(0xff171717),
                                  size: 27,
                                ),
                                onPressed: () {
                                  _isSignedIn
                                      ? nextScreen(context, const ProfilePage())
                                      : nextScreen(context, const AuthPage());
                                },
                              ),
                              if (!isNarrow) // Show text only on wide screens
                                const Text(
                                  "Profile",
                                  style: TextStyle(
                                    color: Color(0xff171717),
                                    fontSize: 11,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 8.0),
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
                              if (!isNarrow) // Show text only on wide screens
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;
          final textSize = isNarrow ? 12.0 : 16.0;
          return Padding(
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
                          style: TextStyle(
                            fontSize: isNarrow ? 20 : 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${searchSnapshot?.docs.length ?? 0}',
                          style: TextStyle(
                            fontSize: isNarrow ? 20 : 32,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xffBEBEBE),
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
                          Text(
                            "Ethy approved",
                            style: TextStyle(
                              fontSize: textSize,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Satoshi',
                              color: const Color(0xff6A7769),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedSortOption = SortOptions.Latest;
                            initiateSearchMethod(appBarSearchController.text);
                          });
                        },
                        child: Text(
                          "Recency",
                          style: TextStyle(
                            fontSize: textSize,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Satoshi',
                            color: const Color(0xff6A7769),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedSortOption = SortOptions.LowToHigh;
                            initiateSearchMethod(appBarSearchController.text);
                          });
                        },
                        child: Text(
                          "Price",
                          style: TextStyle(
                            fontSize: textSize,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Satoshi',
                            color: const Color(0xff6A7769),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isNarrow)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButton<String>(
                      value: _selectedProductType,
                      items: [
                        'Physical Goods',
                        'Local Services',
                        'Ticketed Events',
                        'Fashion',
                        'Accessories',
                        'Beauty',
                        'Home',
                        'Crafts',
                        'Lifestyle',
                        'Wellness',
                        'Gifts',
                        'Other',
                      ].map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(fontSize: textSize),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedProductType = newValue!;
                          initiateSearchMethod(appBarSearchController.text);
                        });
                      },
                    ),
                  ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isNarrow) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Container(
                            width: 220,
                            child: ListView(
                              children: buildProductTypeListTiles(textSize),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 570,
                          child: VerticalDivider(
                            color: Color(0xff6A7769),
                            thickness: 1,
                          ),
                        ),
                      ],
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                if (!isNarrow) // Show footer only on wide screens
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: footerSection(isNarrow, textSize),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> buildProductTypeListTiles(double textSize) {
    List<String> productTypes = [
      'Physical Goods',
      'Local Services',
      'Ticketed Events',
      'Fashion',
      'Accessories',
      'Beauty',
      'Home',
      'Crafts',
      'Lifestyle',
      'Wellness',
      'Gifts',
      'Other',
    ];

    return productTypes.map((type) {
      return ListTile(
        title: Text(
          type,
          style: TextStyle(
            fontSize: _selectedProductType == type ? textSize + 2 : textSize,
            fontWeight: _selectedProductType == type
                ? FontWeight.bold
                : FontWeight.w500,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedProductType = type;
            initiateSearchMethod(appBarSearchController.text);
          });
        },
      );
    }).toList();
  }

  Widget footerSection(bool isNarrow, double textSize) {
    return Container(
      color: const Color(0xFF123113),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildFooterContent(textSize),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: buildFooterContent(textSize),
            ),
    );
  }

  List<Widget> buildFooterContent(double textSize) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Buy It',
            style: TextStyle(
              color: Colors.white,
              fontSize: textSize + 6,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Make your everyday shopping more ethical, cheaper, and simple.',
            style: TextStyle(
              color: Colors.white,
              fontSize: textSize,
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
              fontSize: textSize + 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          buildFooterLink('Terms and Conditions', 'https://drive.google.com/file/d/1gDXeK8jjwCJC90zlF7fqJdeTLqV7rV79/view?usp=sharing', textSize),
          buildFooterLink('Privacy Policy for Buyers', 'https://drive.google.com/file/d/1c0kYpZKRQUWeTPR-BIS2ohwDPprCR4rE/view?usp=sharing', textSize),
          buildFooterLink('Privacy Policy for Sellers', 'https://drive.google.com/file/d/10KOMOR9AX4ZvaztgzkBNL9NubQrlTmuC/view?usp=sharing', textSize),
          buildFooterLink('Refund Policy', 'https://drive.google.com/file/d/1-DSyh0laZCgeyTdti3-3Sgbclg4e3XHO/view?usp=sharing', textSize),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact us directly',
            style: TextStyle(
              color: Colors.white,
              fontSize: textSize + 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'info@eatit.com',
            style: TextStyle(
              color: Colors.white,
              fontSize: textSize,
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
              fontSize: textSize + 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            child: Text(
              'F.A.Q.',
              style: TextStyle(
                color: Colors.white,
                fontSize: textSize,
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
                fontSize: textSize,
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
          GestureDetector(
            child: FaIcon(FontAwesomeIcons.instagram, color: Colors.white,),
            onTap: () {
             _launchURL('https://www.instagram.com/buy_it_market_place?igsh=cHZ1dnFsOXF2OWJ4');
            },
          ), 
          const SizedBox(width: 16),
          GestureDetector(
            child: FaIcon(FontAwesomeIcons.youtube, color: Colors.white,),
            onTap: () {
             _launchURL('https://www.youtube.com/@BuyItMarketplace');
            },
          ),
          const SizedBox(width: 16),
          GestureDetector(
            child: FaIcon(FontAwesomeIcons.linkedin, color: Colors.white,),
            onTap: () {
             _launchURL('https://www.linkedin.com/company/buy-it-co');
            },
          ),
        ],
      ),
    ];
  }

  Widget buildFooterLink(String text, String url, double textSize) {
    return GestureDetector(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: textSize,
        ),
      ),
      onTap: () {
        _launchURL(url);
      },
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
