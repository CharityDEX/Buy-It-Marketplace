import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatit_dev/pages/faq.dart';
import 'package:flutter/material.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatit_dev/services/database_service.dart';
import 'package:eatit_dev/services/auth_service.dart';
import 'package:eatit_dev/pages/profile_page.dart';
import 'package:eatit_dev/pages/cart_page.dart';
import 'package:eatit_dev/pages/home_page.dart';
import 'package:eatit_dev/pages/search_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SellerSettings extends StatefulWidget {
  const SellerSettings({super.key});

  @override
  State<SellerSettings> createState() => _SellerSettingsState();
}

class _SellerSettingsState extends State<SellerSettings> {
  String sid = "";
  String sellerName = "";
  String sellerAddress = "";
  String sellerMobileNo = "";
  String bio = "";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    getSellerData();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    mobileNoController.dispose();
    bioController.dispose();
    super.dispose();
  }

  getSellerData() async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    sid = documentSnapshot['sid'];
    final sellerDocumentSnapshot = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(sid)
        .get();
    setState(() {
      sellerName = sellerDocumentSnapshot['userName'];
      sellerAddress = sellerDocumentSnapshot['sellerAddress'];
      sellerMobileNo = sellerDocumentSnapshot['sellerMobileNo'];
      bio = sellerDocumentSnapshot['bio'];

      nameController.text = sellerName;
      addressController.text = sellerAddress;
      mobileNoController.text = sellerMobileNo;
      bioController.text = bio;
    });
  }

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
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
                          if (constraints.maxWidth > 600)
                            GestureDetector(
                              onTap: () {
                                nextScreen(context, const SearchPage());
                              },
                              child: Container(
                                width: 220,
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: const Color(0xffF8F8F8),
                                  border: Border.all(
                                      color: const Color(0xffF8F8F8)),
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
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 16.0),
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 30),
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
                              child: const Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Color(0xff123113),
                                size: 28,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20, right: 70),
                            child: Text(
                              "Edit shop",
                              style: TextStyle(
                                color: Colors.black, // Adjust your color
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth < 600 ? 20 : 90,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Full name",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff6A7769)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: constraints.maxWidth < 600 ? 300 : 632,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    sellerName = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth < 600 ? 20 : 90,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Phone number",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff6A7769)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: constraints.maxWidth < 600 ? 300 : 632,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextFormField(
                                controller: mobileNoController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    sellerMobileNo = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth < 600 ? 20 : 90,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Shop description",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff6A7769)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: constraints.maxWidth < 600 ? 300 : 632,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextFormField(
                                controller: bioController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    bio = val;
                                  });
                                },
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth < 600 ? 20 : 90,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Address",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff6A7769)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: constraints.maxWidth < 600 ? 300 : 632,
                              height: 109,
                              decoration: BoxDecoration(
                                color: Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextFormField(
                                controller: addressController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    sellerAddress = val;
                                  });
                                },
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              updateSeller();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0XffA2CAA2),
                            ),
                            child: const Text(
                              'Save changes',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff123113)),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade100,
                            ),
                            onPressed: () {
                              _checkAndTerminateShop();
                            },
                            child: const Text(
                              'Terminate Shop',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffE42D36)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      if (constraints.maxWidth > 600)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 750,
                          ),
                          child: Container(
                              width: 500,
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "By pressing the following button you will be about to permanently delete your shop $sellerName",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xffE42D36)),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    "This will erase all shop data from our service, such as completed and active orders, payments info and ratings. The action cannot be undone",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffE42D36),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Container(
                    color: Color(0xFF123113),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: constraints.maxWidth < 600
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
          );
        },
      ),
    );
  }

  updateSeller() async {
    try {
      if (sellerAddress != "" &&
          sellerName != "" &&
          sellerMobileNo != "" &&
          bio != "") {
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .updateSellerData(sid, sellerName, sellerAddress, sellerMobileNo,
                bio);
        showSnackbar(context, Colors.green,
            "Your Profile has been updated successfully");
        nextScreenReplace(context, const ProfilePage());
      } else {
        showSnackbar(context, Colors.red, "Please fill the fields properly");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _checkAndTerminateShop() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: sid)
        .where('isAvailable', isEqualTo: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      showSnackbar(context, Colors.red,
          "You can't delete your store with active products.");
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Terminate Shop?"),
              content: const Text(
                  "Your shop would be terminated within the next 30 days, pending review."),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.cancel, color: Colors.red),
                ),
                IconButton(
                  onPressed: () async {
                    await DatabaseService(
                            uid: FirebaseAuth.instance.currentUser!.uid)
                        .deleteSeller(sid);
                    showSnackbar(context, Colors.green,
                        "Shop termination review initiated successfully");
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.done, color: Colors.green),
                ),
              ],
            );
          });
    }
  }
}
